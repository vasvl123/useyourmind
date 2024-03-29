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
Перем Соединения;
Перем мЗадачи;


Функция ПередатьДанные(Хост, Порт, стрДанные) Экспорт
	Попытка
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.ТаймаутОтправки = 5000;
		Соединение.ОтправитьДвоичныеДанныеАсинхронно(СтруктуруВДвоичныеДанные(стрДанные));
		Возврат Соединение;
	Исключение
		Сообщить(ОписаниеОшибки());
		Если Соединение = Неопределено Тогда
			Сообщить("starter: Хост недоступен: " + Хост + ":" + Порт);
		Иначе
			Соединение.Закрыть();
			Соединение = Неопределено;
		КонецЕсли;
	КонецПопытки;
	Возврат Соединение;
КонецФункции // ПередатьДанные()


Функция СтруктуруВДвоичныеДанные(знСтруктура)
	Результат = Новый Массив;
	Если НЕ знСтруктура = Неопределено Тогда
		Для каждого Элемент Из знСтруктура Цикл
			Если ТипЗнч(знСтруктура) = Тип("Массив") Тогда
				Ключ = "";
				Значение = Элемент;
			Иначе
				Ключ = "" + Элемент.Ключ;
				Значение = Элемент.Значение;
			КонецЕсли;
			Если ТипЗнч(Значение) = Тип("Структура") Тогда
				Ключ = "*" + Ключ;
				дЗначение = СтруктуруВДвоичныеДанные(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("Соответствие") Тогда
				Ключ = "&" + Ключ;
				дЗначение = СтруктуруВДвоичныеДанные(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("Массив") Тогда
				Ключ = "$" + Ключ;
				дЗначение = СтруктуруВДвоичныеДанные(Значение);
			ИначеЕсли ТипЗнч(Значение) = Тип("ДвоичныеДанные") Тогда
				Ключ = "#" + Ключ;
				дЗначение = Значение;
			Иначе
				Если ТипЗнч(Значение) = Тип("Число") Тогда
					Ключ = "!" + Ключ;
				КонецЕсли;
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


Функция ДвоичныеДанныеВСтруктуру(Данные, знСтруктура = Неопределено)
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
	Если знСтруктура = Неопределено Тогда
		знСтруктура = Новый Структура;
	КонецЕсли;
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
			Ключ = Сред(Ключ, 2);
			Значение = ДвоичныеДанныеВСтруктуру(бЗначение, Новый Структура);
		ИначеЕсли Л = "&" Тогда
			Ключ = Сред(Ключ, 2);
			Значение = ДвоичныеДанныеВСтруктуру(бЗначение, Новый Соответствие);
		ИначеЕсли Л = "$" Тогда
			Ключ = Сред(Ключ, 2);
			Значение = ДвоичныеДанныеВСтруктуру(бЗначение, Новый Массив);
		ИначеЕсли Л = "#" Тогда
			Ключ = Сред(Ключ, 2);
			Значение = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение);
		Иначе
			Значение = ПолучитьСтрокуИзДвоичныхДанных(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(бЗначение));
			Если Л = "!" Тогда
				Ключ = Сред(Ключ, 2);
				Значение = Число(Значение);
			КонецЕсли;
		КонецЕсли;
		Если Ключ = "" Тогда
			знСтруктура.Добавить(Значение);
		Иначе
			знСтруктура.Вставить(Ключ, Значение);
		КонецЕсли;
	КонецЦикла;
	Возврат знСтруктура;
КонецФункции


Функция ЗапуститьПроцесс(Имя, Порт, Параметры = "")
	Попытка
		Сообщить("Запуск " + Имя + " ...");
		// Проверка свободного порта
		Сервер = Новый TCPСервер(Порт);
		Сервер.Запустить();
		Сервер.Остановить();
		ЗапуститьПриложение(mono + Имя + " " + Порт + " " + Параметры, ТекущийКаталог());
		Приостановить(200); // ???
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции // ЗапуститьПроцесс()


Хост = "127.0.0.1";

Порт = 8890; // Порт стартера
ПортЗ = 8888; // Порт запросов веб-сервера
ПортВ = 8889; // Порт ответов веб-сервера
ПортД = 8887; // Порт дата-сервера
ПортМ = 8886; // Порт морфологии

НовыйПортК = ПортМ;

ПараметрХост = " "; // путь для загрузки ресурсов

Контроллеры = Новый Соответствие;

Соединения = Новый Массив;

Локальный = Истина;

мЗадачи = Новый Массив;

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

Таймаут = 5;

TCPСервер = Новый TCPСервер(Порт);
TCPСервер.ЗапуститьАсинхронно();
Сообщить("Стартер запущен на порту: " + Порт);

мЗадачи.Добавить(Новый Структура("Запущен, ДанныеВходящие", Ложь, Новый Структура("cmd", "startweb")));
мЗадачи.Добавить(Новый Структура("Запущен, ДанныеВходящие", Ложь, Новый Структура("cmd", "showdata")));
мЗадачи.Добавить(Новый Структура("Запущен, ДанныеВходящие", Ложь, Новый Структура("cmd", "startdata")));
мЗадачи.Добавить(Новый Структура("Запущен, ДанныеВходящие", Ложь, Новый Структура("cmd", "startmorph")));

ЗавершитьПроцесс = Ложь;
ПерезапуститьПроцесс = Ложь;
ПустойЦикл = 0;

Пока НЕ ЗавершитьПроцесс Цикл

	НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();

	к = мЗадачи.Количество();
	Пока к > 0 И НЕ ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла > 50 Цикл
		к = к - 1;
		структЗадача = мЗадачи.Получить(0);
		мЗадачи.Удалить(0);

		ДанныеВходящие = структЗадача.ДанныеВходящие;
		cmd = ДанныеВходящие.cmd;

		Если cmd = "startproc" Тогда
			Если НЕ showdata = Неопределено Тогда
				Если Контроллеры.Получить(ДанныеВходящие.procid) = Неопределено Тогда
					ПортК = showdata;
					showdata = Неопределено;
					стрКонтроллер = Новый Структура("procid, Хост, Порт, ПортС, ПортВ, ПортД, ПортМ, УдаленныйУзел, Локальный, ПараметрХост, cmd", ДанныеВходящие.procid, Хост, ПортК, Порт, ПортВ, ПортД, ПортМ, "", Локальный, ПараметрХост, "init");
					Пока ПередатьДанные(Хост, ПортК, стрКонтроллер) = Неопределено Цикл
						Сообщить("Ошибка передачи параметров процессу.");
						Приостановить(50);
					КонецЦикла;
					Контроллеры.Вставить(ДанныеВходящие.procid, стрКонтроллер);
					Прервать;
				КонецЕсли;
			КонецЕсли;

		ИначеЕсли cmd = "termproc" Тогда
			Если ДанныеВходящие.Свойство("procid") Тогда // процесс завершен
				элКонтроллер = Контроллеры.Получить(ДанныеВходящие.procid);
				Если НЕ элКонтроллер = Неопределено Тогда
					Контроллеры.Удалить(ДанныеВходящие.procid);
				КонецЕсли;
				Продолжить;
			КонецЕсли;

		ИначеЕсли cmd = "startmorph" Тогда
			// Запуск сервера морфологии
			Если структЗадача.Запущен = Ложь Тогда
				структЗадача.Запущен = ЗапуститьПроцесс("useyourmind.exe morphserver.os", ПортМ);
			Иначе
				Продолжить;
			КонецЕсли;

		ИначеЕсли cmd = "startdata" Тогда
			// Запуск дата-сервера
			Если структЗадача.Запущен = Ложь Тогда
				структЗадача.Запущен = ЗапуститьПроцесс("useyourmind.exe dataserver.os", ПортД);
			Иначе
				Продолжить;
			КонецЕсли;

		ИначеЕсли cmd = "startweb" Тогда
			// Запуск веб-сервера
			Если структЗадача.Запущен = Ложь Тогда
				структЗадача.Запущен = ЗапуститьПроцесс("useyourmind.exe webserver.os", ПортВ, ПортЗ);
				// Передать параметры веб-сервера
			Иначе
				Если НЕ ПередатьДанные(Хост, ПортВ, Новый Структура("Хост, Порт, ПортС, ПортД, cmd", Хост, ПортВ, Порт, ПортД, "init")) = Неопределено Тогда
					Приостановить(50);
					Продолжить;
				КонецЕсли;
			КонецЕсли;

		ИначеЕсли cmd = "showdata" Тогда
			Если showdata = Неопределено Тогда // запустить процесс заранее
				Если НовыйПортК < 5555 Тогда
					НовыйПортК = ПортМ;
				КонецЕсли;
				НовыйПортК = НовыйПортК - 1;
				Пока НЕ ЗапуститьПроцесс("useyourmind.exe showdata.os", НовыйПортК) Цикл
					НовыйПортК = НовыйПортК - 1;
				КонецЦикла;
				showdata = НовыйПортК;
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
				Если cmd = "restartserver" Тогда
					ПерезапуститьПроцесс = Истина;
				КонецЕсли;
				ЗавершитьПроцесс = Истина;

			Иначе // завершаем один процесс
				Если ДанныеВходящие.Свойство("procid") Тогда
					элКонтроллер = Контроллеры.Получить(ДанныеВходящие.procid);
					Если НЕ элКонтроллер = Неопределено Тогда
						ПередатьДанные(элКонтроллер.Хост, элКонтроллер.Порт, Новый Структура("cmd, taskid", "termproc", "0"));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

			Продолжить;

		КонецЕсли;

		мЗадачи.Добавить(структЗадача);

	КонецЦикла;

	Соединение = TCPСервер.ПолучитьСоединение(Таймаут);
	Если НЕ Соединение = Неопределено Тогда
		Соединения.Вставить(0, Соединение);
		Таймаут = 5;
	КонецЕсли;

	к = Соединения.Количество();
	Пока к > 0 Цикл
		к = к - 1;
		Соединение = Соединения.Получить(0);
		Соединения.Удалить(0);

		Если Соединение.Статус = "Данные" Тогда

			Попытка
				ДанныеВходящие = Неопределено;
				ДанныеВходящие = ДвоичныеДанныеВСтруктуру(Соединение.ПолучитьДвоичныеДанные());
			Исключение
				Сообщить("starter: " + ОписаниеОшибки());
			КонецПопытки;

			Если ДанныеВходящие = Неопределено Тогда
				Продолжить;
			КонецЕсли;

			Если ДанныеВходящие.Свойство("cmd") Тогда // новая задача
				Сообщить("starter: " + cmd);
				мЗадачи.Добавить(Новый Структура("ДанныеВходящие", ДанныеВходящие));
			КонецЕсли;

			Соединение.Закрыть();
			Продолжить;

		ИначеЕсли Соединение.Статус = "Ошибка" Тогда

			Соединение.Закрыть();
			Продолжить;

		Иначе

			ПустойЦикл = ПустойЦикл + 1;

		КонецЕсли;

		Соединения.Добавить(Соединение);

	КонецЦикла;

	ВремяЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла;
	Если ВремяЦикла > 100 Тогда
		Сообщить("!starter ВремяЦикла=" + ВремяЦикла);
	КонецЕсли;
	Если Таймаут < 50 Тогда
		Таймаут = Таймаут + 1;
	КонецЕсли;

КонецЦикла;

Если Контроллеры.Количество() Тогда
	Сообщить("Не все контроллеры завершили работу.");
	Приостановить(200);
КонецЕсли;

TCPСервер.Остановить();

// Завершить сервер морфологии
с1 = ПередатьДанные(Хост, ПортМ, Новый Структура("cmd", "stopserver"));

// Завершить веб-сервер
с2 = ПередатьДанные(Хост, ПортВ, Новый Структура("cmd", "stopserver"));

// Завершить дата-сервер
с3 = ПередатьДанные(Хост, ПортД, Новый Структура("cmd", "stopserver"));

Пока с1.Статус = "Занят" ИЛИ с2.Статус = "Занят" ИЛИ с3.Статус = "Занят" Цикл
	Приостановить(50);
КонецЦикла;

Если ПерезапуститьПроцесс Тогда
	Сообщить("Перезапуск");
	ЗапуститьПроцесс("useyourmind.exe starter.os", Порт);
КонецЕсли;

Сообщить("Процесс starter завершен.");
