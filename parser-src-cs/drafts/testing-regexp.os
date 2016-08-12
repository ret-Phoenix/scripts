Процедура ВыполнитьРегулярку(ИсходнаяСтрока,ТекстРегулярки)
    Сообщить("-----------------------------");
    РегВыражение = Новый РегулярноеВыражение(ТекстРегулярки);
    РегВыражение.ИгнорироватьРегистр = Истина;
    РегВыражение.Многострочный = Истина;
    Совпадения = РегВыражение.НайтиСовпадения(ИсходнаяСтрока);

    Для каждого Сп Из Совпадения Цикл

        СпГр = Сп.Группы;

        Для А = 0 По 20 Цикл
            Если СокрЛ(СокрЛП(СпГр[А].Значение)) <> "" Тогда
                Сообщить("" + А + ": " + СокрЛП(СпГр[А].Значение));
            КонецЕсли;
        КонецЦикла;
    КонецЦикла;
КонецПроцедуры
//-------------------
// ИсходнаяСтрока = "<returns>Неопределено</returns>";
// ТекстРегулярки = "\<returns\>(.*)\<\/returns\>";
// ВыполнитьРегулярку(ИсходнаяСтрока, ТекстРегулярки);

ИсходнаяСтрока = "<param name=""typeName"">Имя типа, которое будет иметь новый класс. Экземпляры класса создаются оператором Новый.
|<example>ПодключитьСценарий(""C:\file.os"", ""МойОбъект"");
|А = Новый МойОбъект();</example>
|</param>
|";

// ТекстРегулярки = "\<param\s+name=\""(.*)\""\>[\s\S]\<\/param\>";
// ТекстРегулярки = "\<param\s+name=\""(.*)\""\>(.*)\<\/param\>";
ТекстРегулярки = "(?s)(?<=\<param\s+name=\""(.*)\""\>).*?(?=\<\/param\>)";

// ИсходнаяСтрока = "<div class=""b-idea__description"">Аудитория от 5 до 99 лет.
// |Поддерживает модульность. межконтинентальную направленность.
// |Препятствует гиподинамии</div>";
// ТекстРегулярки = "(?<=\<div class=""b-idea__description""\>).+?(?=\<\/div\>)";
ВыполнитьРегулярку(ИсходнаяСтрока, ТекстРегулярки);

// ИсходнаяСтрока = "
// |/// <summary>
// |        /// Не используется. Реализован для совместимости API с 1С:Предприятие
// |        /// </summary>
// |        /// <returns>Неопределено</returns>
// |        [ContextProperty(""Параметры"", ""Parameters"")]
// |        public IValue Parameters
// |        {
// |            get
// |            {
// |               return ValueFactory.Create();
// |            }
// |            set { }
// |        }
// |";
// ТекстРегулярки = "(.*)(ContextProperty)(\W*|\s*|\S*|.*|(\r\n)*)(get|set)(.*)";
// ВыполнитьРегулярку(ИсходнаяСтрока, ТекстРегулярки);
