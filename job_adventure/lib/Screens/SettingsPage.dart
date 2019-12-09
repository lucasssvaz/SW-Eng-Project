import 'package:flutter/material.dart';
import 'package:job_adventure/Screens/NavigationMenu.dart';
import 'package:preferences/preferences.dart';
/*
void logout() {
  print('Logging Out...');
  Navigator.popUntil(context, ModalRoute.withName('/loginScreen'));
}
*/
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: PreferencePage([
        PreferenceTitle('Personalization (WIP)'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),
        PreferenceTitle('Account'),
        PreferenceText(
          'Log Out',
          onTap: (){
            Navigator.pop(context);
            Navigator.pop(context);

          }
        ),
        PreferenceTitle('About'),
        PreferenceText(
          'Help',
          onTap: (){
            print('');
          }
        ),
        PreferenceText(
          'Contact us',
          onTap: (){
            print('');
          }
        ),
      ]),
    );
  }
}