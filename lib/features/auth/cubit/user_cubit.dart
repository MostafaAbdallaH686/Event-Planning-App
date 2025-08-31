import 'package:event_planning_app/features/auth/data/user_model.dart';
import 'package:event_planning_app/features/auth/data/user_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> loginWithUsername(String username, String password) async {
    emit(UserLoadingUsername());
    try {
      UserModel user = await _repository.loginWithUsername(username, password);
      emit(UserLoggedIn(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> loginWithFacebook() async {
    emit(UserLoadingFacebook());
    try {
      UserModel user = await _repository.loginWithFacebook();
      emit(UserLoggedIn(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
