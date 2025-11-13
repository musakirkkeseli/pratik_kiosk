import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_color.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';
import 'package:kiosk/features/utility/extension/text_theme_extension.dart';

class CustomInputContainer extends StatelessWidget {
  final EnumTextformfield type;
  final Widget child;
  final String? customLabel;
  final bool isValid;
  final String? errorMessage;
  final String currentValue; // Mevcut değer (karakter sayısı için)
  final VoidCallback? onClear; // Temizle butonu callback
  final bool obscureText; // Gizli metin (şifre gibi)
  final VoidCallback? onToggleVisibility; // Görünürlük toggle callback

  const CustomInputContainer({
    super.key,
    required this.type,
    required this.child,
    this.customLabel,
    this.isValid = true,
    this.errorMessage,
    this.currentValue = '',
    this.onClear,
    this.obscureText = false,
    this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Text(
            customLabel ?? type.label,
            style: context.inputLabelText,
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: ConstColor.grey200,
            borderRadius: BorderRadius.circular(20.0),
            border: !isValid
                ? Border.all(color: ConstColor.red, width: 2.0)
                : null,
          ),
          child: Stack(
            children: [
              Center(child: child),
              if (currentValue.isEmpty && type.hint.isNotEmpty)
                Center(
                  child: Text(
                    type.hint,
                    style: context.inputHintText,
                  ),
                ),
              // Göz ikonu (eğer onToggleVisibility callback'i varsa)
              if (onToggleVisibility != null && currentValue.isNotEmpty)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Material(
                      color: ConstColor.transparent,
                      child: InkWell(
                        onTap: onToggleVisibility,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ConstColor.grey600,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // Karakter sayısı (sadece göz ikonu yoksa göster)
              if (type.maxLength != null && 
                  currentValue.isNotEmpty && 
                  onToggleVisibility == null)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      '${currentValue.length}/${type.maxLength}',
                      style: context.inputCounterText.copyWith(
                        color: currentValue.length > (type.maxLength ?? 0)
                            ? ConstColor.red
                            : ConstColor.grey600,
                      ),
                    ),
                  ),
                ),
              // Temizle butonu (eğer onClear callback'i varsa ve değer boş değilse)
              if (onClear != null && currentValue.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Material(
                      color: ConstColor.transparent,
                      child: InkWell(
                        onTap: onClear,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ConstColor.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: ConstColor.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Hata mesajı alanı - her zaman aynı yükseklikte (görünür veya görünmez)
        SizedBox(
          height: 30, // Sabit yükseklik
          child: (!isValid && errorMessage != null)
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8),
                  child: Text(
                    errorMessage!,
                    style: context.inputErrorText,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
