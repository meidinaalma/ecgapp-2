import 'package:flutter/material.dart';
import 'package:haloecg/models/user_model.dart';
import 'package:haloecg/pages/Profile.dart';
import 'package:haloecg/pages/Settings.dart';
import 'package:haloecg/pages/daftar_chat.dart';
import 'package:haloecg/pages/dashboardkeRiwayat.dart';
import 'package:haloecg/pages/page_resep_dokter.dart';
import 'package:haloecg/widget/Menu_Card.dart';

class MenuHomeDokter extends StatelessWidget {
  const MenuHomeDokter({Key key, @required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        user: user,
                      ),
                    ),
                  );
                },
                child: MenuCard(
                  firstText: "",
                  secondText: "Profile",
                  icon: Image.asset(
                    "assets/icon/user.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DaftarChat(
                        user: user,
                      ),
                    ),
                  );
                },
                child: MenuCard(
                  firstText: "",
                  secondText: "Riwayat Chat",
                  icon: Image.asset(
                    "assets/icon/chat.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => dashRiwayatECG(user: user),
                    ),
                  );
                },
                child: MenuCard(
                  firstText: "",
                  secondText: "Riwayat ECG pasien & beri diagnosa",
                  icon: Image.asset(
                    "assets/icon/List.png",
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: MenuCard(
                  firstText: "",
                  secondText: "Resep Obat dan Surat Rujukan",
                  icon: Image.asset(
                    "assets/icon/icon_resep.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DaftarChat(
                        title: "Pilih Pasien",
                        isResep: true,
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 170,
              child: GestureDetector(
                child: MenuCard(
                  firstText: "",
                  secondText: "Settings",
                  icon: Image.asset(
                    "assets/icon/settings.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
