class YarnStockReportHistoryModel {
  int? id;
  int? supplierId;
  String? supplierName;
  int? firmId;
  String? firmName;
  int? accountType;
  String? accountTypeName;
  String? purchaseNo;
  String? invoiceNo;
  String? purchaseDate;
  String? details;
  int? packTotal;
  dynamic amountTotal;
  int? totalNetQty;
  dynamic netTotal;
  String? discount;
  dynamic discountRate;
  dynamic discountAmount;
  String? transport;
  dynamic transportRate;
  dynamic transportAmount;
  List<ItemDetails>? itemDetails;

  YarnStockReportHistoryModel(
      {this.id,
      this.supplierId,
      this.supplierName,
      this.firmId,
      this.firmName,
      this.accountType,
      this.accountTypeName,
      this.purchaseNo,
      this.invoiceNo,
      this.purchaseDate,
      this.details,
      this.packTotal,
      this.amountTotal,
      this.totalNetQty,
      this.netTotal,
      this.discount,
      this.discountRate,
      this.discountAmount,
      this.transport,
      this.transportRate,
      this.transportAmount,
      this.itemDetails});

  YarnStockReportHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    accountType = json['account_type'];
    accountTypeName = json['account_type_name'];
    purchaseNo = json['purchase_no'];
    invoiceNo = json['invoice_no'];
    purchaseDate = json['purchase_date'];
    details = json['details'];
    packTotal = json['pack_total'];
    amountTotal = json['amount_total'];
    totalNetQty = json['total_net_qty'];
    netTotal = json['net_total'];
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
    data['supplier_id'] = this.supplierId;
    data['supplier_name'] = this.supplierName;
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['account_type'] = this.accountType;
    data['account_type_name'] = this.accountTypeName;
    data['purchase_no'] = this.purchaseNo;
    data['invoice_no'] = this.invoiceNo;
    data['purchase_date'] = this.purchaseDate;
    data['details'] = this.details;
    data['pack_total'] = this.packTotal;
    data['amount_total'] = this.amountTotal;
    data['total_net_qty'] = this.totalNetQty;
    data['net_total'] = this.netTotal;
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
  int? yarnPurchaseId;
  int? colourId;
  int? yarnId;
  String? stockTo;
  String? boxNo;
  int? itemQuantity;
  dynamic rate;
  dynamic? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? less;
  String? calculateType;
  int? pack;
  int? netQuantity;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
      this.yarnPurchaseId,
      this.colourId,
      this.yarnId,
      this.stockTo,
      this.boxNo,
      this.itemQuantity,
      this.rate,
      this.amount,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.less,
      this.calculateType,
      this.pack,
      this.netQuantity,
      this.yarnName,
      this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnPurchaseId = json['yarn_purchase_id'];
    colourId = json['colour_id'];
    yarnId = json['yarn_id'];
    stockTo = json['stock_to'];
    boxNo = json['box_no'];
    itemQuantity = json['item_quantity'];
    rate = json['rate'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    less = json['less'];
    calculateType = json['calculate_type'];
    pack = json['pack'];
    netQuantity = json['net_quantity'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_purchase_id'] = this.yarnPurchaseId;
    data['colour_id'] = this.colourId;
    data['yarn_id'] = this.yarnId;
    data['stock_to'] = this.stockTo;
    data['box_no'] = this.boxNo;
    data['item_quantity'] = this.itemQuantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['less'] = this.less;
    data['calculate_type'] = this.calculateType;
    data['pack'] = this.pack;
    data['net_quantity'] = this.netQuantity;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
