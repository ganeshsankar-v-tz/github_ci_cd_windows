class ProductOpeningStockModel {
  int? id;
  int? productId;
  String? eDate;
  int? quantity;
  String? details;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? productName;
  String? creatorName;
  String? updatorName;

  ProductOpeningStockModel({
    this.id,
    this.productId,
    this.eDate,
    this.quantity,
    this.details,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.productName,
    this.creatorName,
    this.updatorName,
  });

  ProductOpeningStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    eDate = json['e_date'];
    quantity = json['quantity'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    productName = json['product_name'];
    creatorName = json['creator_name'];
    updatorName = json['updator_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['e_date'] = eDate;
    data['quantity'] = quantity;
    data['details'] = details;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['product_name'] = productName;
    data['creator_name'] = creatorName;
    data['updator_name'] = updatorName;
    return data;
  }
}
