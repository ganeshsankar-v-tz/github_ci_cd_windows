class ColorMatchingListData {
  int? id;
  int? productId;
  String? productName;
  String? designNo;
  List<ProductDetails>? productDetails;
  String? createdAt;

  ColorMatchingListData(
      {this.id,
      this.productId,
      this.productName,
      this.designNo,
      this.productDetails,
      this.createdAt});

  ColorMatchingListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['design_no'] = this.designNo;
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ProductDetails {
  String? isActive;
  String? warpColor;
  String? weftColor;

  ProductDetails({this.isActive, this.warpColor, this.weftColor});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    isActive = json['is_active'];
    warpColor = json['warp_color'];
    weftColor = json['weft_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_active'] = this.isActive;
    data['warp_color'] = this.warpColor;
    data['weft_color'] = this.weftColor;
    return data;
  }

  @override
  String toString() {
    return '${warpColor}';
  }
}
