Функция ПодключитьОбработку(ИмяОбработки) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Каталог = КаталогОбработчиков();
	
	Если НЕ Прав(Каталог, 1) = "\" Тогда
		Каталог = Каталог + "\";
	КонецЕсли;
	ИмяФайла = Каталог + ИмяОбработки + ".epf";
	
	Файл = Новый Файл(ИмяФайла);
	Если Файл.Существует() и леОбщегоНазначения.РежимОтладки() Тогда
		Обработка = ЗагрузитьОбработку(ИмяФайла, ИмяОбработки);		
	КонецЕсли;
	
	Если Не Обработка = Неопределено Тогда
		Возврат Обработка;
	КонецЕсли;
	
	Возврат Обработки[ИмяОбработки].Создать();		
КонецФункции

Функция ЗагрузитьОбработку(ИмяФайла, ИмяОбработки)
	Защита = Новый ОписаниеЗащитыОтОпасныхДействий;
	Защита.ПредупреждатьОбОпасныхДействиях = Ложь;
	
	Попытка
		Обработка = ВнешниеОбработки.Создать(ИмяФайла, Ложь, Защита);
		Возврат Обработка;
	Исключение
		СообщениеОбОшибке = "Ошибка при подключении обработки " + ИмяОбработки + ": " + ОписаниеОшибки();
		ЗаписьЖурналаРегистрации("леПодключаемыеОбработчики", УровеньЖурналаРегистрации.Ошибка,,,СообщениеОбОшибке);
	КонецПопытки;
	Возврат Неопределено;
КонецФункции

Функция ПриЗаписиОбъектаВыполнитьОбработку(Источник) Экспорт
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("ЗаписьВходящихДанныхliteExchange") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Источник", Источник.Ссылка);
	Параметры.Вставить("Приложение", "liteExchange");
	Если леОбщегоНазначения.РежимОтладки() Тогда
		леПодключаемыеОбработчики.ВыполнитьПодключаемыйОбработчикВФоне(Параметры);
	Иначе
		МассивПараметров = Новый Массив;
		МассивПараметров.Добавить(Параметры);
		ФоновыеЗадания.Выполнить("леПодключаемыеОбработчики.ВыполнитьПодключаемыйОбработчикВФоне", МассивПараметров, "", "Подключаемый обработчик");
	КонецЕсли;
КонецФункции

// Устарела. Следует использовать "леСобытия.ОтправитьДанные"
Функция ВыполнитьПодключаемыйОбработчикВФоне(Данные) Экспорт
	Возврат леСобытия.ОтправитьДанные(Данные);
КонецФункции

Функция КаталогОбработчиков()
	Строка = СтрокаСоединенияИнформационнойБазы();
	Если Найти(Строка, "File") Тогда
		ДанныеСтроки = СтрРазделить(Строка, "=");
		Возврат Сред(ДанныеСтроки[1], 2, СтрДлина(ДанныеСтроки[1])-3) + "\bin\";
	Иначе
		Возврат КаталогВременныхФайлов();
	КонецЕсли;
КонецФункции

Функция ПолучитьОчередьНаОтправку()
	
КонецФункции