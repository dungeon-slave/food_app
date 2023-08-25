import 'package:core/core.dart';
import 'package:core/di/app_di.dart';
import 'package:core_ui/core_ui.dart';
import 'package:dishes_menu/src/bloc/dishes_menu_screen/dishes_menu_bloc.dart';
import 'package:dishes_menu/src/models/animation_model.dart';
import 'package:dishes_menu/src/ui/dish_item.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DishesMenuScreen extends StatefulWidget {
  const DishesMenuScreen({super.key});

  @override
  State<DishesMenuScreen> createState() => DishesMenuScreenState();
}

class DishesMenuScreenState extends State<DishesMenuScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final List<AnimationModel> _animationModels = <AnimationModel>[];
  bool _isTabControllerInited = false;

  void _swipeHandler(DragEndDetails details) {
    if (details.primaryVelocity! > AppNumConstants.swipesSensivity &&
        _tabController.index > 0) {
      _tabController.index--;
      return;
    }
    if (details.primaryVelocity! < -AppNumConstants.swipesSensivity &&
        _tabController.index < _tabController.length - 1) {
      _tabController.index++;
      return;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return MenuBloc(
          fetchDishesUsecase: appLocator<FetchDishesUsecase>(),
          saveItemsUseCase: appLocator<SaveItemUseCase>(),
          stackRouter: AutoRouter.of(context),
        );
      },
      child: BlocConsumer<MenuBloc, MenuState>(
        listener: (BuildContext context, MenuState state) {
          if (!_isTabControllerInited && state.items.isNotEmpty) {
            _isTabControllerInited = true;
            _tabController = TabController(
              length: state.items.length,
              vsync: this,
              animationDuration: const Duration(
                milliseconds: AppNumConstants.nestedDuration,
              ),
            );
            _tabController.addListener(
              () => BlocProvider.of<MenuBloc>(context).add(
                ChangeTypeEvent(_tabController.index),
              ),
            );
          }
        },
        builder: (BuildContext context, MenuState state) {
          if (state.errorMessage.isNotEmpty) {
            return AppError(errorText: state.errorMessage);
          }
          if (state.isLoading) {
            return const AppLoadingCircle();
          }
          return GestureDetector(
            onHorizontalDragEnd: _swipeHandler,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SafeArea(
                  minimum: EdgeInsets.only(top: constraints.minHeight / 28),
                  child: Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    appBar: AppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      toolbarHeight: AppDimens.size0,
                      bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).indicatorColor,
                        unselectedLabelColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).indicatorColor,
                        isScrollable: true,
                        tabs: List.generate(
                          state.items.length,
                          (int index) => Tab(
                            child: Text(
                              state.items[index].name,
                              style: AppFonts.normal25,
                            ),
                          ),
                        ),
                      ),
                    ),
                    body: Stack(
                      children: <Widget>[
                        ListView.builder(
                          padding: const EdgeInsets.all(AppDimens.padding10),
                          itemCount:
                              state.items[state.currentTab].dishes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return DishItem(
                              model:
                                  state.items[state.currentTab].dishes[index],
                              handler: (Offset childOffset) {
                                AnimationController currController =
                                    AnimationController(
                                  duration: const Duration(
                                    milliseconds:
                                        AppNumConstants.motionDuration,
                                  ),
                                  vsync: this,
                                );
                                Animation<Rect?> currAnimation = RectTween(
                                  begin: Rect.fromLTWH(
                                    childOffset.dx +
                                        constraints.minWidth / 4.55,
                                    childOffset.dy,
                                    AppDimens.size200,
                                    AppDimens.size200,
                                  ),
                                  end: Rect.fromLTWH(
                                    constraints.minWidth / 1.75,
                                    constraints.minHeight -
                                        constraints.minHeight / 10,
                                    AppDimens.size200 / 5,
                                    AppDimens.size200 / 5,
                                  ),
                                ).animate(currController);
                                AnimationModel currModel = AnimationModel(
                                  controller: currController,
                                  animation: currAnimation,
                                  imageRef: state.items[state.currentTab]
                                      .dishes[index].imageRef,
                                );

                                currModel.controller.addListener(
                                  () => (AnimationModel model) {
                                    if (model.animation.isCompleted) {
                                      model.controller.dispose();
                                      _animationModels.remove(model);
                                    }
                                    setState(() {});
                                  }(currModel),
                                );
                                _animationModels.add(currModel);

                                Future.delayed(
                                  const Duration(
                                    milliseconds: AppNumConstants.addDelay,
                                  ),
                                  () => BlocProvider.of<MenuBloc>(context).add(
                                    AddDishEvent(
                                      model: state.items[state.currentTab]
                                          .dishes[index],
                                    ),
                                  ),
                                );
                                currModel.controller.forward();
                              },
                            );
                          },
                        ),
                        ...List<AnimatedBuilder>.generate(
                          _animationModels.length,
                          (int index) => AnimatedBuilder(
                            animation: _animationModels[index].animation,
                            child: Positioned.fromRect(
                              rect: _animationModels[index].animation.value!,
                              child: AppImage(
                                imageRef: _animationModels[index].imageRef,
                                width: _animationModels[index]
                                    .animation
                                    .value!
                                    .width,
                                height: _animationModels[index]
                                    .animation
                                    .value!
                                    .height,
                              ),
                            ),
                            builder: (_, Widget? child) {
                              return child ?? const SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
