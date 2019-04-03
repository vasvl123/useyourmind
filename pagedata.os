// MIT License
// Copyright (c) 2019 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//
// Включает программный код https://github.com/tsukanov-as/kojura

Перем БазаДанных Экспорт;
Перем ИмяДанных Экспорт;
Перем ПозицияДанных Экспорт;

Перем Данные;
Перем КодУзла;
Перем Узлы Экспорт;
Перем Изменены Экспорт;
Перем сКоличество Экспорт;
Перем Количество Экспорт;
Перем Пустой Экспорт;
Перем УзлыОбновить Экспорт;
Перем Обновить Экспорт;
Перем Представление Экспорт;
Перем Библиотеки;
Перем Операторы;
Перем Рефлектор;
Перем Процесс Экспорт;
Перем Корень Экспорт;
Перем Фронт Экспорт;
Перем К Экспорт;


Функция УзелСостояние(Узел, СостояниеИмя) Экспорт
	Перем УзелСостояния, УзелСостояние;
	Если Узел.Свойство("Состояния", УзелСостояния) Тогда
		УзелСостояния.Свойство(СостояниеИмя, УзелСостояние);
	КонецЕсли;
	Возврат УзелСостояние;
КонецФункции // УзелСостояние(Узел)


Функция СтрокуВСтруктуру(Знач Стр)
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Рез = Новый Структура;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Рез.Вставить(Ключ, знСтр);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции


Функция УзелСостояниеЗначение(Узел, СостояниеИмя, Знач СостояниеЗначение) Экспорт
	Перем УзелСостояния;
	Если НЕ Узел.Свойство("Состояния", УзелСостояния) Тогда
		УзелСостояния = Новый Структура();
		Узел.Вставить("Состояния", УзелСостояния);
	КонецЕсли;
	УзелСостояния.Вставить(СостояниеИмя, СостояниеЗначение);
	//Сообщить("" + Узел.Код + " " + СостояниеИмя + "=" + (Лев(СостояниеЗначение,30)));
	Возврат СостояниеЗначение;
КонецФункции // УзелСостояниеЗначение(Узел)


Функция СтруктуруВСтроку(знСтруктура) Экспорт
	Если НЕ ТипЗнч(знСтруктура) = Тип("Структура") Тогда
		Возврат знСтруктура;
	КонецЕсли;
	Результат = "";
	Для каждого Элемент Из знСтруктура Цикл
		Ключ = Элемент.Ключ;
		Значение = Элемент.Значение;

		Если "" + Значение = "" Тогда
			Продолжить;
		КонецЕсли;

		Если ТипЗнч(Значение) = Тип("Структура") ИЛИ Ключ = "Код" ИЛИ Ключ = "Старший" ИЛИ Ключ = "Родитель" Тогда
			Продолжить;
		ИначеЕсли Ключ = "Имя" Тогда
			Ключ = "И";
		ИначеЕсли Ключ = "Значение" Тогда
			Ключ = "З";
			Значение = СтрЗаменить(Значение, Символы.Таб, "#x9");
			Значение = СтрЗаменить(Значение, Символы.ПС, "#xA");
			Значение = СтрЗаменить(Значение, Символы.ВК, "#xD");
		ИначеЕсли Ключ = "сДочерний" Тогда
			Продолжить;
		ИначеЕсли Ключ = "Дочерний" Тогда
			Если Лев(Значение, 1) = "s" Тогда
				Продолжить;
			КонецЕсли;
			Ключ = "Д";
		ИначеЕсли Ключ = "Соседний" Тогда
			Ключ = "С";
		ИначеЕсли Ключ = "Атрибут" Тогда
			Ключ = "А";
		КонецЕсли;
		Результат = Результат + ?(Результат = "", "", Символы.Таб) + Ключ + Символы.Таб + Значение;
	КонецЦикла;
	Возврат Результат;
КонецФункции


Функция УзелСвойство(Узел, Свойство) Экспорт
	УзелСвойство = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство(Свойство, УзелСвойство);
	КонецЕсли;
	Возврат УзелСвойство;
КонецФункции // УзелСвойство(Узел)


Функция ОбновитьУзел(Знач Узел) Экспорт
	Связи = УзелСостояние(Узел, "Связи");
	Если Связи = Неопределено Тогда
		Связи = Новый Соответствие;
		Связи.Вставить(Узел, ЭтотОбъект);
	КонецЕсли;
	Для каждого элСвязь Из Связи Цикл
		Сообщить("" +  Узел.Код + " ->> " + элСвязь.Ключ.Код);
		элСвязь.Значение.УзлыОбновить.Вставить(элСвязь.Ключ, Узел);
	КонецЦикла;
	УзелСостояниеЗначение(Узел, "ЗначениеУзла", Неопределено);
КонецФункции


Функция ПоказатьУзел(Знач Узел, Атрибуты = "", Дочерний = "", ЭтоАтрибут = Ложь) Экспорт
	Перем Представление;

	Представление = "";

	УзелИмя = Узел.Имя;
	УзелЗначение = "";
	Если Узел.Свойство("Значение") Тогда
		УзелЗначение = 	Узел.Значение;
	КонецЕсли;

	Если ЭтоАтрибут Тогда

		Если НЕ Дочерний = "" Тогда
			УзелЗначение = Дочерний;
		КонецЕсли;

		АтрибутИмя = СтрЗаменить(УзелИмя, "xml_lang", "xml:lang");
		АтрибутИмя = СтрЗаменить(АтрибутИмя, "_", "-");
		Представление = Представление + " " + АтрибутИмя + "=""" + УзелЗначение + """";

	Иначе

		Если Узел.Имя = "Элемент" ИЛИ Узел.Имя = "Э" Тогда
			УзелИмя = "div";
			УзелЗначение = "";
		КонецЕсли;

		Если Узел.Имя = "comment" Тогда
			Представление = Представление + "<!-- " + УзелЗначение + " -->";
		Иначе
			Представление = Представление + "<" + УзелИмя + Атрибуты + " id=""" + "_" + Узел.Код + """>";
			Представление = Представление + УзелЗначение;
			Представление = Представление + Дочерний + "</" + УзелИмя + ">";
		КонецЕсли;

	КонецЕсли;

	Возврат Представление;

КонецФункции // ПоказатьУзел()


// Создать копию ветки
Функция КопироватьВетку(Узел, Цель, Старший, Родитель, ЭтоАтрибут = Ложь, ПервыйВызов = Истина, Служебный = Истина, ПараметрыМодели = Неопределено) Экспорт

	ИмяУзла = УзелСвойство(Узел, "Имя");
	ЗначениеУзла = УзелСвойство(Узел, "Значение");

	КопияУзел = Цель.НовыйУзел(Новый Структура("Имя, Значение, Старший, Родитель", ИмяУзла, ЗначениеУзла, Старший, Родитель), Служебный ИЛИ Служебный(Узел));

	Если НЕ ЭтоАтрибут Тогда

		УзелАтрибут = Атрибут(Узел);
		Если НЕ УзелАтрибут = Неопределено Тогда
			УзелАтрибут = КопироватьВетку(УзелАтрибут, Цель, КопияУзел, КопияУзел, Истина, Ложь, Служебный ИЛИ Служебный(УзелАтрибут), ПараметрыМодели);
			КопияУзел.Вставить("Атрибут", УзелАтрибут.Код);
		КонецЕсли;

	КонецЕсли;

	УзелДочерний = Дочерний(Узел);
	Если УзелДочерний = Неопределено Тогда
		Если ИмяУзла = "Узел" Тогда
			Если НЕ ПараметрыМодели = Неопределено Тогда // если это модель
				Параметр = УзелСвойство(ПараметрыМодели, ЗначениеУзла);
				Если ТипЗнч(Параметр) = Тип("Структура") Тогда
					УзелДочерний = Параметр;
				ИначеЕсли ТипЗнч(Параметр) = Тип("Строка") Тогда
					КопияУзел.Вставить("Дочерний", Цель.НовыйУзел(Новый Структура("Имя, Значение, Старший, Родитель", "Строка", Параметр, Узел, Узел), Служебный ИЛИ Служебный(Узел)).Код);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если НЕ УзелДочерний = Неопределено Тогда
		УзелДочерний = КопироватьВетку(УзелДочерний, Цель, КопияУзел, КопияУзел, , Ложь, Служебный ИЛИ Служебный(УзелДочерний), ПараметрыМодели);
		КопияУзел.Вставить("Дочерний", УзелДочерний.Код);
	КонецЕсли;

	Если ПервыйВызов Тогда
		КопияУзел.Вставить("Соседний", Неопределено);
	Иначе
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			УзелСоседний = КопироватьВетку(УзелСоседний, Цель, КопияУзел, Родитель, ЭтоАтрибут, Ложь, Служебный ИЛИ Служебный(УзелСоседний), ПараметрыМодели);
			КопияУзел.Вставить("Соседний", УзелСоседний.Код);
		КонецЕсли;
	КонецЕсли;

	Возврат КопияУзел;

КонецФункции // КопироватьВетку()


// // Передать значение внешнего узла
// Функция ВнешнийЗначение(Знач Узел, Объект) Экспорт
// 	ВнешнийУзел = НайтиУзел(Корень, Узел.Значение);
// 	Если НЕ ВнешнийУзел = Неопределено Тогда
// 		Связи = УзелСостояние(ВнешнийУзел, "Связи");
// 		Если Связи = Неопределено Тогда
// 			Связи = Новый Соответствие;
// 			УзелСостояниеЗначение(ВнешнийУзел, "Связи", Связи);
// 		КонецЕсли;
// 		Связи.Вставить(Узел, Объект);
// 	КонецЕсли;
// 	Возврат Интерпретировать(Дочерний(ВнешнийУзел));
// КонецФункции


// Получить значение узла
Функция УзелЗначение(Знач Узел) Экспорт

	Состояние = Неопределено;
	ИмяУзла = УзелСвойство(Узел, "Значение");

	Если НЕ "" + ИмяУзла = "" Тогда // нужно найти определение узла
		ОпределениеУзла = ОпределениеУзла(Узел, ИмяУзла);
	Иначе // получить значение дочернего узла
		ОпределениеУзла = Узел;
	КонецЕсли;

	Если НЕ ОпределениеУзла = Неопределено Тогда
		Состояние = УзелСостояние(ОпределениеУзла, "ЗначениеУзла"); // оптимизация
		Если Состояние = Неопределено Тогда

			Состояние = Интерпретировать(Дочерний(ОпределениеУзла), , Ложь);
			УзелСостояниеЗначение(ОпределениеУзла, "ЗначениеУзла", Состояние); // оптимизация

			Связи = УзелСостояние(ОпределениеУзла, "Связи");
			Если НЕ Связи = Неопределено Тогда
				Для каждого элСвязь Из Связи Цикл
					Если НЕ элСвязь.Ключ = Узел Тогда
						УзлыОбновить.Вставить(элСвязь.Ключ, ОпределениеУзла);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;

	Возврат Состояние;

КонецФункции


// Установить значения узла
Функция УзелУстановитьЗначение(Знач Узел, Знач Определение, Знач УзелЗначение) Экспорт

	Состояние = Неопределено;

	Если УзелЗначение = Неопределено Тогда
		УзелЗначение = Дочерний(Узел);
	Иначе
		Если ТипЗнч(УзелЗначение) = Тип("Строка") Тогда
			ОпределениеЗначение = Дочерний(Определение);
			Если НЕ ОпределениеЗначение = Неопределено Тогда
				Если Служебный(ОпределениеЗначение) И ОпределениеЗначение.Имя = "Строка" Тогда
					ОпределениеЗначение.Вставить("Значение", УзелЗначение);
					УзелЗначение = ОпределениеЗначение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ТипЗнч(УзелЗначение) = Тип("Строка") Тогда
			УзелЗначение = НовыйУзел(Новый Структура("Имя, Значение", "Строка", УзелЗначение), Истина);
		КонецЕсли;
	КонецЕсли;

	Если НЕ Служебный(УзелЗначение) Тогда
		УзелЗначение = КопироватьВетку(УзелЗначение, ЭтотОбъект, Определение, Определение.Родитель, , Ложь);
	КонецЕсли;

	Определение.Вставить("сДочерний", УзелЗначение.Код);
	УзелСостояниеЗначение(Определение, "ЗначениеУзла", Неопределено); // будет обновляться

	// Установить для обновления узлы которые нужно обновить
	Связи = УзелСостояние(Определение, "Связи");
	Если НЕ Связи = Неопределено Тогда
		Для каждого элСвязь Из Связи Цикл
			УзлыОбновить.Вставить(элСвязь.Ключ, Определение);
		КонецЦикла;
	КонецЕсли;

	Возврат Состояние;

КонецФункции


Функция ВставитьЗначение(Знач Узел) Экспорт
	Перем ИмяУзла;
	Значение = Дочерний(Узел);
	УзелПоиск = Узел;
	МассивПуть = СтрРазделить(Узел.Значение, ".");
	ПервыйНайден = Ложь;
	Для каждого элПуть Из МассивПуть Цикл
		Если НЕ ПервыйНайден Тогда
			УзелПоиск = ОпределениеУзла(Узел, элПуть, Ложь);
			Если НЕ УзелПоиск = Неопределено Тогда
				ПервыйНайден = Истина;
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		Иначе
			УзелПоиск = НайтиУзел(УзелПоиск, элПуть);
			Если УзелПоиск = Неопределено Тогда
				Возврат Неопределено; // целевой узел не найден
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если Значение.Имя = "Строка" Тогда
		Значение = Интерпретировать(Значение, , Ложь)
	КонецЕсли;
	УзелУстановитьЗначение(Узел, УзелПоиск, Значение);
КонецФункции


// Поиск определения узла
Функция ОпределениеУзла(Знач Узел, Знач ИмяЭлемента, Обновлять = Истина) Экспорт

	Определение = УзелСостояние(Узел, "Определение");
	Если НЕ Определение = Неопределено Тогда
		Возврат Определение;
	КонецЕсли;

	НачальныйУзел = Узел;
	// АтрибутРодитель = Неопределено;

	Узел = Узел.Старший;
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = "Узел" ИЛИ Узел.Имя = "У" Тогда
			Если "" + УзелСвойство(Узел, "Значение") = ИмяЭлемента Тогда
				Если Обновлять Тогда // объявление найдено, зарегистрируем свой узел для обновлений
					Связи = УзелСостояние(Узел, "Связи");
					Если Связи = Неопределено Тогда
						Связи = Новый Соответствие;
						УзелСостояниеЗначение(Узел, "Связи", Связи);
					КонецЕсли;
					Связи.Вставить(НачальныйУзел, ЭтотОбъект);
				КонецЕсли;
				УзелСостояниеЗначение(НачальныйУзел, "Определение", Узел);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Узел = Узел.Старший;
	КонецЦикла;

	Если Узел = Неопределено Тогда
		ВызватьИсключение СтрШаблон("" + НачальныйУзел.Код + " - неизвестный узел %1", ИмяЭлемента);
	КонецЕсли;

	// Если Дочерний(Узел) = Неопределено Тогда
	// 	ВызватьИсключение СтрШаблон("Неверное определение узла %1", ИмяЭлемента);
	// КонецЕсли;

	Возврат Узел;
КонецФункции // ОпределениеУзла()


Функция ОбновитьДанные(Запрос) Экспорт
	Для каждого элПараметр Из Запрос Цикл

		Определение = НайтиУзел(Корень, элПараметр.Ключ);
		Если НЕ Определение = Неопределено Тогда
			//Сообщить("Обновил узел " + элПараметр.Ключ);
			// Элемент = НовыйУзел(Новый Структура("Имя, Значение", "Строка", элПараметр.Значение), Истина);
			// Элемент.Вставить("Старший", Определение);
			// Элемент.Вставить("Родитель", Определение);
			// Определение.Вставить("сДочерний", Элемент.Код);
			// УзелСостояниеЗначение(Определение, "ЗначениеУзла", Неопределено); // будет обновляться
			УзелСостояниеЗначение(Определение, "ЗначениеУзла", элПараметр.Значение);

			// Установить для обновления узлы которые нужно обновить
			Связи = УзелСостояние(Определение, "Связи");
			Если НЕ Связи = Неопределено Тогда
				Для каждого элСвязь Из Связи Цикл
					УзлыОбновить.Вставить(элСвязь.Ключ, Определение);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецФункции // ОбновитьДанные()


Функция ОбновитьПредставление() Экспорт

	Представление = "";

	Если Обновить Тогда
		ОбновитьУзел(Корень);
		Обновить = Ложь;
	КонецЕсли;

	Циклов = 0;
	СписокЭлементов = Новый Соответствие;
	Состояния = Новый Соответствие;

	Если УзлыОбновить.Количество() Тогда

		СписокУзлов = Новый Соответствие;
		// узлы которые нужно обновить
		Для каждого элУзел Из УзлыОбновить Цикл
			СписокУзлов.Вставить(элУзел.Ключ, элУзел.Значение);
		КонецЦикла;

		// обновить узлы
		Для каждого элУзел Из СписокУзлов Цикл

			Узел = элУзел.Ключ;

			Попытка
				Состояние = Интерпретировать(элУзел.Значение, , Ложь);
			Исключение
				Процесс.ЗаписатьСобытие("Интерпретатор", ОписаниеОшибки(), 3);
				//Сообщить(ОписаниеОшибки());
				Инфо = ИнформацияОбОшибке();
				Стек = Инфо.ПолучитьСтекВызовов();
				Для каждого Кадр Из Стек Цикл
					Сообщить(Кадр.ИмяМодуля + " / " + Кадр.Метод + " / " + Кадр.НомерСтроки);
				КонецЦикла;
				УзелСостояниеЗначение(элУзел.Значение, "Ошибка", Истина);
			КонецПопытки;

			УзлыОбновить.Удалить(Узел);

			Если Узел = Корень ИЛИ Узел.Имя = "Элемент" ИЛИ Узел.Имя = "Э" Тогда
				Представление = Представление + Состояние;
				Продолжить;
			КонецЕсли;

			УзелДочерний = Узел;
			РодительУзел = Узел.Родитель;
			Пока НЕ РодительУзел = Неопределено Цикл

				Если РодительУзел.Имя = "Узел" ИЛИ РодительУзел.Имя = "У" Тогда
					// обновить родителя
					УзелСостояниеЗначение(РодительУзел, "ЗначениеУзла", Неопределено); // будет обновляться
					// Установить для обновления узлы которые нужно обновить
					Связи = УзелСостояние(РодительУзел, "Связи");
					Если НЕ Связи = Неопределено Тогда
						Для каждого элСвязь Из Связи Цикл
							Сообщить("" +  РодительУзел.Код + " ->> " + элСвязь.Ключ.Код);
							УзлыОбновить.Вставить(элСвязь.Ключ, РодительУзел);
						КонецЦикла;
					КонецЕсли;
					Прервать;
				КонецЕсли;
				УзелДочерний = РодительУзел;
				РодительУзел = РодительУзел.Родитель;
			КонецЦикла;

		КонецЦикла;

	КонецЕсли;

	Если УзлыОбновить.Количество() Тогда
		Процесс.ЗадачаОбновитьВыполнить = Истина; // продолжение
	КонецЕсли;

	//Сообщить(Представление);

	Возврат Неопределено;

КонецФункции


Функция ПолучитьАргументы(Узел)
	Аргументы = Новый Структура("ЭтотУзел", Узел);
	Аргумент = Атрибут(Узел);
	Пока НЕ Аргумент = Неопределено Цикл
		Если Аргумент.Имя = "Аргумент" ИЛИ Аргумент.Имя = "А" Тогда
			Аргументы.Вставить(Аргумент.Значение, Интерпретировать(Дочерний(Аргумент), , Ложь));
		Иначе
			Аргументы.Вставить(Аргумент.Имя, Аргумент.Значение);
		КонецЕсли;
		Аргумент = Соседний(Аргумент);
	КонецЦикла;
	Возврат Аргументы;
КонецФункции


Функция ВызватьФункцию(Знач Узел, Знач ИмяФункции)

	Состояние = УзелСостояние(Узел, "Состояние"); // оптимизация

	Если Состояние = Неопределено Тогда

		Если НЕ ИмяФункции = Неопределено Тогда // указано имя функции

			Если СтрНайти(ИмяФункции, ".") Тогда
				ИмяФункции = СтрРазделить(ИмяФункции, ".");
				ИмяБиблиотеки = ИмяФункции[0];
				ИмяФункции = ИмяФункции[1];
			Иначе
				ИмяБиблиотеки = "Системные";
			КонецЕсли;

			Библиотека = Библиотеки.Получить(ИмяБиблиотеки);
			Если Библиотека = Неопределено Тогда
				Библиотека = ЗагрузитьСценарий(ОбъединитьПути(ТекущийКаталог(), "lib", ИмяБиблиотеки + ".os"));
				Библиотеки.Вставить(ИмяБиблиотеки, Библиотека);
			КонецЕсли;
			Если НЕ Библиотека = Неопределено Тогда
				ТаблицаМетодов = Рефлектор.ПолучитьТаблицуМетодов(Библиотека);
				Параметры = Неопределено;
				Для каждого Метод Из ТаблицаМетодов Цикл
					Если Метод.Имя = ИмяФункции Тогда
						Аргументы = ПолучитьАргументы(Узел);
						Параметры = Новый Массив;
						Параметры.Добавить(ЭтотОбъект);
						Параметры.Добавить(Аргументы);
						Состояние = Рефлектор.ВызватьМетод(Библиотека, ИмяФункции, Параметры);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Параметры = Неопределено Тогда
					ВызватьИсключение "Функция " + ИмяФункции + " не найдена";
				КонецЕсли;
			Иначе
				ВызватьИсключение "Библиотека " + ИмяБиблиотеки + " не найдена";
			КонецЕсли;

		КонецЕсли;

		УзелСостояниеЗначение(Узел, "Состояние", Состояние); // Новое значение

	КонецЕсли;

	Возврат Состояние;

КонецФункции // ВызватьФункцию()


Функция Интерпретировать(Знач Узел, ЭтоАтрибут = Ложь, НачальныйУзел = Истина) Экспорт
	Перем Имя, Значение, Лямбда, Состояние;

	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		//ВызватьИсключение "Неверный узел: " + Узел;
		Сообщить("Это не узел");
		Возврат "";
	КонецЕсли;

	Состояние = "";

	Имя = Узел.Имя;
	Значение = УзелСвойство(Узел, "Значение");

	Если Имя = "Истина" Тогда
		Состояние = Истина;
	ИначеЕсли Имя = "Ложь" Тогда
		Состояние = Ложь;
	ИначеЕсли Имя = "Неопределено" Тогда
		Состояние = Неопределено;
	ИначеЕсли Имя = "Пустой" Тогда
		Состояние = Пустой;
	ИначеЕсли Имя = "Число" Тогда
		Состояние = Число(Значение);
	ИначеЕсли Имя = "Строка" Тогда
		Состояние = "" + Значение;
		УзелДочерний = Дочерний(Узел);
		Если НЕ УзелДочерний = Неопределено Тогда
			Состояние = Состояние + Интерпретировать(УзелДочерний, , Ложь);
		КонецЕсли;
	ИначеЕсли (Имя = "Аргумент" ИЛИ Имя = "А") И этоАтрибут Тогда
		// объявление аргумента
		Если Значение = "Значение" Тогда
			УзелДочерний = Дочерний(Узел);
			Если НЕ УзелДочерний = Неопределено Тогда
				Состояние = " value=""" + Интерпретировать(УзелДочерний) + """ onchange=""addcmd(this)""";
			КонецЕсли;
		ИначеЕсли Значение = "ПриНажатии" Тогда
			Состояние = " onclick=""addcmd(this); return false""";
		ИначеЕсли Значение = "ПриОтправке" Тогда
			Состояние = " onsubmit=""addcmd(this); return false""";
		КонецЕсли;
	ИначеЕсли Имя = "Узел" ИЛИ Имя = "У" Тогда // объявление узла
		Если Узел = Корень Тогда
			Состояние = "<div id=""_" + Корень.Код + """>" + Интерпретировать(Дочерний(Корень), , Ложь) + "</div>";
		КонецЕсли;
		// расширения узла
		Атр = Атрибут(Узел);
		Расш = НайтиСоседний(Атр, "Родитель");
		Если Расш = Неопределено Тогда
			Расш = НайтиСоседний(Атр, "Р");
		КонецЕсли;
		Если НЕ Расш = Неопределено Тогда // если указан родитель - копируем
			Элемент = Дочерний(Узел);
			Если Элемент = Неопределено Тогда
				Если НЕ "" + Значение = "" Тогда // указано имя узла
					Определение = ОпределениеУзла(Узел, Расш.Значение);
					Если НЕ Определение = Неопределено Тогда
						Элемент = КопироватьВетку(Дочерний(Определение), ЭтотОбъект, Узел, Узел, , Ложь);
						Узел.Вставить("Дочерний", Элемент.Код);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		Иначе
			Расш = НайтиСоседний(Атр, "Функция");
			Если Расш = Неопределено Тогда
				Расш = НайтиСоседний(Атр, "Ф");
			КонецЕсли;
			Если НЕ Расш = Неопределено Тогда
				Состояние = ВызватьФункцию(Узел, Расш.Значение);
			КонецЕсли;
		КонецЕсли;

	ИначеЕсли Имя = "Оператор" ИЛИ Имя = "О" Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ЭтотОбъект);
		Параметры.Добавить(Дочерний(Узел));
		Если НЕ Значение = Неопределено Тогда
			Состояние = Рефлектор.ВызватьМетод(Операторы, "Оператор_" + Значение, Параметры);
		КонецЕсли;
	ИначеЕсли Имя = "Ссылка" ИЛИ Имя = "С" Тогда
		Состояние = Дочерний(Узел);
		Если Состояние = Неопределено Тогда
			Если НЕ "" + Значение = "" Тогда // указано имя узла
				Состояние = ОпределениеУзла(Узел, Значение);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Имя = "Копия" ИЛИ Имя = "К" Тогда // потом убрать
		Элемент = Дочерний(Узел);
		Если Элемент = Неопределено Тогда
			Если НЕ "" + Значение = "" Тогда // указано имя узла
				Определение = ОпределениеУзла(Узел, Значение);
				Если НЕ Определение = Неопределено Тогда
					Элемент = КопироватьВетку(Дочерний(Определение), ЭтотОбъект, Узел, Узел.Родитель, , Ложь);
					Узел.Вставить("Дочерний", Элемент.Код);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Состояние = Интерпретировать(Элемент, , Ложь);
	ИначеЕсли Имя = "Функция" ИЛИ Имя = "Ф" Тогда // потом убрать
		Состояние = ВызватьФункцию(Узел, Значение);
	ИначеЕсли Имя = "Значение" ИЛИ Имя = "З" Тогда
		Если НЕ "" + Значение = "" Тогда
			Состояние = УзелЗначение(Узел);
		КонецЕсли;
	ИначеЕсли Имя = "Элемент" ИЛИ Имя = "Э" Тогда
		Состояние = ПоказатьУзел(Узел, "", УзелЗначение(Узел));
	ИначеЕсли Имя = "Внешний" ИЛИ Имя = "В" Тогда // потом убрать
		//Состояние = Процесс.ВнешнийУзел(Узел, ПолучитьАргументы(Узел), ЭтотОбъект);
	ИначеЕсли Имя = "Вставить" ИЛИ Имя = "Пусть" ИЛИ Имя = "П" Тогда // П и Пусть потом убрать
		ВставитьЗначение(Узел);
		// Определение = ОпределениеУзла(Узел, Значение, Ложь);  // объявление узла
		// Если НЕ Определение = Неопределено Тогда
		// 	Элемент = Интерпретировать(Дочерний(Узел));
		// 	УзелУстановитьЗначение(Узел, Определение, Элемент);
		// КонецЕсли;
	ИначеЕсли Имя = "Указатель" Тогда
		Состояние = ПолучитьУзел(Значение); // указан код узла
	ИначеЕсли Имя = "Свойство" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Состояние = УзелСвойство(Элемент, Значение);
	ИначеЕсли Имя = "Атрибут" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Состояние = НайтиСоседний(Атрибут(Элемент), Значение).Значение;
	ИначеЕсли Имя = "Первый" Тогда
		Список = Интерпретировать(Дочерний(Узел));
		Элемент = Дочерний(Список);
		Если Элемент = Неопределено Тогда
			Элемент = Пустой;
		КонецЕсли;
		Состояние = Элемент;
	ИначеЕсли Имя = "Соседний" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		Если НЕ Элемент = Неопределено Тогда
			Элемент = Соседний(Элемент);
		КонецЕсли;
		Если Элемент = Неопределено Тогда
			Элемент = Пустой;
		КонецЕсли;
		Состояние = Элемент;
	Иначе

		Если НЕ ЭтоАтрибут Тогда
			ЗначениеУзелДочерний = "";
			УзелДочерний = Дочерний(Узел);
			Если НЕ УзелДочерний = Неопределено Тогда
				ЗначениеУзелДочерний = Интерпретировать(УзелДочерний, , Ложь);
			КонецЕсли;
			ЗначениеУзелАтрибут = "";
			УзелАтрибут = Атрибут(Узел);
			Если НЕ УзелАтрибут = Неопределено Тогда
				ЗначениеУзелАтрибут = Интерпретировать(УзелАтрибут, Истина, Ложь);
			КонецЕсли;
			Состояние = ПоказатьУзел(Узел, ЗначениеУзелАтрибут, ЗначениеУзелДочерний);
		Иначе
			ЗначениеУзелДочерний = "";
			УзелДочерний = Дочерний(Узел);
			Если НЕ УзелДочерний = Неопределено Тогда
				ЗначениеУзелДочерний = Интерпретировать(УзелДочерний, , Ложь);
			КонецЕсли;
			Состояние = ПоказатьУзел(Узел, , ЗначениеУзелДочерний, Истина);
		КонецЕсли;

	КонецЕсли;

	Если НЕ НачальныйУзел Тогда
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			Состояние = "" + Состояние + Интерпретировать(УзелСоседний, ЭтоАтрибут, Ложь);
		КонецЕсли;
	КонецЕсли;

	К = К + 1;

	Возврат Состояние;

КонецФункции // Интерпретировать()

Функция ПолучитьУзел(Код, Старший = Неопределено) Экспорт
	Узел = Узлы.Получить(Код);
	Если НЕ Узел = Неопределено Тогда
		Возврат Узел;
	КонецЕсли;
	// Если Лев(Код, 1) = "s" Тогда
	// 	Возврат Неопределено
	// КонецЕсли;
	//Стр = Данные.ПолучитьСтроку(Число(Код));
	Попытка
		Стр = Данные.ПолучитьСтроку(Число(Код));
	Исключение
		Возврат Неопределено;
		//ВызватьИсключение "Неверный код узла: " + Код;
	КонецПопытки;
	Стр = СтрРазделить(Стр, Символы.Таб);
	Ключ = Неопределено;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
			Если Ключ = "И" Тогда
				Ключ = "Имя";
			ИначеЕсли Ключ = "З" Тогда
				Ключ = "Значение";
			ИначеЕсли Ключ = "Д" Тогда
				Ключ = "Дочерний";
			ИначеЕсли Ключ = "С" Тогда
				Ключ = "Соседний";
			ИначеЕсли Ключ = "А" Тогда
				Ключ = "Атрибут";
			КонецЕсли;
		Иначе
			Если Узел = Неопределено Тогда
				Узел = Новый Структура("Код", Код);
			КонецЕсли;
			Если Ключ = "Значение" Тогда
				знСтр = СтрЗаменить(знСтр, "#x9", Символы.Таб);
				знСтр = СтрЗаменить(знСтр, "#xA", Символы.ПС);
				знСтр = СтрЗаменить(знСтр, "#xD", Символы.ВК);
			КонецЕсли;
			Узел.Вставить(Ключ, знСтр);
			Ключ = Неопределено;
		КонецЕсли;
	КонецЦикла;
	Если НЕ Старший = Неопределено Тогда
		Узел.Вставить("Старший", Старший);
		Если УзелСвойство(Старший, "Соседний") = Код Тогда
			Узел.Вставить("Родитель", Старший.Родитель);
		Иначе
			Узел.Вставить("Родитель", Старший);
		КонецЕсли;
	КонецЕсли;
	Узлы.Вставить(Код, Узел);
	Возврат Узел;
КонецФункции // ПолучитьУзел()

Функция НовыйУзел(Узел, Служебный = Ложь) Экспорт
	Если Служебный Тогда
		НовыйКод = "s" + сКоличество;
		сКоличество = сКоличество + 1;
	Иначе
		Пока КодУзла <= Количество Цикл
			КодУзла = КодУзла + 1;
			Если КодУзла > Количество Тогда
				Данные.ДобавитьСтроку("");
				Количество = Данные.КоличествоСтрок();
				Прервать;
			КонецЕсли;
			Если Данные.ПолучитьСтроку(КодУзла) = "" Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		НовыйКод = "" + КодУзла;
	КонецЕсли;
	Узел.Вставить("Код", НовыйКод);
	Узлы.Вставить(Узел.Код, Узел);
	Возврат Узел;
КонецФункции // НовыйУзел(СтруктураУзла)

Функция НовыйРодитель(Дочерний, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Дочерний.Старший);
	СтруктураУзла.Вставить("Родитель", Дочерний.Родитель);
	СтруктураУзла.Вставить("Дочерний", Дочерний.Код);
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	СтаршийУзел = Дочерний.Старший;
	Если НЕ Дочерний(СтаршийУзел) = Неопределено Тогда
		Если СтаршийУзел.Дочерний = Дочерний.Код Тогда
			СтаршийУзел.Дочерний = НовыйУзел.Код;
		КонецЕсли;
	КонецЕсли;
	Если НЕ Соседний(СтаршийУзел) = Неопределено Тогда
		Если СтаршийУзел.Соседний = Дочерний.Код Тогда
			СтаршийУзел.Соседний = НовыйУзел.Код;
		КонецЕсли;
	КонецЕсли;
	СоседнийУзел = Соседний(Дочерний);
	Если НЕ СоседнийУзел = Неопределено Тогда
		СоседнийУзел.Старший = НовыйУзел;
		НовыйУзел.Вставить("Соседний", СоседнийУзел.Код);
	КонецЕсли;
	Дочерний.Вставить("Соседний", Неопределено);
	Дочерний.Вставить("Старший", НовыйУзел);
	Дочерний.Вставить("Родитель", НовыйУзел);
	Возврат НовыйУзел;
КонецФункции // НовыйРодитель()

Функция УдалитьРодителя(Дочерний) Экспорт
	РодительУзел = Дочерний.Родитель;
	СтаршийУзел = РодительУзел.Старший;
	Если УзелСвойство(СтаршийУзел, "Дочерний") = РодительУзел.Код Тогда
		СтаршийУзел.Дочерний = Дочерний.Код;
	КонецЕсли;
	Если УзелСвойство(СтаршийУзел, "Соседний") = РодительУзел.Код Тогда
		СтаршийУзел.Соседний = Дочерний.Код;
	КонецЕсли;
	Дочерний.Вставить("Старший", РодительУзел.Старший);
	Дочерний.Вставить("Родитель", РодительУзел.Родитель);
	СоседнийУзел = Дочерний;
	Пока НЕ УзелСвойство(СоседнийУзел, "Соседний") = Неопределено Цикл
		СоседнийУзел = Соседний(СоседнийУзел);
	КонецЦикла;
	СоседнийУзелРодитель = Соседний(РодительУзел);
	Если НЕ СоседнийУзелРодитель = Неопределено Тогда
		СоседнийУзел.Вставить("Соседний", СоседнийУзелРодитель.Код);
		СоседнийУзелРодитель.Старший = СоседнийУзел;
	КонецЕсли;
КонецФункции // УдалитьРодителя()

Функция НовыйДочерний(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший);
	СтруктураУзла.Вставить("Родитель", Старший);
	УзелСоседний = Дочерний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Дочерний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйДочерний()

Функция НовыйСоседний(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший);
	СтруктураУзла.Вставить("Родитель", Старший.Родитель);
	УзелСоседний = Соседний(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Соседний", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйСоседний()

Функция НовыйАтрибут(Старший, СтруктураУзла, Служебный = Ложь) Экспорт
	СтруктураУзла.Вставить("Старший", Старший);
	СтруктураУзла.Вставить("Родитель", Старший);
	УзелСоседний = Атрибут(Старший);
	Если НЕ УзелСоседний = Неопределено Тогда
		СтруктураУзла.Вставить("Соседний", УзелСоседний.Код);
	КонецЕсли;
	НовыйУзел = НовыйУзел(СтруктураУзла, Служебный);
	Старший.Вставить("Атрибут", НовыйУзел.Код);
	Если НЕ УзелСоседний = Неопределено Тогда
		УзелСоседний.Вставить("Старший", НовыйУзел);
	КонецЕсли;
	Возврат НовыйУзел;
КонецФункции // НовыйАтрибут()

Функция Служебный(Узел)
	Если НЕ Узел = Неопределено Тогда
		Если Лев(Узел.Код, 1) = "s" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
КонецФункции // Служебный()

Функция УдалитьУзел(Узел, Совсем = Истина, НачальныйУзел = Истина) Экспорт

	УзелСоседний = Соседний(Узел);

	Если НачальныйУзел Тогда
		УзелСтарший = Узел.Старший;
		Если НЕ УзелСвойство(УзелСтарший, "Атрибут") = Неопределено Тогда
			Если УзелСтарший.Атрибут = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Атрибут");
					УзелСтарший.Атрибут = Неопределено;
				Иначе
					УзелСтарший.Атрибут = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
		Если НЕ УзелСвойство(УзелСтарший, "Дочерний") = Неопределено Тогда
			Если УзелСтарший.Дочерний = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Дочерний");
					УзелСтарший.Дочерний = Неопределено;
				Иначе
					УзелСтарший.Дочерний = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
		Если НЕ УзелСвойство(УзелСтарший, "Соседний") = Неопределено Тогда
			Если УзелСтарший.Соседний = Узел.Код Тогда
				Если УзелСоседний = Неопределено Тогда
					//УзелСтарший.Удалить("Соседний");
					УзелСтарший.Соседний = Неопределено;
				Иначе
					УзелСтарший.Соседний = УзелСоседний.Код;
					УзелСоседний.Старший = УзелСтарший;
				КонецЕсли
			КонецЕсли;
		КонецЕсли;
	Иначе
		Если НЕ УзелСоседний = Неопределено Тогда
			УдалитьУзел(УзелСоседний, Совсем, Ложь);
		КонецЕсли;
	КонецЕсли;

	Узлы.Удалить(Узел.Код);
	Если НЕ Служебный(Узел) Тогда
		Данные.ЗаменитьСтроку(Узел.Код, "");
	КонецЕсли;

	Если Совсем Тогда
		Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
			УдалитьУзел(Атрибут(Узел), Совсем, Ложь);
		КонецЕсли;
		Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
			УдалитьУзел(Дочерний(Узел), Совсем, Ложь);
		КонецЕсли;
		ОсвободитьОбъект(Узел);
	КонецЕсли;

КонецФункции // УдалитьУзел(Узел)

Функция КопироватьУзел(Узел, Буфер, ПервыйВызов = Истина) Экспорт

	Буфер.Вставить(Узел.Код, Узел);

	Если НЕ УзелСвойство(Узел, "Атрибут") = Неопределено Тогда
		КопироватьУзел(Атрибут(Узел), Буфер, Ложь);
	КонецЕсли;

	Если НЕ УзелСвойство(Узел, "Дочерний") = Неопределено Тогда
		КопироватьУзел(Дочерний(Узел), Буфер, Ложь);
	КонецЕсли;

	Если НЕ ПервыйВызов Тогда
		Если НЕ УзелСвойство(Узел, "Соседний") = Неопределено Тогда
			КопироватьУзел(Соседний(Узел), Буфер, Ложь);
		КонецЕсли;
	КонецЕсли;

КонецФункции // КопироватьУзел()

Функция НайтиСоседний(Знач Узел, ИмяУзла) Экспорт
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = ИмяУзла Тогда
			Возврат Узел;
		КонецЕсли;
		Узел = Соседний(Узел);
	КонецЦикла;
	Возврат Неопределено;
КонецФункции // НайтиСоседний()

Функция НайтиАтрибут(Знач Узел, ИмяАтрибута, ЗначениеАтрибута = Неопределено) Экспорт
	Узел = Атрибут(Узел);
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = ИмяАтрибута И ЗначениеАтрибута = УзелСвойство(Узел, "Значение") Тогда
			Возврат Узел;
		КонецЕсли;
		Узел = Соседний(Узел);
	КонецЦикла;
	Возврат Неопределено;
КонецФункции // НайтиАтрибут()

Функция Соседний(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	СоседнийУзел = УзелСвойство(Узел, "Соседний");
	Если НЕ СоседнийУзел = Неопределено Тогда
		СоседнийУзел = ПолучитьУзел(СоседнийУзел, Узел);
	КонецЕсли;
	Возврат СоседнийУзел;
КонецФункции // Соседний()

Функция Дочерний(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	ДочернийУзел = УзелСвойство(Узел, "сДочерний"); // Если изменено значение узла
	Если ДочернийУзел = Неопределено Тогда
		ДочернийУзел = УзелСвойство(Узел, "Дочерний");
	КонецЕсли;
	Если НЕ ДочернийУзел = Неопределено Тогда
		ДочернийУзел = ПолучитьУзел(ДочернийУзел, Узел);
	КонецЕсли;
	Возврат ДочернийУзел;
КонецФункции // Дочерний()

Функция Атрибут(Знач Узел) Экспорт
	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		ВызватьИсключение "Неверный узел";
	КонецЕсли;
	АтрибутУзел = УзелСвойство(Узел, "Атрибут");
	Если НЕ АтрибутУзел = Неопределено Тогда
		АтрибутУзел = ПолучитьУзел(АтрибутУзел, Узел);
	КонецЕсли;
	Возврат АтрибутУзел;
КонецФункции // Атрибут()

Функция СохранитьДанные() Экспорт
	Для каждого элУзел Из Узлы Цикл
		Если НЕ элУзел.Значение = Неопределено И НЕ Служебный(элУзел.Значение) Тогда
			Данные.ЗаменитьСтроку(ЭлУзел.Ключ, СтруктуруВСтроку(элУзел.Значение));
		КонецЕсли;
	КонецЦикла;
	Возврат Данные.ПолучитьТекст();
КонецФункции // СохранитьДанные()

Функция ПрочитатьВетку(Знач Узел, Знач СтаршийУзел = Неопределено)
	Если НЕ Узел = Неопределено Тогда

		Если НЕ СтаршийУзел = Неопределено Тогда
			УзелСтарший = УзелСвойство(Узел, "Старший");
			Если НЕ УзелСтарший = СтаршийУзел Тогда
				Сообщить("Узел " + Узел.Код + " неверный код старшего узла");
				Узел.Вставить("Старший", СтаршийУзел);
			КонецЕсли;
		КонецЕсли;

		ПолучитьУзел(Узел.Код, СтаршийУзел);
		ПрочитатьВетку(Атрибут(Узел), Узел);
		ПрочитатьВетку(Дочерний(Узел), Узел);
		ПрочитатьВетку(Соседний(Узел), Узел);
	КонецЕсли;
КонецФункции

Функция ПроверитьДанные()
	ПрочитатьВетку(Дочерний(Корень));
	Для нСтр = 1 По Данные.КоличествоСтрок() Цикл
		Если Узлы.Получить(Строка(нСтр)) = Неопределено Тогда
			Стр = Данные.ПолучитьСтроку(нСтр);
			Если НЕ Стр = "" Тогда
				Сообщить("Забытая строка " + нСтр);
				Данные.ЗаменитьСтроку(нСтр, "");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецФункции


// поиск узла внутри узла
Функция НайтиУзел(Знач Узел, ЗначениеУзла, ИмяУзла = "", ПервыйВызов = Истина) Экспорт
	Объявление = Неопределено;
	Если Узел.Имя = ИмяУзла ИЛИ (ИмяУзла = "" И (Узел.Имя = "Узел" ИЛИ Узел.Имя = "У")) Тогда
		Если "" + УзелСвойство(Узел, "Значение") = ЗначениеУзла Тогда
			Возврат Узел;
		ИначеЕсли ПервыйВызов Тогда
			УзелДочерний = Дочерний(Узел);
			Если НЕ УзелДочерний = Неопределено Тогда
				Объявление = НайтиУзел(УзелДочерний, ЗначениеУзла, ИмяУзла, Ложь);
			КонецЕсли;
		КонецЕсли;
	Иначе
		УзелДочерний = Дочерний(Узел);
		Если НЕ УзелДочерний = Неопределено Тогда
			Объявление = НайтиУзел(УзелДочерний, ЗначениеУзла, ИмяУзла, Ложь);
		КонецЕсли;
	КонецЕсли;
	Если Объявление = Неопределено Тогда
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			Объявление = НайтиУзел(УзелСоседний, ЗначениеУзла, ИмяУзла, Ложь);
		КонецЕсли;
	КонецЕсли;
	Возврат Объявление;
КонецФункции // НайтиУзел()


Функция ЗагрузитьHTML(Знач Узел, СтруктураHTML, НомерЭлемента) Экспорт
	Пока НомерЭлемента < СтруктураHTML.Количество() - 1 Цикл
		УзелСтрока = СтруктураHTML.Получить(НомерЭлемента);
		Если УзелСтрока = "_rt" Тогда
			Прервать;
		ИначеЕсли УзелСтрока = "_at" Тогда
			НомерЭлемента = НомерЭлемента + 1;
			УзелСтрока = СтруктураHTML.Получить(НомерЭлемента);
			Пока НЕ УзелСтрока = "_rt" Цикл
				стрУзла = СтрокуВСтруктуру(УзелСтрока);
				НовыйАтрибут(Узел, Новый Структура("Имя, Значение", стрУзла.attrName, стрУзла.attrVal));
				НомерЭлемента = НомерЭлемента + 1;
				УзелСтрока = СтруктураHTML.Получить(НомерЭлемента);
			КонецЦикла;
			НомерЭлемента = НомерЭлемента + 1;
			Продолжить;
		ИначеЕсли УзелСтрока = "_ch" Тогда
			НомерЭлемента = НомерЭлемента + 1;
			дУзел = НовыйДочерний(Узел, Новый Структура());
			ЗагрузитьHTML(дУзел, СтруктураHTML, НомерЭлемента)
		Иначе
			Если Узел.Свойство("Имя") Тогда
				Узел = НовыйСоседний(Узел, Новый Структура());
			КонецЕсли;
			стрУзла = СтрокуВСтруктуру(УзелСтрока);
			Если стрУзла.Свойство("tagName") Тогда
				Узел.Вставить("Имя", стрУзла.tagName);
			Иначе
				Узел.Вставить("Имя", "text");
				Узел.Вставить("Значение", стрУзла.text);
			КонецЕсли;
		КонецЕсли;
		НомерЭлемента = НомерЭлемента + 1;
	КонецЦикла;
КонецФункции // ЗагрузитьHTML()


Функция ПолучитьТекст() Экспорт
	Возврат Данные.ПолучитьТекст();
КонецФункции

Функция ПриСозданииОбъекта(обПроцесс, Текст = "", знБазаДанных = "", знИмяДанных = "", знПозицияДанных = "") Экспорт
	БазаДанных = знБазаДанных;
	ИмяДанных = знИмяДанных;
	ПозицияДанных = знПозицияДанных;
	Процесс = обПроцесс;

	Данные = Новый ТекстовыйДокумент;
	Узлы = Новый Соответствие;
	Если НЕ Текст = "" Тогда
		Данные.УстановитьТекст(Текст);
		Стр1 = Данные.ПолучитьСтроку(1);
		Если КодСимвола(Лев(Стр1, 1)) = 65279 Тогда // BOM
			Данные.ЗаменитьСтроку(1, Сред(Стр1, 2));
		КонецЕсли;
	КонецЕсли;

	Количество = Данные.КоличествоСтрок();
	сКоличество = 0;
	КодУзла = 0;
	К = 0;

	//ПроверитьДанные();
	Представление = "";
	Корень = ПолучитьУзел("1");
	Если Корень = Неопределено Тогда
		Корень = НовыйУзел(Новый Структура("Имя, Значение", "У", "Корень"));
	КонецЕсли;
	Корень.Вставить("Старший", Неопределено);
	Корень.Вставить("Родитель", Неопределено);
	Фронт = Корень;

	Библиотеки = Новый Соответствие;
	Операторы = ЗагрузитьСценарий(ОбъединитьПути(ТекущийКаталог(), "lib", "Операторы.os"));
	Рефлектор = Новый Рефлектор;
	Пустой = НовыйУзел(Новый Структура("Имя", "Пустой"), Истина);
	УзлыОбновить = Новый Соответствие;
	Обновить = Ложь;
	Изменены = Ложь;

КонецФункции
