import 'package:ChibiWallet/pages/wallet.dart';
import 'package:ChibiWallet/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import '../constants/app_fonts.dart';
import 'package:provider/provider.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  _ImportWalletState createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  bool isVerified = false;
  String verificationText = '';

  void navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    void verifyMnemonic() async {
      final walletProvider =
          Provider.of<WalletProvider>(context, listen: false);

      // Call the getPrivateKey function from the WalletProvider
      final privateKey = await walletProvider.getPrivateKey(verificationText);

      // Navigate to the WalletPage
      navigateToWalletPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Import from Seed',
          style: TextStyle(fontFamily: AppFonts.fontFamilyPlusJakartaSans),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please Enter your mnemonic phrase:',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: AppFonts.fontFamilyPlusJakartaSans,
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Enter mnemonic phrase',
                labelStyle: TextStyle(
                  fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: verifyMnemonic,
              child: const Text(
                'Import',
                style:
                    TextStyle(fontFamily: AppFonts.fontFamilyPlusJakartaSans),
              ),
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
