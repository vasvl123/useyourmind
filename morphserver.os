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
Перем Данные;


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


Функция МассивИзСтроки(стр);
	м = Новый Массив();
	дстр = СтрДлина(стр);
	Для н = 1 По дстр Цикл
		м.Добавить(КодСимвола(Сред(стр, н, 1)));
	КонецЦикла;
	Возврат м;
КонецФункции // МассивИзСтроки()


Функция ВыполнитьЗадачу(структЗадача)

	Перем Команда;

	структЗадача.Запрос.Свойство("cmd", Команда);

	Если Команда = "stopserver" Тогда
		ОстановитьСервер = Истина;
		Возврат Ложь;

	ИначеЕсли Команда = "ФормыСлов" Тогда

		НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();

		Пока ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла < 50 Цикл

			мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

			Если структЗадача.Результат.Количество() = мСлова.Количество() Тогда
				Возврат Истина;
			КонецЕсли;

			сл = мСлова.Получить(структЗадача.Результат.Количество());
			слф = ВРег(сл);
			рез = "";

			Сообщить(слф);

			н = Связи.НайтиЗначение(МассивИзСтроки(Символ(1) + слф + Символ(1)));

			Если НЕ н = 0 Тогда
				мр1 = Связи.ПолучитьВложенныеЗначения(н);
				Для каждого мф1 Из мр1 Цикл
					уПрервать = Ложь;
					сЛемма = Связи.ПолучитьСтроку(мф1[0]);
					мр2 = Связи.ПолучитьВложенныеЗначения(мф1[1]);
					Для каждого мф2 Из мр2 Цикл
						нФорма = Связи.ПолучитьСтроку(мф2[0]);
						мр3 = Связи.ПолучитьВложенныеЗначения(мф2[1]);
						Для каждого мф3 Из мр3 Цикл
							нЛемма = Связи.ПолучитьСтроку(мф3[0]);
							рез = рез + ?(рез = "", "", Символы.ПС) + слф + Символы.Таб + сЛемма + Символы.Таб + нФорма + Символы.Таб + нЛемма;
							Если сЛемма = "PREP" ИЛИ сЛемма = "CONJ" Тогда
								уПрервать = Истина;
								Прервать; // и хватит
							КонецЕсли;
						КонецЦикла;
						Если уПрервать Тогда
							Прервать;
						КонецЕсли;
					КонецЦикла;
					Если уПрервать Тогда
						Прервать;
					КонецЕсли;
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

		КонецЦикла;

		Возврат Ложь;

	ИначеЕсли Команда = "Связи" Тогда

		мСлова = СтрРазделить(структЗадача.Запрос.Слова, Символы.ПС);

		Для каждого бигр Из мСлова Цикл

			мб = СтрРазделить(бигр, Символы.Таб);

			ток1имя = мб[0];
			ток1нач = Связи.НайтиЗначение(МассивИзСтроки(Символ(1) + мб[1]));
			ток1гр = Связи.ДобавитьЗначение(МассивИзСтроки(Символ(2) + мб[2]));
			свимя = Связи.ДобавитьЗначение(МассивИзСтроки(Символ(3) + ВРег(мб[3])));
			ток2имя = мб[4];
			ток2нач = Связи.НайтиЗначение(МассивИзСтроки(Символ(1) + мб[5]));
			ток2гр = Связи.ДобавитьЗначение(МассивИзСтроки(Символ(2) + мб[6]));
			р = мб[7];

			гр = МассивИзСтроки(Символ(2) + мб[2] + Символ(1));
			гр.Добавить(ток2гр);
			гр.Добавить(свимя);

			св = МассивИзСтроки(Символ(1) + мб[1] + Символ(2));
			св.Добавить(ток2нач);
			св.Добавить(свимя);
			св.Добавить(КодСимвола(р));

			Если р = "+" Тогда // добавить грамматику и связь
				Связи.ДобавитьЗначение(гр);
				Связи.ДобавитьЗначение(св);

			ИначеЕсли р = "-" Тогда // добавить неверную связь
				Связи.ДобавитьЗначение(св);

			ИначеЕсли р = "" Тогда // удалить связь
				св[св.Количество()-1] = КодСимвола("-");
				н = Связи.НайтиЗначение(св);
				Если НЕ н = 0 Тогда
					Связи.УдалитьЗначение(н);
				КонецЕсли;
				св[св.Количество()-1] = КодСимвола("+");
				н = Связи.НайтиЗначение(св);
				Если НЕ н = 0 Тогда
					Связи.УдалитьЗначение(н);
				КонецЕсли;
			КонецЕсли;

			Если р = "г" Тогда // удалить грамматику
				н = Связи.НайтиЗначение(гр);
				Если НЕ н = 0 Тогда
					Связи.УдалитьЗначение(н);
				КонецЕсли;
			КонецЕсли;

			//структЗадача.Результат.Вставить(ток1имя + "_" + ток2имя, р);

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

			н = инд.Получить(мгр[0]);
			Если н = Неопределено Тогда
				н = Связи.НайтиЗначение(МассивИзСтроки(Символ(2) + мгр[0])); // найти грамматику1
				инд.Вставить(мгр[0], н);
			КонецЕсли;

			Если НЕ н = 0 Тогда // найдено совпадение по образцу

				гр2 = инд.Получить(мгр[1]);
				Если гр2 = Неопределено Тогда
					гр2 = Связи.НайтиЗначение(МассивИзСтроки(Символ(2) + мгр[1])); // найти грамматику2
					инд.Вставить(мгр[1], гр2);
				КонецЕсли;

				Если НЕ гр2 = 0 Тогда

					м = Новый Массив;
					м.Добавить(1);
					м.Добавить(гр2);
					н = Связи.НайтиЗначение(м, н);

					мр = инд.Получить(н);
					Если мр = Неопределено Тогда
						мр = Связи.ПолучитьВложенныеЗначения(н);
						инд.Вставить(н, мр);
					КонецЕсли;

					Для каждого мф Из мр Цикл

						н = инд.Получить(мгр[2]);
						Если н = Неопределено Тогда
							н = Связи.НайтиЗначение(МассивИзСтроки(Символ(1) + мгр[2])); // найти форму1
							инд.Вставить(мгр[2], н);
						КонецЕсли;

						б = "";

						Если НЕ н = 0 Тогда

							нф2 = инд.Получить(мгр[3]);
							Если нф2 = Неопределено Тогда
								нф2 = Связи.НайтиЗначение(МассивИзСтроки(Символ(1) + мгр[3])); // найти форму2
								инд.Вставить(мгр[3], нф2);
							КонецЕсли;

							Если НЕ нф2 = 0 Тогда

								м = Новый Массив;
								м.Добавить(2);
								м.Добавить(нф2);
								н = Связи.НайтиЗначение(м, н); // позиция нужного значения

								мр1 = инд.Получить(н);
								Если мр1 = Неопределено Тогда
									мр1 = Связи.ПолучитьВложенныеЗначения(н);
									инд.Вставить(н, мр1);
								КонецЕсли;

								Для каждого мф1 Из мр1 Цикл
									Если мф[0] = мф1[0] Тогда
										мб = Связи.ПолучитьВложенныеЗначения(мф1[1]); // что внутри
										Для каждого б1 Из мб Цикл
											б = Символ(б1[0]);
										КонецЦикла;
									КонецЕсли;
								КонецЦикла;

							КонецЕсли;

						КонецЕсли;

						структЗадача.Результат.Вставить("гр_" + структЗадача.Результат.Количество(), гр + "_" + Связи.ПолучитьСтроку(мф[0]) + Символы.Таб + б);

					КонецЦикла;

				КонецЕсли;

			КонецЕсли;

		КонецЦикла;

		Возврат Истина;

	ИначеЕсли Команда = "Элемент" Тогда

		поз = структЗадача.Запрос.Позиция;

		ИмяДанных = структЗадача.Запрос.База;
		База = Данные.Получить(ИмяДанных);

		Если База = Неопределено Тогда
			Возврат Истина;
		КонецЕсли;

		з = "";

		Элемент = База.ПолучитьЭлемент(поз);
		структЗадача.Результат.Вставить("Элемент", Элемент);

		Если поз = "0" Тогда // начало файла
			м = База.ПолучитьЗначения(Элемент.Соседний);
			з = ИмяДанных;
		Иначе
			м = База.ПолучитьЗначения(Элемент.Дочерний);
			зн = База.ПолучитьМассив(поз);

			Если ИмяДанных = "Связи" Тогда
				тэ = "НачалоФайла";
				Для каждого зэ Из зн Цикл
					Если тэ = "НачалоФайла" Тогда
						Если зэ = 1 Тогда
							тэ = "Форма";
						ИначеЕсли зэ = 2 Тогда
							тэ = "Лемма";
						ИначеЕсли зэ = 3 Тогда
							тэ = "Отношение";
						КонецЕсли;

					ИначеЕсли тэ = "Форма" Тогда
						Если зэ = 1 Тогда
							тэ = "НачФорма";
							з = тэ;
						ИначеЕсли зэ = 2 Тогда
							тэ = "СвязьСл";
							з = тэ;
						Иначе
							з = з + Символ(зэ);
						КонецЕсли;
					ИначеЕсли тэ = "НачФорма" Тогда
						з = "";
						тэ = "ПозицияЛеммы1";
					ИначеЕсли тэ = "ПозицияЛеммы1" Тогда
						тэ = "ПозицияНФ1";
					ИначеЕсли тэ = "ПозицияНФ1" Тогда
						тэ = "ПозицияЛеммыНФ1";
					ИначеЕсли тэ = "ПозицияЛеммыНФ1" Тогда
						тэ = "";
					ИначеЕсли тэ = "СвязьСл" Тогда
						з = "";
						тэ = "ПозицияФормы1";
					ИначеЕсли тэ = "ПозицияФормы1" Тогда
						тэ = "ПозицияСвязи1";
					ИначеЕсли тэ = "ПозицияСвязи1" Тогда
						тэ = "СимволПМ";
					ИначеЕсли тэ = "СимволПМ" Тогда
						з = Символ(зэ);
						тэ = "";

					ИначеЕсли тэ = "Лемма" Тогда
						Если зэ = 1 Тогда
							тэ = "СвязьГр";
							з = тэ;
						Иначе
							з = з + Символ(зэ);
						КонецЕсли;
					ИначеЕсли тэ = "СвязьГр" Тогда
						з = "";
						тэ = "ПозицияЛеммы2";
					ИначеЕсли тэ = "ПозицияЛеммы2" Тогда
						тэ = "ПозицияСвязи2";
					ИначеЕсли тэ = "ПозицияСвязи2" Тогда
						тэ = "";

					ИначеЕсли тэ = "Отношение" Тогда
						з = з + Символ(зэ);
					КонецЕсли;
				КонецЦикла;

			ИначеЕсли ИмяДанных = "Тезаурус" Тогда

				тэ = "НачалоФайла";
				Для каждого зэ Из зн Цикл
					Если тэ = "НачалоФайла" Тогда
						Если зэ = 1 Тогда
							тэ = "Синсет";
						КонецЕсли;
					ИначеЕсли тэ = "Синсет" Тогда
						Если зэ < 16 Тогда
							Если зэ = 1 Тогда
								тэ = "Син";
							ИначеЕсли зэ = 2 Тогда
								тэ = "Выше";
							ИначеЕсли зэ = 3 Тогда
								тэ = "Ниже";
							ИначеЕсли зэ = 4 Тогда
								тэ = "Целое";
							ИначеЕсли зэ = 5 Тогда
								тэ = "Ассоц";
							ИначеЕсли зэ = 6 Тогда
								тэ = "Часть";
							КонецЕсли;
							з = тэ;
						Иначе
							з = з + Символ(зэ);
						КонецЕсли;
					Иначе
						з = "";
						тэ = "Синсет";
					КонецЕсли;
				КонецЦикла;

			КонецЕсли;

			Если з = "" Тогда
				Если зэ < 16 Тогда
					з = тэ;
				Иначе
					з = База.ПолучитьСтроку(зэ);
					// Если ИмяДанных = "Связи" Тогда
					Если ИмяДанных = "Тезаурус" Тогда
						Элемент = База.ПолучитьЭлемент(зэ);
						структЗадача.Результат.Вставить("Элемент", Элемент);
						м = База.ПолучитьЗначения(Элемент.Дочерний);
					КонецЕсли;
				КонецЕсли;
			Иначе // текст

				Если НЕ Элемент.Значение < 16 Тогда
					Если м.Количество() = 1 Тогда // раскрыть дерево
						Пока м.Количество() = 1 Цикл
							эл = База.ПолучитьЭлемент(Элемент.Дочерний);
							Если эл.Значение < 16 Тогда
								Прервать;
							КонецЕсли;
							з = з + Символ(эл.Значение);
							Элемент = эл;
							м = База.ПолучитьЗначения(Элемент.Дочерний);
						КонецЦикла;
						структЗадача.Результат.Вставить("Элемент", Элемент);
					КонецЕсли;
				КонецЕсли;

			КонецЕсли;

		КонецЕсли;

		Для каждого эл Из м Цикл
			структЗадача.Результат.Вставить("эл_" + структЗадача.Результат.Количество(), эл[1]);
		КонецЦикла;

		структЗадача.Результат.Вставить("Строка", з);

		Возврат Истина;

	КонецЕсли;

КонецФункции


Процедура ОбработатьСоединения() Экспорт

	Если АргументыКоманднойСтроки.Количество() Тогда
		Порт = Число(АргументыКоманднойСтроки[0]);
	Иначе
		Порт = 8886;
	КонецЕсли;

	Таймаут = 5;

	TCPСервер = Новый TCPСервер(Порт);
	TCPСервер.ЗапуститьАсинхронно();

	Сообщить(СокрЛП(ТекущаяДата()) + " Сервер морфологии запущен на порту: " + Порт);

	Данные = Новый Соответствие;

	ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "treedb.os"), "treedb");
	Связи = Новый treedb(ОбъединитьПути(ТекущийКаталог(), "morph", "Связи.dat"));
	Данные.Вставить("Связи", Связи);
	Тезаурус = Новый treedb(ОбъединитьПути(ТекущийКаталог(), "morph", "Тезаурус.dat"));
	Данные.Вставить("Тезаурус", Тезаурус);

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

		Соединение = TCPСервер.ПолучитьСоединение(Таймаут);
		Если НЕ Соединение = Неопределено Тогда
			Соединения.Вставить(0, Соединение);
			Таймаут = 5;
		КонецЕсли;

		к = Соединения.Количество();
		Пока к > 0 Цикл
			к = к - 1;
			Соединение = Соединения.Получить(к);
			Соединения.Удалить(к);

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
		Если Таймаут < 50 Тогда
			Таймаут = Таймаут + 1;
		КонецЕсли;

	КонецЦикла;

	Если НЕ Связи = Неопределено Тогда
		Связи.Закрыть();
	КонецЕсли;

	TCPСервер.Остановить();
	Сообщить("Завершил работу сервера морфологии.");

КонецПроцедуры

МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
ОбработатьСоединения();
