import 'package:carkett/models/perfile_model.dart';
import 'package:carkett/screens/auth/login_screen.dart';
import 'package:carkett/screens/auth/login_seller_screen.dart';
import 'package:carkett/screens/auth/register_screen.dart';
import 'package:carkett/screens/paid_carousel/payment_information_screen.dart';
import 'package:carkett/screens/paid_carousel/checkout_screen.dart';
import 'package:carkett/screens/home_screen.dart';
import 'package:carkett/screens/map_screen.dart';
import 'package:carkett/screens/paid_carousel/orders_screen.dart';
import 'package:carkett/screens/paid_carousel/card_details_screen.dart';
import 'package:carkett/screens/paid_carousel/profile_selection_screen.dart';
import 'package:carkett/screens/search_zone_screen.dart';
import 'package:carkett/screens/product_zone/image_viewer_screen.dart';
import 'package:carkett/screens/product_zone/object_3d_screen.dart';
import 'package:carkett/screens/product_zone/product_screen.dart';
import 'package:carkett/screens/seller/create_store_screen.dart';
import 'package:carkett/screens/seller/html_page_screen.dart';
import 'package:carkett/screens/seller/product_aggregator_screen.dart';
import 'package:carkett/screens/seller/seller_selection_screen.dart';
import 'package:carkett/screens/setting/edit_profile_screen.dart';
import 'package:carkett/screens/setting/language_screen.dart';
import 'package:carkett/screens/setting/profile_list_screen.dart';
import 'package:carkett/screens/setting/setting_screen.dart';
import 'package:carkett/screens/setting/user_profile_screen.dart';
import 'package:carkett/screens/paid_carousel/shopping_cart_screen.dart';
import 'package:carkett/screens/start_screen.dart';
import 'package:carkett/widgets/seller/seller_management_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/seller_selection',
      builder: (context, state) => const SellerSelectionScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final String params = state.pathParameters['id']!;

        return ProductScreen(productId: params);
      },
    ),
    /* GoRoute(
      path:
          '/explorer/:searchText', // Definimos la ruta con el parámetro 'searchText'
      builder: (context, state) {
        final String searchText = state.pathParameters['searchText'] ??
            ''; // Usamos 'pathParameters' para acceder a 'searchText'
        return SearchZoneScreen(
            searchText: searchText); // Pasamos el parámetro al widget
      },
    ),*/
    /* GoRoute(
      path: '/product_explorer',
      builder: (context, state) => const ProductExplorerScreen(),
    ),*/
    /* GoRoute(
      path: '/user_perfile',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final isMy = extra?['isMy'] as bool;
        final userExternal = extra?['userExternal'] as String?;

        return LoadUserProfileScreen(
          isMy: isMy,
          userExternal: userExternal,
        );
      },
    ),*/
    GoRoute(
      path: '/user_perfile/:isMy/:userExternal',
      builder: (context, state) {
        final isMy = state.pathParameters['isMy'] == 'true'; // Parseamos a bool
        final userExternal = state.pathParameters['userExternal'];

        return LoadUserProfileScreen(
          isMy: isMy,
          userExternal: userExternal,
        );
      },
    ),
    GoRoute(
      path: '/shopping_cart',
      builder: (context, state) => const ShoppingCartScreen(),
    ),
    GoRoute(
      path: '/product_aggregator',
      builder: (context, state) => const ProductAggregatorScreen(),
    ),
    GoRoute(
      path: '/seller_management',
      builder: (context, state) => const SellerManagementScreen(),
    ),
    GoRoute(
      path: '/object_3d',
      builder: (context, state) {
        final modelUrl = state.extra as String;
        return Object3dScreen(modelUrl: modelUrl);
      },
    ),
    GoRoute(
      path: '/object_3d_with_camera',
      builder: (context, state) {
        final modelUrl = state.extra as String;
        return Object3dWithCameraScreen(modelUrl: modelUrl);
      },
    ),
    GoRoute(
      path: '/image_viewer',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final List<String> imageUrls = data['imageUrls'] as List<String>;
        final int initialIndex = data['initialIndex'] as int;

        return ImageViewerScreen(
            imageUrls: imageUrls, initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/searchzone',
      builder: (context, state) => const SearchZoneScreen(),
    ),
    GoRoute(
      path: '/html_page',
      builder: (context, state) => const HtmlPageScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const MapScreen(),
    ),
    GoRoute(
      path: '/buyer_info',
      builder: (context, state) {
        final result = state.extra as bool? ?? false;
        return PaymentInformationScreen(result: result);
      },
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/create_store',
      builder: (context, state) => const CreateStoreScreen(),
    ),
    GoRoute(
      path: '/setting',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/card_details',
      builder: (context, state) => const CardDetailsScreen(),
    ),
    GoRoute(
      path: '/profile_list',
      builder: (context, state) => const ProfileListScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) {
        final profileData = state.extra as Map<String, dynamic>?;

        final profileIndex =
            profileData != null ? profileData['profileIndex'] : -1;
        final profiles = profileData != null && profileData['profiles'] != null
            ? List<ProfileModel>.from(profileData['profiles'])
            : <ProfileModel>[];

        return EditProfileScreen(
          profileIndex: profileIndex ?? -1,
          profiles: profiles,
        );
      },
    ),
    GoRoute(
      path: '/profile_selection',
      builder: (context, state) => const ProfileSelectionScreen(),
    ),
    GoRoute(
      path: '/login_seller',
      builder: (context, state) {
        final accountType = state.extra as String? ?? 'general';
        return LoginSellerScreen(accountType: accountType);
      },
    ),
  ],
);
