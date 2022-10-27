import 'dart:developer';

import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/IsFirstTime/IFT_state.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/new_user_verification_screen.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/password_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_field_validator/form_field_validator.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  TextEditingController username = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.question_mark,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
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
      ),
      body: BlocConsumer<IFTBloc, IFTState>(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome !",
                              style:
                                  TextStyle(fontSize: 27, fontFamily: "Roboto"),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Enter Your Iqama Number",
                              style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "Roboto",
                                  color: Colors.black38),
                            ),
                            const SizedBox(height: 20),
                            usernameField(),
                          ],
                        ),
                      ),
                      const Divider(height: 90),
                      SizedBox(
                          width: size.width * 0.8,
                          height: 55,
                          child: submitUserNameButton()),
                      const Divider(height: 90),
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
            if (state.flag) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewUserVerificationScreen(
                          username: username.text,
                        )),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PasswordScreen(
                          username: username.text,
                        )),
              );
            }
          }
        },
      ),
    );
  }

  Widget submitUserNameButton() {
    return BlocBuilder<IFTBloc, IFTState>(builder: (context, state) {
      return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 133, 15, 6)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)))),
        child: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              "Continue",
              style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
            )),
        onPressed: () async {
          log(visible.toString());
          if (formKey.currentState!.validate()) {
            setState(() {
              visible = true;
            });
            context.read<IFTBloc>().add(Sumbitted(username: username.text));
          }
        },
      );
    });
  }

  Widget usernameField() {
    return BlocBuilder<IFTBloc, IFTState>(builder: (context, state) {
      return Form(
        key: formKey,
        child: TextFormField(
            controller: username,
            onSaved: (value) {
              context
                  .read<IFTBloc>()
                  .add(UserNameChanged(username: username.text));
            },
            validator: MultiValidator([
              RequiredValidator(errorText: "* Required"),
            ]),
            decoration: InputDecoration(
              hintStyle: const TextStyle(fontSize: 16, fontFamily: "Roboto"),
              prefixIcon: const Icon(Icons.numbers, color: Colors.black45),
              hintText: "Iqama Number",
              contentPadding: const EdgeInsets.all(14),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 2, color: Colors.black12),
                  borderRadius: BorderRadius.circular(7)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.black38),
                  borderRadius: BorderRadius.circular(7)),
            )),
      );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
