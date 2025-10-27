class YarnOpeningStockModel {
  int? id;
  int? yarnId;
  String? date;
  String? yarnName;
  int? colourId;
  String? createdAt;
  String? colourName;
  int? totalQty;
  List<ItemDetails>? itemDetails;

  YarnOpeningStockModel(
      {this.id,
        this.yarnId,
        this.date,
        this.yarnName,
        this.colourId,
        this.createdAt,
        this.colourName,
        this.totalQty,
        this.itemDetails});

  YarnOpeningStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnId = json['yarn_id'];
    date = json['date'];
    yarnName = json['yarn_name'];
    colourId = json['colour_id'];
    createdAt = json['created_at'];
    colourName = json['colour_name'];
    totalQty = json['total_qty'];
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
    data['yarn_id'] = this.yarnId;
    data['date'] = this.date;
    data['yarn_name'] = this.yarnName;
    data['colour_id'] = this.colourId;
    data['created_at'] = this.createdAt;
    data['colour_name'] = this.colourName;
    data['total_qty'] = this.totalQty;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnOpeningStockId;
  String? stockIn;
  String? boxNumber;
  int? quantity;
  String? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
        this.yarnOpeningStockId,
        this.stockIn,
        this.boxNumber,
        this.quantity,
        this.status,
        this.createdAt,
        this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnOpeningStockId = json['yarn_opening_stock_id'];
    stockIn = json['stock_in'];
    boxNumber = json['box_number'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_opening_stock_id'] = this.yarnOpeningStockId;
    data['stock_in'] = this.stockIn;
    data['box_number'] = this.boxNumber;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}