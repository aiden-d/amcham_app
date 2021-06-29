import 'package:flutter/material.dart';
import 'package:amcham_app_v2/screens/single_event_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:amcham_app_v2/constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'get_firebase_image.dart';
import 'package:amcham_app_v2/scripts/member_checker.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';

class EventItem extends StatefulWidget {
  final int? price;
  //date must be formated as year/month/day
  final int? date;
  //time formatted as hhmm or hour hour minute minute
  final int? startTime;
  final int? endTime;
  final String? title;
  final String? type;
  final String? category;
  final bool? isMembersOnly;
  final String? summary;
  final String? imageRef;
  final String? info;
  final String id;
  final String? link;
  final String? youtube_link;
  final Iterable<dynamic>? registeredUsers;
  final List? tier1hashes;
  final List? tier2hashes;
  final List? tier3hashes;
  final List? tier4hashes;
  final List? speakers;
  final String? archetype;

  EventItem({
    required this.price,
    required this.date,
    required this.title,
    required this.type,
    required this.category,
    required this.isMembersOnly,
    required this.summary,
    required this.imageRef,
    required this.info,
    required this.id,
    required this.link,
    required this.registeredUsers,
    required this.startTime,
    required this.endTime,
    required this.tier1hashes,
    required this.tier2hashes,
    required this.tier3hashes,
    required this.tier4hashes,
    required this.speakers,
    required this.youtube_link,
    required this.archetype,
  });
  int? rankedPoints;
  bool showVid = false;
  bool? isButton;

  bool? showInfo;

  bool? hideSummary;

  bool isInfoSelected = true;

  Function? infoButtonFunction;

  Function? speakersButtonFunction;
  int getPointsFromHashes(List<int> searchHashes) {
    int points = 0;
    for (int searchHash in searchHashes) {
      for (var hash in tier1hashes!) {
        if (hash == searchHash) {
          points += 100;
        }
      }
      for (var hash in tier2hashes!) {
        if (hash == searchHash) {
          points += 75;
        }
      }
      for (var hash in tier3hashes!) {
        if (hash == searchHash) {
          points += 30;
        }
      }
      // for (int hash in tier4hashes) {
      //   if (hash == searchHash) {
      //     points += 15;
      //   }
      // }
      //Commented out to increase performance and battery

    }
    print('points = $points');
    rankedPoints = points;
    return points;
  }

  String DateToString(int? numberDate) {
    String strNumberDate = numberDate.toString();
    String year = strNumberDate.substring(0, 4);
    String month = strNumberDate.substring(4, 6);
    int monthInt = int.parse(month);
    List<String> dates = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    month = dates[monthInt - 1];

    String day = strNumberDate.substring(6, 8);
    return '$day $month $year';
  }

  String TimeToString(int? numberTime) {
    String numberStr = numberTime.toString();
    if (numberStr.length < 4) {
      numberStr = '0' + numberStr;
    }
    String hour = numberStr.substring(0, 2);
    String minute = numberStr.substring(2, 4);
    return '$hour:$minute';
  }

  @override
  _EventItemState createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  MemberChecker memberChecker = new MemberChecker();
  String yID = "QRWijH8KNFU";

  @override
  void initState() {
    if (widget.archetype == "Youtube" && widget.showVid == true) {
      yID = YoutubePlayer.convertUrlToId(widget.youtube_link!)!;
    } else
      print("no vid");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.isButton == false
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleEventScreen(
                            item: widget,
                          )));
            },
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.calendar),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      '${widget.DateToString(this.widget.date)} ${widget.TimeToString(this.widget.startTime)}',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                Text(
                  MemberChecker.isMember == true
                      ? 'FREE ACCESS'
                      : (widget.price == 0 || widget.price == null
                          ? 'FREE'
                          : 'R${widget.price}'),
                  style: TextStyle(color: Colors.red[900], fontSize: 12),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.title!,
                      style: Constants.regularHeading.copyWith(
                          fontSize: widget.title!.length > 25 ? 16 : 19),
                    ),
                  ),
                  Text(
                    widget.type!,
                    style: TextStyle(
                        color: Constants.blueThemeColor, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.category!,
                    style: TextStyle(
                        color: Constants.blueThemeColor, fontSize: 16),
                  ),
                  Text(
                    widget.isMembersOnly == true ? 'Members Only' : 'Public',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            //TODO put container here
            widget.archetype == "Youtube" && widget.showVid == true
                ? Container(
                    //color: Colors.black,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * (9 / 16),
                    child: InAppWebView(
                        initialUrlRequest: URLRequest(
                      url: Uri.parse("https://www.youtube.com/embed/" + yID),
                    )))

                // onWebViewCreated: (controller) {
                //   webViewController = controller;
                // },
                // YoutubePlayerBuilder(
                //     player: YoutubePlayer(
                //       controller: widget._controller,
                //       showVideoProgressIndicator: true,
                //     ),
                //     builder: (context, player) {
                //       return Column(
                //         children: [
                //           // some widgets
                //           player,
                //           //some other widgets
                //         ],
                //       );
                //     })
                :
                //     :

                //     ? YoutubePlayerIFrame(
                //         controller: _controller,
                //         // YoutubePlayerController(
                //         //   initialVideoId:
                //         //       youtube_link.substring(32, youtube_link.length),
                //         //   params: YoutubePlayerParams(
                //         //     autoPlay: false,
                //         //     showControls: true,
                //         //     showFullscreenButton: true,
                //         //   ),
                //         // ),
                //         aspectRatio: 16 / 9,
                //       )
                //     :
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: LoadFirebaseStorageImage(imageRef: widget.imageRef)),
            widget.hideSummary == true ? SizedBox() : Text(widget.summary!),

            //showInfo == true ? Text(info) : SizedBox(),
          ],
        ),
      ),
    );
  }
}
