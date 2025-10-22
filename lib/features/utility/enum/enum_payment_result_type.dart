import '../const/constant_string.dart';

enum EnumPaymentResultType {
  success,
  failure;

  String get title {
    switch (this) {
      case EnumPaymentResultType.success:
        return ConstantString().paymentSuccess;
      case EnumPaymentResultType.failure:
        return ConstantString().paymentFailure;
    }
  }
}
