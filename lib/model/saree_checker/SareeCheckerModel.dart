class SareeCheckerModel {
  int? id;
  String? checkerName;
  String? cellNo;
  String? area;
  String? isActive;

  SareeCheckerModel({
    this.id,
    this.checkerName,
    this.cellNo,
    this.area,
    this.isActive,
  });

  SareeCheckerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkerName = json['checker_name'];
    cellNo = json['cell_no'];
    area = json['area'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['checker_name'] = checkerName;
    data['cell_no'] = cellNo;
    data['area'] = area;
    data['is_active'] = isActive;
    return data;
  }

  @override
  String toString() {
    return "$checkerName";
  }
}
