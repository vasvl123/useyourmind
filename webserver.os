// MIT License
// Copyright (c) 2018 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//
// Включает программный код https://github.com/nextkmv/vServer


Перем Хост, Порт, ПортД, ПараметрХост;
Перем ПерезапуститьСервер, ОстановитьСервер;
Перем СтатусыHTTP;
Перем СоответствиеРасширенийТипамMIME;
Перем Задачи, ИдЗадачи;
Перем Ресурсы;
Перем Процессы;
Перем Загрузка;
Перем Лог;
Перем Локальный;


Функция ПолучитьОбласть(ИмяОбласти, ЗначенияПараметров = Неопределено)
	Если ИмяОбласти = "ОбластьШапка" Тогда ОбластьТекст = "<!DOCTYPE html><html lang=""ru""><head><meta charset=""utf-8""/></head><body>";
ИначеЕсли ИмяОбласти = "ОбластьПеренаправить" Тогда ОбластьТекст = "<!DOCTYPE html><html><script type='text/javascript'>setTimeout(function(){window.location.href = '" + ЗначенияПараметров.Путь + "';}, " + ЗначенияПараметров.Пауза + ");</script>" + ЗначенияПараметров.Текст + "</html>";
	ИначеЕсли ИмяОбласти = "ОбластьПодвал" Тогда ОбластьТекст = "</body></html>";
	Иначе ОбластьТекст = "";
	КонецЕсли;
	Возврат ОбластьТекст;
КонецФункции


Функция СтрокуВСтруктуру(Знач Стр)
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Рез = Новый Структура;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Значение = РаскодироватьСтроку(знСтр, СпособКодированияСтроки.КодировкаURL);
			Если Лев(Ключ, 1) = "*" Тогда
				Ключ = Сред(Ключ, 2);
				Значение = СтрокуВСтруктуру(Значение);
			КонецЕсли;
			Рез.Вставить(Ключ, Значение);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции


Функция СтруктуруВСтроку(Структ)
	Результат = "";
	Если НЕ Структ = Неопределено Тогда
		Для каждого Элемент Из Структ Цикл
			Ключ = Элемент.Ключ;
			Значение = Элемент.Значение;
			Если ТипЗнч(Значение) = Тип("Структура") Тогда
				Ключ = "*" + Ключ;
				Значение = СтруктуруВСтроку(Значение);
			КонецЕсли;
			Результат = ?(Результат = "", "", Результат + Символы.Таб) + Ключ + Символы.Таб + КодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL);
		КонецЦикла;
	КонецЕсли;
	Возврат Результат;
КонецФункции


Функция Раскодировать(знПараметра)
	Возврат РаскодироватьСтроку(знПараметра, СпособКодированияСтроки.КодировкаURL);
КонецФункции


Функция Кодировать(знПараметра)
	Возврат КодироватьСтроку(знПараметра, СпособКодированияСтроки.КодировкаURL);
КонецФункции


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
			POSTСтруктура.Вставить(Ключ, Раскодировать(Значение));
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
			Если НЕ ИмяКонтроллера = "showdata" Тогда
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
						GETСтруктура.Вставить(Ключ, Раскодировать(Значение));
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ИмяМетода = "showdata" Тогда
		ИмяМетода = "";
		ИмяКонтроллера = "showdata";
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

		ПараметрыЗапроса.Вставить("ПараметрыЗапросаКоличество", ПараметрыЗапроса.Количество());

		Задача = Новый Структура;
		ИдЗадачи = ИдЗадачи + 1;
		Задачи.Вставить("" + ИдЗадачи, Задача);
		Задача.Вставить("ИдЗадачи", "" + ИдЗадачи);
		Задача.Вставить("структПроцесс", Неопределено);
		Задача.Вставить("ИмяМетода", Запрос.ИмяМетода);
		Задача.Вставить("ИмяКонтроллера", Запрос.ИмяКонтроллера);
		Задача.Вставить("ВремяНачало", ТекущаяДата());
		Задача.Вставить("Соединение", Соединение);
		Задача.Вставить("СоединениеПроцесс", Неопределено);
		Задача.Вставить("Результат", Неопределено);
		Задача.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);
		Задача.Вставить("УдаленныйУзел", УдаленныйУзелАдрес(Соединение.УдаленныйУзел));

		Если Запрос.ИмяКонтроллера = "tasks" Тогда
			Если Запрос.ИмяМетода = "stopserver" Тогда
				Задача.Вставить("Результат", "goodbye!");
				ОстановитьСервер = Истина;
			ИначеЕсли Запрос.ИмяМетода = "restartserver" Тогда
				Задача.Вставить("Результат", ПолучитьОбласть("ОбластьПеренаправить", Новый Структура("Путь, Пауза, Текст", "/", 1000, "wait...")));
				ПерезапуститьСервер = Истина;
			Иначе
				Задача.Вставить("Результат", "непонятно...");
			КонецЕсли;
		ИначеЕсли Запрос.ИмяКонтроллера = "resource" Тогда

			Задача.Вставить("ИмяДанных", ОбъединитьПути(Запрос.ИмяКонтроллера, Запрос.ИмяМетода));
			Задача.Вставить("Результат", "Файл");

		ИначеЕсли Запрос.ИмяКонтроллера = "test" Тогда

			Результат = ПолучитьОбласть("ОбластьШапка") + ТекущаяДата() + ПолучитьОбласть("ОбластьПодвал");
			Задача.Вставить("Результат", Результат);

		ИначеЕсли Запрос.ИмяКонтроллера = "showdata" Тогда

		ИначеЕсли Запрос.ИмяКонтроллера = "" Тогда

			Если НЕ Задача.ИмяМетода = "" Тогда
				Файл = Новый Файл(ОбъединитьПути(ТекущийКаталог(), "data" , ".files", Задача.ИмяМетода));
				Если НЕ Файл.Существует() Тогда
					Задача.Результат = "404";
				КонецЕсли;
			КонецЕсли;

			Если Задача.ИмяМетода = "" Тогда
				Задача.Вставить("ИмяМетода", "start");
			КонецЕсли;

		Иначе
			Задача.Результат = "404";
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
				// Если НЕ Файл.Существует() Тогда
					// СтатусОтвета = 500;
				// КонецЕсли;
			КонецЕсли;

			Если Файл.Существует() Тогда
				//Ресурсы.ДобавитьДанные(Новый Структура("ИмяФайла, ИмяДанных, Расширение", ИмяФайла, Задача.ИмяДанных, Расширение));
			Иначе

				// ЗаголовокФайла = Ресурсы.ПолучитьФайл(Задача.ИмяДанных);
				//
				// Если НЕ ЗаголовокФайла = Неопределено Тогда
				//
				// 	ИмяФайла = ОбъединитьПути(Ресурсы.КаталогФайловДанных, ЗаголовокФайла.ПозицияДанныхФайла);
				// 	Расширение = ЗаголовокФайла.Расширение;
				// 	Размер		= ЗаголовокФайла.ОбъемДанных;
				// Иначе
				// 	СтатусОтвета = 500;
				// КонецЕсли;

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


Функция ВыполнитьЗапросКСерверуДанных(стрЗапрос, Данные = Неопределено) Экспорт
	Перем Ответ;
	Попытка
		Соединение = Новый TCPСоединение(Хост, ПортД);
		Соединение.ОтправитьДвоичныеДанные(ПолучитьДвоичныеДанныеИзСтроки(стрЗапрос));
		Ответ = ПолучитьСтрокуИзДвоичныхДанных(Соединение.ПрочитатьДвоичныеДанные());
		Если НЕ Данные = Неопределено Тогда
			Соединение.ОтправитьДвоичныеДанные(ПолучитьДвоичныеДанныеИзСтроки(Данные));
			Ответ = ПолучитьСтрокуИзДвоичныхДанных(Соединение.ПрочитатьДвоичныеДанные());
		КонецЕсли;
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Если НЕ Соединение = Неопределено Тогда
		Соединение.Закрыть();
		Соединение = Неопределено;
	КонецЕсли;
	Возврат Ответ;
КонецФункции // ВыполнитьЗапросКСерверуДанных() Экспорт


Процедура ОбработатьЗадачи()

	ПрерватьЦикл = Ложь;
	Пока Не ПрерватьЦикл Цикл
		ПрерватьЦикл = Истина;
		Для каждого элЗадача Из Задачи Цикл
			Задача = элЗадача.Значение;
			Если Задача.Свойство("Завершена") Тогда
				Задачи.Удалить(элЗадача.Ключ);
				ПрерватьЦикл = Ложь;
				Прервать
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Для каждого элЗадача Из Задачи Цикл

		Задача = элЗадача.Значение;

		Если НЕ Задача.Результат = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		Если Задача.структПроцесс = Неопределено Тогда

			структПроцесс = Неопределено;
			ПарИдПроцесса = "0";
			Субъект = "Гость";

			Если Задача.ИмяКонтроллера = "showdata" Тогда
				ПарИдПроцесса = Задача.ИмяМетода;
				структПроцесс = Процессы.Получить(ПарИдПроцесса);
				Если НЕ структПроцесс = Неопределено Тогда
					Если структПроцесс.Свойство("ИдПроцесса") Тогда // Прошел авторизацию
						Если НЕ структПроцесс.УдаленныйУзел = Задача.УдаленныйУзел Тогда
							Сообщить(структПроцесс.Субъект + " необходимо переавторизоваться");
							Задача.ПараметрыЗапроса.Вставить("procid", ПарИдПроцесса);
							Задача.ПараметрыЗапроса.Вставить("unm", структПроцесс.Субъект);
							Задача.ПараметрыЗапроса.Вставить("ПараметрыЗапросаКоличество", 2);
							ПарИдПроцесса = "0";
							Задача.ИмяКонтроллера = "";
							Задача.ИмяМетода = "login";
							структПроцесс = Неопределено;
						КонецЕсли;
					КонецЕсли;
				Иначе
					ПарИдПроцесса = "0";
					Задача.ИмяКонтроллера = "";
					Задача.ИмяМетода = "";
				КонецЕсли;
			КонецЕсли;

			Если Задача.ИмяКонтроллера = "" Тогда
				Если НЕ Задача.ПараметрыЗапроса.Свойство("data") Тогда
					Задача.ПараметрыЗапроса.Вставить("data", Задача.ИмяМетода); // сразу открыть файл
				КонецЕсли;
				cmd = "";
				Если Задача.ПараметрыЗапроса.Свойство("cmd", cmd) Тогда
					ПрошелАвторизацию = Ложь;
					Если cmd = "auth" ИЛИ cmd = "reg" Тогда
						Задача.ПараметрыЗапроса.Вставить("УдаленныйУзел", Задача.УдаленныйУзел);
						Задача.ПараметрыЗапроса = СтрокуВСтруктуру(ВыполнитьЗапросКСерверуДанных(СтруктуруВСтроку(Задача.ПараметрыЗапроса)));
						//Сообщить(Задача.ПараметрыЗапроса.СтатусСубъекта);
						ПрошелАвторизацию = Задача.ПараметрыЗапроса.ПрошелАвторизацию;
					КонецЕсли;
					Если ПрошелАвторизацию Тогда
						Если Задача.ПараметрыЗапроса.Свойство("procid", ПарИдПроцесса) Тогда
							структПроцесс = Процессы.Получить(ПарИдПроцесса);
							Если структПроцесс = Неопределено Тогда
								структПроцесс = Новый Структура("Субъект, ВремяНачало, УдаленныйУзел", Задача.ПараметрыЗапроса.Субъект, ТекущаяДата());
								Процессы.Вставить(ПарИдПроцесса, структПроцесс);
							КонецЕсли;
							Задача.ИмяКонтроллера = "showdata";
							Задача.ИмяМетода = ПарИдПроцесса;
							Задача.Вставить("Результат", ПолучитьОбласть("ОбластьПеренаправить", Новый Структура("Путь, Пауза, Текст", "/showdata/" + ПарИдПроцесса, 10, "success")));
							структПроцесс.УдаленныйУзел = Задача.УдаленныйУзел;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

			структПроцесс = Процессы.Получить(ПарИдПроцесса);

			Если НЕ структПроцесс = Неопределено Тогда
				Если НЕ структПроцесс.Свойство("ИдПроцесса") Тогда // Прошел авторизацию
					Субъект = структПроцесс.Субъект;
					структПроцесс = Неопределено;
				КонецЕсли;
			КонецЕсли;

			Если структПроцесс = Неопределено Тогда
				ЗапуститьПриложение("oscript " + ОбъединитьПути(ТекущийКаталог(), "showdata.os " + Порт + " " + Хост + " " + ПарИдПроцесса + " " + Задача.УдаленныйУзел + " " + Кодировать(Субъект) + " " + Кодировать(ПараметрХост)), ТекущийКаталог());
				структПроцесс = Новый Структура("ИдПроцесса, УдаленныйУзел, Субъект, ВремяНачало, Соединение", ПарИдПроцесса, Задача.УдаленныйУзел, Субъект, ТекущаяДата());
				ЛогСообщить("Запустил процесс procid=" + ПарИдПроцесса);
				Процессы.Вставить(ПарИдПроцесса, структПроцесс);
			КонецЕсли;

			структПроцесс.Вставить("ВремяНачало", ТекущаяДата());
			Задача.Вставить("структПроцесс", структПроцесс);

			Задача.Вставить("ВремяНачало", ТекущаяДата());
			Задача.ПараметрыЗапроса.Вставить("taskid", Задача.ИдЗадачи);

		КонецЕсли;

		Если Задача.СоединениеПроцесс = Неопределено Тогда
			Если НЕ Задача.структПроцесс.Соединение = Неопределено Тогда
				Если Задача.структПроцесс.Соединение.Активно Тогда
					Попытка
						Задача.структПроцесс.Соединение.ОтправитьСтроку(СтруктуруВСтроку(Задача.ПараметрыЗапроса));
						Задача.структПроцесс.Соединение.Закрыть();
						Задача.структПроцесс.Соединение = Неопределено;
						Задача.СоединениеПроцесс = Истина;
					Исключение
						Сообщить("Ошибка отправки задачи процессу.");
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	Для каждого элЗадача Из Задачи Цикл
		Задача = элЗадача.Значение;
		Если НЕ Задача.Результат = Неопределено Тогда
			ОбработатьОтветСервера(Задача);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры


Процедура ЛогСообщить(Сообщение, Тип = 0)
	Сообщить(СокрЛП(ТекущаяДата()) + " " + Сообщение);
	ВыполнитьЗапросКСерверуДанных(СтруктуруВСтроку(Новый Структура("БазаДанных, Заголовок, Команда", "log", Новый Структура("Источник, Тип, Сообщение", "webserver.os", Тип, Сообщение), "ЗаписатьЗаголовок")));
КонецПроцедуры


Процедура ОбработатьСоединения() Экспорт

	Версия = "0.0.1";
	Хост = "127.0.0.1";

	Таймаут = 10;
	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = АргументыКоманднойСтроки[0];
		Локальный = Ложь;
		ПараметрХост = "http://vasvl123.github.io/OneScriptDB"; // путь для загрузки ресурсов
	Иначе
		// Локальный режим
		Порт = 8888;
		Локальный = Истина;
		ПараметрХост = " ";
	КонецЕсли;

	ПортД = 8887;

	// Проверка наличия процесса сервера данных
	Попытка
		Соединение = Новый TCPСоединение(Хост, ПортД);
		Соединение.Закрыть();
	Исключение
		ЗапуститьПриложение("oscript dataserver.os " + ПортД, ТекущийКаталог());
		Приостановить(500);
	КонецПопытки;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.Запустить();
	ЛогСообщить("Сервер запущен на порту: " + СокрЛП(Порт) + ?(Локальный, ", локальный режим", ""));

	ОстановитьСервер = Ложь;
	ПерезапуститьСервер = Ложь;
	Соединение = Неопределено;

	Задачи = Новый Соответствие;
	ИдЗадачи = 0;

	Процессы = Новый Соответствие;

	ПустойЦикл = 0;
	РабочийЦикл = 0;
	ЗамерВремени = ТекущаяДата();

	Пока Истина Цикл

		Если ПустойЦикл + РабочийЦикл > 999 Тогда
			ПредЗамер = ЗамерВремени;
			ЗамерВремени = ТекущаяДата();
			Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(РабочийЦикл/(ЗамерВремени - ПредЗамер)) + " q/s";
			ПустойЦикл = 0;
			РабочийЦикл = 0;

			Если НЕ Локальный Тогда
				Для каждого элПроцесс Из Процессы Цикл
					структПроцесс = ЭлПроцесс.Значение;
					Если ЗамерВремени - структПроцесс.ВремяНачало > 30 * 60 Тогда
						Если НЕ структПроцесс.ИдПроцесса = "0" Тогда // Гостевой процесс не завершаем
							ЛогСообщить("Процесс " + структПроцесс.ИдПроцесса + " простаивает, нужно завершить.");
							Если НЕ структПроцесс.Соединение = Неопределено Тогда
								структПроцесс.Соединение.ОтправитьСтроку(СтруктуруВСтроку(Новый Структура("cmd, taskid", "killproc", "")));
								структПроцесс.Соединение.Закрыть();
							КонецЕсли;
							Процессы.Удалить(элПроцесс.Ключ);
							Прервать;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;

		КонецЕсли;

		Попытка
			Соединение = TCPСервер.ОжидатьСоединения(Таймаут);
			Соединение.ТаймаутОтправки = 500;
			Соединение.ТаймаутЧтения = 50;
		Исключение
			ПустойЦикл = ПустойЦикл + 1;
			Продолжить;
		КонецПопытки;

		Попытка
			ТекстовыеДанныеВходящие	= ПолучитьСтрокуИзДвоичныхДанных(Соединение.ПрочитатьДвоичныеДанные());
		Исключение
			ТекстовыеДанныеВходящие = "";
		КонецПопытки;

		Если ТекстовыеДанныеВходящие = "" Тогда
			Если НЕ Соединение = Неопределено Тогда
				Соединение.Закрыть();
			КонецЕсли;
			ПустойЦикл = ПустойЦикл + 1;
			Продолжить;
		КонецЕсли;

		РабочийЦикл = РабочийЦикл + 1;
		Запрос	= Неопределено;

		Если Лев(ТекстовыеДанныеВходящие, 6) = "procid" Тогда
			//ЛогСообщить(ТекстовыеДанныеВходящие);
			Попытка
				ПроцессЗапрос = СтрокуВСтруктуру(ТекстовыеДанныеВходящие);
				структПроцесс = Процессы.Получить(ПроцессЗапрос.procid);
				Если структПроцесс = Неопределено Тогда
					ЛогСообщить("Существующий процесс procid=" + ПроцессЗапрос.procid + " будет подключен.");
					структПроцесс = Новый Структура("ИдПроцесса, УдаленныйУзел, Субъект, ВремяНачало, Соединение", ПроцессЗапрос.procid, ПроцессЗапрос.ip, ПроцессЗапрос.unm, ТекущаяДата());
					Процессы.Вставить(ПроцессЗапрос.procid, структПроцесс);
				КонецЕсли;
				структПроцесс.Вставить("Соединение", Соединение);
			Исключение
				Соединение.Закрыть();
				Соединение = Неопределено;
				ЛогСообщить(ОписаниеОшибки());
				Продолжить;
			КонецПопытки;

		ИначеЕсли Лев(ТекстовыеДанныеВходящие, 4) = "<!--" Тогда
			taskid = Сред(ТекстовыеДанныеВходящие, 5, 10);
			taskid = Лев(taskid, СтрНайти(taskid, "-->")-1);
			Задача = Задачи.Получить(taskid);
			Если НЕ Задача = Неопределено Тогда
				Задача.Результат = ТекстовыеДанныеВходящие;
			КонецЕсли;
			Соединение.Закрыть();

		Иначе

			Попытка
				Запрос = РазобратьЗапросКлиента(ТекстовыеДанныеВходящие);
				ОбработатьЗапросКлиента(Запрос, Соединение);
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

		КонецЕсли;

		Если Задачи.Количество() Тогда
			ОбработатьЗадачи();
			//Если Локальный Тогда
				Если ПерезапуститьСервер ИЛИ ОстановитьСервер Тогда
					Прервать;
				КонецЕсли;
			//КонецЕсли;
		КонецЕсли;

		Соединение = Неопределено;

	КонецЦикла;

	TCPСервер.Остановить();

	Если Локальный Тогда
		Для каждого элПроцесс Из Процессы Цикл
			структПроцесс = ЭлПроцесс.Значение;
			Если НЕ структПроцесс.Соединение = Неопределено Тогда
				структПроцесс.Соединение.ОтправитьСтроку(СтруктуруВСтроку(Новый Структура("cmd, taskid", "killproc", "")));
				структПроцесс.Соединение.Закрыть();
			КонецЕсли;
		КонецЦикла;
		ВыполнитьЗапросКСерверуДанных("Команда" + Символы.Таб + "stopserver");
	КонецЕсли;

	Если ПерезапуститьСервер Тогда
		ЗапуститьПриложение("oscript webserver.os " + ?(НЕ Локальный, Порт, ""), ТекущийКаталог());
	КонецЕсли;

КонецПроцедуры

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
