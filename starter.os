// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/

Перем Хост;
Перем Контроллеры;
Перем Локальный;
Перем mono;
Перем showdata;

Функция ПередатьДанные(Хост, Порт, стрДанные) Экспорт
	КоличествоПопыток = 0;
	Пока КоличествоПопыток < 100 Цикл
		Попытка
			Приостановить(КоличествоПопыток);
			Соединение = Новый TCPСоединение(Хост, Порт);
			Соединение.ТаймаутОтправки = 50;
			Соединение.ОтправитьДвоичныеДанные(СтруктуруВДвоичныеДанные(стрДанные));
			Соединение.Закрыть();
			Возврат Истина;
		Исключение
			КоличествоПопыток = КоличествоПопыток + 1;
			Если НЕ Соединение = Неопределено Тогда
				Соединение.Закрыть();
			КонецЕсли;
		КонецПопытки;
	КонецЦикла;
	Возврат Ложь;
КонецФункции // ПередатьДанные()


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
			Возврат Неопределено;
		КонецЕсли;
		бдДанные = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Данные);
	ИначеЕсли ТипЗнч(Данные) = Тип("БуферДвоичныхДанных") Тогда
		рдДанные = Данные.Размер;
		бдДанные = Данные;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Позиция = 0;
	знСтруктура = Новый Структура;
	Пока Позиция < рдДанные - 1 Цикл
		рдКлюч = бдДанные.ПрочитатьЦелое16(Позиция);
		рдЗначение = бдДанные.ПрочитатьЦелое32(Позиция + 2);
		Если рдКлюч + рдЗначение > рдДанные Тогда // Это не структура
			Возврат Неопределено;
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


Функция ЗапуститьПроцесс(Имя, Порт)
	Попытка
		// Проверка наличия процесса
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.Закрыть();
		Возврат Ложь;
	Исключение
		ЗапуститьПриложение(mono + "uascript.exe " + Имя + " " + Порт, ТекущийКаталог());
	КонецПопытки;
	Возврат Истина;
КонецФункции // ЗапуститьПроцесс()


Хост = "127.0.0.1";

Порт = 8890; // Порт стартера
ПортЗ = 8888; // Порт запросов веб-сервера
ПортВ = 8889; // Порт ответов веб-сервера
ПортД = 8887; // Порт дата-сервера
ПортК = 8886; // Порт контроллера

Таймаут = 10;

ПараметрХост = " "; // путь для загрузки ресурсов

Контроллеры = Новый Соответствие;

Локальный = Истина;

mono = "";
си = Новый СистемнаяИнформация();
Если Лев(си.ВерсияОС, 4) = "Unix" Тогда
	mono = "mono ";
КонецЕсли;

Если АргументыКоманднойСтроки.Количество() Тогда
	Локальный = (НЕ АргументыКоманднойСтроки[0] = "site");
	Если НЕ Локальный Тогда
		ПортЗ = АргументыКоманднойСтроки[1];
		Сообщить("Режим сайта, порт " + ПортЗ); // перезапуск и завершение заблокированы
		ПараметрХост = ""; // путь для загрузки ресурсов
	КонецЕсли;
КонецЕсли;

TCPСервер = Новый TCPСервер(Порт);
TCPСервер.Запустить();
Сообщить("Стартер запущен на порту: " + Порт);

// Запуск дата-сервера
ЗапуститьПроцесс("dataserver.os", ПортД);

// Запуск веб-сервера
ЗапуститьПроцесс("webserver.os", "" + ПортВ + " " + ПортЗ);

// Запуск контроллера
ЗапуститьПроцесс("webdata.os", ПортК);

// Параметры веб-сервера
ПередатьДанные(Хост, ПортВ, Новый Структура("Хост, Порт, ПортС, ПортД, cmd", Хост, ПортВ, Порт, ПортД, "init"));

// Параметры контроллера
стрКонтроллер = Новый Структура("procid, Хост, Порт, ПортС, ПортВ, ПортД, Субъект, Локальный, ПараметрХост, УдаленныйУзел, cmd", "0", Хост, ПортК, Порт, ПортВ, ПортД, "Гость", Локальный, ПараметрХост, "", "init");
ПередатьДанные(Хост, ПортК, стрКонтроллер);
Контроллеры.Вставить("0", стрКонтроллер);

ЗавершитьПроцесс = Ложь;
ПерезапуститьПроцесс = Ложь;
ПустойЦикл = 0;

Пока Истина Цикл

	Соединение = TCPСервер.ОжидатьСоединения(Таймаут);

	Если НЕ Соединение = Неопределено Тогда

		Соединение.ТаймаутЧтения = 50;

		Попытка
			ДанныеВходящие = Неопределено;
			ДанныеВходящие = ДвоичныеДанныеВСтруктуру(Соединение.ПрочитатьДвоичныеДанные());
		Исключение
		КонецПопытки;

		Если НЕ Соединение = Неопределено Тогда
			Соединение.Закрыть();
		КонецЕсли;

		Если НЕ ДанныеВходящие = Неопределено Тогда
			cmd = "";
			Если ДанныеВходящие.Свойство("cmd", cmd) Тогда
				Сообщить(cmd);
				Если cmd = "startproc" Тогда
					Если Контроллеры.Получить(ДанныеВходящие.procid) = Неопределено Тогда
						Если ДанныеВходящие.procnm = "showdata" И НЕ showdata = Неопределено Тогда // процесс запущен заранее
							НовыйПортК = showdata;
							showdata = Неопределено;
						Иначе
							НовыйПортК = ПортК - 1;
							Пока НЕ ЗапуститьПроцесс(ДанныеВходящие.procnm + ".os", НовыйПортК) Цикл
								НовыйПортК = НовыйПортК - 1;
							КонецЦикла;
						КонецЕсли;
						стрКонтроллер = Новый Структура("procid, Хост, Порт, ПортС, ПортВ, ПортД, Субъект, Локальный, ПараметрХост, data, УдаленныйУзел, cmd", ДанныеВходящие.procid, Хост, НовыйПортК, Порт, ПортВ, ПортД, "Гость", Локальный, ПараметрХост, ДанныеВходящие.data, ДанныеВходящие.УдаленныйУзел, "init");
						ПередатьДанные(Хост, НовыйПортК, стрКонтроллер);
						Контроллеры.Вставить(ДанныеВходящие.procid, стрКонтроллер);
						НовыйПортК = Неопределено;
					КонецЕсли;
				ИначеЕсли cmd = "termproc" Тогда
					Если ДанныеВходящие.Свойство("procid") Тогда // процесс завершен
						элКонтроллер = Контроллеры.Получить(ДанныеВходящие.procid);
						Если НЕ элКонтроллер = Неопределено Тогда
							Контроллеры.Удалить(ДанныеВходящие.procid);
						КонецЕсли;
					КонецЕсли;
				ИначеЕсли cmd = "stopserver" ИЛИ cmd = "restartserver" Тогда
					Если Локальный Тогда
						// Завершить процессы
						Для каждого элКонтроллер Из Контроллеры Цикл
							ПередатьДанные(элКонтроллер.Значение.Хост, элКонтроллер.Значение.Порт, Новый Структура("cmd, taskid", "termproc", "0"));
						КонецЦикла;
						Если НЕ showdata = Неопределено Тогда // процесс запущен заранее
							ПередатьДанные(Хост, showdata, Новый Структура("cmd, taskid", "termproc", "0"));
						КонецЕсли;
						ЗавершитьПроцесс = Истина;
						Если cmd = "restartserver" Тогда
							ПерезапуститьПроцесс = Истина;
						КонецЕсли;
					Иначе // завершаем один процесс
						Если ДанныеВходящие.Свойство("procid") Тогда
							элКонтроллер = Контроллеры.Получить(ДанныеВходящие.procid);
							Если НЕ элКонтроллер = Неопределено Тогда
								ПередатьДанные(элКонтроллер.Хост, элКонтроллер.Порт, Новый Структура("cmd, taskid", "termproc", "0"));
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	Иначе
		ПустойЦикл = ПустойЦикл + 1;

	КонецЕсли;

	Если showdata = Неопределено Тогда // запустить процесс заранее
		НовыйПортК = ПортК - 1;
		Пока НЕ ЗапуститьПроцесс("showdata.os", НовыйПортК) Цикл
			НовыйПортК = НовыйПортК - 1;
		КонецЦикла;
		showdata = НовыйПортК;
	КонецЕсли;

	Если ЗавершитьПроцесс И НЕ Контроллеры.Количество() Тогда
		Прервать;
	КонецЕсли;

КонецЦикла;

TCPСервер.Остановить();

// Завершить веб-сервер
ПередатьДанные(Хост, ПортВ, Новый Структура("cmd", "stopserver"));

// Завершить дата-сервер
ПередатьДанные(Хост, ПортД, Новый Структура("cmd", "stopserver"));

Приостановить(150);

Если ПерезапуститьПроцесс Тогда
	Сообщить("Перезапуск");
	ЗапуститьПроцесс("starter.os", Порт);
КонецЕсли;
