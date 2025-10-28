import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/enum/enum_textformfield.dart';

class CustomInputContainer extends StatelessWidget {
  final EnumTextformfield type;
  final Widget child;
  final String? customLabel;
  final bool isValid;
  final String? errorMessage;
  final String currentValue; // Mevcut değer (karakter sayısı için)
  final VoidCallback? onClear; // Temizle butonu callback

  const CustomInputContainer({
    super.key,
    required this.type,
    required this.child,
    this.customLabel,
    this.isValid = true,
    this.errorMessage,
    this.currentValue = '',
    this.onClear,
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20.0),
            border: !isValid
                ? Border.all(color: Colors.red, width: 2.0)
                : null,
          ),
          child: Stack(
            children: [
              Center(child: child),
              if (currentValue.isEmpty && type.hint.isNotEmpty)
                Center(
                  child: Text(
                    type.hint,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (type.maxLength != null && (onClear == null || currentValue.isEmpty))
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      '${currentValue.length}/${type.maxLength}',
                      style: TextStyle(
                        color: currentValue.length > (type.maxLength ?? 0)
                            ? Colors.red
                            : Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onClear,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red,
                              width: 1.5,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.clear,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Temizle',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Hata mesajı göster
        if (!isValid && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 8),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
