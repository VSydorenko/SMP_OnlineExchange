////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

// Возвращает учетную запись обмена по переданному идентификатору.
//
// Параметры:
//   ИдентификаторОбмена - Строка - набор символов однозначно идентифицирующий учетную запись обмена в базе-приемнике.
//   ЭтоПриемник - Булево - признак учетной записи обмена на стороне применика.
//
// Возвращаемое значение:
//   СправочникСсылка.СМП_УчетныеЗаписиОбменов, Неопределено
//
Функция ПолучитьУчетнуюЗаписьОбменаПоИд(ИдентификаторОбмена, ЭтоПриемник = Ложь) Экспорт
	
	УчетнаяЗапись = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиОбменов.Ссылка КАК УчетнаяЗапись
	|ИЗ
	|	Справочник.СМП_УчетныеЗаписиОбменов КАК УчетныеЗаписиОбменов
	|ГДЕ
	|	УчетныеЗаписиОбменов.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиОбменов.ИдентификаторОбмена = &ИдентификаторОбмена
	|	И УчетныеЗаписиОбменов.НастройкаОбмена = &НастройкаОбмена
	|";
	
	Запрос.УстановитьПараметр("ИдентификаторОбмена", ИдентификаторОбмена);
	Запрос.УстановитьПараметр("НастройкаОбмена", 
	?(ЭтоПриемник, Перечисления.СМП_НастройкиОбменов.ДляПолучения, Перечисления.СМП_НастройкиОбменов.ДляОтправки));
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		УчетнаяЗапись = Выборка.УчетнаяЗапись;
	КонецЕсли;
	
	Возврат УчетнаяЗапись;
	
КонецФункции // ПолучитьУчетнуюЗаписьОбменаПоИд

// Возвращает описание правил конвертации в формате JSON.
//
// Параметры:
//   ИдентификаторОбмена - Строка - набор символов однозначно идентифицирующий учетную запись обмена в базе-приемнике.
//
// Возвращаемое значение:
//   Строка, Неопределено - строка с описанием правил конвертации в формате JSON
//
Функция ПолучитьОписаниеПравилКонвертации(ИдентификаторОбмена) Экспорт
	
	ОписаниеВыгружаемыхДанных = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СМП_УчетныеЗаписиОбменов.ОписаниеВыгружаемыхДанных КАК ОписаниеВыгружаемыхДанных
	|ИЗ
	|	Справочник.СМП_УчетныеЗаписиОбменов КАК СМП_УчетныеЗаписиОбменов
	|ГДЕ
	|	СМП_УчетныеЗаписиОбменов.ПометкаУдаления = ЛОЖЬ
	|	И СМП_УчетныеЗаписиОбменов.ИдентификаторОбмена = &ИдентификаторОбмена
	|	И СМП_УчетныеЗаписиОбменов.НастройкаОбмена = ЗНАЧЕНИЕ(Перечисление.СМП_НастройкиОбменов.ДляПолучения)";
	
	Запрос.УстановитьПараметр("ИдентификаторОбмена", ИдентификаторОбмена);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ОписаниеВыгружаемыхДанных = Выборка.ОписаниеВыгружаемыхДанных;
	КонецЕсли;
	
	
	Возврат ОписаниеВыгружаемыхДанных;
	
КонецФункции // ПолучитьОписаниеПравилКонвертации

// Возвращает настройки транспорта обмена данными.
//
// Параметры:
//   УчетнаяЗапись - СправочникСсылка.СМП_УчетныеЗаписиОбменов - обмен для которого нужно получить настройки.
//
// Возвращаемое значение:
//   Структура:
//		* Ключ - имя настройки
//		* Значение - значение настройки
//
Функция ПолучитьНастройкиТранспортаОбменаДанными(УчетнаяЗапись) Экспорт
	
	ИменаПолей = Новый Структура("ИдентификаторОбмена, ВидТранспорта, ИнтернетАдрес, КаталогФайлов, ИмяСервера1С, ИмяБазы, ИмяПользователя, ПарольПользователя",
	"ИдентификаторОбмена",
	"СпособПодключения",
	"ХттпСервисАдресПодключения",
	"ФайлКаталогОбмена",
	"КомИмяСервера1СПредприятия",
	"КомИмяИнформационнойБазыНаСервере1СПредприятия",
	"ИмяПользователя",
	"ПарольПользователя");
	НастройкиТранспорта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, ИменаПолей);
	
	Возврат НастройкиТранспорта;
	
КонецФункции // ПолучитьНастройкиТранспортаОбменаДанными

// Возвращает строку в формате JSON с данными элемента справочника или документа
// полученными по ссылке.
//
// Параметры:
//   ДанныеСсылка - СправочникСсылка, ДокументСсылка - ссылка по которой нужно получить данные.
//   УчетнаяЗаписьОбмена - СправочникСсылка.СМП_УчетныеЗаписиОбменов - обмен для которого выполняется сериализация данных.
//   ТолькоСсылки - Булево - Признак полной или частичной конвертации объекта (потом убрать).
//
// Возвращаемое значение:
//   Строка - Строка в формате JSON с данными элемента справочника или документа.
//
Функция ДанныеПоСсылкеВJSON(ДанныеСсылка, УчетнаяЗаписьОбмена, ТолькоСсылки = Истина) Экспорт
	
	Конвертер = Обработки.СМП_JSONКонвертер.Создать();
	Конвертер.УчетнаяЗаписьОбмена = УчетнаяЗаписьОбмена;
	Конвертер.ЗаполнитьОписаниеВыгружаемыхТиповДанных();
	Конвертер.ОсновнойОбъектСсылка = ДанныеСсылка;
	МассивJSON = Конвертер.ПолучитьМассивСериализованныхОбъектов();
	
	Возврат МассивJSON;
	
	//Возврат Конвертер.ЗаписатьДанныеВJSON(ДанныеСсылка, ТолькоСсылки);
	
КонецФункции


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Код процедур и функций
#КонецОбласти
