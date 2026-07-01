class BaseUiState<T> {
  dynamic error;
  T? data;
  UIState? _state;

  BaseUiState();

  BaseUiState.loading() : _state = UIState.loading;
  BaseUiState.completed({this.data}) : _state = UIState.completed;
  BaseUiState.error(this.error) : _state = UIState.error;

  bool isLoading() => _state == UIState.loading;
  bool isCompleted() => _state == UIState.completed;
  bool isError() => _state == null || _state == UIState.error;

  @override
  String toString() => 'State is $_state';
}

enum UIState { loading, completed, error }
