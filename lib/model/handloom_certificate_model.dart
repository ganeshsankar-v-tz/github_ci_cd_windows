class HandloomCertificateModel {
  int? id;
  int? firmId;
  String? firmName;
  int? customerId;
  String? customerName;
  String? place;
  String? lrRrNo;
  String? dCDate;
  int? totalQty;
  dynamic totalNetAmount;
  List<ItemDetails>? itemDetails;

  HandloomCertificateModel(
      {this.id,
        this.firmId,
        this.firmName,
        this.customerId,
        this.customerName,
        this.place,
        this.lrRrNo,
        this.dCDate,
        this.totalQty,
        this.totalNetAmount,
        this.itemDetails});

  HandloomCertificateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    place = json['place'];
    lrRrNo = json['lr_rr_no'];
    dCDate = json['d_c_date'];
    totalQty = json['total_qty'];
    totalNetAmount = json['total_net_amount'];
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
    data['lr_rr_no'] = this.lrRrNo;
    data['d_c_date'] = this.dCDate;
    data['total_qty'] = this.totalQty;
    data['total_net_amount'] = this.totalNetAmount;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? handloomCertificateId;
  String? date;
  String? invoiceNo;
  int? bundles;
  int? quantity;
  dynamic netAmount;
  int? status;
  String? createdAt;
  String? updatedAt;

  ItemDetails(
      {this.id,
        this.handloomCertificateId,
        this.date,
        this.invoiceNo,
        this.bundles,
        this.quantity,
        this.netAmount,
        this.status,
        this.createdAt,
        this.updatedAt});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handloomCertificateId = json['handloom_certificate_id'];
    date = json['date'];
    invoiceNo = json['invoice_no'];
    bundles = json['bundles'];
    quantity = json['quantity'];
    netAmount = json['net_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['handloom_certificate_id'] = this.handloomCertificateId;
    data['date'] = this.date;
    data['invoice_no'] = this.invoiceNo;
    data['bundles'] = this.bundles;
    data['quantity'] = this.quantity;
    data['net_amount'] = this.netAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
