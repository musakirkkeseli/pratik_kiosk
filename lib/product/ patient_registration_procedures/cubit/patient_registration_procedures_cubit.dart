import '../../../core/exception/network_exception.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../features/model/api_response_model.dart';
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
    PatientRegistrationProceduresModel model = state.model;
    try {
      // final res = await service.postPatientTransactionCreate(
      //   PatientTransactionCreateRequestModel(
      //     associationId: int.tryParse(model.assocationId ?? ""),
      //     departmentId: model.departmentId,
      //     doctorId: model.doctorId,
      //     mandatoryFields: mandatoryModelList,
      //   ),
      // );
      final res = ApiResponse<PatientTransactionCreateResponseModel>(
        success: true,
        data: PatientTransactionCreateResponseModel(patientId: "4352273"),
        message: "",
      );
      if (res.success &&
          res.data is PatientTransactionCreateResponseModel &&
          res.data!.patientId is String) {
        model.patientId = res.data!.patientId ?? "";
        emit(
          state.copyWith(status: EnumGeneralStateStatus.success, model: model),
        );
        nextStep();
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
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

  void paymentAction(
    List<PaymentContent> paymentContentList,
    PatientContent? patientContent,
  ) {
    PatientPriceDetailModel patientPriceDetailModel = PatientPriceDetailModel(
      patientContent: patientContent,
      paymentContent: paymentContentList,
    );
    final updatedModel = state.model;
    updatedModel.patientPriceDetailModel = patientPriceDetailModel;
    emit(state.copyWith(model: updatedModel));
    nextStep();
  }

  Future<void> patientTransactionRevenue(
    PatientPriceDetailModel patientPriceDetailModel,
  ) async {
    try {
      final res = await service.postPatientTransactionRevenue(
        patientPriceDetailModel,
      );
      if (res.success) {
        _log.d("Ödeme Tamamlandı");
        safeEmit(
          state.copyWith(paymentResultType: EnumPaymentResultType.success),
        );
      } else {
        patientTransactionCancel();
        safeEmit(
          state.copyWith(paymentResultType: EnumPaymentResultType.failure),
        );
      }
    } on NetworkException catch (e) {
      _log.d("NetworkException $e");
      patientTransactionCancel();
      safeEmit(
        state.copyWith(paymentResultType: EnumPaymentResultType.success),
      );
    } catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(paymentResultType: EnumPaymentResultType.success),
      );
    }
  }

  Future<void> patientTransactionCancel() async {
    PatientRegistrationProceduresModel model = state.model;
    String? patientId = model.patientId;
    if (patientId is String) {
      try {
        final res = await service.postPatientTransactionCancel(patientId);
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
