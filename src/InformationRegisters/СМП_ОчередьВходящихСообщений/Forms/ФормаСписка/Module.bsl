
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьСообщение(Команда)
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ЗапуститьОбработкуСообщения(Элементы.Список.ТекущиеДанные.УчетнаяЗаписьОбмена, Элементы.Список.ТекущиеДанные.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Запуск обработки сообщения.
//
// Параметры:
//   <Параметр1> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//   <Параметр2> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервереБезКонтекста
Процедура ЗапуститьОбработкуСообщения(УчетнаяЗапись, ИдентификаторСообщения) 
	
	СМП_ОнлайнОбменУправлениеОчередями.ОбработатьВходящееСообщение(УчетнаяЗапись, ИдентификаторСообщения);
	
КонецПроцедуры //ЗапуститьОбработкуСообщения


#КонецОбласти

