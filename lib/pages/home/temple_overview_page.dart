// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pooja_pass/components/my_icon_btn.dart';
import 'package:pooja_pass/components/temple_image_container.dart';
import 'package:pooja_pass/models/date_crowd_info.dart';
import 'package:pooja_pass/models/user.dart';
import 'package:pooja_pass/pages/about_temple_page.dart';
import 'package:pooja_pass/pages/ticket/book_now_page.dart';
import 'package:pooja_pass/pages/location_page.dart';
import 'package:pooja_pass/pages/ticket/my_tickets_page.dart';
import 'package:pooja_pass/provider/user_provider.dart';
import 'package:pooja_pass/services/date_crowd_info_services.dart';
import 'package:pooja_pass/utils/utils.dart';
import 'package:provider/provider.dart';

class TempleOverviewPage extends StatefulWidget {
  const TempleOverviewPage({super.key});

  @override
  State<TempleOverviewPage> createState() => _TempleOverviewPageState();
}

class _TempleOverviewPageState extends State<TempleOverviewPage> {
  //user detail
  User? user;
  //screen width

  //temple images string
  List<String> templeImagesList = [
    'assets/images/temple-img-1.jpeg',
    'assets/images/temple-img-1.webp',
    'assets/images/temple-img-2.jpeg',
    'assets/images/temple-img-3.jpeg'
  ];

  //max cap and active crowd count
  //todo:to be fetched using api
  int maxCap = 10000;
  int activeCrowd = 4000;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  //book now btn press
  void bookNow(BuildContext context) {
    if (activeCrowd < maxCap) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const BookNowPage()));
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("No available ticket, try later!"),
              ));
    }
  }

  //crowd status
  void showCrowdStatus(BuildContext context) async {
    try {
      int maxCap;
      int activeCrowd;

      //fetch current date crowd status
      DateTime now = DateTime.now();

      DateCrowdInfo? dateCrowdInfo =
          await DateCrowdInfoServices.fetchDateCrowdInfo(context, now);

      if (dateCrowdInfo != null) {
        activeCrowd = dateCrowdInfo.bookedTickets;
        maxCap = dateCrowdInfo.maxCap;
        double percent = (activeCrowd / maxCap);
        Color color;
        String text;
        if (percent < 0.4) {
          color = Colors.green;
          text = "Low";
        } else if (percent > 0.75) {
          color = Colors.red;
          text = "High";
        } else {
          color = Colors.yellow.shade700;
          text = "Medium";
        }
        percent = percent > 1 ? 1 : percent;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Crowd Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
            contentPadding: const EdgeInsets.all(30),
            content: CircularPercentIndicator(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              percent: percent,
              center: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              radius: 100,
              progressColor: color,
              lineWidth: 20,
              circularStrokeCap: CircularStrokeCap.round,
            ),
          ),
        );
      }
    } catch (e) {
      // TODO
      showSnackbar(context, "Failed to load crowd data\n${e.toString()}");
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).user;

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height * 0.4,
            width: size.width,
            // color: Colors.red,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30)),
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.blue.shade300,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    "Welcome,\n${user!.name}",
                    style: const TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        height: 1.2),
                  ),
                ),
                const SizedBox(height: 25),
                _buildImageCarousel(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyIconButton(
                            text: 'Location',
                            icon: const Icon(
                              Icons.map,
                              size: 35,
                              color: Colors.white,
                            ),
                            onTap: () {
                              //
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationPage()));
                            },
                          ),
                          MyIconButton(
                            text: "Crowd",
                            icon: const Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 35,
                            ),
                            onTap: () => showCrowdStatus(context),
                          ),
                          MyIconButton(
                            text: "About temple",
                            icon: const Icon(
                              Icons.description_outlined,
                              color: Colors.white,
                              size: 35,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AboutTemplePage()));
                            },
                          ),
                          MyIconButton(
                            text: "My Tickets",
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 35,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyTicketPage()));
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            bookNow(context);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white),
                          child: const Text(
                            "Book now!",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }

  CarouselSlider _buildImageCarousel() {
    return CarouselSlider.builder(
      itemCount: templeImagesList.length,
      itemBuilder: (context, index, h) =>
          TempleImageContainer(image: templeImagesList[index]),
      options: CarouselOptions(
        height: 350,
        // autoPlay: true,
        enableInfiniteScroll: true,
        enlargeCenterPage: true,
        autoPlayAnimationDuration: const Duration(seconds: 2),
      ),
    );
  }
}
