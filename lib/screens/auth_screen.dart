import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'phone_auth.dart';

class AuthScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User cancelled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/firebase-logo.jpg', height: 120),
              const SizedBox(height: 50),
              _buildSignInButtonWithImage(
                text: 'Google',
                imagePath: "assets/images/google-logo.png",
                color1: Colors.blue,
                color2: Colors.blueAccent,
                onPressed: () => _signInWithGoogle(context),
              ),
              const SizedBox(height: 20),
              _buildSignInButton(
                text: 'Phone',
                icon: Icons.phone,
                color1: Colors.green,
                color2: Colors.lightGreen,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton({
    required String text,
    required IconData icon,
    required Color color1,
    required Color color2,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Left-aligned Icon
              Positioned(
                left: 16, // Adjust left padding
                child: Icon(icon, color: Colors.white, size: 24),
              ),

              /// Centered Text
              Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButtonWithImage({
    required String text,
    required String imagePath,
    required Color color1,
    required Color color2,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.zero,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color1, color2]),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Left-aligned Image
              Positioned(
                left: 16, // Adjust padding for the left position
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// Centered Text
              Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
