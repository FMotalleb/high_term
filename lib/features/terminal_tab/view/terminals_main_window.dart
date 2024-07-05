import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import '../../../core/utils/ctx_utils.dart';
import '../../tab_controller/tab_controller.dart';
import '../controller/terminal_cubit.dart';
import 'main_terminal_view.dart';
import 'terminal_tab_btn_view.dart';

class TerminalsMainWindow extends StatelessWidget {
  const TerminalsMainWindow({super.key, required this.title});

  final String title;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ITabController<TerminalCubit>, TabControllerState<TerminalCubit>>(
      builder: (context, state) {
        return MacosWindow(
          child: SizedBox(
            height: context.height,
            child: Column(
              children: [
                Flexible(
                  child: BlocProvider.value(
                    value: state.currentItem,
                    child: const TerminalDisplay(),
                  ),
                ),
                Row(
                  children: List.generate(state.totalItems + 1, (index) {
                    if (index == state.totalItems) {
                      return FilledButton(
                        onPressed: () {
                          context.read<ITabController<TerminalCubit>>().newTab();
                        },
                        child: const Text(
                          'add',
                        ),
                      );
                    }
                    return BlocProvider.value(
                      value: state.allItems[index],
                      child: TerminalTabBtnView(
                        index: index,
                        isSelected: index == state.currentIndex,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
