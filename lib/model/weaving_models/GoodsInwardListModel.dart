class GoodsInwardListModel {
  int? id;
  String? eDate;
  int? challanNo;
  int? weaverId;
  String? weaverName;
  String? wagesStatus;
  int? qty;
  String? creatorName;
  String? updatedName;
  String? updatedAt;
  String? createdAt;

  GoodsInwardListModel(
      {this.id,
      this.eDate,
      this.challanNo,
      this.weaverId,
      this.weaverName,
      this.wagesStatus,
      this.qty,
      this.creatorName,
      this.updatedName,
      this.updatedAt,
      this.createdAt});

  GoodsInwardListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDate = json['e_date'];
    challanNo = json['challan_no'];
    weaverId = json['weaver_id'];
    weaverName = json['weaver_name'];
    wagesStatus = json['wages_status'];
    qty = json['qty'];
    creatorName = json['creator_name'];
    updatedName = json['updated_name'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['e_date'] = eDate;
    data['challan_no'] = challanNo;
    data['weaver_id'] = weaverId;
    data['weaver_name'] = weaverName;
    data['wages_status'] = wagesStatus;
    data['qty'] = qty;
    data['creator_name'] = creatorName;
    data['updated_name'] = updatedName;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    return data;
  }
}
