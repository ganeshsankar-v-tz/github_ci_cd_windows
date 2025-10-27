class GoodsInwardOtherWarpModel {
  int? warpDesignId;
  String? warpName;
  String? warpType;
  int? balanceQty;
  num? balanceMeter;
  String? otherWarpid;

  GoodsInwardOtherWarpModel({
    this.warpDesignId,
    this.warpName,
    this.warpType,
    this.balanceQty,
    this.balanceMeter,
    this.otherWarpid,
  });

  GoodsInwardOtherWarpModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    balanceQty = json['balance_qty'];
    balanceMeter = json['balance_meter'];
    otherWarpid = json['other_warpid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['warp_type'] = warpType;
    data['balance_qty'] = balanceQty;
    data['balance_meter'] = balanceMeter;
    data['other_warpid'] = otherWarpid;
    return data;
  }

  @override
  String toString() {
    return "$otherWarpid";
  }
}
