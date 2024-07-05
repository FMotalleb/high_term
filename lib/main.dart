import 'dart:io';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';

import 'features/resizable_wrapper/resizable_wrapper.dart';
import 'features/tab_controller/tab_controller.dart';
import 'features/terminal_tab/controller/terminal_cubit.dart';
import 'features/terminal_tab/model/term_generator.dart';
import 'features/terminal_tab/view/terminals_main_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final display = await screenRetriever.getPrimaryDisplay();

  await windowManager.ensureInitialized();
  await windowManager.setAsFrameless();

  final size = display.size;

  await windowManager.setSize(Size(size.width, size.height / 2));
  await windowManager.setPosition(Offset.zero);
  await windowManager.setResizable(true);

  await windowManager.setFullScreen(false);
  await windowManager.isAlwaysOnTop();

  runApp(const HighTermApp());
}

class HighTermApp extends StatelessWidget {
  const HighTermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabController<TerminalCubit>>(
      create: (context) => TabController<TerminalCubit>(
        newItemGenerator: (int index) {
          return TerminalCubit(
            TermGenerator(
              maxLines: 1000,
              terminalCommand: 'nu',
              workingDirectory: Directory.current,
              environmentsVariable: const {},
            ),
          );
        },
      ),
      child: MacosApp(
        title: 'Flutter Demo',
        builder: (context, child) => ResizableWrapper(
          resizeDirection: AxisDirection.down,
          child: child ?? const SizedBox(),
        ),
        debugShowCheckedModeBanner: false,
        theme: MacosThemeData.light(),
        darkTheme: MacosThemeData.dark(),
        themeMode: ThemeMode.dark,
        home: const TerminalsMainWindow(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
