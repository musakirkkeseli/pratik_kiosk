part of 'patient_login_cubit.dart';

enum PageType { auth,register, verifySms }

class PatientLoginState {
  final String? message;
  final PageType pageType;
  final EnumGeneralStateStatus status;
  final int? counter;
  final String phoneNumber;
  final String otpCode;
  final String tcNo;
  final String birthDate;
  final String? encryptedUserData;

  const PatientLoginState({
    this.counter,
    this.message,
    this.pageType = PageType.auth,
    this.status = EnumGeneralStateStatus.initial,
    this.phoneNumber = "",
    this.otpCode = "",
    this.tcNo = "41467192600",
    this.birthDate = "",
    this.encryptedUserData,
  });

  PatientLoginState copyWith({
    String? message,
    PageType? pageType,
    EnumGeneralStateStatus? status,
    int? counter,
    String? phoneNumber,
    String? otpCode,
    String? tcNo,
    String? birthDate,
    String? encryptedUserData,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      pageType: pageType ?? this.pageType,
      status: status ?? this.status,
      counter: counter ?? this.counter,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      tcNo: tcNo ?? this.tcNo,
      birthDate: birthDate ?? this.birthDate,
      encryptedUserData: encryptedUserData ?? this.encryptedUserData,
    );
  }
}
