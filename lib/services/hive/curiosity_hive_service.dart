import 'package:curio_spark/model/curiosity.dart';
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
    await box.put(curiosity.id, curiosity);
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
      await curiosity.save();
      _updateStream();
    }
  }

  static void dispose() {
    _curiositiesSubject.close();
  }
}