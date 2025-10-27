class MDecimal {
  String? item;
  String? label;

  MDecimal({
    this.item,
    this.label,
  });

  MDecimal.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item'] = item;
    data['label'] = label;
    return data;
  }

  @override
  String toString() {
    return '$label';
  }
}
