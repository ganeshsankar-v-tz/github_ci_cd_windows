class JobWorkerDcNoIdByDetails {
  int? id;
  int? jobWorkDeliveryId;
  int? productId;
  int? orderWorkId;
  int? workNo;
  int? pieces;
  int? qty;
  num? wages;
  num? amount;
  String? chDetails;
  String? lotNo;
  String? productName;
  String? designNo;
  String? workName;
  String? inwTyp;

  JobWorkerDcNoIdByDetails(
      {this.id,
      this.jobWorkDeliveryId,
      this.productId,
      this.orderWorkId,
      this.workNo,
      this.pieces,
      this.qty,
      this.wages,
      this.amount,
      this.chDetails,
      this.lotNo,
      this.productName,
      this.designNo,
      this.inwTyp,
      this.workName});

  JobWorkerDcNoIdByDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobWorkDeliveryId = json['job_work_delivery_id'];
    productId = json['product_id'];
    orderWorkId = json['order_work_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    qty = json['qty'];
    wages = json['wages'];
    amount = json['amount'];
    chDetails = json['ch_details'];
    lotNo = json['lot_no'];
    productName = json['product_name'];
    designNo = json['design_no'];
    workName = json['work_name'];
    inwTyp = json['inw_typ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_work_delivery_id'] = jobWorkDeliveryId;
    data['product_id'] = productId;
    data['order_work_id'] = orderWorkId;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['qty'] = qty;
    data['wages'] = wages;
    data['amount'] = amount;
    data['ch_details'] = chDetails;
    data['lot_no'] = lotNo;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['work_name'] = workName;
    data['inw_typ'] = inwTyp;
    return data;
  }
}
