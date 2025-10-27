class WeaverLoomDetailsModel {
  late int id;
  String? ledgerName;
  String? city;
  String? mobileNo;
  int? totalLooms;
  int? activeLooms;
  int? inActiveLoom;
  int? virtualLoom;

  WeaverLoomDetailsModel(
      {required this.id,
      this.ledgerName,
      this.city,
      this.mobileNo,
      this.totalLooms,
      this.activeLooms,
      this.inActiveLoom,
      this.virtualLoom});

  WeaverLoomDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ledgerName = json['ledger_name'];
    city = json['city'];
    mobileNo = json['mobile_no'];
    totalLooms = json['total_looms'];
    activeLooms = json['active_looms'];
    inActiveLoom = json['in_active_loom'];
    virtualLoom = json['virtual_loom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ledger_name'] = ledgerName;
    data['city'] = city;
    data['mobile_no'] = mobileNo;
    data['total_looms'] = totalLooms;
    data['active_looms'] = activeLooms;
    data['in_active_loom'] = inActiveLoom;
    data['virtual_loom'] = virtualLoom;
    return data;
  }

  @override
  String toString() {
    return "$ledgerName";
  }
}
