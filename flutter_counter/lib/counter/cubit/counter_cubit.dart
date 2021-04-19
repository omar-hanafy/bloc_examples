import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void encr() => emit(state + 1);

  void decr() => emit(state - 1);
}
