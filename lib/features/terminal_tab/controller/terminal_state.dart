import 'package:equatable/equatable.dart';
import 'package:xterm/xterm.dart';

sealed class TerminalCubitState extends Equatable {
  const TerminalCubitState();

  Terminal get terminal;
  @override
  List<Object?> get props => [terminal.hashCode];
}

final class InitialTerminal extends TerminalCubitState {
  const InitialTerminal();

  @override
  Terminal get terminal => Terminal();
}

final class TerminalTabInit extends TerminalCubitState {
  const TerminalTabInit({
    required this.terminal,
  });

  @override
  final Terminal terminal;
}
