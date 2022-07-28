import 'package:STUVI_app/dto/LeaderboardDto.dart';

import 'package:flutter/material.dart';

class FriendTileLeaderBoardDisplay extends StatefulWidget {
  final int index;
  final LeaderboardDto leaderboardDto;

  FriendTileLeaderBoardDisplay({
    Key? key,
    required this.index,
    required this.leaderboardDto,
  }) : super(key: key);

  @override
  State<FriendTileLeaderBoardDisplay> createState() =>
      _FriendTileLeaderBoardDisplayState();
}

class _FriendTileLeaderBoardDisplayState
    extends State<FriendTileLeaderBoardDisplay> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    int rank = widget.index + 1;

    Widget renderRank() {
      String badge = '';
      if (rank == 1) {
        badge = "assets/leaderboard/first-medal.png";
      } else if (rank == 2) {
        badge = "assets/leaderboard/second-medal.png";
      } else if (rank == 3) {
        badge = "assets/leaderboard/third-medal.png";
      }
      if (badge.isNotEmpty) {
        return Image(
          image: AssetImage(badge),
        );
      }
      return Container(
        padding: EdgeInsets.only(left: 8, right: 10),
        child: Text(
          '${rank}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return isLoading
        ? Container(
            child: CircularProgressIndicator(),
          )
        : ListTile(
            leading: Container(
              width: 100.0,
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: renderRank(),
                ),
                CircleAvatar(
                  radius: 25.0,
                  child: Text(
                    '${widget.leaderboardDto.initials}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              ]),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.leaderboardDto.fullName}',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'OxygenBold',
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Level ${widget.leaderboardDto.level}',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Oxygen',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
  }
}
