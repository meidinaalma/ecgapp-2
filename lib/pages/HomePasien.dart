import 'package:haloecg/pages/Profile.dart';
import 'package:haloecg/pages/dashboardkeAddECG.dart';
import 'package:haloecg/pages/dashboardkeRiwayat.dart';
import 'package:haloecg/pages/daftar_dokter.dart';
import 'package:haloecg/pages/daftar_chat.dart';
import 'package:haloecg/pages/Settings.dart';
import 'package:flutter/material.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/menu_home_dokter.dart';
import 'package:haloecg/pages/menu_home_pasien.dart';
import 'package:haloecg/pages/page_rujukan.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Menu_Card.dart';
import 'package:haloecg/widget/opaque_imageHome.dart';

class HomePasien extends StatelessWidget {
  const HomePasien({Key key, this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          user.role == "0" ? Constants.darkOrange : Constants.darkGreen,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    OpaqueImageHome(
                      imageUrl: "assets/images/kardiologi.jpg",
                      role: user.role,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Homepage" + " " + user.name.toString(),
                                textAlign: TextAlign.left,
                                style: headingTextStyle,
                              ),
                            ),
                            //MyInfo(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 50),
                    color: user.role == "0"
                        ? Constants.lightYellow
                        : Constants.lightGreen,
                    child: user.role == "0"
                        ? MenuHomePasien(user: user)
                        : MenuHomeDokter(user: user),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
