class WarpInwardWarpDetailsModel {
  String? warpType;
  String? warpId;
  int? productQty;
  num? warpWeight;
  num? metre;
  String? warpColor;
  String? warpDet;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  WarpInwardWarpDetailsModel({
    this.warpType,
    this.warpId,
    this.productQty,
    this.warpWeight,
    this.metre,
    this.warpColor,
    this.warpDet,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  WarpInwardWarpDetailsModel.fromJson(Map<String, dynamic> json) {
    warpType = json['warp_type'];
    warpId = json['warp_id'];
    productQty = json['product_qty'];
    warpWeight = json['warp_weight'];
    metre = json['metre'];
    warpColor = json['warp_color'];
    warpDet = json['warp_det'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_type'] = warpType;
    data['warp_id'] = warpId;
    data['product_qty'] = productQty;
    data['warp_weight'] = warpWeight;
    data['metre'] = metre;
    data['warp_color'] = warpColor;
    data['warp_det'] = warpDet;
    data['warp_for'] = warpFor;
    data['warp_tracker_id'] = warpTrackerId;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    return data;
  }

  @override
  String toString() {
    return "$warpId";
  }
}
