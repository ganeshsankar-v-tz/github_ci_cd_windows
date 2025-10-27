class WarpPurchaseReturnSlipNoDropdown {
  dynamic? id;
  int? firmId;
  dynamic slipNo;
  int? supplierId;
  String? eDate;
  int? paAno;
  String? details;
  num? netTotal;
  dynamic refNo;
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
  num? al4Amount;
  num? al4Perc;
  num? roundOff;
  int? acNo;
  int? dueDays;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  dynamic transNo;
  dynamic supplierCno;
  dynamic al1Cf;
  dynamic al2Cf;
  dynamic al3Cf;
  dynamic al4Cf;
  String? actBillDate;
  dynamic fillStatus;
  dynamic fillingInfo;
  dynamic purEmptyTn;
  dynamic al2Tye;
  dynamic paCno;
  dynamic al1Cno;
  dynamic al2Cno;
  dynamic al3Cno;
  dynamic al4Cno;
  dynamic purBeam;
  dynamic purBobbin;
  dynamic purEmptyAmount;
  dynamic purEmptyStatus;
  dynamic purSheet;
  String? suplierName;
  String? purchaseAccountName;
  String? firmName;
  String? creatorName;
  String? updatedName;
  String? al1AnoName;
  String? al2AnoName;
  String? al3AnoName;
  String? al4AnoName;
  List<ItemDetails>? itemDetails;

  WarpPurchaseReturnSlipNoDropdown({
    this.id,
    this.firmId,
    this.slipNo,
    this.supplierId,
    this.eDate,
    this.paAno,
    this.details,
    this.netTotal,
    this.refNo,
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
    this.acNo,
    this.dueDays,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.transNo,
    this.supplierCno,
    this.al1Cf,
    this.al2Cf,
    this.al3Cf,
    this.al4Cf,
    this.actBillDate,
    this.fillStatus,
    this.fillingInfo,
    this.purEmptyTn,
    this.al2Tye,
    this.paCno,
    this.al1Cno,
    this.al2Cno,
    this.al3Cno,
    this.al4Cno,
    this.purBeam,
    this.purBobbin,
    this.purEmptyAmount,
    this.purEmptyStatus,
    this.purSheet,
    this.suplierName,
    this.purchaseAccountName,
    this.firmName,
    this.creatorName,
    this.updatedName,
    this.al1AnoName,
    this.al2AnoName,
    this.al3AnoName,
    this.al4AnoName,
    this.itemDetails,
  });

  WarpPurchaseReturnSlipNoDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    slipNo = json['slip_no'];
    supplierId = json['supplier_id'];
    eDate = json['e_date'];
    paAno = json['pa_ano'];
    details = json['details'];
    netTotal = json['net_total'];
    refNo = json['ref_no'];
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
    al4Amount = json['al4_amount'];
    al4Perc = json['al4_perc'];
    roundOff = json['round_off'];
    acNo = json['ac_no'];
    dueDays = json['due_days'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    transNo = json['trans_no'];
    supplierCno = json['supplier_cno'];
    al1Cf = json['al1_cf'];
    al2Cf = json['al2_cf'];
    al3Cf = json['al3_cf'];
    al4Cf = json['al4_cf'];
    actBillDate = json['act_bill_date'];
    fillStatus = json['fill_status'];
    fillingInfo = json['filling_info'];
    purEmptyTn = json['pur_empty_tn'];
    al2Tye = json['al2_tye'];
    paCno = json['pa_cno'];
    al1Cno = json['al1_cno'];
    al2Cno = json['al2_cno'];
    al3Cno = json['al3_cno'];
    al4Cno = json['al4_cno'];
    purBeam = json['pur_beam'];
    purBobbin = json['pur_bobbin'];
    purEmptyAmount = json['pur_empty_amount'];
    purEmptyStatus = json['pur_empty_status'];
    purSheet = json['pur_sheet'];
    suplierName = json['suplier_name'];
    purchaseAccountName = json['purchase_account_name'];
    firmName = json['firm_name'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['firm_id'] = firmId;
    data['slip_no'] = slipNo;
    data['supplier_id'] = supplierId;
    data['e_date'] = eDate;
    data['pa_ano'] = paAno;
    data['details'] = details;
    data['net_total'] = netTotal;
    data['ref_no'] = refNo;
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
    data['al4_amount'] = al4Amount;
    data['al4_perc'] = al4Perc;
    data['round_off'] = roundOff;
    data['ac_no'] = acNo;
    data['due_days'] = dueDays;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['trans_no'] = transNo;
    data['supplier_cno'] = supplierCno;
    data['al1_cf'] = al1Cf;
    data['al2_cf'] = al2Cf;
    data['al3_cf'] = al3Cf;
    data['al4_cf'] = al4Cf;
    data['act_bill_date'] = actBillDate;
    data['fill_status'] = fillStatus;
    data['filling_info'] = fillingInfo;
    data['pur_empty_tn'] = purEmptyTn;
    data['al2_tye'] = al2Tye;
    data['pa_cno'] = paCno;
    data['al1_cno'] = al1Cno;
    data['al2_cno'] = al2Cno;
    data['al3_cno'] = al3Cno;
    data['al4_cno'] = al4Cno;
    data['pur_beam'] = purBeam;
    data['pur_bobbin'] = purBobbin;
    data['pur_empty_amount'] = purEmptyAmount;
    data['pur_empty_status'] = purEmptyStatus;
    data['pur_sheet'] = purSheet;
    data['suplier_name'] = suplierName;
    data['purchase_account_name'] = purchaseAccountName;
    data['firm_name'] = firmName;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['al1_ano_name'] = al1AnoName;
    data['al2_ano_name'] = al2AnoName;
    data['al3_ano_name'] = al3AnoName;
    data['al4_ano_name'] = al4AnoName;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$slipNo";
  }
}

class ItemDetails {
  int? id;
  int? wrapPurchaseId;
  String? warpId;
  int? warpDesignId;
  String? emptyType;
  String? wrapCondition;
  String? calculateType;
  int? orderRecNo;
  String? orderYn;
  int? qty;
  num? metre;
  String? warpColor;
  int? emptyQty;
  num? amount;
  int? sheet;
  num? weight;
  num? rate;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;
  String? warpDesignName;
  String? warpType;
  String? weaverName;
  String? loomNo;
  int? warpDelivery;

  ItemDetails({
    this.id,
    this.wrapPurchaseId,
    this.warpId,
    this.warpDesignId,
    this.emptyType,
    this.wrapCondition,
    this.calculateType,
    this.orderRecNo,
    this.orderYn,
    this.qty,
    this.metre,
    this.warpColor,
    this.emptyQty,
    this.amount,
    this.sheet,
    this.weight,
    this.rate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.weaverId,
    this.subWeaverNo,
    this.warpTrackerId,
    this.warpFor,
    this.warpDesignName,
    this.warpType,
    this.weaverName,
    this.loomNo,
    this.warpDelivery,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrapPurchaseId = json['wrap_purchase_id'];
    warpId = json['warp_id'];
    warpDesignId = json['warp_design_id'];
    emptyType = json['empty_type'];
    wrapCondition = json['wrap_condition'];
    calculateType = json['calculate_type'];
    orderRecNo = json['order_rec_no'];
    orderYn = json['order_yn'];
    qty = json['qty'];
    metre = json['metre'];
    warpColor = json['warp_color'];
    emptyQty = json['empty_qty'];
    amount = json['amount'];
    sheet = json['sheet'];
    weight = json['weight'];
    rate = json['rate'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    warpTrackerId = json['warp_tracker_id'];
    warpFor = json['warp_for'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
    warpDelivery = json['warp_delivery'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['wrap_purchase_id'] = wrapPurchaseId;
    data['warp_id'] = warpId;
    data['warp_design_id'] = warpDesignId;
    data['empty_type'] = emptyType;
    data['wrap_condition'] = wrapCondition;
    data['calculate_type'] = calculateType;
    data['order_rec_no'] = orderRecNo;
    data['order_yn'] = orderYn;
    data['qty'] = qty;
    data['metre'] = metre;
    data['warp_color'] = warpColor;
    data['empty_qty'] = emptyQty;
    data['amount'] = amount;
    data['sheet'] = sheet;
    data['weight'] = weight;
    data['rate'] = rate;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['warp_tracker_id'] = warpTrackerId;
    data['warp_for'] = warpFor;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    data['warp_delivery'] = warpDelivery;
    return data;
  }
}
