import 'package:curio_spark/model/curiosity.dart';
import 'package:hive/hive.dart';

class CuriosityHiveService {
  static const String _boxName = 'curiosities';

  static Box<Curiosity> get box => Hive.box<Curiosity>(_boxName);

  static List<Curiosity> getAll() {
    return box.values.toList();
  }

  static Future<void> add(Curiosity curiosity) async {
    await box.put(curiosity.id, curiosity);
  }

  static Future<void> clear() async {
    await box.clear();
  }

  static Future<void> toggleFavorite(String? id) async {
  final curiosity = box.get(id);
  if (curiosity != null) {
    curiosity.isFavorite = !curiosity.isFavorite;
    await curiosity.save();
    print('Toggled favorite for ${curiosity.id}. New state: ${curiosity.isFavorite}');
  }
}
}