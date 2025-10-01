class SectionItems {
  int? sectionId;
  String? sectionName;

  SectionItems({this.sectionId, this.sectionName});

  SectionItems.fromJson(Map<String, dynamic> json) {
    sectionId = json['sectionId'];
    sectionName = json['sectionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sectionId'] = sectionId;
    data['sectionName'] = sectionName;
    return data;
  }
}

