class ProductStockAdjustmentsModel {
  int? id;
  String? date;
  String? recordNo;
  String? details;
  int? totalQuantity;
  List<ItemDetails>? itemDetails;

  ProductStockAdjustmentsModel(
      {this.id,
        this.date,
        this.recordNo,
        this.details,
        this.totalQuantity,
        this.itemDetails});

  ProductStockAdjustmentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    recordNo = json['record_no'];
    details = json['details'];
    totalQuantity = json['total_quantity'];
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
    data['date'] = this.date;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['total_quantity'] = this.totalQuantity;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productStockAdjustmentId;
  int? productId;
  String? designNo;
  String? work;
  int? stock;
  int? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? workType;
  String? productName;

  ItemDetails(
      {this.id,
        this.productStockAdjustmentId,
        this.productId,
        this.designNo,
        this.work,
        this.stock,
        this.quantity,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.workType,
        this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productStockAdjustmentId = json['product_stock_adjustment_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    work = json['work'];
    stock = json['stock'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    workType = json['work_type'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_stock_adjustment_id'] = this.productStockAdjustmentId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['work'] = this.work;
    data['stock'] = this.stock;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['work_type'] = this.workType;
    data['product_name'] = this.productName;
    return data;
  }
}
