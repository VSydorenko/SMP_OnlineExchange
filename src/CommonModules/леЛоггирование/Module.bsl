Процедура СообщитьОбОшибке(Сообщение) Экспорт
	ЗаписьЖурналаРегистрации("Exchange API", УровеньЖурналаРегистрации.Ошибка,,,Сообщение);
КонецПроцедуры

Процедура СообщитьИнформацию(Сообщение) Экспорт
	ЗаписьЖурналаРегистрации("Exchange API", УровеньЖурналаРегистрации.Информация,,,Сообщение);
КонецПроцедуры

Процедура СообщитьОбОшибкеПодключаемыеОбработчики(Сообщение) Экспорт
	ЗаписьЖурналаРегистрации("Подключаемые обработчики", УровеньЖурналаРегистрации.Ошибка,,,Сообщение);
КонецПроцедуры

Процедура СообщитьИнформациюПодключаемыеОбработчики(Сообщение) Экспорт
	ЗаписьЖурналаРегистрации("Подключаемые обработчики", УровеньЖурналаРегистрации.Информация,,,Сообщение);
КонецПроцедуры