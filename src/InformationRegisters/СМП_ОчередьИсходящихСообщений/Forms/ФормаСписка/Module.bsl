
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьСообщение(Команда)

	ТекСтрока = Элементы.Список.ТекущиеДанные;
	ОбработатьСообщениеНаСервере(ТекСтрока.УчетнаяЗаписьОбмена, ТекСтрока.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Запускает процес отправки сообщения.
//
// Параметры:
//   Учетнаязаписьобмена - СправочникСсылка.СМП_УчетныеЗаписиОбменов - учетная запись в рамках которой обрабатывается сообщение.
//   ИдентификаторСообщения - Строка - уникальный идентификатор сообщения.
//
&НаСервереБезКонтекста
Процедура ОбработатьСообщениеНаСервере(УчетнаяЗаписьОбмена, ИдентификаторСообщения) 
	
	//МассивПараметров = Новый Массив(2);
	//МассивПараметров.Установить(0, УчетнаяЗаписьОбмена);
	//МассивПараметров.Установить(1, ИдентификаторСообщения);
	//ФЗ = ФоновыеЗадания.Выполнить("СМП_ОнлайнОбменУправлениеОчередями.ОтправитьСообщение", МассивПараметров, Новый УникальныйИдентификатор);
	
	// Отладка
	СМП_ОнлайнОбменУправлениеОчередями.ОтправитьСообщение(УчетнаяЗаписьОбмена, ИдентификаторСообщения);
	
КонецПроцедуры //ОбработатьСообщениеНаСервере

#КонецОбласти