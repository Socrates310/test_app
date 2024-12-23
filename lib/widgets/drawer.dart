import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final VoidCallback onChangeUserName;

  const CustomDrawer({
    Key? key,
    required this.userName,
    required this.onChangeUserName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userName),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onChangeUserName,
                ),
              ],
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(userName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
