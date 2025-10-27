class WarpSaleModel {
  int? id;
  int? firmId;
  String? firmName;
  int? customerId;
  String? customerName;
  int? saleAno;
  String? saleAnoName;
  String? eDate;
  String? details;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? updatedBy;
  String? creatorName;
  String? updatedName;
  num? netTotal;
  String? lrNo;
  String? lrDate;
  String? al1Typ;
  int? al1Ano;
  num? al1Perc;
  num? al1Amount;
  String? al2Typ;
  int? al2Ano;
  num? al2Perc;
  num? al2Amount;
  String? al3Typ;
  int? al3Ano;
  num? al3Perc;
  num? al3Amount;
  String? al4Typ;
  int? al4Ano;
  num? al4Perc;
  num? al4Amount;
  num? roundOff;
  String? ledgerNameA1;
  String? ledgerNameA2;
  String? ledgerNameA3;
  String? ledgerNameA4;
  List<ItemDetails>? itemDetails;

  WarpSaleModel({
    this.id,
    this.firmId,
    this.firmName,
    this.customerId,
    this.customerName,
    this.saleAno,
    this.saleAnoName,
    this.eDate,
    this.details,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.creatorName,
    this.updatedName,
    this.netTotal,
    this.lrNo,
    this.lrDate,
    this.al1Typ,
    this.al1Ano,
    this.al1Perc,
    this.al1Amount,
    this.al2Typ,
    this.al2Ano,
    this.al2Perc,
    this.al2Amount,
    this.al3Typ,
    this.al3Ano,
    this.al3Perc,
    this.al3Amount,
    this.al4Typ,
    this.al4Ano,
    this.al4Perc,
    this.al4Amount,
    this.roundOff,
    this.ledgerNameA1,
    this.ledgerNameA2,
    this.ledgerNameA3,
    this.ledgerNameA4,
    this.itemDetails,
  });

  WarpSaleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    saleAno = json['sale_ano'];
    saleAnoName = json['sale_ano_name'];
    eDate = json['e_date'];
    details = json['details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    netTotal = json['net_total'];
    lrNo = json['lr_no'];
    lrDate = json['lr_date'];
    al1Typ = json['al1_typ'];
    al1Ano = json['al1_ano'];
    al1Perc = json['al1_perc'];
    al1Amount = json['al1_amount'];
    al2Typ = json['al2_typ'];
    al2Ano = json['al2_ano'];
    al2Perc = json['al2_perc'];
    al2Amount = json['al2_amount'];
    al3Typ = json['al3_typ'];
    al3Ano = json['al3_ano'];
    al3Perc = json['al3_perc'];
    al3Amount = json['al3_amount'];
    al4Typ = json['al4_typ'];
    al4Ano = json['al4_ano'];
    al4Perc = json['al4_perc'];
    al4Amount = json['al4_amount'];
    ledgerNameA1 = json['ledger_name_a1'];
    ledgerNameA2 = json['ledger_name_a2 '];
    ledgerNameA3 = json['ledger_name_a3'];
    ledgerNameA4 = json['ledger_name_a4'];
    roundOff = json['round_off'];

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
    data['sale_ano'] = saleAno;
    data['sale_ano_name'] = saleAnoName;
    data['e_date'] = eDate;
    data['details'] = details;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['net_total'] = netTotal;
    data['lr_no'] = lrNo;
    data['lr_date'] = lrDate;
    data['al1_typ'] = al1Typ;
    data['al1_ano'] = al1Ano;
    data['al1_perc'] = al1Perc;
    data['al1_amount'] = al1Amount;
    data['al2_typ'] = al2Typ;
    data['al2_ano'] = al2Ano;
    data['al2_perc'] = al2Perc;
    data['al2_amount'] = al2Amount;
    data['al3_typ'] = al3Typ;
    data['al3_ano'] = al3Ano;
    data['al3_perc'] = al3Perc;
    data['al3_amount'] = al3Amount;
    data['al4_typ'] = al4Typ;
    data['al4_ano'] = al4Ano;
    data['al4_perc'] = al4Perc;
    data['al4_amount'] = al4Amount;
    data['round_off'] = roundOff;
    data['ledger_name_a1'] = ledgerNameA1;
    data['ledger_name_a2'] = ledgerNameA2;
    data['ledger_name_a3'] = ledgerNameA3;
    data['ledger_name_a4'] = ledgerNameA4;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpSaleId;
  int? warpDesignId;
  String? warpId;
  num? amount;
  int? tokenNo;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  int? productQty;
  num? meter;
  String? warpColor;
  String? cutRateSep;
  num? warpWight;
  num? kgsRate;
  String? cutKgsRateSep;
  String? chDet;
  String? dcDate;
  String? dcNo;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? details;
  String? warpDesignName;
  String? warpType;

  ItemDetails({
    this.id,
    this.warpSaleId,
    this.warpDesignId,
    this.warpId,
    this.amount,
    this.tokenNo,
    this.emptyType,
    this.emptyQty,
    this.sheet,
    this.productQty,
    this.meter,
    this.warpColor,
    this.cutRateSep,
    this.warpWight,
    this.kgsRate,
    this.cutKgsRateSep,
    this.chDet,
    this.dcDate,
    this.dcNo,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.details,
    this.warpDesignName,
    this.warpType,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpSaleId = json['warp_sale_id'];
    warpDesignId = json['warp_design_id'];
    warpId = json['warp_id'];
    amount = json['amount'];
    tokenNo = json['token_no'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    productQty = json['product_qty'];
    meter = json['meter'];
    warpColor = json['warp_color'];
    cutRateSep = json['cut_rate_sep'];
    warpWight = json["warp_weight"] ?? 0;
    kgsRate = json['kgs_rate'];
    cutKgsRateSep = json['cut_kgs_rate_sep'];
    chDet = json['ch_det'];
    dcDate = json['dc_date'];
    dcNo = json['dc_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    details = json['details'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warp_sale_id'] = warpSaleId;
    data['warp_design_id'] = warpDesignId;
    data['warp_id'] = warpId;
    data['amount'] = amount;
    data['token_no'] = tokenNo;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['product_qty'] = productQty;
    data['meter'] = meter;
    data['warp_color'] = warpColor;
    data['cut_rate_sep'] = cutRateSep;
    data["warp_weight"] = warpWight ?? 0;
    data['kgs_rate'] = kgsRate;
    data['cut_kgs_rate_sep'] = cutKgsRateSep;
    data['ch_det'] = chDet;
    data['dc_date'] = dcDate;
    data['dc_no'] = dcNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['details'] = details;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    return data;
  }
}
