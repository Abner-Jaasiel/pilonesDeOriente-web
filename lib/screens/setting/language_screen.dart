import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.language),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/flags.png",
                      fit: BoxFit.cover,
                      height: 280,
                      opacity: const AlwaysStoppedAnimation(.5),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(S.current.selectALanguage),
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(17, 255, 255, 255),
                        borderRadius: BorderRadius.circular(35.0),
                        //border: Border.all(),
                      ),
                      child: DropdownButton<String>(
                        underline: Container(),
                        items: const [
                          DropdownMenuItem(value: 'en', child: Text("English")),
                          DropdownMenuItem(value: 'es', child: Text("Español")),
                          DropdownMenuItem(value: 'zh', child: Text("中文")),
                          DropdownMenuItem(
                              value: 'fr', child: Text("Français")),
                          DropdownMenuItem(value: 'de', child: Text("Deutsch")),
                          DropdownMenuItem(
                              value: 'it', child: Text("Italiano")),
                          DropdownMenuItem(value: 'ru', child: Text("Русский")),
                        ],
                        hint: Text(
                          S.current.current_language,
                        ),
                        onChanged: (String? selectedValue) {
                          final LanguageController languageController =
                              Provider.of<LanguageController>(context,
                                  listen: false);
                          if (selectedValue == 'en') {
                            languageController.updateLocale(const Locale('en'));
                          } else if (selectedValue == 'es') {
                            languageController.updateLocale(const Locale('es'));
                          } else if (selectedValue == 'fr') {
                            languageController.updateLocale(const Locale('fr'));
                          } else if (selectedValue == 'de') {
                            languageController.updateLocale(const Locale('de'));
                          } else if (selectedValue == 'it') {
                            languageController.updateLocale(const Locale('it'));
                          } else if (selectedValue == 'ru') {
                            languageController.updateLocale(const Locale('ru'));
                          } else if (selectedValue == 'zh') {
                            languageController.updateLocale(const Locale('zh'));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "   ${S.current.hello}  ${S.current.language}  ${S.current.edit}  ${S.current.next}  ${S.current.alert}  ${S.current.save}  ",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
        ],
      ),
    );
  }
}
