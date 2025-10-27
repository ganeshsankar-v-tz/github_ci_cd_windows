class DebitNoteSlipNoDropdown {
  dynamic id;
  int? firmId;
  int? supplierId;
  String? purchaseDate;
  int? paAno;
  String? invoiceNo;
  String? details;
  String? acNo;
  String? al1Typ;
  int? al1Ano;
  num? al1Amount;
  String? al2Typ;
  int? al2Ano;
  num? al2Amount;
  String? al3Typ;
  int? al3Ano;
  num? al3Amount;
  String? al4Typ;
  int? al4Ano;
  num? al4Amount;
  num? netTotal;
  num? totalNetQty;
  dynamic slipNo;
  dynamic supplierCno;
  dynamic paCno;
  dynamic al1Cno;
  dynamic al2Cno;
  dynamic al3Cno;
  dynamic al4Cno;
  dynamic transNo;
  String? createdAt;
  String? updatedAt;
  int? status;
  num? al1Perc;
  num? al2Perc;
  num? al3Perc;
  num? al4Perc;
  String? slipChar;
  num? roundOff;
  dynamic transPerUnit;
  dynamic purtyp;
  dynamic dueDays;
  dynamic al1Cf;
  dynamic al2Cf;
  dynamic al3Cf;
  dynamic al4Cf;
  dynamic actBillDate;
  dynamic fillingStatus;
  dynamic fillingInfo;
  int? createdBy;
  dynamic updatedBy;
  String? supplierName;
  String? firmName;
  String? creatorName;
  dynamic updatedName;
  String? paAnoName;
  String? al1AnoName;
  String? al2AnoName;
  dynamic al3AnoName;
  dynamic al4AnoName;
  num? netQty;
  int? pack;
  List<ItemDetails>? itemDetails;

  DebitNoteSlipNoDropdown(
      {this.id,
      this.firmId,
      this.supplierId,
      this.purchaseDate,
      this.paAno,
      this.invoiceNo,
      this.details,
      this.acNo,
      this.al1Typ,
      this.al1Ano,
      this.al1Amount,
      this.al2Typ,
      this.al2Ano,
      this.al2Amount,
      this.al3Typ,
      this.al3Ano,
      this.al3Amount,
      this.al4Typ,
      this.al4Ano,
      this.al4Amount,
      this.netTotal,
      this.totalNetQty,
      this.slipNo,
      this.supplierCno,
      this.paCno,
      this.al1Cno,
      this.al2Cno,
      this.al3Cno,
      this.al4Cno,
      this.transNo,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.al1Perc,
      this.al2Perc,
      this.al3Perc,
      this.al4Perc,
      this.slipChar,
      this.roundOff,
      this.transPerUnit,
      this.purtyp,
      this.dueDays,
      this.al1Cf,
      this.al2Cf,
      this.al3Cf,
      this.al4Cf,
      this.actBillDate,
      this.fillingStatus,
      this.fillingInfo,
      this.createdBy,
      this.updatedBy,
      this.supplierName,
      this.firmName,
      this.creatorName,
      this.updatedName,
      this.paAnoName,
      this.al1AnoName,
      this.al2AnoName,
      this.al3AnoName,
      this.al4AnoName,
      this.netQty,
      this.pack,
      this.itemDetails});

  DebitNoteSlipNoDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    supplierId = json['supplier_id'];
    purchaseDate = json['purchase_date'];
    paAno = json['pa_ano'];
    invoiceNo = json['invoice_no'];
    details = json['details'];
    acNo = json['ac_no'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Amount = json['al1_amount'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Amount = json['al2_amount'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Amount = json['al3_amount'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4Amount = json['al4_amount'];
    netTotal = json['net_total'];
    totalNetQty = json['total_net_qty'];
    slipNo = json['slip_no'];
    supplierCno = json['supplier_cno'];
    paCno = json['pa_cno'];
    al1Cno = json['al1_cno'];
    al2Cno = json['al2_cno'];
    al3Cno = json['al3_cno'];
    al4Cno = json['al4_cno'];
    transNo = json['trans_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    al1Perc = json['al1_perc'];
    al2Perc = json['al2_perc'];
    al3Perc = json['al3_perc'];
    al4Perc = json['al4_perc'];
    slipChar = json['slip_char'];
    roundOff = json['round_off'];
    transPerUnit = json['trans_per_unit'];
    purtyp = json['purtyp'];
    dueDays = json['due_days'];
    al1Cf = json['al1_cf'];
    al2Cf = json['al2_cf'];
    al3Cf = json['al3_cf'];
    al4Cf = json['al4_cf'];
    actBillDate = json['act_bill_date'];
    fillingStatus = json['filling_status'];
    fillingInfo = json['filling_info'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    supplierName = json['supplier_name'];
    firmName = json['firm_name'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    paAnoName = json['pa_ano_name'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
    netQty = json['net_qty'];
    pack = json['pack'];
    if (json['item_details'] != dynamic) {
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
    data['supplier_id'] = supplierId;
    data['purchase_date'] = purchaseDate;
    data['pa_ano'] = paAno;
    data['invoice_no'] = invoiceNo;
    data['details'] = details;
    data['ac_no'] = acNo;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_amount'] = al1Amount;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_amount'] = al2Amount;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_amount'] = al3Amount;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al4_amount'] = al4Amount;
    data['net_total'] = netTotal;
    data['total_net_qty'] = totalNetQty;
    data['slip_no'] = slipNo;
    data['supplier_cno'] = supplierCno;
    data['pa_cno'] = paCno;
    data['al1_cno'] = al1Cno;
    data['al2_cno'] = al2Cno;
    data['al3_cno'] = al3Cno;
    data['al4_cno'] = al4Cno;
    data['trans_no'] = transNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['al1_perc'] = al1Perc;
    data['al2_perc'] = al2Perc;
    data['al3_perc'] = al3Perc;
    data['al4_perc'] = al4Perc;
    data['slip_char'] = slipChar;
    data['round_off'] = roundOff;
    data['trans_per_unit'] = transPerUnit;
    data['purtyp'] = purtyp;
    data['due_days'] = dueDays;
    data['al1_cf'] = al1Cf;
    data['al2_cf'] = al2Cf;
    data['al3_cf'] = al3Cf;
    data['al4_cf'] = al4Cf;
    data['act_bill_date'] = actBillDate;
    data['filling_status'] = fillingStatus;
    data['filling_info'] = fillingInfo;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['supplier_name'] = supplierName;
    data['firm_name'] = firmName;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['pa_ano_name'] = paAnoName;
    data['al1_ano_name'] = al1AnoName;
    data['al2_ano_name'] = al2AnoName;
    data['al3_ano_name'] = al3AnoName;
    data['al4_ano_name'] = al4AnoName;
    data['net_qty'] = netQty;
    data['pack'] = pack;
    if (itemDetails != dynamic) {
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
  int? yarnPurchaseId;
  int? yarnId;
  int? colorId;
  String? stockTo;
  dynamic boxNo;
  int? pack;
  num? itemQuantity;
  int? less;
  num? netQuantity;
  String? calculateType;
  num? rate;
  num? amount;
  int? rowNo;
  int? crNo;
  int? rcdCr;
  int? rtnCr;
  int? purCr;
  int? purCrLess;
  int? purCrCost;
  dynamic boxSerialNo;
  dynamic rtnCrDet;
  dynamic rtnyarnCrDet;
  dynamic rtnyarnCr;
  dynamic rtnyarnCrLess;
  dynamic batchNo;
  dynamic poRecNo;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic createdBy;
  dynamic updatedBy;
  String? yarnName;
  String? colorName;

  ItemDetails({
    this.id,
    this.yarnPurchaseId,
    this.yarnId,
    this.colorId,
    this.stockTo,
    this.boxNo,
    this.pack,
    this.itemQuantity,
    this.less,
    this.netQuantity,
    this.calculateType,
    this.rate,
    this.amount,
    this.rowNo,
    this.crNo,
    this.rcdCr,
    this.rtnCr,
    this.purCr,
    this.purCrLess,
    this.purCrCost,
    this.boxSerialNo,
    this.rtnCrDet,
    this.rtnyarnCrDet,
    this.rtnyarnCr,
    this.rtnyarnCrLess,
    this.batchNo,
    this.poRecNo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.yarnName,
    this.colorName,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnPurchaseId = json['yarn_purchase_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockTo = json['stock_to'];
    boxNo = json['box_no'];
    pack = json['pack'];
    itemQuantity = json['item_quantity'];
    less = json['less'];
    netQuantity = json['net_quantity'];
    calculateType = json['calculate_type'];
    rate = json['rate'];
    amount = json['amount'];
    rowNo = json['row_no'];
    crNo = json['cr_no'];
    rcdCr = json['rcd_cr'];
    rtnCr = json['rtn_cr'];
    purCr = json['pur_cr'];
    purCrLess = json['pur_cr_less'];
    purCrCost = json['pur_cr_cost'];
    boxSerialNo = json['box_serial_no'];
    rtnCrDet = json['rtn_cr_det'];
    rtnyarnCrDet = json['rtnyarn_cr_det'];
    rtnyarnCr = json['rtnyarn_cr'];
    rtnyarnCrLess = json['rtnyarn_cr_less'];
    batchNo = json['batch_no'];
    poRecNo = json['po_rec_no'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_purchase_id'] = yarnPurchaseId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['stock_to'] = stockTo;
    data['box_no'] = boxNo;
    data['pack'] = pack;
    data['item_quantity'] = itemQuantity;
    data['less'] = less;
    data['net_quantity'] = netQuantity;
    data['calculate_type'] = calculateType;
    data['rate'] = rate;
    data['amount'] = amount;
    data['row_no'] = rowNo;
    data['cr_no'] = crNo;
    data['rcd_cr'] = rcdCr;
    data['rtn_cr'] = rtnCr;
    data['pur_cr'] = purCr;
    data['pur_cr_less'] = purCrLess;
    data['pur_cr_cost'] = purCrCost;
    data['box_serial_no'] = boxSerialNo;
    data['rtn_cr_det'] = rtnCrDet;
    data['rtnyarn_cr_det'] = rtnyarnCrDet;
    data['rtnyarn_cr'] = rtnyarnCr;
    data['rtnyarn_cr_less'] = rtnyarnCrLess;
    data['batch_no'] = batchNo;
    data['po_rec_no'] = poRecNo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}
