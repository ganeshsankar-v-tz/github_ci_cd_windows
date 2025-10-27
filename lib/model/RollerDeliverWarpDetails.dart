class RollerDeliverWarpDetails {
  String? warpId;
  int? qty;
  num? metre;
  num? weight;
  String? warpColor;
  String? details;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  RollerDeliverWarpDetails({
    this.warpId,
    this.qty,
    this.metre,
    this.warpColor,
    this.weight,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  RollerDeliverWarpDetails.fromJson(Map<String, dynamic> json) {
    warpId = json['warp_id'];
    qty = json['qty'];
    metre = json['metre'];
    warpColor = json['warp_color'];
    details = json['details'];
    weight = json['weight'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_id'] = warpId;
    data['qty'] = qty;
    data['metre'] = metre;
    data['warp_color'] = warpColor;
    data['details'] = details;
    data['weight'] = weight;
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
