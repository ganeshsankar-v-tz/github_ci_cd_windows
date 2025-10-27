class WarpDesignChargesConfigModel {
  int? id;
  int? wrapDesignId;
  String? wrapType;
  String? lengthType;
  int? asthiri;
  dynamic designChanges;
  String? chargesPer;
  String? yarns;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? wrapDesignName;

  WarpDesignChargesConfigModel(
      {this.id,
        this.wrapDesignId,
        this.wrapType,
        this.lengthType,
        this.asthiri,
        this.designChanges,
        this.chargesPer,
        this.yarns,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.wrapDesignName});

  WarpDesignChargesConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wrapDesignId = json['wrap_design_id'];
    wrapType = json['wrap_type'];
    lengthType = json['length_type'];
    asthiri = json['asthiri'];
    designChanges = json['design_changes'];
    chargesPer = json['charges_per'];
    yarns = json['yarns'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    wrapDesignName = json['wrap_design_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wrap_design_id'] = this.wrapDesignId;
    data['wrap_type'] = this.wrapType;
    data['length_type'] = this.lengthType;
    data['asthiri'] = this.asthiri;
    data['design_changes'] = this.designChanges;
    data['charges_per'] = this.chargesPer;
    data['yarns'] = this.yarns;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['wrap_design_name'] = this.wrapDesignName;
    return data;
  }
}