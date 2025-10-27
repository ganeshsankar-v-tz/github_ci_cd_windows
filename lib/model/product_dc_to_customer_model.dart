class ProductDCtoCustomerModel {
  int? id;
  int? firmId;
  String? firmName;
  int? customerId;
  String? customerName;
  String? creatorName;
  int? dcNo;
  String? details;
  String? eDate;
  int? noOfBoxes;
  String? dcType;
  String? bookingPlace;
  String? transport;
  String? createdAt;
  String? updatedAt;
  String? updatedName;
  List<ItemDetails>? itemDetails;

  ProductDCtoCustomerModel(
      {this.id,
      this.firmId,
      this.firmName,
      this.customerId,
      this.customerName,
      this.creatorName,
      this.dcNo,
      this.details,
      this.eDate,
      this.noOfBoxes,
      this.dcType,
      this.bookingPlace,
      this.transport,
      this.createdAt,
      this.updatedAt,
      this.updatedName,
      this.itemDetails});

  ProductDCtoCustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    creatorName = json['creator_name'];
    dcNo = json['dc_no'];
    details = json['details'];
    eDate = json['e_date'];
    noOfBoxes = json['no_of_boxes'];
    dcType = json['dc_type'];
    bookingPlace = json['booking_place'];
    transport = json['transport'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    updatedName = json['updated_name'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firm_id'] = firmId;
    data['firm_name'] = firmName;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['creator_name'] = creatorName;
    data['dc_no'] = dcNo;
    data['details'] = details;
    data['e_date'] = eDate;
    data['no_of_boxes'] = noOfBoxes;
    data['dc_type'] = dcType;
    data['booking_place'] = bookingPlace;
    data['transport'] = transport;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['updated_name'] = updatedName;
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
  int? deliPieces;
  int? deliQty;
  int? rate;
  String? designNo;
  int? workNo;
  num? amount;
  String? details;
  int? stock;
  String? workDetails;
  String? boxNo;
  String? det;
  int? sno;
  int? lotSerialNo;
  String? taxTyp;
  int? cgstPerc;
  int? igstPerc;
  int? sgstPerc;
  int? cessPerc;
  int? discPerc;
  int? discAmount;
  int? grossAmount;
  int? grossRate;
  int? itemWeight;
  int? status;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  String? productName;

  ItemDetails(
      {this.id,
      this.productDcCustomerId,
      this.productId,
      this.deliPieces,
      this.deliQty,
      this.rate,
      this.designNo,
      this.workNo,
      this.amount,
      this.details,
      this.stock,
      this.workDetails,
      this.boxNo,
      this.det,
      this.sno,
      this.lotSerialNo,
      this.taxTyp,
      this.cgstPerc,
      this.igstPerc,
      this.sgstPerc,
      this.cessPerc,
      this.discPerc,
      this.discAmount,
      this.grossAmount,
      this.grossRate,
      this.itemWeight,
      this.status,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt,
      this.productName});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productDcCustomerId = json['product_dc_customer_id'];
    productId = json['product_id'];
    deliPieces = json['deli_pieces'];
    deliQty = json['deli_qty'];
    rate = json['rate'];
    designNo = json['design_no'];
    workNo = json['work_no'];
    amount = json['amount'];
    details = json['details'];
    stock = json['stock'];
    workDetails = json['work_details'];
    boxNo = json['box_no'];
    det = json['det'];
    sno = json['sno'];
    lotSerialNo = json['lot_serial_no'];
    taxTyp = json['tax_typ'];
    cgstPerc = json['cgst_perc'];
    igstPerc = json['igst_perc'];
    sgstPerc = json['sgst_perc'];
    cessPerc = json['cess_perc'];
    discPerc = json['disc_perc'];
    discAmount = json['disc_amount'];
    grossAmount = json['gross_amount'];
    grossRate = json['gross_rate'];
    itemWeight = json['item_weight'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_dc_customer_id'] = productDcCustomerId;
    data['product_id'] = productId;
    data['deli_pieces'] = deliPieces;
    data['deli_qty'] = deliQty;
    data['rate'] = rate;
    data['design_no'] = designNo;
    data['work_no'] = workNo;
    data['amount'] = amount;
    data['details'] = details;
    data['stock'] = stock;
    data['work_details'] = workDetails;
    data['box_no'] = boxNo;
    data['det'] = det;
    data['sno'] = sno;
    data['lot_serial_no'] = lotSerialNo;
    data['tax_typ'] = taxTyp;
    data['cgst_perc'] = cgstPerc;
    data['igst_perc'] = igstPerc;
    data['sgst_perc'] = sgstPerc;
    data['cess_perc'] = cessPerc;
    data['disc_perc'] = discPerc;
    data['disc_amount'] = discAmount;
    data['gross_amount'] = grossAmount;
    data['gross_rate'] = grossRate;
    data['item_weight'] = itemWeight;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['product_name'] = productName;
    return data;
  }
}
