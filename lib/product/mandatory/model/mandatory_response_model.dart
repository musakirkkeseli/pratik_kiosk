class MandatoryResponseModel {
  String? id;
  String? assId;
  String? massId;
  String? itId;
  String? inId;
  String? orderNumber;
  String? labelCaption;
  String? targetFieldName;
  String? defaultValue;
  String? maxValue;
  String? minValue;
  String? systemTime;
  String? ptyId;
  String? items;
  String? maskEdit;
  String? offId;
  String? valueAlwIsNull;
  String? isExpiredClear;
  String? targetFieldDetailName;
  String? targetTableName;
  String? isNullable;
  String? fieldValue;
  String? objectType;

  MandatoryResponseModel({
    this.id,
    this.assId,
    this.massId,
    this.itId,
    this.inId,
    this.orderNumber,
    this.labelCaption,
    this.targetFieldName,
    this.defaultValue,
    this.maxValue,
    this.minValue,
    this.systemTime,
    this.ptyId,
    this.items,
    this.maskEdit,
    this.offId,
    this.valueAlwIsNull,
    this.isExpiredClear,
    this.targetFieldDetailName,
    this.targetTableName,
    this.isNullable,
    this.fieldValue,
    this.objectType,
  });

  MandatoryResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    assId = json['ASS_ID'];
    massId = json['MASS_ID'];
    itId = json['IT_ID'];
    inId = json['IN_ID'];
    orderNumber = json['ORDER_NUMBER'];
    labelCaption = json['LABEL_CAPTION'];
    targetFieldName = json['TARGET_FIELD_NAME'];
    defaultValue = json['DEFAULT_VALUE'];
    maxValue = json['MAX_VALUE'];
    minValue = json['MIN_VALUE'];
    systemTime = json['SYSTEM_TIME'];
    ptyId = json['PTY_ID'];
    items = json['ITEMS'];
    maskEdit = json['MASK_EDIT'];
    offId = json['OFF_ID'];
    valueAlwIsNull = json['VALUE_ALW_IS_NULL'];
    isExpiredClear = json['IS_EXPIRED_CLEAR'];
    targetFieldDetailName = json['TARGET_FIELD_DETAIL_NAME'];
    targetTableName = json['TARGET_TABLE_NAME'];
    isNullable = json['IS_NULLABLE'];
    fieldValue = json['FIELD_VALUE'];
    objectType = json['OBJECT_TYPE'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = id;
    data['ASS_ID'] = assId;
    data['MASS_ID'] = massId;
    data['IT_ID'] = itId;
    data['IN_ID'] = inId;
    data['ORDER_NUMBER'] = orderNumber;
    data['LABEL_CAPTION'] = labelCaption;
    data['TARGET_FIELD_NAME'] = targetFieldName;
    data['DEFAULT_VALUE'] = defaultValue;
    data['MAX_VALUE'] = maxValue;
    data['MIN_VALUE'] = minValue;
    data['SYSTEM_TIME'] = systemTime;
    data['PTY_ID'] = ptyId;
    data['ITEMS'] = items;
    data['MASK_EDIT'] = maskEdit;
    data['OFF_ID'] = offId;
    data['VALUE_ALW_IS_NULL'] = valueAlwIsNull;
    data['IS_EXPIRED_CLEAR'] = isExpiredClear;
    data['TARGET_FIELD_DETAIL_NAME'] = targetFieldDetailName;
    data['TARGET_TABLE_NAME'] = targetTableName;
    data['IS_NULLABLE'] = isNullable;
    data['FIELD_VALUE'] = fieldValue;
    data['OBJECT_TYPE'] = objectType;
    return data;
  }
}
