import 'package:cleanapp/core/ui_constants/fonts.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/login/login_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/login/login_state.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/verification_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../../../core/ui_constants/border_radius.dart';
import '../../../../core/ui_constants/colors.dart';
import '../../../../main.dart';
import '../../../localization/language.dart';
import '../../../localization/language_pref.dart';
import '../bloc/login/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _buildBody(size),
    );
  }

  Widget _buildBody(Size size) {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: size.width,
          height: size.height,
          child: Center(
              child: SingleChildScrollView(child: loginForm(size, context))));
    }));
  }

  Widget emailTextField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        validator: MultiValidator([
          RequiredValidator(errorText: "* Required"),
          EmailValidator(errorText: "Enter valid email id"),
        ]),
        controller: username,
        onSaved: (value) {
          username.text = value!;
          context
              .read<LoginBloc>()
              .add(LoginUserNameChanged(username: username.text));
        },
        decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: body_font_size),
            prefixIcon: const Icon(Icons.numbers),
            iconColor: third_color,
            hintText: "Enter Id Or Iqama Number",
            contentPadding: const EdgeInsets.all(17),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
            )),
      );
    });
  }

  Widget myForm(Size size, BuildContext context) {
    var value = false;
    return Form(
      key: formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: DropdownButton<Language>(
                        icon: const Icon(Icons.language),
                        iconSize: 25,
                        elevation: 16,
                        items: Language.languageList()
                            .map<DropdownMenuItem<Language>>(
                              (e) => DropdownMenuItem<Language>(
                                value: e,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      e.flag,
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                    Text(e.name)
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (Language? language) async {
                          if (language != null) {
                            Locale locale =
                                await setLocale(language.languageCode);
                            MyApp.setLocale(context, locale);
                          }
                        },
                      )),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset('assets/img.png'),
                  ),
                  Positioned(
                    top: 40,
                    left: 70,
                    child: Image.asset('assets/img2.png'),
                  ),
                  Positioned(
                    top: 70,
                    left: 0,
                    child: Image.asset('assets/img3.png'),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: size.width,
              height: 50,
              child: const Text(
                "Sign In To Fipay",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: primary_color,
                ),
              ),
            ),
            emailTextField(),
            const SizedBox(height: 10),
            passwordTextField(),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width,
              height: 55,
              child: CheckboxListTile(
                title: const Text("Remember Me"),
                value: value,
                onChanged: (value) => {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: size.width, height: 55, child: signInButton(formKey)),
            TextButton(
              child: const Text(
                "Forget Password?",
                style: TextStyle(
                    color: text_third_color,
                    fontSize: large_font_size,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {},
            ),
          ]),
    );
  }

  Widget loginForm(Size size, BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      builder: ((context, state) {
        return myForm(size, context);
      }),
      listener: (context, state) {
        if (state is SubmissionFailed) {
          _showSnackBar(context, state.message);
        } else if (state is SubmissionSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VerificationScreen()),
          );
        }
      },
    );
  }

  Widget passwordTextField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return TextFormField(
        validator: MultiValidator([
          RequiredValidator(errorText: "* Required"),
          MinLengthValidator(6,
              errorText: "Password should be atleast 6 characters"),
          MaxLengthValidator(15,
              errorText: "Password should not be greater than 15 characters")
        ]),
        obscureText: true,
        controller: password,
        onSaved: (value) {
          password.text = value!;
          context
              .read<LoginBloc>()
              .add(LoginPasswordChanged(password: password.text));
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(17),
            hintStyle: const TextStyle(fontSize: body_font_size),
            prefixIcon: const Icon(Icons.lock),
            iconColor: third_color,
            hintText: "Enter Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS),
            )),
      );
    }));
  }

  Widget signInButton(GlobalKey<FormState> key) {
    bool visible = false;
    return BlocBuilder<LoginBloc, LoginState>(builder: ((context, state) {
      return ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(text_secondary_color),
            backgroundColor: MaterialStateProperty.all(primary_color),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DEFAULT_BORDER_RADIUS)))),
        child: Padding(
            padding: const EdgeInsets.all(14),
            child: visible == false
                ? const Text(
                    "Sign In",
                    style: TextStyle(fontSize: large_font_size),
                  )
                : const CircularProgressIndicator()),
        onPressed: () async {
          visible = true;
          if (key.currentState!.validate()) {
            context.read<LoginBloc>().add(LoginSubmitted(
                username: username.text, password: password.text));
          }
        },
      );
    }));
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
