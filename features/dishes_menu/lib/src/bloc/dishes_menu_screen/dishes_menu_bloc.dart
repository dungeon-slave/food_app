import 'package:core/core.dart' show Bloc, Emitter, StackRouter;
import 'package:detailed_page/detailed_page.dart';
import 'package:domain/domain.dart';
import 'package:domain/models/cart_items/cart_item_model.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:domain/models/dishes_items/dish_type_model.dart';
import 'package:domain/usecase/usecase.dart';

part 'dishes_menu_event.dart';
part 'dishes_menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final FetchDishesUsecase _fetchDishesUsecase;
  final SaveItemUseCase _saveItemUseCase;
  final StackRouter _stackRouter;

  MenuBloc({
    required FetchDishesUsecase fetchDishesUsecase,
    required SaveItemUseCase saveItemsUseCase,
    required StackRouter stackRouter,
  })  : _fetchDishesUsecase = fetchDishesUsecase,
        _saveItemUseCase = saveItemsUseCase,
        _stackRouter = stackRouter,
        super(const MenuState(
          items: <DishTypeModel>[],
          isLoading: true,
        )) {
    on<InitEvent>(_init);
    on<ChangeTypeEvent>(_changeType);
    on<AddDishEvent>(_addDish);
    on<OpenDetailedEvent>(_openDetailed);

    add(InitEvent());
  }

  void _openDetailed(OpenDetailedEvent event, Emitter<MenuState> emit) {
    _stackRouter.push(
      DetailedPageRoute(
        model: event.model,
        addToCartHandler: event.handler,
      ),
    );
  }

  Future<void> _init(InitEvent event, Emitter<MenuState> emit) async {
    try {
      emit(
        state.copyWith(
          isLoading: false,
          items: await _fetchDishesUsecase.execute(const NoParams()),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _changeType(ChangeTypeEvent event, Emitter<MenuState> emit) {
    emit(state.copyWith(currentTab: event.typeIndex));
  }

  Future<void> _addDish(AddDishEvent event, Emitter<MenuState> emit) async {
    await _saveItemUseCase.execute(
      CartItemModel(
        dishModel: event.model,
        count: 1,
      ),
    );
    emit(state.copyWith());
  }
}
