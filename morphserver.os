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


Функция МассивИзСтроки(стр);
	м = Новый Массив();
	дстр = СтрДлина(стр);
	Для н = 1 По дстр Цикл
		м.Добавить(КодСимвола(Сред(стр, н, 1)));
	КонецЦикла;
	Возврат м;
КонецФункции // МассивИзСтроки()


Функция ДобавитьЗначение(гр)

	// пройти по дереву
	ОткрытьПоток(0);
	буф = Новый БуферДвоичныхДанных(16);

	н = 0;
	к = 1;
	рн = 0;

	сгр = гр.Количество();

	Если НЕ Связи.Размер() = 0 Тогда

		Пока Истина Цикл
			ф = гр.Получить(к - 1);
			Пока Истина Цикл
				Связи.Перейти(н, ПозицияВПотоке.Начало);
				Связи.Прочитать(буф, 0, 16);
				ф1 = буф.ПрочитатьЦелое32(0);
				нн = буф.ПрочитатьЦелое32(4); // позиция следующего
				Если ф1 = ф Тогда  // найден элемент
					рн = н;
					к = к + 1;
					Если НЕ к > сгр Тогда
						нн = буф.ПрочитатьЦелое32(8); // позиция вложенного
						Если нн = 0 Тогда // создать ссылку на вложенный
							ОткрытьПоток(1);
							кн = Связи.Размер();
							буф.ЗаписатьЦелое32(8, кн); // вложенный в конец
							Связи.Перейти(н, ПозицияВПотоке.Начало);
							Связи.Записать(буф, 0, 14);
							//Связи.СброситьБуферы();
						КонецЕсли;
					КонецЕсли;
					Прервать;
				КонецЕсли;
				нн = буф.ПрочитатьЦелое32(4); // позиция следующего
				Если нн = 0 Тогда // это последний
					ОткрытьПоток(1);
					кн = Связи.Размер();
					буф.ЗаписатьЦелое32(4, кн); // соседний в конец
					Связи.Перейти(н, ПозицияВПотоке.Начало);
					Связи.Записать(буф, 0, 16);
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
			ф = гр.Получить(к - 1);
			Связи.Перейти(0, ПозицияВПотоке.Конец);
			н = Связи.ТекущаяПозиция();
			Если НЕ к = сгр Тогда
				кн = н + 16;
			Иначе
				кн = 0;
			КонецЕсли;
			буф.ЗаписатьЦелое32(0, ф); // код символа
			буф.ЗаписатьЦелое32(4, 0); // нет соседнего
			буф.ЗаписатьЦелое32(8, кн); // вложенный в конец
			буф.ЗаписатьЦелое32(12, рн); // родитель
			Связи.Записать(буф, 0, 16);
			рн = н;
		КонецЦикла;

		Связи.СброситьБуферы();

	КонецЕсли;

	Возврат н;

КонецФункции // ДобавитьЗначение()


Функция ПолучитьЗначения(Знач н)
	буф = Новый БуферДвоичныхДанных(16);
	ОткрытьПоток(0);
	Связи.Перейти(н, ПозицияВПотоке.Начало);
	Связи.Прочитать(буф, 0, 16);
	вн = буф.ПрочитатьЦелое32(8); // позиция вложенного
	мр = Новый Массив;
	н = вн;
	Пока Истина Цикл
		Если н = 0 Тогда
			Прервать;
		КонецЕсли;
		Связи.Перейти(н, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 16);
		ф = буф.ПрочитатьЦелое32(0);
		сн = буф.ПрочитатьЦелое32(4);
		мф = Новый Массив;
		мф.Добавить(ф);
		мф.Добавить(н);
		мр.Добавить(мф);
		н = сн;
	КонецЦикла;
	Возврат мр;
КонецФункции // ПолучитьЗначения()


Функция ПолучитьСтроку(Знач н)

	гр = "";
	буф = Новый БуферДвоичныхДанных(16);

	ОткрытьПоток(0);

	Пока Истина Цикл
		Связи.Перейти(н, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 16);
		ф = буф.ПрочитатьЦелое32(0);
		н = буф.ПрочитатьЦелое32(12); // позиция родителя
		Если н = 0 Тогда // это первый
			Прервать;
		КонецЕсли;
		гр = Символ(ф) + гр;
	КонецЦикла;

	Возврат гр;

КонецФункции // ПолучитьСтроку()


Функция НайтиЗначение(нгр, Знач н = 0)

	буф = Новый БуферДвоичныхДанных(16);

	ОткрытьПоток(0);

	Если НЕ н = 0 Тогда // искать внутри
		Связи.Перейти(н, ПозицияВПотоке.Начало);
		Связи.Прочитать(буф, 0, 16);
		н = буф.ПрочитатьЦелое32(8); // позиция вложенного
		Если н = 0 Тогда
			Возврат н;
		КонецЕсли;
	КонецЕсли;

	Если НЕ ТипЗнч(нгр) = Тип("Массив") Тогда
		зн = нгр;
		нгр = Новый Массив;
		нгр.Добавить(зн);
	КонецЕсли;

	сгр = нгр.Количество();

	// пройти по дереву

	к = 1;

	Пока Истина Цикл
		ф = нгр.Получить(к - 1);
		Пока Истина Цикл
			Связи.Перейти(н, ПозицияВПотоке.Начало);
			Связи.Прочитать(буф, 0, 16);
			ф1 = буф.ПрочитатьЦелое32(0);
			Если ф1 = ф ИЛИ ф = 42 Тогда  // найден элемент
				Если ф = 42 Тогда // *
					Если ф1 = нгр.Получить(к + 1) Тогда
						к = к + 1;
					КонецЕсли;
				Иначе
					к = к + 1;
				КонецЕсли;
				Если НЕ к > сгр Тогда
					н = буф.ПрочитатьЦелое32(8); // позиция вложенного
				КонецЕсли;
				Прервать;
			КонецЕсли;
			н = буф.ПрочитатьЦелое32(4); // позиция следующего
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


Функция УдалитьЗначение(Знач н)

	буф = Новый БуферДвоичныхДанных(16);

	ОткрытьПоток(0);
	Связи.Перейти(н, ПозицияВПотоке.Начало);
	Связи.Прочитать(буф, 0, 16);
	сн = буф.ПрочитатьЦелое32(4); // позиция соседнего
	рн = буф.ПрочитатьЦелое32(12); // позиция родителя

	Связи.Перейти(рн, ПозицияВПотоке.Начало);
	Связи.Прочитать(буф, 0, 16);
	нн = буф.ПрочитатьЦелое32(8); // позиция дочернего

	Если нн = н Тогда // если это первый дочерний
		ОткрытьПоток(1);
		буф.ЗаписатьЦелое32(8, сн);
		Связи.Перейти(рн, ПозицияВПотоке.Начало);
		Связи.Записать(буф, 0, 16);
		Связи.СброситьБуферы();

	Иначе // перебрать остальные

		Пока Истина Цикл
			Связи.Перейти(нн, ПозицияВПотоке.Начало);
			Связи.Прочитать(буф, 0, 16);
			пс = буф.ПрочитатьЦелое32(4); // позиция следующего
			Если пс = н Тогда // найден элемент
				ОткрытьПоток(1);
				буф.ЗаписатьЦелое32(4, сн);
				Связи.Перейти(нн, ПозицияВПотоке.Начало);
				Связи.Записать(буф, 0, 16);
				Связи.СброситьБуферы();
				Прервать;
			КонецЕсли;
			Если пс = 0 Тогда
				Прервать;
			КонецЕсли;
			нн = пс;
		КонецЦикла;

	КонецЕсли;

КонецФункции // УдалитьЗначение()


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

		н = НайтиЗначение(МассивИзСтроки(Символ(1) + слф + Символ(1)));

		Если НЕ н = 0 Тогда
			мр1 = ПолучитьЗначения(н);
			Для каждого мф1 Из мр1 Цикл
				сЛемма = ПолучитьСтроку(мф1[0]);
				мр2 = ПолучитьЗначения(мф1[1]);
				Для каждого мф2 Из мр2 Цикл
					нФорма = ПолучитьСтроку(мф2[0]);
					мр3 = ПолучитьЗначения(мф2[1]);
					Для каждого мф3 Из мр3 Цикл
						нЛемма = ПолучитьСтроку(мф3[0]);
						рез = рез + ?(рез = "", "", Символы.ПС) + слф + Символы.Таб + сЛемма + Символы.Таб + нФорма + Символы.Таб + нЛемма;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
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
			ток1нач = НайтиЗначение(МассивИзСтроки(Символ(1) + мб[1]));
			ток1гр = ДобавитьЗначение(МассивИзСтроки(Символ(2) + мб[2]));
			свимя = ДобавитьЗначение(МассивИзСтроки(Символ(3) + ВРег(мб[3])));
			ток2имя = мб[4];
			ток2нач = НайтиЗначение(МассивИзСтроки(Символ(1) + мб[5]));
			ток2гр = ДобавитьЗначение(МассивИзСтроки(Символ(2) + мб[6]));
			р = мб[7];

			гр = МассивИзСтроки(Символ(2) + мб[2] + Символ(1));
			гр.Добавить(ток2гр);
			гр.Добавить(свимя);

			св = МассивИзСтроки(Символ(1) + мб[1] + Символ(2));
			св.Добавить(ток2нач);
			св.Добавить(свимя);
			св.Добавить(КодСимвола(р));

			Если р = "+" Тогда // добавить грамматику и связь
				ДобавитьЗначение(гр);
				ДобавитьЗначение(св);

			ИначеЕсли р = "-" Тогда // добавить неверную связь
				ДобавитьЗначение(св);

			ИначеЕсли р = "" Тогда // удалить связь
				св[св.Количество()-1] = КодСимвола("-");
				н = НайтиЗначение(св);
				Если НЕ н = 0 Тогда
					УдалитьЗначение(н);
				КонецЕсли;
				св[св.Количество()-1] = КодСимвола("+");
				н = НайтиЗначение(св);
				Если НЕ н = 0 Тогда
					УдалитьЗначение(н);
				КонецЕсли;
			КонецЕсли;

			Если р = "г" Тогда // удалить грамматику
				н = НайтиЗначение(гр);
				Если НЕ н = 0 Тогда
					УдалитьЗначение(н);
				КонецЕсли;
			КонецЕсли;

			структЗадача.Результат.Вставить(ток1имя + "_" + ток2имя, р);

		КонецЦикла;

		Возврат Истина;

	ИначеЕсли Команда = "Грамматики" Тогда

		сгр = Новый Соответствие;

		сл = структЗадача.Запрос.Слова;

		мсл = СтрРазделить(сл, Символы.ПС);

		инд = Новый Соответствие; // индекс

		Для каждого гр Из мсл Цикл

			Если НЕ сгр.Получить(гр) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			сгр.Вставить(гр, "");

			мгр = СтрРазделить(гр, Символы.Таб);

			н = инд.Получить(мгр[0] + Символ(1));
			Если н = Неопределено Тогда
				н = НайтиЗначение(МассивИзСтроки(Символ(2) + мгр[0] + Символ(1))); // найти грамматику
				инд.Вставить(мгр[0] + Символ(1), н);
			КонецЕсли;

			Если НЕ н = 0 Тогда // найдено совпадение по образцу

				гр2 = инд.Получить(мгр[1]);
				Если гр2 = Неопределено Тогда
					гр2 = НайтиЗначение(МассивИзСтроки(Символ(2) + мгр[1]));
					инд.Вставить(мгр[1], гр2);
				КонецЕсли;

				Если НЕ гр2 = 0 Тогда

					н = НайтиЗначение(гр2, н);

					мр = инд.Получить(н);
					Если мр = Неопределено Тогда
						мр = ПолучитьЗначения(н);
						инд.Вставить(н, мр);
					КонецЕсли;

					Для каждого мф Из мр Цикл

						н = инд.Получить(мгр[2] + Символ(2));
						Если н = Неопределено Тогда
							н = НайтиЗначение(МассивИзСтроки(Символ(1) + мгр[2] + Символ(2))); // найти связь
							инд.Вставить(мгр[2] + Символ(2), н);
						КонецЕсли;

						б = "";

						Если НЕ н = 0 Тогда

							нф2 = инд.Получить(мгр[3]);
							Если нф2 = Неопределено Тогда
								нф2 = НайтиЗначение(МассивИзСтроки(Символ(1) + мгр[3]));
								инд.Вставить(мгр[3], нф2);
							КонецЕсли;

							Если НЕ нф2 = 0 Тогда

								н = НайтиЗначение(нф2, н); // позиция нужного значения

								мр1 = инд.Получить(н);
								Если мр1 = Неопределено Тогда
									мр1 = ПолучитьЗначения(н);
									инд.Вставить(н, мр1);
								КонецЕсли;

								Для каждого мф1 Из мр1 Цикл
									Если мф[0] = мф1[0] Тогда
										мб = ПолучитьЗначения(мф1[1]); // что внутри
										Для каждого б1 Из мб Цикл
											б = Символ(б1[0]);
										КонецЦикла;
									КонецЕсли;
								КонецЦикла;

							КонецЕсли;

						КонецЕсли;

						структЗадача.Результат.Вставить("гр_" + структЗадача.Результат.Количество(), гр + "_" + ПолучитьСтроку(мф[0]) + Символы.Таб + б);

					КонецЦикла;

				КонецЕсли;

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
				Задачи.Удалить(структЗадача.ИдЗадачи);
				Продолжить;
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
