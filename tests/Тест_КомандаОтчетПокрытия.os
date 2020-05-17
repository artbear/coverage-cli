#Использовать fs
#Использовать cli
#Использовать asserts
#Использовать "../internal/cmd"

Перем Тестер;
Перем КаталогСборки;

#Область ОбработчикиСобытий

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт
	
	Тестер = Тестирование;
	
	ИменаТестов = Новый Массив;
	ИменаТестов.Добавить("ТестДолжен_ОбъединитьДанныеПокрытия");
	
	Возврат ИменаТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	КаталогСборки = Тестер.ИмяВременногоФайла();
	ФС.ОбеспечитьПустойКаталог(КаталогСборки);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	Тестер.УдалитьВременныеФайлы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТестов

Процедура ТестДолжен_ОбъединитьДанныеПокрытия() Экспорт

	// конвертируем данные покрытия
	ИмяФайлаРезультатов     = ОбъединитьПути(КаталогСборки, "genericCoverage.xml");
	ИмяФайлаРезультатовXML  = ОбъединитьПути(КаталогСборки, "coverage.xml");
	ИмяФайлаРезультатовJSON = ОбъединитьПути(КаталогСборки, "coverage.json");

	КонвертерJSON = Новый Конвертер(КаталогТестовыхДанных());
	КонвертерJSON.УстановитьФайлПокрытия(ФайлПокрытия());
	КонвертерJSON.УстановитьФайлВывода(ИмяФайлаРезультатовJSON);
	КонвертерJSON.ИспользоватьВнутреннийФормат();
	КонвертерJSON.ДобавитьИсходныеФайлыРасширения("Расширение1", "src/cfe/edt", ФорматыИсходныхФайлов.EDT);
	КонвертерJSON.РазобратьПокрытие();

	КонвертерXML = Новый Конвертер(КаталогТестовыхДанных());
	КонвертерXML.УстановитьФайлПокрытия(ФайлПокрытия());
	КонвертерXML.УстановитьФайлВывода(ИмяФайлаРезультатовXML);
	КонвертерXML.ДобавитьИсходныеФайлыВнешнегоМодуля(ИмяФайлаВнешнегоМодуля(), "src/epf/xml", ФорматыИсходныхФайлов.XML);
	КонвертерXML.РазобратьПокрытие();

	Аргументы = Новый Массив;
	ДобавитьАргументInput(Аргументы, КаталогСборки);
	ДобавитьАргументOutput(Аргументы, ИмяФайлаРезультатов);
	
	ВыполнитьКоманду(Аргументы);
	
	Утверждения.ПроверитьИстину(
	 	ФС.ФайлСуществует(ИмяФайлаРезультатов),
	 	"Файл с результатами должен существовать");
	
	ДанныеПокрытия = Новый ПокрытиеGenericCoverage;
	ДанныеПокрытия.Прочитать(ИмяФайлаРезультатов);

	ПрограммныеМодули = ДанныеПокрытия.ПрограммныеМодули();
	Утверждения.ПроверитьРавенство(ПрограммныеМодули.Количество(), 4,
		"Проверка количества модулей для покрытия");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КаталогТестовыхДанных()
	Возврат ОбъединитьПути("tests", "testdata");
КонецФункции

Функция ФайлПокрытия()
	Возврат ОбъединитьПути(КаталогТестовыхДанных(), "coverage.csv");
КонецФункции

Функция ИмяФайлаВнешнегоМодуля()
	Возврат "file://ВнешняяОбработка1.epf";
КонецФункции

Процедура ДобавитьАргументInput(Аргументы, Значение)
	
	Аргументы.Добавить("--input");
	Аргументы.Добавить(Значение);
	
КонецПроцедуры

Процедура ДобавитьАргументOutput(Аргументы, Значение)
	
	Аргументы.Добавить("--output");
	Аргументы.Добавить(Значение);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Аргументы)
	
	Команда = Новый КомандаПриложения("testapp", "Тестовое приложения", Новый КомандаОтчетПокрытия());
	Команда.Опция("d debug", Ложь, "Режим отладки").ТБулево();
	Команда.НачалоЗапуска();
	Команда.Запуск(Аргументы);
	
КонецПроцедуры

#КонецОбласти
