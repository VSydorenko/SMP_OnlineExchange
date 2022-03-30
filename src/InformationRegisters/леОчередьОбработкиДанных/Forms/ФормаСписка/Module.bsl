
&НаСервере
Процедура ОбработатьНаСервере(Данные)
	Для Каждого Строка Из Данные Цикл
		леУправлениеОчередями.ОбработкаОчередиДанных(Строка.УникальныйИдентификатор)
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Обработать(Команда)
	Данные = Новый Массив;
	Для Каждого СтрокаСписка Из Элементы.Список.ВыделенныеСтроки Цикл
		Данные.Добавить(СтрокаСписка);
	КонецЦикла;
	ОбработатьНаСервере(Данные);
КонецПроцедуры
