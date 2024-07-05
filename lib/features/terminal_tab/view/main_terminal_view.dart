import 'package:flutter/cupertino.dart';
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
        );
      },
    );
  }
}
