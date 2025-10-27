class FirmModel {
  int? id;
  String? firmName;
  String? shortCode;
  String? street;
  String? area;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? phone;
  String? fax;
  String? mobile;
  String? email;
  String? web;
  String? bussinessType;
  String? gstNo;
  String? tinNo;
  String? jurisdiction;
  String? iacNo;
  String? bankName;
  String? ifscCode;
  String? bankAccountNo;
  String? logo;
  int? status;
  String? createdAt;
  String? updatedAt;

  FirmModel({
    this.id,
    this.firmName,
    this.shortCode,
    this.street,
    this.area,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.phone,
    this.fax,
    this.mobile,
    this.email,
    this.web,
    this.bussinessType,
    this.gstNo,
    this.tinNo,
    this.jurisdiction,
    this.iacNo,
    this.bankName,
    this.ifscCode,
    this.bankAccountNo,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  FirmModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firmName = json['firm_name'];
    shortCode = json['short_code'];
    street = json['street'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    phone = json['phone'];
    fax = json['fax'];
    mobile = json['mobile'];
    email = json['email'];
    web = json['web'];
    bussinessType = json['bussiness_type'];
    gstNo = json['gst_no'];
    tinNo = json['tin_no'];
    jurisdiction = json['jurisdiction'];
    iacNo = json['iac_no'];
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];
    bankAccountNo = json['bank_account_no'];
    logo = json['logo'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['firm_name'] = firmName;
    data['short_code'] = shortCode;
    data['street'] = street;
    data['area'] = area;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    data['phone'] = phone;
    data['fax'] = fax;
    data['mobile'] = mobile;
    data['email'] = email;
    data['web'] = web;
    data['bussiness_type'] = bussinessType;
    data['gst_no'] = gstNo;
    data['tin_no'] = tinNo;
    data['jurisdiction'] = jurisdiction;
    data['iac_no'] = iacNo;
    data['bank_name'] = bankName;
    data['ifsc_code'] = ifscCode;
    data['bank_account_no'] = bankAccountNo;
    data['logo'] = logo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return '$firmName';
  }
}
