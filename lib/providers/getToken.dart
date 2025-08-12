import 'package:firebase_auth/firebase_auth.dart';

Future<String?> getToken() async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    return await user.getIdToken();
  }
  return null;
}
