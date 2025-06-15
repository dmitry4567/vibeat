import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FilterItem extends Equatable {
  final String name;
  final IconData iconName;
  final String pathScreen;
  final bool choose;

  const FilterItem({
    required this.name,
    required this.iconName,
    required this.pathScreen,
    required this.choose,
  });

  FilterItem copyWith({
    String? name,
    IconData? iconName,
    String? pathScreen,
    bool? choose,
  }) {
    return FilterItem(
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      pathScreen: pathScreen ?? this.pathScreen,
      choose: choose ?? this.choose,
    );
  }

  @override
  List<Object?> get props => [name, iconName, pathScreen, choose];
}