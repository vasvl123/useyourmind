// MIT License
// Copyright (c) 2019 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//
// Включает программный код https://github.com/nextkmv/vServer


Перем Порт;
Перем ОстановитьСервер;
Перем СтатусыHTTP;
Перем СоответствиеРасширенийТипамMIME;
Перем Задачи;
Перем Ресурсы;
Перем Контроллеры;
Перем Загрузка;
Перем Параметры;
Перем МоментЗапуска;
Перем Сообщения;


Функция ПолучитьИД()
	МоментЗапуска = МоментЗапуска - 1;
	Возврат Цел(ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментЗапуска);
КонецФункции // ПолучитьИД()


Функция СтруктуруВДвоичныеДанные(знСтруктура)
	Результат = Новый Массив;
	Если НЕ знСтруктура = Неопределено Тогда
		Для каждого Элемент Из знСтруктура Цикл
			Ключ = Элемент.Ключ;
			Значение = Элемент.Значение;
			Если ТипЗнч(Значение) = Тип("Структура") Тогда
				Ключ = "*" + Ключ;
				дЗначение = СтруктуруВДвоичныеДанные(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("ДвоичныеДанные") Тогда
				Ключ = "#" + Ключ;
				дЗначение = Значение;
			Иначе
				дЗначение = ПолучитьДвоичныеДанныеИзСтроки(Значение);
			КонецЕсли;
			дКлюч = ПолучитьДвоичныеДанныеИзСтроки(Ключ);
			рдКлюч = дКлюч.Размер();
			рдЗначение = дЗначение.Размер();
			бРезультат = Новый БуферДвоичныхДанных(6);
			бРезультат.ЗаписатьЦелое16(0, рдКлюч);
			бРезультат.ЗаписатьЦелое32(2, рдЗначение);
			Результат.Добавить(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бРезультат));
			Результат.Добавить(дКлюч);
			Результат.Добавить(дЗначение);
		КонецЦикла;
	КонецЕсли;
	Возврат СоединитьДвоичныеДанные(Результат);
КонецФункции


Функция ДвоичныеДанныеВСтруктуру(Данные, Рекурсия = Истина)
	Если ТипЗнч(Данные) = Тип("ДвоичныеДанные") Тогда
		рдДанные = Данные.Размер();
		Если рдДанные = 0 Тогда
			Возврат "";
		КонецЕсли;
		бдДанные = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("БуферДвоичныхДанных") Тогда
		рдДанные = Данные.Размер;
		бдДанные = Данные;
	Иначе
		Возврат Данные;
	КонецЕсли;
	Позиция = 0;
	знСтруктура = Новый Структура;
	Пока Позиция < рдДанные - 1 Цикл
		рдКлюч = бдДанные.ПрочитатьЦелое16(Позиция);
		рдЗначение = бдДанные.ПрочитатьЦелое32(Позиция + 2);
		Если рдКлюч + рдЗначение > рдДанные Тогда // Это не структура
			Возврат ПолучитьСтрокуИзДвоичныхДанных(Данные);
		КонецЕсли;
		Ключ = ПолучитьСтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бдДанные.Прочитать(Позиция + 6, рдКлюч)));
		бЗначение = бдДанные.Прочитать(Позиция + 6 + рдКлюч, рдЗначение);
		Позиция = Позиция + 6 + рдКлюч + рдЗначение;
		Л = Лев(Ключ, 1);
		Если Л = "*" Тогда
			Если НЕ Рекурсия Тогда
				Продолжить;
			КонецЕсли;
			Ключ = Сред(Ключ, 2);
			Значение = ДвоичныеДанныеВСтруктуру(бЗначение);
		ИначеЕсли Л = "#" Тогда
			Ключ = Сред(Ключ, 2);
			Значение = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение);
		Иначе
			Значение = ПолучитьСтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение));
		КонецЕсли;
		знСтруктура.Вставить(Ключ, Значение);
	КонецЦикла;
	Возврат знСтруктура;
КонецФункции


Функция ПередатьДанные(Хост, Порт, стрДанные) Экспорт
	Попытка
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.ТаймаутОтправки = 50;
		Соединение.ОтправитьДвоичныеДанные(СтруктуруВДвоичныеДанные(стрДанные));
		Соединение.Закрыть();
		Возврат Истина;
	Исключение
		Сообщить("Хост недоступен: " + Хост + ":" + Порт);
		Если НЕ Соединение = Неопределено Тогда
			Соединение.Закрыть();
		КонецЕсли;
	КонецПопытки;
	Возврат Ложь;
КонецФункции // ПередатьДанные()


Функция УдаленныйУзелАдрес(УдаленныйУзел)
	Возврат Лев(УдаленныйУзел, Найти(УдаленныйУзел, ":") - 1);
КонецФункции


// Разбирает вошедший запрос и возвращает структуру запроса
Функция РазобратьЗапросКлиента(ТекстЗапроса)

	Перем ИмяКонтроллера;
	Перем ИмяМетода;
	Перем ПараметрыМетода;

	Заголовок = Новый Соответствие();

	мТекстовыеДанные = ТекстЗапроса;
	Пока Найти(мТекстовыеДанные,Символы.ПС) > 0 Цикл
		П = Найти(мТекстовыеДанные,Символы.ПС);
		Подстрока = Лев(мТекстовыеДанные, П);
		мТекстовыеДанные = Прав(мТекстовыеДанные,СтрДлина(мТекстовыеДанные)-П);
		// Разбираем ключ значение
		Если Найти(Подстрока,"HTTP/1.1") > 0 Тогда
			// Это строка протокола
			// Определим метод
			П1 = 0;
			Метод = Неопределено;
			Если Лев(Подстрока, 3) = "GET" Тогда
				Метод ="GET";
				П1 = 3;
			ИначеЕсли Лев(Подстрока, 4) = "POST" Тогда
				Метод ="POST";
				П1 = 4;
			ИначеЕсли Лев(Подстрока, 3) = "PUT" Тогда
				Метод = "PUT";
				П1 = 3;
			ИначеЕсли Лев(Подстрока, 6) = "DELETE" Тогда
				Метод ="DELETE";
				П1 = 6;
			КонецЕсли;
			Заголовок.Вставить("Method", Метод);
			// Определим Путь
			П2 = Найти(Подстрока,"HTTP/1.1");
			Путь = СокрЛП(Сред(Подстрока,П1+1,СтрДлина(Подстрока)-10-П1));
			Заголовок.Вставить("Path", Путь);

		Иначе
			Если Найти(Подстрока,":") > 0 Тогда
				П3 = Найти(Подстрока,":");
				Ключ 		= СокрЛП(Лев(Подстрока,П3-1));
				Значение	= СокрЛП(Прав(Подстрока,СтрДлина(Подстрока)-П3));
				Заголовок.Вставить(Ключ, Значение);
			Иначе
				Ключ 		= "unknown";
				Значение	= СокрЛП(Подстрока);
				Если СтрДлина(Значение) > 0 Тогда
					Заголовок.Вставить(Ключ, Значение);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	// Получим данные запроса
	ПД = Найти(мТекстовыеДанные,Символы.ВК+Символы.ПС+Символы.ВК+Символы.ПС);
	POSTДанные = Сред(мТекстовыеДанные,ПД,СтрДлина(мТекстовыеДанные)-ПД);
	// Разбираем данные пост
	Если СтрДлина(POSTДанные) > 0 Тогда
		POSTДанные = POSTДанные + "&";
	КонецЕсли;
	Заголовок.Вставить("POSTДанные", POSTДанные);
	POSTСтруктура = Новый Структура();
	Пока Найти(POSTДанные, "&") > 0 Цикл
		П1 = Найти(POSTДанные, "&");
		П2 = Найти(POSTДанные, "=");
		Ключ = Лев(POSTДанные, П2-1);
		Значение = Сред(POSTДанные, П2+1, П1-(П2+1));
		POSTДанные = Прав(POSTДанные, СтрДлина(POSTДанные)-П1);
		Если НЕ Ключ = "" Тогда
			POSTСтруктура.Вставить(Ключ, РаскодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL));
		КонецЕсли;
	КонецЦикла;
	Заголовок.Вставить("POSTData", POSTСтруктура);
	//ЛогСообщить(ПД);
	// Разбор пути на имена контроллеров
	Путь = СокрЛП(Заголовок.Получить("Path"));
	// ПараметрыМетода = Новый Массив();
	Если Не Путь = Неопределено Тогда
		Если Лев(Путь,1) = "/" Тогда
			Путь = Прав(Путь, СтрДлина(Путь)-1);
		КонецЕсли;
		Если Прав(Путь,1) <> "/" Тогда
			Путь = Путь+"/";
		КонецЕсли;
		Сч = 0;
		Пока Найти(Путь,"/") > 0 Цикл
			П = Найти(Путь,"/");
			Сч = Сч + 1;
			ЗначениеПараметра = Лев(Путь,П-1);
			Путь = Прав(Путь, СтрДлина(Путь)-П);
			Если Сч = 1 Тогда
				ИмяКонтроллера = ЗначениеПараметра;
			ИначеЕсли Сч = 2 Тогда
				ИмяМетода = ЗначениеПараметра;
			ИначеЕсли НЕ ЗначениеПараметра = ".." Тогда
				ИмяМетода = ОбъединитьПути(ИмяМетода, ЗначениеПараметра);
			КонецЕсли;
		КонецЦикла;
		Если ИмяМетода = Неопределено Тогда
			Если НЕ ИмяКонтроллера = "webdata" Тогда
				ИмяМетода = ИмяКонтроллера;
				ИмяКонтроллера = "";
			КонецЕсли;
		КонецЕсли;
		GETСтруктура = Новый Структура();
		Если НЕ СокрЛП(ИмяМетода) = "" Тогда
			Если Найти(ИмяМетода, "?") Тогда
				GETДанные = ИмяМетода;
				ИмяМетода = Лев(GETДанные, Найти(GETДанные, "?") - 1);
				GETДанные = СтрЗаменить(GETДанные, ИмяМетода + "?", "") + "&";
				// Разбираем данные гет
				Пока Найти(GETДанные, "&") > 0 Цикл
					П1 = Найти(GETДанные, "&");
					П2 = Найти(GETДанные, "=");
					Ключ = Лев(GETДанные, П2-1);
					Значение = Сред(GETДанные, П2 + 1, П1 - (П2 + 1));
					GETДанные = Прав(GETДанные, СтрДлина(GETДанные) - П1);
					Если НЕ Ключ = "" Тогда
						GETСтруктура.Вставить(Ключ, РаскодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL));
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ИмяМетода = "webdata" Тогда
		ИмяМетода = "";
		ИмяКонтроллера = "webdata";
	КонецЕсли;
	Заголовок.Вставить("GETData", GETСтруктура);

	Запрос = Новый Структура;
	Запрос.Вставить("Заголовок", Заголовок);
	Запрос.Вставить("ИмяКонтроллера", "" + ИмяКонтроллера);
	Запрос.Вставить("ИмяМетода", "" + ИмяМетода);
	// Запрос.Вставить("ПараметрыМетода", ПараметрыМетода);

	Возврат Запрос;

КонецФункции


Функция ОбработатьЗапросКлиента(Запрос, Знач Соединение)

	Метод = Запрос.Заголовок.Получить("Method");

	Если НЕ Метод = Неопределено Тогда

		ПараметрыЗапроса = Запрос.Заголовок.Получить(Метод + "Data");

		Если ПараметрыЗапроса = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;

		Задача = Новый Структура;
		ИдЗадачи = ПолучитьИД();
		Задачи.Вставить("" + ИдЗадачи, Задача);
		Задача.Вставить("ИдЗадачи", "" + ИдЗадачи);
		Задача.Вставить("структКонтроллер", Неопределено);
		Задача.Вставить("ИмяМетода", Запрос.ИмяМетода);
		Задача.Вставить("ИмяКонтроллера", Запрос.ИмяКонтроллера);
		Задача.Вставить("ВремяНачало", ТекущаяДата());
		Задача.Вставить("Соединение", Соединение);
		Задача.Вставить("ПереданоВКонтроллер", Неопределено);
		Задача.Вставить("Результат", Неопределено);
		Задача.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
		Задача.Вставить("УдаленныйУзел", УдаленныйУзелАдрес(Соединение.УдаленныйУзел));
		ПараметрыЗапроса.Вставить("УдаленныйУзел", Задача.УдаленныйУзел);

		Если Запрос.ИмяКонтроллера = "resource" Тогда // запрос к файлам сервера

			Задача.Вставить("ИмяДанных", ОбъединитьПути(Запрос.ИмяКонтроллера, Запрос.ИмяМетода));
			Задача.Вставить("Результат", "Файл");

		// ИначеЕсли Запрос.ИмяКонтроллера = "time" Тогда
		// 	Задача.Вставить("Результат", "server time: " + ТекущаяДата());

		КонецЕсли;

		ЛогСообщить(Задача.УдаленныйУзел + " -> taskid=" + Задача.ИдЗадачи + " " + СокрЛП(Запрос.Заголовок.Получить("Method")) + " " + Запрос.Заголовок.Получить("Path"));

	КонецЕсли;

КонецФункции


Процедура ОбработатьОтветСервера(Задача)

	Перем ИмяФайла;

	Попытка

		СтатусОтвета = 200;
		Заголовок = Новый Соответствие();
		Если ТипЗнч(Задача.Результат) = Тип("ДвоичныеДанные") Тогда
			ДвоичныеДанныеОтвета =  Задача.Результат;
		Иначе
			ДвоичныеДанныеОтвета = ПолучитьДвоичныеДанныеИзСтроки(Задача.Результат);
			Заголовок.Вставить("Content-Length", ДвоичныеДанныеОтвета.Размер());
			Заголовок.Вставить("Content-Type", "text/html");
		КонецЕсли;

		// Разбор маршрута
		Если Задача.Свойство("ИмяДанных") Тогда

			ИмяФайла = ОбъединитьПути(ТекущийКаталог(), Задача.ИмяДанных);

			//ЛогСообщить(ИмяФайла);

			Файл = Новый Файл(ИмяФайла);
			Расширение = Файл.Расширение;

			Если НЕ Файл.Существует() Тогда
				ИмяФайла = СтрЗаменить(ИмяФайла, "/", "\");
				Файл = Новый Файл(ИмяФайла);
			КонецЕсли;

			Если НЕ Файл.Существует() Тогда
				СтатусОтвета = 404;
			КонецЕсли;

			Если СтатусОтвета = 200 Тогда
				MIME = СоответствиеРасширенийТипамMIME.Получить(Расширение);
				Если MIME = Неопределено Тогда
					MIME = СоответствиеРасширенийТипамMIME.Получить("default");
				КонецЕсли;
				ДвоичныеДанныеОтвета = Новый ДвоичныеДанные(СокрЛП(ИмяФайла));

				Заголовок.Вставить("Content-Length", ДвоичныеДанныеОтвета.Размер());
				Заголовок.Вставить("Content-Type", MIME);
			КонецЕсли;

		КонецЕсли;

		Если Задача.Соединение.Активно Тогда

			ПС = Символы.ВК + Символы.ПС;
			мЗаголовок = СокрЛП(СтатусыHTTP[Число(СтатусОтвета)]) + ПС;
			Задача.Соединение.ОтправитьСтроку(мЗаголовок);
			ТекстОтветаКлиенту = "";
			Для Каждого СтрокаЗаголовкаответа из Заголовок Цикл
				ТекстОтветаКлиенту = ТекстОтветаКлиенту + СтрокаЗаголовкаответа.Ключ + ":" + СтрокаЗаголовкаответа.Значение + ПС;
			КонецЦикла;

			Задача.Соединение.ОтправитьСтроку(ТекстОтветаКлиенту);
			Задача.Соединение.ОтправитьСтроку(ПС);

			Задача.Соединение.ОтправитьДвоичныеДанные(ДвоичныеДанныеОтвета);

		КонецЕсли;

	Исключение
		ЛогСообщить("Ошибка формирования ответа");
		ЛогСообщить(ОписаниеОшибки());
	КонецПопытки;

	Задача.Соединение.Закрыть();
	Задача.Соединение = Неопределено;
	Задача.Вставить("Завершена");
	ЛогСообщить("<- taskid=" + СокрЛП(Задача.ИдЗадачи) + " time=" + Цел(100*(ТекущаяДата() - Задача.ВремяНачало))/100 + Загрузка);

КонецПроцедуры


Процедура ОбработатьЗадачи()

	ПереченьЗадач = Новый Массив;
	Для каждого элЗадача Из Задачи Цикл
		ПереченьЗадач.Добавить(ЭлЗадача.Значение);
	КонецЦикла;

	Для каждого Задача Из ПереченьЗадач Цикл

		Если НЕ Задача.структКонтроллер = Неопределено Тогда
			Если НЕ Задача.ПереданоВКонтроллер = Истина Тогда
				Задача.ПереданоВКонтроллер = ПередатьДанные(Задача.структКонтроллер.Хост, Задача.структКонтроллер.Порт, Задача.ПараметрыЗапроса);
			КонецЕсли;
		КонецЕсли;

		Если Задача.Результат = Неопределено Тогда

			Если Задача.структКонтроллер = Неопределено Тогда

				ПарИдКонтроллера = "";

				Если Задача.ИмяКонтроллера = "" ИЛИ Задача.ИмяКонтроллера = "webdata" Тогда // по умолчанию контроллер webdata

					ПарИдКонтроллера = "0";
					Если НЕ Задача.ПараметрыЗапроса.Свойство("data") Тогда
						Задача.ПараметрыЗапроса.Вставить("data", Задача.ИмяМетода); // сразу открыть файл
					КонецЕсли;

				ИначеЕсли Задача.ИмяКонтроллера = "procid" Тогда // конкретный процесс

					ПарИдКонтроллера = Задача.ИмяМетода;

				Иначе // запустить новый процесс

					ПарИдКонтроллера = "" + ПолучитьИд();
					Если ПередатьДанные(Параметры.Хост, Параметры.ПортС, Новый Структура("procid, procnm, data, cmd", ПарИдКонтроллера, Задача.ИмяКонтроллера, Задача.ИмяМетода, "startproc")) Тогда // запустить новый процесс контроллера
						Задача.ИмяКонтроллера = "procid";
						Задача.ИмяМетода = ПарИдКонтроллера;
					КонецЕсли;

				КонецЕсли;

				Если НЕ ПарИдКонтроллера = "" Тогда

					структКонтроллер = Контроллеры.Получить(ПарИдКонтроллера);

					Если НЕ структКонтроллер = Неопределено Тогда

						структКонтроллер.Вставить("ВремяНачало", ТекущаяДата());
						Задача.Вставить("структКонтроллер", структКонтроллер);

						Задача.Вставить("ВремяНачало", ТекущаяДата());
						Задача.ПараметрыЗапроса.Вставить("taskid", Задача.ИдЗадачи);

					КонецЕсли;

				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		Если НЕ Задача.Результат = Неопределено Тогда
			ОбработатьОтветСервера(Задача);
		КонецЕсли;

		Если Задача.Свойство("Завершена") Тогда
			Задачи.Удалить(Задача.ИдЗадачи);
		ИначеЕсли НЕ Задача.Соединение = Неопределено Тогда
			Если НЕ Задача.Соединение.Активно Тогда
				Задачи.Удалить(Задача.ИдЗадачи);
			КонецЕсли;
		КонецЕсли;


	КонецЦикла;

	Если Сообщения.Количество() Тогда
		ПередатьДанные(Параметры.Хост, Параметры.ПортД, Сообщения.Получить(0));
		Сообщения.Удалить(0);
	КонецЕсли;

КонецПроцедуры


Процедура ЛогСообщить(Сообщение, Тип = 0)
	Сообщить("" + ТекущаяДата() + " " + Сообщение);
	Если НЕ Параметры = Неопределено Тогда
		Сообщения.Добавить(Новый Структура("БазаДанных, Заголовок, Команда", "web", Новый Структура("Тип, Сообщение", Тип, Сообщение), "ЗаписатьЗаголовок"));
	КонецЕсли;
КонецПроцедуры


Процедура УдалитьКонтроллерИЗадачи(структКонтроллер)
	Контроллеры.Удалить(структКонтроллер.ИдКонтроллера);
	Для каждого элЗадача Из Задачи Цикл
		Если ЭлЗадача.Значение.структКонтроллер = структКонтроллер Тогда
			ЭлЗадача.Значение.Вставить("Завершена");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Процедура ОбработатьСоединения()

	Версия = "0.0.1";
	Порт = 8888;

	Таймаут = 10;
	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = АргументыКоманднойСтроки[0];
	КонецЕсли;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.Запустить();
	ЛогСообщить("Веб-сервер запущен на порту: " + Порт);

	ОстановитьСервер = Ложь;
	Соединение = Неопределено;

	Задачи = Новый Соответствие;
	Контроллеры = Новый Соответствие;
	Сообщения = Новый Массив;

	ПустойЦикл = 0;
	РабочийЦикл = 0;
	ЗамерВремени = ТекущаяДата();

	Пока Не ОстановитьСервер Цикл

		Если ПустойЦикл + РабочийЦикл > 999 Тогда
			ПредЗамер = ЗамерВремени;
			ЗамерВремени = ТекущаяДата();
			Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(РабочийЦикл/(ЗамерВремени - ПредЗамер)) + " q/s";
			ПустойЦикл = 0;
			РабочийЦикл = 0;
		КонецЕсли;

		// Ожидаем подключение
		Соединение = TCPСервер.ОжидатьСоединения(Таймаут);

		Если НЕ Соединение = Неопределено Тогда

			//Соединение.ТаймаутОтправки = 500;
			Соединение.ТаймаутЧтения = 50;

			Попытка
				ДанныеВходящие = ДвоичныеДанныеВСтруктуру(Соединение.ПрочитатьДвоичныеДанные());
			Исключение
				ДанныеВходящие = "";
			КонецПопытки;

			Если ДанныеВходящие = "" Тогда
				Соединение.Закрыть();
				ПустойЦикл = ПустойЦикл + 1;
				Продолжить;

			ИначеЕсли ТипЗнч(ДанныеВходящие) = Тип("Строка") Тогда // это http запрос
				ТекстовыеДанныеВходящие = ДанныеВходящие;

				РабочийЦикл = РабочийЦикл + 1;

				Попытка
					Запрос = РазобратьЗапросКлиента(ТекстовыеДанныеВходящие);
					ОбработатьЗапросКлиента(Запрос, Соединение);
					//Сообщить("webserver: всего задач " + Задачи.Количество());
				Исключение
					ЛогСообщить(ОписаниеОшибки());
					ЛогСообщить("Ошибка обработки запроса:");
					ЛогСообщить(ТекстовыеДанныеВходящие);
					Попытка
						Соединение.ОтправитьСтроку("500");
					Исключение
					КонецПопытки;
					Соединение.Закрыть();
				КонецПопытки;

			ИначеЕсли ТипЗнч(ДанныеВходящие) = Тип("Структура") Тогда // это ответ контроллера

				Соединение.Закрыть();

				РабочийЦикл = РабочийЦикл + 1;

				КонтроллерЗапрос = ДанныеВходящие;

				Если КонтроллерЗапрос.Свойство("procid") Тогда
					структКонтроллер = Контроллеры.Получить(КонтроллерЗапрос.procid);
					Если КонтроллерЗапрос.Свойство("cmd") Тогда
						Если КонтроллерЗапрос.cmd = "termproc" Тогда // удалить контроллер
							Если НЕ структКонтроллер = Неопределено Тогда
								УдалитьКонтроллерИЗадачи(структКонтроллер);
							КонецЕсли
						ИначеЕсли КонтроллерЗапрос.cmd = "init" Тогда // зарегистрировать контроллер
							Если структКонтроллер = Неопределено Тогда
								ЛогСообщить("Подключен контроллер procid=" + КонтроллерЗапрос.procid);
								структКонтроллер = Новый Структура("ИдКонтроллера, Хост, Порт, ВремяНачало", КонтроллерЗапрос.procid, КонтроллерЗапрос.Хост, КонтроллерЗапрос.Порт, ТекущаяДата());
								Контроллеры.Вставить(КонтроллерЗапрос.procid, структКонтроллер);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;

					Если КонтроллерЗапрос.Свойство("taskid") Тогда
						Задача = Задачи.Получить(КонтроллерЗапрос.taskid);
						Если НЕ Задача = Неопределено Тогда
							Задача.Результат = КонтроллерЗапрос.Результат;
						КонецЕсли;
						Соединение.Закрыть();
					КонецЕсли;

				ИначеЕсли КонтроллерЗапрос.Свойство("cmd") Тогда
					Если КонтроллерЗапрос.cmd = "stopserver" Тогда
						ОстановитьСервер = Истина;

					ИначеЕсли КонтроллерЗапрос.cmd = "init" Тогда
						Если Параметры = Неопределено Тогда
							Сообщить("Получены параметры");
							Параметры = ДанныеВходящие;
						КонецЕсли;

					КонецЕсли;

				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

		Если Задачи.Количество() Тогда
			ОбработатьЗадачи();
		КонецЕсли;

	КонецЦикла;

	TCPСервер.Остановить();

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();

СтатусыHTTP = Новый Массив(1000);
СтатусыHTTP.Вставить(200,"HTTP/1.1 200 OK");
СтатусыHTTP.Вставить(400,"HTTP/1.1 400 Bad Request");
СтатусыHTTP.Вставить(401,"HTTP/1.1 401 Unauthorized");
СтатусыHTTP.Вставить(402,"HTTP/1.1 402 Payment Required");
СтатусыHTTP.Вставить(403,"HTTP/1.1 403 Forbidden");
СтатусыHTTP.Вставить(404,"HTTP/1.1 404 Not Found");
СтатусыHTTP.Вставить(405,"HTTP/1.1 405 Method Not Allowed");
СтатусыHTTP.Вставить(406,"HTTP/1.1 406 Not Acceptable");
СтатусыHTTP.Вставить(500,"HTTP/1.1 500 Internal Server Error");
СтатусыHTTP.Вставить(501,"HTTP/1.1 501 Not Implemented");
СтатусыHTTP.Вставить(502,"HTTP/1.1 502 Bad Gateway");
СтатусыHTTP.Вставить(503,"HTTP/1.1 503 Service Unavailable");
СтатусыHTTP.Вставить(504,"HTTP/1.1 504 Gateway Timeout");
СтатусыHTTP.Вставить(505,"HTTP/1.1 505 HTTP Version Not Supported");

СоответствиеРасширенийТипамMIME = Новый Соответствие();
СоответствиеРасширенийТипамMIME.Вставить(".html","text/html");
СоответствиеРасширенийТипамMIME.Вставить(".css","text/css");
СоответствиеРасширенийТипамMIME.Вставить(".js","text/javascript");
СоответствиеРасширенийТипамMIME.Вставить(".jpg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".svg","image/svg+xml");
СоответствиеРасширенийТипамMIME.Вставить(".jpeg","image/jpeg");
СоответствиеРасширенийТипамMIME.Вставить(".png","image/png");
СоответствиеРасширенийТипамMIME.Вставить(".gif","image/gif");
СоответствиеРасширенийТипамMIME.Вставить(".ico","image/x-icon");
СоответствиеРасширенийТипамMIME.Вставить(".zip","application/x-compressed");
СоответствиеРасширенийТипамMIME.Вставить(".rar","application/x-compressed");

СоответствиеРасширенийТипамMIME.Вставить("default","text/plain");

ОбработатьСоединения();
