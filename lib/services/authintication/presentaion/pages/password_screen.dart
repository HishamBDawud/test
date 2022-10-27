import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/Password/password_state.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/verification_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key, required this.username});
  final String username;
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController password = TextEditingController();
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.question_mark,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sign In",
          style: TextStyle(
              color: Colors.black, fontSize: 17, fontFamily: "Roboto"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocConsumer<PasswordBloc, PasswordState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: size.width,
              height: size.height - 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter Your Password",
                              style:
                                  TextStyle(fontSize: 27, fontFamily: "Roboto"),
                            ),
                            const SizedBox(height: 40),
                            passwordTextField(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Forget Password ? ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      fontFamily: "Roboto"),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: const Text(
                                      "Reset Password",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: "Roboto"),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                      const Divider(height: 50),
                      SizedBox(
                          width: size.width * 0.9,
                          height: 55,
                          child: submitPasswordButton()),
                      const Divider(height: 50),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Visibility(
                            visible: visible,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainState: true,
                            child: const CircularProgressIndicator()),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width * 0.9,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Roboto",
                                color: Colors.black26),
                            children: <TextSpan>[
                              const TextSpan(
                                  text:
                                      'By clicking Sign In, you agree to our '),
                              TextSpan(
                                  text: '\nTerms of Service',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontSize: 14),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                  text: 'Privacy Policy',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                      fontSize: 14),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is SubmissionFailed) {
            _showSnackBar(context, state.message);
            visible = false;
          } else if (state is SubmissionSuccess) {
            visible = false;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const VerificationScreen()),
            );
          }
        },
      ),
    );
  }

  Widget passwordTextField() {
    return BlocBuilder<PasswordBloc, PasswordState>(builder: (context, state) {
      return Form(
        key: formKey,
        child: TextFormField(
            controller: password,
            obscureText: true,
            onSaved: (value) {
              context.read<PasswordBloc>().add(GetUsername(
                  password: password.text, username: widget.username));
            },
            validator: MultiValidator([
              RequiredValidator(errorText: "* Required"),
              MinLengthValidator(6,
                  errorText: "Password should be atleast 6 characters"),
              MaxLengthValidator(15,
                  errorText:
                      "Password should not be greater than 15 characters")
            ]),
            decoration: InputDecoration(
              hintStyle: const TextStyle(fontSize: 15, fontFamily: "Roboto"),
              prefixIcon: const Icon(Icons.lock, color: Colors.black45),
              hintText: "Enter Your Password",
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.black12),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                  borderRadius: BorderRadius.circular(8)),
            )),
      );
    });
  }

  Widget submitPasswordButton() {
    return BlocBuilder<PasswordBloc, PasswordState>(builder: (context, state) {
      return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 133, 15, 6)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)))),
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            "Sign In",
            style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
          ),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            setState(() {
              visible = true;
            });
            context.read<PasswordBloc>().add(
                Submitted(password: password.text, username: widget.username));
          }
        },
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
