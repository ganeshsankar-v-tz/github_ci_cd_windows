class ProductDeliveryToJobWorkerModel {
  int? id;
  int? firmId;
  String? firmName;
  int? dcNo;
  String? dcType;
  int? jobWorkerId;
  String? jobWorkerName;
  String? eDate;
  String? details;
  int? noOfBales;
  String? transport;
  String? al1Typ;
  int? al1Ano;
  String? al1AnoName;
  num? al1Amount;
  num? al1Perc;
  String? al2Typ;
  int? al2Ano;
  String? al2AnoName;
  num? al2Amount;
  num? al2Perc;
  String? al3Typ;
  int? al3Ano;
  String? al3AnoName;
  num? al3Amount;
  num? al3Perc;
  String? al4Typ;
  int? al4Ano;
  String? al4AnoName;
  num? al4Amount;
  num? al4Perc;
  num? netTotal;
  num? qty;
  int? totalInwardQty;
  int? totalDeliveryQty;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  ProductDeliveryToJobWorkerModel({
    this.id,
    this.firmId,
    this.firmName,
    this.dcNo,
    this.dcType,
    this.jobWorkerId,
    this.jobWorkerName,
    this.eDate,
    this.details,
    this.noOfBales,
    this.transport,
    this.al1Typ,
    this.al1Ano,
    this.al1AnoName,
    this.al1Amount,
    this.al1Perc,
    this.al2Typ,
    this.al2Ano,
    this.al2AnoName,
    this.al2Amount,
    this.al2Perc,
    this.al3Typ,
    this.al3Ano,
    this.al3AnoName,
    this.al3Amount,
    this.al3Perc,
    this.al4Typ,
    this.al4Ano,
    this.al4AnoName,
    this.al4Amount,
    this.al4Perc,
    this.netTotal,
    this.qty,
    this.totalInwardQty,
    this.totalDeliveryQty,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  ProductDeliveryToJobWorkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    dcNo = json['dc_no'];
    dcType = json['dc_type'];
    jobWorkerId = json['job_worker_id'];
    jobWorkerName = json['job_worker_name'];
    eDate = json['e_date'];
    details = json['details'];
    noOfBales = json['no_of_bales'];
    transport = json['transport'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1AnoName = json['al1_ano_name'];
    al1Amount = json['al1_amount'];
    al1Perc = json['al1_perc'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2AnoName = json['al2_ano_name'];
    al2Amount = json['al2_amount'];
    al2Perc = json['al2_perc'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3AnoName = json['al3_ano_name'];
    al3Amount = json['al3_amount'];
    al3Perc = json['al3_perc'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4AnoName = json['al4_ano_name'];
    al4Amount = json['al4_amount'];
    al4Perc = json['al4_perc'];
    netTotal = json['net_total'];
    qty = json['qty'];
    totalInwardQty = json['total_inward_qty'];
    totalDeliveryQty = json['total_delivery_qty'];
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
    data['dc_no'] = dcNo;
    data['dc_type'] = dcType;
    data['job_worker_id'] = jobWorkerId;
    data['job_worker_name'] = jobWorkerName;
    data['e_date'] = eDate;
    data['details'] = details;
    data['no_of_bales'] = noOfBales;
    data['transport'] = transport;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_ano_name'] = al1AnoName;
    data['al1_amount'] = al1Amount;
    data['al1_perc'] = al1Perc;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_ano_name'] = al2AnoName;
    data['al2_amount'] = al2Amount;
    data['al2_perc'] = al2Perc;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_ano_name'] = al3AnoName;
    data['al3_amount'] = al3Amount;
    data['al3_perc'] = al3Perc;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al4_ano_name'] = al4AnoName;
    data['al4_amount'] = al4Amount;
    data['al4_perc'] = al4Perc;
    data['net_total'] = netTotal;
    data['qty'] = qty;
    data['total_inward_qty'] = totalInwardQty;
    data['total_delivery_qty'] = totalDeliveryQty;
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
  int? jobWorkDeliveryId;
  int? productId;
  int? orderWorkid;
  int? workNo;
  int? pieces;
  int? qty;
  String? lotSerialNo;
  num? rate;
  num? amount;
  String? chDetails;
  String? lotNo;
  String? productName;
  String? designNo;
  String? workName;
  String? agentName;

  ItemDetails({
    this.id,
    this.jobWorkDeliveryId,
    this.productId,
    this.orderWorkid,
    this.workNo,
    this.pieces,
    this.qty,
    this.lotSerialNo,
    this.rate,
    this.amount,
    this.chDetails,
    this.lotNo,
    this.productName,
    this.workName,
    this.designNo,
    this.agentName,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobWorkDeliveryId = json['job_work_delivery_id'];
    productId = json['product_id'];
    orderWorkid = json['order_work_id'];
    workNo = json['work_no'];
    pieces = json['pieces'];
    qty = json['qty'];
    lotSerialNo = json['lot_serial_no'];
    rate = json['rate'];
    amount = json['amount'];
    chDetails = json['ch_details'];
    lotNo = json['lot_no'];
    productName = json['product_name'];
    designNo = json['design_no'];
    workName = json['work_name'];
    agentName = json['agent_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_work_delivery_id'] = jobWorkDeliveryId;
    data['product_id'] = productId;
    data['order_work_id'] = orderWorkid;
    data['work_no'] = workNo;
    data['pieces'] = pieces;
    data['qty'] = qty;
    data['lot_serial_no'] = lotSerialNo;
    data['rate'] = rate;
    data['amount'] = amount;
    data['ch_details'] = chDetails;
    data['lot_no'] = lotNo;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['work_name'] = workName;
    data['agent_name'] = agentName;
    return data;
  }
}
