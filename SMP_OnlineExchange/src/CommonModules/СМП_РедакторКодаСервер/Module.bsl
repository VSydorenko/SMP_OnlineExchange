
Функция ПолучитьМакетыРедактора() Экспорт
	
	НаборМакетов = Новый Соответствие;
	НаборМакетов.Вставить("style1c.css",Обработки.СМП_РедакторКода.ПолучитьМакет("РедакторКодаCss"));
	НаборМакетов.Вставить("lib1c.js",Обработки.СМП_РедакторКода.ПолучитьМакет("РедакторКодаLib"));
	НаборМакетов.Вставить("mode1c.js",Обработки.СМП_РедакторКода.ПолучитьМакет("РедакторКодаMode"));
	НаборМакетов.Вставить("index",Обработки.СМП_РедакторКода.ПолучитьМакет("РедакторКодаIndex"));
	
	Возврат НаборМакетов;
	
КонецФункции
