class JobWorkerProductModel {
  int? id;
  int? jobworkerId;
  String? jobworkerName;
  String? recordNo;
  String? details;
  int? totalQty;
  String? createdAt;
  List<ItemDetails>? itemDetails;

  JobWorkerProductModel(
      {this.id,
        this.jobworkerId,
        this.jobworkerName,
        this.recordNo,
        this.details,
        this.totalQty,
        this.createdAt,
        this.itemDetails});

  JobWorkerProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobworkerId = json['jobworker_id'];
    jobworkerName = json['jobworker_name'];
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
    data['jobworker_id'] = this.jobworkerId;
    data['jobworker_name'] = this.jobworkerName;
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
  int? jobWorkProductOpeningStockId;
  int? productId;
  String? designNo;
  String? orderedWork;
  int? quantity;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? pcs;
  String? productName;

  ItemDetails(
      {this.id,
        this.jobWorkProductOpeningStockId,
        this.productId,
        this.designNo,
        this.orderedWork,
        this.quantity,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.pcs,
        this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobWorkProductOpeningStockId = json['job_work_product_opening_stock_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    orderedWork = json['ordered_work'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pcs = json['pcs'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['job_work_product_opening_stock_id'] =
        this.jobWorkProductOpeningStockId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['ordered_work'] = this.orderedWork;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['pcs'] = this.pcs;
    data['product_name'] = this.productName;
    return data;
  }
}