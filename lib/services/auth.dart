import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:snkr_stacks/models/user.dart' as model;

/// Authentication service to manage Firebase Auth & related logic
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.ref();

  /// Create custom user model from Firebase user
  model.User? _userFromFirebaseUser(User? user) {
    return user != null ? model.User(uid: user.uid) : null;
  }

  /// Stream of auth state changes (user sign in/out)
  Stream<model.User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  /// Sign in with email and password
  Future<model.User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // print("** Signed in as: ${user?.uid}");
      return _userFromFirebaseUser(user);
    } catch (e) {
      // print("Sign in error: $e");
      return null;
    }
  }

  /// Register a new user with email, password, and username
  Future<dynamic> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Update Firebase display name with custom username
      await user?.updateDisplayName(username);
      return _userFromFirebaseUser(user);
    } catch (e) {
      // print("Registration error: $e");
      return e.toString(); // Optionally: return null or throw if you want to handle externally
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // print("Password reset error: $e");
      rethrow; // optionally handle error upstream
    }
  }

  /// Creates a sample user record in the Realtime Database (can be removed or adjusted for real use)
  void createUserTable() {
    databaseReference.child('users/').set({'id': 'ID1', 'data': 'This is a sample data'});
    // print('*** createUserTable done ***');
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // print("Sign out error: $e");
      return;
    }
  }

  /// Delete the currently signed-in user
  Future<void> deleteUser() async {
    try {
      // print('Now in deleteUser');
      User? user = _auth.currentUser;
      // print('Current user: $user');

      await user?.delete();
      await _auth.signOut();
    } catch (e) {
      // print("Delete user error: $e");
      rethrow; // rethrow to allow UI to handle error if needed
    }
  }
}
