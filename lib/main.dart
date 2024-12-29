import 'package:contactsproject/pages/allcontacts.dart';
import 'package:contactsproject/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:contactsproject/provider/font_provider.dart';
import 'package:provider/provider.dart';
import 'store/contacts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeContacts();

  runApp(ContactsProject());
}

class ContactsProject extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => FontProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: Provider.of<FontProvider>(context).currentFont,
            ),
            darkTheme: ThemeData(
              fontFamily: Provider.of<FontProvider>(context).currentFont,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            home: allcontacts(),
          );
        },
      ),
    );
  }
}
