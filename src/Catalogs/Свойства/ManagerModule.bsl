
// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Владелец");
	Результат.Добавить("Родитель");
	Результат.Добавить("Синоним");
	Результат.Добавить("Использование");
	Результат.Добавить("Индексирование");
	Результат.Добавить("КвалификаторыЧисла_Длина");
	Результат.Добавить("КвалификаторыЧисла_Точность");
	Результат.Добавить("КвалификаторыЧисла_Неотрицательное");
	Результат.Добавить("КвалификаторыСтроки_Длина");
	Результат.Добавить("КвалификаторыСтроки_Фиксированная");
	Результат.Добавить("КвалификаторыДаты_Состав");
	Результат.Добавить("Авторегистрация");
	Результат.Добавить("Вид");
	Результат.Добавить("ТипыСтрокой");
	Результат.Добавить("Типы");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()