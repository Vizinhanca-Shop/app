import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class Login extends StatelessWidget {
  final String title;
  final String message;

  const Login({super.key, required this.title, required this.message});

  Future<void> _handleSignIn() async {
    try {
      final credentials = await _googleSignIn.signIn();
      final authentication = await credentials?.authentication;
      print({authentication?.accessToken});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.sora(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GoogleSignInButton(onPressed: _handleSignIn),
        ],
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: Colors.white,
      elevation: 0,
      hoverElevation: 1,
      highlightElevation: 1,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        constraints: const BoxConstraints(minWidth: 220),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google.png', height: 24, width: 24),
            const SizedBox(width: 12),
            Text(
              'Entrar com Google',
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
