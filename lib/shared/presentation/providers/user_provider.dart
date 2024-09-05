import '../../../../shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier,UserState>((ref) {
  
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(): super( UserState() );

  void saveUserData(User user) {
    state = state.copyWith(user: user);
  }
}

class UserState {
  final User? user;

  UserState({
    this.user,
  });
  UserState copyWith({
    User? user,
  }) => UserState(
    user: user ?? this.user,
  );
}