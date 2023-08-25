import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:detailed_page/src/bloc/detailed_page_bloc.dart';
import 'package:domain/models/dishes_items/dish_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DetailedPage extends StatefulWidget {
  final DishModel _model;
  final void Function() _addToCartHandler;

  const DetailedPage({
    required DishModel model,
    required void Function() addToCartHandler,
    super.key,
  })  : _model = model,
        _addToCartHandler = addToCartHandler;

  @override
  State<DetailedPage> createState() => _DetailedPageState();
}

class _DetailedPageState extends State<DetailedPage>
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
    return BlocProvider(
      create: (BuildContext context) => DetailedPageBloc(
        appRouter: AutoRouter.of(context),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SafeArea(
            minimum: EdgeInsets.only(top: constraints.minHeight / 28),
            child: Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                leading: const SizedBox.shrink(),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
                actions: <Container>[
                  Container(
                    margin: const EdgeInsets.only(right: AppDimens.padding10),
                    child: BlocBuilder<DetailedPageBloc, DetailedPageState>(
                      builder: (BuildContext context, DetailedPageState state) {
                        return IconButton(
                          iconSize: AppNumConstants.deleteIconSize,
                          icon: const AppIcon(
                            AppIconsData.closeDetailedPage,
                            size: AppDimens.size40,
                          ),
                          color: Theme.of(context).primaryColor,
                          onPressed: () =>
                              BlocProvider.of<DetailedPageBloc>(context).add(
                            CloseDetailedEvent(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                title: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    widget._model.name,
                    style: AppFonts.normal30.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.only(
                  bottom: AppDimens.padding100,
                ),
                children: <Container>[
                  Container(
                    margin: const EdgeInsets.all(AppDimens.padding50),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppDimens.padding10),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: AppDimens.padding100,
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: widget._model.id,
                      child: AppImage(
                        imageRef: widget._model.imageRef,
                        width: AppDimens.size250,
                        height: AppDimens.size250,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: AppDimens.padding50),
                    padding: const EdgeInsets.only(bottom: AppDimens.padding25),
                    child: Text(
                      AppStrConstants.detailedDescription,
                      style: AppFonts.normal30.copyWith(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(
                      left: AppDimens.padding50,
                      right: AppDimens.padding15,
                    ),
                    child: Text(
                      widget._model.description,
                      style: AppFonts.normal22,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: AppDimens.padding50),
                    padding: const EdgeInsets.only(
                      bottom: AppDimens.padding25,
                      top: AppDimens.padding25,
                    ),
                    child: Text(
                      AppStrConstants.detailedIngredients,
                      style: AppFonts.normal30.copyWith(
                        color: Theme.of(context).indicatorColor,
                      ),
                    ),
                  ),
                  ...List.generate(
                    widget._model.ingredients.length,
                    (int index) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        margin:
                            const EdgeInsets.only(left: AppDimens.padding50),
                        padding: const EdgeInsets.only(
                          right: AppDimens.padding20,
                          bottom: AppDimens.padding20,
                        ),
                        child: Text(
                          '- ${widget._model.ingredients[index]}',
                          style: AppFonts.normal22,
                        ),
                      );
                    },
                  ),
                ],
              ),
              bottomSheet: Container(
                padding: const EdgeInsets.only(
                  top: AppDimens.padding10,
                  bottom: AppDimens.padding10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).indicatorColor),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurStyle: BlurStyle.normal,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ],
                ),
                child: Row(
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
                      child: Padding(
                        padding: EdgeInsets.all(_animation.value),
                        child: AppButton(
                          text: AppStrConstants.addToCart,
                          handler: () {
                            if (_controller.isAnimating) {
                              _controller.reset();
                            }
                            _controller.forward();
                            widget._addToCartHandler();
                          },
                        ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
