import 'package:learnio/base.dart';

part 'deleted_item.g.dart';

@HiveType(typeId: 49)
class DeletedItemData {
  @HiveField(0)
  final dynamic value;

  @HiveField(1)
  final DateTime deletionTime;

  DeletedItemData([this.value, DateTime? deletionTime])
    : deletionTime = deletionTime ?? DateTime.now();
}
