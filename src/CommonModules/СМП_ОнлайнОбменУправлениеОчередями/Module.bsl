////////////////////////////////////////////////////////////////////////////////
// СМП_ОнлайнОбменУправлениеОчередями: работа с сообщениями онлайн-обменов данными.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДобавлениеВОчередь

// Регистрирует объект для отправки в очереди исходящих сообщений.
//
// Параметры:
//   УчетнаяЗаписьОбмена - СправочникСсылка.СМП_УчетныеЗаписиОбменов - учетная запись обмена для которой регистрируется сообщение.
//   Сообщение - ДокументССылка, СправочникСсылка - ссылка на объект, который регистрируется в очереди.
//
Процедура ДобавитьСообщениеВОчередьИсходящих(УчетнаяЗаписьОбмена, Сообщение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	МенеджерЗаписи = ПолучитьМенеджерСообщения("СМП_ОчередьИсходящихСообщений", УникальныйИдентификатор);
	МенеджерЗаписи.УчетнаязаписьОбмена = УчетнаяЗаписьОбмена;
	МенеджерЗаписи.Данные = ЗначениеВСтрокуВнутр(Сообщение);
	МенеджерЗаписи.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	// Пока что очередь только заполняется, без отправки.
	////Если СМП_ОнлайнОбменОбщегоНазначения.РежимОтладки() Тогда
	////	СМП_ОнлайнОбменУправлениеОчередями.ОтправитьСообщение(УникальныйИдентификатор);
	////Иначе
	////	Параметры = Новый Массив;
	////	Параметры.Добавить(УникальныйИдентификатор);
	////	ФоновыеЗадания.Выполнить("СМП_ОнлайнОбменУправлениеОчередями.ОтправитьСообщение", Параметры);
	////КонецЕсли;
	
КонецПроцедуры

Функция ПоместитьСообщениеВОчередьОбработки(Данные) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	
	МенеджерЗаписи = ПолучитьМенеджерСообщения("леОчередьОбработкиДанных", УникальныйИдентификатор);
	МенеджерЗаписи.ПредставлениеДанных = Данные;
	
	Попытка
		Мета = Данные.Метаданные();
		Если Метаданные.РегистрыСведений.Содержит(Мета) Тогда
			Данные = Новый Структура("Тип, Отбор", ТипЗнч(Данные), Данные.Отбор);
			МенеджерЗаписи.Данные              = ЗначениеВСтрокуВнутр(Данные);
		ИначеЕсли Метаданные.РегистрыНакопления.Содержит(Мета) Тогда
			Данные = Новый Структура("Тип, Отбор", ТипЗнч(Данные), Данные.Отбор);
			МенеджерЗаписи.Данные              = ЗначениеВСтрокуВнутр(Данные);
		ИначеЕсли Метаданные.РегистрыРасчета.Содержит(Мета) Тогда
			Данные = Новый Структура("Тип, Отбор", ТипЗнч(Данные), Данные.Отбор);
			МенеджерЗаписи.Данные              = ЗначениеВСтрокуВнутр(Данные);
		Иначе
			МенеджерЗаписи.Данные              = ЗначениеВСтрокуВнутр(Данные);
		КонецЕсли;
	Исключение
		МенеджерЗаписи.Данные              = ЗначениеВСтрокуВнутр(Данные);
	КонецПопытки;
	
	МенеджерЗаписи.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Если СМП_ОнлайнОбменОбщегоНазначения.РежимОтладки() Тогда
		СМП_ОнлайнОбменУправлениеОчередями.ОбработкаОчередиДанных(УникальныйИдентификатор);
	Иначе
		//Параметры = Новый Массив;
		//Параметры.Добавить(УникальныйИдентификатор);
		//ФоновыеЗадания.Выполнить("леУправлениеОчередями.ОбработкаОчередиДанных", Параметры);
	КонецЕсли;
	
	Возврат УникальныйИдентификатор;
	
КонецФункции

Функция ПоместитьСообщениеВОчередьВходящих(Сообщение, ТаймШтамп) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	МенеджерЗаписи = ПолучитьМенеджерСообщения("леОчередьВходящихСообщений", УникальныйИдентификатор, ТаймШтамп);
	МенеджерЗаписи.Данные    = Сообщение;
	МенеджерЗаписи.ТаймШтамп = ТаймШтамп;
	МенеджерЗаписи.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат УникальныйИдентификатор;
	
КонецФункции

#КонецОбласти

#Область ОбработкаОчереди

// Выполняет обработку сообщения в очереди исходящих.
//
// Параметры:
//   УчетнаязаписьОбмена - СправочникСсылка.СМП_УчетныеЗаписиОбменов - учетная запись обмена в рамках которой отправляется сообщение.
//   ИдентификаторСообщения - Строка - уникальный идентификатор сообщения в очереди исходящих.
//
Процедура ОтправитьСообщение(УчетнаязаписьОбмена, ИдентификаторСообщения) Экспорт
	
	УстановитьСтатусВОбработке(ИдентификаторСообщения, "Исход");
	Данные = ПолучитьИсходящееСообщениеПоИдентификатору(ИдентификаторСообщения);
	ДанныеСсылка = ЗначениеИзСтрокиВнутр(Данные);
	СМП_ОнлайнОбменСобытия.ОтправитьСообщение(УчетнаязаписьОбмена, ДанныеСсылка);
	УстановитьСтатусОбработано(ИдентификаторСообщения, "Исход");
	
КонецПроцедуры //ОбработатьИсходящееСообщение


#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти

#Область ДобавлениеВОчередь_Служебное

Функция ПолучитьМенеджерСообщения(ИмяОчереди, УникальныйИдентификатор = Неопределено, ТаймШтамп = Неопределено)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если УникальныйИдентификатор = Неопределено Тогда
		УникальныйИдентификатор = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если ТаймШтамп = Неопределено Тогда
		ТаймШтамп = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений[ИмяОчереди].СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УникальныйИдентификатор = УникальныйИдентификатор;
	МенеджерЗаписи.ДатаДобавления          = ТекущаяДатаСеанса();
	МенеджерЗаписи.ТаймШтамп               = ТаймШтамп;
	МенеджерЗаписи.Статус                  = Перечисления.СМП_СтатусыОбработкиСообщений.Новое;
	
	Возврат МенеджерЗаписи;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

#КонецОбласти

#Область ОбновлениеСтатусов

Функция УстановитьСтатусНовое(УникальныйИдентификатор, Очередь = "") Экспорт
	
	ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.Новое);
	
КонецФункции

Функция УстановитьСтатусВОбработке(УникальныйИдентификатор, Очередь = "") Экспорт
	
	ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.ВОбработке);
	
КонецФункции

Функция УстановитьСтатусДоставлено(УникальныйИдентификатор, Очередь = "")
	
	ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.Доставлено);
	
КонецФункции

Функция УстановитьСтатусОтправлено(УникальныйИдентификатор, Очередь = "")
	
	ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.Отправлено);
	
КонецФункции

Функция УстановитьСтатусОбработано(УникальныйИдентификатор, Очередь = "") Экспорт
	
	ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.Обработано);
	
КонецФункции

Функция УстановитьСтатусОшибкаОбработки(УникальныйИдентификатор, Очередь = "", СообщениеОбОшибке) Экспорт
	
	ЗаписатьОшибку(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.ОшибкаОбработки, СообщениеОбОшибке);
	
КонецФункции

Функция УстановитьСтатусОшибкаДоставки(УникальныйИдентификатор, Очередь = "", СообщениеОбОшибке)
	
	ЗаписатьОшибку(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.ОшибкаДоставки, СообщениеОбОшибке);
	
КонецФункции

Функция УстановитьСтатусОшибкаОтправки(УникальныйИдентификатор, Очередь = "", СообщениеОбОшибке)
	
	ЗаписатьОшибку(Очередь, УникальныйИдентификатор, Перечисления.СМП_СтатусыОбработкиСообщений.ОшибкаОтправки, СообщениеОбОшибке);
	
КонецФункции

Функция ОбновитьСтатусСообщения(Очередь, УникальныйИдентификатор, Статус)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = НаборЗаписейПоИмениОчереди(Очередь);
	
	НаборЗаписей.Отбор.УникальныйИдентификатор.Установить(УникальныйИдентификатор);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей[0];
		Запись.Статус = Статус;
		Если НЕ Запись.Статус = Перечисления.СМП_СтатусыОбработкиСообщений.Новое Тогда
			Запись.ДатаОбработки = ТекущаяДатаСеанса();
		КонецЕсли;
		Запись.СообщениеОбОшибке = "";
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

Функция ЗаписатьОшибку(Очередь, УникальныйИдентификатор, Статус, СообщениеОбОшибке)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = НаборЗаписейПоИмениОчереди(Очередь);
	
	НаборЗаписей.Отбор.УникальныйИдентификатор.Установить(УникальныйИдентификатор);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() Тогда
		Запись = НаборЗаписей[0];
		Запись.Статус = Статус;
		Запись.СообщениеОбОшибке = СообщениеОбОшибке;
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

#КонецОбласти

#Область ОбработкаДанных

Функция НаборЗаписейПоИмениОчереди(Очередь)
	
	Если Очередь = "" Тогда
		НаборЗаписей = РегистрыСведений.леОчередьОбработкиДанных.СоздатьНаборЗаписей();
	ИначеЕсли Найти(НРег(Очередь), "исход") Тогда
		НаборЗаписей = РегистрыСведений.СМП_ОчередьИсходящихСообщений.СоздатьНаборЗаписей();
	ИначеЕсли Найти(НРег(Очередь), "вход") Тогда
		НаборЗаписей = РегистрыСведений.леОчередьВходящихСообщений.СоздатьНаборЗаписей();
	КонецЕсли;
	
	Возврат НаборЗаписей;
	
КонецФункции

Функция ОбработкаОчередиДанных(УникальныйИдентификатор) Экспорт
	
	Данные = ПолучитьДанныеПоИдентификатору(УникальныйИдентификатор);
	СМП_СобытияОтправкиДанных.ОтправитьДанные(Данные);
	УстановитьСтатусОбработано(УникальныйИдентификатор);
	
КонецФункции

Функция ПолучитьДанныеПоИдентификатору(УникальныйИдентификатор) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	леОчередьОбработкиДанных.Данные КАК Данные
	|ИЗ
	|	РегистрСведений.леОчередьОбработкиДанных КАК леОчередьОбработкиДанных
	|ГДЕ
	|	леОчередьОбработкиДанных.УникальныйИдентификатор = &УникальныйИдентификатор";
	Запрос.УстановитьПараметр("УникальныйИдентификатор",УникальныйИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Данные = ЗначениеИзСтрокиВнутр(Выборка.Данные);
		
		//todo факт выгрузки регистров должен определяться автоматически
		Если ТипЗнч(Данные) = Тип("Структура") И Данные.Свойство("ПроизвольныеДанные") Тогда
			
		ИначеЕсли ТипЗнч(Данные) = Тип("Структура") Тогда
			Мета = Метаданные.НайтиПоТипу(Данные.Тип);
			Если Метаданные.РегистрыСведений.Содержит(Мета)
				ИЛИ Метаданные.РегистрыНакопления.Содержит(Мета)
				ИЛИ Метаданные.РегистрыРасчета.Содержит(Мета) Тогда
				
				Если Метаданные.РегистрыСведений.Содержит(Мета) Тогда
					НаборЗаписей = РегистрыСведений[Мета.Имя].СоздатьНаборЗаписей();
				ИначеЕсли Метаданные.РегистрыНакопления.Содержит(Мета) Тогда
					НаборЗаписей = РегистрыНакопления[Мета.Имя].СоздатьНаборЗаписей();
				ИначеЕсли Метаданные.РегистрыРасчета.Содержит(Мета) Тогда
					НаборЗаписей = РегистрыРасчета[Мета.Имя].СоздатьНаборЗаписей();
				КонецЕсли;
				
				Для Каждого Отбор Из Данные.Отбор Цикл
					Если Отбор.Использование Тогда
						НаборЗаписей.Отбор[Отбор.Имя].Установить(Отбор.Значение);
					КонецЕсли;
				КонецЦикла;
				
				НаборЗаписей.Прочитать();
				Данные = НаборЗаписей;
			КонецЕсли;
		КонецЕсли;
		
		Возврат Данные;
		
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьИсходящееСообщениеПоИдентификатору(УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СМП_ОчередьИсходящихСообщений.Данные КАК Сообщение
	|ИЗ
	|	РегистрСведений.СМП_ОчередьИсходящихСообщений КАК СМП_ОчередьИсходящихСообщений
	|ГДЕ
	|	СМП_ОчередьИсходящихСообщений.УникальныйИдентификатор = &УникальныйИдентификатор";
	Запрос.УстановитьПараметр("УникальныйИдентификатор",УникальныйИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Сообщение;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВходящееСообщениеПоИдентификатору(УникальныйИдентификатор)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	леОчередьВходящихСообщений.Данные КАК Сообщение
	|ИЗ
	|	РегистрСведений.леОчередьВходящихСообщений КАК леОчередьВходящихСообщений
	|ГДЕ
	|	леОчередьВходящихСообщений.УникальныйИдентификатор = &УникальныйИдентификатор";
	Запрос.УстановитьПараметр("УникальныйИдентификатор",УникальныйИдентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Сообщение;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

//Функция ОтправитьСообщение(УникальныйИдентификатор, ПараметрыДоставки = Неопределено) Экспорт
//	
//	УстановитьСтатусВОбработке(УникальныйИдентификатор, "Исходящая");
//	леЛоггирование.СообщитьИнформациюПодключаемыеОбработчики("Отправка данных");
//	
//	Данные = ПолучитьИсходящееСообщениеПоИдентификатору(УникальныйИдентификатор);
//	
//	Если Данные = Неопределено Тогда
//		ТекстОшибки = "Не удалось прочитать данные сообщения для отправки";
//		
//		УстановитьСтатусОшибкаОбработки(УникальныйИдентификатор, "Исходящая", ТекстОшибки);
//		леЛоггирование.СообщитьОбОшибке(ТекстОшибки);
//		
//		Возврат Неопределено;
//		
//	КонецЕсли;
//	
//	ОтправитьНаСервер(УникальныйИдентификатор, Данные, ПараметрыДоставки);
//	
//КонецФункции

Функция ОтправитьНаСервер(УникальныйИдентификатор, Данные, ПараметрыДоставки = Неопределено)
	
	Пользователь = "robot";
	Пароль = "robot";
	
	Параметры = Новый Структура;	
	
	ДопДанные = Новый Структура;
	УРЛ = "http://fs.local";
	
	Попытка
		Результат = леКоннекторHTTP.ОтправитьТекст(Данные, УРЛ, ДопДанные);
	Исключение
		ТекстСообщения = "Отправка не удалась";
		ОписаниеОшибки = ОписаниеОшибки();
		леЛоггирование.СообщитьОбОшибкеПодключаемыеОбработчики(ТекстСообщения + ": " + ОписаниеОшибки);
		УстановитьСтатусОшибкаОтправки(УникальныйИдентификатор, "Исходящая", ОписаниеОшибки);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Если Результат.КодСостояния = 200 Тогда
		леЛоггирование.СообщитьИнформациюПодключаемыеОбработчики("Данные отправлены успешно");
		УстановитьСтатусОтправлено(УникальныйИдентификатор, "Исходящая");
	Иначе
		ТекстСообщения = "Отправка не удалась";
		ОтветСервера = Результат.Ответ.ПолучитьТелоКакСтроку();
		леЛоггирование.СообщитьОбОшибкеПодключаемыеОбработчики(ТекстСообщения + ": " + ОтветСервера);
		УстановитьСтатусОшибкаОтправки(УникальныйИдентификатор, "Исходящая", ОтветСервера);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ОбработкаДанных

Функция Пауза(ИД, КоличествоСекунд = Неопределено) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.леОчередьОжидания.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.УникальныйИдентификатор = ИД;
	МенеджерЗаписи.Записать();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.леОчередьОжидания");
	ЭлементБлокировки.УстановитьЗначение("УникальныйИдентификатор", ИД);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	Если ЗначениеЗаполнено(КоличествоСекунд) Тогда
		ПараметрыЗадания = Новый Массив;
		ПараметрыЗадания.Добавить(ИД);	
		ФоновыеЗадания.Выполнить("СМП_ОнлайнОбменУправлениеОчередями.Пауза", ПараметрыЗадания);
	КонецЕсли;
	
КонецФункции

#КонецОбласти