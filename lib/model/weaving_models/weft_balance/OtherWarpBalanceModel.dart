class OtherWarpBalanceModel {
  int? warpDesignId;
  String? warpDesignName;
  String? warpId;
  num? delivered;
  num? usedQty;
  num? weaverStock;
  String? lengthType;

  OtherWarpBalanceModel(
      {this.warpDesignId,
      this.warpDesignName,
      this.warpId,
      this.delivered,
      this.usedQty,
      this.weaverStock,
      this.lengthType});

  OtherWarpBalanceModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    warpId = json['warp_id'];
    delivered = json['deliverd'];
    usedQty = json['used_qty'];
    weaverStock = json['weaver_stock'];
    lengthType = json['length_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['warp_design_name'] = warpDesignName;
    data['warp_id'] = warpId;
    data['deliverd'] = delivered;
    data['used_qty'] = usedQty;
    data['weaver_stock'] = weaverStock;
    data['length_type'] = lengthType;
    return data;
  }
}
