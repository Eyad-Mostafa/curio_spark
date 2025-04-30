import 'package:hive/hive.dart';

part 'profile.g.dart';

@HiveType(typeId: 1)
class Profile extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? image;

  Profile({
    required this.name,
    required this.email,
    this.image,
  });
}