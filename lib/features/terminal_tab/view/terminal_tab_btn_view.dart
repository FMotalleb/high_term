import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../tab_controller/tab_controller.dart';
import '../controller/terminal_cubit.dart';

class TerminalTabBtnView extends StatelessWidget {
  const TerminalTabBtnView({
    super.key,
    required this.index,
    required this.isSelected,
  });
  final int index;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.resolveWith(
          (states) {
            if (!isSelected) {
              return RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              );
            }
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            );
          },
        ),
        backgroundColor: WidgetStateColor.resolveWith(
          (_) => isSelected ? Colors.green : Colors.grey,
        ),
      ),
      onPressed: () {
        context.read<ITabController<TerminalCubit>>().select(index);
      },
      onLongPress: () {
        context.read<ITabController<TerminalCubit>>().remove(index);
      },
      child: Text('Tab: $index'),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('index', index))
      ..add(DiagnosticsProperty<bool>('isSelected', isSelected));
  }
}
