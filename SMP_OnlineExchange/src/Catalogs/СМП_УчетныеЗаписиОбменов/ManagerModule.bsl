
#Область ПрограммныйИнтерфейс

// Возвращает СКД для выгрузки данных документа.
//
// Параметры:
//   ИмяДокумента - Строка - имя документа, как оно задано в конфигураторе.
//
// Возвращаемое значение:
//   СхемаКомпоновкиДанных - СКД для отборов по документу.
//
Функция ПолучитьСКД(ИмяДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = СформироватьТекстЗапроса(ИмяДокумента);
	СКД = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = ИмяДокумента;
	НаборДанных.Запрос = ТекстЗапроса;
	НаборДанных.ИсточникДанных = "ИсточникДанных1";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	
	ПолеСсылка = СКД.НастройкиПоУмолчанию.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ПолеСсылка.Заголовок = "Ссылка";
	ПолеСсылка.Использование = Истина;
	ПолеСсылка.Поле = Новый ПолеКомпоновкиДанных("Ссылка");
	
	ГруппировкаСКД = СКД.НастройкиПоУмолчанию.Структура.Добавить(тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаСКД.Использование = Истина;
	
	АвтоВыбранныеполя = ГруппировкаСКД.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	АвтоВыбранныеполя.Использование = Истина;
	
	ВыбранныеполяПорядка=ГруппировкаСКД.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	ВыбранныеполяПорядка.Использование = Истина;
	
	
	МассивСтрок = СтрРазделить(ИмяДокумента, ".");
	ИмяДок = МассивСтрок[1];
	ПараметрСсылка = СКД.Параметры.Добавить();
	ПараметрСсылка.Имя = "ПараметрСсылка";
	ПараметрСсылка.Заголовок = " Ссылка на документ";
	ПараметрСсылка.ТипЗначения = Новый ОписаниеТипов("ДокументСсылка." + ИмяДок);
	ПараметрСсылка.ВключатьВДоступныеПоля = Истина;
	ПараметрСсылка.ЗапрещатьНезаполненныеЗначения = Истина;
	ПараметрСсылка.Использование = ИспользованиеПараметраКомпоновкиДанных.Всегда;
	
	////// Временно, запись схемы в файл {
	////КаталогДляСохранения = "D:\_РобочіФайлиПрограмістів\Y.Holovatyi\LiteExchange\СКД_ДляОтбораДокументов\";
	////ИмяФайла = СтрЗаменить(ИмяДокумента, ".", "") + ".xml";
	////
	////ЗаписьXML = Новый ЗаписьXML;
	////ЗаписьXML.ОткрытьФайл(КаталогДляСохранения + ИмяФайла);
	////СериализаторXDTO.ЗаписатьXML(ЗаписьXML, 
	////							 СКД, 
	////							 "DataCompositionSchema", 
	////							 "http://v8.1c.ru/8.1/data-composition-system/schema");
	////ЗаписьXML.Закрыть();
	// Временно, запись схемы в файл }
	
	Возврат СКД;
	
КонецФункции // ПолучитьСКД

// Возвращает описание правил конвертации в формате JSON.
//
// Параметры:
//   УчетнаяЗаписьОбмена - СправочникСсылка.СМП_УчетныеЗаписиОбменов - ссылка на учетную запись 
//   по которой нужно сформировать описание правил конвертации для использования на стороне базы-отправителя.
//
// Возвращаемое значение:
//   Строка - строка с описанием правил конвертации в формате JSON
//
Функция СформироватьОписаниеВыгружаемыхДанных(УчетнаяЗаписьОбмена) Экспорт
	
	ОписаниеПравил = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаКонвертацииОбъектов.Ссылка КАК Ссылка,
	|	ПравилаКонвертацииОбъектов.ТипИсточника КАК ТипИсточника
	|ИЗ
	|	Справочник.ПравилаКонвертацииОбъектов КАК ПравилаКонвертацииОбъектов
	|ГДЕ
	|	ПравилаКонвертацииОбъектов.ПометкаУдаления = ЛОЖЬ
	|	И ПравилаКонвертацииОбъектов.ЭтоГруппа = ЛОЖЬ
	|	И НЕ ПОДСТРОКА(ПравилаКонвертацииОбъектов.ТипИсточника, 1, 18) = ""ПеречислениеСсылка""
	|	И ПравилаКонвертацииОбъектов.Владелец = &УчетнаяЗаписьОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПравилаКонвертацииСвойств.Ссылка КАК Ссылка,
	|	ПравилаКонвертацииСвойств.Владелец КАК Владелец,
	|	ПравилаКонвертацииСвойств.ИмяИсточника КАК ИмяИсточника,
	|	ПравилаКонвертацииСвойств.Поиск КАК Поиск,
	|	ПравилаКонвертацииСвойств.ЭтоГруппа КАК ЭтоГруппа
	|ИЗ
	|	Справочник.ПравилаКонвертацииСвойств КАК ПравилаКонвертацииСвойств
	|ГДЕ
	|	ПравилаКонвертацииСвойств.ПометкаУдаления = ЛОЖЬ
	|	И ПравилаКонвертацииСвойств.Отключить = ЛОЖЬ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("УчетнаяЗаписьОбмена", УчетнаяЗаписьОбмена);
	ПакетРезультатов = Запрос.ВыполнитьПакет();
	
	Если НЕ ПакетРезультатов[0].Пустой() И НЕ ПакетРезультатов[1].Пустой() Тогда
		
		сОписания = Новый Соответствие;
		
		ВыборкаПКО = ПакетРезультатов[0].Выбрать();
		ВыборкаПКС = ПакетРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
		Пока ВыборкаПКО.Следующий() Цикл
			
			СсылкаПКО = ВыборкаПКО.Ссылка;
			ТипИсточника = ВыборкаПКО.ТипИсточника;
			
			сНаборРеквизитов = сОписания.Получить(ТипИсточника);
			
			Если сНаборРеквизитов = Неопределено Тогда
				
				сНаборРеквизитов = Новый Соответствие;
				
			КонецЕсли;
			
			ЗаполнитьНаборВыгружаемыхРеквизитов(ВыборкаПКС, СсылкаПКО, сНаборРеквизитов);
			сОписания.Вставить(ТипИсточника, сНаборРеквизитов);
			
		КонецЦикла;
	КонецЕсли;
	
	мЗапись = Новый ЗаписьJSON;
	мЗапись.УстановитьСтроку();
	ЗаписатьJSON(мЗапись, сОписания);
	ОписаниеПравил = мЗапись.Закрыть();
	
	Возврат ОписаниеПравил;
	
КонецФункции // СформироватьОписаниеВыгружаемыхДанных

// .
//
// Параметры:
//   <Параметр1> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//   <Параметр2> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид> - <описание возвращаемого значения>
//
Функция ОписаниеВыгружаемыхДанныхДерево(УчетнаяЗаписьОбмена) Экспорт
	
	// Не обрабатываются ПКО с пустым источником, ПКГС и ПКС с пустыми источниками.
	
	//ДеревоРезультат = Новый ДеревоЗначений;
	//ДеревоРезультат.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная)));
	//ДеревоРезультат.Колонки.Добавить("СвойствоИмяПКО", Новый ОписаниеТипов("строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)));
	
	СоответствиеРезультат = Новый Соответствие;
	СтрокаРезультат = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПравилаКонвертацииОбъектов.ТипИсточника КАК ТипИсточника,
	|	ПравилаКонвертацииОбъектов.Код КАК Код,
	|	ПравилаКонвертацииОбъектов.Ссылка КАК ПКО
	|ПОМЕСТИТЬ втПКО
	|ИЗ
	|	Справочник.ПравилаКонвертацииОбъектов КАК ПравилаКонвертацииОбъектов
	|ГДЕ
	|	ПравилаКонвертацииОбъектов.ЭтоГруппа = ЛОЖЬ
	|	И ПравилаКонвертацииОбъектов.ПометкаУдаления = ЛОЖЬ
	|	И НЕ ПравилаКонвертацииОбъектов.ТипИсточника = """"
	|	И ПравилаКонвертацииОбъектов.Владелец = &УчетнаяЗаписьОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.ТипИсточника КАК ТипИсточника,
	|	вт.Код КАК Код,
	|	вт.ПКО КАК ПКО
	|ИЗ
	|	втПКО КАК вт
	|ИТОГИ
	|	КОЛИЧЕСТВО(Код)
	|ПО
	|	ТипИсточника
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	вт.ПКО КАК ПКО,
	|	ПравилаКонвертацииСвойств.Ссылка КАК ПКС,
	|	ПравилаКонвертацииСвойств.ИмяИсточника КАК ИмяИсточника,
	|	ПравилаКонвертацииСвойств.Поиск КАК Поиск,
	|	ПравилаКонвертацииСвойств.ЭтоГруппа КАК ЭтоГруппа,
	|	ВЫБОР
	|		КОГДА ПравилаКонвертацииСвойств.ЭтоГруппа
	|			ТОГДА """"
	|		ИНАЧЕ ЕСТЬNULL(ПравилаКонвертацииОбъектов.Код, """")
	|	КОНЕЦ КАК СвойствоИмяПКО
	|ИЗ
	|	втПКО КАК вт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаКонвертацииСвойств КАК ПравилаКонвертацииСвойств
	|		ПО вт.ПКО = ПравилаКонвертацииСвойств.Владелец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаКонвертацииОбъектов КАК ПравилаКонвертацииОбъектов
	|		ПО (ПравилаКонвертацииСвойств.ПравилоКонвертации = ПравилаКонвертацииОбъектов.Ссылка)
	|ГДЕ
	|	ПравилаКонвертацииСвойств.Отключить = ЛОЖЬ
	|	И ПравилаКонвертацииСвойств.ПометкаУдаления = ЛОЖЬ
	|	И ПравилаКонвертацииСвойств.ЭтоГруппа = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	вт.ПКО,
	|	ПравилаКонвертацииСвойств.Ссылка,
	|	ПравилаКонвертацииСвойств.ИмяИсточника,
	|	ПравилаКонвертацииСвойств.Поиск,
	|	ПравилаКонвертацииСвойств.ЭтоГруппа,
	|	ВЫБОР
	|		КОГДА ПравилаКонвертацииСвойств.ЭтоГруппа
	|			ТОГДА """"
	|		ИНАЧЕ ЕСТЬNULL(ПравилаКонвертацииОбъектов.Код, """")
	|	КОНЕЦ
	|ИЗ
	|	втПКО КАК вт
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаКонвертацииСвойств КАК ПравилаКонвертацииСвойств
	|		ПО вт.ПКО = ПравилаКонвертацииСвойств.Владелец
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПравилаКонвертацииОбъектов КАК ПравилаКонвертацииОбъектов
	|		ПО (ПравилаКонвертацииСвойств.ПравилоКонвертации = ПравилаКонвертацииОбъектов.Ссылка)
	|ГДЕ
	|	ПравилаКонвертацииСвойств.Отключить = ЛОЖЬ
	|	И ПравилаКонвертацииСвойств.ПометкаУдаления = ЛОЖЬ
	|	И ПравилаКонвертацииСвойств.ЭтоГруппа = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПКО,
	|	ПКС ИЕРАРХИЯ";
	Запрос.УстановитьПараметр("УчетнаяЗаписьОбмена", УчетнаяЗаписьОбмена);
	РезультатПакет = Запрос.ВыполнитьПакет();
	РезультатИсточник = РезультатПакет[1];
	РезультатПКС = РезультатПакет[2];
	ВыборкаПКС = РезультатПКС.Выбрать();
	Если НЕ РезультатИсточник.Пустой() Тогда
		
		ВыборкаТипИсточника = РезультатИсточник.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаТипИсточника.Следующий() Цикл
			
			Если СтрНачинаетсяС(ВыборкаТипИсточника.ТипИсточника, "ПеречислениеСсылка") Тогда
				Продолжить;
			КонецЕсли;
			
			сДанныеПравил = Новый Соответствие;
			ИменаПравил = "";
			
			//СтрокаТипИсточника = ДеревоРезультат.Строки.Добавить();
			//СтрокаТипИсточника.Наименование = ВыборкаТипИсточника.ТипИсточника;
			
			ВыборкаПравила = ВыборкаТипИсточника.Выбрать();
			Пока ВыборкаПравила.Следующий() Цикл
				
				ИмяПравила = СокрЛП(ВыборкаПравила.Код);
				ИменаПравил = ИменаПравил + ?(НЕ ПустаяСтрока(ИменаПравил), ",", "") + ИмяПравила;
				сПравило = Новый Соответствие;
				
				//СтрокаПравило = СтрокаТипИсточника.Строки.Добавить();
				//СтрокаПравило.Наименование = СокрЛП(ВыборкаПравила.Код);
				
				ДобавитьСтрокиПКС(ВыборкаПКС, ВыборкаПравила.ПКО, сПравило);
				
				сДанныеПравил.Вставить(ИмяПравила, сПравило);
				
			КонецЦикла;
			
			сДанныеПравил.Вставить("_ИменаПравил", ИменаПравил);
			
			СоответствиеРезультат.Вставить(ВыборкаТипИсточника.ТипИсточника, сДанныеПравил);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если СоответствиеРезультат.Количество() > 0 Тогда
		
		Попытка
			ЗаписьДж = Новый ЗаписьJSON;
			ЗаписьДж.УстановитьСтроку();
			ЗаписатьJSON(ЗаписьДж, СоответствиеРезультат);
			СтрокаРезультат = ЗаписьДж.Закрыть();
		Исключение
		    //ОписаниеОшибки()
		КонецПопытки;
		
	КонецЕсли;
	
	//Возврат ДеревоРезультат;
	Возврат СтрокаРезультат;
	
КонецФункции // ОписаниеВыгружаемыхДанныхДерево

// .
//
// Параметры:
//   <Параметр1> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//   <Параметр2> - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ДобавитьСтрокиПКС(ВыборкаПКС, ПКО, сПравило)
	
	//СтрокаСвойстваПоиска = СтрокаПКО.Строки.Добавить();
	//СтрокаСвойстваПоиска.Наименование = "_СвойстваПоиска";
	
	сСвойстваПоиска = Новый Структура;
	сПравило.Вставить("_СвойстваПоиска", сСвойстваПоиска);
	
	//СтрокаСвойства = СтрокаПКО.Строки.Добавить();
	//СтрокаСвойства.Наименование = "_Свойства";
	
	сСвойства = Новый Соответствие;
	сПравило.Вставить("_Свойства", сСвойства);
	
	//СтрокаТЧ = СтрокаПКО.Строки.Добавить();
	//СтрокаТЧ.Наименование = "_ТабличныеЧасти";
	
	сТабЧасти = Новый Соответствие;
	сПравило.Вставить("_ТабличныеЧасти", сТабЧасти);
	
	ВыборкаПКС.Сбросить();
	
	Пока ВыборкаПКС.НайтиСледующий(ПКО, "ПКО") Цикл
		
		Если ВыборкаПКС.ПКС = NULL Тогда
			Прервать;
		КонецЕсли;
		
		Если ПустаяСтрока(ВыборкаПКС.ИмяИсточника) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВыборкаПКС.ЭтоГруппа Тогда
			
			сДанныеТЧ = Новый Соответствие;
			
			//стрТЧ = СтрокаТЧ.Строки.Добавить();
			//стрТЧ.Наименование = ВыборкаПКС.ИмяИсточника;
			
			ВыборкаСвойстваТЧ = ВыборкаПКС.Выбрать();
			
			Пока ВыборкаСвойстваТЧ.Следующий() Цикл
				
				Если ПустаяСтрока(ВыборкаСвойстваТЧ.ИмяИсточника) Тогда
					Продолжить;
				КонецЕсли;
				
				//стрСвойствоТЧ = стрТЧ.Строки.Добавить();
				//стрСвойствоТЧ.Наименование = ВыборкаСвойстваТЧ.ИмяИсточника;
				//стрСвойствоТЧ.СвойствоИмяПКО = СокрЛП(ВыборкаСвойстваТЧ.СвойствоИмяПКО);
				
				сДанныеТЧ.Вставить(ВыборкаСвойстваТЧ.ИмяИсточника, СокрЛП(ВыборкаСвойстваТЧ.СвойствоИмяПКО));
				
			КонецЦикла;
			
			сТабЧасти.Вставить(ВыборкаПКС.ИмяИсточника, сДанныеТЧ);
			
		ИначеЕсли ВыборкаПКС.Поиск Тогда
			
			//стрСвойствоПоиска = СтрокаСвойстваПоиска.Строки.Добавить();
			//стрСвойствоПоиска.Наименование = ВыборкаПКС.ИмяИсточника;
			//стрСвойствоПоиска.СвойствоИмяПКО = СокрЛП(ВыборкаПКС.СвойствоИмяПКО);
			
			сСвойстваПоиска.Вставить(ВыборкаПКС.ИмяИсточника, СокрЛП(ВыборкаПКС.СвойствоИмяПКО));
			
		Иначе
			
			//стрСвойство = СтрокаСвойства.Строки.Добавить();
			//стрСвойство.Наименование = ВыборкаПКС.ИмяИсточника;
			//стрСвойство.СвойствоИмяПКО = СокрЛП(ВыборкаПКС.СвойствоИмяПКО);
			
			сСвойства.Вставить(ВыборкаПКС.ИмяИсточника, СокрЛП(ВыборкаПКС.СвойствоИмяПКО));
			
		КонецЕсли;
		
	КонецЦикла;
	
	ВыборкаПКС.Сбросить();
	
КонецПроцедуры //ДобавитьСтрокиПКС


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает текст запроса по имени документа для вставки в СКД.
//
// Параметры:
//   ИмяДокумента - Строка - имя документа вида "Документ.АвансовыйОтчет".
//
// Возвращаемое значение:
//   Строка - текст запроса по всем реквизитам выбранного документа.
//
Функция СформироватьТекстЗапроса(Знач ИмяДокумента) Экспорт
	
	МассивСтрок = СтрРазделить(ИмяДокумента, ".");
	ИмяДок = МассивСтрок[1];
	
	РеквизитыЗапроса = "";
	ОбъектМетаданных = Метаданные.Документы.Найти(ИмяДок);
	
	Для Каждого СтРеквизит Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
		РеквизитыЗапроса = РеквизитыЗапроса + ?(РеквизитыЗапроса = "", "", ", " + Символы.ПС) + " ОБ." + СтРеквизит.Имя + " КАК " + СтРеквизит.Имя;	
	КонецЦикла;
	
	Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
		РеквизитыЗапроса =  РеквизитыЗапроса + ?(РеквизитыЗапроса = "", "", ", " + Символы.ПС) + " ОБ." + Реквизит.Имя + " КАК " + Реквизит.Имя;
	КонецЦикла;
	
	Для каждого ТабЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
		
		Если ТабЧасть.Реквизиты.Количество() = 0 Тогда
			Продолжить;	
		КонецЕсли;
		
		СтрТабЧасть = "ОБ." + ТабЧасть.Имя + ".(" + Символы.ПС
		+ "%1" + Символы.ПС + ") КАК " + ТабЧасть.Имя;
		
		РеквизитыТабЧасти = "НомерСтроки КАК НомерСтроки";
		Для Каждого Реквизит Из ТабЧасть.Реквизиты Цикл
			
			РеквизитыТабЧасти = РеквизитыТабЧасти + ", " + Символы.ПС + Реквизит.Имя + " КАК " + Реквизит.Имя;
			
		КонецЦикла;
		
		СТрТабЧасть = СтрШаблон(СТрТабЧасть, РеквизитыТабЧасти);
		РеквизитыЗапроса = РеквизитыЗапроса + ", " + Символы.ПС + СтрТабЧасть;
		
	КонецЦикла;
	
	Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ " + Символы.ПС + РеквизитыЗапроса + Символы.ПС + " ИЗ " + ИмяДокумента + " КАК ОБ "
	+ Символы.ПС + "ГДЕ ОБ.Ссылка = &ПараметрСсылка";
	
	Возврат Текст;
	
КонецФункции

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("НастройкаОбмена");
	
	Возврат Результат;
	
КонецФункции // ПолучитьБлокируемыеРеквизитыОбъекта()

// Заполняет список выгружаемых свойств по правилам конвертаций объектов.
//
// Параметры:
//   ВыборкаСвойств - ВыборкаИзРезультатаЗапроса - Содержит свойства ПКС
//   СсылкаПКО - СправочникСсылка.ПравилаКонвертацииОбъектов - ссылка на ПКО для поиска свойств в выборке.
//   НаборРеквизитов - Соответствие:
//						* Ключ - Строка - имя реквизита в источнике;
//						* Значение - Булево - признак поиска по реквизиту;
//
Процедура ЗаполнитьНаборВыгружаемыхРеквизитов(ВыборкаСвойств, СсылкаПКО, НаборРеквизитов) 
	
	СвойстваПоиска = НаборРеквизитов.Получить("_СвойстваПоиска");
	Если СвойстваПоиска = Неопределено Тогда
		СвойстваПоиска = Новый Массив;
		НаборРеквизитов.Вставить("_СвойстваПоиска", СвойстваПоиска);
	КонецЕсли;
	
	Свойства = НаборРеквизитов.Получить("_Свойства");
	Если Свойства = Неопределено Тогда
		Свойства = Новый Массив;
		НаборРеквизитов.Вставить("_Свойства", Свойства);
	КонецЕсли;
	
	ТабличныеЧасти = НаборРеквизитов.Получить("_ТабличныеЧасти");
	Если ТабличныеЧасти = Неопределено Тогда
		ТабличныеЧасти = Новый Соответствие;
		НаборРеквизитов.Вставить("_ТабличныеЧасти", ТабличныеЧасти);
	КонецЕсли;
	
	Пока ВыборкаСвойств.НайтиСледующий(СсылкаПКО, "Владелец") Цикл
		
		ИмяРеквизита = ВыборкаСвойств.ИмяИсточника;
		
		Если ВыборкаСвойств.ЭтоГруппа Тогда // Заполняем реквизиты ТЧ
			
			ВыборкаРеквизитыТЧ = ВыборкаСвойств.Выбрать();
			
			РеквизитыТЧ = ТабличныеЧасти.Получить(ИмяРеквизита);
			
			Если РеквизитыТЧ = Неопределено Тогда
				
				РеквизитыТЧ = Новый Соответствие;
				
			КонецЕсли;
			
			Пока ВыборкаРеквизитыТЧ.Следующий() Цикл
				
				РеквизитыТЧ.Вставить(ВыборкаРеквизитыТЧ.ИмяИсточника, Ложь);
				
			КонецЦикла;
			
			ТабличныеЧасти.Вставить(ИмяРеквизита, РеквизитыТЧ);
			
		Иначе
			
			Если ВыборкаСвойств.Поиск Тогда
				
				индПоиск = СвойстваПоиска.Найти(ИмяРеквизита);
				Если индПоиск = Неопределено Тогда
					СвойстваПоиска.Добавить(ИмяРеквизита);
				КонецЕсли;
				
				индСвойство = Свойства.Найти(ИмяРеквизита);
				Если индСвойство <> Неопределено Тогда
					Свойства.Удалить(индСвойство);
				КонецЕсли;
				
			Иначе
				
				индСвойство = Свойства.Найти(ИмяРеквизита);
				Если индСвойство = Неопределено Тогда
					Свойства.Добавить(ИмяРеквизита);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ВыборкаСвойств.Сбросить();
	
КонецПроцедуры //ЗаполнитьНаборВыгружаемыхРеквизитов

#КонецОбласти
