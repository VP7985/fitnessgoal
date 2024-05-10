import 'package:fitnessgoal/components/my_list.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onProfile;

  const DrawerPage({super.key,required this.onProfile, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Column(
              children: [
                          DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
          MyList(
            icon: Icons.home,
            text: 'HOME',
            onTap: () => Navigator.pop(context),
          ),
          MyList(
            icon: Icons.person,
            text: 'PROFILE',
            onTap: onProfile,
              ),
              ],
            ),
          Padding(padding: const EdgeInsets.only(bottom:25.0),
          child:  MyList(
            icon: Icons.logout,
            text: 'LOGOUT',
            onTap: onSignOut,
          ),
          ),
        ],
      ),
    );
  }
}
