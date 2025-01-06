import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trancend/src/constants/app_colors.dart';
import 'package:trancend/src/locator.dart';
import 'package:trancend/src/models/topic.model.dart';
import 'package:trancend/src/services/firestore.service.dart';

import '../settings/settings_view.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({super.key});

  static const routeName = '/';

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

/// Displays a list of SampleItems.
class _SampleItemListViewState extends State<SampleItemListView>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  Color baseColor = const Color(0xFFD59074);
  Color textColor = const Color(0xFF883912);
  Color titleColor = const Color(0xFFFBF3D8);
  double firstDepth = 15;
  double secondDepth = 50;
  double thirdDepth = 50;
  double fourthDepth = 50;
  late AnimationController _animationController;
  late final CollectionReference<Topic> collection;

  @override
  void initState() {
    super.initState();

    // Initialize collection here instead of in build
    collection = _firestoreService.getTopicQuery();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _fullWidth = _width > 70 ? 70 : _width;

    double? stagger(double value, double progress, double delay) {
      var newProgress = progress - (1 - delay);
      if (newProgress < 0) newProgress = 0;
      return value * (newProgress / delay);
    }

    final calculatedFirstDepth =
        stagger(firstDepth, _animationController.value, 0.25)!;

    return Scaffold(
        backgroundColor: baseColor,
        appBar: AppBar(
          title: ClayText("Topics",
              emboss: false,
              size: 36,
              parentColor: baseColor,
              textColor: titleColor,
              color: baseColor,
              depth: 9,
              spread: 3,
              style: TextStyle(fontWeight: FontWeight.w300)),
          backgroundColor: baseColor,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: textColor, size: 36),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: FirestoreListView(
          query: collection,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context, snapshot) {
            final topic = snapshot.data();
            return Column(
              children: [
                Container(
                    color: baseColor,
                    padding: const EdgeInsets.all(12),
                    child: ClayContainer(
                      color: baseColor,
                      borderRadius: 20,
                      height: 120,
                      width: 400,
                      curveType: CurveType.concave,
                      spread: 5,
                      depth: calculatedFirstDepth.toInt(),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ClayContainer(
                                  surfaceColor: AppColors.dark(topic.appColor),
                                  parentColor: baseColor,
                                  emboss: false,
                                  spread: 2,
                                  depth: 12,
                                  curveType: CurveType.concave,
                                  // surfaceColor: baseColor,
                                  width: 36,
                                  height: double.infinity,
                                  customBorderRadius: BorderRadius.only(
                                    topRight: Radius.elliptical(0, 0),
                                    bottomRight: Radius.elliptical(0, 0),
                                    topLeft: Radius.elliptical(16, 16),
                                    bottomLeft: Radius.elliptical(16, 16),
                                  )),
                            ),
                            SizedBox(
                              width: 180,
                              child: ClayText(topic.title,
                                  emboss: true,
                                  size: 18,
                                  parentColor: baseColor,
                                  textColor: textColor,
                                  color: baseColor,
                                  spread: 2,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w900)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: SvgPicture.network(
                                  topic.svg,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                  color: textColor,
                                  width: _fullWidth,
                                ),
                              ),
                            ),
                          ]),
                    ))
              ],
            );
          },
        ));
  }
}
