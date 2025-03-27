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

  void updateBpm(int from, int to) {
    emit(BpmChanged(from: from, to: to));
  }
}
