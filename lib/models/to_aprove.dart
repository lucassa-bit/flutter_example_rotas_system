part 'to_aprove.g.dart';

class toAprove {
  int id = -1;
  bool isAprovado = false;
  bool isOkayToAprove = true;

  toAprove({required this.id, required this.isAprovado, required this.isOkayToAprove});
  Map<String, dynamic> toJson() => _$toAproveToJson(this);
  factory toAprove.fromJson(Map<String, dynamic> item) => _$toAproveFromJson(item);

}