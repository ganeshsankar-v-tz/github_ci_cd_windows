class WeavingEntryTypeModel {
  int? weaverId;
  int? loom;
  String? entryType;

  WeavingEntryTypeModel({this.weaverId, this.loom, this.entryType});

  WeavingEntryTypeModel.fromJson(Map<String, dynamic> json) {
    weaverId = json['weaver_id'];
    loom = json['loom'];
    entryType = json['entry_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['weaver_id'] = weaverId;
    data['loom'] = loom;
    data['entry_type'] = entryType;
    return data;
  }

  @override
  String toString() {
    return '${entryType}';
  }
}
