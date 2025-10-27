class DyerOrderOpeningBalanceModel {
  int? id;
  int? dyerId;
  String? dyerName;
  int? yarnId;
  String? yarnName;
  int? recordNo;
  String? details;
  int? qtyTotal;
  int? packTotal;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  DyerOrderOpeningBalanceModel(
      {this.id,
        this.dyerId,
        this.dyerName,
        this.yarnId,
        this.yarnName,
        this.recordNo,
        this.details,
        this.qtyTotal,
        this.packTotal,
        this.createdAt,
        this.itemDetails});

  DyerOrderOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyerName = json['dyer_name'];
    yarnId = json['yarn_id'];
    yarnName = json['yarn_name'];
    recordNo = json['record_no'];
    details = json['details'];
    qtyTotal = json['qty_total'];
    packTotal = json['pack_total'];
    createdAt = json['created_at'];
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
    data['dyer_id'] = this.dyerId;
    data['dyer_name'] = this.dyerName;
    data['yarn_id'] = this.yarnId;
    data['yarn_name'] = this.yarnName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['qty_total'] = this.qtyTotal;
    data['pack_total'] = this.packTotal;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? dyarOpeningStockId;
  int? colourId;
  int? pack;
  int? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? colorName;

  ItemDetails(
      {this.id,
        this.dyarOpeningStockId,
        this.colourId,
        this.pack,
        this.quantity,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyarOpeningStockId = json['dyar_opening_stock_id'];
    colourId = json['colour_id'];
    pack = json['pack'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dyar_opening_stock_id'] = this.dyarOpeningStockId;
    data['colour_id'] = this.colourId;
    data['pack'] = this.pack;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['color_name'] = this.colorName;
    return data;
  }
}