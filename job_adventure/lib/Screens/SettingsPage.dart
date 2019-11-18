import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

void LogOut(){

}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: PreferencePage([
        PreferenceTitle('Personalization'),
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
            print('Logging Out...');
          }
        ),
      ]),
    );
  }
}