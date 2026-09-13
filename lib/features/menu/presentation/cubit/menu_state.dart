import '../../domain/entities/menu_item.dart';

class MenuState {
  final List<MenuItem> items;
  final bool isLoading;
  final String? error;
  final String? sort;

  const MenuState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.sort,
  });

  MenuState copyWith({
    List<MenuItem>? items,
    bool? isLoading,
    String? error,
    String? sort,
  }) {
    return MenuState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sort: sort ?? this.sort,
    );
  }
}