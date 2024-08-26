import 'dart:async';

import 'package:digital_signage/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';
import 'package:video_player/video_player.dart';

class Play extends StatefulWidget {
  const Play({super.key});

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> with SingleTickerProviderStateMixin {
  String runningText = 'Digital Signage by Bejabat Code || CP: 085376777244';
  late VideoPlayerController controller;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    load();
    initControllers();
    checkLists();
     animationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    animation = Tween<double>(
      begin: 1,
      end: -1,
    ).animate(animationController);
  }

  String current = '';

  void load() async {
    final res = await Server().getBanners();
    current = res.toString();
    for (var data in res) {
      switch (data['type']) {
        case 'text':
          {
            setState(() {
              runningText = data['url'];
            });
          }
        case 'banner1':
          {
            setState(() {
              banner1 = data['url'];
            });
          }
        case 'banner2':
          {
            setState(() {
              banner2 = data['url'];
            });
            break;
          }
        case 'banner3':
          {
            setState(() {
              banner3 = data['url'];
            });
            break;
          }
        case 'banner4':
          {
            setState(() {
              banner4 = data['url'];
            });
            break;
          }
        case 'video':
          {
            setState(() {
              video = data['url'];
            });
            initControllers();
            break;
          }
      }
    }
  }

  void checkLists() {
    Timer.periodic(const Duration(seconds: 3), (Timer t) async {
      final res = await Server().getBanners();
      String temp = res.toString();
      if (temp != current) {
        load();
      }
    });
  }

  void initControllers() {
    controller = VideoPlayerController.networkUrl(Uri.parse(video));
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((_) {
      setState(() {});
    });

    controller.setLooping(true);
    controller.play();

   
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('EEEE, d MMMM yyyy').format(dateTime);
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  /* List<dynamic> banners = [];
  List<dynamic> banner1 = [];
  List<dynamic> banner2 = [];
  List<dynamic> banner3 = [];
  List<dynamic> banner4 = [];
  List<dynamic> videos = [];*/

  String banner1 = '';
  String banner2 = '';
  String banner3 = '';
  String banner4 = '';
  String video = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                  flex: 25,
                  child: Column(
                    children: [
                      Expanded(
                          child: banner1.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey,
                                )
                              : Image.network(
                                  banner1,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )),
                      Expanded(
                          child: banner2.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey,
                                )
                              : Image.network(banner2,
                                  width: double.infinity, fit: BoxFit.cover)),
                      Expanded(
                          child: banner3.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey,
                                )
                              : Image.network(banner3,
                                  width: double.infinity, fit: BoxFit.cover))
                    ],
                  )),
              Expanded(
                  flex: 75,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 33,
                          child: banner4.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey,
                                )
                              : Image.network(
                                  banner4,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )),
                      Expanded(
                          flex: 66,
                          child: SizedBox.expand(
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                      width: controller.value.size.width,
                                      height: controller.value.size.height,
                                      child: Stack(children: [
                                        video.isEmpty
                                            ? Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                color: Colors.grey,
                                              )
                                            : VideoPlayer(controller),
                                        Positioned(
                                          top: 16,
                                          right: 16,
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                188, 73, 73, 73),
                                            child: Column(
                                              children: [
                                                Text(
                                                  formatDate(DateTime.now()),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                ),
                                                DigitalClock(
                                                    format: 'HH:mm:ss',
                                                    textScaleFactor: 4,
                                                    showSeconds: true,
                                                    isLive: false,
                                                    digitalClockTextColor:
                                                        Colors.white,
                                                    decoration: const BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15))),
                                                    datetime: DateTime.now()),
                                              ],
                                            ),
                                          ),
                                        )
                                      ])))))
                    ],
                  ))
            ],
          )),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            color: const Color.fromARGB(255, 73, 73, 73),
            child: ClipRect(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      animation.value * MediaQuery.of(context).size.width - 50,
                      0,
                    ),
                    child: child,
                  );
                },
                child: Text(
                  runningText,
                  style: const TextStyle(fontSize: 26, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
