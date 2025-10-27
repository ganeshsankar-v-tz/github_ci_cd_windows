class WarpPurchaseModel {
  int? id;
  int? firmId;
  String? firmName;
  int? slipNo;
  String? eDate;
  int? supplierId;
  String? suplierName;
  String? actBillDate;
  int? paAno;
  String? purchaseAccountName;
  String? details;
  int? dueDays;
  String? al1Typ;
  int? al1Ano;
  num? al1Amount;
  num? al1Perc;
  String? al2Typ;
  int? al2Ano;
  num? al2Amount;
  num? al2Perc;
  String? al3Typ;
  int? al3Ano;
  num? al3Amount;
  num? al3Perc;
  String? al4Typ;
  int? al4Ano;
  String? al1AnoName;
  String? al2AnoName;
  String? al3AnoName;
  String? al4AnoName;
  num? al4Amount;
  num? al4Perc;
  num? roundOff;
  num? netTotal;
  String? purEmptyStatus;
  int? purBeam;
  int? purBobbin;
  int? purSheet;
  num? purEmptyAmount;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  WarpPurchaseModel({
    this.id,
    this.firmId,
    this.firmName,
    this.slipNo,
    this.eDate,
    this.supplierId,
    this.suplierName,
    this.actBillDate,
    this.paAno,
    this.purchaseAccountName,
    this.details,
    this.dueDays,
    this.al1Typ,
    this.al1Ano,
    this.al1Amount,
    this.al1Perc,
    this.al2Typ,
    this.al2Ano,
    this.al2Amount,
    this.al2Perc,
    this.al3Typ,
    this.al3Ano,
    this.al3Amount,
    this.al3Perc,
    this.al4Typ,
    this.al4Ano,
    this.al4Amount,
    this.al4Perc,
    this.roundOff,
    this.netTotal,
    this.purEmptyStatus,
    this.purBeam,
    this.purBobbin,
    this.purSheet,
    this.purEmptyAmount,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  WarpPurchaseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    slipNo = json['slip_no'];
    eDate = json['e_date'];
    supplierId = json['supplier_id'];
    suplierName = json['suplier_name'];
    actBillDate = json['act_bill_date'];
    paAno = json['pa_ano'];
    purchaseAccountName = json['purchase_account_name'];
    details = json['details'];
    dueDays = json['due_days'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Amount = json['al1_amount'];
    al1Perc = json['al1_perc'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Amount = json['al2_amount'];
    al2Perc = json['al2_perc'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Amount = json['al3_amount'];
    al3Perc = json['al3_perc'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
    al4Amount = json['al4_amount'];
    al4Perc = json['al4_perc'];
    roundOff = json['round_off'];
    netTotal = json['net_total'];
    purEmptyStatus = json['pur_empty_status'];
    purBeam = json['pur_beam'];
    purBobbin = json['pur_bobbin'];
    purSheet = json['pur_sheet'];
    purEmptyAmount = json['pur_empty_amount'];
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
    data['slip_no'] = slipNo;
    data['e_date'] = eDate;
    data['supplier_id'] = supplierId;
    data['suplier_name'] = suplierName;
    data['act_bill_date'] = actBillDate;
    data['pa_ano'] = paAno;
    data['purchase_account_name'] = purchaseAccountName;
    data['details'] = details;
    data['due_days'] = dueDays;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_amount'] = al1Amount;
    data['al1_perc'] = al1Perc;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_amount'] = al2Amount;
    data['al2_perc'] = al2Perc;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_amount'] = al3Amount;
    data['al3_perc'] = al3Perc;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al1_ano_name'] = al1AnoName;
    data['al2_ano_name'] = al2AnoName;
    data['al3_ano_name'] = al3AnoName;
    data['al4_ano_name'] = al4AnoName;
    data['al4_amount'] = al4Amount;
    data['al4_perc'] = al4Perc;
    data['round_off'] = roundOff;
    data['net_total'] = netTotal;
    data['pur_empty_status'] = purEmptyStatus;
    data['pur_beam'] = purBeam;
    data['pur_bobbin'] = purBobbin;
    data['pur_sheet'] = purSheet;
    data['pur_empty_amount'] = purEmptyAmount;
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
  int? wrapPurchaseId;
  int? orderRecNo;
  String? warpId;
  int? warpDesignId;
  int? qty;
  num? metre;
  String? warpColor;
  String? transport;
  String? emptyType;
  int? emptyQty;
  num? amount;
  int? rowNo;
  int? sheet;
  String? wrapCondition;
  num? weight;
  num? rate;
  String? calculateType;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? createdBy;
  String? updatedBy;
  String? warpDesignName;
  String? warpType;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;
  int? warpDelivery;

  ItemDetails({
    this.id,
    this.wrapPurchaseId,
    this.orderRecNo,
    this.warpId,
    this.warpDesignId,
    this.qty,
    this.metre,
    this.warpColor,
    this.transport,
    this.emptyType,
    this.emptyQty,
    this.amount,
    this.rowNo,
    this.sheet,
    this.wrapCondition,
    this.weight,
    this.rate,
    this.calculateType,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.warpType,
    this.warpDesignName,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
    this.warpDelivery,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrapPurchaseId = json['wrap_purchase_id'];
    orderRecNo = json['order_rec_no'];
    warpId = json['warp_id'];
    warpDesignId = json['warp_design_id'];
    qty = json['qty'];
    metre = json['metre'];
    warpColor = json['warp_color'];
    transport = json['transport'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    amount = json['amount'];
    rowNo = json['row_no'];
    sheet = json['sheet'];
    wrapCondition = json['wrap_condition'];
    weight = json['weight'];
    rate = json['rate'];
    calculateType = json['calculate_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
    warpDelivery = json["warp_delivery"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wrap_purchase_id'] = wrapPurchaseId;
    data['order_rec_no'] = orderRecNo;
    data['warp_id'] = warpId;
    data['warp_design_id'] = warpDesignId;
    data['qty'] = qty;
    data['metre'] = metre;
    data['warp_color'] = warpColor;
    data['transport'] = transport;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['amount'] = amount;
    data['row_no'] = rowNo;
    data['sheet'] = sheet;
    data['wrap_condition'] = wrapCondition;
    data['weight'] = weight;
    data['rate'] = rate;
    data['calculate_type'] = calculateType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    data['warp_for'] = warpFor;
    data['warp_tracker_id'] = warpTrackerId;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    data['warp_delivery'] = warpDelivery;
    return data;
  }
}
