import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/register_data_controller.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RegisterDataController delAccount =
        Provider.of<RegisterDataController>(context);

    final mediaQuerySizeX = MediaQuery.of(context).size.width;
    final Widget ySizeB = SizedBox(height: mediaQuerySizeX > 600 ? 30 : 8);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        delAccount.delAccount = false;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Center(
                    child: Text(
                      S.current.doYouWanttoDeleteYourNotesSmartAccount,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                Center(
                  child: DropdownButton<bool>(
                    hint: Text(
                        delAccount.delAccount ? S.current.yes : S.current.no),
                    items: [
                      DropdownMenuItem(
                        value: true,
                        child: Text(S.current.yes),
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: Text(S.current.no),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == true) {
                        delAccount.delAccount = true;
                      } else {
                        delAccount.delAccount = false;
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Center(
                  child: SizedBox(
                    width: 250,
                    child: Text(
                        "Please note that all your data will be deleted forever, including your notes."),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Color.fromARGB(108, 48, 78, 117),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Color.fromARGB(134, 255, 0, 0))),
              onPressed: delAccount.delAccount
                  ? () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(S.current.confirm),
                            content:
                                Text(S.current.doYouWantToDeleteTheAccount),
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

                                  authFirebaseService.deleteAccount();
                                  GoRouter.of(context).replace('/login');

                                  delAccount.delAccount = false;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(S.current.deleteAccount),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.delete)
                ],
              ),
            ),
          ),
          ySizeB
        ]),
      ),
    );
  }
}
