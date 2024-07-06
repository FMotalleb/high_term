import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabControllerState<T> extends Equatable {
  const TabControllerState({
    required this.totalItems,
    required this.currentIndex,
    required this.currentItem,
  });

  final int totalItems;
  final int currentIndex;
  final T currentItem;
  @override
  List<Object?> get props => [currentIndex, totalItems];
}

class ITabController<T> extends Cubit<TabControllerState<T>> {
  ITabController({
    T? initialItem,
    required this.newItemGenerator,
    required this.cleanup,
  })  : items = List.empty(growable: true),
        super(
          () {
            final item = initialItem ?? newItemGenerator(0);
            return TabControllerState(
              totalItems: 0,
              currentIndex: 0,
              currentItem: item,
            );
          }(),
        ) {
    items.add(initialItem ?? newItemGenerator(0));
    emit(
      TabControllerState(
        totalItems: 1,
        currentIndex: 0,
        currentItem: items.last,
      ),
    );
  }
  Future<void> newTab() async {
    items.add(newItemGenerator(items.length - 1));
    emit(
      TabControllerState(
        totalItems: items.length,
        currentIndex: items.length - 1,
        currentItem: items.last,
      ),
    );
  }

  void select(int index) {
    assert(index >= 0 && index < items.length, 'index out of range');
    emit(
      TabControllerState(
        totalItems: items.length,
        currentIndex: index,
        currentItem: items[index],
      ),
    );
  }

  void remove(int index) {
    assert(index >= 0 && index < items.length, 'index out of range');
    items.removeAt(index);
    emit(
      TabControllerState(
        totalItems: items.length,
        currentIndex: items.length - 1,
        currentItem: items.last,
      ),
    );
  }

  final List<T> items;
  final T Function(int index) newItemGenerator;
  final void Function(T item) cleanup;
}
