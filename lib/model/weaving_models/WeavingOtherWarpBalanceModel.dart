class WeavingOtherWarpBalanceModel {
  int? warpDesignId;
  String? warpName;
  String? warpType;
  String? otherWarpId;
  int? balanceQty;
  num? balanceMeter;

  WeavingOtherWarpBalanceModel({
    this.warpDesignId,
    this.warpName,
    this.warpType,
    this.otherWarpId,
    this.balanceQty,
    this.balanceMeter,
  });

  WeavingOtherWarpBalanceModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    otherWarpId = json['other_warpid'];
    balanceQty = json['balance_qty'];
    balanceMeter = json['balance_meter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['warp_type'] = warpType;
    data['other_warpid'] = otherWarpId;
    data['balance_qty'] = balanceQty;
    data['balance_meter'] = balanceMeter;
    return data;
  }

  @override
  String toString() {
    return "$warpName";
  }
}
