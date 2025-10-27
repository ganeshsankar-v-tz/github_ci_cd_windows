class WeaverByLoomStatusModel {
  int? weaveNo;
  String? currentStatus;
  int? productId;
  String? productName;
  int? wages;

  WeaverByLoomStatusModel(
      {this.weaveNo,
      this.currentStatus,
      this.productId,
      this.productName,
      this.wages});

  WeaverByLoomStatusModel.fromJson(Map<String, dynamic> json) {
    weaveNo = json['weave_no'];
    currentStatus = json['current_status'];
    productId = json['product_id'];
    productName = json['product_name'];
    wages = json['wages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weave_no'] = weaveNo;
    data['current_status'] = currentStatus;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['wages'] = wages;
    return data;
  }

  @override
  String toString() {
    return "$currentStatus";
  }
}
