class WarpInwardModel {
  int? id;
  int? firmId;
  String? firmName;
  int? warperId;
  String? warperName;
  String? recoredNo;
  String? eDate;
  String? orderYn;
  String? warpId;
  int? warpDesignId;
  int? wagesAno;
  String? warpDesignName;
  int? productQty;
  num? metre;
  String? warpCondition;
  String? emptyType;
  String? typ;
  String? details;
  int? emptyQty;
  int? sheet;
  num? warpingWages;
  num? designCharges;
  num? twistingWages;
  num? totalWages;
  int? totalNoEnds;
  int? totalYarnUsage;
  num? totalAmount;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  String? warpFor;
  int? warpDelivery;
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? weaverName;
  String? loomNo;
  List<ItemDetails>? itemDetails;

  WarpInwardModel({
    this.id,
    this.firmId,
    this.firmName,
    this.warperId,
    this.warperName,
    this.recoredNo,
    this.eDate,
    this.orderYn,
    this.warpId,
    this.warpDesignId,
    this.warpDesignName,
    this.productQty,
    this.metre,
    this.typ,
    this.details,
    this.wagesAno,
    this.warpCondition,
    this.emptyType,
    this.emptyQty,
    this.sheet,
    this.warpingWages,
    this.designCharges,
    this.twistingWages,
    this.totalWages,
    this.totalNoEnds,
    this.totalYarnUsage,
    this.totalAmount,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
    this.warpFor,
    this.warpDelivery,
    this.weaverId,
    this.subWeaverNo,
    this.warpTrackerId,
    this.weaverName,
    this.loomNo,
  });

  WarpInwardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    warperId = json['warper_id'];
    warperName = json['warper_name'];
    recoredNo = json['recored_no'];
    eDate = json['e_date'];
    orderYn = json['order_yn'];
    wagesAno = json['wages_ano'];
    warpId = json['warp_id'];
    typ = json['typ'];
    details = json['details'];
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    productQty = json['product_qty'];
    metre = json['metre'];
    warpCondition = json['warp_condition'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    warpingWages = json['warping_wages'];
    twistingWages = json['twisting_wages'];
    designCharges = json['design_charges'];
    totalWages = json['total_wages'];
    totalNoEnds = json['total_no_ends'];
    totalYarnUsage = json['total_yarn_usage'];
    totalAmount = json['total_amount'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpFor = json['warp_for'];
    warpDelivery = json['warp_delivery'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    warpTrackerId = json['warp_tracker_id'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
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
    data['warper_id'] = warperId;
    data['warper_name'] = warperName;
    data['recored_no'] = recoredNo;
    data['e_date'] = eDate;
    data['order_yn'] = orderYn;
    data['wages_ano'] = wagesAno;
    data['warp_id'] = warpId;
    data['warp_design_id'] = warpDesignId;
    data['warp_design_name'] = warpDesignName;
    data['product_qty'] = productQty;
    data['metre'] = metre;
    data['typ'] = typ;
    data['details'] = details;
    data['warp_condition'] = warpCondition;
    data['twisting_wages'] = twistingWages;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['warping_wages'] = warpingWages;
    data['design_charges'] = designCharges;
    data['total_wages'] = totalWages;
    data['total_no_ends'] = totalNoEnds;
    data['total_yarn_usage'] = totalYarnUsage;
    data['total_amount'] = totalAmount;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['warp_for'] = warpFor;
    data['warp_delivery'] = warpDelivery;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['warp_tracker_id'] = warpTrackerId;
    data['loom_no'] = loomNo;
    data['weaver_name'] = weaverName;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpInwardId;
  int? yarnId;
  int? colorId;
  int? ends;
  num? usedYarns;
  String? calcTyp;
  num? wages;
  num? amount;
  num? qty;
  int? rowNo;
  String? createdBy;
  String? updatedBy;
  String? colorName;
  String? createdAt;
  String? updatedAt;
  int? twistingWpu;
  num? twstingAmount;
  String? yarnName;

  ItemDetails({
    this.id,
    this.warpInwardId,
    this.yarnId,
    this.colorId,
    this.ends,
    this.usedYarns,
    this.calcTyp,
    this.wages,
    this.amount,
    this.qty,
    this.rowNo,
    this.createdBy,
    this.updatedBy,
    this.colorName,
    this.createdAt,
    this.updatedAt,
    this.twistingWpu,
    this.twstingAmount,
    this.yarnName,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpInwardId = json['warp_inward_id'];
    yarnId = json['yarn_id'];
    colorId = json['color_id'];
    ends = json['ends'];
    usedYarns = json['used_yarns'];
    calcTyp = json['calc_typ'];
    wages = json['wages'];
    amount = json['amount'];
    qty = json['qty'];
    rowNo = json['row_no'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    colorName = json['color_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    twistingWpu = json['twisting_wpu'];
    twstingAmount = json['twsting_amount'];
    yarnName = json['yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warp_inward_id'] = warpInwardId;
    data['yarn_id'] = yarnId;
    data['color_id'] = colorId;
    data['ends'] = ends;
    data['used_yarns'] = usedYarns;
    data['calc_typ'] = calcTyp;
    data['wages'] = wages;
    data['amount'] = amount;
    data['qty'] = qty;
    data['row_no'] = rowNo;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['color_name'] = colorName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['twisting_wpu'] = twistingWpu;
    data['twsting_amount'] = twstingAmount;
    data['yarn_name'] = yarnName;
    return data;
  }
}
