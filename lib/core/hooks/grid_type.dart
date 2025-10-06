import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibeat/app/injection_container.dart';

(bool, VoidCallback, ValueSetter<bool>) useSharedPrefBool(
  String key, {
  bool defaultValue = false,
}) {
  final sharedPreferences = sl<SharedPreferences>();
  
  // Получаем начальное значение из SharedPreferences
  final initialValue = sharedPreferences.getBool(key) ?? defaultValue;
  
  // Создаем состояние для значения
  final value = useState<bool>(initialValue);
  
  // Функция для переключения значения
  final toggleValue = useCallback(() {
    final newValue = !value.value;
    value.value = newValue;
    sharedPreferences.setBool(key, newValue);
  }, [key, value.value, sharedPreferences]);
  
  // Функция для установки конкретного значения
  final setValue = useCallback((bool newValue) {
    value.value = newValue;
    sharedPreferences.setBool(key, newValue);
  }, [key, value.value, sharedPreferences]);
  
  return (value.value, toggleValue, setValue);
}