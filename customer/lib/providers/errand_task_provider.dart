import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/errand_item.dart';

// Re-export so existing screens that import this file still get ErrandItem.
export '../models/errand_item.dart';

class ErrandTaskNotifier extends Notifier<List<ErrandItem>> {
  @override
  List<ErrandItem> build() => []; // start empty — no debug seed data

  void addItem() {
    state = [...state, ErrandItem()];
  }

  void updateItemName(int index, String name) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(name: name);
    state = updated;
  }

  void updateItemDetails(int index, String details) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(details: details);
    state = updated;
  }

  void incrementQuantity(int index) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(
      quantity: updated[index].quantity + 1,
    );
    state = updated;
  }

  void decrementQuantity(int index) {
    final updated = [...state];
    if (updated[index].quantity > 1) {
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
      state = updated;
    }
  }

  void removeItem(int index) {
    final updated = [...state];
    updated.removeAt(index);
    state = updated;
  }

  void clearTask() {
    state = []; // fully empty — the UI should show an "Add item" prompt
  }

  int get totalItems => state.length;
}

final errandTaskProvider =
    NotifierProvider<ErrandTaskNotifier, List<ErrandItem>>(
        ErrandTaskNotifier.new);
