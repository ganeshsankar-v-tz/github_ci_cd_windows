class YarnSaleReturnModel {
  int? id;
  int? customerId;
  String? customerName;
  int? firmId;
  String? firmName;
  int? accountType;
  String? accountTypeName;
  String? returnNo;
  String? returnDate;
  String? salesNo;
  String? details;
  int? packTotal;
  int? stockTotal;
  int? quantityTotal;
  dynamic amountTotal;
  dynamic netTotal;
  String? createdAt;
  String? discount;
  dynamic discountRate;
  dynamic discountAmount;
  String? transport;
  dynamic transportRate;
  dynamic transportAmount;
  List<ItemDetails>? itemDetails;

  YarnSaleReturnModel(
      {this.id,
      this.customerId,
      this.customerName,
      this.firmId,
      this.firmName,
      this.accountType,
      this.accountTypeName,
      this.returnNo,
      this.returnDate,
      this.salesNo,
      this.details,
      this.packTotal,
      this.stockTotal,
      this.quantityTotal,
      this.amountTotal,
      this.netTotal,
      this.createdAt,
      this.discount,
      this.discountRate,
      this.discountAmount,
      this.transport,
      this.transportRate,
      this.transportAmount,
      this.itemDetails});

  YarnSaleReturnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    accountType = json['account_type'];
    accountTypeName = json['account_type_name'];
    returnNo = json['return_no'];
    returnDate = json['return_date'];
    salesNo = json['sales_no'];
    details = json['details'];
    packTotal = json['pack_total'];
    stockTotal = json['stock_total'];
    quantityTotal = json['quantity_total'];
    amountTotal = json['amount_total'];
    netTotal = json['net_total'];
    createdAt = json['created_at'];
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
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['account_type'] = this.accountType;
    data['account_type_name'] = this.accountTypeName;
    data['return_no'] = this.returnNo;
    data['return_date'] = this.returnDate;
    data['sales_no'] = this.salesNo;
    data['details'] = this.details;
    data['pack_total'] = this.packTotal;
    data['stock_total'] = this.stockTotal;
    data['quantity_total'] = this.quantityTotal;
    data['amount_total'] = this.amountTotal;
    data['net_total'] = this.netTotal;
    data['created_at'] = this.createdAt;
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
  int? yarnSaleReturnId;
  int? colourId;
  int? yarnId;
  int? stock;
  String? boxNo;
  int? pack;
  int? quantity;
  dynamic rate;
  dynamic amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? stockTo;
  int? less;
  int? netQuantity;
  String? calculateType;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnSaleReturnId,
      this.colourId,
      this.yarnId,
      this.stock,
      this.boxNo,
      this.pack,
      this.quantity,
      this.rate,
      this.amount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.stockTo,
      this.less,
      this.netQuantity,
      this.calculateType,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnSaleReturnId = json['yarn_sale_return_id'];
    colourId = json['colour_id'];
    yarnId = json['yarn_id'];
    stock = json['stock'];
    boxNo = json['box_no'];
    pack = json['pack'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stockTo = json['stock_to'];
    less = json['less'];
    netQuantity = json['net_quantity'];
    calculateType = json['calculate_type'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_sale_return_id'] = this.yarnSaleReturnId;
    data['colour_id'] = this.colourId;
    data['yarn_id'] = this.yarnId;
    data['stock'] = this.stock;
    data['box_no'] = this.boxNo;
    data['pack'] = this.pack;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['stock_to'] = this.stockTo;
    data['less'] = this.less;
    data['net_quantity'] = this.netQuantity;
    data['calculate_type'] = this.calculateType;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
