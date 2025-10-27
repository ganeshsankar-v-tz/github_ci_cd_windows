class WeavingProductApprovalModel {
  int? id;
  int? weaverId;
  int? subWeaverNo;
  int? productId;
  int? wages;
  int? firmId;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  dynamic? updatedBy;
  dynamic? designImage;
  String? status;
  dynamic? approvedBy;
  String? eDate;
  String? requestJson;
  String? weaverName;
  String? productName;
  String? firmName;
  String? loomNo;
  String? createdByName;
  dynamic? approvedByName;

  WeavingProductApprovalModel(
      {this.id,
        this.weaverId,
        this.subWeaverNo,
        this.productId,
        this.wages,
        this.firmId,
        this.createdAt,
        this.updatedAt,
        this.createdBy,
        this.updatedBy,
        this.designImage,
        this.status,
        this.approvedBy,
        this.eDate,
        this.requestJson,
        this.weaverName,
        this.productName,
        this.firmName,
        this.loomNo,
        this.createdByName,
        this.approvedByName});

  WeavingProductApprovalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    subWeaverNo = json['sub_weaver_no'];
    productId = json['product_id'];
    wages = json['wages'];
    firmId = json['firm_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    designImage = json['design_image'];
    status = json['status'];
    approvedBy = json['approved_by'];
    eDate = json['e_date'];
    requestJson = json['request_json'];
    weaverName = json['weaver_name'];
    productName = json['product_name'];
    firmName = json['firm_name'];
    loomNo = json['loom_no'];
    createdByName = json['created_by_name'];
    approvedByName = json['approved_by_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['weaver_id'] = this.weaverId;
    data['sub_weaver_no'] = this.subWeaverNo;
    data['product_id'] = this.productId;
    data['wages'] = this.wages;
    data['firm_id'] = this.firmId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['design_image'] = this.designImage;
    data['status'] = this.status;
    data['approved_by'] = this.approvedBy;
    data['e_date'] = this.eDate;
    data['request_json'] = this.requestJson;
    data['weaver_name'] = this.weaverName;
    data['product_name'] = this.productName;
    data['firm_name'] = this.firmName;
    data['loom_no'] = this.loomNo;
    data['created_by_name'] = this.createdByName;
    data['approved_by_name'] = this.approvedByName;
    return data;
  }
}