import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _verificationId = ''; // Store the verification ID
  bool _isCodeSent = false; // Track if OTP is sent
  bool _isLoading = false; // Track loading state

  Future<void> _verifyPhoneNumber() async {
    print("_phoneController.text");
    print(_phoneController.text);
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${_phoneController.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatically sign in the user if verification is completed
          await _auth.signInWithCredential(credential);
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacementNamed(context, '/home'); // Navigate to home screen
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isCodeSent = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        timeout: Duration(seconds: 60), // Timeout for OTP
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a PhoneAuthCredential with the OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );

      // Sign in the user with the credential
      await _auth.signInWithCredential(credential);

      setState(() {
        _isLoading = false;
      });

      // Navigate to the home screen
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isCodeSent)
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixText: '+91 ', // Change to your country code
                ),
                keyboardType: TextInputType.phone,
              ),
            if (_isCodeSent)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter the OTP',
                ),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 20),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _isCodeSent ? _verifyOTP : _verifyPhoneNumber,
                child: Text(_isCodeSent ? 'Verify OTP' : 'Send OTP'),
              ),
          ],
        ),
      ),
    );
  }
}