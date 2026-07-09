import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Handles Google Sign-in + Firebase Auth + Firestore user document creation.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs the user in with Google, then creates/updates their Firestore
  /// profile document. Returns the signed-in [User], or null if the user
  /// cancelled the Google account picker.
  Future<User?> signInWithGoogle() async {
    // 1. Trigger the Google account picker
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled the sign-in flow
      return null;
    }

    // 2. Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // 3. Create a new Firebase credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // 4. Sign in to Firebase with that credential
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      await _saveUserToFirestore(user, isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false);
    }

    return user;
  }

  /// Saves/merges the signed-in user's details into `users/{uid}`.
  Future<void> _saveUserToFirestore(User user, {required bool isNewUser}) async {
    final docRef = _firestore.collection('users').doc(user.uid);

    await docRef.set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
      if (isNewUser) 'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}