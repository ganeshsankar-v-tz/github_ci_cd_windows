class YarnSaleReturnSlipNoModel {
  int? id;
  int? firmId;
  int? customerId;
  String? salesDate;
  int? saAno;
  String? details;
  num? netTotal;
  int? acNo;
  int? billNo;
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
  dynamic customerCno;
  dynamic salesCno;
  dynamic al1Cno;
  dynamic al2Cno;
  dynamic al3Cno;
  dynamic al4Cno;
  dynamic transNo;
  num? al1Perc;
  num? al2Perc;
  num? al3Perc;
  num? al4Perc;
  String? destinationTo;
  String? freight;
  String? lrNo;
  String? lrDate;
  String? transportType;
  num? roundOff;
  int? creditDays;
  dynamic billChar;
  dynamic saltyp;
  dynamic al1Cf;
  dynamic al2Cf;
  dynamic al3Cf;
  dynamic al4Cf;
  dynamic deliNos;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? buyerName;
  dynamic street;
  dynamic city;
  dynamic state;
  dynamic pin;
  dynamic country;
  dynamic area;
  dynamic tinNo;
  dynamic phone;
  dynamic febricBillDesc;
  dynamic hankBillBesc;
  dynamic febricMetre;
  dynamic regName1;
  dynamic singedQrCode;
  dynamic signedInvoice;
  dynamic ackNo;
  dynamic irn;
  dynamic stateCode;
  dynamic ackDt;
  dynamic ewbNo;
  dynamic ewbDet;
  dynamic transTyp;
  dynamic transGstin;
  dynamic ledAdderNo;
  dynamic trsptDocNo;
  dynamic trsptDocDate;
  dynamic trsptVachicleNo;
  dynamic trsptDistance;
  dynamic ewbValidBill;
  String? customerName;
  String? firmName;
  String? accountTypeName;
  String? creatorName;
  String? al1AnoName;
  String? al2AnoName;
  String? al3AnoName;
  String? al4AnoName;
  dynamic updatedName;
  List<ItemDetails>? itemDetails;

  YarnSaleReturnSlipNoModel({
    this.id,
    this.firmId,
    this.customerId,
    this.salesDate,
    this.saAno,
    this.details,
    this.netTotal,
    this.acNo,
    this.billNo,
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
    this.customerCno,
    this.salesCno,
    this.al1Cno,
    this.al2Cno,
    this.al3Cno,
    this.al4Cno,
    this.transNo,
    this.al1Perc,
    this.al2Perc,
    this.al3Perc,
    this.al4Perc,
    this.destinationTo,
    this.freight,
    this.lrNo,
    this.lrDate,
    this.transportType,
    this.roundOff,
    this.creditDays,
    this.billChar,
    this.saltyp,
    this.al1Cf,
    this.al2Cf,
    this.al3Cf,
    this.al4Cf,
    this.deliNos,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.buyerName,
    this.street,
    this.city,
    this.state,
    this.pin,
    this.country,
    this.area,
    this.tinNo,
    this.phone,
    this.febricBillDesc,
    this.hankBillBesc,
    this.febricMetre,
    this.regName1,
    this.singedQrCode,
    this.signedInvoice,
    this.ackNo,
    this.irn,
    this.stateCode,
    this.ackDt,
    this.ewbNo,
    this.ewbDet,
    this.transTyp,
    this.transGstin,
    this.ledAdderNo,
    this.trsptDocNo,
    this.trsptDocDate,
    this.trsptVachicleNo,
    this.trsptDistance,
    this.ewbValidBill,
    this.customerName,
    this.firmName,
    this.accountTypeName,
    this.creatorName,
    this.al1AnoName,
    this.al2AnoName,
    this.al3AnoName,
    this.al4AnoName,
    this.updatedName,
    this.itemDetails,
  });

  YarnSaleReturnSlipNoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    customerId = json['customer_id'];
    salesDate = json['sales_date'];
    saAno = json['sa_ano'];
    details = json['details'];
    netTotal = json['net_total'];
    acNo = json['ac_no'];
    billNo = json['bill_no'];
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
    customerCno = json['customer_cno'];
    salesCno = json['sales_cno'];
    al1Cno = json['al1_cno'];
    al2Cno = json['al2_cno'];
    al3Cno = json['al3_cno'];
    al4Cno = json['al4_cno'];
    transNo = json['trans_no'];
    al1Perc = json['al1_perc'];
    al2Perc = json['al2_perc'];
    al3Perc = json['al3_perc'];
    al4Perc = json['al4_perc'];
    destinationTo = json['destination_to'];
    freight = json['freight'];
    lrNo = json['lr_no'];
    lrDate = json['lr_date'];
    transportType = json['transport_type'];
    roundOff = json['round_off'];
    creditDays = json['credit_days'];
    billChar = json['bill_char'];
    saltyp = json['saltyp'];
    al1Cf = json['al1_cf'];
    al2Cf = json['al2_cf'];
    al3Cf = json['al3_cf'];
    al4Cf = json['al4_cf'];
    deliNos = json['deli_nos'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    buyerName = json['buyer_name'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    pin = json['pin'];
    country = json['country'];
    area = json['area'];
    tinNo = json['tin_no'];
    phone = json['phone'];
    febricBillDesc = json['febric_bill_desc'];
    hankBillBesc = json['hank_bill_besc'];
    febricMetre = json['febric_metre'];
    regName1 = json['reg_name1'];
    singedQrCode = json['singed_qr_code'];
    signedInvoice = json['signed_invoice'];
    ackNo = json['ack_no'];
    irn = json['irn'];
    stateCode = json['state_code'];
    ackDt = json['ack_dt'];
    ewbNo = json['ewb_no'];
    ewbDet = json['ewb_det'];
    transTyp = json['trans_typ'];
    transGstin = json['trans_gstin'];
    ledAdderNo = json['led_adder_no'];
    trsptDocNo = json['trspt_doc_no'];
    trsptDocDate = json['trspt_doc_date'];
    trsptVachicleNo = json['trspt_vachicle_no'];
    trsptDistance = json['trspt_distance'];
    ewbValidBill = json['ewb_valid_bill'];
    customerName = json['customer_name'];
    firmName = json['firm_name'];
    accountTypeName = json['account_type_name'];
    creatorName = json['creator_name'];
    al1AnoName = json['al1_ano_name'];
    al2AnoName = json['al2_ano_name'];
    al3AnoName = json['al3_ano_name'];
    al4AnoName = json['al4_ano_name'];
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
    data['customer_id'] = customerId;
    data['sales_date'] = salesDate;
    data['sa_ano'] = saAno;
    data['details'] = details;
    data['net_total'] = netTotal;
    data['ac_no'] = acNo;
    data['bill_no'] = billNo;
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
    data['customer_cno'] = customerCno;
    data['sales_cno'] = salesCno;
    data['al1_cno'] = al1Cno;
    data['al2_cno'] = al2Cno;
    data['al3_cno'] = al3Cno;
    data['al4_cno'] = al4Cno;
    data['trans_no'] = transNo;
    data['al1_perc'] = al1Perc;
    data['al2_perc'] = al2Perc;
    data['al3_perc'] = al3Perc;
    data['al4_perc'] = al4Perc;
    data['destination_to'] = destinationTo;
    data['freight'] = freight;
    data['lr_no'] = lrNo;
    data['lr_date'] = lrDate;
    data['transport_type'] = transportType;
    data['round_off'] = roundOff;
    data['credit_days'] = creditDays;
    data['bill_char'] = billChar;
    data['saltyp'] = saltyp;
    data['al1_cf'] = al1Cf;
    data['al2_cf'] = al2Cf;
    data['al3_cf'] = al3Cf;
    data['al4_cf'] = al4Cf;
    data['deli_nos'] = deliNos;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['buyer_name'] = buyerName;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['pin'] = pin;
    data['country'] = country;
    data['area'] = area;
    data['tin_no'] = tinNo;
    data['phone'] = phone;
    data['febric_bill_desc'] = febricBillDesc;
    data['hank_bill_besc'] = hankBillBesc;
    data['febric_metre'] = febricMetre;
    data['reg_name1'] = regName1;
    data['singed_qr_code'] = singedQrCode;
    data['signed_invoice'] = signedInvoice;
    data['ack_no'] = ackNo;
    data['irn'] = irn;
    data['state_code'] = stateCode;
    data['ack_dt'] = ackDt;
    data['ewb_no'] = ewbNo;
    data['ewb_det'] = ewbDet;
    data['trans_typ'] = transTyp;
    data['trans_gstin'] = transGstin;
    data['led_adder_no'] = ledAdderNo;
    data['trspt_doc_no'] = trsptDocNo;
    data['trspt_doc_date'] = trsptDocDate;
    data['trspt_vachicle_no'] = trsptVachicleNo;
    data['trspt_distance'] = trsptDistance;
    data['ewb_valid_bill'] = ewbValidBill;
    data['customer_name'] = customerName;
    data['firm_name'] = firmName;
    data['account_type_name'] = accountTypeName;
    data['creator_name'] = creatorName;
    data['al1_ano_name'] = al1AnoName;
    data['al2_ano_name'] = al2AnoName;
    data['al3_ano_name'] = al3AnoName;
    data['al4_ano_name'] = al4AnoName;
    data['updated_name'] = updatedName;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$billNo";
  }
}

class ItemDetails {
  int? id;
  int? yarnSaleId;
  int? yarnId;
  int? colorId;
  String? stockIn;
  int? pack;
  String? calculateType;
  String? boxNo;
  num? quantity;
  num? rate;
  num? amount;
  dynamic boxSerialNo;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  num? grossQuantity;
  num? lessQuantity;
  dynamic crNo;
  dynamic deliCr;
  dynamic rtnCr;
  dynamic solCr;
  dynamic solCrLess;
  dynamic solCrCost;
  int? grossAmount;
  dynamic rtnCrDet;
  dynamic rtnYarnCrDet;
  dynamic rtnYrnCr;
  dynamic rtnyarnCrLess;
  dynamic batchNo;
  dynamic dcRowNo;
  dynamic purTyp;
  dynamic ynTaxTyp;
  String? yarnName;
  String? colorName;

  ItemDetails({
    this.id,
    this.yarnSaleId,
    this.yarnId,
    this.colorId,
    this.stockIn,
    this.pack,
    this.calculateType,
    this.boxNo,
    this.quantity,
    this.rate,
    this.amount,
    this.boxSerialNo,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.grossQuantity,
    this.lessQuantity,
    this.crNo,
    this.deliCr,
    this.rtnCr,
    this.solCr,
    this.solCrLess,
    this.solCrCost,
    this.grossAmount,
    this.rtnCrDet,
    this.rtnYarnCrDet,
    this.rtnYrnCr,
    this.rtnyarnCrLess,
    this.batchNo,
    this.dcRowNo,
    this.purTyp,
    this.ynTaxTyp,
    this.yarnName,
    this.colorName,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yarnSaleId = json['yarn_sale_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    stockIn = json['stock_in'];
    pack = json['pack'];
    calculateType = json['calculate_type'];
    boxNo = json['box_no'];
    quantity = json['quantity'];
    rate = json['rate'];
    amount = json['amount'];
    boxSerialNo = json['box_serial_no'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    grossQuantity = json['gross_quantity'];
    lessQuantity = json['less_quantity'];
    crNo = json['cr_no'];
    deliCr = json['deli_cr'];
    rtnCr = json['rtn_cr'];
    solCr = json['sol_cr'];
    solCrLess = json['sol_cr_less'];
    solCrCost = json['sol_cr_cost'];
    grossAmount = json['gross_amount'];
    rtnCrDet = json['rtn_cr_det'];
    rtnYarnCrDet = json['rtn_yarn_cr_det'];
    rtnYrnCr = json['rtn_yrn_cr'];
    rtnyarnCrLess = json['rtnyarn_cr_less'];
    batchNo = json['batch_no'];
    dcRowNo = json['dc_row_no'];
    purTyp = json['pur_typ'];
    ynTaxTyp = json['yn_tax_typ'];
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['yarn_sale_id'] = yarnSaleId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['stock_in'] = stockIn;
    data['pack'] = pack;
    data['calculate_type'] = calculateType;
    data['box_no'] = boxNo;
    data['quantity'] = quantity;
    data['rate'] = rate;
    data['amount'] = amount;
    data['box_serial_no'] = boxSerialNo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['gross_quantity'] = grossQuantity;
    data['less_quantity'] = lessQuantity;
    data['cr_no'] = crNo;
    data['deli_cr'] = deliCr;
    data['rtn_cr'] = rtnCr;
    data['sol_cr'] = solCr;
    data['sol_cr_less'] = solCrLess;
    data['sol_cr_cost'] = solCrCost;
    data['gross_amount'] = grossAmount;
    data['rtn_cr_det'] = rtnCrDet;
    data['rtn_yarn_cr_det'] = rtnYarnCrDet;
    data['rtn_yrn_cr'] = rtnYrnCr;
    data['rtnyarn_cr_less'] = rtnyarnCrLess;
    data['batch_no'] = batchNo;
    data['dc_row_no'] = dcRowNo;
    data['pur_typ'] = purTyp;
    data['yn_tax_typ'] = ynTaxTyp;
    data['yarn_name'] = yarnName;
    data['color_name'] = colorName;
    return data;
  }
}
