import 'package:cleanapp/services/authintication/presentaion/bloc/newPassword/new_password_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newPassword/new_password_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/newPassword/new_password_state.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/username_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

class NewPasswordScreen extends StatefulWidget {
  final String username;
  final String OTP;
  const NewPasswordScreen(
      {super.key, required this.OTP, required this.username});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
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
        body: BlocConsumer<NewPasswordBloc, NewPasswordState>(
          builder: ((context, state) {
            return SizedBox(
                width: size.width,
                height: size.height - 90,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Create new password",
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: "Roboto"),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "The password must be atleast 8 characters and should contain numbers and characters",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black38,
                                          fontFamily: "Roboto"),
                                    )
                                  ]),
                              const SizedBox(height: 30),
                              TextFormField(
                                  controller: password,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "* Required"),
                                    MinLengthValidator(6,
                                        errorText:
                                            "Password should be atleast 6 characters"),
                                    MaxLengthValidator(15,
                                        errorText:
                                            "Password should not be greater than 15 characters")
                                  ]),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintStyle: const TextStyle(
                                        fontSize: 16, fontFamily: "Roboto"),
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.black45),
                                    hintText: "Enter Password",
                                    contentPadding: const EdgeInsets.all(15),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.black12),
                                        borderRadius: BorderRadius.circular(7)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.black38),
                                        borderRadius: BorderRadius.circular(7)),
                                  )),
                              const SizedBox(height: 20),
                              passwordTextField()
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 50),
                      SizedBox(
                          width: size.width * 0.8,
                          height: 55,
                          child: submitButton())
                    ],
                  ),
                ));
          }),
          listener: (context, state) {
            if (state is SubmissionFailed) {
              _showSnackBar(context, state.message);
            } else if (state is SubmissionSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UsernameScreen()));
            }
          },
        ));
  }

  Widget passwordTextField() {
    return BlocBuilder<NewPasswordBloc, NewPasswordState>(
        builder: ((context, state) {
      return TextFormField(
          controller: confirmPassword,
          onSaved: (newValue) {
            context
                .read<NewPasswordBloc>()
                .add(PasswordEnterd(password: confirmPassword.text));
          },
          validator: ((value) {
            if (value!.isEmpty) {
              return "* Required";
            }
            if (password.text != confirmPassword.text) {
              return "Password does not match";
            }
            return null;
          }),
          obscureText: true,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontSize: 16, fontFamily: "Roboto"),
            prefixIcon: const Icon(Icons.lock, color: Colors.black45),
            hintText: "Confirm Password",
            contentPadding: const EdgeInsets.all(15),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(7)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.black38),
                borderRadius: BorderRadius.circular(7)),
          ));
    }));
  }

  Widget submitButton() {
    return BlocBuilder<NewPasswordBloc, NewPasswordState>(
      builder: (context, state) {
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
              "Confirm",
              style: TextStyle(fontSize: 16, fontFamily: "Roboto"),
            ),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<NewPasswordBloc>().add(ButtonSubmitted(
                  password: confirmPassword.text,
                  OTP: widget.OTP,
                  username: widget.username));
            }
          },
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
