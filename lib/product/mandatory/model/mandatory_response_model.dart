import '../../../core/model/dropdown_model.dart';
import '../../../features/utility/enum/enum_object_type.dart';

class MandatoryResponseModel {
  String? id;
  String? labelCaption;
  String? targetFieldName;
  String? maxValue;
  String? minValue;
  String? isNullable;
  String? fieldValue;
  ObjectType? objectType;
  List<DropdownModel>? dropdownItems;

  MandatoryResponseModel({
    this.id,
    this.labelCaption,
    this.targetFieldName,
    this.maxValue,
    this.minValue,
    this.isNullable,
    this.fieldValue,
    this.objectType,
    this.dropdownItems,
  });

  MandatoryResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    labelCaption = json['LABEL_CAPTION'];
    targetFieldName = json['TARGET_FIELD_NAME'];
    maxValue = json['MAX_VALUE'];
    minValue = json['MIN_VALUE'];
    isNullable = json['IS_NULLABLE'];
    fieldValue = json['FIELD_VALUE'];
    objectType = ObjectTypeHelper.fromString(json['OBJECT_TYPE'] as String?);
    if (json['DROPDOWN_ITEMS'] != null) {
      dropdownItems = <DropdownModel>[];
      json['DROPDOWN_ITEMS'].forEach((v) {
        dropdownItems!.add(DropdownModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['LABEL_CAPTION'] = labelCaption;
    data['TARGET_FIELD_NAME'] = targetFieldName;
    data['MAX_VALUE'] = maxValue;
    data['MIN_VALUE'] = minValue;
    data['IS_NULLABLE'] = isNullable;
    data['FIELD_VALUE'] = fieldValue;
    data['OBJECT_TYPE'] = ObjectTypeHelper.toJson(objectType);
    if (dropdownItems != null) {
      data['DROPDOWN_ITEMS'] = dropdownItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
