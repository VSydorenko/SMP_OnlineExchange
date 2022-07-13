
#Область СтандартныеЗапросы

Функция ОбменДаннымиDataPost(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=utf-8");
	
	ИдентификаторОбмена = Запрос.ПараметрыURL.Получить("ИдентификаторОбмена");
	УчетнаяЗаписьОбмена = СМП_ОнлайнОбменПовтИсп.ПолучитьУчетнуюЗаписьОбменаПоИд(ИдентификаторОбмена, Истина);
	
	Если УчетнаяЗаписьОбмена <> Неопределено Тогда
		
		ТелоЗапросаСтрокой = Запрос.ПолучитьТелоКакСтроку();
		Если ТипЗнч(ТелоЗапросаСтрокой) = Тип("Строка") Тогда
			СтрокаУИД = СМП_ОнлайнОбменУправлениеОчередями.ДобавитьСообщениеВОчередьВходящих(УчетнаяЗаписьОбмена, ТелоЗапросаСтрокой);
			Если СтрокаУИД <> Неопределено Тогда
				Ответ.КодСостояния = 201; // Created - "Создано". Запрос успешно выполнен и в результате был создан ресурс. Этот код обычно присылается в ответ на запрос PUT "ПОМЕСТИТЬ".
			КонецЕсли;
		Иначе
			Ответ.КодСостояния = 415; //Unsupported Media Type - Медиа формат запрашиваемых данных не поддерживается сервером, поэтому запрос отклонён.
		КонецЕсли;
		
	Иначе
		
		Ответ.КодСостояния = 404;
		ТекстОтвета = "В базе-приемнике не найдена учетная запись обмена с идентификатором """ + ИдентификаторОбмена + """.";
		Ответ.УстановитьТелоИзСтроки(ТекстОтвета);
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ПроверкаСвязиPingGet(Запрос)
	
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type","text/html; charset=utf-8");
	
	ИдентификаторОбмена = Запрос.ПараметрыURL.Получить("ИдентификаторОбмена");
	Если ИдентификаторОбмена <> Неопределено Тогда
		
		УчетнаяЗаписьОбмена = СМП_ОнлайнОбменПовтИсп.ПолучитьУчетнуюЗаписьОбменаПоИд(ИдентификаторОбмена, Истина);
		Если УчетнаяЗаписьОбмена = Неопределено Тогда
			Ответ.КодСостояния = 404;
			ТекстОтвета = "В базе-приемнике не найдена учетная запись обмена с идентификатором """ + ИдентификаторОбмена + """.";
			Ответ.УстановитьТелоИзСтроки(ТекстОтвета);
		КонецЕсли;
		
	Иначе
		
		Ответ.КодСостояния = 400;
		ТекстОтвета = "Не указан идентификатор учетной записи обмена!";
		Ответ.УстановитьТелоИзСтроки(ТекстОтвета, КодировкаТекста.UTF8);
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция ВыгрузкаОписанияМетаданныхMetadataGet(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

Функция ОписаниеВыгружаемыхДанныхRulesGet(Запрос)
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
