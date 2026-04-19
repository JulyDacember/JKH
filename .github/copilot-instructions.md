## Быстрый старт для AI-кодировщика

Проект: мобильное Flutter-приложение `zhkh_app` (вход: `lib/main.dart`). Приложение использует локальные модели в `lib/models/`, экранную структуру в `lib/screens/` и заглушечный сервис данных `lib/services/mock_data_service.dart`.

**Архитектура — суть**:
- **Точка входа**: `lib/main.dart` — содержит `AuthWrapper`, использующий `SharedPreferences` (`isLoggedIn`) для выбора `LoginScreen` vs `HomeScreen`.
- **UI**: экранная логика организована по папкам: `lib/screens/{auth,home,meters,payments,requests,activity}`; повторно используемые компоненты лежат в `widgets` внутри экранов (пример: `lib/screens/home/widgets/bottom_navigation_bar.dart`).
- **Данные**: временные данные поставляет `lib/services/mock_data_service.dart`; модели в `lib/models/` (например `user.dart`, `request.dart`, `balance.dart`, `meter.dart`).
- **Навигация**: используется `Navigator` + `MaterialPageRoute`; в некоторых местах применяются `pushReplacement` и `pushAndRemoveUntil` (см. `LoginScreen` и `HomeScreen._logout`).

**Критические рабочие процессы**:
- Установка зависимостей: `flutter pub get`.
- Локальная сборка/запуск: `flutter run -d <device>` (Android/iOS/windows/linux/mac поддерживаются через каталоги `android/`, `ios/`, `windows/`, `linux/`, `macos/`).
- Сборка Android (если нужно gradle вручную): `cd android && .\gradlew.bat assembleDebug` (Windows).
- Обновление иконок: `flutter pub run flutter_launcher_icons:main` (конфиг в `pubspec.yaml`).
- Тесты: `flutter test`.

**Проектные соглашения и паттерны**:
- Файлы — lower_snake_case; виджеты как `SomeWidget` в `some_widget.dart` в папке `widgets`.
- Данные в UI сейчас синхронные и синхронно возвращаются из `MockDataService` — для интеграции с реальным бэкендом ищите места вызова `MockDataService.*()` и заменяйте на асинхронный сервис, сохраняя модельный контракт (`lib/models/`).
- Состояние авторизации хранится в `SharedPreferences` под ключом `isLoggedIn` (значение boolean) и `userEmail` — удобно для тестов и обхода авторизации.
- Тема приложения задаётся в `ThemeData` в `lib/main.dart` (primaryColor, fontFamily и т.д.).

**Интеграции и зависимости**:
- `shared_preferences` — хранение простого состояния (авторизация).
- `intl` — форматирование дат/чисел (см. импорты в моделях/экранах).
- Иконки генерируются через `flutter_launcher_icons` (см. `pubspec.yaml`).

**Частые изменения и куда смотреть**:
- Добавление экранов — `lib/screens/<feature>/`.
- Добавление модели — `lib/models/` и корректировка мест, где `MockDataService` создаёт данные.
- Замена mock-сервиса — заменить вызовы `MockDataService` и/или реализовать интерфейс в `lib/services/real_data_service.dart`.

**Примеры быстрых правок (гуидлайн)**:
- Чтобы временно пропустить экран логина (для быстрого теста), в `lib/main.dart` в `AuthWrapper._checkAuthStatus()` можно явно установить `isLoggedIn = true`.
- Чтобы подключить реальный API, создайте `lib/services/api_service.dart`, перенесите модели из `lib/models/` и в экранах замените импорты `mock_data_service.dart` на ваш сервис, сохраняя сигнатуры методов (например `getCurrentUser()` → `Future<User> getCurrentUser()`).

**Полезные файлы для обзора**:
- `lib/main.dart` — запуск и тема
- `lib/services/mock_data_service.dart` — текущая точка правды данных
- `lib/models/` — все DTO/модели
- `lib/screens/home/home_screen.dart` — пример комбинирования виджетов, навигации и SharedPreferences

Если нужно, могу перевести инструкцию на английский, добавить примеры изменения `MockDataService` на async API или добавить чек-лист PR/старта работы для новых разработчиков. Напишите, какие разделы расширить.

***

**План работы**:
- ✅ Создать UI для Админ панели (просмотр заявок, пользователей, баланса, управление тарифами, просмотр платежей по комунальным услугам пользователей и т.д.) - реализовано admin_screen.dart, admin_requests_screen.dart
- ✅ Улучшение UX (уведомления, обработка ошибок, анимации) - добавлен snackbar_helper.dart, анимации переходов вкладок
- ✅ Реализовать функционал заявок на ремонт/обслуживание с возможностью прикрепления фото и статусов выполнения - создан create_request_screen.dart, обновлена модель Request
- ✅ Реализовать экран истории платежей с фильтрацией по дате и типу услуги - создан payment_history_screen.dart
- ✅ Реализовать экран профиля пользователя с возможностью редактирования личных данных и смены пароля - создан profile_screen.dart
- ✅ Добавление микро-анимаций (fade in карточек) - реализовано для BalanceCard и RequestsCard
- 🔄 Реализация deep linking для уведомлений
