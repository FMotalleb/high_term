import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xterm/xterm.dart';
import '../../../main.dart';
import '../controller/terminal_cubit.dart';
import '../controller/terminal_state.dart';

class TerminalDisplay extends StatelessWidget {
  const TerminalDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TerminalCubit, TerminalCubitState>(
      builder: (context, state) {
        return TerminalView(
          state.terminal,
          alwaysShowCursor: true,
          hardwareKeyboardOnly: false,
          shortcuts: {
            SingleActivator(
              LogicalKeyboardKey.keyC,
              control: true,
              shift: true,
            ): CopySelectionTextIntent.copy,
            SingleActivator(
              LogicalKeyboardKey.keyV,
              control: true,
              shift: true,
            ): PasteTextIntent(SelectionChangedCause.keyboard),
            SingleActivator(
              LogicalKeyboardKey.keyA,
              control: true,
            ): SelectAllTextIntent(SelectionChangedCause.keyboard),
            SingleActivator(
              LogicalKeyboardKey.escape,
            ): VoidCallbackIntent(() async {
              await windowManager.hide();

              Future.delayed(
                  const Duration(
                    seconds: 1,
                  ), () async {
                await windowManager.show();
              });
            }),
          },
          textScaler: TextScaler.linear(1),
          textStyle: const TerminalStyle(
            fontFamily: "RobotoMono Nerd Font",
            fontFamilyFallback: ["arial"],
            height: 1.5,
          ),
        );
      },
    );
  }
}

class DoNothingAction extends Action<Intent> {
  /// Creates a [DoNothingAction].
  ///
  /// The optional [consumesKey] argument defaults to true.
  DoNothingAction({bool consumesKey = true}) : _consumesKey = consumesKey;

  @override
  bool consumesKey(Intent intent) => _consumesKey;
  final bool _consumesKey;

  @override
  void invoke(Intent intent) {}
}
