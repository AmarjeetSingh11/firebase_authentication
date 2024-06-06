import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:login_firebase/views/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  sendCode()async {
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+91${phoneNumber.text}',
          verificationCompleted: (PhoneAuthCredential credential){},
          verificationFailed: (FirebaseAuthException e){
            Get.snackbar("Firebase OTP Send related Waring", e.toString(),snackPosition: SnackPosition.BOTTOM);
          },
          codeSent:(String vid,int? token){
            Get.to(()=> OtpScreen(vid: vid,));
          },
          codeAutoRetrievalTimeout: (vid){}
      );
    }catch(e){
      Get.snackbar("Error Occured", e.toString(),snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 200, right: 24, left: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: phoneNumber,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone number";
                      } else if (value.length != 10) {
                        return "Please enter a 10-digit phone number";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "Enter Phone Number",
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.phone_android_outlined),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        counterText: "",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Form is valid, proceed with OTP sending
                            Get.snackbar("OTP Sent", "OTP has been sent to ${phoneNumber.text}");
                            sendCode();


                          } else {
                            // Form is not valid, show error message
                            Get.snackbar("Invalid Input", "Please correct the errors in the form");
                          }
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
                              "Send OTP",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
