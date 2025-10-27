class ProductReturnFromCustomerModel {
  int? id;
  int? firmId;
  String? firmName;
  int? customerId;
  String? customerName;
  String? place;
  String? dcNo;
  String? dcDate;
  String? details;
  int? totelPieces;
  int? totelQuantity;
  List<ItemDetails>? itemDetails;

  ProductReturnFromCustomerModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.customerId,
      this.customerName,
      this.place,
      this.dcNo,
      this.dcDate,
      this.details,
      this.totelPieces,
      this.totelQuantity,
      this.itemDetails});

  ProductReturnFromCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    place = json['place'];
    dcNo = json['dc_no'];
    dcDate = json['dc_date'];
    details = json['details'];
    totelPieces = json['totel_pieces'];
    totelQuantity = json['totel_quantity'];
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
    data['customer_name'] = this.customerName;
    data['place'] = this.place;
    data['dc_no'] = this.dcNo;
    data['dc_date'] = this.dcDate;
    data['details'] = this.details;
    data['totel_pieces'] = this.totelPieces;
    data['totel_quantity'] = this.totelQuantity;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? productReturnFromCustomerId;
  int? productId;
  String? desginNo;
  String? work;
  int? pieces;
  int? quantity;
  dynamic rate;
  int? delivered;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? workDetails;
  String? productName;

  ItemDetails(
      {this.id,
      this.productReturnFromCustomerId,
      this.productId,
      this.desginNo,
      this.work,
      this.pieces,
      this.quantity,
      this.rate,
      this.delivered,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.workDetails,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productReturnFromCustomerId = json['product_return_from_customer_id'];
    productId = json['product_id'];
    desginNo = json['desgin_no'];
    work = json['work'];
    pieces = json['pieces'];
    quantity = json['quantity'];
    rate = json['rate'];
    delivered = json['delivered'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    workDetails = json['work_details'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_return_from_customer_id'] = this.productReturnFromCustomerId;
    data['product_id'] = this.productId;
    data['desgin_no'] = this.desginNo;
    data['work'] = this.work;
    data['pieces'] = this.pieces;
    data['quantity'] = this.quantity;
    data['rate'] = this.rate;
    data['delivered'] = this.delivered;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    data['work_details'] = this.workDetails;
    data['product_name'] = this.productName;
    return data;
  }
}
