Перем Форма;
Перем ДанныеСписка;
Перем ПолеПоиска;
Перем СписокВариантов;
Перем СтрДанные;

Процедура ПриИзмененииПолеПоиска() Экспорт

    СтрПоиска = ПолеПоиска.Значение;
    СтрПоиска = СтрЗаменить(СтрПоиска, " ", ".*");
    // @"(.*)(" + textBoxSearchValue.Text.Replace(" ", @".*") + @")(.*)"

    РегВыражение = Новый РегулярноеВыражение("(.*)(" + СтрПоиска + ")(.*)");
    РегВыражение.ИгнорироватьРегистр = Истина;
    РегВыражение.Многострочный = Истина;

    Совпадения = РегВыражение.НайтиСовпадения(СтрДанные);

	// Сообщить("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    ДанныеСписка.Очистить();
    Для каждого Сп Из Совпадения Цикл

        СпГр = Сп.Группы;

        // Сообщить(СокрЛП(СпГр[1].Значение));

        Если СокрЛП(СпГр[1].Значение) <> "" Тогда
            ДанныеСписка.Вставить(СокрЛП(СпГр[0].Значение),СокрЛП(СпГр[1].Значение));
            СписокВариантов.СписокВыбора = ДанныеСписка;
        КонецЕсли;

    КонецЦикла;

КонецПроцедуры

Процедура ПриОткрытииФормы() Экспорт

	СтрДанные = "
    |(4) [Ф] ОбработатьРабочуюОбластьПлатежей
    |(31) [Ф] ОбработатьРабочуюОбласть
    |(70) [Ф] ПолучитьРабочуюОбласть
    |(85) [П] ИмпортДоговоровНаСервере
    |(170) [П] ИмпортДоговоров
    |(176) [П] ЗагрузитьПлатежи
    |(196) [П] ИмпортПлатежей
    |(200) [П] МояПроцедура
    |(210) [П] МояПроцедура2
    |(220) [П] МояПроцедура2выборки1
    |(220) [П] МояПроцедура2выборки2
    |(220) [П] МояПроцедура2выборки3
    |(220) [П] МояПроцедура2выборки4
    |(220) [П] МояПроцедура2выборки5
    |(220) [П] МояПроцедура2выборки6
    |(220) [П] МояПроцедура2выборки7
    |(220) [П] МояПроцедура2выборки8
    |(220) [П] МояПроцедура2выборки9
    |(220) [П] МояПроцедура2выборки10
    |(220) [П] МояПроцедура2выборки11
    |(220) [П] МояПроцедура2выборки12
    |(220) [П] МояПроцедура2выборки13
    |(220) [П] МояПроцедура2выборки14
    |(220) [П] МояПроцедура2выборки15
    |(220) [П] МояПроцедура2выборки16
    |(220) [П] МояПроцедура2выборки17
    |(220) [П] МояПроцедура2выборки18
    |";

    ДанныеСписка = Новый Соответствие;
    ДанныеСписка.Вставить("[Ф] ОбработатьРабочуюОбластьПлатежей", "4");
    // ДанныеСписка.Вставить("[Ф] ОбработатьРабочуюОбласть", "31");
    // ДанныеСписка.Вставить("[Ф] ПолучитьРабочуюОбласть", "70");
    // ДанныеСписка.Вставить("[П] ИмпортДоговоровНаСервере", "85");
    // ДанныеСписка.Вставить("[П] ИмпортДоговоров", "170");
    // ДанныеСписка.Вставить("[П] ЗагрузитьПлатежи", "176");
    // ДанныеСписка.Вставить("[П] ИмпортПлатежей", "196");

    ПолеПоиска = Форма.Элементы.Добавить("ПолеПоиска", "ПолеФормы", Неопределено);
    ПолеПоиска.Вид = Форма.ВидПоляФормы.ПолеВвода;
    ПолеПоиска.УстановитьДействие(ЭтотОбъект, "ПриИзменении", "ПриИзмененииПолеПоиска");
    ПолеПоиска.Заголовок = "";
    ПолеПоиска.Значение = "";
    ПолеПоиска.Закрепление = 1;

    СписокВариантов = Форма.Элементы.Добавить("СписокВариантов", "ПолеФормы", Неопределено);
    СписокВариантов.Вид = Форма.ВидПоляФормы.ПолеСписка;
    СписокВариантов.СписокВыбора = ДанныеСписка;
    // СписокВариантов.Высота = 500;
    СписокВариантов.Закрепление = 5;
    // СписокВариантов.АвтоматическийРазмер = Ложь;
    СписокВариантов.Заголовок = "";
    
    // СписокВариантов.Значение = "1";

КонецПроцедуры

Процедура Конструктор()

    ПодключитьВнешнююКомпоненту("c:\work\GitHub\oscript-simple-gui\releases\oscript-simple-gui.dll");
    Управление = Новый SimpleGUI();
    Форма = Управление.СоздатьФорму();
    Форма.УстановитьДействие(ЭтотОбъект, "ПриОткрытии", "ПриОткрытииФормы");
    Форма.Показать();

КонецПроцедуры

Конструктор();