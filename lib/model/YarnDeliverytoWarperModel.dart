class YarnDeliverytoWarperModel {
  int? id;
  int? warperId;
  String? warperName;
  String? creatorName;
  int? dcNo;
  String? eDate;
  String? details;
  String? emptyType;
  int? transNo;
  int? emptyQty;
  String? acNo;
  String? eeTyp;
  int? firmId;
  String? firmName;
  int? pck;
  int? quantity;
  List<ItemDetails>? itemDetails;

  YarnDeliverytoWarperModel(
      {this.id,
      this.warperId,
      this.warperName,
      this.creatorName,
      this.dcNo,
      this.eDate,
      this.details,
      this.emptyType,
      this.transNo,
      this.emptyQty,
      this.acNo,
      this.eeTyp,
      this.firmId,
      this.firmName,
      this.pck,
      this.quantity,
      this.itemDetails});

  YarnDeliverytoWarperModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    creatorName = json['creator_name'];
    dcNo = json['dc_no'];
    eDate = json['e_date'];
    details = json['details'];
    emptyType = json['empty_type'];
    transNo = json['trans_no'];
    emptyQty = json['empty_qty'];
    acNo = json['ac_no'];
    eeTyp = json['ee_typ'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    pck = json['pck'];
    quantity = json['quantity'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warper_id'] = this.warperId;
    data['warper_name'] = this.warperName;
    data['creator_name'] = this.creatorName;
    data['dc_no'] = this.dcNo;
    data['e_date'] = this.eDate;
    data['details'] = this.details;
    data['empty_type'] = this.emptyType;
    data['trans_no'] = this.transNo;
    data['empty_qty'] = this.emptyQty;
    data['ac_no'] = this.acNo;
    data['ee_typ'] = this.eeTyp;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['pck'] = this.pck;
    data['quantity'] = this.quantity;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnDeliveryToWarperId;
  int? yarnId;
  int? colorId;
  String? stockIn;
  String? boxNo;
  int? stock;
  int? pck;
  // dynamic quantity;
  int? rowNo;
  int? boxSerialNo;
  dynamic grossQuantity;
  // dynamic lessQuantity;
  int? deliCr;
  String? rtnCrDet;
  int? rtnCr;
  String? rtnyarnCrDet;
  int? rtnyarnCr;
  int? crNo;
  int? rtnyarnCrLess;
  String? updatedAt;
  String? createdAt;
  String? createdBy;
  String? updatedBy;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnDeliveryToWarperId,
      this.yarnId,
      this.colorId,
      this.stockIn,
      this.boxNo,
      this.stock,
      this.pck,
      // this.quantity,
      this.rowNo,
      this.boxSerialNo,
      this.grossQuantity,
      // this.lessQuantity,
      this.deliCr,
      this.rtnCrDet,
      this.rtnCr,
      this.rtnyarnCrDet,
      this.rtnyarnCr,
      this.crNo,
      this.rtnyarnCrLess,
      this.updatedAt,
      this.createdAt,
      this.createdBy,
      this.updatedBy,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnDeliveryToWarperId = json['yarn_delivery_to_warper_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    boxNo = json['box_no'];
    stock = json['stock'];
    pck = json['pck'];
    // quantity = json['quantity'];
    rowNo = json['row_no'];
    boxSerialNo = json['box_serial_no'];
    grossQuantity = json['gross_quantity'];
    // lessQuantity = json['less_quantity'];
    deliCr = json['deli_cr'];
    rtnCrDet = json['rtn_cr_det'];
    rtnCr = json['rtn_cr'];
    rtnyarnCrDet = json['rtnyarn_cr_det'];
    rtnyarnCr = json['rtnyarn_cr'];
    crNo = json['cr_no'];
    rtnyarnCrLess = json['rtnyarn_cr_less'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_delivery_to_warper_id'] = this.yarnDeliveryToWarperId;
    data['yarn_id'] = this.yarnId;
    data['color_id'] = this.colorId;
    data['stock_in'] = this.stockIn;
    data['box_no'] = this.boxNo;
    data['stock'] = this.stock;
    data['pck'] = this.pck;
    // data['quantity'] = this.quantity;
    data['row_no'] = this.rowNo;
    data['box_serial_no'] = this.boxSerialNo;
    data['gross_quantity'] = this.grossQuantity;
    // data['less_quantity'] = this.lessQuantity;
    data['deli_cr'] = this.deliCr;
    data['rtn_cr_det'] = this.rtnCrDet;
    data['rtn_cr'] = this.rtnCr;
    data['rtnyarn_cr_det'] = this.rtnyarnCrDet;
    data['rtnyarn_cr'] = this.rtnyarnCr;
    data['cr_no'] = this.crNo;
    data['rtnyarn_cr_less'] = this.rtnyarnCrLess;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
