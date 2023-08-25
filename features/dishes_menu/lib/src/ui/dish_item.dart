import 'package:core/core.dart' show BlocProvider;
import 'package:core_ui/core_ui.dart';
import 'package:dishes_menu/src/bloc/dishes_menu_screen/dishes_menu_bloc.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:flutter/material.dart';

class DishItem extends StatefulWidget {
  final DishModel _model;
  final void Function(Offset childOffset) _handler;

  const DishItem({
    required DishModel model,
    required void Function(Offset childOffset) handler,
    super.key,
  })  : _model = model,
        _handler = handler;

  @override
  State<DishItem> createState() => _DishItemState();
}

class _DishItemState extends State<DishItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppNumConstants.scaleDuration),
    );
    _controller.addListener(
      () {
        if (_controller.isCompleted) {
          _controller.reverse();
        }
      },
    );
    _animation = Tween<double>(
      begin: AppNumConstants.buttonMinScale,
      end: AppNumConstants.buttonMaxScale,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => BlocProvider.of<MenuBloc>(context).add(
        OpenDetailedEvent(
          model: widget._model,
          handler: () => BlocProvider.of<MenuBloc>(context).add(
            AddDishEvent(model: widget._model),
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(AppDimens.padding10),
        padding: const EdgeInsets.only(
          top: AppDimens.padding10,
          bottom: AppDimens.padding10,
        ),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurStyle: BlurStyle.outer,
              blurRadius: AppDimens.padding10,
              color: Theme.of(context).cardColor,
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(AppDimens.radius10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.margin5,
                bottom: AppDimens.margin5,
              ),
              child: Text(
                widget._model.name,
                style: AppFonts.normal25,
              ),
            ),
            Hero(
              tag: widget._model.id,
              child: Builder(builder: (BuildContext context) {
                return AppImage(
                  imageRef: widget._model.imageRef,
                  width: AppDimens.size200,
                  height: AppDimens.size200,
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  '${widget._model.price}\$',
                  style: AppFonts.bold24.copyWith(
                    color: Theme.of(context).indicatorColor,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animation,
                  child: AppButton(
                    text: AppStrConstants.addToCart,
                    handler: () {
                      if (_controller.isAnimating) {
                        _controller.reset();
                      }
                      widget._handler(
                        (context.findRenderObject() as RenderBox)
                            .localToGlobal(Offset.zero),
                      );
                      _controller.forward();
                    },
                  ),
                  builder: (_, Widget? child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: child,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
