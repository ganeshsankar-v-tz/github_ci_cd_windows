class DropoutWarpDetailsModel {
  int? warpDesignId;
  String? warpName;
  String? newWarpId;
  String? recFrom;
  int? qty;
  num? meter;
  int? beam;
  int? bobbin;
  int? sheet;
  String? warpColor;
  String? warpDet;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;
  String? warpFor;

  DropoutWarpDetailsModel({
    this.warpDesignId,
    this.warpName,
    this.newWarpId,
    this.recFrom,
    this.qty,
    this.meter,
    this.beam,
    this.bobbin,
    this.sheet,
    this.warpColor,
    this.warpDet,
    this.warpTrackerId,
    this.weaverId,
    this.weaverName,
    this.subWeaverNo,
    this.loomNo,
    this.warpFor,
  });

  DropoutWarpDetailsModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    newWarpId = json['new_warp_id'];
    recFrom = json['rec_from'];
    qty = json['qty'];
    meter = json['meter'];
    beam = json['beam'];
    bobbin = json['bobbin'];
    sheet = json['sheet'];
    warpColor = json['warp_color'];
    warpDet = json['warp_det'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    subWeaverNo = json['sub_weaver_no'];
    loomNo = json['loom_no'];
    warpFor = json['warp_for'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['new_warp_id'] = newWarpId;
    data['rec_from'] = recFrom;
    data['qty'] = qty;
    data['meter'] = meter;
    data['beam'] = beam;
    data['bobbin'] = bobbin;
    data['sheet'] = sheet;
    data['warp_color'] = warpColor;
    data['warp_det'] = warpDet;
    data['warp_tracker_id'] = warpTrackerId;
    data['weaver_id'] = weaverId;
    data['weaver_name'] = weaverName;
    data['sub_weaver_no'] = subWeaverNo;
    data['loom_no'] = loomNo;
    data['warp_for'] = warpFor;
    return data;
  }

  @override
  String toString() {
    return "$newWarpId";
  }
}
