class YarnStockModel {
  int? id;
  int? firmId;
  String? firmName;
  String? eDate;
  String? reason;
  int? recordNo;
  String? details;
  String? yarnName;
  List<YarnItem>? itemDetails;

  YarnStockModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.eDate,
      this.reason,
      this.recordNo,
      this.details,
      this.yarnName,
      this.itemDetails});

  YarnStockModel.fromJson(Map<String, dynamic> json) {
    id = json['rec_no'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    eDate = json['e_date'];
    reason = json['reason'];
    recordNo = json['rec_no'];
    details = json['details'];
    yarnName = json['yarn_name'];
    if (json['item_details'] != null) {
      itemDetails = <YarnItem>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(YarnItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rec_no'] = id;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['e_date'] = eDate;
    data['reason'] = reason;
    data['rec_no'] = recordNo;
    data['details'] = details;
    data['yarn_name'] = yarnName;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YarnItem {
  int? id;
  int? yarnStockAdjustmentId;
  int? yarnId;
  String? boxNo;
  String? stockIn;
  String? typ;
  int? batchNo;
  int? pck;
  dynamic quantity;
  int? crNo;
  num? crQty;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  int? colorId;
  String? yarnName;
  String? colorName;

  YarnItem({
    this.id,
    this.yarnStockAdjustmentId,
    this.yarnId,
    this.boxNo,
    this.stockIn,
    this.typ,
    this.batchNo,
    this.pck,
    this.quantity,
    this.crNo,
    this.crQty,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.colorId,
    this.yarnName,
    this.colorName,
  });

  YarnItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnStockAdjustmentId = json['yarn_stock_adjustment_id'];
    yarnId = json['yarn_id'];
    boxNo = json['box_no'];
    stockIn = json['stock_in'];
    typ = json['typ'];
    batchNo = json['batch_no'];
    pck = json['pck'];
    quantity = json['quantity'];
    crNo = json['cr_no'];
    crQty = json['cr_qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    colorId = json['color_id'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_stock_adjustment_id'] = yarnStockAdjustmentId;
    data['yarn_id'] = yarnId;
    data['box_no'] = boxNo;
    data['stock_in'] = stockIn;
    data['typ'] = typ;
    data['batch_no'] = batchNo;
    data['pck'] = pck;
    data['quantity'] = quantity;
    data['cr_no'] = crNo;
    data['cr_qty'] = crQty;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['color_id'] = colorId;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}
