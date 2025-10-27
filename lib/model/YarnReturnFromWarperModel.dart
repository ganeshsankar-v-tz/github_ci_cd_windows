class YarnReturnfromWarperModel {
  int? id;
  int? warperId;
  String? warperName;
  String? creatorName;
  String? dcNo;
  String? acNo;
  String? eDate;
  String? eeTyp;
  int? emptyQty;
  int? transNo;
  String? emptyType;
  int? firmId;
  String? firmName;
  String? details;
  List<ItemDetails>? itemDetails;

  YarnReturnfromWarperModel(
      {this.id,
        this.warperId,
        this.warperName,
        this.creatorName,
        this.dcNo,
        this.acNo,
        this.eDate,
        this.eeTyp,
        this.emptyQty,
        this.transNo,
        this.emptyType,
        this.firmId,
        this.firmName,
        this.details,
        this.itemDetails});

  YarnReturnfromWarperModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    creatorName = json['creator_name'];
    dcNo = json['dc_no'];
    acNo = json['ac_no'];
    eDate = json['e_date'];
    eeTyp = json['ee_typ'];
    emptyQty = json['empty_qty'];
    transNo = json['trans_no'];
    emptyType = json['empty_type'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    details = json['details'];
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
    data['ac_no'] = this.acNo;
    data['e_date'] = this.eDate;
    data['ee_typ'] = this.eeTyp;
    data['empty_qty'] = this.emptyQty;
    data['trans_no'] = this.transNo;
    data['empty_type'] = this.emptyType;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['details'] = this.details;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnReturnFromWarperId;
  int? yarnId;
  int? colorId;
  String? stockIn;
  String? boxNo;
  int? pck;
  // dynamic quantity;
  int? rowNo;
  int? boxSerialNo;
  // dynamic lessQuantity;
  int? crNo;
  int? rcdCr;
  int? rtnCr;
  String? rtnCrDet;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  dynamic grossQuantity;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
        this.yarnReturnFromWarperId,
        this.yarnId,
        this.colorId,
        this.stockIn,
        this.boxNo,
        this.pck,
        // this.quantity,
        this.rowNo,
        this.boxSerialNo,
        // this.lessQuantity,
        this.crNo,
        this.rcdCr,
        this.rtnCr,
        this.rtnCrDet,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.grossQuantity,
        this.yarnName,
        this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnReturnFromWarperId = json['yarn_return_from_warper_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    boxNo = json['box_no'];
    pck = json['pck'];
    // quantity = json['quantity'];
    rowNo = json['row_no'];
    boxSerialNo = json['box_serial_no'];
    // lessQuantity = json['less_quantity'];
    crNo = json['cr_no'];
    rcdCr = json['rcd_cr'];
    rtnCr = json['rtn_cr'];
    rtnCrDet = json['rtn_cr_det'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    grossQuantity = json['gross_quantity'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_return_from_warper_id'] = this.yarnReturnFromWarperId;
    data['yarn_id'] = this.yarnId;
    data['color_id'] = this.colorId;
    data['stock_in'] = this.stockIn;
    data['box_no'] = this.boxNo;
    data['pck'] = this.pck;
    // data['quantity'] = this.quantity;
    data['row_no'] = this.rowNo;
    data['box_serial_no'] = this.boxSerialNo;
    // data['less_quantity'] = this.lessQuantity;
    data['cr_no'] = this.crNo;
    data['rcd_cr'] = this.rcdCr;
    data['rtn_cr'] = this.rtnCr;
    data['rtn_cr_det'] = this.rtnCrDet;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['gross_quantity'] = this.grossQuantity;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
