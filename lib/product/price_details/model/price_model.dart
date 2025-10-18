class PatientPriceModel {
  PatientTranscationList? patientTranscationList;
  PatientTranscationProcessList? patientTranscationProcessList;

  PatientPriceModel({
    this.patientTranscationList,
    this.patientTranscationProcessList,
  });

  PatientPriceModel.fromJson(Map<String, dynamic> json) {
    patientTranscationList = json['PatientTranscationList'] != null
        ? PatientTranscationList.fromJson(json['PatientTranscationList'])
        : null;
    patientTranscationProcessList =
        json['PatientTranscationProcessList'] != null
        ? PatientTranscationProcessList.fromJson(
            json['PatientTranscationProcessList'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (patientTranscationList != null) {
      data['PatientTranscationList'] = patientTranscationList!.toJson();
    }
    if (patientTranscationProcessList != null) {
      data['PatientTranscationProcessList'] = patientTranscationProcessList!
          .toJson();
    }
    return data;
  }
}

class PatientTranscationList {
  List<GetPatientTranscationDet>? getPatientTranscationDet;

  PatientTranscationList({this.getPatientTranscationDet});

  PatientTranscationList.fromJson(Map<String, dynamic> json) {
    if (json['GetPatientTranscationDet'] != null) {
      getPatientTranscationDet = <GetPatientTranscationDet>[];
      json['GetPatientTranscationDet'].forEach((v) {
        getPatientTranscationDet!.add(GetPatientTranscationDet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getPatientTranscationDet != null) {
      data['GetPatientTranscationDet'] = getPatientTranscationDet!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class GetPatientTranscationDet {
  String? patientId;
  String? associationId;
  String? associationName;
  String? patTotalPrice;
  String? patNetTotalPrice;
  String? priceTaxRate;
  String? patOverallTotalPrice;
  String? payedPrice;
  String? patDebtPice;
  String? wihtholdingTotal;

  GetPatientTranscationDet({
    this.patientId,
    this.associationId,
    this.associationName,
    this.patTotalPrice,
    this.patNetTotalPrice,
    this.priceTaxRate,
    this.patOverallTotalPrice,
    this.payedPrice,
    this.patDebtPice,
    this.wihtholdingTotal,
  });

  GetPatientTranscationDet.fromJson(Map<String, dynamic> json) {
    patientId = json['PatientId'];
    associationId = json['AssociationId'];
    associationName = json['AssociationName'];
    patTotalPrice = json['PatTotalPrice'];
    patNetTotalPrice = json['PatNetTotalPrice'];
    priceTaxRate = json['PriceTaxRate'];
    patOverallTotalPrice = json['PatOverallTotalPrice'];
    payedPrice = json['PayedPrice'];
    patDebtPice = json['PatDebtPice'];
    wihtholdingTotal = json['WihtholdingTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientId'] = patientId;
    data['AssociationId'] = associationId;
    data['AssociationName'] = associationName;
    data['PatTotalPrice'] = patTotalPrice;
    data['PatNetTotalPrice'] = patNetTotalPrice;
    data['PriceTaxRate'] = priceTaxRate;
    data['PatOverallTotalPrice'] = patOverallTotalPrice;
    data['PayedPrice'] = payedPrice;
    data['PatDebtPice'] = patDebtPice;
    data['WihtholdingTotal'] = wihtholdingTotal;
    return data;
  }
}

class PatientTranscationProcessList {
  GetPatientTranscationProcessList? getPatientTranscationProcessList;

  PatientTranscationProcessList({this.getPatientTranscationProcessList});

  PatientTranscationProcessList.fromJson(Map<String, dynamic> json) {
    getPatientTranscationProcessList =
        json['GetPatientTranscationProcessList'] != null
        ? GetPatientTranscationProcessList.fromJson(
            json['GetPatientTranscationProcessList'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getPatientTranscationProcessList != null) {
      data['GetPatientTranscationProcessList'] =
          getPatientTranscationProcessList!.toJson();
    }
    return data;
  }
}

class GetPatientTranscationProcessList {
  String? patientProcessId;
  String? processId;
  String? processName;
  String? processTime;
  String? sutCode;
  String? processQuantity;
  String? categoryName;
  String? typeName;
  String? patientPrice;
  String? assPrice;
  String? secAssPrice;
  String? patPriceDebt;
  String? assPriceDebt;
  String? secAssPriceDebt;
  String? contTotal;

  GetPatientTranscationProcessList({
    this.patientProcessId,
    this.processId,
    this.processName,
    this.processTime,
    this.sutCode,
    this.processQuantity,
    this.categoryName,
    this.typeName,
    this.patientPrice,
    this.assPrice,
    this.secAssPrice,
    this.patPriceDebt,
    this.assPriceDebt,
    this.secAssPriceDebt,
    this.contTotal,
  });

  GetPatientTranscationProcessList.fromJson(Map<String, dynamic> json) {
    patientProcessId = json['PatientProcessId'];
    processId = json['ProcessId'];
    processName = json['ProcessName'];
    processTime = json['ProcessTime'];
    sutCode = json['SutCode'];
    processQuantity = json['ProcessQuantity'];
    categoryName = json['CategoryName'];
    typeName = json['TypeName'];
    patientPrice = json['PatientPrice'];
    assPrice = json['AssPrice'];
    secAssPrice = json['SecAssPrice'];
    patPriceDebt = json['PatPriceDebt'];
    assPriceDebt = json['AssPriceDebt'];
    secAssPriceDebt = json['SecAssPriceDebt'];
    contTotal = json['ContTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientProcessId'] = patientProcessId;
    data['ProcessId'] = processId;
    data['ProcessName'] = processName;
    data['ProcessTime'] = processTime;
    data['SutCode'] = sutCode;
    data['ProcessQuantity'] = processQuantity;
    data['CategoryName'] = categoryName;
    data['TypeName'] = typeName;
    data['PatientPrice'] = patientPrice;
    data['AssPrice'] = assPrice;
    data['SecAssPrice'] = secAssPrice;
    data['PatPriceDebt'] = patPriceDebt;
    data['AssPriceDebt'] = assPriceDebt;
    data['SecAssPriceDebt'] = secAssPriceDebt;
    data['ContTotal'] = contTotal;
    return data;
  }
}
