class WarpDeliveryRollerModel {
  int? id;
  int? rollerId;
  String? rollerName;
  int? dcNo;
  String? eDate;
  String? details;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  String? warpCheckerName;
  int? warpCheckerId;
  List<ItemDetails>? itemDetails;

  WarpDeliveryRollerModel({
    this.id,
    this.rollerId,
    this.rollerName,
    this.dcNo,
    this.eDate,
    this.details,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
    this.warpCheckerName,
    this.warpCheckerId,
  });

  WarpDeliveryRollerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rollerId = json['roller_id'];
    rollerName = json['roller_name'];
    dcNo = json['dc_no'];
    eDate = json['e_date'];
    details = json['details'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpCheckerName = json['warp_checker_name'];
    warpCheckerId = json['warp_checker_id'];
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
    data['roller_id'] = rollerId;
    data['roller_name'] = rollerName;
    data['dc_no'] = dcNo;
    data['e_date'] = eDate;
    data['details'] = details;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['warp_checker_name'] = warpCheckerName;
    data['warp_checker_id'] = warpCheckerId;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpDeliveryToRollerId;
  int? warpDesignId;
  String? warpId;
  String? warpType;
  int? productQty;
  num? meter;
  String? colorId;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  String? createdAt;
  String? updatedAt;
  String? warpDesignName;
  String? warpColor;
  num? returnWarp;
  String? warpdet;
  num? warpWeight;
  int? warpInward;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  ItemDetails({
    this.id,
    this.warpDeliveryToRollerId,
    this.warpDesignId,
    this.warpId,
    this.warpType,
    this.productQty,
    this.meter,
    this.colorId,
    this.emptyType,
    this.emptyQty,
    this.sheet,
    this.warpColor,
    this.createdAt,
    this.updatedAt,
    this.warpDesignName,
    this.warpInward,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpDeliveryToRollerId = json['warp_delivery_to_roller_id'];
    warpDesignId = json['warp_design_id'];
    warpId = json['warp_id'];
    warpType = json['warp_type'];
    productQty = json['product_qty'];
    meter = json['meter'];
    colorId = json['color_id'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    returnWarp = json['return_warp'];
    warpdet = json['warp_det'];
    warpWeight = json['warp_weight'];
    warpColor = json['warp_color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpDesignName = json['warp_design_name'];
    warpInward = json['warp_inward'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warp_delivery_to_roller_id'] = warpDeliveryToRollerId;
    data['warp_design_id'] = warpDesignId;
    data['warp_id'] = warpId;
    data['warp_type'] = warpType;
    data['product_qty'] = productQty;
    data['meter'] = meter;
    data['color_id'] = colorId;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['return_warp'] = returnWarp;
    data['warp_det'] = warpdet;
    data['warp_weight'] = warpWeight;
    data['warp_color'] = warpColor;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['warp_design_name'] = warpDesignName;
    data['warp_inward'] = warpInward;
    data['warp_for'] = warpFor;
    data['warp_tracker_id'] = warpTrackerId;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    return data;
  }
}
