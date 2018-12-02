// MIT License
// Copyright (c) 2018 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB


Функция СтрокуВСтруктуру(Знач Стр)
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Рез = Неопределено;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Если Рез = Неопределено Тогда
				Рез = Новый Структура;
			КонецЕсли;
			Рез.Вставить(Ключ, знСтр);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции


Функция СписокВТаблицу(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	ПарШаблон = Неопределено;
	Список = Параметры.Список;
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
				Данные.НовыйДочерний(Узел, Новый Структура("Имя, Значение", "К", ПарШаблон.Значение), Истина);
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
	Данные.Процесс.НоваяВкладка(Параметры);
	Возврат Неопределено;
КонецФункции // НоваяВкладка()


// Функция НовыйФайл(Данные, Параметры) Экспорт
// 	ИмяФайла = Параметры.ИмяФайла;
// 	ИмяФайлаДанных = ОбъединитьПути(ТекущийКаталог(), "data", ".files", ИмяФайла);
// 	Файл = Новый Файл(ИмяФайлаДанных);
// 	Если НЕ Файл.Существует() Тогда
// 		Файл = Новый ТекстовыйДокумент;
// 		Попытка
// 			Файл.Записать(ИмяФайлаДанных);
// 			стрСообщение = "Новый файл создан";
// 		Исключение
// 			стрСообщение = ОписаниеОшибки();
// 		КонецПопытки;
// 	Иначе
// 		стрСообщение = "Файл уже существует";
// 	КонецЕсли;
// 	Данные.Процесс.ЗаписатьСобытие(ИмяФайла, стрСообщение, 1);
// 	Возврат стрСообщение;
// КонецФункции


Функция НоваяБаза(Данные, Параметры) Экспорт
	БазаДанных = Параметры.БазаДанных;
	Если НЕ "" + БазаДанных = "" Тогда
		Соединение = Неопределено;
		Данные.Процесс.ПередатьСтроку(Соединение, "osdb" + Символы.Таб + БазаДанных);
		Попытка
			ИмяФайла = Соединение.ПрочитатьСтроку();
			Соединение.Закрыть();
			стрСообщение = "Новая база данных создана";
		Исключение
			стрСообщение = ОписаниеОшибки();
		КонецПопытки;
	КонецЕсли;
	Данные.Процесс.ЗаписатьСобытие(БазаДанных, стрСообщение, 1);
	Возврат стрСообщение;
КонецФункции


Функция СписокБаз(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Ссылка"), Истина);
	ЭтотУзел.Вставить("Дочерний", Узел.Код);
	СписокФайлов = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data"), "*.osdb", Истина);
	Если СписокФайлов.Количество() Тогда
		Для каждого элФайл Из СписокФайлов Цикл
			стрУзел = Новый Структура("Имя", "Строка");
			Если Узел.Имя = "Ссылка" Тогда
				Узел = Данные.НовыйДочерний(Узел, стрУзел, Истина);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
			КонецЕсли;
			Атр = Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "ИмяКонтейнера", элФайл.ИмяБезРасширения), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "ВремяИзменения", элФайл.ПолучитьВремяИзменения()), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "Размер", элФайл.Размер()), Истина);
		КонецЦикла;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции


Функция СписокДанных(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	БазаДанных = Параметры.БазаДанных;
	ИндексИмя = ОбъединитьПути(ТекущийКаталог(), "data", БазаДанных + ".files", "index");

	Соединение = Новый TCPСоединение(Данные.Процесс.Хост, Данные.Процесс.ПортД);
	Соединение.ОтправитьДвоичныеДанные(ПолучитьДвоичныеДанныеИзСтроки( "osdb" + Символы.Таб + БазаДанных));
	Попытка
		Индекс = ПолучитьСтрокуИзДвоичныхДанных(Соединение.ПрочитатьДвоичныеДанные());
		Соединение.Закрыть();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	Индекс = СтрРазделить(Индекс, Символы.ПС);
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Ссылка"), Истина);
	ЭтотУзел.Вставить("Дочерний", Узел.Код);
	Для Каждого элИндекс Из Индекс Цикл
		нУзел = СтрокуВСтруктуру(элИндекс);
		Если НЕ нУзел = Неопределено Тогда
			стрУзел = Новый Структура("Имя", "Строка");
			Если Узел.Имя = "Ссылка" Тогда
				Узел = Данные.НовыйДочерний(Узел, стрУзел, Истина);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
			КонецЕсли;
			Атр = Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "ИмяДанных", нУзел.data), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "ПозицияДанных", нУзел.dataposition), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "ВремяИзменения", "" + Данные.УзелСвойство(нУзел, "date")), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "Размер", нУзел.length), Истина);
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции


Функция ЗагруженныеДанные(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Ссылка"), Истина);
	ЭтотУзел.Вставить("Дочерний", Узел.Код);
	Для каждого элОбъектДанных Из Данные.Процесс.ВсеДанные Цикл
		ОбъектДанных = элОбъектДанных.Значение;
		стрУзел = Новый Структура("Имя", "Строка");
		Если Узел.Имя = "Ссылка" Тогда
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


Функция СписокФайлов(Данные, Параметры) Экспорт
	ЭтотУзел = Параметры.ЭтотУзел;
	Узел = Данные.НовыйУзел(Новый Структура("Имя", "Ссылка"), Истина);
	ЭтотУзел.Вставить("Дочерний", Узел.Код);
	СписокФайлов = НайтиФайлы(ОбъединитьПути(ТекущийКаталог(), "data", ".files"), "*.*", Истина);
	Если СписокФайлов.Количество() Тогда
		Для каждого элФайл Из СписокФайлов Цикл
			стрУзел = Новый Структура("Имя", "Строка");
			Если Узел.Имя = "Ссылка" Тогда
				Узел = Данные.НовыйДочерний(Узел, стрУзел, Истина);
			Иначе
				Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
			КонецЕсли;
			Атр = Данные.НовыйАтрибут(Узел, Новый Структура("Имя, Значение", "ИмяФайла", элФайл.Имя), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "ВремяИзменения", элФайл.ПолучитьВремяИзменения()), Истина);
			Атр = Данные.НовыйСоседний(Атр, Новый Структура("Имя, Значение", "Размер", элФайл.Размер()), Истина);
		КонецЦикла;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции
