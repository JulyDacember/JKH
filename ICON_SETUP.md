# Инструкция по установке иконки приложения

## Способ 1: Автоматическая генерация (рекомендуется)

Самый простой способ - использовать пакет `flutter_launcher_icons`, который автоматически создаст все необходимые размеры иконок для всех платформ из одной исходной картинки.

### Шаги:

1. **Поместите вашу иконку в проект:**
   - Создайте папку `assets/icons` в корне проекта (рядом с папками `lib`, `android`, `ios`)
   - Поместите туда вашу иконку с именем `app_icon.png`
   - **Рекомендуемый размер:** 1024x1024 пикселей (PNG формат)
   - **Важно:** Иконка должна быть квадратной (например, 512x512, 1024x1024)

2. **Конфигурация уже добавлена в `pubspec.yaml`**

3. **Установите зависимости:**
   ```bash
   flutter pub get
   ```

4. **Сгенерируйте иконки:**
   ```bash
   flutter pub run flutter_launcher_icons
   ```

Готово! Иконки будут автоматически созданы для всех платформ (Android, iOS, Windows, Web).

---

## Способ 2: Ручная установка (если нужен полный контроль)

Если вы хотите установить иконки вручную, вот куда их нужно поместить:

### Android:
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png` (72x72)
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png` (48x48)
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png` (96x96)
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png` (144x144)
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png` (192x192)
- `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` (адаптивная иконка)

### iOS:
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Различные размеры от 20x20 до 1024x1024
  - См. файл `Contents.json` для полного списка

### Web:
- `web/icons/Icon-192.png` (192x192)
- `web/icons/Icon-512.png` (512x512)
- `web/favicon.png` (любой размер)

### Windows:
- `windows/runner/resources/app_icon.ico` (файл .ico с несколькими размерами)

---

## Рекомендация

Используйте **Способ 1** (автоматический) - это намного проще и гарантирует, что все размеры будут созданы правильно!

