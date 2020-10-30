// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/

Перем Хост, Порт;
Перем ОстановитьСервер;
Перем МоментЗапуска;
Перем Задачи, мЗадачи;
Перем Соединения;
Перем Леммы;
Перем Связи;
Перем НачальныеФормы;
Перем Правила;
Перем Биграммы;
Перем Грамматики;

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

	ИначеЕсли Команда = "ФормыСлов" Тогда

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

	ИначеЕсли Команда = "Биграммы" Тогда

		мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

		Для каждого бигр Из мСлова Цикл

			мб = СтрРазделить(бигр, Символы.Таб);

			ток1имя = мб[0];
			ток1нач = мб[1];

			мс = Биграммы.Получить(ток1нач); // начальная форма
			Если мс = Неопределено Тогда
				мс = Новый Массив;
				Биграммы.Вставить(ток1нач, мс);
			КонецЕсли;

			р = "";
			Если мб.Количество() = 8 Тогда

				ток1гр = мб[2];
				свимя = мб[3];
				ток2имя = мб[4];
				ток2нач = мб[5];
				ток2гр = мб[6];
				р = мб[7];

				Если р = "+" Тогда // добавить корректную биграмму
					Если мс.Найти(ток2нач) = Неопределено Тогда
						мс.Добавить(ток2нач);
					КонецЕсли;
					// удалить из некорректных
					п = мс.Найти("_" + ток2нач);
					Если НЕ п = Неопределено Тогда
						мс.Удалить(п);
					КонецЕсли;

					// добавить грамматику
					г1 = Грамматики.Получить(ток1гр);
					Если г1 = Неопределено Тогда
						г1 = Новый Массив;
						г1.Добавить(свимя);
						Грамматики.Вставить(ток1гр, г1);
					ИначеЕсли г1.Найти(свимя) = Неопределено Тогда
						г1.Добавить(свимя);
					КонецЕсли;
					г2 = Грамматики.Получить(свимя);
					Если г2 = Неопределено Тогда
						г2 = Новый Массив;
						г2.Добавить(ток2гр);
						Грамматики.Вставить(свимя, г2);
					ИначеЕсли г2.Найти(ток2гр) = Неопределено Тогда
						г2.Добавить(ток2гр);
					КонецЕсли;

				ИначеЕсли р = "-" Тогда // добавить некорректную биграмму
					Если мс.Найти("_" + ток2нач) = Неопределено Тогда
						мс.Добавить("_" + ток2нач);
					КонецЕсли;
					// удалить из корректных
					п = мс.Найти(ток2нач);
					Если НЕ п = Неопределено Тогда
						мс.Удалить(п);
					КонецЕсли;
				КонецЕсли;

			Иначе // найти биграмму

				ток2имя = мб[2];
				ток2нач = мб[3];

				Если НЕ мс.Найти(ток2нач) = Неопределено Тогда
					р = "+";
				ИначеЕсли НЕ мс.Найти("_" + ток2нач) = Неопределено Тогда
					р = "-";
				КонецЕсли;

			КонецЕсли;

			структЗадача.Результат.Вставить(ток1имя + "_" + ток2имя, р);

		КонецЦикла;

		Возврат Истина;

	ИначеЕсли Команда = "Грамматики" Тогда

		мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

		Для каждого гр Из мСлова Цикл

			мгр = СтрРазделить(гр, Символы.Таб);

			ток1нач = мгр[0];
			ток2нач = мгр[1];

			г1 = Грамматики.Получить(ток1нач);
			Если НЕ г1 = Неопределено Тогда
				Для каждого г2 Из г1 Цикл
					г3 = Грамматики.Получить(г2);
					Для каждого г4 Из г3 Цикл
						Если г4 = ток2нач Тогда
							структЗадача.Результат.Вставить("гр_" + структЗадача.Результат.Количество(), гр + "_" + г2);
							Прервать;
						КонецЕсли;
					КонецЦикла;
				КонецЦикла;
			КонецЕсли;

		КонецЦикла;

		Возврат Истина;

	КонецЕсли;

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
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Леммы.txt"));
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Леммы.Вставить(Число(зн), кл);
	КонецЦикла;
	Сообщить("Прочитал Леммы");
	ф.Закрыть();

	Связи = Новый Соответствие;
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Связи.txt"));
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Связи.Вставить(кл, Число(зн));
	КонецЦикла;
	Сообщить("Прочитал Связи");
	ф.Закрыть();

	НачальныеФормы = Новый Соответствие;
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "НачальныеФормы.txt"));
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
	ф.Закрыть();

	Правила = Новый Соответствие;
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Правила.txt"));
	Пока Истина Цикл
		кл = ф.ПрочитатьСтроку();
		Если кл = Неопределено Тогда
			Прервать;
		КонецЕсли;
		зн = ф.ПрочитатьСтроку();
		Правила.Вставить(кл, зн);
	КонецЦикла;
	Сообщить("Прочитал Правила");
	ф.Закрыть();

	Биграммы = Новый Соответствие;
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Биграммы.txt"));
	ф.ПрочитатьСтроку();
	Пока Истина Цикл
		гр1 = ф.ПрочитатьСтроку();
		Если гр1 = Неопределено Тогда
			Прервать;
		КонецЕсли;
		мгр = Новый Массив();
		гр2 = "" + ф.ПрочитатьСтроку();
		Пока НЕ гр2 = "" Цикл
			мгр.Добавить(гр2);
			гр2 = "" + ф.ПрочитатьСтроку();
		КонецЦикла;
		Биграммы.Вставить(гр1, мгр);
	КонецЦикла;
	Сообщить("Прочитал Биграммы");
	ф.Закрыть();

	Грамматики = Новый Соответствие;
	ф = Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Грамматики.txt"));
	ф.ПрочитатьСтроку();
	Пока Истина Цикл
		гр1 = ф.ПрочитатьСтроку();
		Если гр1 = Неопределено Тогда
			Прервать;
		КонецЕсли;
		мгр = Новый Массив();
		гр2 = "" + ф.ПрочитатьСтроку();
		Пока НЕ гр2 = "" Цикл
			мгр.Добавить(гр2);
			гр2 = "" + ф.ПрочитатьСтроку();
		КонецЦикла;
		Грамматики.Вставить(гр1, мгр);
	КонецЦикла;
	Сообщить("Прочитал Грамматики");
	ф.Закрыть();

	Задачи = Новый Соответствие;
	мЗадачи = Новый Массив;

	ОстановитьСервер = Ложь;
	ПерезапуститьСервер = Ложь;
	Соединение = Неопределено;

	Соединения = Новый Массив();

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

		к = мЗадачи.Количество();
		Пока к > 0 И НЕ ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла > 50 Цикл
			к = к - 1;
			структЗадача = мЗадачи.Получить(0);
			мЗадачи.Удалить(0);

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
				Продолжить;
			КонецЕсли;

			мЗадачи.Добавить(структЗадача);

		КонецЦикла;

		т = Таймаут;
		Пока Истина Цикл
			Соединение = TCPСервер.ПолучитьСоединение(т);
			Если Соединение = Неопределено Тогда
				Прервать;
			КонецЕсли;
			Соединения.Вставить(0, Соединение);
			т = 0;
		КонецЦикла;

		к = Соединения.Количество();
		Пока к > 0 Цикл
			к = к - 1;
			Соединение = Соединения.Получить(0);
			Соединения.Удалить(0);

			Если Соединение.Статус = "Успех" Тогда

				Попытка
					Запрос = Неопределено;
					Запрос = ДвоичныеДанныеВСтруктуру(Соединение.ПолучитьДвоичныеДанные());
				Исключение
					Сообщить("morphserver: " + ОписаниеОшибки());
				КонецПопытки;

				Если НЕ Запрос = Неопределено Тогда
					структЗадача = Новый Структура("ИдЗадачи, Запрос, Ответ, Результат, ВремяНачало", ПолучитьИД(), Запрос, Неопределено, Новый Структура(), ТекущаяДата());
					Задачи.Вставить(структЗадача.ИдЗадачи, структЗадача);
					мЗадачи.Добавить(структЗадача);
					//Сообщить("dataserver: всего задач " + Задачи.Количество());
				КонецЕсли;

				Соединение.Закрыть();
				Продолжить;

			ИначеЕсли Соединение.Статус = "Ошибка" Тогда

				Соединение.Закрыть();
				Продолжить;

			КонецЕсли;

			Соединения.Добавить(Соединение);

		КонецЦикла;

		ВремяЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла;
		Если ВремяЦикла > 100 Тогда
			Сообщить("!morphserver ВремяЦикла=" + ВремяЦикла);
		КонецЕсли;
		Таймаут = ?(ВремяЦикла > 50, 0, 30);

	КонецЦикла;

	// Записать Биграммы
	ф = Новый ЗаписьТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Биграммы.txt"));
	Для каждого бгр Из Биграммы Цикл
		ф.ЗаписатьСтроку("");
		ф.ЗаписатьСтроку(бгр.Ключ);
		кол = бгр.Значение.Количество();
		Пока кол > 0 Цикл
			кол = кол - 1;
			ф.ЗаписатьСтроку(бгр.Значение[кол]);
		КонецЦикла;
	КонецЦикла;
	Сообщить("Записал Биграммы");
	ф.Закрыть();

	// Записать Грамматики
	ф = Новый ЗаписьТекста(ОбъединитьПути(ТекущийКаталог(), "morph", "Грамматики.txt"));
	Для каждого гр Из Грамматики Цикл
		ф.ЗаписатьСтроку("");
		ф.ЗаписатьСтроку(гр.Ключ);
		кол = гр.Значение.Количество();
		Пока кол > 0 Цикл
			кол = кол - 1;
			ф.ЗаписатьСтроку(гр.Значение[кол]);
		КонецЦикла;
	КонецЦикла;
	Сообщить("Записал Грамматики");
	ф.Закрыть();

	TCPСервер.Остановить();
	Сообщить("Завершил работу сервера морфологии.");

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбработатьСоединения();
