import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_firebase/views/home_screen.dart';
import 'package:pinput/pinput.dart';
class OtpScreen extends StatefulWidget {
  String vid;
  OtpScreen({super.key,required this.vid});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  var otpCode = '';
  signIn()async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: otpCode,
    );

    try{
      await FirebaseAuth.instance.signInWithCredential(credential).then((value)
      => Get.offAll(()=> HomeScreen())
      );
    }catch(e){
      Get.snackbar("Error Occured",e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:200,right: 24,left: 24),
              child: Column(
                children: [
                  Center(
                    child: Pinput(
                      length: 6,
                      onChanged: (value){
                        setState(() {
                          otpCode = value;
                        });
                      },
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      signIn();

                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.black,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
