import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum EnumTextformfield { hospitalUserName, hospitalUserPassword, tc, birthday }

extension EnumTextformfieldExtension on EnumTextformfield {
  String get label {
    switch (this) {
      case EnumTextformfield.hospitalUserName:
        return 'Kullanıcı Adı';
      case EnumTextformfield.hospitalUserPassword:
        return 'Şifre';
      case EnumTextformfield.tc:
        return 'T.C. Kimlik No';
      case EnumTextformfield.birthday:
        return 'Doğum Tarihi';
    }
  }

  String get hint {
    switch (this) {
      case EnumTextformfield.hospitalUserName:
        return '';
      case EnumTextformfield.hospitalUserPassword:
        return '••••••••';
      case EnumTextformfield.tc:
        return '11 haneli TC bilgisi';
      case EnumTextformfield.birthday:
        return 'gg.aa.yyyy';
    }
  }

  TextInputType get keyboardType {
    switch (this) {
      case EnumTextformfield.hospitalUserName:
        return TextInputType.text;
      case EnumTextformfield.hospitalUserPassword:
        return TextInputType.visiblePassword;
      case EnumTextformfield.tc:
        return TextInputType.number;
      case EnumTextformfield.birthday:
        return TextInputType.number;
    }
  }

  bool get obscureText {
    switch (this) {
      case EnumTextformfield.hospitalUserPassword:
        return true;
      default:
        return false;
    }
  }

  int? get maxLength {
    switch (this) {
      case EnumTextformfield.tc:
        return 11;
      case EnumTextformfield.birthday:
        return 12; // gg.aa.yyyy
      default:
        return null;
    }
  }

  List<TextInputFormatter> get inputFormatters {
    switch (this) {
      case EnumTextformfield.hospitalUserName:
        return [
          FilteringTextInputFormatter.allow(
            RegExp(r"[a-zA-Z0-9ğüşöçıİĞÜŞÖÇ._\- ]"),
          ),
          LengthLimitingTextInputFormatter(50),
        ];
      case EnumTextformfield.hospitalUserPassword:
        return [LengthLimitingTextInputFormatter(64)];
      case EnumTextformfield.tc:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ];
      case EnumTextformfield.birthday:
        return [
          FilteringTextInputFormatter.digitsOnly,
          DateDottedFormatter(),
          LengthLimitingTextInputFormatter(10),
        ];
    }
  }

  FormFieldValidator<String> get validator {
    switch (this) {
      case EnumTextformfield.hospitalUserName:
        return (v) {
          final value = v?.trim() ?? '';
          if (value.isEmpty) return 'Kullanıcı adı zorunludur';
          if (value.length < 3) return 'En az 3 karakter girin';
          return null;
        };
      case EnumTextformfield.hospitalUserPassword:
        return (v) {
          final value = v ?? '';
          if (value.isEmpty) return 'Şifre zorunludur';
          if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
          return null;
        };
      case EnumTextformfield.tc:
        return (v) {
          final raw = (v ?? '').replaceAll(RegExp(r'\D'), '');
          if (raw.isEmpty) return 'T.C. Kimlik No zorunludur';
          if (raw.length != 11) return '11 haneli olmalıdır';
          if (!_isValidTCKN(raw)) return 'Geçersiz T.C. Kimlik No';
          return null;
        };
      case EnumTextformfield.birthday:
        return (v) {
          final value = (v ?? '').trim();
          if (value.isEmpty) return 'Doğum tarihi zorunludur';
          if (!_isValidDate(value)) {
            return 'gg.aa.yyyy biçiminde geçerli bir tarih girin';
          }
          return null;
        };
    }
  }

  bool _isValidTCKN(String t) {
    if (!RegExp(r'^\d{11}$').hasMatch(t)) return false;
    if (t[0] == '0') return false;
    if (RegExp(r'^(\d)\1{10}$').hasMatch(t)) return false;

    final d = t.split('').map(int.parse).toList();
    final sumOdd = d[0] + d[2] + d[4] + d[6] + d[8];
    final sumEven = d[1] + d[3] + d[5] + d[7];

    final d10 = ((sumOdd * 7) - sumEven) % 10;
    final d11 = (d.take(10).reduce((a, b) => a + b)) % 10;

    return d[9] == d10 && d[10] == d11;
  }

  bool _isValidDate(String s) {
    // Beklenen: gg.aa.yyyy
    final parts = s.split('.');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return false;

    // Mantıklı aralıklar
    if (year < 1900) return false;
    if (month < 1 || month > 12) return false;

    // Geçerli tarih mi?
    final dt = DateTime(year, month, day);
    if (dt.year != year || dt.month != month || dt.day != day) return false;

    // Gelecek tarih olmasın
    final now = DateTime.now();
    if (dt.isAfter(DateTime(now.year, now.month, now.day))) return false;

    return true;
  }
}

class DateDottedFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 8) digits = digits.substring(0, 8);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if (i == 1 && digits.length > 2) formatted += '.';
      if (i == 3 && digits.length > 4) formatted += '.';
    }

    // İmleci sonuna koy
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
