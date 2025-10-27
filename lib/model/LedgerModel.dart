class LedgerModel {
  int? id;
  String? ledgerName;
  String? shortCode;
  String? isActive;
  String? referredBy;
  String? street;
  String? area;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? transport;
  String? phone;
  String? fax;
  String? mobileNo;
  String? email;
  String? tinNo;
  String? gstNo;
  String? details;
  String? panNo;
  String? ledgerRole;
  String? linkThrough;
  String? regtyp;
  String? llName;
  String? image;
  int? status;
  String? cstNo;
  String? aadharNo;
  String? createdAt;
  String? updatedAt;
  String? agentName;
  String? cProductStatus;
  String? cYarnStatus;
  String? cWarpStatus;
  String? accoutType;
  int? firmId;
  String? ledgerRoleId;
  String? supplier;
  String? customer;
  String? warper;
  String? weaver;
  String? dyer;
  String? roller;
  String? employee;
  String? processor;
  String? jobWorker;
  String? winder;
  String? operator;
  String? sProductStatus;
  String? sYarnStatus;
  String? sWarpStatus;
  String? stockInActive;

  LedgerModel(
      {this.id,
      this.ledgerName,
      this.shortCode,
      this.isActive,
      this.referredBy,
      this.street,
      this.area,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.transport,
      this.phone,
      this.fax,
      this.mobileNo,
      this.email,
      this.tinNo,
      this.gstNo,
      this.details,
      this.panNo,
      this.ledgerRole,
      this.linkThrough,
      this.regtyp,
      this.llName,
      this.image,
      this.status,
      this.cstNo,
      this.aadharNo,
      this.createdAt,
      this.updatedAt,
      this.agentName,
      this.cProductStatus,
      this.cYarnStatus,
      this.cWarpStatus,
      this.accoutType,
      this.firmId,
      this.ledgerRoleId,
      this.supplier,
      this.customer,
      this.warper,
      this.weaver,
      this.dyer,
      this.roller,
      this.employee,
      this.processor,
      this.jobWorker,
      this.winder,
      this.operator,
      this.sProductStatus,
      this.sYarnStatus,
      this.sWarpStatus,
      this.stockInActive});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ledgerName = json['ledger_name'];
    shortCode = json['short_code'];
    isActive = json['is_active'];
    referredBy = json['referred_by'];
    street = json['street'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    transport = json['transport'];
    phone = json['phone'];
    fax = json['fax'];
    mobileNo = json['mobile_no'];
    email = json['email'];
    tinNo = json['tin_no'];
    gstNo = json['gst_no'];
    details = json['details'];
    panNo = json['pan_no'];
    ledgerRole = json['ledger_role'];
    linkThrough = json['link_through'];
    regtyp = json['regtyp'];
    llName = json['ll_name'];
    image = json['image'];
    status = json['status'];
    cstNo = json['cst_no'];
    aadharNo = json['aadhar_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    agentName = json['agent_name'];
    cProductStatus = json['c_product_status'];
    cYarnStatus = json['c_yarn_status'];
    cWarpStatus = json['c_warp_status'];
    accoutType = json['accout_type'];
    firmId = json['firm_id'];
    ledgerRoleId = json['ledger_role_id'];
    supplier = json['supplier'];
    customer = json['customer'];
    warper = json['warper'];
    weaver = json['weaver'];
    dyer = json['dyer'];
    roller = json['roller'];
    employee = json['employee'];
    processor = json['processor'];
    jobWorker = json['job_worker'];
    winder = json['winder'];
    operator = json['operator'];
    sProductStatus = json['s_product_status'];
    sYarnStatus = json['s_yarn_status'];
    sWarpStatus = json['s_warp_status'];
    stockInActive = json['stock_in_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ledger_name'] = ledgerName;
    data['short_code'] = shortCode;
    data['is_active'] = isActive;
    data['referred_by'] = referredBy;
    data['street'] = street;
    data['area'] = area;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['pincode'] = pincode;
    data['transport'] = transport;
    data['phone'] = phone;
    data['fax'] = fax;
    data['mobile_no'] = mobileNo;
    data['email'] = email;
    data['tin_no'] = tinNo;
    data['gst_no'] = gstNo;
    data['details'] = details;
    data['ledger_role'] = ledgerRole;
    data['link_through'] = linkThrough;
    data['regtyp'] = regtyp;
    data['ll_name'] = llName;
    data['image'] = image;
    data['status'] = status;
    data['cst_no'] = cstNo;
    data['aadhar_no'] = aadharNo;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['agent_name'] = agentName;
    data['c_product_status'] = cProductStatus;
    data['c_yarn_status'] = cYarnStatus;
    data['c_warp_status'] = cWarpStatus;
    data['accout_type'] = accoutType;
    data['firm_id'] = firmId;
    data['ledger_role_id'] = ledgerRoleId;
    data['supplier'] = supplier;
    data['customer'] = customer;
    data['warper'] = warper;
    data['weaver'] = weaver;
    data['dyer'] = dyer;
    data['roller'] = roller;
    data['employee'] = employee;
    data['processor'] = processor;
    data['job_worker'] = jobWorker;
    data['winder'] = winder;
    data['operator'] = operator;
    data['s_product_status'] = sProductStatus;
    data['s_yarn_status'] = sYarnStatus;
    data['s_warp_status'] = sWarpStatus;
    data['stock_in_active'] = stockInActive;
    data['pan_no'] = panNo;
    return data;
  }

  @override
  String toString() {
    return '$ledgerName';
  }
}
