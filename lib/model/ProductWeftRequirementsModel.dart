class ProductWeftRequirementsModel {
  int? id;
  int? productId;
  String? productName;
  String? designNo;
  int? weftForSaree;
  String? requirements;
  List<YarnDetails>? yarnDetails;

  ProductWeftRequirementsModel(
      {this.id,
      this.productId,
      this.productName,
      this.designNo,
      this.weftForSaree,
      this.requirements,
      this.yarnDetails});

  ProductWeftRequirementsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    designNo = json['design_no'];
    weftForSaree = json['weft_for_saree'];
    requirements = json['requirements'];
    if (json['yarn_details'] != null) {
      yarnDetails = <YarnDetails>[];
      json['yarn_details'].forEach((v) {
        yarnDetails!.add(YarnDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['design_no'] = designNo;
    data['weft_for_saree'] = weftForSaree;
    data['requirements'] = requirements;
    if (yarnDetails != null) {
      data['yarn_details'] = yarnDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YarnDetails {
  int? id;
  int? productWeftReqId;
  int? yarnId;
  String? weftType;
  String? quantity;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? yarnName;

  YarnDetails(
      {this.id,
      this.productWeftReqId,
      this.yarnId,
      this.weftType,
      this.quantity,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.yarnName});

  YarnDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productWeftReqId = json['product_weft_req_id'];
    yarnId = json['yarn_id'];
    weftType = json['weft_type'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    yarnName = json['yarn_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_weft_req_id'] = productWeftReqId;
    data['yarn_id'] = yarnId;
    data['weft_type'] = weftType;
    data['quantity'] = quantity;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['yarn_name'] = yarnName;
    return data;
  }
}
