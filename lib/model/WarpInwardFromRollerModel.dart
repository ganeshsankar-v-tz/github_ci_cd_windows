class WarpInwardFromRollerModel {
  int? id;
  late int rollerId;
  String? rollerName;
  String? referenceNo;
  String? eDate;
  int? wagesAno;
  int? firmId;
  String? wagesAccountName;
  String? details;
  String? wagesStatus;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<RollerItem>? rollerItem;

  WarpInwardFromRollerModel({
    this.id,
    required this.rollerId,
    this.rollerName,
    this.referenceNo,
    this.eDate,
    this.wagesAno,
    this.wagesAccountName,
    this.details,
    this.wagesStatus,
    this.firmId,
    this.rollerItem,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  WarpInwardFromRollerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rollerId = json['roller_id'];
    rollerName = json['roller_name'];
    referenceNo = json['reference_no'];
    eDate = json['e_date'];
    firmId = json['firm_id'];
    wagesAno = json['wages_ano'];
    wagesAccountName = json['wages_account_name'];
    details = json['details'];
    wagesStatus = json['wages_status'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['roller_item'] != null) {
      rollerItem = <RollerItem>[];
      json['roller_item'].forEach((v) {
        rollerItem!.add(RollerItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['roller_id'] = rollerId;
    data['roller_name'] = rollerName;
    data['reference_no'] = referenceNo;
    data['e_date'] = eDate;
    data['firm_id'] = firmId;
    data['wages_ano'] = wagesAno;
    data['wages_account_name'] = wagesAccountName;
    data['details'] = details;
    data['wages_status'] = wagesStatus;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (rollerItem != null) {
      data['roller_item'] = rollerItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RollerItem {
  int? id;
  int? warpInwardFromRollerId;
  int? warpDesignId;
  String? oldWarpId;
  String? newWarpId;
  String? warpType;
  num? wages;
  int? emptyQty;
  int? sheet;
  int? qty;
  dynamic length;
  String? warpColor;
  int? rowNo;
  dynamic warpWeight;
  String? emptyTyp;
  String? warpDet;
  int? createdBy;
  int? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? status;
  String? warpDesignName;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  RollerItem({
    this.id,
    this.warpInwardFromRollerId,
    this.warpDesignId,
    this.oldWarpId,
    this.newWarpId,
    this.warpType,
    this.wages,
    this.emptyQty,
    this.sheet,
    this.qty,
    this.length,
    this.warpColor,
    this.rowNo,
    this.warpWeight,
    this.emptyTyp,
    this.warpDet,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.warpDesignName,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  RollerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpInwardFromRollerId = json['warp_inward_from_roller_id'];
    warpDesignId = json['warp_design_id'];
    oldWarpId = json['old_warp_id'];
    newWarpId = json['new_warp_id'];
    warpType = json['warp_type'];
    wages = json['wages'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    qty = json['qty'];
    length = json['length'];
    warpColor = json['warp_color'];
    rowNo = json['row_no'];
    warpWeight = json['warp_weight'];
    emptyTyp = json['empty_typ'];
    warpDet = json['warp_det'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    warpDesignName = json['warp_design_name'];
    warpFor = json['warp_for'];
    warpTrackerId = json['warp_tracker_id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['warp_inward_from_roller_id'] = warpInwardFromRollerId;
    data['warp_design_id'] = warpDesignId;
    data['old_warp_id'] = oldWarpId;
    data['new_warp_id'] = newWarpId;
    data['warp_type'] = warpType;
    data['wages'] = wages;
    data['empty_qty'] = emptyQty;
    data['sheet'] = sheet;
    data['qty'] = qty;
    data['length'] = length;
    data['warp_color'] = warpColor;
    data['row_no'] = rowNo;
    data['warp_weight'] = warpWeight;
    data['empty_typ'] = emptyTyp;
    data['warp_det'] = warpDet;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['warp_design_name'] = warpDesignName;
    data['warp_for'] = warpFor;
    data['warp_tracker_id'] = warpTrackerId;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    return data;
  }
}
