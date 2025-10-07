import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleTokenScreen extends StatefulWidget {
  const GoogleTokenScreen({super.key});

  @override
  State<GoogleTokenScreen> createState() => _GoogleTokenScreenState();
}

class _GoogleTokenScreenState extends State<GoogleTokenScreen> {
  GoogleSignInAccount? _user;
  String? _idToken;
  String? _accessToken;

  @override
  void initState() {
    super.initState();

    final signIn = GoogleSignIn.instance;

    // Initialize Google Sign-In
    signIn.initialize().then((_) {
      // Listen for authentication events
      signIn.authenticationEvents.listen((event) async {
        switch (event) {
          case GoogleSignInAuthenticationEventSignIn():
            final account = event.user;
            final auth = await account.authentication;
            setState(() {
              _user = account;
              _idToken = auth.idToken;
              // _accessToken = auth.;
            });
            break;

          case GoogleSignInAuthenticationEventSignOut():
            setState(() {
              _user = null;
              _idToken = null;
              _accessToken = null;
            });
            break;
        }
      });
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await GoogleSignIn.instance.authenticate();
    } catch (e) {
      print("Google Sign-In failed: $e");
    }
  }

  Future<void> _handleSignOut() async {
    await GoogleSignIn.instance.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Token Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null) ...[
              Text("Email: ${_user!.email}"),
              Text("ID Token:\n$_idToken"),
              Text("Access Token:\n$_accessToken"),
              ElevatedButton(
                onPressed: _handleSignOut,
                child: const Text("Sign Out"),
              ),
            ] else
              ElevatedButton(
                onPressed: _handleSignIn,
                child: const Text("Sign in with Google"),
              ),
          ],
        ),
      ),
    );
  }
}
