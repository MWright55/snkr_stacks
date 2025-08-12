import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snkr_stacks/home/home.dart';
import 'package:snkr_stacks/home/homeUser.dart';
import 'package:snkr_stacks/models/user.dart' as model;
import 'package:snkr_stacks/screens/no_internet.dart';
import '../providers/getToken.dart';
import '../screens/authenticate/vndy_login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:snkr_stacks/providers/resources.dart' as Resources;
import 'package:snkr_stacks/providers/connectivity.dart';

/// Wrapper determines the initial screen based on:
/// - Firebase auth state
/// - Internet connection
/// - Admin profile detection (via token-protected REST call)
class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late bool currentAdmin;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Track the current connectivity state from provider
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth changes
      builder: (context, snapshot) {
        final user = snapshot.data;

        // Show loading spinner while auth state is being determined
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitWave(color: Colors.black, size: 25.0);
        }

        // Show No Internet screen if disconnected
        if (isOnline == false) {
          return NoInternetScreen();
        }

        // Show login screen if user is signed out
        if (user == null) {
          return VndyLogin();
        }

        // User is signed in — check if they are admin
        return FutureBuilder<String>(
          future: _checkUser(user.uid),
          builder: (context, adminSnapshot) {
            // Show loading spinner while role is being verified
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const SpinKitWave(color: Colors.black, size: 25.0);
            }

            // Route to Home (admin) or HomeUser (non-admin)
            if (adminSnapshot.data == 'true') {
              return Home();
            } else {
              return HomeUser();
            }
          },
        );
      },
    );
  }

  /// Checks if the given UID belongs to an admin by calling the ADMIN_URL
  /// Returns:
  /// - 'true' if UID found in admin list
  /// - 'false' otherwise
  Future<String> _checkUser(String uid) async {
    // Get Firebase ID token to authorize backend request
    String? token = await getToken();

    if (token == null) {
      // No token available; treat as non-admin
      return 'false';
    }

    final url = '${Resources.ADMIN_URL}?auth=$token';

    // Perform GET request to backend admin list
    final response = await http.get(Uri.parse(url));

    // DEBUG:
    // print("Admin list response: ${response.body}");

    // Return 'true' if UID is found in the admin list
    if (response.body.contains(uid)) {
      // print("UID Found — User is admin");
      return 'true';
    } else {
      // print("UID Not Found — User is not admin");
      return 'false';
    }
  }
}
