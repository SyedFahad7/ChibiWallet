import 'package:ChibiWallet/components/nft_balances.dart';
import 'package:ChibiWallet/components/send_tokens.dart';
import 'package:ChibiWallet/pages/create_or_import.dart';
import 'package:ChibiWallet/pages/select_avatar_page.dart';
import 'package:ChibiWallet/providers/wallet_provider.dart';
import 'package:ChibiWallet/utils/get_balances.dart';
import 'package:ChibiWallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:convert';
import '../constants/app_fonts.dart';
import 'package:flutter/services.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String walletAddress = '';
  String balance = '';
  String pvKey = '';
  String? selectedAvatar;
  bool showWalletAddress = false;

  @override
  void initState() {
    super.initState();
    loadWalletData();
    loadSelectedAvatar();
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      final walletProvider = WalletProvider();
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);
      print(address.hex);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print(pvKey);
      String response = await getBalances(address.hex, 'sepolia');
      dynamic data = json.decode(response);
      String newBalance = data['balance'] ?? '0';

      // Transform balance from wei to ether
      EtherAmount latestBalance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  Future<void> loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar =
          prefs.getString('selectedAvatar') ?? 'assets/images/dummy.png';
    });
  }

  void showWalletAddressDialog(
      BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Address',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                walletAddress,
                style: TextStyle(
                  fontSize: 14.0,
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: walletAddress));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Wallet address copied to clipboard!'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.black
                    : Colors.blue.shade800,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectAvatarPage(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            selectedAvatar = result;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 23.0,
                        backgroundImage: AssetImage(
                            selectedAvatar ?? 'assets/images/dummy.png'),
                      ),
                    ),
                    const Spacer(),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                        child: Text(
                          'Chibi Wallet',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                      child: IconButton(
                        icon: Icon(themeProvider.isDarkMode
                            ? Icons.wb_sunny
                            : Icons.nights_stay),
                        onPressed: () {
                          themeProvider.toggleTheme();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final backgroundColor = themeProvider.isDarkMode
                                  ? Colors.black
                                  : Colors.white;
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Navigator.of(context).pop(true);
                              });
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  child: AlertDialog(
                                    title: Text(
                                      themeProvider.isDarkMode
                                          ? 'Dark Mode'
                                          : 'Light Mode',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily:
                                            AppFonts.fontFamilyPlusJakartaSans,
                                      ),
                                    ),
                                    content: Text(
                                      'You have switched to ${themeProvider.isDarkMode ? 'Dark' : 'Light'} Mode.',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily:
                                            AppFonts.fontFamilyPlusJakartaSans,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    height: MediaQuery.of(context).size.height * 0.4,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: themeProvider.isDarkMode
                            ? [Colors.grey.shade800, Colors.black]
                            : [Colors.blue.shade200, Colors.blue.shade800],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Wallet Address',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            showWalletAddressDialog(context, themeProvider);
                          },
                          icon: Icon(
                            showWalletAddress
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          label: Text(
                            showWalletAddress
                                ? 'Hide Wallet Address'
                                : 'Show Wallet Address',
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32.0),
                        const Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        AnimatedOpacity(
                          opacity: balance.isNotEmpty ? 1.0 : 0.0,
                          duration: const Duration(seconds: 1),
                          child: Text(
                            balance,
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.white70,
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'sendButton', // Unique tag for send button
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SendTokensPage(privateKey: pvKey)),
                            );
                          },
                          backgroundColor: themeProvider.isDarkMode
                              ? Colors.black
                              : Colors.blue.shade800,
                          child: const Icon(Icons.send),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Send',
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FloatingActionButton(
                          heroTag: 'refreshButton',
                          onPressed: () {
                            setState(() {});
                          },
                          backgroundColor: themeProvider.isDarkMode
                              ? Colors.black
                              : Colors.blue.shade800,
                          child: const Icon(Icons.replay_outlined),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Refresh',
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Colors.blue,
                        indicatorColor: Colors.blue,
                        labelStyle: TextStyle(
                          fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                        ),
                        tabs: [
                          Tab(
                            text: 'Assets',
                          ),
                          Tab(
                            text: 'NFTs',
                          ),
                          Tab(
                            text: 'Options',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: TabBarView(
                          children: [
                            // Assets Tab
                            Column(
                              children: [
                                Card(
                                  margin: const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Sepolia ETH',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontFamily: AppFonts
                                                .fontFamilyPlusJakartaSans,
                                          ),
                                        ),
                                        Text(
                                          balance,
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontFamily: AppFonts
                                                .fontFamilyPlusJakartaSans,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // NFTs Tab
                            SingleChildScrollView(
                                child: NFTListPage(
                                    address: walletAddress, chain: 'sepolia')),
                            // Activities Tab
                            Center(
                              child: ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontFamily:
                                        AppFonts.fontFamilyPlusJakartaSans,
                                  ),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('privateKey');
                                  // ignore: use_build_context_synchronously
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CreateOrImportPage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
