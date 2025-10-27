class ProductInwardFromProcessModel {
  int? id;
  int? firmId;
  String? firmName;
  int? wagesAno;
  String? wagesAccountName;
  int? processorId;
  String? processorName;
  int? dcNo;
  int? deliRecNo;
  String? eDate;
  String? refNo;
  String? details;
  String? pmtSts;
  num? totalWages;
  int? quantity;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  ProductInwardFromProcessModel({
    this.id,
    this.firmId,
    this.firmName,
    this.wagesAno,
    this.wagesAccountName,
    this.processorId,
    this.processorName,
    this.dcNo,
    this.deliRecNo,
    this.eDate,
    this.refNo,
    this.details,
    this.pmtSts,
    this.totalWages,
    this.quantity,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  ProductInwardFromProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    wagesAno = json['wages_ano'];
    wagesAccountName = json['wages_account_name'];
    processorId = json['processor_id'];
    processorName = json['processor_name'];
    dcNo = json['dc_no'];
    deliRecNo = json['deli_rec_no'];
    eDate = json['e_date'];
    refNo = json['ref_no'];
    details = json['details'];
    pmtSts = json['pmt_sts'];
    totalWages = json['total_wages'];
    quantity = json['quantity'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    data['wages_ano'] = wagesAno;
    data['wages_account_name'] = wagesAccountName;
    data['processor_id'] = processorId;
    data['processor_name'] = processorName;
    data['dc_no'] = dcNo;
    data['deli_rec_no'] = deliRecNo;
    data['e_date'] = eDate;
    data['ref_no'] = refNo;
    data['details'] = details;
    data['pmt_sts'] = pmtSts;
    data['total_wages'] = totalWages;
    data['quantity'] = quantity;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? processorInwardId;
  int? productId;
  int? workNo;
  int? pieces;
  num? wages;
  num? amount;
  String? grpNo;
  String? lotSerialNo;
  String? processType;
  int? quantity;
  String? productName;
  String? designNo;

  ItemDetails(
      {this.id,
      this.processorInwardId,
      this.productId,
      this.workNo,
      this.pieces,
      this.wages,
      this.amount,
      this.grpNo,
      this.lotSerialNo,
      this.processType,
      this.quantity,
      this.productName,
      this.designNo});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processorInwardId = json['processor_inward_id'];
    productId = json['product_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    wages = json['wages'];
    amount = json['amount'];
    grpNo = json['grp_no'];
    lotSerialNo = json['lot_serial_no'];
    processType = json['process_type'];
    quantity = json['quantity'];
    productName = json['product_name'];
    designNo = json['design_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['processor_inward_id'] = processorInwardId;
    data['product_id'] = productId;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['wages'] = wages;
    data['amount'] = amount;
    data['grp_no'] = grpNo;
    data['lot_serial_no'] = lotSerialNo;
    data['process_type'] = processType;
    data['quantity'] = quantity;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    return data;
  }
}
