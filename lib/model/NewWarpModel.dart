class NewWarpModel {
  int? id;
  String? warpName;
  String? warpType;
  int? groupId;
  String? groupName;
  String? patterns;
  String? designSheet;
  int? totalEnds;
  int? standerdLength;
  String? lengthType;
  String? isActive;
  int? totalWarpEnds;
  int? totalYarnUsage;
  String? createdAt;
  List<WarpDetails>? warpDetails;

  NewWarpModel({
    this.id,
    this.warpName,
    this.warpType,
    this.groupId,
    this.groupName,
    this.patterns,
    this.designSheet,
    this.totalEnds,
    this.standerdLength,
    this.lengthType,
    this.isActive,
    this.totalWarpEnds,
    this.totalYarnUsage,
    this.createdAt,
    required this.warpDetails,
  });

  NewWarpModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    warpName = json['warp_name'];
    warpType = json['warp_type'];
    groupId = json['group_id'];
    groupName = json['group_name'];
    patterns = json['patterns'];
    designSheet = json['design_sheet'];
    totalEnds = json['total_ends'];
    standerdLength = json['standerd_length'];
    lengthType = json['length_type'];
    isActive = json['is_active'];
    totalWarpEnds = json['total_warp_ends'];
    totalYarnUsage = json['total_yarn_usage'];
    createdAt = json['created_at'];
    if (json['warp_details'] != null) {
      warpDetails = <WarpDetails>[];
      json['warp_details'].forEach((v) {
        warpDetails?.add(new WarpDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['warp_name'] = this.warpName;
    data['warp_type'] = this.warpType;
    data['group_id'] = this.groupId;
    data['group_name'] = this.groupName;
    data['patterns'] = this.patterns;
    data['design_sheet'] = this.designSheet;
    data['total_ends'] = this.totalEnds;
    data['standerd_length'] = this.standerdLength;
    data['length_type'] = this.lengthType;
    data['is_active'] = this.isActive;
    data['total_warp_ends'] = this.totalWarpEnds;
    data['total_yarn_usage'] = this.totalYarnUsage;
    data['created_at'] = this.createdAt;
    data['warp_details'] = warpDetails?.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return "$warpName";
  }
}

class WarpDetails {
  String? yarnName;
  String? colorName;
  int? noOfEnds;
  int? usage;
  int? yarnId;
  int? colourId;

  WarpDetails(
      {this.yarnName,
      this.colorName,
      this.noOfEnds,
      this.usage,
      this.yarnId,
      this.colourId});

  WarpDetails.fromJson(Map<String, dynamic> json) {
    yarnName = json['yarn_name'];
    colorName = json['color_name'];
    noOfEnds = json['no_of_ends'];
    usage = json['usage'];
    yarnId = json['yarn_id'];
    colourId = json['colour_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['yarn_name'] = this.yarnName;
    data['color_name'] = this.colorName;
    data['no_of_ends'] = this.noOfEnds;
    data['usage'] = this.usage;
    data['colour_id'] = this.colourId;
    data['yarn_id'] = this.yarnId;
    return data;
  }
}
