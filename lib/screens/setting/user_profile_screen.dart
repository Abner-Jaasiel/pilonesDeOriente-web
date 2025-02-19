import 'package:cached_network_image/cached_network_image.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/models/user_model.dart';
import 'package:carkett/providers/appconfig_controller.dart';
import 'package:carkett/services/api_service.dart';
import 'package:carkett/services/auth_firebase_service.dart';
import 'package:carkett/services/file_service.dart';
import 'package:carkett/utils/utils.dart';
import 'package:carkett/widgets/alert_widget.dart';
import 'package:carkett/widgets/custom_appbar_widget.dart';
import 'package:carkett/widgets/custom_show_modal_bottom_sheet.dart';
import 'package:carkett/widgets/flutter_map_widget.dart';
import 'package:carkett/widgets/home_screen_widgets/product_carousels_zone_list_widget.dart';
import 'package:carkett/widgets/map_buttom_widget.dart';
import 'package:carkett/widgets/super_progressindicator_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

final bucketGlobal = PageStorageBucket();

class LoadUserProfileScreen extends StatefulWidget {
  const LoadUserProfileScreen({super.key, this.isMy = true, this.userExternal});

  final bool isMy;
  final String? userExternal;

  @override
  State<LoadUserProfileScreen> createState() => _LoadUserProfileScreenState();
}

class _LoadUserProfileScreenState extends State<LoadUserProfileScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshData(
    User user,
  ) async {
    try {
      await loadUserFromPreferences(user.uid, loadFromServer: true);
      setState(() {});
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMy = widget.isMy;
    User? user;
    user = FirebaseAuth.instance.currentUser;
    final String userExternal = widget.userExternal ?? "";
    final String usertemp = user?.uid ?? "";

    if (userExternal == usertemp) {
      isMy = true;
    } else if (userExternal.isNotEmpty) {
      isMy = false;
    }

    return user != null || widget.userExternal != null
        ? FutureBuilder(
            future: isMy == true && user != null
                ? loadUserFromPreferences(user.uid)
                : loadExternalUser(widget.userExternal!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == null) {
                return const Center(child: Text('No userdata available.'));
              }
              UserModel data = snapshot.data as UserModel;
              AppConfigController appConfigController =
                  Provider.of<AppConfigController>(context);

              appConfigController.isSeller = data.seller != null ? true : false;
              return true
                  ? UserProfileScreen(
                      data: data,
                      user: user,
                      onRefresh: () => refreshData(user!),
                      isMy: isMy)
                  : Container();
            })
        : const Center(child: CircularProgressIndicator());
  }
}

class UserProfileScreen extends StatelessWidget {
  final UserModel data;
  final User? user;
  final VoidCallback onRefresh;
  final bool isMy;

  const UserProfileScreen({
    super.key,
    required this.data,
    required this.user,
    required this.onRefresh,
    this.isMy = true,
  });

  @override
  Widget build(BuildContext context) {
    print("${data.seller}🤺🤺🤺🤺🤺🤺");
    return Scaffold(
      appBar: CustomAppbarWidget(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 1000,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return RefreshIndicator(
              onRefresh: () async => onRefresh(),
              child: PageStorage(
                bucket: bucketGlobal,
                child: ListView(
                  key: const PageStorageKey<String>('user_profile_list'),
                  children: [
                    IconButton(
                      onPressed: onRefresh,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh),
                          const SizedBox(width: 10),
                          Text(S.current.refresh)
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.grey[300],
                            child: ClipOval(
                              child: data.profileImageUrl != null &&
                                      data.profileImageUrl!.isNotEmpty
                                  ? CachedNetworkImage(
                                      key:
                                          const PageStorageKey('profile_image'),
                                      imageUrl: data.profileImageUrl!,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                      width: 180,
                                      height: 180,
                                    )
                                  : Image.asset(
                                      "assets/images/profileUser.jpg",
                                      fit: BoxFit.cover,
                                      width: 180,
                                      height: 180,
                                    ),
                            ),
                          ),
                        ),
                        if (isMy)
                          Positioned(
                            bottom: 0,
                            child: Container(
                              margin: const EdgeInsets.only(left: 130),
                              child: InkWell(
                                onTap: () async {
                                  superProgressIndicator(context);
                                  final ImagePicker picker = ImagePicker();
                                  final XFile? pickedFiles = await picker
                                      .pickImage(source: ImageSource.gallery);

                                  if (pickedFiles != null) {
                                    final String? urlImage =
                                        await uploadUserImageFirebase(
                                            pickedFiles, data.profileImageUrl);

                                    if (urlImage != null) {
                                      await updateUserInPreferences(data,
                                          update: "profile_image_url",
                                          valueUpdate: urlImage);

                                      await APIService().updateUserData(
                                          null,
                                          null,
                                          urlImage,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null,
                                          null);
                                      onRefresh();
                                    }
                                  }

                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (data.seller != null && !isMy)
                          Positioned(
                            bottom: 10,
                            child: Container(
                              margin: const EdgeInsets.only(left: 140),
                              child: const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    ListTile(
                      onTap: isMy
                          ? () {
                              TextEditingController textController =
                                  TextEditingController(text: data.name);
                              customShowModalBottomSheet(context, () async {
                                await updateUserInPreferences(data,
                                    update: "name",
                                    valueUpdate: textController.text);

                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Future.delayed(const Duration(seconds: 2));

                                await APIService().updateUserData(
                                    textController.text,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null);
                                onRefresh();
                              }, textController, S.current.save);
                            }
                          : null,
                      leading: const Icon(Icons.person),
                      title: Text(data.name),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      onTap: isMy
                          ? () {
                              TextEditingController textController =
                                  TextEditingController(text: data.description);
                              customShowModalBottomSheet(context, () async {
                                await updateUserInPreferences(data,
                                    update: "description",
                                    valueUpdate: textController.text);

                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Future.delayed(const Duration(seconds: 2));

                                await APIService().updateUserData(
                                    null,
                                    textController.text,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null,
                                    null);
                                onRefresh();
                              }, textController, S.current.save);
                            }
                          : null,
                      leading: const Icon(Icons.description),
                      title: Text(S.current.description),
                      subtitle: Text(data.description ?? S.current.description),
                    ),
                    if (isMy)
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push("/profile_list");
                        },
                        leading: const Icon(Icons.folder_shared_rounded),
                        title: Text(S.current.profiles),
                        subtitle: Text(S.current.profiles),
                      ),

                    if (isMy)
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push("/language");
                        },
                        leading: const Icon(Icons.language),
                        title: Text(S.current.language),
                        subtitle: Text(S.current.current_language),
                      ),
                    if (isMy)
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push("/setting");
                        },
                        leading: const Icon(Icons.settings),
                        title: Text(S.current.setting),
                        subtitle: Text(S.current.setting),
                      ),
                    const SizedBox(height: 20),
                    if (isMy && data.seller == null)
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push('/seller_selection');
                        },
                        leading: const Icon(Icons.upload_outlined),
                        title: Text(S.current.upgradeToSeller),
                        subtitle: const Text("Seleccion de tipo"),
                      ),
                    if (isMy && data.seller != null)
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push('/seller_selection');
                        },
                        leading: const Icon(Icons.admin_panel_settings_sharp),
                        title: Text(S.current.changeSellerPlan),
                        subtitle: Text(data.seller ?? ""),
                      ),
                    const SizedBox(height: 20),
                    //  const Divider(),
                    if (isMy &&
                        (data.seller == "premium" ||
                            data.seller == "enterprise"))
                      Center(
                        child: Text("${S.current.sellerManagement}:",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                    //  const Divider(),
                    const SizedBox(height: 10),
                    if (isMy &&
                        (data.seller == "premium" ||
                            data.seller == "enterprise"))
                      ListTile(
                        onTap: () {
                          GoRouter.of(context).push("/create_store");
                        },
                        leading: const Icon(Icons.store),
                        title: Text(S.current.createStore),
                        subtitle: Text(S.current.createStore),
                      ),
                    if (isMy &&
                        (data.seller == "premium" ||
                            data.seller == "enterprise"))
                      ListTile(
                        onTap: () async {
                          GoRouter.of(context).push("/provider_dashboard");
                          /* final Uri url = Uri.parse(
                              'https://gestionapp-zeta.vercel.app/#/');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }*/
                        },
                        leading: const Icon(Icons.settings_suggest_rounded),
                        title: Text(S.current.sellerManagement),
                        subtitle: Text(S.current.sellerManagement),
                      ),
                    if (data.seller != null)
                      MapButtomWidget(
                        lat: data.locationLatitude ?? 0,
                        long: data.locationLongitude ?? 0,
                        height: constraints.maxHeight / 2.5,
                      ),
                    const SizedBox(height: 10),
                    if (data.seller != null)
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: Text(S.current.aboutMe),
                        subtitle: const Text("Usuario Verificado"),
                      ),
                    if (isMy)
                      ListTile(
                        onTap: () async {
                          bool? confirmLogout =
                              await showLogoutConfirmationDialog(
                                  context,
                                  S.current.logout,
                                  S.current.areYouSureYouWantToLogOut);

                          if (confirmLogout == true) {
                            AuthFirebaseService().signOut();
                            GoRouter.of(context).go("/login");
                          }
                        },
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: Text(S.current.logout),
                        subtitle: Text(S.current.logout),
                      ),
                    const SizedBox(height: 10),
                    Text(isMy ? S.current.myProducts : S.current.userProducts,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 10),
                    PageStorage(
                      bucket: bucketGlobal,
                      child: ProductCarouselListWithSellerWidget(
                        seller: isMy ? user!.uid : data.firebaseUid,
                        withIntialSpace: false,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
