class RetailSaleModel {
  int? id;
  int? firmId;
  String? firmName;
  int? customerId;
  String? coustomerName;
  int? accountTypeId;
  String? accountName;
  int? salesNo;
  String? salesDate;
  String? cash;
  String? cellNo;
  String? emailId;
  String? address;
  int? totalQty;
  dynamic totalRate;
  dynamic totalAmount;
  dynamic netTotalAmount;
  String? discount;
  dynamic discountRate;
  dynamic discountAmount;
  String? transport;
  dynamic transportRate;
  dynamic transportAmount;
  List<ItemDetails>? itemDetails;

  RetailSaleModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.customerId,
      this.coustomerName,
      this.accountTypeId,
      this.accountName,
      this.salesNo,
      this.salesDate,
      this.cash,
      this.cellNo,
      this.emailId,
      this.address,
      this.totalQty,
      this.totalRate,
      this.totalAmount,
      this.netTotalAmount,
      this.discount,
      this.discountRate,
      this.discountAmount,
      this.transport,
      this.transportRate,
      this.transportAmount,
      this.itemDetails});

  RetailSaleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    customerId = json['customer_id'];
    coustomerName = json['coustomer_name'];
    accountTypeId = json['account_type_id'];
    accountName = json['account_name'];
    salesNo = json['sales_no'];
    salesDate = json['sales_date'];
    cash = json['cash'];
    cellNo = json['cell_no'];
    emailId = json['email_id'];
    address = json['address'];
    totalQty = json['total_qty'];
    totalRate = json['total_rate'];
    totalAmount = json['total_amount'];
    netTotalAmount = json['net_total_amount'];
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
    data['customer_id'] = this.customerId;
    data['coustomer_name'] = this.coustomerName;
    data['account_type_id'] = this.accountTypeId;
    data['account_name'] = this.accountName;
    data['sales_no'] = this.salesNo;
    data['sales_date'] = this.salesDate;
    data['cash'] = this.cash;
    data['cell_no'] = this.cellNo;
    data['email_id'] = this.emailId;
    data['address'] = this.address;
    data['total_qty'] = this.totalQty;
    data['total_rate'] = this.totalRate;
    data['total_amount'] = this.totalAmount;
    data['net_total_amount'] = this.netTotalAmount;
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
  int? retailSaleId;
  int? productId;
  String? designNo;
  String? work;
  int? qty;
  dynamic rate;
  dynamic amount;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? workDetails;
  String? productName;

  ItemDetails(
      {this.id,
      this.retailSaleId,
      this.productId,
      this.designNo,
      this.work,
      this.qty,
      this.rate,
      this.amount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.workDetails,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    retailSaleId = json['retail_sale_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    work = json['work'];
    qty = json['qty'];
    rate = json['rate'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    workDetails = json['work_details'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['retail_sale_id'] = this.retailSaleId;
    data['product_id'] = this.productId;
    data['design_no'] = this.designNo;
    data['work'] = this.work;
    data['qty'] = this.qty;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['work_details'] = this.workDetails;
    data['product_name'] = this.productName;
    return data;
  }
}
