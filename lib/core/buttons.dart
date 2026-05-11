import 'package:learnio/base.dart';

class MenuButtonCtrler<T> {
  final String dataName;
  final List<T> values;
  final void Function()? rebuild;
  final void Function()? rebuild2;
  final dynamic Function(dynamic)? extraFunc;
  final dynamic Function(dynamic)? extraFunc2;
  final dynamic Function()? outFunc;
  T get value => Data.app.get<T>(dataName);
  set value(T newValue) => Data.app.put<T>(dataName, newValue);
  late T currentValue = values.first;

  MenuButtonCtrler({
    required this.dataName,
    required this.values,
    required this.rebuild,
    this.rebuild2,
    this.extraFunc,
    this.extraFunc2,
    this.outFunc
  });

  @method
  void onValueChange(T? newValue, dynamic ev, dynamic ev2) {
    if (newValue != null) {
      currentValue = newValue;
      value = newValue;

      rebuild?.call();
      rebuild2?.call();
      extraFunc?.call(ev);
      extraFunc2?.call(ev2);
    }
    outFunc?.call();
  }

  @method
  List<DropdownMenuItem<T>> getItems() {
    return values.map((v) => DropdownMenuItem(
      value: v,
      child: Text(v.toString(), style: TextStyle(
        color: tx1,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      )),
    )).toList();
  }
}
