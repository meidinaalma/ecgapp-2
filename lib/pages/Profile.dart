import 'package:flutter/material.dart';
import 'package:haloecg/models/user_model.dart';
// import 'package:haloecg/ChartECG.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/utils/text_style.dart';
import 'package:haloecg/widget/Profil_Card.dart';
import 'package:haloecg/widget/opaque_image.dart';
import 'package:haloecg/widget/my_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key, this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    String link = "http://haloecg.site/haloecgk/";
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Stack(
                  children: <Widget>[
                    OpaqueImage(
                      imageUrl: "$link${user.fotoProfil}",
                      role: user.role,
                      //"assets/images/robby.jpg",
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Colors.white,
                                  iconSize: 30,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Profil",
                                    textAlign: TextAlign.left,
                                    style: headingTextStyle,
                                  ),
                                ),
                              ],
                            ),
                            MyInfo(
                              imgUrl: '$link${user.fotoProfil}',
                              name: user.name,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: user.role == "0"
                      ? Constants.lightYellow
                      : Constants.lightGreen,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.all(8),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ProfilCard(
                            firstText: "Tanggal \n lahir",
                            secondText: user.tanggalLahir,
                            icon: Icon(
                              Icons.calendar_today,
                              size: 30,
                            ),
                            widhh: 0.4,
                          ),
                          ProfilCard(
                            firstText: "Email",
                            secondText: user.email,
                            icon: Icon(
                              Icons.email,
                              size: 30,
                            ),
                            widhh: 0.4,
                          ),
                          ProfilCard(
                            firstText: "HP.",
                            secondText: user.phone,
                            icon: Icon(
                              Icons.phone,
                              size: 30,
                            ),
                            widhh: 0.4,
                          ),
                          ProfilCard(
                            firstText: "Alamat",
                            secondText: user.alamat,
                            icon: Icon(
                              Icons.home_outlined,
                              size: 30,
                            ),
                            widhh: 0.4,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
