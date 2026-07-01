import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final subscription = CompositeSubscription();
  final hideKeyboardSubject = PublishSubject<bool>();

  void dispose() {
    subscription.clear();
    hideKeyboardSubject.close();
  }
}
