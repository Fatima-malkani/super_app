import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(FirebaseAuth.instance.currentUser);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // =========================================================
  // LOGIN
  // =========================================================

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

  // =========================================================
  // SIGNUP
  // =========================================================

  Future<String?> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user != null) {
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

  // =========================================================
  // UPDATE PROFILE NAME
  // =========================================================

  Future<String?> updateProfileName(
    String name,
  ) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return 'not-logged-in';
      }

      if (name.trim().isEmpty) {
        return 'empty-name';
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'name': name.trim(),
      });

      return null;
    } catch (e) {
      print('UPDATE NAME ERROR: $e');

      return 'update-failed';
    }
  }

  // =========================================================
  // UPLOAD PROFILE IMAGE
  // =========================================================

  Future<String?> uploadProfileImage(
    XFile image,
  ) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return 'not-logged-in';
      }

      // Read image bytes.
      // This works for Web as well as mobile.
      final imageBytes = await image.readAsBytes();

      // Create Storage path
      final storageRef = _storage
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      // Upload image
      await storageRef.putData(
        imageBytes,
        SettableMetadata(
          contentType: 'image/jpeg',
        ),
      );

      // Get download URL
      final imageUrl =
          await storageRef.getDownloadURL();

      // Save URL in Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'profileImageUrl': imageUrl,
      });

      return imageUrl;
    } on FirebaseException catch (e) {
      print('STORAGE ERROR: ${e.code}');
      print('MESSAGE: ${e.message}');

      return e.code;
    } catch (e) {
      print('UPLOAD IMAGE ERROR: $e');

      return 'upload-failed';
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    await _auth.signOut();

    emit(null);
  }
}