class PatientTransactionDetailsResponseModel {
  List<PaymentContent>? paymentContent;
  PatientContent? patientContent;
  PosContent? posContent;

  PatientTransactionDetailsResponseModel({
    this.paymentContent,
    this.patientContent,
    this.posContent,
  });

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
    if (posContent != null) {
      data['posContent'] = posContent!.toJson();
    }
    return data;
  }
}

class PaymentContent {
  String? paymentName;
  String? price;
  String? tax;
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

class PosContent {
  String? patientTransactionId;
  String? dataId;
  String? orderNo;
  String? statusId;
  String? saleNumber;
  String? inquiryLink;
  double? amount;

  PosContent({
    this.patientTransactionId,
    this.dataId,
    this.orderNo,
    this.statusId,
    this.saleNumber,
    this.inquiryLink,
    this.amount,
  });

  PosContent.fromJson(Map<String, dynamic> json) {
    patientTransactionId = json['patientTransactionId'];
    dataId = json['dataId'];
    orderNo = json['orderNo'];
    statusId = json['statusId'];
    saleNumber = json['saleNumber'];
    inquiryLink = json['inquiryLink'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientTransactionId'] = patientTransactionId;
    data['dataId'] = dataId;
    data['orderNo'] = orderNo;
    data['statusId'] = statusId;
    data['saleNumber'] = saleNumber;
    data['inquiryLink'] = inquiryLink;
    data['amount'] = amount;
    return data;
  }
}
