import 'package:carkett/firebase_options.dart';
import 'package:carkett/generated/l10n.dart';
import 'package:carkett/providers/appbar_controller.dart';
import 'package:carkett/providers/chat_model_ai_controller.dart';
import 'package:carkett/providers/home_controller.dart';
import 'package:carkett/providers/language_controller.dart';
import 'package:carkett/providers/location_controller.dart';
import 'package:carkett/providers/navigator_controller.dart';
import 'package:carkett/providers/payment_controller.dart';
import 'package:carkett/providers/product_aggregator_controller.dart';
import 'package:carkett/providers/register_data_controller.dart';
import 'package:carkett/providers/search_filter_controller.dart';
import 'package:carkett/providers/theme_controller.dart';
import 'package:carkett/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences language = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  runApp(MyApp(language));
}

class MyApp extends StatelessWidget {
  const MyApp(this.language, {super.key});
  final SharedPreferences language;

  @override
  Widget build(BuildContext context) {
    String? languageCode = language.getString('language');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => LanguageController(languageCode)),
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => AppbarController()),
        ChangeNotifierProvider(create: (context) => NavigatorController()),
        ChangeNotifierProvider(
            create: (context) => ProductAggregatorController()),
        ChangeNotifierProvider(create: (context) => RegisterDataController()),
        ChangeNotifierProvider(create: (context) => SearchFilterController()),
        ChangeNotifierProvider(create: (context) => ChatModelAiController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => PaymentController()),
        ChangeNotifierProvider(create: (context) => LocationController()),
        // ChangeNotifierProvider(create: (context) => RouteManagerController())
      ],
      child: Builder(builder: (context) {
        Locale currentLocale = Provider.of<LanguageController>(context).locale;
        final getTheme = context.watch<ThemeController>().getTheme();
        return MaterialApp.router(
          locale: currentLocale,
          debugShowCheckedModeBanner: false,
          title: 'Carkett',
          routerConfig: router,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          themeMode: getTheme,
          darkTheme: ThemeData(
            useMaterial3: true,
            dividerTheme:
                const DividerThemeData(color: Color.fromARGB(38, 50, 128, 173)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(52, 94, 207, 245),
                ),
                textStyle:
                    WidgetStateProperty.all(const TextStyle(fontSize: 17)),
                foregroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 187, 218, 243),
            ),
            textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.white),
                titleMedium: TextStyle(color: Colors.white),
                displayLarge:
                    TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color.fromARGB(255, 15, 15, 19),
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 67, 147, 158),
              secondary: Color.fromARGB(13, 0, 0, 0),
              shadow: Color.fromARGB(66, 27, 58, 68),
            ),
          ),
          theme: ThemeData(
            useMaterial3: true,
            dividerTheme:
                const DividerThemeData(color: Color.fromARGB(38, 50, 128, 173)),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  const Color.fromARGB(52, 94, 207, 245),
                ),
                textStyle:
                    WidgetStateProperty.all(const TextStyle(fontSize: 17)),
                foregroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(234, 44, 44, 44)),
              ),
            ),
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 135, 155, 170),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.black),
              displayLarge:
                  TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 67, 147, 158),
              secondary: Color.fromARGB(13, 255, 255, 255),
              shadow: Color.fromARGB(49, 101, 204, 238),
            ),
          ),
        );
      }),
    );
  }
}
