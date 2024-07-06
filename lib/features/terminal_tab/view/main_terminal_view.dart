import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xterm/xterm.dart';
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
          cursorType: TerminalCursorType.block,
          theme: const TerminalTheme(
            cursor: Color(0XAAAEAFAD),
            selection: Color(0XAAAEAFAD),
            foreground: Color(0XFFCCCCCC),
            background: Color(0X051E1E1E),
            black: Color(0XFF000000),
            red: Color(0XFFCD3131),
            green: Color(0XFF0DBC79),
            yellow: Color(0XFFE5E510),
            blue: Color(0XFF2472C8),
            magenta: Color(0XFFBC3FBC),
            cyan: Color(0XFF11A8CD),
            white: Color(0XFFE5E5E5),
            brightBlack: Color(0XFF666666),
            brightRed: Color(0XFFF14C4C),
            brightGreen: Color(0XFF23D18B),
            brightYellow: Color(0XFFF5F543),
            brightBlue: Color(0XFF3B8EEA),
            brightMagenta: Color(0XFFD670D6),
            brightCyan: Color(0XFF29B8DB),
            brightWhite: Color(0XFFFFFFFF),
            searchHitBackground: Color(0XFFFFFF2B),
            searchHitBackgroundCurrent: Color(0XFF31FF26),
            searchHitForeground: Color(0XFF000000),
          ),
          shortcuts: const {
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
          },
          textScaler: TextScaler.noScaling,
          textStyle: const TerminalStyle(
            fontFamily: "consolas",
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
