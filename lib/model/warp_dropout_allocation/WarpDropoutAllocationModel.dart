class WarpDropoutAllocationModel {
  int? id;
  String? eDate;
  int? weavingAcId;
  int? warpDesignId;
  String? warpId;
  int? warpQty;
  num? meter;
  int? bbn;
  int? bm;
  int? sht;
  int? rowNo;
  String? warpColor;
  int? weaverId;
  int? subWeaverNo;
  String? warpTrackerId;
  String? warpFor;
  String? warpAllocateDate;
  String? createdAt;
  int? createdBy;
  String? updatedAt;
  int? updatedBy;
  String? warpName;
  String? weaverName;
  String? loomNo;
  String? creatorName;
  String? updatedName;

  WarpDropoutAllocationModel({
    this.id,
    this.eDate,
    this.weavingAcId,
    this.warpDesignId,
    this.warpId,
    this.warpQty,
    this.meter,
    this.bbn,
    this.bm,
    this.sht,
    this.rowNo,
    this.warpColor,
    this.weaverId,
    this.subWeaverNo,
    this.warpTrackerId,
    this.warpFor,
    this.warpAllocateDate,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.warpName,
    this.weaverName,
    this.loomNo,
    this.creatorName,
    this.updatedName,
  });

  WarpDropoutAllocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    weavingAcId = json['weaving_ac_id'];
    warpDesignId = json['warp_design_id'];
    warpId = json['warp_id'];
    warpQty = json['warp_qty'];
    meter = json['meter'];
    bbn = json['bbn'];
    bm = json['bm'];
    sht = json['sht'];
    rowNo = json['row_no'];
    warpColor = json['warp_color'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    warpTrackerId = json['warp_tracker_id'];
    warpFor = json['warp_for'];
    warpAllocateDate = json['warp_allocate_date'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
    warpName = json['warp_name'];
    weaverName = json['weaver_name'];
    loomNo = json['loom_no'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['weaving_ac_id'] = weavingAcId;
    data['warp_design_id'] = warpDesignId;
    data['warp_id'] = warpId;
    data['warp_qty'] = warpQty;
    data['meter'] = meter;
    data['bbn'] = bbn;
    data['bm'] = bm;
    data['sht'] = sht;
    data['row_no'] = rowNo;
    data['warp_color'] = warpColor;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['warp_tracker_id'] = warpTrackerId;
    data['warp_for'] = warpFor;
    data['warp_allocate_date'] = warpAllocateDate;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['updated_at'] = updatedAt;
    data['updated_by'] = updatedBy;
    data['warp_name'] = warpName;
    data['weaver_name'] = weaverName;
    data['loom_no'] = loomNo;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    return data;
  }
}
