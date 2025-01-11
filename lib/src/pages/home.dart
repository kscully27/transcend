import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:trancend/src/topics/topics_list_view.dart';
import 'package:trancend/src/ui/neo_bottom_nav/neo_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Color baseColor = const Color(0xFFD59074);
    Color baseColor2 = const Color(0xFFC67E60);
    Color navColor = const Color(0xFFC6846A);
    Color textColor = const Color(0xFF883912);
    Color titleColor = const Color(0xFFFBF3D8);
    Color iconColor = const Color(0xFFE2BFAF);
    return Scaffold(
            // appBar: AppBar(
            //   title: const Text("NeoBottomNavNSheet"),
            //   automaticallyImplyLeading: false,
            //   actions: [
            //     IconButton(
            //       icon: const Icon(Remix.notification_2_fill),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            extendBody: true,
            backgroundColor: baseColor,
            body: _index == 0
        ? TopicsListView() : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    [
                      Remix.home_6_fill,
                      // Remix.search_2_fill,
                      // Remix.file_list_2_fill,
                      Remix.user_3_fill
                    ][_index],
                    color: theme.colorScheme.secondary,
                    size: 48,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ["Home", "Search", "Topics", "Account"][_index],
                    textScaleFactor: 2.0,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: NeoBottomNavNSheet(
              backgroundColor: navColor,
              parentColor: baseColor,
              borderColors: [baseColor2, baseColor2, baseColor2, baseColor2],
              selectedItemColor: iconColor,
              unselectedItemColor: titleColor,
              sheetOpenIconBoxColor: iconColor,
              sheetOpenIconColor: textColor,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
                Future.delayed(const Duration(seconds: 1), () {
                  setState(() {
                    _index = index;
                  });
                });
              },
              initialSelectedIndex: _index,
              sheet: Sheet(),
              sheetOpenIcon: Remix.menu_4_line,
              sheetCloseIcon: Remix.add_line,
              // sheetCloseIconBoxColor: Colors.white,
              sheetCloseIconColor: theme.scaffoldBackgroundColor,
              // sheetOpenIconColor: Colors.white,
              onSheetToggle: (v) {
                setState(() {});
              },
              items: const [
                NeoBottomNavItem(
                  activeIcon: Remix.home_6_fill,
                  icon: Remix.home_6_line,
                  // label: "Home",
                ),
                // NeoBottomNavItem(
                //   icon: Remix.search_2_line,
                //   activeIcon: Remix.search_2_fill,
                //   // label: "Search",
                // ),
                // NeoBottomNavItem(
                //   icon: Remix.file_list_2_line,
                //   activeIcon: Remix.file_list_2_fill,
                //   // label: "Topics",
                // ),
                NeoBottomNavItem(
                  icon: Remix.user_3_line,
                  activeIcon: Remix.user_3_fill,
                  // label: "Account",
                ),
              ],
            ),
          );
  }
}

class Sheet extends StatelessWidget {
  Sheet({super.key});

  @override
  Widget build(BuildContext context) {
    // var theme = Theme.of(context);

    return DraggableScrollableSheet(
      builder: (context, controller) {
        return Padding(
          padding: EdgeInsets.zero,
          // padding: EdgeInsets.only(
          //   bottom: MediaQuery.of(context).viewInsets.bottom,
          // ),
          child: Container(
            // margin: EdgeInsets.all(8),
            child: ClipRRect(
              // borderRadius: BorderRadius.all(Radius.circular(20)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    // borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.black26,
                      width: 0.5,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.25,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                  color: Colors.black12,
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            // Container(
                            //   margin: EdgeInsets.all(0),
                            //   padding: EdgeInsets.all(0),
                            //   height: 32,
                            //   width: double.infinity,
                            //   alignment: Alignment.topRight,
                            //   child: IconButton(
                            //     icon: Icon(Icons.close, color: Colors.black),
                            //     iconSize: 32,
                            //     padding: EdgeInsets.all(0),
                            //     onPressed: () {
                            //       Navigator.pop(context);
                            //     },
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      spacing: 12,
                                      children: [])),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      minChildSize: 0.5,
      initialChildSize: 0.75,
    );
  }
}
