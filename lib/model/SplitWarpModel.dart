class SplitWarpModel {
  int? id;
  String? eDate;
  int? warpDesignId;
  String? details;
  String? warpIdNo;
  String? warpDesignName;
  String? emptyType;
  int? emptyQty;
  int? metre;
  int? sheet;
  int? totalEnds;
  int? transNo;
  String? warpColors;
  List<WarpItem>? warpItem;

  SplitWarpModel(
      {this.id,
        this.eDate,
        this.warpDesignId,
        this.details,
        this.warpIdNo,
        this.warpDesignName,
        this.emptyType,
        this.emptyQty,
        this.metre,
        this.sheet,
        this.totalEnds,
        this.transNo,
        this.warpColors,
        this.warpItem});

  SplitWarpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    warpDesignId = json['warp_design_id'];
    details = json['details'];
    warpIdNo = json['warp_id_no'];
    warpDesignName = json['warp_design_name'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    metre = json['metre'];
    sheet = json['sheet'];
    totalEnds = json['total_ends'];
    transNo = json['trans_no'];
    warpColors = json['warp_colors'];
    if (json['warp_item'] != null) {
      warpItem = <WarpItem>[];
      json['warp_item'].forEach((v) {
        warpItem!.add(new WarpItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['e_date'] = this.eDate;
    data['warp_design_id'] = this.warpDesignId;
    data['details'] = this.details;
    data['warp_id_no'] = this.warpIdNo;
    data['warp_design_name'] = this.warpDesignName;
    data['empty_type'] = this.emptyType;
    data['empty_qty'] = this.emptyQty;
    data['metre'] = this.metre;
    data['sheet'] = this.sheet;
    data['total_ends'] = this.totalEnds;
    data['trans_no'] = this.transNo;
    data['warp_colors'] = this.warpColors;
    if (this.warpItem != null) {
      data['warp_item'] = this.warpItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WarpItem {
  int? id;
  int? splitWarpId;
  int? rowNo;
  String? warpIdNo;
  int? warpDesignId;
  String? warpColor;
  String? emptyType;
  int? emptyQty;
  int? metre;
  int? sheet;
  String? wrapCondition;
  String? createdBy;
  String? updatedBy;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? warpIdNoName;
  String? warpDesignName;

  WarpItem(
      {this.id,
        this.splitWarpId,
        this.rowNo,
        this.warpIdNo,
        this.warpDesignId,
        this.warpColor,
        this.emptyType,
        this.emptyQty,
        this.metre,
        this.sheet,
        this.wrapCondition,
        this.createdBy,
        this.updatedBy,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.warpIdNoName,
        this.warpDesignName});

  WarpItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    splitWarpId = json['split_warp_id'];
    rowNo = json['row_no'];
    warpIdNo = json['warp_id_no'];
    warpDesignId = json['warp_design_id'];
    warpColor = json['warp_color'];
    emptyType = json['empty_type'];
    emptyQty = json['empty_qty'];
    metre = json['metre'];
    sheet = json['sheet'];
    wrapCondition = json['wrap_condition'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    warpIdNoName = json['warp_id_no_name'];
    warpDesignName = json['warp_design_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['split_warp_id'] = this.splitWarpId;
    data['row_no'] = this.rowNo;
    data['warp_id_no'] = this.warpIdNo;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_color'] = this.warpColor;
    data['empty_type'] = this.emptyType;
    data['empty_qty'] = this.emptyQty;
    data['metre'] = this.metre;
    data['sheet'] = this.sheet;
    data['wrap_condition'] = this.wrapCondition;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['warp_id_no_name'] = this.warpIdNoName;
    data['warp_design_name'] = this.warpDesignName;
    return data;
  }
}
