import 'package:kiosk/core/utility/logger_service.dart';

import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../doctor/model/doctor_model.dart';
import '../../mandatory/model/patient_mandatory_model.dart';
import '../../patient_transaction/model/association_model.dart';
import '../../patient_transaction/model/insurance_model.dart';
import '../../section/model/section_model.dart';
import '../model/patient_registration_procedures_request_model.dart';

part 'patient_registration_procedures_state.dart';

class PatientRegistrationProceduresCubit
    extends BaseCubit<PatientRegistrationProceduresState> {
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresRequestModel? model;

  PatientRegistrationProceduresCubit({
    required this.startStep,
    required this.model,
  }) : super(
         PatientRegistrationProceduresState(
           currentStep: startStep,
           model: model ?? PatientRegistrationProceduresRequestModel(),
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
    for (var element in mandatoryModelList) {
      _log.d('mandatoryCheck - ${element.targetFieldName} : ${element.value}');
    }
    createNewPatientTransaction();
  }

  void createNewPatientTransaction() {
    emit(state.copyWith(status: EnumGeneralStateStatus.loading));
    Future.delayed(const Duration(seconds: 2), () {
      emit(state.copyWith(status: EnumGeneralStateStatus.success));
      nextStep();
    });
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
