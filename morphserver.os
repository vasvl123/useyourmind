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
Перем Связи;
Перем свПуть;
Перем Запись;


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


Функция ОткрытьПоток(парЗапись)

	Если Запись = парЗапись Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запись = парЗапись;

	Если НЕ Связи = Неопределено Тогда
		Связи.Закрыть();
	КонецЕсли;

	Если Запись = 1 Тогда
		Связи =	ФайловыеПотоки.ОткрытьДляЗаписи(ОбъединитьПути(ТекущийКаталог(), "morph", "Связи.dat"));
	Иначе
		Связи =	ФайловыеПотоки.ОткрытьДляЧтения(ОбъединитьПути(ТекущийКаталог(), "morph", "Связи.dat"));
	КонецЕсли;

КонецФункции // ОткрытьПоток()


Функция ПолучитьЗначения(Знач н, Знач ф, мф = Неопределено, Все = Ложь, Первый = Истина)
	рез = Неопределено;
	буф = Новый БуферДвоичныхДанных(14);
	Пока Истина Цикл
		Связи.Перейти(н, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 14);
		ф1 = буф.ПрочитатьЦелое16(0);
		Если НЕ ф1 = 0 Тогда
			вн = буф.ПрочитатьЦелое32(6); // позиция вложенного
			Если НЕ вн = 0 И НЕ (ф1 = 9 И НЕ Все) Тогда // есть вложение
				рез = ПолучитьЗначения(вн, ф + Символ(ф1), мф, Все, Ложь);
			Иначе
				рез = ф + Символ(ф1);
				Если НЕ мф = Неопределено Тогда
					мф.Добавить(рез);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		н = буф.ПрочитатьЦелое32(2); // позиция следующего
		Если н = 0 ИЛИ Первый Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Возврат рез;
КонецФункции // ПолучитьЗначения()


Функция ПолучитьЗначение(н)

	гр = "";
	буф = Новый БуферДвоичныхДанных(14);

	ОткрытьПоток(0);

	Пока Истина Цикл
		Связи.Перейти(н, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 14);
		ф = буф.ПрочитатьЦелое16(0);
		н = буф.ПрочитатьЦелое32(10); // позиция родителья
		Если н = 0 Тогда // это первый
			Прервать;
		КонецЕсли;
		гр = Символ(ф) + гр;
	КонецЦикла;

	Возврат гр;

КонецФункции // ПолучитьЗначение()


Функция НайтиЗначение(в, Знач нгр)

	нгр = Символ(в) + нгр;
	сгр = СтрДлина(нгр);

	// пройти по дереву

	буф = Новый БуферДвоичныхДанных(14);

	ОткрытьПоток(0);

	н = 0;
	к = 1;

	Пока Истина Цикл
		ф = КодСимвола(Сред(нгр, к, 1));
		Пока Истина Цикл
			Связи.Перейти(н, ПозицияВПотоке.Начало);
			Связи.Прочитать(буф, 0, 14);
			ф1 = буф.ПрочитатьЦелое16(0);
			Если ф1 = ф ИЛИ ф = 42 Тогда  // найден элемент
				Если ф = 42 Тогда // *
					Если ф1 = КодСимвола(Сред(нгр, к + 1, 1)) Тогда
						к = к + 1;
					КонецЕсли;
				Иначе
					к = к + 1;
				КонецЕсли;
				Если НЕ к > сгр Тогда
					н = буф.ПрочитатьЦелое32(6); // позиция вложенного
				КонецЕсли;
				Прервать;
			КонецЕсли;
			н = буф.ПрочитатьЦелое32(2); // позиция следующего
			Если н = 0 ИЛИ к > сгр Тогда // это последний
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если н = 0 ИЛИ к > сгр Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Возврат н;

КонецФункции // НайтиЗначение()


Функция УдалитьЗначение(в, Знач нгр)

	// пройти по дереву

	нгр = Символ(в) + нгр;
	сгр = СтрДлина(нгр);

	буф = Новый БуферДвоичныхДанных(14);

	ОткрытьПоток(0);

	н = 0; // текущий символ
	пн = Неопределено;  // первый символ
	к = 1;

	Связи.Перейти(0, ПозицияВПотоке.Начало);

	Пока Истина Цикл
		ф = КодСимвола(Сред(нгр, к, 1));
		Пока Истина Цикл
			Связи.Перейти(н, ПозицияВПотоке.Начало);
			Связи.Прочитать(буф, 0, 14);
			ф1 = буф.ПрочитатьЦелое16(0);
			нн = буф.ПрочитатьЦелое32(2); // позиция следующего
			Если ф1 = ф Тогда // найден элемент
				Если пн = Неопределено Тогда
					пн = н;
				КонецЕсли;
				к = к + 1;
				нн = буф.ПрочитатьЦелое32(6); // позиция вложенного
				Прервать;
			КонецЕсли;
			Если нн = 0 ИЛИ к > сгр Тогда // это последний
				Прервать;
			КонецЕсли;
			н = нн;
		КонецЦикла;
		Если нн = 0 ИЛИ к > сгр Тогда
			Прервать;
		КонецЕсли;
		Если ф = 9 Тогда // начало нового элемента
			пн = Неопределено;
		КонецЕсли;
		н = нн;
	КонецЦикла;

	Если НЕ пн = Неопределено И к > сгр Тогда
		Связи.Перейти(пн, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 14);
		буф.ЗаписатьЦелое16(0, 0);
		ОткрытьПоток(1);
		Связи.Перейти(пн, ПозицияВПотоке.Начало);
		Связи.Записать(буф, 0, 14);
		Связи.СброситьБуферы();
	КонецЕсли;

КонецФункции // УдалитьЗначение()


Функция ДобавитьЗначение(в, Знач гр)

	// пройти по дереву
	ОткрытьПоток(0);
	буф = Новый БуферДвоичныхДанных(14);

	н = 0;
	к = 1;
	рн = 0;

	гр = Символ(в) + гр;

	сгр = СтрДлина(гр);

	Если НЕ Связи.Размер() = 0 Тогда

		Пока Истина Цикл
			ф = КодСимвола(Сред(гр, к, 1));
			Пока Истина Цикл
				Связи.Перейти(н, ПозицияВПотоке.Начало);
				Связи.Прочитать(буф, 0, 14);
				ф1 = буф.ПрочитатьЦелое16(0);
				нн = буф.ПрочитатьЦелое32(2); // позиция следующего
				Если ф1 = ф Тогда  // найден элемент
					рн = н;
					к = к + 1;
					Если НЕ к > сгр Тогда
						нн = буф.ПрочитатьЦелое32(6); // позиция вложенного
						Если нн = 0 Тогда // создать ссылку на вложенный
							ОткрытьПоток(1);
							кн = Связи.Размер();
							буф.ЗаписатьЦелое32(6, кн); // вложенный в конец
							Связи.Перейти(н, ПозицияВПотоке.Начало);
							Связи.Записать(буф, 0, 14);
							//Связи.СброситьБуферы();
						КонецЕсли;
					КонецЕсли;
					Прервать;
				КонецЕсли;
				нн = буф.ПрочитатьЦелое32(2); // позиция следующего
				Если нн = 0 Тогда // это последний
					ОткрытьПоток(1);
					кн = Связи.Размер();
					буф.ЗаписатьЦелое32(2, кн); // соседний в конец
					Связи.Перейти(н, ПозицияВПотоке.Начало);
					Связи.Записать(буф, 0, 14);
					//Связи.СброситьБуферы();
					Прервать;
				КонецЕсли;
				н = нн;
			КонецЦикла;
			Если нн = 0 ИЛИ к > сгр Тогда
				Прервать;
			КонецЕсли;
			н = нн;
		КонецЦикла;

	КонецЕсли;

	Если НЕ к > сгр Тогда

		// создать новые элементы
		ОткрытьПоток(1);

		Для к = к по сгр Цикл
			ф = КодСимвола(Сред(гр, к, 1));
			Связи.Перейти(0, ПозицияВПотоке.Конец);
			н = Связи.ТекущаяПозиция();
			Если НЕ к = сгр Тогда
				кн = н + 14;
			Иначе
				кн = 0;
			КонецЕсли;
			буф.ЗаписатьЦелое16(0, ф); // код символа
			буф.ЗаписатьЦелое32(2, 0); // нет соседнего
			буф.ЗаписатьЦелое32(6, кн); // вложенный в конец
			буф.ЗаписатьЦелое32(10, рн); // родитель
			Связи.Записать(буф, 0, 14);
			рн = н;
		КонецЦикла;

		Связи.СброситьБуферы();

	КонецЕсли;

	Возврат н;

КонецФункции // ДобавитьЗначение()


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

		Сообщить(слф);

		н = НайтиЗначение(1, слф);

		Если НЕ н = 0 Тогда

			н = НайтиЗначение(3, "" + н + Символы.Таб);

			Если НЕ н = 0 Тогда

				мф = Новый Массив;
				ПолучитьЗначения(н, "", мф, Истина);

				Для каждого г2 Из мф Цикл
					мг2 = СтрРазделить(г2, Символы.Таб);
					сЛемма = ПолучитьЗначение(мг2[1]);
					нФорма = ПолучитьЗначение(мг2[2]);
					нЛемма = ПолучитьЗначение(мг2[3]);
					рез = рез + ?(рез = "", "", Символы.ПС) + слф + Символы.Таб + сЛемма + Символы.Таб + нФорма + Символы.Таб + нЛемма;
				КонецЦикла;

			КонецЕсли;
		КонецЕсли;

		Если рез = "" Тогда // форма слова не найдена
			Если СтрНайти(слф, "Ё") = 0 Тогда // е заменить на ё
				Для н = 1 по СтрДлина(слф) Цикл
					Если Сред(слф, н, 1) = "Е" Тогда
						структЗадача.Запрос.Слова = структЗадача.Запрос.Слова + Символы.ПС + Лев(слф, н - 1) + "Ё" + Сред(слф, н + 1);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		структЗадача.Результат.Вставить("s_" + структЗадача.Результат.Количество(), Новый Структура("Слово, Результат", сл, рез));

		Возврат Ложь;

	ИначеЕсли Команда = "Связи" Тогда

		мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

		Для каждого бигр Из мСлова Цикл

			мб = СтрРазделить(бигр, Символы.Таб);

			ток1имя = мб[0];
			ток1нач = ДобавитьЗначение(1, мб[1]);
			ток1гр = ДобавитьЗначение(2, мб[2]);
			свимя = мб[3];
			ток2имя = мб[4];
			ток2нач = ДобавитьЗначение(1, мб[5]);
			ток2гр = ДобавитьЗначение(2, мб[6]);
			р = мб[7];

			Если р = "" Тогда // удалить связь

				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя);

				УдалитьЗначение(5, св);

			ИначеЕсли р = "г" Тогда // удалить грамматику

				// удалить грамматику
				гр = "" +
					ток1гр + Символы.Таб +
					ток2гр + Символы.Таб +
					ВРег(свимя);

				УдалитьЗначение(4, гр);

				// удалить связь
				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя);

				УдалитьЗначение(5, св);

			ИначеЕсли р = "+" Тогда // добавить корректную связь

				// удалить некорректную связь
				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя) + Символы.Таб +
					"-";

				УдалитьЗначение(5, св);

				// добавить грамматику
				гр = "" +
					ток1гр + Символы.Таб +
					ток2гр + Символы.Таб +
					ВРег(свимя);

				ДобавитьЗначение(4, гр);

				// добавить связь
				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя) + Символы.Таб +
					р;

				ДобавитьЗначение(5, св);

			ИначеЕсли р = "-" Тогда // добавить некорректную биграмму

				// удалить корректную связь
				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя) + Символы.Таб +
					"+";

				УдалитьЗначение(5, св);

				// добавить связь
				св = "" +
					ток1нач + Символы.Таб +
					ток2нач + Символы.Таб +
					ВРег(свимя) + Символы.Таб +
					р;

				ДобавитьЗначение(5, св);

			КонецЕсли;

			структЗадача.Результат.Вставить(ток1имя + "_" + ток2имя, р);

		КонецЦикла;

		Возврат Истина;

	ИначеЕсли Команда = "Грамматики" Тогда

		сгр = Новый Соответствие;

		сл = структЗадача.Запрос.Слова;

		мсл = СтрРазделить(сл, Символы.ПС);

		Для каждого гр Из мсл Цикл

			мгр = СтрРазделить(гр, Символы.Таб);

			ток1гр = ДобавитьЗначение(2, мгр[0]);
			ток2гр = ДобавитьЗначение(2, мгр[1]);
			ток1нач = ДобавитьЗначение(1, мгр[2]);
			ток2нач = ДобавитьЗначение(1, мгр[3]);

			Если НЕ сгр.Получить(гр) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			сгр.Вставить(гр, "");

			н = НайтиЗначение(4, "" + ток1гр + Символы.Таб + ток2гр + Символы.Таб);

			Если НЕ н = 0 Тогда // найдено совпадение по образцу
				мф = Новый Массив;
				ПолучитьЗначения(н, "", мф);
				Для каждого г2 Из мф Цикл

					б = "";

					// найти связь
					нсв = "" +
						ток1нач + Символы.Таб +
						ток2нач + Символы.Таб +
						ВРег(г2) + Символы.Таб;

					н = НайтиЗначение(5, нсв);

					Если НЕ н = 0 Тогда // найдено совпадение по образцу
						св = ПолучитьЗначения(н, "");
						Если НЕ св = Неопределено Тогда
							б = св;
						КонецЕсли;
					КонецЕсли;

					структЗадача.Результат.Вставить("гр_" + структЗадача.Результат.Количество(), гр + "_" + г2 + Символы.Таб + б);

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

	свПуть = ОбъединитьПути(ТекущийКаталог(), "morph", "Связи.dat");

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

	Если НЕ Связи = Неопределено Тогда
		Связи.Закрыть();
	КонецЕсли;

	TCPСервер.Остановить();
	Сообщить("Завершил работу сервера морфологии.");

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбработатьСоединения();
