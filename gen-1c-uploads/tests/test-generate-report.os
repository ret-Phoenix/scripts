#Использовать ".."
#Использовать asserts

Перем юТест;
Перем Форма;

Процедура Инициализация()
	
КонецПроцедуры

Функция ПолучитьСписокТестов(Тестирование) Экспорт

	юТест = Тестирование;

	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("Тест_Должен_ПолучитьШапкуОтчета");

	Возврат СписокТестов;

КонецФункции

Процедура Тест_Должен_ПолучитьШапкуОтчета() Экспорт
    
    Генератор = Новый ГенераторXMLФайлов();
	Генератор.СоздатьФайлыПоПравилам("fixtures\test2.json");

КонецПроцедуры 

//////////////////////////////////////////////////////////////////////////////////////
// Инициализация

Инициализация();
