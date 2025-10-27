class RollerInwardWarpDetails {
  String? oldWarpId;
  int? qty;
  num? length;
  String? emptyType;
  int? emptyQty;
  int? sheet;
  String? warpColor;
  num? warpWeight;
  String? warpDet;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  RollerInwardWarpDetails({
    this.oldWarpId,
    this.qty,
    this.length,
    this.emptyType,
    this.emptyQty,
    this.sheet,
    this.warpColor,
    this.warpWeight,
    this.warpDet,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  RollerInwardWarpDetails.fromJson(Map<String, dynamic> json) {
    oldWarpId = json['old_warp_id'];
    qty = json['qty'];
    length = json['length'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    warpColor = json['warp_color'];
    warpWeight = json['warp_weight'];
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
    data['old_warp_id'] = oldWarpId;
    data['qty'] = qty;
    data['length'] = length;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['warp_color'] = warpColor;
    data['warp_weight'] = warpWeight;
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
    return "$oldWarpId";
  }
}
