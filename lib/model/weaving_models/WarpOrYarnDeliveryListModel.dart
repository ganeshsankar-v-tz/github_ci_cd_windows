class WarpOrYarnDeliveryListModel {
  int? id;
  String? entryType;
  int? weavingAcId;
  int? challanNo;
  String? eDate;
  int? weaverId;
  String? weaverName;
  String? creatorName;
  String? updatedName;
  String? createdAt;
  String? updatedAt;

  WarpOrYarnDeliveryListModel({
    this.id,
    this.entryType,
    this.weavingAcId,
    this.challanNo,
    this.eDate,
    this.weaverId,
    this.weaverName,
    this.creatorName,
    this.updatedName,
    this.createdAt,
    this.updatedAt,
  });

  WarpOrYarnDeliveryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entryType = json['entry_type'];
    weavingAcId = json['weaving_ac_id'];
    challanNo = json['challan_no'];
    eDate = json['e_date'];
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['entry_type'] = entryType;
    data['weaving_ac_id'] = weavingAcId;
    data['challan_no'] = challanNo;
    data['e_date'] = eDate;
    data['weaver_id'] = weaverId;
    data['weaver_name'] = weaverName;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
