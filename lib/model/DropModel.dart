class DropModel {
  int? id;
  String? name;

  DropModel({required this.id, required this.name});
  @override
  String toString() {
    return '$name';
  }
}
