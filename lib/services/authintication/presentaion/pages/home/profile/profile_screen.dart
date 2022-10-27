import 'package:cleanapp/core/ui_constants/border_radius.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_bloc.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_event.dart';
import 'package:cleanapp/services/authintication/presentaion/bloc/profile/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/ui_constants/colors.dart';
import '../../../../domain/entities/user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primary_color,
                      secondary_color,
                      third_color,
                      Colors.transparent
                    ]),
              ),
            ),
            SizedBox(
              width: size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/img1.png'),
                            fit: BoxFit.cover),
                        color: secondary_color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                        width: size.width * 0.9,
                        height: 240,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: primary_color,
                                offset: Offset(
                                  5.0,
                                  5.0,
                                ),
                                blurRadius: 10.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 0.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(SECOND_BORDER_RADIUS)),
                        child: UserInformation())
                  ]),
            )
          ],
        ),
      ),
    );
  }
}

Widget UserInformation() {
  return BlocBuilder<ProfileBLoc, ProfileState>(builder: (context, state) {
    context.read<ProfileBLoc>().add(LoadProfileInfo());
    if (state is Loaded) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.idNo),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.firstName),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.midName),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.thirdName),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.lastName),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.nationality),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.address),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.comment),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.profileImage),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.status),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.email),
            ],
          ),
          Row(
            children: [
              const Text("ID Number"),
              Text(state.user.phoneNumber),
            ],
          ),
        ],
      );
    } else if (state is LoadingFaild) {
      _showSnackBar(context, state.message);
      return const Center(
        child: Text("Fail"),
      );
    } else {
      return const Center(
        child: Text("Faild to load Data"),
      );
    }
  });
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
