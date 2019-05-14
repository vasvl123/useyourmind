// MIT License
// Copyright (c) 2019 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB


Функция СписокВТаблицу(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	ДочернийУзел = Данные.Дочерний(ЭтотУзел);
	// прежний дочерний нужно удалять
	Если НЕ ДочернийУзел = Неопределено Тогда
		Данные.УдалитьУзел(ДочернийУзел);
	КонецЕсли;
	ПарШаблон = Неопределено;
	Список = Данные.Дочерний(Параметры.Список);
	нУзел = Неопределено;
	Пока НЕ Список = Неопределено Цикл
		нстрУзел = Новый Структура("Имя", "tr");
		Если нУзел = Неопределено Тогда
			нУзел = Данные.НовыйУзел(нстрУзел, Истина);
			нУзел.Вставить("Старший", ЭтотУзел);
			нУзел.Вставить("Родитель", ЭтотУзел);
			ЭтотУзел.Вставить("Дочерний", нУзел.Код);
		Иначе
			нУзел = Данные.НовыйСоседний(нУзел, нстрУзел, Истина);
		КонецЕсли;
		// это ссылка на строку таблицы
		Узел = Данные.НовыйДочерний(нУзел, Новый Структура("Имя, Значение", "Узел", "Строка"), Истина);
		Данные.НовыйДочерний(Узел, Новый Структура("Имя, Значение", "Указатель", Список.Код), Истина);
		Атрибут = Данные.Атрибут(Список);
		Пока НЕ Атрибут = Неопределено Цикл
			нстУзел = Новый Структура("Имя, Значение", "td", Атрибут.Значение);
			Если Узел.Имя = "tr" Тогда
				Узел = Данные.НовыйДочерний(нУзел, нстУзел, Истина);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, нстУзел, Истина);
			КонецЕсли;
			// Если есть шаблон для значения
			Если Параметры.Свойство(Атрибут.Имя, ПарШаблон) Тогда
 				Узел.Значение = Неопределено;
				Элемент = Данные.КопироватьВетку(Данные.Дочерний(ПарШаблон), , Узел, Узел, , Ложь);
				Данные.НовыйДочерний(Узел, Элемент, Истина);
			КонецЕсли;
			Атрибут = Данные.Соседний(Атрибут);
		КонецЦикла;
		Список = Данные.Соседний(Список);
	КонецЦикла;
	Возврат Неопределено;
КонецФункции


// Функция ПокаЦикл(Данные, Параметры) Экспорт
// 	ЭтотУзел = Параметры.ЭтотУзел;
// 	УсловиеПока = Параметры.УсловиеПока;
// 	ЦиклУзел = Параметры.ЦиклУзел;
// 	Узел = Неопределено;
// 	Пока Данные.Интерпретировать(УсловиеПока) Цикл
// 		НовыйУзел = Данные.КопироватьВетку(ЦиклУзел, Узел, ЭтотУзел);
// 		Если Узел = ЭтотУзел Тогда
// 			Узел.Вставить("Дочерний", НовыйУзел);
// 		Иначе
// 			Узел.Вставить("Соседний", НовыйУзел);
// 		конецЕсли;
// 		Узел = НовыйУзел;
// 	КонецЦикла;
// 	Возврат Узел;
// КонецФункции // ПокаЦикл()


Функция НоваяВкладка(Данные, Параметры) Экспорт
	Параметры.Вставить("cmd", "newtab");
	Данные.Процесс.НоваяЗадача(Параметры, "Служебный");
	Возврат Неопределено;
КонецФункции // НоваяВкладка()


Функция ИсточникДанных(Данные, Параметры) Экспорт
	Перем ЗапросДанных;
	ЭтотУзел = Параметры.ЭтотУзел;
	ЗапросДанных = Параметры.ЗапросДанных;
	Если Данные.УзелСостояние(ЗапросДанных, "Значение") = Неопределено Тогда
		// прежний дочерний нужно удалять
		ДочернийУзел = Данные.Дочерний(ЭтотУзел);
		Если НЕ ДочернийУзел = Неопределено Тогда
			Данные.УдалитьУзел(ДочернийУзел);
		КонецЕсли;
		Запрос = Новый Структура("Данные, Узел, ЗапросДанных, cmd", Данные, ЭтотУзел, ЗапросДанных, "ЗапросДанных");
		Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
		Данные.УзелСостояниеЗначение(ЗапросДанных, "Значение", Новый Структура);
	КонецЕсли;
КонецФункции // ИсточникДанных()


Функция НоваяБаза(Данные, Параметры) Экспорт
	БазаДанных = Параметры.БазаДанных;
	Запрос = Новый Структура("Данные, БазаДанных, cmd", Данные, БазаДанных, "НоваяБаза");
	Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
	Возврат Неопределено;
КонецФункции


Функция ЗагруженныеДанные(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	ДочернийУзел = Данные.Дочерний(ЭтотУзел);
	// прежний дочерний нужно удалять
	Если НЕ ДочернийУзел = Неопределено Тогда
		Данные.УдалитьУзел(ДочернийУзел);
	КонецЕсли;
	Узел = ЭтотУзел;
	Для каждого элОбъектДанных Из Данные.Процесс.ВсеДанные Цикл
		ОбъектДанных = элОбъектДанных.Значение;
		стрУзел = Новый Структура("Имя", "Строка");
		Если Узел.Имя = "Узел" Тогда
			Узел = Данные.НовыйДочерний(Узел, стрУзел, Истина);
		Иначе
			Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
		КонецЕсли;
		Атр = Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "ИмяДанных", ОбъектДанных.ИмяДанных), Истина);
		Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "ПозицияДанных", ОбъектДанных.ПозицияДанных), Истина);
		Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "БазаДанных", ОбъектДанных.БазаДанных), Истина);
		Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "Размер", ОбъектДанных.Количество), Истина);
	КонецЦикла;
	Возврат Неопределено;
КонецФункции
