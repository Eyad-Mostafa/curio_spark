import 'package:curio_spark/model/profile.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

class ProfileHiveService {
  static const String _boxName = 'profiles';
  static const String _key = 'user';

  static final BehaviorSubject<Profile?> _profileSubject = BehaviorSubject<Profile?>();

  static Box<Profile> get box => Hive.box<Profile>(_boxName);

  static void init() {
    _updateStream();
    box.watch(key: _key).listen((_) => _updateStream());
  }

  static void _updateStream() {
    final profile = box.get(_key);
    _profileSubject.add(profile);
  }

  static Stream<Profile?> get profileStream => _profileSubject.stream;

  static Profile? getProfile() {
    return box.get(_key);
  }

  static Future<void> saveProfile(Profile profile) async {
    await box.put(_key, profile);
    _updateStream();
  }

  static Future<void> deleteProfile() async {
    await box.delete(_key);
    _updateStream();
  }

  static void dispose() {
    _profileSubject.close();
  }
}
