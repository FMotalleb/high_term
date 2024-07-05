import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import '../../tab_controller/tab_controller.dart';
import '../controller/terminal_cubit.dart';
import 'main_terminal_view.dart';

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
    return BlocBuilder<TabController<TerminalCubit>, TabControllerState<TerminalCubit>>(
      builder: (context, state) {
        return MacosWindow(
          child: MacosTabView(
            padding: EdgeInsets.zero,
            position: MacosTabPosition.bottom,
            controller: MacosTabController(length: state.totalItems),
            tabs: List.generate(
              state.totalItems,
              (index) => MacosTab(
                label: 'Tab: $index',
                active: state.currentIndex == index,
              ),
            ),
            children: List.generate(
              state.totalItems,
              (index) => BlocProvider.value(
                value: state.allItems[index],
                child: const TerminalDisplay(),
              ),
            ),
          ),
        );
      },
    );
  }
}
