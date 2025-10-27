class ProcessProductOpeningBalanceModel {
  int? id;
  int? processorId;
  String? processorName;
  String? recordNo;
  String? details;
  int? totalQty;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  ProcessProductOpeningBalanceModel(
      {this.id,
        this.processorId,
        this.processorName,
        this.recordNo,
        this.details,
        this.totalQty,
        this.createdAt,
        this.itemDetails});

  ProcessProductOpeningBalanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processorId = json['processor_id'];
    processorName = json['processor_name'];
    recordNo = json['record_no'];
    details = json['details'];
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
    data['processor_id'] = this.processorId;
    data['processor_name'] = this.processorName;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
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
  int? processProductOpeningStockId;
  int? productId;
  String? designNo;
  String? workType;
  int? pcs;
  int? quantity;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? productName;

  ItemDetails(
      {this.id,
        this.processProductOpeningStockId,
        this.productId,
        this.designNo,
        this.workType,
        this.pcs,
        this.quantity,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processProductOpeningStockId = json['process_product_opening_stock_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    workType = json['work_type'];
    pcs = json['pcs'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['process_product_opening_stock_id'] =
        this.processProductOpeningStockId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['work_type'] = this.workType;
    data['pcs'] = this.pcs;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    return data;
  }
}