import 'package:curio_spark/model/curiosity.dart';
import 'package:curio_spark/services/notificationservuce.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class CuriosityHiveService {
  static const String _boxName = 'curiosities';
  static final BehaviorSubject<List<Curiosity>> _curiositiesSubject = 
      BehaviorSubject<List<Curiosity>>();

  static Box<Curiosity> get box => Hive.box<Curiosity>(_boxName);

  static void init() {
    _updateStream();
    box.watch().listen((_) => _updateStream());
  }

  static void _updateStream() {
    _curiositiesSubject.add(box.values.toList());
  }

  static Stream<List<Curiosity>> get curiositiesStream => _curiositiesSubject.stream;

  static List<Curiosity> getAll() {
    return box.values.toList();
  }

  static Future<void> addCuriosity(Curiosity curiosity) async {
  if (curiosity != null) {
    await box.put(curiosity.id, curiosity);
    _updateStream();

    // Show notification for new curiosity
    await NotificationService.notifyNewCuriosity();
  }
}


  static Future<void> deleteCuriosity(String? id) async {
    if (id == null) return;

    await box.delete(id);
    _updateStream();
  }

  static Future<void> clear() async {
    await box.clear();
    _updateStream();
  }

  static Future<void> toggleFavorite(String? id) async {
    if (id == null) return;
    
    final curiosity = box.get(id);
    if (curiosity != null) {
      curiosity.isFavorite = !curiosity.isFavorite;
      await box.put(id, curiosity); // directly save the curiosity
      _updateStream();
    }
  }

  static void dispose() {
    _curiositiesSubject.close();
  }
}
