class WeavingWarpDeliveryModel {
  int? warpDesignId;
  String? newWarpId;
  String? recFrom;
  int? qty;
  num? meter;
  int? beam;
  int? bobbin;
  int? sheet;
  String? warpColor;
  String? warpDet;

  WeavingWarpDeliveryModel(
      {this.warpDesignId,
      this.newWarpId,
      this.recFrom,
      this.qty,
      this.meter,
      this.beam,
      this.bobbin,
      this.sheet,
      this.warpColor,
      this.warpDet});

  WeavingWarpDeliveryModel.fromJson(Map<String, dynamic> json) {
    warpDesignId = json['warp_design_id'];
    newWarpId = json['new_warp_id'];
    recFrom = json['rec_from'];
    qty = json['qty'];
    meter = json['meter'];
    beam = json['beam'];
    bobbin = json['bobbin'];
    sheet = json['sheet'];
    warpColor = json['warp_color'];
    warpDet = json['warp_det'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['warp_design_id'] = warpDesignId;
    data['new_warp_id'] = newWarpId;
    data['rec_from'] = recFrom;
    data['qty'] = qty;
    data['meter'] = meter;
    data['beam'] = beam;
    data['bobbin'] = bobbin;
    data['sheet'] = sheet;
    data['warp_color'] = warpColor;
    data['warp_det'] = warpDet;
    return data;
  }

  @override
  String toString() {
    return "$newWarpId";
  }
}
