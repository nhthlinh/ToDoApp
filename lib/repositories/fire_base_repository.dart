import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum RegistrationResult {
  success,
  loginSuccess,
  emailConflict,
  error,
  invalidEmail,
  tooManyRequests,
}

enum UnsubscribeResult { success, error }

class FirebaseRepository {

  Future<RegistrationResult> signUpOrLogin(String email, String pass) async {
    try {
      // Thử tạo tài khoản mới
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return RegistrationResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Nếu đã có tài khoản => Thử đăng nhập
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: pass,
          );
          return RegistrationResult.loginSuccess;
        } on FirebaseAuthException catch (loginError) {
          if (loginError.code == 'wrong-password') {
            log('Email in use but password wrong.');
            return RegistrationResult.emailConflict;
          } else if (loginError.code == 'too-many-requests') {
            return RegistrationResult.tooManyRequests;
          } else {
            log('Login failed: ${loginError.code}');
            return RegistrationResult.error;
          }
        }
      } else if (e.code == 'invalid-email') {
        log('Invalid email format.');
        return RegistrationResult.invalidEmail;
      } else if (e.code == 'weak-password') {
        log('Password is too weak.');
        return RegistrationResult.error;
      } else if (e.code == 'too-many-requests') {
        return RegistrationResult.tooManyRequests;
      } else {
        log('SignUp failed: ${e.code}');
        return RegistrationResult.error;
      }
    } catch (e) {
      log('Unexpected error: $e');
      return RegistrationResult.error;
    }
  }

  Future<UnsubscribeResult> logOut() async {
    try {
      try {
        await FirebaseAuth.instance.signOut();
        return UnsubscribeResult.success;
      } catch (innerError) {
        log('Inner error during logout: $innerError');
        return UnsubscribeResult.error;
      }
    } catch (outerError) {
      log('Outer error during logout: $outerError');
      return UnsubscribeResult.error;
    }
  }

  Future<String?> getCurrentUserId() async {
    final user = await FirebaseAuth.instance.currentUser;
    return user?.uid;
  }


}
