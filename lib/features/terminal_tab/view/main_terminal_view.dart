import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:xterm/xterm.dart';
import '../../tab_controller/tab_controller.dart';
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
        );
      },
    );
  }
}
