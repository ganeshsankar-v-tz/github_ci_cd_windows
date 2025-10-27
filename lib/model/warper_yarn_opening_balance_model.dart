class WarpYarnOpeningBalanceModel {
  int? id;
  int? warperId;
  String? warperName;
  String? recordNo;
  String? details;
  int? totalPack;
  dynamic? totalQty;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  WarpYarnOpeningBalanceModel(
      {this.id,
      this.warperId,
      this.warperName,
      this.recordNo,
      this.details,
      this.totalPack,
      this.totalQty,
      this.createdAt,
      this.itemDetails});

  WarpYarnOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    recordNo = json['record_no'];
    details = json['details'];
    totalPack = json['total_pack'];
    totalQty = json['total_qty'];
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
    data['warper_id'] = this.warperId;
    data['warper_name'] = this.warperName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['total_pack'] = this.totalPack;
    data['total_qty'] = this.totalQty;
    data['created_at'] = this.createdAt;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warperYarnOpeningStockId;
  int? yarnId;
  int? colourId;
  int? pack;
  dynamic quantity;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.warperYarnOpeningStockId,
      this.yarnId,
      this.colourId,
      this.pack,
      this.quantity,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warperYarnOpeningStockId = json['warper_yarn_opening_stock_id'];
    yarnId = json['yarn_id'];
    colourId = json['colour_id'];
    pack = json['pack'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warper_yarn_opening_stock_id'] = this.warperYarnOpeningStockId;
    data['yarn_id'] = this.yarnId;
    data['colour_id'] = this.colourId;
    data['pack'] = this.pack;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
