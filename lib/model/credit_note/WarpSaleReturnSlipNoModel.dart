class WarpSaleReturnSlipNoModel {
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
  List<ItemDetails>? itemDetails;

  WarpSaleReturnSlipNoModel({
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
    this.itemDetails,
  });

  WarpSaleReturnSlipNoModel.fromJson(Map<String, dynamic> json) {
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
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
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
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return "$id";
  }

}

class ItemDetails {
  int? id;
  int? warpSaleId;
  int? warpDesignId;
  String? warpId;
  num? amount;
  dynamic tokenNo;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  int? productQty;
  num? meter;
  String? warpColor;
  dynamic cutRateSep;
  num? warpWight;
  num? kgsRate;
  dynamic cutKgsRateSep;
  dynamic chDet;
  dynamic dcDate;
  dynamic dcNo;
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
    warpWight = json['warp_wight'];
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
    data['warp_wight'] = warpWight;
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
