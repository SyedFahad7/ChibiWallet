import 'package:ChibiWallet/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_fonts.dart';

class SelectAvatarPage extends StatefulWidget {
  const SelectAvatarPage({super.key});

  @override
  State<SelectAvatarPage> createState() => _SelectAvatarPageState();
}

class _SelectAvatarPageState extends State<SelectAvatarPage> {
  String? selectedAvatar;
  ThemeProvider? themeProvider;

  @override
  void initState() {
    super.initState();
    loadSelectedAvatar();
  }

  Future<void> loadSelectedAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAvatar = prefs.getString('selectedAvatar');
    });
  }

  Future<void> saveSelectedAvatar(String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAvatar', avatar);
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);

    final List<Map<String, String>> hoomans = List.generate(
      12,
      (index) => {
        'name': 'Avatar ${index + 1}',
        'image': 'assets/images/avatar${index + 1}.png',
      },
    );

    final List<Map<String, String>> animals = List.generate(
      12,
      (index) => {
        'name': 'Animal ${index + 1}',
        'image': 'assets/images/animal${index + 1}.png',
      },
    );

    final List<Map<String, String>> fruitsAndVeggies = List.generate(
      14,
      (index) => {
        'name': 'Fruit/Vegetable ${index + 1}',
        'image':
            'assets/images/${index + 1 < 10 ? '00${index + 1}' : '0${index + 1}'}-fruit-${index + 1}.png',
      },
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 16.0, right: 16.0, bottom: 1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: themeProvider!.isDarkMode
                          ? [Colors.black45, Colors.white.withOpacity(0.99)]
                          : [
                              Colors.blue.shade800,
                              Colors.white.withOpacity(0.7)
                            ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Choose an ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              ),
                            ),
                            TextSpan(
                              text: ' Avatar',
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: themeProvider!.isDarkMode
                                    ? Colors.black
                                    : Colors.yellow.shade200,
                                fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16.0), // Add spacing here
                  Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: themeProvider!.isDarkMode
                          ? Colors.grey.shade800
                          : Colors.green.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: themeProvider!.isDarkMode
                            ? Colors.grey.shade600
                            : Colors.green.shade400,
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(
                        vertical: BorderSide.strokeAlignCenter,
                        horizontal: BorderSide.strokeAlignCenter,
                      ),
                      tabs: [
                        Tab(
                          child: Text(
                            'Hoomans',
                            style: TextStyle(
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider!.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Furriends',
                            style: TextStyle(
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider!.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Bloomies',
                            style: TextStyle(
                              fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider!.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18.0), // Add spacing here
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      children: [
                        buildAvatarGrid(hoomans),
                        buildAvatarGrid(animals),
                        buildAvatarGrid(fruitsAndVeggies),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeProvider!.isDarkMode
                              ? Colors.orange
                              : Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider!.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: selectedAvatar != null
                            ? () {
                                saveSelectedAvatar(selectedAvatar!);
                                Navigator.pop(context, selectedAvatar);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAvatar != null
                              ? (themeProvider!.isDarkMode
                                  ? Colors.redAccent
                                  : Colors.blue.shade800)
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(
                            fontFamily: AppFonts.fontFamilyPlusJakartaSans,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider!.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatarGrid(List<Map<String, String>> avatars) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isSelected = selectedAvatar == avatar['image'];
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedAvatar = avatar['image'];
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage(avatar['image']!),
                backgroundColor: isSelected ? Colors.green : null,
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24.0,
                ),
            ],
          ),
        );
      },
    );
  }
}
