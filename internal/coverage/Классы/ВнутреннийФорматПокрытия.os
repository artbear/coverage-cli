Перем ДанныеПокрытия;
Перем ОписаниеТиповЧисло;

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДобавитьПокрытие(ПрограммныйМодуль, СтрокаПокрытия) Экспорт
	
	ДанныеПокрытияМодуля = ДанныеПокрытия.Получить(ПрограммныйМодуль.Идентификатор);
	Если ДанныеПокрытияМодуля = Неопределено Тогда
		
		ДанныеПокрытияМодуля = НовыйДанныеПокрытияМодуля();
		ДанныеПокрытияМодуля.ModuleId = ПрограммныйМодуль.Идентификатор;
		ДанныеПокрытияМодуля.SourcePath = ПрограммныйМодуль.Путь;
		ДанныеПокрытияМодуля.ObjectId = СтрокаПокрытия.ObjectId;
		ДанныеПокрытияМодуля.PropertyId = СтрокаПокрытия.PropertyId;
		ДанныеПокрытияМодуля.ModuleName = СтрокаПокрытия.ModuleName;
		ДанныеПокрытияМодуля.ExtentionName = СтрокаПокрытия.ExtentionName;
		ДанныеПокрытияМодуля.URL = СтрокаПокрытия.URL;
		
		ДанныеПокрытия.Вставить(ПрограммныйМодуль.Идентификатор, ДанныеПокрытияМодуля);
		
	КонецЕсли;
	
	ДанныеПокрытияМодуля.LineNo.Вставить(СтрокаПокрытия.LineNo, Истина);
	
КонецПроцедуры

Функция ДанныеПокрытияМодулей() Экспорт
	Возврат ДанныеПокрытия;
КонецФункции

Процедура ДополнитьGenericCoverage(ОтчетGenericCoverage) Экспорт
	
	Для Каждого ДанныеПокрытияМодуля Из ДанныеПокрытия Цикл
		
		ИмяМодуля = ДанныеПокрытияМодуля.Ключ;
		
		Для Каждого ДанныеПокрытияСтроки Из ДанныеПокрытияМодуля.Значение.LineNo Цикл
		
			НомерСтроки = ОписаниеТиповЧисло.ПривестиЗначение(ДанныеПокрытияСтроки.Ключ);
			ПокрытиеСтроки = ДанныеПокрытияСтроки.Значение;
			ОтчетGenericCoverage.УстановитьПокрытиеСтроки(ИмяМодуля, НомерСтроки, ПокрытиеСтроки);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура Прочитать(ФайлПокрытия) Экспорт
	
	ДанныеПокрытия = Новый Соответствие;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.ОткрытьФайл(ФайлПокрытия, КодировкаТекста.UTF8);
	ЧтениеJSON.Прочитать();
	
	Пока ЧтениеJSON.Прочитать() И ЧтениеJSON.ТипТекущегоЗначения = ТипЗначенияJSON.НачалоОбъекта Цикл
		
		ДанныеПокрытияМодуля = ПрочитатьJSON(ЧтениеJSON);
		
		НомераСтрок = Новый Соответствие;
		Для Каждого СтрокаПокрытия Из ДанныеПокрытияМодуля.LineNo Цикл
			НомераСтрок.Вставить(СтрокаПокрытия.lineNumber, СтрокаПокрытия.covered);
		КонецЦикла;
		ДанныеПокрытияМодуля.LineNo = НомераСтрок;
		
		ДанныеПокрытия.Вставить(ДанныеПокрытияМодуля.SourcePath, ДанныеПокрытияМодуля);
		
	КонецЦикла;
	
	ЧтениеJSON.Закрыть();
	
КонецПроцедуры

Процедура Записать(ФайлПокрытия) Экспорт
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(ФайлПокрытия);
	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	Для каждого КлючИЗначение Из ДанныеПокрытия Цикл
		
		ДанныеПокрытияМодуля = КлючИЗначение.Значение;
		НомераСтрок = Новый Массив;
		Для Каждого КлючИЗначениеНомерСтроки Из ДанныеПокрытияМодуля.LineNo Цикл
			
			СтрокаПокрытия = Новый Структура;
			СтрокаПокрытия.Вставить("lineNumber", КлючИЗначениеНомерСтроки.Ключ);
			СтрокаПокрытия.Вставить("covered", КлючИЗначениеНомерСтроки.Значение);
			
			НомераСтрок.Добавить(СтрокаПокрытия);
			
		КонецЦикла;
		ДанныеПокрытияМодуля.LineNo = НомераСтрок;
		
		ЗаписатьJSON(ЗаписьJSON, КлючИЗначение.Значение);
		
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецМассива();
	ЗаписьJSON.Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриСозданииОбъекта() Экспорт
	ДанныеПокрытия = Новый Соответствие;
	ОписаниеТиповЧисло = Новый ОписаниеТипов("Число");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйДанныеПокрытияМодуля()
	
	ДанныеПокрытияМодуля = Новый Структура;
	ДанныеПокрытияМодуля.Вставить("ModuleId", "");
	ДанныеПокрытияМодуля.Вставить("SourcePath", "");
	ДанныеПокрытияМодуля.Вставить("ObjectId", "");
	ДанныеПокрытияМодуля.Вставить("PropertyId", "");
	ДанныеПокрытияМодуля.Вставить("ModuleName", "");
	ДанныеПокрытияМодуля.Вставить("ExtentionName", "");
	ДанныеПокрытияМодуля.Вставить("URL", "");
	ДанныеПокрытияМодуля.Вставить("LineNo", Новый Соответствие);
	
	Возврат ДанныеПокрытияМодуля;
	
КонецФункции

#КонецОбласти
