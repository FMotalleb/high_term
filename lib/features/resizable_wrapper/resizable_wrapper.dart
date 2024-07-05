import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class ResizableWrapper extends StatelessWidget {
  const ResizableWrapper({
    super.key,
    required this.resizeDirection,
    required this.child,
  });
  final AxisDirection resizeDirection;
  ResizeEdge convertDirectionToEdge(AxisDirection direction) {
    return switch (direction) {
      AxisDirection.up => ResizeEdge.top,
      AxisDirection.down => ResizeEdge.bottom,
      AxisDirection.right => ResizeEdge.right,
      AxisDirection.left => ResizeEdge.left,
    };
  }

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: switch (resizeDirection) {
        AxisDirection.down || AxisDirection.up => Axis.vertical,
        AxisDirection.right || AxisDirection.left => Axis.horizontal
      },
      textDirection: TextDirection.ltr,
      children: [
        if (resizeDirection == AxisDirection.up || //
            resizeDirection == AxisDirection.left)
          Listener(
            onPointerDown: (_) async => windowManager.startResizing(
              convertDirectionToEdge(
                resizeDirection,
              ),
            ),
            child: const Divider(
              thickness: 10,
            ),
          ),
        Expanded(child: child),
        if (resizeDirection == AxisDirection.down || //
            resizeDirection == AxisDirection.right)
          Listener(
            onPointerDown: (_) async => windowManager.startResizing(
              convertDirectionToEdge(
                resizeDirection,
              ),
            ),
            child: const Divider(
              thickness: 10,
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      EnumProperty<AxisDirection>(
        'resizeDirection',
        resizeDirection,
      ),
    );
  }
}
