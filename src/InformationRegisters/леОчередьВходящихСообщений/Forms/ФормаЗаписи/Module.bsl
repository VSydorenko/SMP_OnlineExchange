
&НаСервере
Процедура ПоказатьДанныеПриИзмененииНаСервере()
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеПриИзменении(Элемент)
	ПоказатьДанныеПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	Элементы.Данные.Видимость = ПоказатьДанные;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьВидимость();
	ДанныеКратко = Запись.Данные;
КонецПроцедуры
