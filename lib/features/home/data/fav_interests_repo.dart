import 'package:event_planning_app/core/utils/cache/cache_helper.dart';
import 'package:event_planning_app/core/utils/cache/shared_preferenece_key.dart';

abstract class InterestsRepository {
  Future<void> saveSelectedCategories(List<String> categoryIds);
  Future<List<String>> getSelectedCategories();
}

class InterestsRepo implements InterestsRepository {
  final CacheHelper _cacheHelper;

  InterestsRepo(this._cacheHelper);

  @override
  Future<void> saveSelectedCategories(List<String> categoryIds) async {
    await _cacheHelper.saveData(
        key: SharedPrefereneceKey.favInterests, value: categoryIds);
  }

  @override
  Future<List<String>> getSelectedCategories() async {
    final data = _cacheHelper.getData(key: 'selected_categories');
    return data ?? [];
  }
}
