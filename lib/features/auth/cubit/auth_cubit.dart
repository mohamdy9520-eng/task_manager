import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= LOGIN =================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ================= REGISTER =================
  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Signup failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ================= GOOGLE =================
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        emit(AuthError("Google login cancelled"));
        return;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError("Google Error: ${e.toString()}"));
    }
  }

  // ================= FACEBOOK =================
  Future<void> signInWithFacebook() async {
    emit(AuthLoading());

    try {
      final result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );

        await _auth.signInWithCredential(credential);

        emit(AuthSuccess());
      } else {
        emit(AuthError("Facebook login failed"));
      }
    } catch (e) {
      emit(AuthError("Facebook Error: ${e.toString()}"));
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();

    emit(AuthInitial());
  }
}