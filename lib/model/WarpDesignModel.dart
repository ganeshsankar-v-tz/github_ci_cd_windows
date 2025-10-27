class WarpDesignModel {
  int? warpDesignId;
  String? warpName;
  String? warpType;

  WarpDesignModel({this.warpDesignId, this.warpName, this.warpType});

  WarpDesignModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warp_design_id'] = this.warpDesignId;
    data['warp_name'] = this.warpName;
    data['warp_type'] = this.warpType;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$warpName";
  }
}
