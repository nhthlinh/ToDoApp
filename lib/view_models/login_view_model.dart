import 'package:flutter/material.dart';
import 'package:to_do_app/repositories/fire_base_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();

  String _userId = '';

  Future<void> signUpOrLogin(
    String email,
    String pass,
    BuildContext context,
  ) async {
    final result = await _firebaseRepository.signUpOrLogin(email, pass);

    if (!context.mounted) return;

    switch (result) {
      case RegistrationResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful.')),
        );

        _userId = (await _firebaseRepository.getCurrentUserId())!;
        break;
      case RegistrationResult.loginSuccess:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful.')));

        _userId = (await _firebaseRepository.getCurrentUserId())!;
        break;
      case RegistrationResult.emailConflict:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is registered with a different password.'),
          ),
        );
        break;
      case RegistrationResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error during log in / registration.')),
        );
        break;
      case RegistrationResult.invalidEmail:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid email format.')));
        break;
      case RegistrationResult.tooManyRequests:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Too many attempts, please try again later.'),
          ),
        );
        break;
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      final result = await _firebaseRepository.logOut();
      notifyListeners();

      switch (result) {
        case UnsubscribeResult.success:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Log out successfully.')),
          );

          _userId = '';
          break;
        case UnsubscribeResult.error:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error during log out.')),
          );
          break;
      }
    } catch (e) {
      debugPrint('Error when unsubscribing: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to log out: $e')));
      }
    }
  }

  String getUserId() {
    return _userId;
  }
}
