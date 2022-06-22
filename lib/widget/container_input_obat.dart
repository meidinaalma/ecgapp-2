import 'package:flutter/material.dart';

class ContainerInputObat extends StatefulWidget {
  const ContainerInputObat({
    Key key,
    @required this.controllerNama,
    @required this.controllerDosis,
    @required this.controllerKeterangan,
    @required this.controllerJumlah,
  }) : super(key: key);
  final TextEditingController controllerNama;
  final TextEditingController controllerDosis;
  final TextEditingController controllerKeterangan;
  final TextEditingController controllerJumlah;

  @override
  State<ContainerInputObat> createState() => _ContainerInputObatState();
}

class _ContainerInputObatState extends State<ContainerInputObat> {
  bool visibility = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
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
                child: visibility ? Icon(Icons.remove) : Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 13),
          Visibility(
            visible: visibility,
            child: Column(
              children: [
                TextFormField(
                  controller: widget.controllerNama,
                  validator: (confirmController) {
                    if (confirmController.isEmpty) {
                      return "masukkan nama obat";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Nama Obat",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (confirmController) {
                    if (confirmController.isEmpty) {
                      return "masukkan dosis obat";
                    } else {
                      return null;
                    }
                  },
                  controller: widget.controllerDosis,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Dosis",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (confirmController) {
                    if (confirmController.isEmpty) {
                      return "masukkan jumlah obat";
                    } else {
                      return null;
                    }
                  },
                  controller: widget.controllerJumlah,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Jumlah",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (confirmController) {
                    if (confirmController.isEmpty) {
                      return "masukkan keterangan obat";
                    } else {
                      return null;
                    }
                  },
                  controller: widget.controllerKeterangan,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Keterangan",
                  ),
                ),
                SizedBox(height: 10),

                // Icon(Icons.add_circle_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
