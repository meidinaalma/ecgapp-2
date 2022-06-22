import 'package:flutter/material.dart';

class ContainerRujukan extends StatefulWidget {
  final String rujukan;
  const ContainerRujukan({Key key, this.rujukan}) : super(key: key);

  @override
  State<ContainerRujukan> createState() => _ContainerRujukanState();
}

class _ContainerRujukanState extends State<ContainerRujukan> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child: visibility
                    ? Icon(Icons.arrow_drop_up_sharp)
                    : Icon(Icons.arrow_drop_down_sharp),
              ),
            ],
          ),
          SizedBox(height: 13),
          Visibility(
            visible: visibility,
            child: Text(
              widget.rujukan,
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }
}
