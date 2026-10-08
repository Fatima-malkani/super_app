import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(FirebaseAuth.instance.currentUser);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================
  // LOGIN
  // =========================
  Future<bool> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(result.user);

      return true;
    } catch (e) {
      print('LOGIN ERROR: $e');
      return false;
    }
  }

  // =========================
  // SIGNUP
  // =========================
  Future<String?> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Create Firebase Authentication account
      final result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
        // Save additional user information
        // inside Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({
          'name': name,
          'email': email,
          'walletBalance': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      emit(user);

      return null;
    } on FirebaseAuthException catch (e) {
      print('SIGNUP ERROR: ${e.code}');
      print('MESSAGE: ${e.message}');

      return e.code;
    } catch (e) {
      print('OTHER SIGNUP ERROR: $e');

      return 'unknown-error';
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await _auth.signOut();

    emit(null);
  }
}