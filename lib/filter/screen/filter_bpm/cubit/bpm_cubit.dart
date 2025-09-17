import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bpm_state.dart';

class BpmCubit extends Cubit<BpmState> {
  BpmCubit() : super(const BpmInitial());

  void changeTo(int value) {
    emit(BpmChanged(from: state.from, to: value));
  }

  void changeFrom(int value) {
    emit(BpmChanged(from: value, to: state.to));
  }

  void updateBpm(String from, String to) {
    final intFrom = int.parse(from != "" ? from : "0");
    final intTo = int.parse(to != "" ? to : "0");

    emit(BpmChanged(from: intFrom, to: intTo));
  }

  void clearSelection() {
    emit(const BpmInitial());
  }
}
