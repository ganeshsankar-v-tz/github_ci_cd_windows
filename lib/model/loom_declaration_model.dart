class LoomDeclarationModel {
  int? id;
  int? weaverId;
  String? introDate;
  String? details;
  int? status;
  String? llName;
  String? subWeaverNo;
  String? isActive;
  String? sunday;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saterday;
  String? loomStatus;
  String? brench;
  String? ifscNo;
  String? accountNo;
  String? panNo;
  int? tdsPerc;
  String? acHolder;
  String? loomType;
  String? aatharNo;
  String? benifAcTyp;
  String? lmBreak;
  String? bankName;
  String? weaverName;

  LoomDeclarationModel({
    this.id,
    this.weaverId,
    this.introDate,
    this.details,
    this.status,
    this.llName,
    this.subWeaverNo,
    this.isActive,
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saterday,
    this.loomStatus,
    this.brench,
    this.ifscNo,
    this.accountNo,
    this.panNo,
    this.tdsPerc,
    this.acHolder,
    this.loomType,
    this.aatharNo,
    this.benifAcTyp,
    this.lmBreak,
    this.bankName,
    this.weaverName,
  });

  LoomDeclarationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    weaverId = json['weaver_id'];
    introDate = json['intro_date'];
    details = json['details'];
    status = json['status'];
    llName = json['ll_name'];
    subWeaverNo = json['sub_weaver_no'];
    isActive = json['is_active'];
    sunday = json['sunday'];
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saterday = json['saterday'];
    loomStatus = json['loom_status'];
    brench = json['brench'];
    ifscNo = json['ifsc_no'];
    accountNo = json['account_no'];
    panNo = json['pan_no'];
    tdsPerc = json['tds_perc'];
    acHolder = json['ac_holder'];
    loomType = json['loom_type'];
    aatharNo = json['aathar_no'];
    benifAcTyp = json['benif_ac_typ'];
    lmBreak = json['lm_break'];
    bankName = json['bank_name'];
    weaverName = json['weaver_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['weaver_id'] = weaverId;
    data['intro_date'] = introDate;
    data['details'] = details;
    data['status'] = status;
    data['ll_name'] = llName;
    data['sub_weaver_no'] = subWeaverNo;
    data['is_active'] = isActive;
    data['sunday'] = sunday;
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    data['wednesday'] = wednesday;
    data['thursday'] = thursday;
    data['friday'] = friday;
    data['saterday'] = saterday;
    data['loom_status'] = loomStatus;
    data['brench'] = brench;
    data['ifsc_no'] = ifscNo;
    data['account_no'] = accountNo;
    data['pan_no'] = panNo;
    data['tds_perc'] = tdsPerc;
    data['ac_holder'] = acHolder;
    data['loom_type'] = loomType;
    data['aathar_no'] = aatharNo;
    data['benif_ac_typ'] = benifAcTyp;
    data['lm_break'] = lmBreak;
    data['bank_name'] = bankName;
    data['weaver_name'] = weaverName;
    return data;
  }
}
