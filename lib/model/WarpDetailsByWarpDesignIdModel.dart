class WarpDetailsByWarpDesignIdModel {
  int? warpDesignId;
  String? warpId;
  String? warpType;
  num? qty;
  num? metre;
  num? weight;
  String? emptyType;
  String? warpColor;
  int? emptyQty;
  String? warpCondition;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  WarpDetailsByWarpDesignIdModel({
    this.warpDesignId,
    this.warpId,
    this.warpType,
    this.qty,
    this.metre,
    this.weight,
    this.emptyType,
    this.warpColor,
    this.emptyQty,
    this.warpCondition,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  WarpDetailsByWarpDesignIdModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpId = json['warp_id'];
    warpType = json['warp_type'];
    qty = json['qty'];
    metre = json['metre'];
    weight = json['weight'];
    warpColor = json['warp_color'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    warpCondition = json['warp_condition'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['warp_id'] = warpId;
    data['warp_type'] = warpType;
    data['qty'] = qty;
    data['metre'] = metre;
    data['weight'] = weight;
    data['warp_color'] = warpColor;
    data['empty_type'] = emptyType;
    data['empty_qty'] = emptyQty;
    data['warp_condition'] = warpCondition;
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
