class NewWarpIdDetailsModel {
  String? lastWarpId;
  String? newWarpId;

  /// This Used For Warp Purchase WarpId
  String? warpId;

  NewWarpIdDetailsModel({this.lastWarpId, this.newWarpId, this.warpId});

  NewWarpIdDetailsModel.fromJson(Map<String, dynamic> json) {
    lastWarpId = json['last_warp_id'];
    newWarpId = json['new_warp_id'];
    warpId = json['warp_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['last_warp_id'] = lastWarpId;
    data['new_warp_id'] = newWarpId;
    data['warp_id'] = warpId;
    return data;
  }
}
