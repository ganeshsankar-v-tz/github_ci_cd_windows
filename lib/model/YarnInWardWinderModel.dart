class YarnInWardWinderModel {
  int? id;
  int? winderId;
  String? winderName;
  String? referanceNo;
  String? eDate;
  String? details;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  YarnInWardWinderModel({
    this.id,
    this.winderId,
    this.winderName,
    this.referanceNo,
    this.eDate,
    this.details,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  YarnInWardWinderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    winderId = json['winder_id'];
    winderName = json['winder_name'];
    referanceNo = json['referance_no'];
    eDate = json['e_date'];
    details = json['details'];
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
    data['winder_id'] = winderId;
    data['winder_name'] = winderName;
    data['referance_no'] = referanceNo;
    data['e_date'] = eDate;
    data['details'] = details;
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
  int? yarnInwardFromWinderId;
  String? entryType;
  int? yarnId;
  String? colourName;
  int? colorId;
  String? stockIn;
  int? pack;
  String? bagBoxNo;
  int? rowNo;
  String? boxSerialNo;
  int? expYarnNo;
  dynamic expQuantity;
  dynamic grossQuantity;
  int? crNo;
  int? rcCr;
  int? deliRecNo;
  dynamic debitAmount;
  int? firmNo;
  int? wagesAno;
  dynamic wages;
  dynamic creditAmount;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? yarnName;
  String? colorName;
  String? dcNo;

  ItemDetails(
      {this.id,
      this.yarnInwardFromWinderId,
      this.entryType,
      this.yarnId,
      this.colourName,
      this.colorId,
      this.stockIn,
      this.pack,
      this.bagBoxNo,
      this.rowNo,
      this.boxSerialNo,
      this.expYarnNo,
      this.expQuantity,
      this.grossQuantity,
      this.crNo,
      this.rcCr,
      this.deliRecNo,
      this.debitAmount,
      this.firmNo,
      this.wagesAno,
      this.wages,
      this.creditAmount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.yarnName,
      this.colorName,
      this.dcNo});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnInwardFromWinderId = json['yarn_inward_from_winder_id'];
    entryType = json['entry_type'];
    yarnId = json['yarn_id'];
    colourName = json['colour_name'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    pack = json['pack'];
    bagBoxNo = json['bag_box_no'];
    rowNo = json['row_no'];
    boxSerialNo = json['box_serial_no'];
    expYarnNo = json['exp_yarn_no'];
    expQuantity = json['exp_quantity'];
    grossQuantity = json['gross_quantity'];
    crNo = json['cr_no'];
    rcCr = json['rc_cr'];
    deliRecNo = json['deli_rec_no'];
    debitAmount = json['debit_amount'];
    firmNo = json['firm_no'];
    wagesAno = json['wages_ano'];
    wages = json['wages'];
    creditAmount = json['credit_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
    dcNo = json['dc_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_inward_from_winder_id'] = yarnInwardFromWinderId;
    data['entry_type'] = entryType;
    data['yarn_id'] = yarnId;
    data['colour_name'] = colourName;
    data['color_id'] = colorId;
    data['stock_in'] = stockIn;
    data['pack'] = pack;
    data['bag_box_no'] = bagBoxNo;
    data['row_no'] = rowNo;
    data['box_serial_no'] = boxSerialNo;
    data['exp_yarn_no'] = expYarnNo;
    data['exp_quantity'] = expQuantity;
    data['gross_quantity'] = grossQuantity;
    data['cr_no'] = crNo;
    data['rc_cr'] = rcCr;
    data['deli_rec_no'] = deliRecNo;
    data['debit_amount'] = debitAmount;
    data['firm_no'] = firmNo;
    data['wages_ano'] = wagesAno;
    data['wages'] = wages;
    data['credit_amount'] = creditAmount;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    data['dc_no'] = dcNo;
    return data;
  }
}
