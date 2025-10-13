import 'package:flutter/material.dart';

import '../../../product/ patient_registration_procedures/model/patient_registration_procedures_request_model.dart';
import '../../../product/doctor/view/doctors_view.dart';
import '../../../product/patient_transaction/view/patient_transaction_view.dart';
import '../../../product/payment_screen/view/payment_view.dart';
import '../../../product/section/view/section_view.dart';

enum EnumPatientRegistrationProcedures {
  section,
  doctor,
  patientTransaction,
  payment,
}

extension EnumPatientRegistrationProceduresExtension
    on EnumPatientRegistrationProcedures {
  String get label {
    switch (this) {
      case EnumPatientRegistrationProcedures.section:
        return 'Bölüm Seçimi';
      case EnumPatientRegistrationProcedures.doctor:
        return 'Doktor Seçimi';
      case EnumPatientRegistrationProcedures.patientTransaction:
        return 'Hasta İşlemleri';
      case EnumPatientRegistrationProcedures.payment:
        return 'Ödeme';
    }
  }
}

extension EnumNavigationWidgetExtension on EnumPatientRegistrationProcedures {
  Widget widget(PatientRegistrationProceduresRequestModel model) {
    switch (this) {
      case EnumPatientRegistrationProcedures.section:
        return SectionSearchView();
      case EnumPatientRegistrationProcedures.doctor:
        return DoctorSearchView(sectionId: model.branchId ?? 0);
      case EnumPatientRegistrationProcedures.patientTransaction:
        return PatientTransactionView();
      case EnumPatientRegistrationProcedures.payment:
        return PaymentView();
    }
  }
}
