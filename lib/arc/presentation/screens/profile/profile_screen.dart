import 'package:flutter/material.dart';
import 'package:hii_xuu_social/src/config/config.dart';
import 'package:hii_xuu_social/src/preferences/app_preference.dart';
import 'package:hii_xuu_social/src/utilities/navigation_service.dart';
import 'package:hii_xuu_social/src/validators/static_variable.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
            onTap: () {
              StaticVariable.listPost = null;
              StaticVariable.myData = null;
              AppPreference().setVerificationID(null);
              navService.pushNamed(RouteKey.login);
            },
            child: Text(
              'logout',
              style: Theme.of(context).primaryTextTheme.button,
            )),
      ),
    );
  }
}
