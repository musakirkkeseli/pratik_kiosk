import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/enum/enum_payment_result_type.dart';
import '../../doctor/model/doctor_model.dart';
import '../../../features/model/patient_mandatory_model.dart';
import '../../patient_transaction/model/association_model.dart';
import '../../patient_transaction/model/insurance_model.dart';
import '../../section/model/section_model.dart';
import '../model/patient_registration_procedures_request_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../service/IPatientRegistrationProceduresService.dart';

part 'patient_registration_procedures_state.dart';

class PatientRegistrationProceduresCubit
    extends BaseCubit<PatientRegistrationProceduresState> {
  final IPatientRegistrationProceduresService service;
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresModel? model;

  PatientRegistrationProceduresCubit({
    required this.service,
    required this.startStep,
    required this.model,
  }) : super(
         PatientRegistrationProceduresState(
           currentStep: startStep,
           model: model ?? PatientRegistrationProceduresModel(),
         ),
       );

  final MyLog _log = MyLog('PatientRegistrationProceduresCubit');

  void selectSection(SectionItems section) {
    if (section.sectionId != null && section.sectionName != null) {
      final updatedModel = state.model;
      updatedModel.branchId = section.sectionId;
      updatedModel.branchName = section.sectionName;
      emit(state.copyWith(model: updatedModel));
      nextStep();
    }
  }

  void selectDoctor(DoctorItems section) {
    if (section.doctorId != null && section.doctorName != null) {
      final updatedModel = state.model;
      updatedModel.doctorId = section.doctorId;
      updatedModel.departmentId = section.departmentId;
      updatedModel.doctorName = section.doctorName;
      emit(state.copyWith(model: updatedModel));
      nextStep();
    }
  }

  void selectAssociation(AssocationModel section) {
    if (section.assocationId != null && section.assocationName != null) {
      final updatedModel = state.model;
      updatedModel.assocationId = section.assocationId ?? "";
      updatedModel.assocationName = section.assocationName;
      updatedModel.gssAssocationId = section.gssAssocationId ?? "";
      emit(state.copyWith(model: updatedModel));
      nextStep();
    }
  }

  void selectAssociationWithInsurance(
    AssocationModel section,
    InsuranceModel insurance,
  ) {
    if (section.assocationId != null && section.assocationName != null) {
      final updatedModel = state.model;
      updatedModel.assocationId = section.assocationId ?? "";
      updatedModel.assocationName = section.assocationName;
      updatedModel.gssAssocationId = section.gssAssocationId ?? "";
      emit(state.copyWith(model: updatedModel));
      nextStep();
    }
  }

  void mandatoryCheck(List<PatientMandatoryModel> mandatoryModelList) {
    patientTransactionCreate(mandatoryModelList);
  }

  Future<void> patientTransactionCreate(
    List<PatientMandatoryModel> mandatoryModelList,
  ) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    PatientRegistrationProceduresModel model = state.model;
    try {
      PatientTransactionCreateRequestModel request =
          PatientTransactionCreateRequestModel(
            associationId: int.tryParse(model.assocationId ?? ""),
            departmentId: model.departmentId,
            doctorId: model.doctorId,
            appointmentId: model.appointmentId,
            mandatoryFields: mandatoryModelList,
          );
      final res = await service.postPatientTransactionCreate(request);

      if (res.success &&
          res.data is PatientTransactionCreateResponseModel &&
          res.data!.patientId is String) {
        model.patientId = res.data!.patientId ?? "";
        fetchPatientPrice(model);
        // emit(
        //   state.copyWith(status: EnumGeneralStateStatus.success, model: model),
        // );
        // nextStep();
      } else {
        patientTransactionCancel();
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> fetchPatientPrice(
    PatientRegistrationProceduresModel model,
  ) async {
    try {
      final res = await service.postPatientTransactionDetails(model.patientId!);
      if (res.success && res.data is PatientTransactionDetailsResponseModel) {
        _log.d(res);
        List<PaymentContent>? paymentContentList = res.data!.paymentContent;
        PatientContent? patientContent = res.data!.patientContent;
        if (paymentContentList is List<PaymentContent> &&
            patientContent is PatientContent) {
          model.patientContent = patientContent;
          model.paymentContentList = paymentContentList;
          emit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              model: model,
            ),
          );
          nextStep();
        } else {
          patientTransactionCancel();
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: res.message,
            ),
          );
        }
      } else {
        patientTransactionCancel();
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  void paymentAction() {
    final updatedModel = state.model;
    PatientTransactionDetailsResponseModel patientPriceDetailModel =
        PatientTransactionDetailsResponseModel(
          patientContent: updatedModel.patientContent,
          paymentContent: updatedModel.paymentContentList,
        );
    updatedModel.patientPriceDetailModel = patientPriceDetailModel;
    emit(state.copyWith(model: updatedModel));
    nextStep();
  }

  Future<void> patientTransactionRevenue(
    PatientTransactionDetailsResponseModel patientPriceDetailModel,
  ) async {
    try {
      final res = await service.postPatientTransactionRevenue(
        patientPriceDetailModel,
      );
      
      // Total amount'u al
      final totalAmount = patientPriceDetailModel.patientContent?.totalPrice ?? "0";
      
      if (res.success) {
        _log.d("Ödeme Tamamlandı");
        safeEmit(
          state.copyWith(
            paymentResultType: EnumPaymentResultType.success,
            totalAmount: totalAmount,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            paymentResultType: EnumPaymentResultType.failure,
            totalAmount: totalAmount,
          ),
        );
      }
    } on NetworkException catch (e) {
      _log.d("NetworkException $e");
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.success,
          totalAmount: patientPriceDetailModel.patientContent?.totalPrice ?? "0",
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.success,
          totalAmount: patientPriceDetailModel.patientContent?.totalPrice ?? "0",
        ),
      );
    }
  }

  Future<void> patientTransactionCancel() async {
    PatientRegistrationProceduresModel model = state.model;
    String? patientId = model.patientId;
    if (patientId is String) {
      try {
        await service.postPatientTransactionCancel(patientId);
      } on NetworkException catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: e.message,
          ),
        );
      } catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: ConstantString().errorOccurred,
          ),
        );
      }
    }
  }

  void nextStep() {
    final currentStep = state.currentStep;
    if (currentStep.index <
        EnumPatientRegistrationProcedures.values.length - 1) {
      emit(
        state.copyWith(
          currentStep:
              EnumPatientRegistrationProcedures.values[currentStep.index + 1],
        ),
      );
    }
  }

  void previousStep() {
    final currentStep = state.currentStep;
    final model = state.model;

    switch (state.currentStep) {
      case EnumPatientRegistrationProcedures.section:
        break;
      case EnumPatientRegistrationProcedures.doctor:
        model.branchId = null;
        model.branchName = null;
        emit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.patientTransaction:
        model.doctorId = null;
        model.doctorName = null;
        emit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.payment:
        model.assocationId = null;
        model.assocationName = null;
        emit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.mandatory:
        model.assocationId = null;
        model.assocationName = null;
        emit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.price:
        break;
    }
    if (currentStep.index > 0) {
      emit(
        state.copyWith(
          currentStep:
              EnumPatientRegistrationProcedures.values[currentStep.index - 1],
        ),
      );
    }
  }
}
