#Использовать json

Перем мИгнорировать;
Перем мОбъект;
Перем мИспользовованныеУИД;

Процедура Конструктор() Экспорт

    мИспользовованныеУИД = Новый Массив;

    мИгнорировать = Новый Массив;
    мИгнорировать.Добавить("Реквизиты");
    мИгнорировать.Добавить("Значения");
    мИгнорировать.Добавить("ТабличныеЧасти");
    мИгнорировать.Добавить("Ресурсы");
    мИгнорировать.Добавить("Измерения");
    мИгнорировать.Добавить("ТипМетаданных");
    мИгнорировать.Добавить("ПризнакиУчета");
    мИгнорировать.Добавить("ПризнакиУчетаСубконто");
    мИгнорировать.Добавить("Адресация");

КонецПроцедуры

Процедура ОбеспечитьКаталог(Знач Каталог)

	Файл = Новый Файл(Каталог);
	Если Не Файл.Существует() Тогда
		СоздатьКаталог(Каталог);
	ИначеЕсли Не Файл.ЭтоКаталог() Тогда
		ВызватьИсключение "Каталог " + Каталог + " не является каталогом";
	КонецЕсли;

КонецПроцедуры

Функция ЗаписатьРезультатВФайл(ИмяФайла, Данные)
    Текст = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8);
    Текст.Записать(Данные);
    Текст.Закрыть();
КонецФункции // ЗаписатьРезультатВФайл(ИмяФайла,Данные)

Функция ПолучитьТекстИзФайла(ИмяФайла = "")
    ФайлОбмена = Новый Файл(ИмяФайла);
    Данные = "";
    Если ФайлОбмена.Существует() Тогда
        Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
        Данные = Текст.Прочитать();
        Текст.Закрыть();
    Иначе
        ВызватьИсключение "Файл не найден: " + ИмяФайла;
    КонецЕсли;
    возврат Данные;
КонецФункции

Функция ПолучитьУИД()
    
    НовыйУИД = Новый УникальныйИдентификатор;

	Если мИспользовованныеУИД.Найти(НовыйУИД) = Неопределено Тогда
        Возврат НовыйУИД;
    Иначе
        Пока НЕ мИспользовованныеУИД.Найти(НовыйУИД) = Неопределено Цикл
            НовыйУИД = Новый УникальныйИдентификатор;
        КонецЦикла;
        Возврат НовыйУИД;
    КонецЕсли;

КонецФункции // ПолучитьУИД()

Функция ПолучитьОписаниеТипа(ТипСтр)
    
    Если СтрНайти(ТипСтр,".") > 0 Тогда
        ТипМ = СтрРазделить(ТипСтр, ".");
        Результат = "
        |<v8:Type>cfg:" + СвойстваМетаданных.КартаТипов[ТипМ[0]] + "." + ТипМ[1] + "</v8:Type>
        |";
    Иначе
        Если СвойстваМетаданных.КартаТипов.Свойство(ТипСтр) Тогда
            Результат = "
            |<v8:TypeSet>cfg:" + СвойстваМетаданных.КартаТипов[ТипСтр] + "</v8:TypeSet>
            |";
        Иначе
            Квалификатор = "";
            Если ТипСтр = "Булево" Тогда
                Результат = "<v8:Type>xs:boolean</v8:Type>
                |";
            ИначеЕсли СтрНачинаетсяС(ТипСтр, "Число") Тогда
                Результат = "<v8:Type>xs:decimal</v8:Type>
                |";
                ТипМ = СтрРазделить(ТипСтр, " ", Ложь);
                Если ТипМ.Количество() > 1 Тогда
                    Квалификатор  = Квалификатор  + "
                    |<v8:NumberQualifiers>
                    |   <v8:Digits>" + ТипМ[1] + "</v8:Digits>
                    |	<v8:FractionDigits>" + ТипМ[2] + "</v8:FractionDigits>
                    |</v8:NumberQualifiers>
                    |";
                КонецЕсли;
            ИначеЕсли СтрНачинаетсяС(ТипСтр, "Строка") Тогда
                Результат = "<v8:Type>xs:string</v8:Type>
                |";
                ТипМ = СтрРазделить(ТипСтр, " ", Ложь);
                Если ТипМ.Количество() > 1 Тогда
                    Квалификатор  = Квалификатор  + "
                    |<v8:StringQualifiers>
                    |   <v8:Length>" + ТипМ[1] + "</v8:Length>
                    |	<v8:AllowedLength>Variable</v8:AllowedLength>
                    |</v8:StringQualifiers>
                    |";
                КонецЕсли;
            ИначеЕсли ТипСтр = "Дата" Тогда
                Результат = "<v8:Type>xs:dateTime</v8:Type>
                |";
            ИначеЕсли ТипСтр = "ГУИД" Тогда
                Результат = "<v8:Type>v8:UUID</v8:Type>
                |";
            КонецЕсли;
        КонецЕсли
    КонецЕсли;
    
    Возврат Результат + Квалификатор; 
    
КонецФункции

Функция РаспарситьШаблон(Параметры)
    
    ДанныеШаблона = "";
    Для каждого Стр Из Параметры Цикл
        
        Если НЕ мИгнорировать.Найти(Стр.Ключ) = Неопределено Тогда
            Продолжить;
        КонецЕсли;
        
        ЗначениеКлюча = Стр.Значение;
        
        Если Стр.Ключ = "Синоним" Тогда
            ЗначениеКлюча = "
            |	<v8:item>
            |		<v8:lang>ru</v8:lang>
            |		<v8:content>" + Стр.Значение + "</v8:content>
            |	</v8:item>
            |";
        КонецЕсли;
        
        
        Если Стр.Ключ = "МинимальноеЗначение" Тогда
            ЗначениеКлюча = "
            |	<MinValue xsi:type=""xs:string"">" + Стр.Значение + "</MinValue>
            |";
            ДанныеШаблона  = ДанныеШаблона  + ЗначениеКлюча;
            Продолжить
            
        КонецЕсли;
        
        Если Стр.Ключ = "МаксимальноеЗначение" Тогда
            ЗначениеКлюча = "
            |	<MaxValue xsi:type=""xs:string"">" + Стр.Значение + "</MaxValue>
            |";
            ДанныеШаблона  = ДанныеШаблона  + ЗначениеКлюча;
            Продолжить
            
        КонецЕсли;
        
        Если Стр.Ключ = "ПроверкаЗаполнения" Тогда
            ЗначениеКлюча = ?(Стр.Значение=Истина,"ShowError","DontCheck");
        КонецЕсли;
        
        Если (Стр.Ключ = "Тип") Тогда
            ТипыРеквизита = СтрРазделить(ЗначениеКлюча,",", Ложь);
            
            ЗначениеКлюча = "";
            Если ТипыРеквизита.Количество() > 0 Тогда
                
                Для каждого ЭлементТип Из ТипыРеквизита Цикл
                    
                    СтрЭлементТип = СокрЛП(ЭлементТип);
                    СтрЭлементТипы = СтрРазделить(СтрЭлементТип," ", Ложь);
                    ЗначениеКлюча  = ЗначениеКлюча  + ПолучитьОписаниеТипа(СтрЭлементТип);
                КонецЦикла;
            КонецЕсли;
        КонецЕсли;
        
        Если 
            (Стр.Ключ = "Задача")
            ИЛИ (Стр.Ключ = "ПланВидовРасчета")
        Тогда
            ТипМ = СтрРазделить(ЗначениеКлюча, ".");
            ЗначениеКлюча = "" + СвойстваМетаданных.КартаТипов[ТипМ[0]] + "." + ТипМ[1];
        КонецЕсли;
        
        Если Стр.Ключ = "Состав" Тогда
			ЗначениеКлюча = ПолучитьСостав(мОбъект["Состав"], "Content");            
        КонецЕсли;
        
        ДанныеШаблона  = ДанныеШаблона  + "
        |		<%Ключ%>%Значение%</%Ключ%>
        |";
        
        ДанныеШаблона = СтрЗаменить(ДанныеШаблона,"%Ключ%", СвойстваМетаданных.Карта[Стр.Ключ]);
        ДанныеШаблона = СтрЗаменить(ДанныеШаблона,"%Значение%", ЗначениеКлюча);
    КонецЦикла;
    
    Возврат ДанныеШаблона;
    
КонецФункции // РаспарситьШаблон(ФайлШаблона, Параметры)

Функция ПолучитьШапку(Параметры)
    
    Возврат "<Properties>" + РаспарситьШаблон(Параметры) + "</Properties>";
    
КонецФункции // ИмяФункции()

Функция ПолучитьРеквизиты(Параметры, ИмяТега = "Attribute")
    
    Реквизиты = "";
    Для каждого Реквизит Из Параметры Цикл
        
        Реквизиты  = Реквизиты  + "
        |<" + ИмяТега + " uuid=""" + ПолучитьУИД() + """>
        |	<Properties>";
        
        Реквизиты = Реквизиты + РаспарситьШаблон(Реквизит);
        
        Реквизиты  = Реквизиты  + "
        |	</Properties>
        |</" + ИмяТега + ">";
        
    КонецЦикла;
    
    Возврат Реквизиты;
    
КонецФункции // ПолучитьРеквизиты()

// Для ОбщихРеквизитов
Функция ПолучитьСостав(Параметры, Тег)
    Реквизиты  = "";

    Для каждого Реквизит Из Параметры Цикл
        
        ТипМ = СтрРазделить(Реквизит, ".");
		ТипМД = СвойстваМетаданных.КартаДляСостава[ТипМ[0]] + "." + ТипМ[1];

        Реквизиты  = Реквизиты  + "
        |				<xr:Item>
        |					<xr:Metadata>" + ТипМД + "</xr:Metadata>
        |					<xr:Use>Use</xr:Use>
        |					<xr:ConditionalSeparation/>
        |				</xr:Item>
        |";

    КонецЦикла;

    Возврат Реквизиты;
    
КонецФункции // ПолучитьРеквизиты()

Функция ГенерируемыйТип(Имя, ТипПолный, ТипКраткий, ЮИД1 = Неопределено, ЮИД2 = Неопределено)
    
    ЮИД1 = ?(ЮИД1 = Неопределено, ПолучитьУИД(), ЮИД1);
    ЮИД2 = ?(ЮИД2 = Неопределено, ПолучитьУИД(), ЮИД2);
    
    Стр = "
    |			<xr:GeneratedType name=""" + ТипПолный + "." + Имя + """ category=""" + ТипКраткий + """>
    |				<xr:TypeId>" + ЮИД1 + "</xr:TypeId>
    |				<xr:ValueId>" + ЮИД2 + "</xr:ValueId>
    |			</xr:GeneratedType>
    |";
    Возврат Стр;
    
КонецФункции

Функция ПолучитьЗаголовки(Параметры)
    
    Результат = Новый Структура;
    СтрНачало = "<?xml version=""1.0"" encoding=""UTF-8""?>
    |<MetaDataObject xmlns=""http://v8.1c.ru/8.3/MDClasses"" 
    | xmlns:app=""http://v8.1c.ru/8.2/managed-application/core"" 
    | xmlns:cfg=""http://v8.1c.ru/8.1/data/enterprise/current-config""
    | xmlns:cmi=""http://v8.1c.ru/8.2/managed-application/cmi"" 
    | xmlns:ent=""http://v8.1c.ru/8.1/data/enterprise"" 
    | xmlns:lf=""http://v8.1c.ru/8.2/managed-application/logform"" 
    | xmlns:style=""http://v8.1c.ru/8.1/data/ui/style"" 
    | xmlns:sys=""http://v8.1c.ru/8.1/data/ui/fonts/system"" 
    | xmlns:v8=""http://v8.1c.ru/8.1/data/core"" 
    | xmlns:v8ui=""http://v8.1c.ru/8.1/data/ui"" 
    | xmlns:web=""http://v8.1c.ru/8.1/data/ui/colors/web"" 
    | xmlns:win=""http://v8.1c.ru/8.1/data/ui/colors/windows"" 
    | xmlns:xen=""http://v8.1c.ru/8.3/xcf/enums"" 
    | xmlns:xpr=""http://v8.1c.ru/8.3/xcf/predef"" 
    | xmlns:xr=""http://v8.1c.ru/8.3/xcf/readable"" 
    | xmlns:xs=""http://www.w3.org/2001/XMLSchema"" 
    | xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" version=""2.1"">
    |";
    СтрКонец = "";
    
    Если Параметры["ТипМетаданных"] = "ВнешнийОтчет" Тогда
        
        СтрНачало  = СтрНачало  + "	
        |<ExternalReport uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ExternalReportObject", "Object")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</ExternalReport>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Справочник" Тогда
        СтрНачало  = СтрНачало  + "
        |<Catalog uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "CatalogObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CatalogRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CatalogSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CatalogList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CatalogManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Catalog>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Документ" Тогда
        СтрНачало  = СтрНачало  + "
        |<Document uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "DocumentObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DocumentRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DocumentSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DocumentList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DocumentManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Document>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Перечисление" Тогда
        СтрНачало  = СтрНачало  + "
        |<Enum uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "EnumRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "EnumList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "EnumManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Enum>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Константа" Тогда
        СтрНачало  = СтрНачало  + "
        |<Constant uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ConstantManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ConstantValueManager", "ValueManager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Constant>";
    ИначеЕсли Параметры["ТипМетаданных"] = "ОпределяемыйТип" Тогда
        СтрНачало  = СтрНачало  + "
        |<DefinedType uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "DefinedType", "DefinedType")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</DefinedType>";
    ИначеЕсли Параметры["ТипМетаданных"] = "РегистрБухгалтерии" Тогда
        СтрНачало  = СтрНачало  + "
        |<AccountingRegister uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterRecord", "Record")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterExtDimensions", "ExtDimensions")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterRecordSet", "RecordSet")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterRecordKey", "RecordKey")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccountingRegisterManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</AccountingRegister>";
    ИначеЕсли Параметры["ТипМетаданных"] = "РегистрНакопления" Тогда
        СтрНачало  = СтрНачало  + "
        |<AccumulationRegister uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterRecord", "Record")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterRecordSet", "RecordSet")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "AccumulationRegisterRecordKey", "RecordKey")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</AccumulationRegister>";
    ИначеЕсли Параметры["ТипМетаданных"] = "РегистрРасчета" Тогда
        СтрНачало  = СтрНачало  + "
        |<CalculationRegister uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterRecord", "Record")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterRecordSet", "RecordSet")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "CalculationRegisterRecordKey", "RecordKey")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "RecalculationsManager", "Recalcs")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</CalculationRegister>";
    ИначеЕсли Параметры["ТипМетаданных"] = "РегистрСведений" Тогда
        СтрНачало  = СтрНачало  + "
        |<InformationRegister uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterRecord", "Record")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterRecordSet", "RecordSet")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterRecordKey", "RecordKey")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "InformationRegisterRecordManager", "RecordManager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</InformationRegister>";
    ИначеЕсли Параметры["ТипМетаданных"] = "БизнесПроцесс" Тогда
        СтрНачало  = СтрНачало  + "
        |<BusinessProcess uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BusinessProcessRoutePointRef", "RoutePointRef")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</BusinessProcess>";
    ИначеЕсли Параметры["ТипМетаданных"] = "ПланСчетов" Тогда
        СтрНачало  = СтрНачало  + "
        |<ChartOfAccounts uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsExtDimensionTypes", "ExtDimensionTypes")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfAccountsExtDimensionTypesRow", "ExtDimensionTypesRow")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</ChartOfAccounts>";
    ИначеЕсли Параметры["ТипМетаданных"] = "ПланВидовРасчета" Тогда
        СтрНачало  = СтрНачало  + "
        |<ChartOfCalculationTypes uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCalculationTypesObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCalculationTypesRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCalculationTypesSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCalculationTypesList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCalculationTypesManager", "Manager")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DisplacingCalculationTypes", "DisplacingCalculationTypes")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DisplacingCalculationTypesRow", "DisplacingCalculationTypesRow")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BaseCalculationTypes", "BaseCalculationTypes")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "BaseCalculationTypesRow", "BaseCalculationTypesRow")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "LeadingCalculationTypes", "LeadingCalculationTypes")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "LeadingCalculationTypesRow", "LeadingCalculationTypesRow")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</ChartOfCalculationTypes>";
    ИначеЕсли Параметры["ТипМетаданных"] = "ПланВидовХарактеристик" Тогда
        СтрНачало  = СтрНачало  + "
        |<ChartOfCharacteristicTypes uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCharacteristicTypesObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCharacteristicTypesRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCharacteristicTypesSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCharacteristicTypesList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "Characteristic", "Characteristic")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ChartOfCharacteristicTypesManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</ChartOfCharacteristicTypes>";
    ИначеЕсли Параметры["ТипМетаданных"] = "ОбщийРеквизит" Тогда
        СтрНачало  = СтрНачало  + "
        |<CommonAttribute uuid=""" + ПолучитьУИД() + """>
        |";
        
        СтрКонец = "
        |</CommonAttribute>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Обработка" Тогда
        СтрНачало  = СтрНачало  + "
        |<DataProcessor uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "DataProcessorObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "DataProcessorManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</DataProcessor>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Отчет" Тогда
        СтрНачало  = СтрНачало  + "
        |<Report uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "ReportObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "ReportManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Report>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Задача" Тогда
        СтрНачало  = СтрНачало  + "
        |<Task uuid=""" + ПолучитьУИД() + """>
        |		<InternalInfo>
        |" + ГенерируемыйТип(Параметры["Имя"], "TaskObject", "Object")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "TaskRef", "Ref")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "TaskSelection", "Selection")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "TaskList", "List")  + "
        |" + ГенерируемыйТип(Параметры["Имя"], "TaskManager", "Manager")  + "
        |		</InternalInfo>
        |";
        
        СтрКонец = "
        |</Task>";
    ИначеЕсли Параметры["ТипМетаданных"] = "Роль" Тогда
        СтрНачало  = СтрНачало  + "
        |<Role uuid=""" + ПолучитьУИД() + """>
        |";
        
        СтрКонец = "
        |</Role>";
    КонецЕсли;
    
    СтрКонец  = СтрКонец  + "
    |</MetaDataObject>";
    
    Результат.Вставить("Начало", СтрНачало);
    Результат.Вставить("Конец", СтрКонец);
    
    Возврат Результат;
    
КонецФункции // ПолучитьЗаголовки()

Функция ПолучитьТабличныеЧасти(Параметры, ИмяОбъектаМД="")
    
    Реквизиты = "";
    Для каждого ТабЧасть Из Параметры Цикл
        
        ПолноеИмяТЧ = СокрЛП(ИмяОбъектаМД) + "." + СокрЛП(ТабЧасть["Имя"]);
        
        Реквизиты  = Реквизиты  + "
        |<TabularSection uuid=""" + (Новый УникальныйИдентификатор) + """>
        |				<InternalInfo>
        |					<xr:GeneratedType name=""ReportTabularSection." + ПолноеИмяТЧ + """ category=""TabularSection"">
        |						<xr:TypeId>" + (Новый УникальныйИдентификатор) + "</xr:TypeId>
        |						<xr:ValueId>" + (Новый УникальныйИдентификатор) + "</xr:ValueId>
        |					</xr:GeneratedType>
        |					<xr:GeneratedType name=""ReportTabularSectionRow." + ПолноеИмяТЧ + """ category=""TabularSectionRow"">
        |						<xr:TypeId>" + (Новый УникальныйИдентификатор) + "</xr:TypeId>
        |						<xr:ValueId>" + (Новый УникальныйИдентификатор) + "</xr:ValueId>
        |					</xr:GeneratedType>
        |				</InternalInfo>
        |	<Properties>
        |	
        |";
        
        Реквизиты = Реквизиты + РаспарситьШаблон(ТабЧасть);
        
        Реквизиты  = Реквизиты  + "
        |</Properties>
        |		<ChildObjects>
        |";
        
        Для каждого РеквизитТЧ Из ТабЧасть["Реквизиты"] Цикл
            Реквизиты  = Реквизиты  + "
            |<Attribute uuid=""" + (Новый УникальныйИдентификатор) + """>
            |<Properties>
            |";
            
            Реквизиты = Реквизиты + РаспарситьШаблон(РеквизитТЧ);
            
            Реквизиты  = Реквизиты  + "
            |</Properties>
            |</Attribute>
            |";
            
        КонецЦикла;
        
        Реквизиты  = Реквизиты  + "
        |		</ChildObjects>
        |</TabularSection>";
        
    КонецЦикла;
    
    Возврат Реквизиты;
    
КонецФункции // ПолучитьТабличныеЧасти(Параметры)

Процедура СоздатьФайлыПоПравилам(Объект, ИмяРезультирующегоФайла="") Экспорт
    
    
    мОбъект = Объект; 
    
    ТабЧасти = "";
    Реквизиты = "";
    Измерения = "";
    Ресурсы = "";
    ПризнакУчета = "";
    ПризнакУчетаСубконто = "";
    Состав = "";
    Адресация = "";

    НачалоПодчиненных = "<ChildObjects>";
    КонецПодчиненных = "</ChildObjects>";
    
    Заголовки = ПолучитьЗаголовки(Объект);
    Шапка = ПолучитьШапку(Объект);
    
    Если Объект.Получить("Реквизиты") <> Неопределено Тогда
        Реквизиты = ПолучитьРеквизиты(Объект["Реквизиты"]);
    КонецЕсли;
    
    Если Объект.Получить("Значения") <> Неопределено Тогда
        Реквизиты = ПолучитьРеквизиты(Объект["Значения"], "EnumValue");
    КонецЕсли;
    
    Если Объект.Получить("ТабличныеЧасти") <> Неопределено Тогда
        ТабЧасти = ПолучитьТабличныеЧасти(Объект["ТабличныеЧасти"], Объект["Имя"]);
    КонецЕсли;

    Если Объект.Получить("Адресация") <> Неопределено Тогда
        Адресация = ПолучитьРеквизиты(Объект["Адресация"], "AddressingAttribute");
    КонецЕсли;
    
    Если Объект.Получить("Ресурсы") <> Неопределено Тогда
        Ресурсы = ПолучитьРеквизиты(Объект["Ресурсы"], "Resource");
    КонецЕсли;
    
    Если Объект.Получить("Измерения") <> Неопределено Тогда
        Измерения = ПолучитьРеквизиты(Объект["Измерения"], "Dimension");
    КонецЕсли;

    Если Объект.Получить("ПризнакиУчета") <> Неопределено Тогда
        ПризнакУчета = ПолучитьРеквизиты(Объект["ПризнакиУчета"], "AccountingFlag");
    КонецЕсли;
    
    Если Объект.Получить("ПризнакиУчетаСубконто") <> Неопределено Тогда
        ПризнакУчетаСубконто = ПолучитьРеквизиты(Объект["ПризнакиУчетаСубконто"], "ExtDimensionAccountingFlag");
    КонецЕсли;

    // Если Объект.Получить("Состав") <> Неопределено Тогда
    //     Состав = ПолучитьСостав(Объект["Состав"], "Content");
    // КонецЕсли;



    Если (Объект["ТипМетаданных"] = "Константа") 
        или (Объект["ТипМетаданных"] = "ОбщийРеквизит") 
        или (Объект["ТипМетаданных"] = "ОпределяемыйТип") 
        или (Объект["ТипМетаданных"] = "Роль") 
        Тогда
        НачалоПодчиненных = "";
        КонецПодчиненных = "";
    КонецЕсли;
    
    Результат = Заголовки.Начало 
    	+ Шапка 
        + НачалоПодчиненных 
        + Измерения 
        + Ресурсы 
        + Реквизиты  
        + ПризнакУчета 
        + ПризнакУчетаСубконто
        + ТабЧасти 
        + Адресация
        + Состав 
        + КонецПодчиненных 
        + Заголовки.Конец;
    
    ИмяФайла = ?(ИмяРезультирующегоФайла="", Объект["Имя"], ИмяРезультирующегоФайла);
    
	// ОбеспечитьКаталог(ИмяФайла);

    ЗаписатьРезультатВФайл(ИмяФайла, Результат);
    
КонецПроцедуры

Процедура СоздатьФайлКонфигурации(Каталог, Параметры) Экспорт

	Результат = "<?xml version=""1.0"" encoding=""UTF-8""?>
    |<MetaDataObject
    |	xmlns=""http://v8.1c.ru/8.3/MDClasses""
    |	xmlns:app=""http://v8.1c.ru/8.2/managed-application/core""
    |	xmlns:cfg=""http://v8.1c.ru/8.1/data/enterprise/current-config""
    |   xmlns:cmi=""http://v8.1c.ru/8.2/managed-application/cmi""
    |	xmlns:ent=""http://v8.1c.ru/8.1/data/enterprise""
    |	xmlns:lf=""http://v8.1c.ru/8.2/managed-application/logform""
	|	xmlns:style=""http://v8.1c.ru/8.1/data/ui/style""
	|	xmlns:sys=""http://v8.1c.ru/8.1/data/ui/fonts/system"" 
	|	xmlns:v8=""http://v8.1c.ru/8.1/data/core"" 
	|	xmlns:v8ui=""http://v8.1c.ru/8.1/data/ui"" 
	|	xmlns:web=""http://v8.1c.ru/8.1/data/ui/colors/web"" 
	|	xmlns:win=""http://v8.1c.ru/8.1/data/ui/colors/windows"" 
	|	xmlns:xen=""http://v8.1c.ru/8.3/xcf/enums"" 
	|	xmlns:xpr=""http://v8.1c.ru/8.3/xcf/predef"" 
	|	xmlns:xr=""http://v8.1c.ru/8.3/xcf/readable"" 
	|	xmlns:xs=""http://www.w3.org/2001/XMLSchema"" 
	|	xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" version=""2.1"">
	|	<Configuration uuid=""3dc019df-393f-4789-8a30-592bae5a7e1c"">
    |	<InternalInfo>
    |        			<xr:ContainedObject>
    |                    				<xr:ClassId>9cd510cd-abfc-11d4-9434-004095e12fc7</xr:ClassId>
    |				<xr:ObjectId>b62b9a1a-7a91-4449-9bc5-019219ea3e90</xr:ObjectId>
    |			</xr:ContainedObject>
    |			<xr:ContainedObject>
    |				<xr:ClassId>9fcd25a0-4822-11d4-9414-008048da11f9</xr:ClassId>
    |				<xr:ObjectId>9a0deabd-62ae-4fe3-9fe5-2040f5c0ab45</xr:ObjectId>
    |			</xr:ContainedObject>
    |			<xr:ContainedObject>
    |				<xr:ClassId>e3687481-0a87-462c-a166-9f34594f9bba</xr:ClassId>
    |				<xr:ObjectId>38cf4b49-c3c4-40ac-a59d-17e8030028a1</xr:ObjectId>
    |			</xr:ContainedObject>
    |			<xr:ContainedObject>
    |				<xr:ClassId>9de14907-ec23-4a07-96f0-85521cb6b53b</xr:ClassId>
    |				<xr:ObjectId>e02eaf2c-2166-4bc3-8314-0e119f8dff6c</xr:ObjectId>
    |			</xr:ContainedObject>
    |			<xr:ContainedObject>
    |				<xr:ClassId>51f2d5d8-ea4d-4064-8892-82951750031e</xr:ClassId>
    |				<xr:ObjectId>687cc561-3f01-4901-a71b-044e89721ec1</xr:ObjectId>
    |			</xr:ContainedObject>
    |			<xr:ContainedObject>
    |				<xr:ClassId>e68182ea-4237-4383-967f-90c1e3370bc7</xr:ClassId>
    |				<xr:ObjectId>e1e5e16d-81a3-4fdf-ac8e-74caeaabf2c9</xr:ObjectId>
    |			</xr:ContainedObject>
    |		</InternalInfo>	
    |<Properties>
    |";
    
    Для каждого Стр Из Параметры["Свойства"] Цикл
        Результат  = Результат  + РаспарситьШаблон(Стр);
    КонецЦикла;
    Результат  = Результат  + "</Properties>";

    Результат  = Результат  + "<ChildObjects>";

	Для каждого Стр Из Параметры["Состав"] Цикл
        Результат  = Результат  + "<" + СвойстваМетаданных.КартаДляСостава[Стр["ТипМетаданных"]] + ">"
        + Стр["Имя"]
        + "</" + СвойстваМетаданных.КартаДляСостава[Стр["ТипМетаданных"]] + ">"
    КонецЦикла;

    Результат  = Результат  + "</ChildObjects>";
    Результат  = Результат  + "
    |</Configuration>
    |</MetaDataObject>";

	ОбеспечитьКаталог(Каталог);

    ЗаписатьРезультатВФайл(ОбъединитьПути(Каталог,"Configuration.xml"),Результат);

КонецПроцедуры