import 'dart:io';

import 'package:bloc/bloc.dart';

import '../model/term_generator.dart';
import 'terminal_state.dart';

class TerminalCubit extends Cubit<TerminalCubitState> {
  TerminalCubit([TermGenerator? termBuilder])
      : super(
          TerminalTabInit(
            terminal: (termBuilder ?? //
                    TermGenerator(
                      maxLines: 1000,
                      terminalCommand: 'nu',
                      workingDirectory: Directory.current,
                      environmentsVariable: const {},
                    ))
                .generateTerminal(),
          ),
        );
}
