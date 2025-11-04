import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_specialization.freezed.dart';
part 'medical_specialization.g.dart';

@freezed
class MedicalSpecialization with _$MedicalSpecialization {
  const factory MedicalSpecialization({
    required String id,
    required String name,
    required String description,
    String? icon,
  }) = _MedicalSpecialization;

  factory MedicalSpecialization.fromJson(Map<String, dynamic> json) =>
      _$MedicalSpecializationFromJson(json);
}

// Lista de especializaciones médicas comunes
class MedicalSpecializations {
  static const List<MedicalSpecialization> list = [
    MedicalSpecialization(
      id: 'general',
      name: 'Medicina General',
      description: 'Atención médica integral y preventiva',
      icon: '🏥',
    ),
    MedicalSpecialization(
      id: 'cardiology',
      name: 'Cardiología',
      description: 'Especialidad en enfermedades del corazón',
      icon: '❤️',
    ),
    MedicalSpecialization(
      id: 'neurology',
      name: 'Neurología',
      description: 'Especialidad en enfermedades del sistema nervioso',
      icon: '🧠',
    ),
    MedicalSpecialization(
      id: 'pediatrics',
      name: 'Pediatría',
      description: 'Medicina especializada en niños y adolescentes',
      icon: '👶',
    ),
    MedicalSpecialization(
      id: 'dermatology',
      name: 'Dermatología',
      description: 'Especialidad en enfermedades de la piel',
      icon: '🩺',
    ),
    MedicalSpecialization(
      id: 'orthopedics',
      name: 'Ortopedia',
      description: 'Especialidad en huesos, articulaciones y músculos',
      icon: '🦴',
    ),
    MedicalSpecialization(
      id: 'gynecology',
      name: 'Ginecología',
      description: 'Especialidad en salud reproductiva femenina',
      icon: '👩',
    ),
    MedicalSpecialization(
      id: 'psychiatry',
      name: 'Psiquiatría',
      description: 'Especialidad en salud mental',
      icon: '🧘',
    ),
    MedicalSpecialization(
      id: 'oncology',
      name: 'Oncología',
      description: 'Especialidad en tratamiento del cáncer',
      icon: '🎗️',
    ),
    MedicalSpecialization(
      id: 'endocrinology',
      name: 'Endocrinología',
      description: 'Especialidad en hormonas y metabolismo',
      icon: '⚕️',
    ),
    MedicalSpecialization(
      id: 'gastroenterology',
      name: 'Gastroenterología',
      description: 'Especialidad en sistema digestivo',
      icon: '🫀',
    ),
    MedicalSpecialization(
      id: 'pulmonology',
      name: 'Neumología',
      description: 'Especialidad en enfermedades respiratorias',
      icon: '🫁',
    ),
    MedicalSpecialization(
      id: 'urology',
      name: 'Urología',
      description: 'Especialidad en sistema urinario',
      icon: '🔬',
    ),
    MedicalSpecialization(
      id: 'ophthalmology',
      name: 'Oftalmología',
      description: 'Especialidad en ojos y visión',
      icon: '👁️',
    ),
    MedicalSpecialization(
      id: 'otolaryngology',
      name: 'Otorrinolaringología',
      description: 'Especialidad en oído, nariz y garganta',
      icon: '👂',
    ),
    MedicalSpecialization(
      id: 'anesthesiology',
      name: 'Anestesiología',
      description: 'Especialidad en anestesia y cuidados críticos',
      icon: '💉',
    ),
    MedicalSpecialization(
      id: 'radiology',
      name: 'Radiología',
      description: 'Especialidad en diagnóstico por imágenes',
      icon: '📷',
    ),
    MedicalSpecialization(
      id: 'pathology',
      name: 'Patología',
      description: 'Especialidad en diagnóstico de enfermedades',
      icon: '🔍',
    ),
    MedicalSpecialization(
      id: 'emergency',
      name: 'Medicina de Emergencias',
      description: 'Atención médica de urgencias',
      icon: '🚑',
    ),
    MedicalSpecialization(
      id: 'family',
      name: 'Medicina Familiar',
      description: 'Atención integral a la familia',
      icon: '👨‍👩‍👧‍👦',
    ),
  ];

  static MedicalSpecialization? getById(String id) {
    try {
      return list.firstWhere((spec) => spec.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<MedicalSpecialization> search(String query) {
    if (query.isEmpty) return list;
    
    return list.where((spec) =>
      spec.name.toLowerCase().contains(query.toLowerCase()) ||
      spec.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}

