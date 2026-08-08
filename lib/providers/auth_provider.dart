// lib/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ufc_delivery_app/notifiers/auth_notifier.dart';
import '../services/auth_service.dart'; 
import '../config/dio.dart'; 



final dioProvider = Provider((ref) => api);


final authServiceProvider = Provider((ref) => AuthService(ref.read(dioProvider)));


final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);
