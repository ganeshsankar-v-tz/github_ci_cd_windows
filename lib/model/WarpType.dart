class WarpType {
  String? wrapDesign;
  String? wrapType;
  int? warpDesignId;

  WarpType({
    this.wrapDesign,
    this.wrapType,
    this.warpDesignId,
  });

  WarpType.fromJson(Map<String, dynamic> json) {
    wrapDesign = json['warp_design'];
    wrapType = json['warp_type'];
    warpDesignId = json['warp_design_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design'] = wrapDesign;
    data['warp_type'] = wrapType;
    data['warp_design_id'] = warpDesignId;
    return data;
  }

  @override
  String toString() {
    return '$wrapDesign';
  }
}
