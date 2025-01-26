import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/theme_controller.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:carkett/widgets/custom_show_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final getTextTheme = Provider.of<ThemeController>(context).getTextTheme();

    final setTheme = context.watch<ThemeController>();
    return Scaffold(
      appBar: AppBar(title: Text(S.current.setting), actions: [
        IconButton(
          icon: const Icon(
            Icons.exit_to_app_rounded,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.current.confirm),
                  content: Text(S.current.areYouSureYouWantToLogOut),
                  actions: [
                    TextButton(
                      child: Text(S.current.no),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(S.current.yes),
                      onPressed: () {
                        AuthFirebaseService authFirebaseService =
                            AuthFirebaseService();
                        authFirebaseService.signOut();
                        GoRouter.of(context).replace('/home');
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ]),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                onTap: () {
                  GoRouter.of(context).push("/language");
                },
                title: Text(S.current.language),
              ),
              ListTile(
                title: Text(S.current.theme),
                onTap: () {
                  TextEditingController textController =
                      TextEditingController();
                  customShowModalBottomSheetDropdown(
                      context: context,
                      metho: (value) {
                        if (value == "dark") {
                          setTheme.setTheme(ThemeMode.dark);
                        } else {
                          setTheme.setTheme(ThemeMode.light);
                        }

                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      textController: textController,
                      textInput: getTextTheme,
                      itemsDropdown: [
                        const DropdownMenuItem(
                            value: 'dark', child: Text("Dark")),
                        const DropdownMenuItem(
                            value: 'light', child: Text("Light"))
                      ],
                      items: [
                        Text(
                          '${S.current.theme}:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 30),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 244, 248, 251),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 30,
                              width: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 20, 24, 25),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 30,
                              width: 30,
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: 30),
                      ]);
                },
              ),
              const Divider(),
              ListTile(
                title: Text(S.current.share),
                onTap: () {
                  Share.share(
                      '${S.current.downloadtheNotesSmartApp} https://ancikle.com/apps');
                },
              ),
              ListTile(
                title: Text(S.current.termsAndConditions),
                onTap: () {
                  Uri uri = Uri.parse(S.current.privacyPolicyURL);

                  void launchURL_files() async => await canLaunchUrl(uri)
                      ? await launchUrl(uri)
                      : throw 'Could not launch $uri';
                  launchURL_files();
                },
              ),
              ListTile(
                title: Text(
                  S.current.deleteAccount,
                  style:
                      const TextStyle(color: Color.fromARGB(255, 133, 50, 44)),
                ),
                onTap: () {
                  GoRouter.of(context).push("/delete_account_screen");
                },
              ),
            ],
          ).animate().scaleY(
              begin: 1.15,
              end: 1,
              duration: const Duration(milliseconds: 700),
              curve: Curves.ease),
        ),
      ),
    );
  }
}
