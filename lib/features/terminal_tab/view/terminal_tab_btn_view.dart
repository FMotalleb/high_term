import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        foregroundColor: WidgetStateColor.resolveWith(
          (_) => isSelected ? Colors.green : Colors.grey,
        ),
      ),
      onPressed: () {
        context.read<ITabController<TerminalCubit>>().select(index);
      },
      child: Text('Tab: $index'),
    );
  }
}
