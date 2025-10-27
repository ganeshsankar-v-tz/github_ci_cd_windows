class ProductIntegrationModel {
  int? id;
  String? date;
  String? recoredNo;
  String? integrateBy;
  int? productId;
  String? productName;
  String? designNo;
  int? quantity;
  int? totalWastage;
  List<ProductDetails>? productDetails;

  ProductIntegrationModel(
      {this.id,
        this.date,
        this.recoredNo,
        this.integrateBy,
        this.productId,
        this.productName,
        this.designNo,
        this.quantity,
        this.totalWastage,
        this.productDetails});

  ProductIntegrationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    recoredNo = json['recored_no'];
    integrateBy = json['integrate_by'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    quantity = json['quantity'];
    totalWastage = json['total_wastage'];
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['recored_no'] = this.recoredNo;
    data['integrate_by'] = this.integrateBy;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['design_no'] = this.designNo;
    data['quantity'] = this.quantity;
    data['total_wastage'] = this.totalWastage;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetails {
  int? id;
  int? productIntergrationId;
  int? productId;
  String? designNo;
  String? workName;
  int? quantity;
  int? wastage;
  int? totelConsumption;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? productName;

  ProductDetails(
      {this.id,
        this.productIntergrationId,
        this.productId,
        this.designNo,
        this.workName,
        this.quantity,
        this.wastage,
        this.totelConsumption,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.productName});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productIntergrationId = json['product_intergration_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    workName = json['work_name'];
    quantity = json['quantity'];
    wastage = json['wastage'];
    totelConsumption = json['totel_consumption'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_intergration_id'] = this.productIntergrationId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['work_name'] = this.workName;
    data['quantity'] = this.quantity;
    data['wastage'] = this.wastage;
    data['totel_consumption'] = this.totelConsumption;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['product_name'] = this.productName;
    return data;
  }
}
