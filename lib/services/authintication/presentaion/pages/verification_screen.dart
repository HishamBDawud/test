import 'package:cleanapp/core/ui_constants/fonts.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/timer/timer_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/verification/verify_state.dart';
import 'package:cleanapp/services/authintication/presentaion/pages/home/main_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../bloc/timer/timer_event.dart';
import '../bloc/timer/timer_state.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String myOtp = "";
  @override
  void initState() {
    context.read<TimerBloc>().add(const TimerStarted(60));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
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
            "Verify Account",
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontFamily: "Roboto"),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop(context);
            },
          ),
        ),
        body: BlocConsumer<VerifyBloc, VerifyState>(
          builder: (context, state) {
            return SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Code Is Sent Please Check Your E-mail",
                          style: TextStyle(fontFamily: "Roboto"),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: size.width * 0.9,
                          child: Form(
                            key: formKey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                verificationTextField(first: true, last: false),
                                verificationTextField(
                                    first: false, last: false),
                                verificationTextField(
                                    first: false, last: false),
                                verificationTextField(first: false, last: true)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Timer(),
                              Visibility(
                                  visible: false,
                                  maintainAnimation: true,
                                  maintainSize: true,
                                  maintainState: true,
                                  child: TextButton(
                                    child: const Text(
                                      'Resend Code',
                                      style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromARGB(255, 145, 36, 36)),
                                    ),
                                    onPressed: () {},
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't Recieve Code ? ",
                              style: TextStyle(
                                  color: Colors.black54, fontFamily: "Roboto"),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Request Again",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Roboto"),
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            width: size.width * 0.8,
                            height: 55,
                            child: verifyButton())
                      ],
                    )
                  ]),
            );
          },
          listener: (context, state) {
            if (state is OtpSubmissionFailed) {
              _showSnackBar(context, state.message);
            } else if (state is OtpSubmissionSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainHomePage()),
              );
            }
          },
        ),
      ),
    );
  }

  Widget verifyButton() {
    return BlocBuilder<VerifyBloc, VerifyState>(builder: (context, state) {
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
            "Verify",
            style: TextStyle(fontSize: 15, fontFamily: "Roboto"),
          ),
        ),
        onPressed: () {
          context.read<VerifyBloc>().add(OtpSubmitted(otp: myOtp));
        },
      );
    });
  }

  Widget verificationTextField({required bool first, last}) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 60,
      width: 60,
      child: TextFormField(
          onChanged: (value) => {
                if (value.length == 1 && last == false)
                  {myOtp += value, FocusScope.of(context).nextFocus()},
                if (value.isEmpty && first == false)
                  {FocusScope.of(context).previousFocus()},
                if (value.length == 1 && last == true) {myOtp += value}
              },
          validator: MultiValidator([
            RequiredValidator(errorText: "* Required"),
          ]),
          autofocus: true,
          showCursor: true,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: body_font_size, fontWeight: FontWeight.w400),
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.circular(8)),
          )),
    );
  }

  Widget Timer() {
    return BlocConsumer<TimerBloc, TimerState>(builder: (context, state) {
      if (state is TimerInitial) {
        context.read<TimerBloc>().add(const TimerStarted(60));
      } else if (state is ResendCodeFaild) {
        _showSnackBar(context, state.message);
      }
      if (state.duration > 0) {
        return Text(
          '${context.select((TimerBloc bloc) => bloc.state.duration)}',
          style: const TextStyle(fontSize: 20),
        );
      } else {
        context.read<TimerBloc>().add(CodeEnded());
        return TextButton(
          child: const Text(
            'Resend Code',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          onPressed: () {
            context.read<TimerBloc>().add(TimerReset());
          },
        );
      }
    }, listener: (context, state) {
      if (state is ResendCodeSuccess) {
        context.read<TimerBloc>().add(TimerStarted(state.duration));
      }
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
