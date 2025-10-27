class WarpDeliveryToDyerModel {
  int? id;
  int? dyerId;
  String? dyarName;
  int? dcNo;
  String? eDate;
  String? details;
  String? warpCheckerName;
  int? warpCheckerId;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  WarpDeliveryToDyerModel({
    this.id,
    this.dyerId,
    this.dyarName,
    this.dcNo,
    this.eDate,
    this.details,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
    this.itemDetails,
    this.warpCheckerName,
    this.warpCheckerId,
  });

  WarpDeliveryToDyerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    dyarName = json['dyar_name'];
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
    data['dyer_id'] = dyerId;
    data['dyar_name'] = dyarName;
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
  int? warpDeliveryToDyerId;
  int? warpDesignId;
  String? warpId;
  String? colorToDye;
  int? rowNo;
  String? warpDet;
  num? warpWeight;
  String? usedEmpty;
  String? warpDesignName;
  String? warpType;
  int? productQty;
  int? metre;
  int? warpInward;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  ItemDetails({
    this.id,
    this.warpDeliveryToDyerId,
    this.warpDesignId,
    this.warpId,
    this.colorToDye,
    this.rowNo,
    this.warpDet,
    this.warpWeight,
    this.usedEmpty,
    this.warpDesignName,
    this.warpType,
    this.productQty,
    this.metre,
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
    warpDeliveryToDyerId = json['warp_delivery_to_dyer_id'];
    warpDesignId = json['warp_design_id'];
    warpId = json['warp_id'];
    colorToDye = json['color_to_dye'];
    rowNo = json['row_no'];
    warpDet = json['warp_det'];
    warpWeight = json['warp_weight'];
    usedEmpty = json['used_empty'];
    warpDesignName = json['warp_design_name'];
    warpType = json['warp_type'];
    productQty = json['product_qty'];
    metre = json['metre'];
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
    data['warp_delivery_to_dyer_id'] = warpDeliveryToDyerId;
    data['warp_design_id'] = warpDesignId;
    data['warp_id'] = warpId;
    data['color_to_dye'] = colorToDye;
    data['row_no'] = rowNo;
    data['warp_det'] = warpDet;
    data['warp_weight'] = warpWeight;
    data['used_empty'] = usedEmpty;
    data['warp_design_name'] = warpDesignName;
    data['warp_type'] = warpType;
    data['product_qty'] = productQty;
    data['metre'] = metre;
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
