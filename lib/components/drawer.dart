import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnessgoal/components/my_list.dart';

class DrawerPage extends StatelessWidget {
  final void Function()? onSignOut;
  final void Function()? onProfile;

  const DrawerPage({Key? key, required this.onProfile, this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  user?.displayName ?? 'User', // Display name if available
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: Text(
                  user?.email ?? 'No Email', // Display email if available
                  style: TextStyle(color: Colors.white),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : AssetImage('assets/default_profile_image.png') as ImageProvider,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyList(
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
