class AlternativeWarpDesignModel {
  int? id;
  String? date;
  String? recordNo;
  String? details;
  int? oldWarpDesignId;
  String? oldWarpDesign;
  String? warpType;
  int? totalEnds;
  String? warpIdNo;
  String? emptyType;
  int? emptyQty;
  int? productQty;
  dynamic? meter;
  String? warpCondition;
  int? sheet;
  String? altWarpDesignId;
  int? altTotalEnds;
  String? altWarpId;
  String? altWarpType;

  AlternativeWarpDesignModel(
      {this.id,
      this.date,
      this.recordNo,
      this.details,
      this.oldWarpDesignId,
      this.oldWarpDesign,
      this.warpType,
      this.totalEnds,
      this.warpIdNo,
      this.emptyType,
      this.emptyQty,
      this.productQty,
      this.meter,
      this.warpCondition,
      this.sheet,
      this.altWarpDesignId,
      this.altTotalEnds,
      this.altWarpId,
      this.altWarpType});

  AlternativeWarpDesignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    recordNo = json['record_no'];
    details = json['details'];
    oldWarpDesignId = json['old_warp_design_id'];
    oldWarpDesign = json['old_warp_design'];
    warpType = json['warp_type'];
    totalEnds = json['total_ends'];
    warpIdNo = json['warp_id_no'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    productQty = json['product_qty'];
    meter = json['meter'];
    warpCondition = json['warp_condition'];
    sheet = json['sheet'];
    altWarpDesignId = json['alt_warp_design_id'];
    altTotalEnds = json['alt_total_ends'];
    altWarpId = json['alt_warp_id'];
    altWarpType = json['alt_Warp_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['record_no'] = this.recordNo;
    data['details'] = this.details;
    data['old_warp_design_id'] = this.oldWarpDesignId;
    data['old_warp_design'] = this.oldWarpDesign;
    data['warp_type'] = this.warpType;
    data['total_ends'] = this.totalEnds;
    data['warp_id_no'] = this.warpIdNo;
    data['empty_type'] = this.emptyType;
    data['empty_qty'] = this.emptyQty;
    data['product_qty'] = this.productQty;
    data['meter'] = this.meter;
    data['warp_condition'] = this.warpCondition;
    data['sheet'] = this.sheet;
    data['alt_warp_design_id'] = this.altWarpDesignId;
    data['alt_total_ends'] = this.altTotalEnds;
    data['alt_warp_id'] = this.altWarpId;
    data['alt_Warp_type'] = this.altWarpType;
    return data;
  }
}
