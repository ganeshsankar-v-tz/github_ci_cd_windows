class WarpMergingModel {
  int? id;
  String? eDate;
  int? warpDesignId;
  String? warpDesignName;
  String? warpCondition;
  String? details;
  int? prodQty;
  String? warpIdNo;
  String? emptyTyp;
  int? emptyQty;
  int? metre;
  int? sheet;
  String? warpType;
  String? warpColor;
  int? totalEnds;
  List<ItemDetails>? itemDetails;

  WarpMergingModel(
      {this.id,
      this.eDate,
      this.warpDesignId,
      this.warpDesignName,
      this.warpCondition,
      this.details,
      this.prodQty,
      this.warpIdNo,
      this.emptyTyp,
      this.emptyQty,
      this.metre,
      this.sheet,
      this.warpType,
      this.warpColor,
      this.totalEnds,
      this.itemDetails});

  WarpMergingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    warpDesignId = json['warp_design_id'];
    warpDesignName = json['warp_design_name'];
    warpCondition = json['warp_condition'];
    details = json['details'];
    prodQty = json['prod_qty'];
    warpIdNo = json['warp_id_no'];
    emptyTyp = json['empty_typ'];
    emptyQty = json['empty_qty'];
    metre = json['metre'];
    sheet = json['sheet'];
    warpType = json['warp_type'];
    warpColor = json['warp_color'];
    totalEnds = json['total_ends'];
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails!.add(new ItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['e_date'] = this.eDate;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_design_name'] = this.warpDesignName;
    data['warp_condition'] = this.warpCondition;
    data['details'] = this.details;
    data['prod_qty'] = this.prodQty;
    data['warp_id_no'] = this.warpIdNo;
    data['empty_typ'] = this.emptyTyp;
    data['empty_qty'] = this.emptyQty;
    data['metre'] = this.metre;
    data['sheet'] = this.sheet;
    data['warp_type'] = this.warpType;
    data['warp_color'] = this.warpColor;
    data['total_ends'] = this.totalEnds;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemDetails {
  int? id;
  int? warpMergingId;
  int? rowNo;
  int? warpDesignId;
  String? warpIdNo;
  int? metre;
  String? emptyTyp;
  int? emptyQty;
  int? sheet;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? updatedBy;
  String? warpDesignName;
  int? totalEnds;
  String? warpType;

  ItemDetails(
      {this.id,
      this.warpMergingId,
      this.rowNo,
      this.warpDesignId,
      this.warpIdNo,
      this.metre,
      this.emptyTyp,
      this.emptyQty,
      this.sheet,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.warpDesignName,
      this.totalEnds,
      this.warpType});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpMergingId = json['warp_merging_id'];
    rowNo = json['row_no'];
    warpDesignId = json['warp_design_id'];
    warpIdNo = json['warp_id_no'];
    metre = json['metre'];
    emptyTyp = json['empty_typ'];
    emptyQty = json['empty_qty'];
    sheet = json['sheet'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    warpDesignName = json['warp_design_name'];
    totalEnds = json['total_ends'];
    warpType = json['warp_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_merging_id'] = this.warpMergingId;
    data['row_no'] = this.rowNo;
    data['warp_design_id'] = this.warpDesignId;
    data['warp_id_no'] = this.warpIdNo;
    data['metre'] = this.metre;
    data['empty_typ'] = this.emptyTyp;
    data['empty_qty'] = this.emptyQty;
    data['sheet'] = this.sheet;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['warp_design_name'] = this.warpDesignName;
    data['total_ends'] = this.totalEnds;
    data['warp_type'] = this.warpType;
    return data;
  }
}
