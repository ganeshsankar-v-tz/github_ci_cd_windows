class NweWarpWagingConfigModel {
  int? id;
  int? newWarpId;
  int? yarnId;
  int? ends;
  dynamic usage;
  int? colorId;
  String? yarnName;
  int? unitId;
  String? unitName;
  String? colorName;
  String? calcTyp;
  dynamic wages;
  dynamic amount;
  dynamic qty;
  dynamic defaultLength;
  dynamic sycons;

  NweWarpWagingConfigModel(
      {this.id,
      this.newWarpId,
      this.yarnId,
      this.ends,
      this.usage,
      this.colorId,
      this.yarnName,
      this.unitId,
      this.unitName,
      this.colorName,
      this.calcTyp,
      this.qty,
      this.defaultLength,
      this.sycons,
      this.amount,
      this.wages});

  NweWarpWagingConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newWarpId = json['new_warp_id'];
    yarnId = json['yarn_id'];
    ends = json['ends'];
    usage = json['usage'];
    colorId = json['color_id'];
    yarnName = json['yarn_name'];
    unitId = json['unit_id'];
    unitName = json['unit_name'];
    colorName = json['color_name'] ?? '';
    calcTyp = json['calc_typ'];
    qty = json['qty'] ?? 0;
    amount = json['amount'] ?? 0;
    wages = json['wages'];
    defaultLength = json['dft_length'];
    sycons = json['sycons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['new_warp_id'] = newWarpId;
    data['yarn_id'] = yarnId;
    data['ends'] = ends;
    data['usage'] = usage;
    data['color_id'] = colorId;
    data['yarn_name'] = yarnName;
    data['unit_id'] = unitId;
    data['unit_name'] = unitName;
    data['color_name'] = colorName;
    data['calc_typ'] = calcTyp;
    data['qty'] = qty;
    data['amount'] = amount;
    data['wages'] = wages;
    data['dft_length'] = defaultLength;
    data['sycons'] = sycons;
    return data;
  }
}
