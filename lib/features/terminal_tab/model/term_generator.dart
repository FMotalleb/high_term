import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_pty/flutter_pty.dart';
import 'package:xterm/xterm.dart';

abstract interface class ITermGenerator {
  Terminal generateTerminal();
}

class TermGenerator extends Equatable implements ITermGenerator {
  const TermGenerator({
    required this.maxLines,
    required this.terminalCommand,
    required this.workingDirectory,
    required this.environmentsVariable,
  });
  final int maxLines;
  final String terminalCommand;
  final Directory workingDirectory;
  final Map<String, String> environmentsVariable;
  @override
  Terminal generateTerminal() {
    final terminal = Terminal(
      maxLines: maxLines,
    );
    final String shell;
    final List<String> shellArgs;
    if (Platform.isWindows) {
      shell = 'cmd.exe';
      shellArgs = ['/c'];
    } else {
      shell = 'sh';
      shellArgs = ['-c'];
    }
    final pty = Pty.start(
      shell,
      arguments: [
        ...shellArgs,
        terminalCommand,
      ],
      workingDirectory: workingDirectory.path,
      environment: {
        ...Platform.environment,
        ...environmentsVariable,
      },
      columns: terminal.viewWidth,
      rows: terminal.viewHeight,
    );

    pty.output
        .cast<List<int>>()
        .transform(
          const Utf8Decoder(),
        )
        .listen(terminal.write);

    unawaited(
      pty.exitCode.then(
        (code) {
          terminal.write('\nthe process exited with exit code $code');
        },
      ),
    );

    terminal
      ..onOutput = (data) {
        pty.write(const Utf8Encoder().convert(data));
      }
      ..onResize = (w, h, pw, ph) {
        pty.resize(h, w);
      };
    return terminal;
  }

  @override
  List<Object?> get props => [
        maxLines,
        terminalCommand,
        workingDirectory,
        environmentsVariable,
      ];
}
