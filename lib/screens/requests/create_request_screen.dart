import 'package:flutter/material.dart';
import '../../services/mock_data_service.dart';
import '../../widgets/header.dart';
import '../../widgets/snackbar_helper.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  List<String> _selectedPhotos = []; // В реальном приложении это будут пути к файлам

  final List<String> _locationOptions = [
    'Кухня',
    'Ванная',
    'Гостиная',
    'Спальня',
    'Коридор',
    'Балкон',
    'Другое'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Имитация отправки заявки
      await Future.delayed(const Duration(seconds: 2));

      // В реальном приложении здесь был бы API вызов
      // Пока просто показываем успех
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Заявка успешно создана');
        Navigator.of(context).pop();
      }
    }
  }

  void _addPhoto() {
    // В реальном приложении здесь был бы выбор фото из галереи или камеры
    setState(() {
      _selectedPhotos.add('photo_${_selectedPhotos.length + 1}.jpg');
    });
    SnackbarHelper.showSuccess(context, 'Фото добавлено (имитация)');
  }

  void _removePhoto(int index) {
    setState(() {
      _selectedPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            user: MockDataService.getCurrentUser(),
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Создать заявку',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Опишите проблему и прикрепите фото',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Заголовок
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Заголовок проблемы',
                        hintText: 'Например: Течет кран в ванной',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите заголовок';
                        }
                        if (value.length < 5) {
                          return 'Заголовок должен быть не менее 5 символов';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Описание
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Подробное описание',
                        hintText: 'Опишите проблему как можно подробнее...',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Введите описание проблемы';
                        }
                        if (value.length < 10) {
                          return 'Описание должно быть не менее 10 символов';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Локация
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Местоположение',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      items: _locationOptions.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _locationController.text = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Выберите местоположение';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Фото
                    const Text(
                      'Фото проблемы',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Выбранные фото
                    if (_selectedPhotos.isNotEmpty) ...[
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedPhotos.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/placeholder.jpg'), // Заглушка
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => _removePhoto(index),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Кнопка добавления фото
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addPhoto,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Добавить фото'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF1E3A8A)),
                          foregroundColor: const Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Кнопка отправки
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Отправить заявку',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}