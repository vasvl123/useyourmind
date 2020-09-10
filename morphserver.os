// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/

Перем Хост, Порт;
Перем ОстановитьСервер;
Перем МоментЗапуска;
Перем Задачи;
Перем Соединения;
Перем СоединенияП;
Перем Леммы;
Перем Связи;
Перем НачальныеФормы;
Перем Правила;


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


Функция ПередатьДанные(Хост, Порт, стрДанные) Экспорт
	Попытка
		Соединение = Новый TCPСоединение(Хост, Порт);
		Соединение.ТаймаутОтправки = 5000;
		Соединение.ОтправитьДвоичныеДанныеАсинхронно(СтруктуруВДвоичныеДанные(стрДанные));
		//Соединение.Закрыть();
		СоединенияП.Вставить(Соединение, Истина);
		Возврат Соединение;
	Исключение
		Сообщить(ОписаниеОшибки());
		Если Соединение = Неопределено Тогда
			Сообщить("dataserver: Хост недоступен: " + Хост + ":" + Порт);
		Иначе
			Соединение.Закрыть();
			Соединение = Неопределено;
		КонецЕсли;
	КонецПопытки;
	Возврат Соединение;
КонецФункции // ПередатьДанные()


Функция ВыполнитьЗадачу(структЗадача)

	Перем Команда;

	структЗадача.Запрос.Свойство("cmd", Команда);

	Если Команда = "stopserver" Тогда
		ОстановитьСервер = Истина;
		Возврат Ложь;
	КонецЕсли;

	мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

	Если структЗадача.Результат.Количество() = мСлова.Количество() Тогда
		Возврат Истина;
	КонецЕсли;

	сл = мСлова.Получить(структЗадача.Результат.Количество());
	слф = ВРег(сл);
	рез = "";

	Для н = 0 по стрДлина(слф) Цикл

		Если н > 0 Тогда
			ок = Прав(слф, н);
			нач = Лев(слф, СтрДлина(слф) - н);

			к = 0;
			Пока Истина Цикл
				фс = Правила.Получить(ок + "_" + к);
				Если фс = Неопределено Тогда
					Прервать;
				КонецЕсли;
				фс = СтрРазделить(фс, Символы.Таб);
				м = 0;
				Пока Истина Цикл
					нф = НачальныеФормы.Получить(нач + фс[0] + "_" + м);
					Если нф = Неопределено Тогда
						Прервать;
					КонецЕсли;
					л = 0;
					Пока Истина Цикл
						нф1 = Связи.Получить(фс[1] + "_" + л);
						Если нф1 = Неопределено Тогда
							Прервать;
						КонецЕсли;
						Если нф1 = нф Тогда
							рез = рез + ?(рез = "", "", Символы.ПС) + слф + Символы.Таб + Леммы.Получить(Число(фс[1])) + Символы.Таб + нач + фс[0] + Символы.Таб + Леммы.Получить(Число(нф));
						КонецЕсли;
						л = л + 1;
					КонецЦикла;
					м = м + 1;
				КонецЦикла;
				к = к + 1;
			КонецЦикла;

		Иначе

			м = 0;
			Пока Истина Цикл
				нф = НачальныеФормы.Получить(слф + "_" + м);
				Если нф = Неопределено Тогда
					Прервать;
				КонецЕсли;
				рез = рез + ?(рез = "", "", Символы.ПС) + слф + Символы.Таб + Леммы.Получить(Число(нф));
				м = м + 1;
			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

	структЗадача.Результат.Вставить("s_" + структЗадача.Результат.Количество(), Новый Структура("Слово, Результат", сл, рез));

	Возврат Ложь;

КонецФункции


Процедура ОбработатьСоединения() Экспорт

	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = Число(АргументыКоманднойСтроки[0]);
	Иначе
		Порт = 8886;
	КонецЕсли;

	Таймаут = 50;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.ЗапуститьАсинхронно();

	Сообщить(СокрЛП(ТекущаяДата()) + " Сервер морфологии запущен на порту: " + Порт);

	Леммы = Новый Соответствие;
	ф = Новый ЧтениеТекста("Леммы.txt");
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Леммы.Вставить(Число(зн), кл);
	КонецЦикла;
	Сообщить("Прочитал Леммы");

	Связи = Новый Соответствие;
	ф = Новый ЧтениеТекста("Связи.txt");
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Связи.Вставить(кл, Число(зн));
	КонецЦикла;
	Сообщить("Прочитал Связи");

	НачальныеФормы = Новый Соответствие;
	ф = Новый ЧтениеТекста("НачальныеФормы.txt");
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Если НЕ зн = "" Тогда
			НачальныеФормы.Вставить(кл, Число(зн));
		КонецЕсли;
	КонецЦикла;
	Сообщить("Прочитал НачальныеФормы");

	Правила = Новый Соответствие;
	ф = Новый ЧтениеТекста("Правила.txt");
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Правила.Вставить(кл, зн);
	КонецЦикла;
	Сообщить("Прочитал Правила");

	ф = Неопределено;

	Задачи = Новый Соответствие;

	ОстановитьСервер = Ложь;
	ПерезапуститьСервер = Ложь;
	Соединение = Неопределено;

	Соединения = Новый Соответствие();
	СоединенияП = Новый Соответствие();

	СуммаЦиклов = 0;
	РабочийЦикл = 0;
	ЗамерВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();

	Пока НЕ ОстановитьСервер Цикл

		НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();
		СуммаЦиклов = СуммаЦиклов + 1;

		Если СуммаЦиклов > 999 Тогда
			ПредЗамер = ЗамерВремени;
			ЗамерВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
			Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(1000 * РабочийЦикл / (ЗамерВремени - ПредЗамер)) + " q/s " + Задачи.Количество() + " tasks";
			СуммаЦиклов = 0;
			РабочийЦикл = 0;
		КонецЕсли;

		ВремяЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла;
		Если ВремяЦикла > 100 Тогда
			Сообщить("!morphserver ВремяЦикла=" + ВремяЦикла);
		КонецЕсли;
		НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();

		Если Задачи.Количество() Тогда
			ПереченьЗадач = Новый СписокЗначений;
			Для каждого элЗадача Из Задачи Цикл
				ПереченьЗадач.Добавить(ЭлЗадача.Значение, элЗадача.Ключ);
			КонецЦикла;
			ПереченьЗадач.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
			Для каждого элПеречень Из ПереченьЗадач Цикл
				структЗадача = элПеречень.Значение;
				ЕстьРезультат = Ложь;
				РабочийЦикл = РабочийЦикл + 1;
				Попытка
					ЕстьРезультат = ВыполнитьЗадачу(структЗадача);
				Исключение
					Сообщить(ОписаниеОшибки());
				КонецПопытки;
				Если ЕстьРезультат = Истина Тогда
					Попытка
						ОбратныйЗапрос = "";
						Если структЗадача.Запрос.Свойство("ОбратныйЗапрос", ОбратныйЗапрос) Тогда // возвращаем результат
							ОбратныйЗапрос.Вставить("РезультатДанные", Новый Структура("Ответ, Результат", структЗадача.Ответ, структЗадача.Результат));
							Если ПередатьДанные(ОбратныйЗапрос.Хост, ОбратныйЗапрос.Порт, ОбратныйЗапрос) = Неопределено Тогда
								Продолжить;
							КонецЕсли;
							Сообщить("morphserver " + ТекущаяДата() + " time=" + (ТекущаяДата() - структЗадача.ВремяНачало) + Загрузка);
							структЗадача.Результат = Неопределено;
						КонецЕсли;
					Исключение
						Сообщить(ОписаниеОшибки());
					КонецПопытки;
					Задачи.Удалить(структЗадача.ИдЗадачи);
					//Сообщить("morphserver: всего задач " + Задачи.Количество());
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		Соединение = TCPСервер.ПолучитьСоединение(Таймаут);

		Если НЕ Соединение = Неопределено Тогда

			//Соединение.ТаймаутОтправки = 5000;
			Соединение.ТаймаутЧтения = 5000;

			Соединение.ПрочитатьДвоичныеДанныеАсинхронно();
			Соединения.Вставить(Соединение, Новый Массив);

		КонецЕсли;

		Для каждого зСоединение Из Соединения Цикл
			Соединение = зСоединение.Ключ;
			мДанные = зСоединение.Значение;
			Если Соединение.Статус = "Успех" Тогда

				Попытка
					Запрос = Неопределено;
					дд = Соединение.ПолучитьДвоичныеДанные();
					Если НЕ дд.Размер() = 0 Тогда
						мДанные.Добавить(дд);
						Запрос = ДвоичныеДанныеВСтруктуру(СоединитьДвоичныеДанные(мДанные));
					КонецЕсли;
				Исключение
					Сообщить("morphserver: " + ОписаниеОшибки());
				КонецПопытки;

				Если Запрос = Неопределено Тогда
					//Соединения.Вставить(Соединение, мДанные);
					Продолжить;
				КонецЕсли;

				Если НЕ Запрос = Неопределено Тогда
					структЗадача = Новый Структура("ИдЗадачи, Запрос, Ответ, Результат, ВремяНачало", ПолучитьИД(), Запрос, Неопределено, Новый Структура(), ТекущаяДата());
					Задачи.Вставить(структЗадача.ИдЗадачи, структЗадача);
					//Сообщить("dataserver: всего задач " + Задачи.Количество());
				КонецЕсли;

				Соединение.Закрыть();
				Соединения.Удалить(Соединение);
				Прервать;

			ИначеЕсли Соединение.Статус = "Ошибка" Тогда

				Соединения.Удалить(Соединение);
				Прервать;

			Иначе

			КонецЕсли;

		КонецЦикла;

		Для каждого зСоединение Из СоединенияП Цикл
			Соединение = зСоединение.Ключ;
			Если НЕ Соединение.Статус = "Занят" Тогда
				Соединение.Закрыть();
				СоединенияП.Удалить(Соединение);
				Прервать;
			КонецЕсли;
		КонецЦикла;

		ВремяЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла;
		Если ВремяЦикла > 100 Тогда
			Сообщить("!morphserver ВремяЦикла=" + ВремяЦикла);
		КонецЕсли;
		Таймаут = ?(ВремяЦикла > 10, 0, 50);

	КонецЦикла;

	TCPСервер.Остановить();
	Сообщить("Завершил работу сервера морфологии.");

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбработатьСоединения();
