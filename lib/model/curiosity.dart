import 'package:curio_spark/services/hive/curiosity_hive_service.dart';
import 'package:hive/hive.dart';

part 'curiosity.g.dart';

@HiveType(typeId: 0)
class Curiosity extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? content;

  @HiveField(2)
  bool isFavorite;

  Curiosity({
    required this.id,
    required this.content,
    this.isFavorite = false,
  });

  static List<Curiosity> curiosities = CuriosityHiveService.getAll();

  static List<Curiosity> sampleData() {
    return [
      Curiosity(id: '01', content: 'With great power comes great responsibility.', isFavorite: true),
      Curiosity(id: '02', content: 'Buy Groceries', isFavorite: true),
      Curiosity(id: '03', content: 'Check Emails'),
      Curiosity(id: '04', content: 'Team Meeting'),
      Curiosity(id: '05', content: 'Work on mobile apps for 2 hours'),
      Curiosity(id: '06', content: 'Flutter compiles to native ARM/x86 code.'),
    ];
  }  
}
