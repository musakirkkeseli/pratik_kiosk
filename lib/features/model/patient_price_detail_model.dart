class PatientTransactionDetailsResponseModel {
  List<PaymentContent>? paymentContent;
  PatientContent? patientContent;

  PatientTransactionDetailsResponseModel({this.paymentContent, this.patientContent});

  PatientTransactionDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['paymentContent'] != null) {
      paymentContent = <PaymentContent>[];
      json['paymentContent'].forEach((v) {
        paymentContent!.add(PaymentContent.fromJson(v));
      });
    }
    patientContent = json['patientContent'] != null
        ? PatientContent.fromJson(json['patientContent'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (paymentContent != null) {
      data['paymentContent'] = paymentContent!.map((v) => v.toJson()).toList();
    }
    if (patientContent != null) {
      data['patientContent'] = patientContent!.toJson();
    }
    return data;
  }
}

class PaymentContent {
  String? paymentName;
  int? price;
  int? tax;
  bool? isContributionFee;

  PaymentContent({
    this.paymentName,
    this.price,
    this.tax,
    this.isContributionFee,
  });

  PaymentContent.fromJson(Map<String, dynamic> json) {
    paymentName = json['paymentName'];
    price = json['price'];
    tax = json['tax'];
    isContributionFee = json['isContributionFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentName'] = paymentName;
    data['price'] = price;
    data['tax'] = tax;
    data['isContributionFee'] = isContributionFee;
    return data;
  }
}

class PatientContent {
  String? patientProcessId;
  String? patientId;
  String? totalPrice;

  PatientContent({this.patientProcessId, this.patientId, this.totalPrice});

  PatientContent.fromJson(Map<String, dynamic> json) {
    patientProcessId = json['patientProcessId'];
    patientId = json['patientId'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientProcessId'] = patientProcessId;
    data['patientId'] = patientId;
    data['totalPrice'] = totalPrice;
    return data;
  }
}
