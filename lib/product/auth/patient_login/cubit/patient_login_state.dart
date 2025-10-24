part of 'patient_login_cubit.dart';

enum AuthType { register, login }

enum PageType { auth, verifySms }

class PatientLoginState {
  final String? message;
  final AuthType authType;
  final PageType pageType;
  final EnumGeneralStateStatus status;
  final int counter;
  final String phoneNumber;
  final String otpCode;
  final String tcNo;
  final String birthDate;

  const PatientLoginState({
    this.counter = 0,
    this.message,
    this.authType = AuthType.login,
    this.pageType = PageType.auth,
    this.status = EnumGeneralStateStatus.initial,
    this.phoneNumber = "",
    this.otpCode = "",
    this.tcNo = "",
    this.birthDate = "",
  });

  PatientLoginState copyWith({
    String? message,
    AuthType? authType,
    PageType? pageType,
    EnumGeneralStateStatus? status,
    int? counter,
    String? phoneNumber,
    String? otpCode,
    String? tcNo,
    String? birthDate,
  }) {
    return PatientLoginState(
      message: message ?? this.message,
      authType: authType ?? this.authType,
      pageType: pageType ?? this.pageType,
      status: status ?? this.status,
      counter: counter ?? this.counter,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      tcNo: tcNo ?? this.tcNo,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
