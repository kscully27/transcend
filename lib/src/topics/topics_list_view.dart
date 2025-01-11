import 'dart:ui';

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

Color baseColor = const Color(0xFFD59074);
Color baseColor2 = const Color(0xFFC67E60);
Color textColor = const Color(0xFF883912);
Color titleColor = const Color(0xFFFBF3D8);
double firstDepth = 15;
double secondDepth = 10;
double thirdDepth = 50;
double fourthDepth = 50;

class TopicItem extends StatefulWidget {
  const TopicItem({super.key, required this.topic});
  final Topic topic;

  @override
  State<TopicItem> createState() => _TopicItemState();
}

class _TopicItemState extends State<TopicItem> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _opacityController;
  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 0,
    )..addListener(() {
        setState(() {});
      });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 0,
    )..addListener(() {
        setState(() {});
        if (_animationController.value == 1) {
          _opacityController.forward();
        }
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _opacityController.dispose();
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

    // final calculatedSecondDepth =
    //     stagger(secondDepth, _animationController.value, 0.5)!;
    final calculatedThirdDepth = stagger(1, _opacityController.value, 0.75)!;
    final calculatedFourthDepth = stagger(1, _opacityController.value, 1)!;

    final topic = widget.topic;

    void _handleButtonPressed(topic) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.transparent,
        isDismissible: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              margin: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 20.0,
                    sigmaY: 20.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                  borderRadius: BorderRadius.circular(2),
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
                              Container(
                                margin: EdgeInsets.all(0),
                                padding: EdgeInsets.all(0),
                                height: 32,
                                width: double.infinity,
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.close, color: Colors.black),
                                  iconSize: 32,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 12,
                                        children: [
                                      Text(topic.title,
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black87)),
                                      Text(topic.description,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black)),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Center(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: .8,
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.black,
                                                  size: 40,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Start Trance",
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.w200,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
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
      );
    }

    return GestureDetector(
      onTap: () => _handleButtonPressed(topic),
      child: Container(
          // color: baseColor,
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
                  AnimatedOpacity(
                    opacity: calculatedThirdDepth,
                    duration: _opacityController.duration!,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 180,
                        child: ClayText(topic.title,
                            emboss: true,
                            size: 24,
                            parentColor: baseColor,
                            textColor: Colors.white,
                            // textColor: AppColors.shadow(topic.appColor),
                            color: baseColor,
                            spread: 2,
                            style: TextStyle(fontWeight: FontWeight.w200)),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: calculatedFourthDepth,
                    duration: _opacityController.duration!,
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(0),
                              child: ClayContainer(
                                  surfaceColor: AppColors.light(topic.appColor),
                                  parentColor: baseColor,
                                  emboss: false,
                                  spread: 8,
                                  depth: 8,
                                  curveType: CurveType.concave,
                                  // surfaceColor: baseColor,
                                  width: 100,
                                  height: double.infinity,
                                  customBorderRadius: BorderRadius.only(
                                    topLeft: Radius.elliptical(0, 0),
                                    bottomLeft: Radius.elliptical(0, 0),
                                    topRight: Radius.elliptical(16, 16),
                                    bottomRight: Radius.elliptical(16, 16),
                                  )),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 14),
                              child: Center(
                                child: SvgPicture.network(
                                  topic.svg,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.bottomCenter,
                                  color: AppColors.flat(topic.appColor),
                                  width: _fullWidth,
                                ),
                              ),
                            ),
                          ])),
                    ),
                  ),
                ]),
          )),
    );
  }
}

class TopicsListView extends StatefulWidget {
  const TopicsListView({super.key});

  static const routeName = '/';

  @override
  State<TopicsListView> createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView>
    with TickerProviderStateMixin {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  late Query collection;

  @override
  Widget build(BuildContext context) {
    collection = _firestoreService.getTopicQuery();
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
          scrolledUnderElevation: 1,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
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
            final topic = snapshot.data() as Topic;
            return TopicItem(topic: topic);
          },
        ));
  }
}
