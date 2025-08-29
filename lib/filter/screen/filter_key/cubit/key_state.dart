part of 'key_cubit.dart';

abstract class KeyState extends Equatable {
  final List<KeyModel> keys;
  final List<KeyModel> selectedKeys;
  final String searchQuery;

  const KeyState({
    required this.keys,
    required this.selectedKeys,
    this.searchQuery = '',
  });

  @override
  List<Object> get props => [keys, selectedKeys, searchQuery];
}

class KeyInitial extends KeyState {
  KeyInitial() : super(keys: [], selectedKeys: []);
}

class KeyLoading extends KeyState {
  KeyLoading() : super(keys: [], selectedKeys: []);
}

class KeyError extends KeyState {
  KeyError() : super(keys: [], selectedKeys: []);
}

class KeyLoaded extends KeyState {
  const KeyLoaded({
    required super.keys,
    required super.selectedKeys,
    super.searchQuery,
  });
}
