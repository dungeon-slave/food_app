import 'package:core/core.dart';
import 'package:core/di/app_di.dart';
import 'package:data/entities/cart_item_entity/cart_item_entity.dart';
import 'package:data/entities/dish_entity/dish_entity.dart';
import 'package:data/entities/dish_type_enity/dish_type_entity.dart';
import 'package:data/providers/remote/firebase_auth_provider.dart';
import 'package:data/providers/remote/firebase_provider.dart';
import 'package:data/providers/local/hive_provider.dart';
import 'package:data/repositories/authentication_repository_impl.dart';
import 'package:data/repositories/cart_repository_impl.dart';
import 'package:data/repositories/dishes_repository_impl.dart';
import 'package:data/repositories/text_scale_repository.dart';
import 'package:data/repositories/theme_repository_impl.dart';
import 'package:domain/domain.dart';
import 'package:domain/repositories/authentication_repository.dart';

final DataDI dataDI = DataDI();

class DataDI {
  void initDependencies() {
    _initServices();
    _initProviders();
    _initAdapters();
    _initRepositories();
    _initUseCases();
  }

  void _initServices() {
    appLocator.registerLazySingleton<UrlService>(
      () => UrlService(),
    );
    appLocator.registerLazySingleton<AuthService>(
      () => AuthService(),
    );
  }

  void _initProviders() {
    appLocator.registerLazySingleton<FirebaseProvider>(
      () => FirebaseProvider(),
    );

    appLocator.registerLazySingleton<HiveProvider>(
      () => HiveProvider(),
    );

    appLocator.registerLazySingleton<FirebaseAuthProvider>(
      () => FirebaseAuthProvider(
        firebaseAuth: FirebaseAuth.instance,
        googleSignIn: GoogleSignIn(),
      ),
    );
  }

  void _initAdapters() {
    Hive.registerAdapter<CartItemEntity>(
      CartItemEntityAdapter(),
    );
    Hive.registerAdapter<DishEntity>(
      DishEntityAdapter(),
    );
    Hive.registerAdapter<DishTypeEntity>(
      DishTypeEntityAdapter(),
    );
  }

  void _initRepositories() {
    appLocator.registerLazySingleton<DishesRepository>(
      () => DishesRepositoryImpl(
        firebaseProvider: appLocator<FirebaseProvider>(),
        hiveProvider: appLocator<HiveProvider>(),
      ),
    );

    appLocator.registerLazySingleton<ThemeRepository>(
      () => ThemeRepositoryImpl(
        hiveProvider: appLocator<HiveProvider>(),
      ),
    );

    appLocator.registerLazySingleton<TextScaleRepository>(
      () => TextScaleRepositoryImpl(
        hiveProvider: appLocator<HiveProvider>(),
      ),
    );

    appLocator.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(
        hiveProvider: appLocator<HiveProvider>(),
      ),
    );

    appLocator.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
        authProvider: appLocator<FirebaseAuthProvider>(),
        hiveProvider: appLocator<HiveProvider>(),
      ),
    );
  }

  void _initUseCases() {
    appLocator.registerLazySingleton<FetchDishesUsecase>(
      () => FetchDishesUsecase(
        dishesRepository: appLocator<DishesRepository>(),
      ),
    );
    appLocator.registerLazySingleton<SaveDishesUseCase>(
      () => SaveDishesUseCase(
        dishesRepository: appLocator<DishesRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SetThemeUseCase>(
      () => SetThemeUseCase(
        themeRepository: appLocator<ThemeRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetThemeUseCase>(
      () => GetThemeUseCase(
        themeRepository: appLocator<ThemeRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SetTextScaleUseCase>(
      () => SetTextScaleUseCase(
        textScaleRepository: appLocator<TextScaleRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetTextScaleUseCase>(
      () => GetTextScaleUseCase(
        textScaleRepository: appLocator<TextScaleRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SaveItemUseCase>(
      () => SaveItemUseCase(
        cartRepository: appLocator<CartRepository>(),
      ),
    );
    appLocator.registerLazySingleton<GetItemsUseCase>(
      () => GetItemsUseCase(
        cartRepository: appLocator<CartRepository>(),
      ),
    );
    appLocator.registerLazySingleton<ClearCartUseCase>(
      () => ClearCartUseCase(
        cartRepository: appLocator<CartRepository>(),
      ),
    );
    appLocator.registerLazySingleton<ChangeItemCountUseCase>(
      () => ChangeItemCountUseCase(
        cartRepository: appLocator<CartRepository>(),
      ),
    );
    appLocator.registerLazySingleton<EmailSignInUseCase>(
      () => EmailSignInUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );

    appLocator.registerLazySingleton<EmailSignUpUseCase>(
      () => EmailSignUpUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GoogleSignInUseCase>(
      () => GoogleSignInUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );

    appLocator.registerLazySingleton<SaveUserUseCase>(
      () => SaveUserUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );

    appLocator.registerLazySingleton<GetCartCountUseCase>(
      () => GetCartCountUseCase(
        cartRepository: appLocator<CartRepository>(),
      ),
    );

    appLocator.registerLazySingleton<CheckUserUseCase>(
      () => CheckUserUseCase(
        authenticationRepository: appLocator<AuthenticationRepository>(),
      ),
    );
  }
}
