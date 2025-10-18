class PatientMandatoryModel {
  String? id;
  String? targetFieldName;
  String? value;

  PatientMandatoryModel({this.id, this.targetFieldName, this.value});

  PatientMandatoryModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    targetFieldName = json['TargetFieldName'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['TargetFieldName'] = targetFieldName;
    data['Value'] = value;
    return data;
  }
}
