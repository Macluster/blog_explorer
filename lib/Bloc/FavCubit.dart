import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

/// {@template counter_cubit}
/// A [Cubit] which manages an [int] as its state.
/// {@endtemplate}
/// 


class FavCubit extends Cubit<List> {

  /// {@macro counter_cubit}
FavCubit() : super([]);

  /// Add 1 to the current state.
  void addItem(String value) {



        state.add(value);
        print(state);
      emit(state);
      
  }

  void removeitem(String value)
  {
    var list=[];
    list.addAll(state);
    list.remove(value);
    state.clear();
    state.addAll(list);
    emit(list);
  }

  void init(List list)
  {
    state.clear();
    state.addAll(list);
    emit(state);
  }

 

}

class TitleCubit extends Cubit<String>
{
  TitleCubit():super("Blogs and Articles");

  void changeTitle(String title)
  {
    emit(title);
    
  }
}
