import 'package:flutter/material.dart';

class ContainerObat extends StatefulWidget {
  final String namaObat, jumlahObat, dosisObat, keterangan;

  const ContainerObat(
      {Key key,
      this.namaObat,
      this.jumlahObat,
      this.dosisObat,
      this.keterangan})
      : super(key: key);

  @override
  State<ContainerObat> createState() => _ContainerObatState();
}

class _ContainerObatState extends State<ContainerObat> {
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: ,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Resep Obat",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (visibility == true) {
                      visibility = false;
                    } else {
                      visibility = true;
                    }
                  });
                },
                child: visibility
                    ? Icon(Icons.arrow_drop_up_sharp)
                    : Icon(Icons.arrow_drop_down_sharp),
              ),
            ],
          ),
          SizedBox(height: 15),
          Visibility(
            visible: visibility,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama Obat: ${widget.namaObat}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                Text(
                  "Dosis Obat: ${widget.dosisObat}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                Text(
                  "Jumlah Obat: ${widget.jumlahObat}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
                Text(
                  "Keterangan: ${widget.keterangan}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
