class WarpInwardFromDyerModel {
  int? id;
  int? dyerId;
  int? firmId;
  String? dyerName;
  String? firmName;
  String? referenceNo;
  String? eDate;
  int? wagesAno;
  int? inwardWarps;
  num? totalWages;
  String? wagesAccountName;
  String? details;
  String? wagesStatus;
  bool? select = false;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;
  List<ItemDetails>? itemDetails;

  WarpInwardFromDyerModel({
    this.id,
    this.dyerId,
    this.firmId,
    this.dyerName,
    this.firmName,
    this.referenceNo,
    this.eDate,
    this.wagesAno,
    this.inwardWarps,
    this.totalWages,
    this.wagesAccountName,
    this.details,
    this.wagesStatus,
    this.itemDetails,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  WarpInwardFromDyerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dyerId = json['dyer_id'];
    firmId = json['firm_id'];
    dyerName = json['dyer_name'];
    firmName = json['firm_name'];
    referenceNo = json['reference_no'];
    eDate = json['e_date'];
    wagesAno = json['wages_ano'];
    inwardWarps = json['inward_warps'];
    totalWages = json['total_wages'];
    wagesAccountName = json['wages_account_name'];
    details = json['details'];
    wagesStatus = json['wages_status'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dyer_id'] = dyerId;
    data['firm_id'] = firmId;
    data['dyer_name'] = dyerName;
    data['firm_name'] = firmName;
    data['reference_no'] = referenceNo;
    data['e_date'] = eDate;
    data['wages_ano'] = wagesAno;
    data['inward_warps'] = inwardWarps;
    data['total_wages'] = totalWages;
    data['wages_account_name'] = wagesAccountName;
    data['details'] = details;
    data['wages_status'] = wagesStatus;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (itemDetails != null) {
      data['item_details'] = itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpInwardFromDyerId;
  int? warpDesignId;
  String? oldWarpId;
  String? newWarpId;
  String? warpType;
  int? qty;
  dynamic meter;
  String? createdAt;
  String? updatedAt;
  dynamic wages;
  int? colorId;
  int? length;
  String? warpColor;
  int? rowNo;
  String? warpDet;
  num? warpWeight;
  String? createdBy;
  String? updatedBy;
  String? warpDesignName;
  String? warpFor;
  String? warpTrackerId;
  int? weaverId;
  String? weaverName;
  int? subWeaverNo;
  String? loomNo;

  ItemDetails({
    this.id,
    this.warpInwardFromDyerId,
    this.warpDesignId,
    this.oldWarpId,
    this.newWarpId,
    this.warpType,
    this.qty,
    this.meter,
    this.createdAt,
    this.updatedAt,
    this.wages,
    this.colorId,
    this.length,
    this.warpColor,
    this.rowNo,
    this.warpDet,
    this.warpWeight,
    this.createdBy,
    this.updatedBy,
    this.warpDesignName,
    this.warpFor,
    this.warpTrackerId,
    this.subWeaverNo,
    this.weaverId,
    this.weaverName,
    this.loomNo,
  });

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpInwardFromDyerId = json['warp_inward_from_dyer_id'];
    warpDesignId = json['warp_design_id'];
    oldWarpId = json['old_warp_id'];
    newWarpId = json['new_warp_id'];
    warpType = json['warp_type'];
    qty = json['qty'];
    meter = json['meter'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    wages = json['wages'];
    colorId = json['color_id'];
    length = json['length'];
    warpColor = json['warp_color'];
    rowNo = json['row_no'];
    warpDet = json['warp_det'];
    warpWeight = json['warp_weight'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
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
    data['warp_inward_from_dyer_id'] = warpInwardFromDyerId;
    data['warp_design_id'] = warpDesignId;
    data['old_warp_id'] = oldWarpId;
    data['new_warp_id'] = newWarpId;
    data['warp_type'] = warpType;
    data['qty'] = qty;
    data['meter'] = meter;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['wages'] = wages;
    data['color_id'] = colorId;
    data['length'] = length;
    data['warp_color'] = warpColor;
    data['row_no'] = rowNo;
    data['warp_det'] = warpDet;
    data['warp_weight'] = warpWeight;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
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
