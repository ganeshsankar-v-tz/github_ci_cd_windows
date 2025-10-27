class WeavingRunningProductModel {
  int? productId;
  num? wages;
  String? productName;
  String? designImage;

  WeavingRunningProductModel({
    this.productId,
    this.wages,
    this.productName,
    this.designImage,
  });

  WeavingRunningProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    wages = json['wages'];
    productName = json['product_name'];
    designImage = json['design_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['wages'] = wages;
    data['product_name'] = productName;
    data['design_image'] = designImage;
    return data;
  }
}
