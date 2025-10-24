import 'package:flutter/material.dart';

import '../../../../features/utility/const/constant_color.dart';
import '../../../../features/utility/const/constant_string.dart';
import '../../../../features/utility/enum/enum_payment_result_type.dart';
import '../../../../features/utility/extension/text_theme_extension.dart';
import '../../../../features/utility/extension/color_extension.dart';

class PaymentResultWidget extends StatelessWidget {
  final EnumPaymentResultType paymentResultType;
  const PaymentResultWidget({super.key, required this.paymentResultType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
            vertical: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: paymentResultType == EnumPaymentResultType.success
                    ? Colors.green
                    : Colors.red,
                size: 100,
              ),
              Text(paymentResultType.title, style: context.sectionTitle),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text("Ödeme işleminiz başarıyla tamamlandı.", style: context.bodyPrimary),
              Text(ConstantString().appointmentConfirmed, style: context.bodyPrimary),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: ConstColor.textfieldColor),
                  color: ConstColor.infoCardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _PaymentInfoRow(
                      label: "Ödenen Tutar",
                      value: "1.420 TL",
                      valueColor: context.primaryColor,
                      valueSize: 32,
                      valueBold: true,
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: "Ödeme Yöntemi",
                      value: "Kredi Kartı",
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: "İşlem Tarihi",
                      value: "21 Ekim 2025 13:14",
                    ),
                    Divider(color: ConstColor.textfieldColor),
                    _PaymentInfoRow(
                      label: "İşlem No",
                      value: "TRX-2023-845621",
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Randevu Detayları",
                        style: context.sectionTitle.copyWith(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bölüm",
                                style: context.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Beyin ve Sinir Cerrahisi",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Tarih",
                                style: context.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "25 Ekim 2023",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Doktor",
                                style: context.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Dr. Adil Yılmaz",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Saat",
                                style: context.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "14:30",
                                style: context.cardTitle.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final double? valueSize;
  final bool valueBold;

  const _PaymentInfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueSize,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodySecondary,
          ),
          Text(
            value,
            style: context.bodyPrimary.copyWith(
              fontSize: valueSize ?? 16,
              fontWeight: valueBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
