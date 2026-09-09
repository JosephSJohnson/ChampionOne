import '../models/user_account_model.dart';

class AuthSession {
  AuthSession._();

  static final AuthSession instance = AuthSession._();

  UserAccount? _currentUser;

  UserAccount? get currentUser => _currentUser;

  bool get isAuthenticated => _currentUser != null;

  void signIn(UserAccount account) {
    _currentUser = account;
  }

  void signOut() {
    _currentUser = null;
  }

  void clear() {
    _currentUser = null;
  }
}