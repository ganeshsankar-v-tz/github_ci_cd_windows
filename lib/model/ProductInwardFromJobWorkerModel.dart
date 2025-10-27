class ProductInwardFromJobWorkerModel {
  int? id;
  int? firmId;
  String? firmName;
  int? wagesAno;
  String? wagesAccountName;
  int? jobWorkerId;
  String? jobWorkerName;
  String? eDate;
  String? details;
  int? dcNo;
  String? refNo;
  int? deliRecNo;
  String? pmtSts;
  num? totalAmount;
  num? qty;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  ProductInwardFromJobWorkerModel({
    this.id,
    this.firmId,
    this.firmName,
    this.wagesAno,
    this.wagesAccountName,
    this.jobWorkerId,
    this.jobWorkerName,
    this.eDate,
    this.details,
    this.dcNo,
    this.deliRecNo,
    this.refNo,
    this.pmtSts,
    this.totalAmount,
    this.qty,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  ProductInwardFromJobWorkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    wagesAno = json['wages_ano'];
    wagesAccountName = json['wages_account_name'];
    jobWorkerId = json['job_worker_id'];
    jobWorkerName = json['job_worker_name'];
    eDate = json['e_date'];
    details = json['details'];
    dcNo = json['dc_no'];
    deliRecNo = json['deli_rec_no'];
    refNo = json['ref_no'];
    pmtSts = json['pmt_sts'];
    totalAmount = json['total_amount'];
    qty = json['qty'];
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
    data['job_worker_id'] = jobWorkerId;
    data['job_worker_name'] = jobWorkerName;
    data['e_date'] = eDate;
    data['details'] = details;
    data['deli_rec_no'] = deliRecNo;
    data['dc_no'] = dcNo;
    data['ref_no'] = refNo;
    data['pmt_sts'] = pmtSts;
    data['total_amount'] = totalAmount;
    data['qty'] = qty;
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
  int? jobWorkInwardId;
  int? orderWorkId;
  int? productId;
  int? workNo;
  int? pieces;
  int? qty;
  int? rowNo;
  num? wages;
  num? amount;
  int? grpNo;
  int? lotSerialNo;
  String? inwTyp;
  String? lotNo;
  String? productName;
  String? designNo;
  String? workName;

  ItemDetails(
      {this.id,
      this.jobWorkInwardId,
      this.orderWorkId,
      this.productId,
      this.workNo,
      this.pieces,
      this.qty,
      this.rowNo,
      this.wages,
      this.amount,
      this.grpNo,
      this.lotSerialNo,
      this.inwTyp,
      this.lotNo,
      this.productName,
      this.workName,
      this.designNo});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobWorkInwardId = json['job_work_inward_id'];
    orderWorkId = json['order_work_id'];
    productId = json['product_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    qty = json['qty'];
    rowNo = json['row_no'];
    wages = json['wages'];
    amount = json['amount'];
    grpNo = json['grp_no'];
    lotSerialNo = json['lot_serial_no'];
    inwTyp = json['inw_typ'];
    lotNo = json['lot_no'];
    productName = json['product_name'];
    designNo = json['design_no'];
    workName = json['work_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_work_inward_id'] = jobWorkInwardId;
    data['order_work_id'] = orderWorkId;
    data['product_id'] = productId;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['qty'] = qty;
    data['row_no'] = rowNo;
    data['wages'] = wages;
    data['amount'] = amount;
    data['grp_no'] = grpNo;
    data['lot_serial_no'] = lotSerialNo;
    data['inw_typ'] = inwTyp;
    data['lot_no'] = lotNo;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['work_name'] = workName;
    return data;
  }
}
