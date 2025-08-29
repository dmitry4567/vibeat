part of 'bpm_cubit.dart';

abstract class BpmState extends Equatable {
  final int from;
  final int to;

  const BpmState({
    required this.from,
    required this.to,
  });

  @override
  List<Object> get props => [from, to];
}

class BpmInitial extends BpmState {
  const BpmInitial() : super(from: 0, to: 0);
}

class BpmChanged extends BpmState {
  const BpmChanged({
    required super.from,
    required super.to,
  });
}
