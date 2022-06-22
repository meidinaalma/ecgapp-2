import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haloecg/cubit/jantung_cubit.dart';
import 'package:haloecg/utils/const.dart';
import 'package:haloecg/widget/column_builder.dart';

class JantungPage extends StatelessWidget {
  const JantungPage({Key key, this.idPasien}) : super(key: key);

  final String idPasien;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.lightGreen,
      appBar: AppBar(
        backgroundColor: Constants.darkGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: const Text('Hasil Nilai R Peak'),
      ),
      body: BlocBuilder<JantungCubit, JantungState>(
        builder: (context, state) {
          if (state is JantungLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is JantungFailed) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is JantungSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: ColumnBuilder(
                itemCount: state.dataJantung.content.length,
                itemBuilder: ((context, index) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Text(
                      "${state.dataJantung.content[index].totalR} Bpm",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
