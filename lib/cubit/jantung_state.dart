part of 'jantung_cubit.dart';

abstract class JantungState extends Equatable {
  const JantungState();

  @override
  List<Object> get props => [];
}

class JantungInitial extends JantungState {}

class JantungLoading extends JantungState {}

class JantungSuccess extends JantungState {
  final JantungModel dataJantung;

  JantungSuccess(this.dataJantung);

  List<Object> get props => [dataJantung];
}

class JantungFailed extends JantungState {
  final String error;

  JantungFailed(this.error);

  List<Object> get props => [error];
}
