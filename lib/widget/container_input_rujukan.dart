import 'package:flutter/material.dart';

class ContainerInputRujukan extends StatefulWidget {
  const ContainerInputRujukan({Key key, @required this.controllerRujukan})
      : super(key: key);

  final TextEditingController controllerRujukan;

  @override
  State<ContainerInputRujukan> createState() => _ContainerInputRujukanState();
}

class _ContainerInputRujukanState extends State<ContainerInputRujukan> {
  bool visibility = false;
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
                "Surat Rujukan",
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
            child: TextFormField(
              controller: widget.controllerRujukan,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Masukkan Keterangan",
              ),
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }
}
