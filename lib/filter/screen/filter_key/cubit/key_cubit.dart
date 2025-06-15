import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:vibeat/filter/screen/filter_key/model/key_model.dart';

part 'key_state.dart';

class KeyCubit extends Cubit<KeyState> {
  List<KeyModel> _originalKeys = [];

  KeyCubit() : super(KeyInitial()) {
    loadInitialKeys();
  }

  void loadInitialKeys() async {
    try {
      emit(KeyLoading());

      final response = await http
          .get(Uri.parse('http://192.168.43.60:7772/api/metadata/keynotes'));

      await Future.delayed(const Duration(milliseconds: 500));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        _originalKeys = data.map((json) => KeyModel.fromJson(json)).toList();
        emit(KeyLoaded(
          keys: _originalKeys,
          selectedKeys: const [],
        ));
      }
    } catch (e) {
      emit(KeyError());
    }
  }

  void searchKeys(String query) {
    if (state is KeyLoaded) {
      final currentState = state as KeyLoaded;

      if (query.isEmpty) {
        emit(KeyLoaded(
          keys: _originalKeys.map((key) {
            final isSelected = currentState.selectedKeys
                .any((selected) => selected.name == key.name);
            return key.copyWith(isSelected: isSelected);
          }).toList(),
          selectedKeys: currentState.selectedKeys,
          searchQuery: '',
        ));
        return;
      }

      final filteredKeys = _originalKeys
          .where((key) => key.name.toLowerCase().contains(query.toLowerCase()))
          .map((key) {
        final isSelected = currentState.selectedKeys
            .any((selected) => selected.name == key.name);
        return key.copyWith(isSelected: isSelected);
      }).toList();

      emit(KeyLoaded(
        keys: filteredKeys,
        selectedKeys: currentState.selectedKeys,
        searchQuery: query,
      ));
    }
  }

  void toggleKeySelection(KeyModel key) {
    if (state is KeyLoaded) {
      final currentState = state as KeyLoaded;
      final isAlreadySelected = currentState.selectedKeys
          .any((selectedKey) => selectedKey.name == key.name);

      List<KeyModel> updatedSelected = List.from(currentState.selectedKeys);
      List<KeyModel> updatedKeys = currentState.keys.map((g) {
        if (g.name == key.name) {
          return g.copyWith(isSelected: !isAlreadySelected);
        }
        return g;
      }).toList();

      if (isAlreadySelected) {
        updatedSelected.removeWhere((g) => g.name == key.name);
      } else {
        updatedSelected.add(key.copyWith(isSelected: true));
      }

      emit(KeyLoaded(
        keys: updatedKeys,
        selectedKeys: updatedSelected,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  void clearSelection() {
    if (state is KeyLoaded) {
      final currentState = state as KeyLoaded;

      // Reset all Keys' selection state
      final clearedKeys = currentState.keys
          .map((key) => key.copyWith(isSelected: false))
          .toList();

      emit(KeyLoaded(
        keys: clearedKeys,
        selectedKeys: const [], // Clear selected Keys
        searchQuery: currentState.searchQuery,
      ));
    }
  }
}
