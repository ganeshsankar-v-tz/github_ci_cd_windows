class WarpNotificationModel {
  int? id;
  String? eDate;
  int? weaverId;
  int? subWeaverNo;
  int? productId;
  int? warpDesignId;
  String? details;
  String? warpStatus;
  String? createdAt;
  int? weaverNo;
  String? weaverName;
  String? warpName;
  String? loom;

  WarpNotificationModel(
      {this.id,
      this.eDate,
      this.weaverId,
      this.subWeaverNo,
      this.productId,
      this.warpDesignId,
      this.details,
      this.warpStatus,
      this.createdAt,
      this.weaverNo,
      this.weaverName,
      this.warpName,
      this.loom});

  WarpNotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    productId = json['product_id'];
    warpDesignId = json['warp_design_id'];
    details = json['details'];
    warpStatus = json['warp_status'];
    createdAt = json['created_at'];
    weaverNo = json['weaver_no'];
    weaverName = json['weaver_name'];
    warpName = json['warp_name'];
    loom = json['loom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['weaver_id'] = weaverId;
    data['sub_weaver_no'] = subWeaverNo;
    data['product_id'] = productId;
    data['warp_design_id'] = warpDesignId;
    data['details'] = details;
    data['warp_status'] = warpStatus;
    data['created_at'] = createdAt;
    data['weaver_no'] = weaverNo;
    data['weaver_name'] = weaverName;
    data['warp_name'] = warpName;
    data['loom'] = loom;
    return data;
  }
}
