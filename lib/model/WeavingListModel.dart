//WeavingListModel

class WeavingListModel {
  int? id;
  int? weaverId;
  int? loom;
  int? no;
  String? warpStatus;
  int? firmId;
  int? productId;
  int? wages;
  dynamic? unitLength;
  int? receivedProductQuantity;
  int? receivedDebit;
  int? receivedCredit;
  int? balanceProductQuantity;
  int? balanceDebit;
  int? balanceCredit;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? weaverName;
  String? firmName;
  String? productName;

  WeavingListModel(
      {this.id,
      this.weaverId,
      this.loom,
      this.no,
      this.warpStatus,
      this.firmId,
      this.productId,
      this.wages,
      this.unitLength,
      this.receivedProductQuantity,
      this.receivedDebit,
      this.receivedCredit,
      this.balanceProductQuantity,
      this.balanceDebit,
      this.balanceCredit,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.weaverName,
      this.firmName,
      this.productName});

  WeavingListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    loom = json['loom'];
    no = json['no'];
    warpStatus = json['warp_status'];
    firmId = json['firm_id'];
    productId = json['product_id'];
    wages = json['wages'];
    unitLength = json['unit_length'];
    receivedProductQuantity = json['received_product_quantity'];
    receivedDebit = json['received_debit'];
    receivedCredit = json['received_credit'];
    balanceProductQuantity = json['balance_product_quantity'];
    balanceDebit = json['balance_debit'];
    balanceCredit = json['balance_credit'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    weaverName = json['weaver_name'];
    firmName = json['firm_name'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weaver_id'] = this.weaverId;
    data['loom'] = this.loom;
    data['no'] = this.no;
    data['warp_status'] = this.warpStatus;
    data['firm_id'] = this.firmId;
    data['product_id'] = this.productId;
    data['wages'] = this.wages;
    data['unit_length'] = this.unitLength;
    data['received_product_quantity'] = this.receivedProductQuantity;
    data['received_debit'] = this.receivedDebit;
    data['received_credit'] = this.receivedCredit;
    data['balance_product_quantity'] = this.balanceProductQuantity;
    data['balance_debit'] = this.balanceDebit;
    data['balance_credit'] = this.balanceCredit;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['weaver_name'] = this.weaverName;
    data['firm_name'] = this.firmName;
    data['product_name'] = this.productName;
    return data;
  }
}
