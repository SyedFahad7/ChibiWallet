import 'package:ChibiWallet/pages/login_pages.dart';
import 'package:ChibiWallet/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the private key
  WalletProvider walletProvider = WalletProvider();
  await walletProvider.loadPrivateKey();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletProvider>.value(value: walletProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // Disables the DEBUG banner
          theme: themeProvider.themeData,
          initialRoute: MyRoutes.loginRoute,
          routes: {
            MyRoutes.loginRoute: (context) => const LoginPage(),
          },
        );
      },
    );
  }
}
