class WarpCurrentPositionModel {
  String? entry;
  String? ledgerName;
  String? oldWarpId;
  String? newWarpId;
  int? warpDesignId;
  String? warpName;
  String? warpColor;
  String? details;
  int? qty;
  num? meter;
  String? warpTrackerId;
  String? warpType;

  WarpCurrentPositionModel({
    this.entry,
    this.ledgerName,
    this.oldWarpId,
    this.newWarpId,
    this.warpDesignId,
    this.warpName,
    this.warpColor,
    this.details,
    this.qty,
    this.meter,
    this.warpTrackerId,
    this.warpType,
  });

  WarpCurrentPositionModel.fromJson(Map<String, dynamic> json) {
    entry = json['entry'];
    ledgerName = json['ledger_name'];
    oldWarpId = json['old_warp_id'];
    newWarpId = json['new_warp_id'];
    warpDesignId = json['warp_design_id'];
    warpName = json['warp_name'];
    warpColor = json['warp_color'];
    details = json['details'];
    qty = json['qty'];
    meter = json['meter'];
    warpTrackerId = json['warp_tracker_id'];
    warpType = json['warp_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entry'] = entry;
    data['ledger_name'] = ledgerName;
    data['old_warp_id'] = oldWarpId;
    data['new_warp_id'] = newWarpId;
    data['warp_design_id'] = warpDesignId;
    data['warp_name'] = warpName;
    data['warp_color'] = warpColor;
    data['details'] = details;
    data['qty'] = qty;
    data['meter'] = meter;
    data['warp_tracker_id'] = warpTrackerId;
    data['warp_type'] = warpType;
    return data;
  }
}
