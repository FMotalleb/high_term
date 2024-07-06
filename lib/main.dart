import 'dart:io';

import 'package:flutter/material.dart' show Colors, ThemeMode;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:super_hot_key/super_hot_key.dart';
import 'package:window_manager/window_manager.dart';

import 'features/resizable_wrapper/resizable_wrapper.dart';
import 'features/tab_controller/tab_controller.dart';
import 'features/terminal_tab/controller/terminal_cubit.dart';
import 'features/terminal_tab/model/term_generator.dart';
import 'features/terminal_tab/view/terminals_main_window.dart';

Future<void> init() async {
  await windowManager.ensureInitialized();
  await Window.initialize();
  if (Platform.isWindows) {
    await Window.setEffect(
      effect: WindowEffect.transparent,
      dark: true,
    );
  }
  final display = await screenRetriever.getPrimaryDisplay();

  await windowManager.setAsFrameless();

  final size = display.size;

  await windowManager.setSize(Size(size.width, size.height / 2));
  await windowManager.setPosition(display.visiblePosition ?? Offset.zero);
  await windowManager.setResizable(true);

  await windowManager.setAlwaysOnTop(true);
  await windowManager.setFullScreen(false);
  HotKey? escHotkey;
  await HotKey.create(
    definition: HotKeyDefinition(
      key: PhysicalKeyboardKey.keyR,
      alt: true,
    ),
    onPressed: () async {
      final currentState = await windowManager.isVisible();
      if (currentState) {
        await escHotkey?.dispose();
        await windowManager.hide();
      } else {
        await windowManager.show(inactive: false);
        escHotkey = await HotKey.create(
          definition: HotKeyDefinition(
            key: PhysicalKeyboardKey.escape,
          ),
          onPressed: () async {
            await escHotkey?.dispose();
            await windowManager.hide();
          },
        );
      }
    },
  );

  escHotkey = await HotKey.create(
    definition: HotKeyDefinition(
      key: PhysicalKeyboardKey.escape,
    ),
    onPressed: () async {
      await escHotkey?.dispose();
      await windowManager.hide();
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  // await windowManager.isAlwaysOnTop();

  runApp(const HighTermApp());
}

class HighTermApp extends StatelessWidget {
  const HighTermApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.90,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.blueGrey.withAlpha(150),
        ),
        child: BlocProvider<ITabController<TerminalCubit>>(
          create: (context) => ITabController<TerminalCubit>(
            cleanup: (term) {
              term.close();
            },
            newItemGenerator: (index) {
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
            title: 'High term',
            builder: (context, child) => Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Shortcuts.manager(
                manager: ShortcutManager(
                  modal: true,
                  shortcuts: {},
                ),
                child: ResizableWrapper(
                  resizeDirection: AxisDirection.down,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: child,
                  ),
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            theme: MacosThemeData.light(),
            darkTheme: MacosThemeData.dark(),
            themeMode: ThemeMode.dark,
            home: const TerminalsMainWindow(),
          ),
        ),
      ),
    );
  }
}
