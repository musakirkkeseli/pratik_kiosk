import 'package:kiosk/core/utility/logger_service.dart';

class SectionItems {
  String? sectionId;
  String? sectionName;

  SectionItems({this.sectionId, this.sectionName});

  SectionItems.fromJson(Map<String, dynamic> json) {
    MyLog.debug('SectionItems.fromJson: $json');
    sectionId = json['ID'];
    sectionName = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = sectionId;
    data['Name'] = sectionName;
    return data;
  }
}
