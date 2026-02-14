import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'LanguageProvider.dart';
import 'OverlayProvider.dart';
import 'RoleProvider.dart';
import 'bloc/item_bloc/item_bloc.dart';
import 'data/repositories/item_repository.dart';
import 'Pages/HomePage.dart';
import 'Pages/market.dart';
import 'Pages/fav.dart';
import 'Pages/settings.dart';
import 'Pages/SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  FirebaseAppCheck.instance.onTokenChange.listen((token) {
    print('App Check debug token: $token');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => OverlayProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        BlocProvider(
          create: (context) => ItemBloc(itemRepository: ItemRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Provider.of<LanguageProvider>(context).getText('app_title'),
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00B054),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: const Color(0xFF00B054),
          secondary: const Color(0xFF00B054),
        ),
      ),
      home: const SplashScreenWidget(), // Assuming SplashScreen handles navigation
      routes: {
        '/homePage': (context) => const HomePageWidget(),
        '/market': (context) => const MarketWidget(),
        '/fav': (context) => const FavWidget(),
        '/settings': (context) => const SettingsWidget(),
      },
    );
  }
}