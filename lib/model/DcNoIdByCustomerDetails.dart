class DcNoIdByCustomerDetails {
  int? id;
  int? customerId;
  String? customerName;
  int? bales;
  String? transport;
  List<ItemDetails>? itemDetails;

  DcNoIdByCustomerDetails(
      {this.id,
      this.customerId,
      this.customerName,
      this.bales,
      this.transport,
      this.itemDetails});

  DcNoIdByCustomerDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    bales = json['bales'];
    transport = json['transport'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['bales'] = bales;
    data['transport'] = transport;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productDcCustomerId;
  int? productId;
  String? designNo;
  int? workNo;
  int? deliQty;
  int? deliPieces;
  num? rate;
  num? amount;
  String? productName;

  ItemDetails(
      {this.id,
      this.productDcCustomerId,
      this.productId,
      this.designNo,
      this.workNo,
      this.deliQty,
      this.rate,
      this.amount,
      this.deliPieces,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productDcCustomerId = json['product_dc_customer_id'];
    productId = json['product_id'];
    designNo = json['design_no'];
    workNo = json['work_no'];
    deliQty = json['deli_qty'];
    rate = json['rate'];
    amount = json['amount'];
    deliPieces = json['deli_pieces'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_dc_customer_id'] = productDcCustomerId;
    data['product_id'] = productId;
    data['design_no'] = designNo;
    data['work_no'] = workNo;
    data['deli_qty'] = deliQty;
    data['rate'] = rate;
    data['amount'] = amount;
    data['deli_pieces'] = deliPieces;
    data['product_name'] = productName;
    return data;
  }
}
