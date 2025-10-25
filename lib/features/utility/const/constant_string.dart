import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/custom_extension.dart';

import 'environment.dart';
import 'locale_keys.g.dart';

class ConstantString {
  static var backendUrl = Environment.backendUrl;

  // Localization
  // ignore: constant_identifier_names
  static const SUPPORTED_LOCALE = [
    ConstantString.TR_LOCALE,
    ConstantString.EN_LOCALE,
    ConstantString.AR_LOCALE,
  ];
  static const TR_LOCALE = Locale("tr", "TR");
  static const EN_LOCALE = Locale('en', 'EN');
  static const AR_LOCALE = Locale('ar', 'AR');
  static const LANG_PATH = "assets/lang";
  static const turkish = "Türkçe";
  static const english = "English";
  static const arabic = "عربي";
  static const loadingGif = "assets/gif/loading.gif";
  static const posGif = "assets/gif/pos_gif.json";
  static const healthGif = "assets/gif/health_gif.json";
  static const configLoading = "assets/gif/config_loading.json";
  static const settingsGif = "assets/gif/settings_gif.json";
  static const hospitalLogo = "assets/images/pratikLogo.png";
  static const buharaLogo = "assets/images/buharaLogo.png";
  static const configSetting = "assets/gif/config_setting.json";
  static const paymentLoading = "assets/gif/payment_loading.json";

  String birthDate = LocaleKeys.birthDate.locale;
  String signIn = LocaleKeys.signIn.locale;
  String patientLogin = LocaleKeys.patientLogin.locale;
  String hospitalLogin = LocaleKeys.hospitalLogin.locale;
  String appointments = LocaleKeys.appointments.locale;
  String logout = LocaleKeys.logout.locale;
  String homePageTitle = LocaleKeys.homePageTitle.locale;
  String selectBranch = LocaleKeys.selectBranch.locale;
  String branches = LocaleKeys.branches.locale;
  String selectDoctor = LocaleKeys.selectDoctor.locale;
  String errorOccurred = LocaleKeys.errorOccurred.locale;
  String noAppointments = LocaleKeys.noAppointments.locale;
  String internetConnectionError = LocaleKeys.internetConnectionError.locale;
  String checkInternetConnection = LocaleKeys.checkInternetConnection.locale;
  String associationGssInfoMessage = LocaleKeys.associationGssInfoMessage.locale;
  String fieldRequired = LocaleKeys.fieldRequired.locale;
  String minLengthError = LocaleKeys.minLengthError.locale;
  String priceInformation = LocaleKeys.priceInformation.locale;
  String sectionSelection = LocaleKeys.sectionSelection.locale;
  String section = LocaleKeys.section.locale;
  String doctorSelection = LocaleKeys.doctorSelection.locale;
  String doctor = LocaleKeys.doctor.locale;
  String patientTransaction = LocaleKeys.patientTransaction.locale;
  String mandatoryFields = LocaleKeys.mandatoryFields.locale;
  String payment = LocaleKeys.payment.locale;
  String paymentAction = LocaleKeys.paymentAction.locale;
  String total = LocaleKeys.total.locale;
  String insurance = "Sigorta";
  String loginWithTrIdNo = "T.C KİMLİK NO İLE GİRİŞ";
  String enterYourTurkishIdNumber = "TC Kimlik Numaranızı Giriniz";
  String clear = "Temizle";
  String patientRegistration = "Hasta Kaydı";
  String testQueue = "Tetkik Sırası";
  String results = "Sonuçlar";
  String appointmentRegistration = "Randevuna Kayıt Aç";
  String registration = "Kayıt Aç";
  String tests = "Tetkikler";
  String completeRegistration = "Kaydı Tamamla";
  String patientInformation = "Hasta Bilgileri";
  String summaryAndInvoice = "Özet ve Fatura";
  String totalAmount = "TOPLAM TUTAR";
  String creditCardPayment = "Kredi Kartı ile Ödeme";
  String securePaymentMessage = "Güvenli ödeme için kredi kartı kullanınız.";
  String description = "Açıklama";
  String amount = "Tutar";
  String paymentSuccess = "Ödeme Başarılı";
  String paymentFailure = "Ödeme Başarısız";
  String appointmentConfirmed = "Randevunuz onaylanmıştır";
  String paymentPending = "Ödeme Bekleniyor";
  String paymentProcessing = "Lütfen POS cihazında ödeme işlemini gerçekleştiriniz";
  String hour = "Saat";
  String policlinic = "Polikinlik";
  String close = "Kapat";
  String select = "Seç";
  String timeExpired = "Süre doldu. Lütfen tekrar deneyin.";
  String settingsApplying = "Ayarlar Uygulanıyor...";
  String paymentAmount = "Ödenecek Tutar:";
  String registrationFailed = "Kayıt İşlemi Başarısız Oldu";
  String bankReferral = "Lütfen bankoya müracaat edin";
}
