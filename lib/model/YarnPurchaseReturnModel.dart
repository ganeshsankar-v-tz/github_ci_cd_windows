class YarnPurchaseReturnModel {
  int? id;
  int? supplierId;
  String? supplierName;
  int? firmId;
  String? firmName;
  int? accountType;
  String? accountTypeName;
  String? invoiceNo;
  String? returnNo;
  String? returnDate;
  String? details;
  int? packTotal;
  int? quantityTotal;
  dynamic amountTotal;
  dynamic netTotal;
  dynamic discount;
  dynamic discountRate;
  dynamic discountAmount;
  String? transport;
  dynamic transportRate;
  dynamic transportAmount;
  List<ItemDetails>? itemDetails;

  YarnPurchaseReturnModel(
      {this.id,
        this.supplierId,
        this.supplierName,
        this.firmId,
        this.firmName,
        this.accountType,
        this.accountTypeName,
        this.invoiceNo,
        this.returnNo,
        this.returnDate,
        this.details,
        this.packTotal,
        this.quantityTotal,
        this.amountTotal,
        this.netTotal,
        this.discount,
        this.discountRate,
        this.discountAmount,
        this.transport,
        this.transportRate,
        this.transportAmount,
        this.itemDetails});

  YarnPurchaseReturnModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supplierId = json['supplier_id'];
    supplierName = json['supplier_name'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    accountType = json['account_type'];
    accountTypeName = json['account_type_name'];
    invoiceNo = json['invoice_no'];
    returnNo = json['return_no'];
    returnDate = json['return_date'];
    details = json['details'];
    packTotal = json['pack_total'];
    quantityTotal = json['quantity_total'];
    amountTotal = json['amount_total'];
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
    data['invoice_no'] = this.invoiceNo;
    data['return_no'] = this.returnNo;
    data['return_date'] = this.returnDate;
    data['details'] = this.details;
    data['pack_total'] = this.packTotal;
    data['quantity_total'] = this.quantityTotal;
    data['amount_total'] = this.amountTotal;
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
  int? stock;
  String? boxNo;
  int? pack;
  int? returnQuantity;
  dynamic rate;
  dynamic amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deliverFrom;
  int? less;
  int? netQty;
  String? calculateType;
  String? yarnName;
  String? colorName;

  ItemDetails(
      {this.id,
        this.yarnPurchaseId,
        this.colourId,
        this.yarnId,
        this.stock,
        this.boxNo,
        this.pack,
        this.returnQuantity,
        this.rate,
        this.amount,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.deliverFrom,
        this.less,
        this.netQty,
        this.calculateType,
        this.yarnName,
        this.colorName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnPurchaseId = json['yarn_purchase_id'];
    colourId = json['colour_id'];
    yarnId = json['yarn_id'];
    stock = json['stock'];
    boxNo = json['box_no'];
    pack = json['pack'];
    returnQuantity = json['return_quantity'];
    rate = json['rate'];
    amount = json['amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliverFrom = json['deliver_From'];
    less = json['less'];
    netQty = json['net_qty'];
    calculateType = json['calculate_type'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['yarn_purchase_id'] = this.yarnPurchaseId;
    data['colour_id'] = this.colourId;
    data['yarn_id'] = this.yarnId;
    data['stock'] = this.stock;
    data['box_no'] = this.boxNo;
    data['pack'] = this.pack;
    data['return_quantity'] = this.returnQuantity;
    data['rate'] = this.rate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deliver_From'] = this.deliverFrom;
    data['less'] = this.less;
    data['net_qty'] = this.netQty;
    data['calculate_type'] = this.calculateType;
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    return data;
  }
}
