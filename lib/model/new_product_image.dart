class NewProductImageModel {
  int? id;
  int? productId;
  String? productName;
  String? designNo;
  dynamic length;
  String? createdAt;
  List<ProductDetails>? productDetails;

  NewProductImageModel(
      {this.id,
      this.productId,
      this.productName,
      this.designNo,
      this.length,
      this.createdAt,
      this.productDetails});

  NewProductImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    length = json['length'];
    createdAt = json['created_at'];
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
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['design_no'] = this.designNo;
    data['length'] = this.length;
    data['created_at'] = this.createdAt;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetails {
  String? header;
  String? info;
  String? image;

  ProductDetails({this.header, this.info, this.image});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    info = json['info'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['info'] = this.info;
    data['image'] = this.image;
    return data;
  }
}
