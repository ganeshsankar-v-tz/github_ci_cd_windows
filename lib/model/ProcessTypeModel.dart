class ProcessTypeModel {
  int? id;
  String? processType;
  String? isActive;

  ProcessTypeModel({
    this.id,
    this.processType,
    this.isActive,
  });

  ProcessTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    processType = json['process_type'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['process_type'] = processType;
    data['is_active'] = isActive;
    return data;
  }

  @override
  String toString() {
    return "$processType";
  }
}
