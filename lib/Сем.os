// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind

Перем пДанные;
Перем Правила;
Перем Формы;


Функция УзелСвойство(Узел, Свойство) Экспорт
	УзелСвойство = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство(Свойство, УзелСвойство);
	КонецЕсли;
	Возврат УзелСвойство;
КонецФункции // УзелСвойство(Узел)


Функция ИмяЗначение(Имя, Значение = "")
	Возврат Новый Структура("Имя, Значение", Имя, Значение);
КонецФункции


Процедура ФормыСлов(Данные, Свойства, Результат) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Для каждого Вариант Из Результат Цикл
			ф = Формы.с.Получить(Вариант.Значение.Слово);
			мРез = СтрРазделить(Вариант.Значение.Результат, Символы.ПС);
			Для каждого Рез Из мРез Цикл
				Если НЕ Рез = "" Тогда
					мФорм = СтрРазделить(Рез, Символы.Таб);
					Запись = ИмяЗначение(мФорм[0], мФорм[1]);
					у = пДанные.НовоеЗначениеУзла(ф, Запись, , Истина); // Добавить форму
					Если мФорм.Количество() > 2 Тогда
						пДанные.НовыйАтрибут(у, ИмяЗначение(мФорм[2], мФорм[3]));
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	Свойства.д.Разбор.Значение = "Токены";
	Данные.ОбъектыОбновить.Добавить(Свойства.Родитель);
КонецПроцедуры


Процедура ПостроитьИндекс(пУзел)
	пУзел.Вставить("с", Новый Соответствие);
	дУзел = пУзел.Дочерний;
	Пока НЕ дУзел = Неопределено Цикл
		ПостроитьИндекс(дУзел);
		ин = 0;
		Пока НЕ пУзел.с.Получить(дУзел.Имя + "_" + ин) = Неопределено Цикл
			ин = ин + 1;
		КонецЦикла;
		пУзел.с.Вставить(дУзел.Имя + "_" + ин, дУзел);
		дУзел = дУзел.Соседний;
	КонецЦикла;
КонецПроцедуры

Функция Предложение_Свойства(Данные, оУзел) Экспорт

	Если пДанные = Неопределено Тогда // Загрузить правила анализа
		Запрос = Новый Структура("sdata, data", Данные.Процесс.Источник, "semdata");
		пДанные = Данные.Процесс.ПолучитьДанные(Новый Структура("Запрос", Запрос));
		Если пДанные = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	Если НЕ пДанные.Корень.Свойство("Свойства") Тогда
		пДанные.ОбъектыОбновить.Добавить(пДанные.Корень);
		Возврат Ложь;
	КонецЕсли;
	Если Правила = Неопределено Тогда // построить индекс
		Правила = пДанные.Корень.Свойства.д.Правила;
		ПостроитьИндекс(Правила);
	КонецЕсли;
	Если Формы = Неопределено Тогда // формы слов
		Формы = пДанные.Корень.Свойства.д.Формы;
		Формы.Вставить("с", Новый Соответствие);
		фУзел = Формы.Дочерний;
		Пока НЕ фУзел = Неопределено Цикл
			Формы.с.Вставить(фУзел.Имя, фУзел);
			фУзел = фУзел.Соседний;
		КонецЦикла;
	КонецЕсли;

	Если НЕ оУзел.Свойство("Свойства") Тогда // новый объект
		Свойства = Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
		шСвойства = "
		|Токены
		|Разбор: Нет
		|*Вид";
		Данные.СоздатьСвойства(Свойства, шСвойства);
		оУзел.Вставить("Свойства", Свойства);
	КонецЕсли;

КонецФункции

Функция Предложение_Модель(Данные, Свойства, Изменения) Экспорт
	Перем Обновить;

	оУзел = Свойства.Родитель;
	Если НЕ УзелСвойство(оУзел, "Обновить") = Ложь Тогда

		Если Свойства.д.Разбор.Значение = "Нет" Тогда
			пр = "";
			Свойства.д.Токены.Вставить("с", Новый Соответствие);
			Если Свойства.д.Свойство("Текст", пр) Тогда
				сСимв = ".,!?:;()«»""'-–";
				Для н = 1 По стрДлина(сСимв) Цикл
					сс = Сред(сСимв, н, 1);
					пр = СтрЗаменить(пр, сс, " " + сс + " ");
				КонецЦикла;
				м = СтрРазделить(пр, " ");
				мсл = "";
				Для каждого сл Из м Цикл
					Если НЕ сл = "" Тогда
						т = Данные.НовыйДочерний(Свойства.д.Токены, ИмяЗначение(сл, ""), , Истина);
						Если стрНайти(сСимв, сл) = 0 Тогда
							всл = ВРег(сл);
							Если Формы.с.Получить(всл) = Неопределено Тогда
								ф = Данные.НовыйДочерний(Формы, ИмяЗначение(всл), , Истина);
								Формы.с.Вставить(всл, ф);
								мсл = мсл + Символы.ПС + всл;
							КонецЕсли;
						КонецЕсли;
						Свойства.д.Токены.с.Вставить(сл, т);
					КонецЕсли;
				КонецЦикла;
				Запрос = Новый Структура("Библиотека, Данные, Слова, Свойства, cmd", ЭтотОбъект, Данные, Сред(мсл, 2), Свойства, "ФормыСлов");
				Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
				Свойства.д.Разбор.Значение = "Формы";
			Иначе // нечего разбирать
				оУзел.Вставить("Обновить", Ложь);
			КонецЕсли;
		КонецЕсли;

		Если Свойства.д.Разбор.Значение = "Токены" Тогда
			// можно выполнять семантический разбор
			Для каждого т1 Из Свойства.д.Токены.с Цикл
				ток1 = т1.Значение;
				ток1Формы = Формы.с.Получить(ВРег(т1.Ключ));
				Если НЕ ток1Формы = Неопределено Тогда
					фУзел1 = ток1Формы.Дочерний;
					Пока НЕ фУзел1 = Неопределено Цикл
						и1 = 0;
						Пока Истина Цикл
							п1 = Правила.с.Получить(фУзел1.Значение + "_" + и1);
							Если п1 = Неопределено Тогда
								Прервать;
							КонецЕсли;
							Для каждого т2 Из Свойства.д.Токены.с Цикл
								ток2 = т2.Значение;
								Если НЕ ток1 = ток2 Тогда
									ток2Формы = Формы.с.Получить(ВРег(т2.Ключ));
									Если НЕ ток2Формы = Неопределено Тогда
										фУзел2 = ток2Формы.Дочерний;
										Пока НЕ фУзел2 = Неопределено Цикл
											и2 = 0;
											Пока Истина Цикл
												п2 = п1.с.Получить(фУзел2.Значение + "_" + и2);
												Если п2 = Неопределено Тогда
													Прервать;
												КонецЕсли;
												// найдено подходящее правило
												Данные.НовыйДочерний(ток1, ИмяЗначение(п2.Значение, ток2.Имя), , Истина);
												и2 = и2 + 1;
											КонецЦикла;
											фУзел2 = фУзел2.Соседний;
										КонецЦикла;
									КонецЕсли;
								КонецЕсли;
							КонецЦикла;
							и1 = и1 + 1;
						КонецЦикла;
						фУзел1 = фУзел1.Соседний;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;

			Свойства.д.Разбор.Значение = "Выполнен";
			//Обновить = Истина;

		КонецЕсли;

		Если Свойства.д.Разбор.Значение = "Выполнен" Тогда
			// сформировать представление
			Вид = "";
			тУзел = Свойства.д.Токены.Дочерний;
			Пока НЕ тУзел = Неопределено Цикл
				Вид = Вид + тУзел.Код;
				тУзел = тУзел.Соседний;
			КонецЦикла;
			Свойства.д.Вид.Значение = Вид;
			оУзел.Вставить("Обновить", Ложь);
		КонецЕсли;

	КонецЕсли;

	Возврат Обновить;

КонецФункции


Функция Токен_Свойства(Данные, оУзел) Экспорт

	Если НЕ оУзел.Свойство("Свойства") Тогда // новый объект
		Свойства = Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
		шСвойства = "
		|";
		Данные.СоздатьСвойства(Свойства, шСвойства);
		оУзел.Вставить("Свойства", Свойства);
	КонецЕсли;

КонецФункции

Функция Токен_Модель(Данные, Свойства, Изменения) Экспорт

	оУзел = Свойства.Родитель;
	Если НЕ УзелСвойство(оУзел, "Обновить") = Ложь Тогда
	КонецЕсли;

КонецФункции
