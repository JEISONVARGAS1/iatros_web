enum DaysWeekEnum { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

extension ContextExtension on DaysWeekEnum {

  String get toName {
    switch(this){
      case DaysWeekEnum.MONDAY:
        return "Lunes";
      case DaysWeekEnum.TUESDAY:
        return "Martes";
      case DaysWeekEnum.WEDNESDAY:
        return "Miércoles";
      case DaysWeekEnum.THURSDAY:
        return "Jueves";
      case DaysWeekEnum.FRIDAY:
        return "Viernes";
      case DaysWeekEnum.SATURDAY:
        return "Sábado";
      case DaysWeekEnum.SUNDAY:
        return "Domingo";
    }
  }
}
