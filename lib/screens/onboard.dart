import 'package:flutter/material.dart';
import 'package:momoproxy/constant.dart';
import 'package:momoproxy/model/onboardmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardScreen extends StatefulWidget {
  OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

void seen() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("seenOnboarding", "true");
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;

  List<AllinOnboardModel> allinonboardlist = [
    AllinOnboardModel(
        "assets/images/exchange.png",
        "Exchange e-cash for physical cash and visa vera with people around you",
        "Momoproxy, the uber for mobile money ?"),
    AllinOnboardModel(
        "assets/images/locate.png",
        "Find nearby e-vendors and tranditional mobile money agents with GPS locations",
        "Find vendors nearby"),
    AllinOnboardModel(
        "assets/images/connect.png",
        "Momoproxy's e-vendors allow you to withdraw at any time, yes even on holidays and sundays.",
        "Sunday ? Holiday ? you can still withdraw"),
  ];

  @override
  Widget build(BuildContext context) {
    seen();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
          child: Stack(
            children: [
              PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentIndex = value;
                    });
                  },
                  itemCount: allinonboardlist.length,
                  itemBuilder: (context, index) {
                    //setState(() {});
                    return PageBuilderWidget(
                        title: allinonboardlist[index].titlestr,
                        description: allinonboardlist[index].description,
                        imgurl: allinonboardlist[index].imgStr);
                  }),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.3,
                left: MediaQuery.of(context).size.width * 0.44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    allinonboardlist.length,
                    (index) => buildDot(index: index),
                  ),
                ),
              ),
              currentIndex < allinonboardlist.length - 1
                  ? Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "",
                              style:
                                  TextStyle(fontSize: 18, color: primarygreen),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: lightgreenshede1,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0))),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Swipe",
                              style:
                                  TextStyle(fontSize: 18, color: primarygreen),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: lightgreenshede1,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0))),
                            ),
                          )
                        ],
                      ),
                    )
                  : Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.2,
                      left: MediaQuery.of(context).size.width * 0.33,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/intro');
                        },
                        child: Text(
                          "Get Started",
                          style: TextStyle(fontSize: 18, color: primarygreen),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: lightgreenshede1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentIndex == index ? primarygreen : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class PageBuilderWidget extends StatelessWidget {
  String title;
  String description;
  String imgurl;
  PageBuilderWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.imgurl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // margin: const EdgeInsets.only(top: 20),
            child: Image.asset(imgurl),
          ),
          const SizedBox(
            height: 20,
          ),
          //Tite Text
          Text(title,
              style: TextStyle(
                  color: primarygreen,
                  fontSize: 24,
                  fontWeight: FontWeight.w700)),
          const SizedBox(
            height: 20,
          ),
          //discription
          Text(description,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: primarygreen,
                fontSize: 14,
              ))
        ],
      ),
    );
  }
}
