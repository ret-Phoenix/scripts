
///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс
#Использовать json

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды, "Парсинг *.md для получения структуры конфигурации");
	//Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "Команда");
	
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "md", "Файл описания структуры");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "json", "файл промежуточных правил");
	
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
КонецПроцедуры

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие ключей командной строки и их значений
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды) Экспорт
	// сообщить("вошли в команду");
	Парсер = Новый ПарсерАргументовКоманднойСтроки;
	
	РаспарситьМДФайл(Парсер, ПараметрыКоманды);
	
	// МенеджерКомандПриложения.ЗарегистрироватьКоманды(Парсер);
	
	// Если ПараметрыКоманды["Команда"] = Неопределено Тогда
	// 	ПоказатьВозможныеКоманды(Парсер);
	// Иначе
	// 	РаспарситьМДФайл(Парсер, ПараметрыКоманды);
	// КонецЕсли;
	
	Возврат 0;
	
КонецФункции


Функция ПолучитьТекстИзФайла(ИмяФайла = "")
	ФайлДанных = Новый Файл(ИмяФайла);
	Данные = "";
	Если ФайлДанных.Существует() Тогда
		Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
		Данные = Текст.Прочитать();
		Текст.Закрыть();
		ОсвободитьОбъект(Текст);
	Иначе
		ВызватьИсключение "Файл не найден: " + ИмяФайла;
	КонецЕсли;
	возврат Данные;
КонецФункции


Процедура РаспарситьМДФайл(Знач Парсер, Знач ПараметрыКоманды)
	
	Для каждого Стр Из ПараметрыКоманды Цикл
		Сообщить(Стр.Ключ);
	КонецЦикла;	
	МДФайл = ПараметрыКоманды.Получить("md");
	
	Сообщить("прм: " + МДФайл);
	
	Данные = ПолучитьТекстИзФайла(МДФайл);
	КолСтрок = СтрЧислоСтрок(Данные);
	
	РегВыражениеТипВид = Новый РегулярноеВыражение("(## (.*): (.*))");
	РегВыражениеТипВид.ИгнорироватьРегистр = Истина;
	
	РегПараметрыОбъекта = Новый РегулярноеВыражение("(### (Свойства|Реквизиты|Измерения|Ресурсы|Табличные части|Значения))");

	РегПараметр = Новый РегулярноеВыражение("^(- (.*): (.*))");

	РегСвойстваПараметра = Новый РегулярноеВыражение("(Свойства:)");
	РегПараметрСвойства = Новый РегулярноеВыражение("^(\s).*(- (.*): (.*))");

	РегОпределениеФактаТЧ = Новый РегулярноеВыражение("(### (Табличные части))");

	РегИмяТЧ = Новый РегулярноеВыражение("(#### (.*))");
	// РегИмяТЧ = Новый РегулярноеВыражение("### (Табличные части)\s*(\r\n)*####\s*(Товары)");
	// РегИмяТЧ.Многострочный = Истина;

	МассивОбъектов = Новый Массив;
	
	СледСтрокаИмяТЧ = Ложь;
	ИзначальныйСостав = Неопределено;

	Для А=0 По КолСтрок Цикл
		Стр = СокрП(СтрПолучитьСтроку(Данные, А));
		// Сообщить(Стр);
		
		Совпадения = РегВыражениеТипВид.НайтиСовпадения(Стр);
		Если Совпадения.Количество() > 0 Тогда
			
			СпГр = Совпадения[0].Группы;

			ОбъектМД = Новый Соответствие();
			ОбъектМД.Вставить("ТипДанных", СокрЛП(СпГр[2].Значение));
			ОбъектМД.Вставить("Имя", СокрЛП(СпГр[3].Значение));

			МассивОбъектов.Добавить(ОбъектМД);
			Продолжить;
		КонецЕсли;

		Совпадения = РегПараметрыОбъекта.НайтиСовпадения(Стр);
		Если Совпадения.Количество() > 0 Тогда
			
			СпГр = Совпадения[0].Группы;
			ТипСостава = СокрЛП(СпГр[2].Значение);

			Состав = Новый Массив();

			ОбъектМД.Вставить(ТипСостава, Состав);

			Если ТипСостава = "Табличные части" Тогда
				СледСтрокаИмяТЧ = Истина;
				ИзначальныйСостав = Состав ;
			КонецЕсли;
			// Совпадения = РегИмяТЧ.НайтиСовпадения(Стр);
			// Сообщить("Кол выражений: " + Совпадения.Количество());
			// Если Совпадения.Количество() > 0 Тогда
				

			// 	СпГр = Совпадения[0].Группы;
			// 	ИмяТЧ = СокрЛП(СпГр[2].Значение);

			// 	Состав.Добавить(ИмяТЧ);
			// КонецЕсли;

			Продолжить
			
		КонецЕсли;		

		Совпадения = РегПараметр.НайтиСовпадения(Стр);
		Если Совпадения.Количество() > 0 Тогда
			
			СпГр = Совпадения[0].Группы;

			ЗначениеПараметра = Новый Соответствие();
			ЗначениеПараметра.Вставить("Имя", СпГр[2].Значение);
			ЗначениеПараметра.Вставить("Тип", СпГр[3].Значение);

			Состав.Добавить(ЗначениеПараметра);

			Продолжить
			
		КонецЕсли;		

		Совпадения = РегСвойстваПараметра.НайтиСовпадения(Стр);
		Если Совпадения.Количество() > 0 Тогда

			Продолжить
			
		КонецЕсли;		

		Совпадения = РегПараметрСвойства.НайтиСовпадения(Стр);
		Если Совпадения.Количество() > 0 Тогда
			
			СпГр = Совпадения[0].Группы;
			ЗначениеПараметра.Вставить(СпГр[3].Значение, СпГр[4].Значение);
			Продолжить
			
		КонецЕсли;

		Совпадения = РегИмяТЧ.НайтиСовпадения(Стр);
		
		Если Совпадения.Количество() > 0 Тогда
			Если СледСтрокаИмяТЧ Тогда
				Сообщить("Кол: " + Совпадения.Количество());
				СпГр = Совпадения[0].Группы;

				ОписаниеТЧ = Новый Соответствие();
				РеквизитыТЧ = Новый Массив;

				ОписаниеТЧ.Вставить(СпГр[2].Значение, РеквизитыТЧ);
				Состав = ИзначальныйСостав;
				Состав.Добавить(ОписаниеТЧ);
				Состав = РеквизитыТЧ;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;
	
	ПарсерJSON = Новый ПарсерJSON();
	СтрокаJSON = ПарсерJSON.ЗаписатьJSON(МассивОбъектов,,,,Ложь);
	Сообщить(СтрокаJSON);

КонецПроцедуры


Функция ЗаписатьРезультатВФайл(ИмяФайла, Данные)
    Текст = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8);
    Текст.Записать(Данные);
    Текст.Закрыть();
КонецФункции // ЗаписатьРезультатВФайл(ИмяФайла,Данные)