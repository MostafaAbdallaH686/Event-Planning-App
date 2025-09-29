import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';
import 'package:event_planning_app/core/utils/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class InterestsRepository {
  Future<void> saveSelectedCategoriesLocally(List<String> categoryIds);
  Future<void> saveSelectedCategoriesToFirebase(List<String> categoryIds);
  Future<List<String>> getSelectedCategories();
}

class InterestsRepo implements InterestsRepository {
  final CacheHelper _cacheHelper;
  final FirestoreService _firestoreService;

  InterestsRepo(this._cacheHelper, this._firestoreService);

  @override
  Future<void> saveSelectedCategoriesLocally(List<String> categoryIds) async {
    await _cacheHelper.saveData(
      key: SharedPrefereneceKey.favInterests,
      value: categoryIds,
    );
  }

  @override
  Future<void> saveSelectedCategoriesToFirebase(
      List<String> categoryIds) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestoreService.saveUserInterests(user.uid, categoryIds);
  }

  @override
  Future<List<String>> getSelectedCategories() async {
    // You can choose to load from Firebase or local cache
    final data = _cacheHelper.getData(key: SharedPrefereneceKey.favInterests);
    return data ?? [];
  }
}
