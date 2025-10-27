class ProductSaleReturnModel {
  int? id;
  int? firmId;
  String? firmName;
  int? coustomerId;
  String? coustomerName;
  int? returnNo;
  String? returnDate;
  String? against;
  String? salesNo;
  int? accountTypeId;
  String? accountName;
  String? checkedBy;
  String? details;
  int? totalPieces;
  int? totalQty;
  dynamic totalAmount;
  dynamic totalNetAmount;
  String? discount;
  dynamic discountRate;
  dynamic discountAmount;
  String? transport;
  dynamic transportRate;
  dynamic transportAmount;
  List<ItemDetails>? itemDetails;

  ProductSaleReturnModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.coustomerId,
      this.coustomerName,
      this.returnNo,
      this.returnDate,
      this.against,
      this.salesNo,
      this.accountTypeId,
      this.accountName,
      this.checkedBy,
      this.details,
      this.totalPieces,
      this.totalQty,
      this.totalAmount,
      this.totalNetAmount,
      this.discount,
      this.discountRate,
      this.discountAmount,
      this.transport,
      this.transportRate,
      this.transportAmount,
      this.itemDetails});

  ProductSaleReturnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    coustomerId = json['coustomer_id'];
    coustomerName = json['coustomer_name'];
    returnNo = json['return_no'];
    returnDate = json['return_date'];
    against = json['against'];
    salesNo = json['sales_no'];
    accountTypeId = json['account_type_id'];
    accountName = json['account_name'];
    checkedBy = json['checked_by'];
    details = json['details'];
    totalPieces = json['total_pieces'];
    totalQty = json['total_qty'];
    totalAmount = json['total_Amount'];
    totalNetAmount = json['total_net_amount'];
    discount = json['discount'];
    discountRate = json['discount_rate'];
    discountAmount = json['discount_amount'];
    transport = json['transport'];
    transportRate = json['transport_rate'];
    transportAmount = json['transport_amount'];
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
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['coustomer_id'] = this.coustomerId;
    data['coustomer_name'] = this.coustomerName;
    data['return_no'] = this.returnNo;
    data['return_date'] = this.returnDate;
    data['against'] = this.against;
    data['sales_no'] = this.salesNo;
    data['account_type_id'] = this.accountTypeId;
    data['account_name'] = this.accountName;
    data['checked_by'] = this.checkedBy;
    data['details'] = this.details;
    data['total_pieces'] = this.totalPieces;
    data['total_qty'] = this.totalQty;
    data['total_Amount'] = this.totalAmount;
    data['total_net_amount'] = this.totalNetAmount;
    data['discount'] = this.discount;
    data['discount_rate'] = this.discountRate;
    data['discount_amount'] = this.discountAmount;
    data['transport'] = this.transport;
    data['transport_rate'] = this.transportRate;
    data['transport_amount'] = this.transportAmount;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productSaleReturnId;
  int? productId;
  String? designNo;
  String? workName;
  int? productQty;
  int? pieces;
  int? qty;
  dynamic rate;
  dynamic amount;
  int? stock;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? workDetails;
  String? productName;

  ItemDetails(
      {this.id,
      this.productSaleReturnId,
      this.productId,
      this.designNo,
      this.workName,
      this.productQty,
      this.pieces,
      this.qty,
      this.rate,
      this.amount,
      this.stock,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.workDetails,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productSaleReturnId = json['product_sale_return_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    workName = json['work_name'];
    productQty = json['product_qty'];
    pieces = json['pieces'];
    qty = json['qty'];
    rate = json['rate'];
    amount = json['amount'];
    stock = json['stock'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    workDetails = json['work_details'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_sale_return_id'] = this.productSaleReturnId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['work_name'] = this.workName;
    data['product_qty'] = this.productQty;
    data['pieces'] = this.pieces;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['stock'] = this.stock;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['work_details'] = this.workDetails;
    data['product_name'] = this.productName;
    return data;
  }
}
