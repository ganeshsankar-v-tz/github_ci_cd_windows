class NewWrap {
  int? id;
  String? warpName;
  String? warpType;
  String? group;
  String? patterns;
  String? designSheet;
  String? totalEnds;
  String? length;
  String? isActive;
  String? unit;
  int? status;
  String? createdAt;
  String? updatedAt;

  NewWrap(
      {this.id,
        this.warpName,
        this.warpType,
        this.group,
        this.patterns,
        this.designSheet,
        this.totalEnds,
        this.length,
        this.isActive,
        this.unit,
        this.status,
        this.createdAt,
        this.updatedAt});

  NewWrap.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    group = json['group'];
    patterns = json['patterns'];
    designSheet = json['design_sheet'];
    totalEnds = json['total_ends'];
    length = json['length'];
    isActive = json['is_active'];
    unit = json['unit'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_name'] = this.warpName;
    data['warp_type'] = this.warpType;
    data['group'] = this.group;
    data['patterns'] = this.patterns;
    data['design_sheet'] = this.designSheet;
    data['total_ends'] = this.totalEnds;
    data['length'] = this.length;
    data['is_active'] = this.isActive;
    data['unit'] = this.unit;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}