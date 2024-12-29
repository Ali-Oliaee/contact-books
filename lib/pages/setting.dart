import 'package:contactsproject/provider/font_provider.dart';
import 'package:contactsproject/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:contactsproject/Widgets/appBar.dart';
import 'package:provider/provider.dart';

class setting extends StatefulWidget {
  @override
  State<setting> createState() => _setting();
}

class _setting extends State<setting> {
  Map<String, String> fonts = {
    'Ubuntu': 'Ubuntu',
    'Bangers': 'Bangers',
    'Bebas': 'Bebas ',
  };

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final fontProvider = Provider.of<FontProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: InnerAppbar('Settings', context),
        body: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Theme',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.light_mode,
                  color: themeProvider.isDarkMode ? Colors.grey : Colors.yellow,
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Colors.teal,
                ),
                Icon(
                  Icons.dark_mode,
                  color: themeProvider.isDarkMode
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              ],
            )),
            const SizedBox(
              height: 40,
            ),
            Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Font',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: fontProvider.currentFont),
                ),
              ),
            ),
            DropdownButton<String>(
              value: fontProvider.currentFont,
              onChanged: (font) {
                if (font != null) fontProvider.toggleFont(font);
              },
              items: fonts.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
