class YarnDeliveryToWinderModel {
  int? id;
  int? firmId;
  String? firmName;
  int? winderId;
  String? winderName;
  int? wagesAno;
  String? wagesAccountType;
  String? dcNo;
  String? eDate;
  String? details;
  String? wagesStatus;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  YarnDeliveryToWinderModel({
    this.id,
    this.firmId,
    this.firmName,
    this.winderId,
    this.winderName,
    this.wagesAno,
    this.wagesAccountType,
    this.dcNo,
    this.eDate,
    this.details,
    this.wagesStatus,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  YarnDeliveryToWinderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    winderId = json['winder_id'];
    winderName = json['winder_name'];
    wagesAno = json['wages_ano'];
    wagesAccountType = json['wages_account_type'];
    dcNo = json['dc_no'];
    eDate = json['e_date'];
    details = json['details'];
    wagesStatus = json['wages_status'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['winder_id'] = winderId;
    data['winder_name'] = winderName;
    data['wages_ano'] = wagesAno;
    data['wages_account_type'] = wagesAccountType;
    data['dc_no'] = dcNo;
    data['e_date'] = eDate;
    data['details'] = details;
    data['wages_status'] = wagesStatus;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnDeliveryToWinderId;
  int? yarnId;
  String? colourName;
  int? colorId;
  String? stockIn;
  int? pack;
  String? boxNo;
  int? rowNo;
  int? boxSerialNo;
  int? expYarnId;
  num? expQuantity;
  num? grossQuantity;
  String? calculateType;
  num? wages;
  num? amount;
  num? deliCr;
  String? rtnCrDet;
  String? rtnCr;
  String? rtnyarnCrDet;
  String? rtnyarnCr;
  String? rtnrarnCrLess;
  String? crNo;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? yarnName;
  String? colorName;
  String? expYarnName;

  ItemDetails(
      {this.id,
      this.yarnDeliveryToWinderId,
      this.yarnId,
      this.colourName,
      this.colorId,
      this.stockIn,
      this.pack,
      this.boxNo,
      this.rowNo,
      this.boxSerialNo,
      this.expYarnId,
      this.expQuantity,
      this.grossQuantity,
      this.calculateType,
      this.wages,
      this.amount,
      this.deliCr,
      this.rtnCrDet,
      this.rtnCr,
      this.rtnyarnCrDet,
      this.rtnyarnCr,
      this.rtnrarnCrLess,
      this.crNo,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.yarnName,
      this.expYarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnDeliveryToWinderId = json['yarn_delivery_to_winder_id'];
    yarnId = json['yarn_id'];
    colourName = json['colour_name'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    pack = json['pack'];
    boxNo = json['box_no'];
    rowNo = json['row_no'];
    boxSerialNo = json['box_serial_no'];
    expYarnId = json['exp_yarn_id'];
    expQuantity = json['exp_quantity'];
    grossQuantity = json['gross_quantity'];
    calculateType = json['calculate_type'];
    wages = json['wages'];
    amount = json['amount'];
    deliCr = json['deli_cr'];
    rtnCrDet = json['rtn_cr_det'];
    rtnCr = json['rtn_cr'];
    rtnyarnCrDet = json['rtnyarn_cr_det'];
    rtnyarnCr = json['rtnyarn_cr'];
    rtnrarnCrLess = json['rtnrarn_cr_less'];
    crNo = json['cr_no'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
    expYarnName = json['exp_yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_delivery_to_winder_id'] = yarnDeliveryToWinderId;
    data['yarn_id'] = yarnId;
    data['colour_name'] = colourName;
    data['color_id'] = colorId;
    data['stock_in'] = stockIn;
    data['pack'] = pack;
    data['box_no'] = boxNo;
    data['row_no'] = rowNo;
    data['box_serial_no'] = boxSerialNo;
    data['exp_yarn_id'] = expYarnId;
    data['exp_quantity'] = expQuantity;
    data['gross_quantity'] = grossQuantity;
    data['calculate_type'] = calculateType;
    data['wages'] = wages;
    data['amount'] = amount;
    data['deli_cr'] = deliCr;
    data['rtn_cr_det'] = rtnCrDet;
    data['rtn_cr'] = rtnCr;
    data['rtnyarn_cr_det'] = rtnyarnCrDet;
    data['rtnyarn_cr'] = rtnyarnCr;
    data['rtnrarn_cr_less'] = rtnrarnCrLess;
    data['cr_no'] = crNo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['yarn_name'] = yarnName;
    data['exp_yarn_name'] = expYarnName;
    data['color_name'] = colorName;
    return data;
  }
}
