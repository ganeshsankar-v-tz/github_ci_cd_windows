class YarnInwardFromDyerModel {
  int? id;
  int? dyerId;
  String? dyerName;
  String? referenceNo;
  String? entryDate;
  int? accountTypeId;
  String? wagesAccount;
  String? details;
  dynamic totalAmount;
  dynamic? totalQuantity;
  int? totalPack;
  dynamic? discount;
  dynamic discountWages;
  dynamic discountAmount;
  dynamic netTotal;
  List<ItemDetails>? itemDetails;

  YarnInwardFromDyerModel(
      {this.id,
      this.dyerId,
      this.dyerName,
      this.referenceNo,
      this.entryDate,
      this.accountTypeId,
      this.wagesAccount,
      this.details,
      this.totalAmount,
      this.totalQuantity,
      this.totalPack,
      this.discount,
      this.discountWages,
      this.discountAmount,
      this.netTotal,
      this.itemDetails});

  YarnInwardFromDyerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyerName = json['dyer_name'];
    referenceNo = json['reference_no'];
    entryDate = json['entry_date'];
    accountTypeId = json['account_type_id'];
    wagesAccount = json['wages_account'];
    details = json['details'];
    totalAmount = json['total_amount'];
    totalQuantity = json['total_quantity'];
    totalPack = json['total_pack'];
    discount = json['discount'];
    discountWages = json['discount_wages'];
    discountAmount = json['discount_amount'];
    netTotal = json['net_total'];
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
    data['dyer_id'] = this.dyerId;
    data['dyer_name'] = this.dyerName;
    data['reference_no'] = this.referenceNo;
    data['entry_date'] = this.entryDate;
    data['account_type_id'] = this.accountTypeId;
    data['wages_account'] = this.wagesAccount;
    data['details'] = this.details;
    data['total_amount'] = this.totalAmount;
    data['total_quantity'] = this.totalQuantity;
    data['total_pack'] = this.totalPack;
    data['discount'] = this.discount;
    data['discount_wages'] = this.discountWages;
    data['discount_amount'] = this.discountAmount;
    data['net_total'] = this.netTotal;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? yarnInwardFromDyerId;
  int? yarnId;
  int? colorId;
  String? stockNo;
  String? bagBoxNo;
  int? pack;
  int? yarnBalance;
  String? calculateType;
  dynamic wages;
  dynamic amount;
  int? yarnOrderBalance;
  dynamic? less;
  dynamic? netQty;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic? quantity;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnInwardFromDyerId,
      this.yarnId,
      this.colorId,
      this.stockNo,
      this.bagBoxNo,
      this.pack,
      this.yarnBalance,
      this.calculateType,
      this.wages,
      this.amount,
      this.yarnOrderBalance,
      this.less,
      this.netQty,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.quantity,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnInwardFromDyerId = json['yarn_inward_from_dyer_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockNo = json['stock_no'];
    bagBoxNo = json['bag_box_no'];
    pack = json['pack'];
    yarnBalance = json['yarn_balance'];
    calculateType = json['calculate_type'];
    wages = json['wages'];
    amount = json['amount'];
    yarnOrderBalance = json['yarn_order_balance'];
    less = json['less'];
    netQty = json['net_qty'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quantity = json['quantity'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_inward_from_dyer_id'] = this.yarnInwardFromDyerId;
    data['yarn_id'] = this.yarnId;
    data['color_id'] = this.colorId;
    data['stock_no'] = this.stockNo;
    data['bag_box_no'] = this.bagBoxNo;
    data['pack'] = this.pack;
    data['yarn_balance'] = this.yarnBalance;
    data['calculate_type'] = this.calculateType;
    data['wages'] = this.wages;
    data['amount'] = this.amount;
    data['yarn_order_balance'] = this.yarnOrderBalance;
    data['less'] = this.less;
    data['net_qty'] = this.netQty;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['quantity'] = this.quantity;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
