import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:haloecg/models/jantung_model.dart';
import 'package:haloecg/service/ApiService.dart';

part 'jantung_state.dart';

class JantungCubit extends Cubit<JantungState> {
  JantungCubit() : super(JantungInitial());

  void getDataJantung(String idPasien, String jam) async {
    try {
      emit(JantungLoading());
      JantungModel data = await ApiService().ambilDataJantung(idPasien, jam);
      if (data.value == "1") {
        emit(JantungSuccess(data));
      } else {
        emit(JantungFailed(data.message.toString()));
      }
    } catch (e) {
      emit(JantungFailed(e.toString()));
    }
  }
}
