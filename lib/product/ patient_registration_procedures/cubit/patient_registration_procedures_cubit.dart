import 'package:kiosk/features/utility/enum/enum_general_state_status.dart';

import '../../../core/utility/base_cubit.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../doctor/model/doctor_model.dart';
import '../../patient_transaction/model/Patient_transaction_request_model.dart';
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

  void selectAssociation(AssociationsModel section) {
    if (section.associationId != null && section.associationName != null) {
      final updatedModel = state.model;
      updatedModel.associationId = section.associationId;
      updatedModel.associationName = section.associationName;
      emit(state.copyWith(model: updatedModel));
      createNewPatientTransaction();
    }
  }

  void createNewPatientTransaction() {
    emit(state.copyWith(status: EnumGeneralStateStatus.loading));
    Future.delayed(const Duration(seconds: 5), () {
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
        model.associationId = null;
        model.associationName = null;
        emit(state.copyWith(model: model));
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
