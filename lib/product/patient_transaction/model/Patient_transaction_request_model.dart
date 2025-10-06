class AssociationsModel {
  int? associationId;
  String? associationName;

  AssociationsModel({this.associationId, this.associationName});

  AssociationsModel.fromJson(Map<String, dynamic> json) {
    associationId = json['associationId'];
    associationName = json['associationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['associationId'] = associationId;
    data['associationName'] = associationName;
    return data;
  }
}
