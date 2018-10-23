// MIT License
// Copyright (c) 2018 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//
// Включает программный код https://github.com/tsukanov-as/kojura

Перем БазаДанных Экспорт;
Перем ИмяФайла Экспорт;

Перем Данные;
Перем КодУзла;
Перем Узлы Экспорт;
Перем Изменены Экспорт;
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
Перем Шаг Экспорт;


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
	Рез = Неопределено;
	Для Каждого знСтр Из Стр Цикл
		Если Ключ = Неопределено Тогда
			Ключ = знСтр;
		Иначе
			Если Рез = Неопределено Тогда
				Рез = Новый Структура;
			КонецЕсли;
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
	УзлыОбновить.Вставить(Узел, Связи);
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

		АтрибутИмя = СтрЗаменить(УзелИмя, "xml_lang", "xml:lang");
		АтрибутИмя = СтрЗаменить(АтрибутИмя, "_", "-");
		Представление = Представление + " " + АтрибутИмя + "=""" + УзелЗначение + """";

	Иначе

		Если УзелИмя = "Элемент" ИЛИ УзелИмя = "Э" Тогда
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
Функция КопироватьВетку(Узел, Цель, Старший, Родитель, ЭтоАтрибут = Ложь, ПервыйВызов = Истина, Служебный = Истина) Экспорт

	ИмяУзла = УзелСвойство(Узел, "Имя");
	ЗначениеУзла = УзелСвойство(Узел, "Значение");

	КопияУзел = Цель.НовыйУзел(Новый Структура("Имя, Значение, Старший, Родитель", ИмяУзла, ЗначениеУзла, Старший, Родитель), Служебный ИЛИ Служебный(Узел));

	Если НЕ ЭтоАтрибут Тогда

		УзелАтрибут = Атрибут(Узел);
		Если НЕ УзелАтрибут = Неопределено Тогда
			УзелАтрибут = КопироватьВетку(УзелАтрибут, Цель, КопияУзел, КопияУзел, Истина, Ложь, Служебный ИЛИ Служебный(УзелАтрибут));
			КопияУзел.Вставить("Атрибут", УзелАтрибут.Код);
		КонецЕсли;

	КонецЕсли;

	УзелДочерний = Дочерний(Узел);
	Если НЕ УзелДочерний = Неопределено Тогда
		УзелДочерний = КопироватьВетку(УзелДочерний, Цель, КопияУзел, КопияУзел, , Ложь, Служебный ИЛИ Служебный(УзелДочерний));
		КопияУзел.Вставить("Дочерний", УзелДочерний.Код);
	КонецЕсли;

	Если ПервыйВызов Тогда
		КопияУзел.Вставить("Соседний", Неопределено);
	Иначе
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			УзелСоседний = КопироватьВетку(УзелСоседний, Цель, КопияУзел, Родитель, ЭтоАтрибут, Ложь, Служебный ИЛИ Служебный(УзелСоседний));
			КопияУзел.Вставить("Соседний", УзелСоседний.Код);
		КонецЕсли;
	КонецЕсли;

	Возврат КопияУзел;

КонецФункции // КопироватьВетку()


// Получить значение узла
Функция УзелЗначение(Знач Узел) Экспорт

	Состояние = Неопределено;
	ИмяУзла = УзелСвойство(Узел, "Значение");

	Если НЕ "" + ИмяУзла = "" Тогда // нужно найти определение узла
		ОпределениеУзла = ОпределениеУзла(Узел, ИмяУзла);
		Если НЕ ОпределениеУзла = Неопределено Тогда
			Состояние = УзелСостояние(ОпределениеУзла, "ЗначениеУзла"); // оптимизация
			Если Состояние = Неопределено Тогда
				Состояние = Интерпретировать(Дочерний(ОпределениеУзла), , Ложь);
				УзелСостояниеЗначение(ОпределениеУзла, "ЗначениеУзла", Состояние); // оптимизация
			КонецЕсли;
		КонецЕсли;
	Иначе // получить значение узла
		Состояние = УзелСостояние(Узел, "ЗначениеУзла"); // оптимизация
		Если Состояние = Неопределено Тогда
			Состояние = Интерпретировать(Дочерний(Узел), , Ложь);
			УзелСостояниеЗначение(Узел, "ЗначениеУзла", Состояние); // оптимизация
		КонецЕсли;
	КонецЕсли;

	Возврат Состояние;

КонецФункции


// Установить значения узла
Функция УзелУстановитьЗначение(Знач Узел, Знач УзелЗначение) Экспорт

	Состояние = Неопределено;
	ИмяУзла = УзелСвойство(Узел, "Значение");

	Если НЕ "" + ИмяУзла = "" Тогда // указано имя узла

		// объявление узла
		Определение = ОпределениеУзла(Узел, ИмяУзла, Ложь);

		Если НЕ Определение = Неопределено Тогда

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
				УзлыОбновить.Вставить(Определение, Связи);
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Возврат Состояние;

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
	ЭтоФронт = Истина;
	Пока НЕ Узел = Неопределено Цикл
		Если Узел.Имя = "Элемент" ИЛИ Узел.Имя = "Э" Тогда
			Если "" + УзелСвойство(Узел, "Значение") = "Фронт" Тогда
				ЭтоФронт = Ложь;
			КонецЕсли;
		Иначе
			// узлы объявленные в атрибутах
			// Если НЕ Узел = АтрибутРодитель И (Узел.Имя = "Копия" ИЛИ Узел.Имя = "К" ИЛИ Узел.Имя = "Функция" ИЛИ Узел.Имя = "Ф") Тогда
			// 	Атрибут = Атрибут(Узел);
			// 	Пока НЕ Атрибут = Неопределено Цикл
			// 		Узел = Атрибут;
			// 		АтрибутРодитель = Узел.Родитель;
			// 		Атрибут = Соседний(Атрибут);
			// 	КонецЦикла;
			// КонецЕсли;
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
					УзелСостояниеЗначение(НачальныйУзел, "ЭтоФронт", ЭтоФронт);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		//Родитель = Узел.Родитель;
		Узел = Узел.Старший;
	КонецЦикла;

	Если Узел = Неопределено Тогда
		ВызватьИсключение СтрШаблон("" + НачальныйУзел.Код + " - неизвестный узел %1", ИмяЭлемента);
	КонецЕсли;

	Если Дочерний(Узел) = Неопределено Тогда
		ВызватьИсключение СтрШаблон("Неверное определение узла %1", ИмяЭлемента);
	КонецЕсли;

	Возврат Узел;
КонецФункции // ОпределениеУзла()


// Функция ОбновитьДанные(Запрос) Экспорт
// 	Для каждого элПараметр Из Запрос Цикл
//
// 		Определение = НайтиУзел(Корень, элПараметр.Ключ);
// 		Если НЕ Определение = Неопределено Тогда
// 			Элемент = НовыйУзел(Новый Структура("Имя, Значение", "Строка", элПараметр.Значение), Истина);
// 			Элемент.Вставить("Старший", Определение);
// 			Элемент.Вставить("Родитель", Определение);
// 			Определение.Вставить("сДочерний", Элемент.Код);
// 			УзелСостояниеЗначение(Определение, "ЗначениеУзла", Неопределено); // будет обновляться
//
// 			// Установить для обновления узлы которые нужно обновить
// 			Связи = УзелСостояние(Определение, "Связи");
// 			Если НЕ Связи = Неопределено Тогда
// 				УзлыОбновить.Вставить(Определение, Связи);
// 			КонецЕсли;
// 		КонецЕсли;
// 	КонецЦикла;
// КонецФункции // ОбновитьДанные()


Функция ОбновитьПредставление(знОбновить = Ложь) Экспорт

	Представление = "";
	Если знОбновить Тогда
		Обновить = Истина;
	КонецЕсли;
	Если Обновить Тогда
		ОбновитьУзел(Фронт);
	КонецЕсли;

	Циклов = 0;
	СписокЭлементов = Новый Соответствие;

	Пока Циклов < 10 И УзлыОбновить.Количество() Цикл

	 	СписокУзлов = Новый Соответствие;
		// узлы которые нужно обновить
		Для каждого элУзел Из УзлыОбновить Цикл
			Связи = элУзел.Значение;
			Для каждого элСвязь Из Связи Цикл
				Если элСвязь.Значение = ЭтотОбъект Тогда
					РодительУзел = элСвязь.Ключ;
					Пока НЕ РодительУзел = Неопределено Цикл
						Если РодительУзел.Имя = "Элемент" ИЛИ РодительУзел.Имя = "Э"
							ИЛИ РодительУзел.Имя = "Узел" ИЛИ РодительУзел.Имя = "У" Тогда
								СписокУзлов.Вставить(РодительУзел.Код, РодительУзел);
								Прервать;
						ИначеЕсли РодительУзел.Имя = "Функция" ИЛИ РодительУзел.Имя = "Ф" Тогда // функция будет пересчитана
							УзелСостояниеЗначение(РодительУзел, "Состояние", Неопределено);
							ОсвободитьОбъект(Дочерний(РодительУзел));
							РодительУзел.Вставить("Дочерний", Неопределено);
						КонецЕсли;
						Если РодительУзел = Фронт Тогда
							Прервать;
						КонецЕсли;
						РодительУзел = РодительУзел.Родитель;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		УзлыОбновить.Очистить();

		Если СписокУзлов.Количество() Тогда
			Для каждого элУзел Из СписокУзлов Цикл
				РодительУзел = элУзел.Значение;
				// Если НЕ РодительУзел = УзелЗначение Тогда // Источник обновлять не надо
					ПервыйНайден = Ложь;
					// Установить для обновления узлы которые нужно обновить
					Связи = УзелСостояние(РодительУзел, "Связи");
					Если НЕ Связи = Неопределено Тогда
						УзлыОбновить.Вставить(РодительУзел, Связи);
						УзелСостояниеЗначение(РодительУзел, "ЗначениеУзла", Неопределено);
					КонецЕсли;
					// Поиск элемента для обновления
					Пока НЕ РодительУзел = Неопределено Цикл
						Если РодительУзел.Имя = "Функция" ИЛИ РодительУзел.Имя = "Ф" Тогда
							УзелСостояниеЗначение(РодительУзел, "Состояние", Неопределено);
						ИначеЕсли РодительУзел.Имя = "Элемент" ИЛИ РодительУзел.Имя = "Э" Тогда
							УзелСостояниеЗначение(РодительУзел, "Состояние", Неопределено);
							Если НЕ ПервыйНайден Тогда
								// будет обновлено состояние узла
								СписокЭлементов.Вставить(РодительУзел.Код, РодительУзел);
								УзелСостояниеЗначение(РодительУзел, "ОбновитьУзел", Истина);
								ПервыйНайден = Истина;
							КонецЕсли;
						КонецЕсли;
						Если РодительУзел = Фронт Тогда
							Прервать;
						КонецЕсли;
						РодительУзел = РодительУзел.Родитель;
					КонецЦикла;
				// КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		СписокУзлов.Очистить();

		Циклов = Циклов + 1;
	КонецЦикла;
	Сообщить(ИмяФайла + " циклов:" + Циклов);

	// обновить элементы
	Если СписокЭлементов.Количество() Тогда
		Для каждого элУзел Из СписокЭлементов Цикл
			Попытка
				Если УзелСостояние(элУзел.Значение, "Ошибка") = Неопределено Тогда
					Представление = Представление + Интерпретировать(элУзел.Значение);
				КонецЕсли;
			Исключение
				Процесс.ЗаписатьСобытие("Интерпретатор", ОписаниеОшибки(), 3);
				Сообщить(ОписаниеОшибки());
				Инфо = ИнформацияОбОшибке();
				Стек = Инфо.ПолучитьСтекВызовов();
				Для каждого Кадр Из Стек Цикл
					Сообщить(Кадр.ИмяМодуля + " / " + Кадр.Метод + " / " + Кадр.НомерСтроки);
				КонецЦикла;
				УзелСостояниеЗначение(элУзел.Значение, "Ошибка", Истина);
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;

	УзлыОбновить.Очистить();
	Обновить = Ложь;

КонецФункции


Функция ВызватьФункцию(Знач Узел, Знач ИмяФункции)

	Состояние = Неопределено; //УзелСостояние(Узел, "Состояние"); // оптимизация

	Если Состояние = Неопределено Тогда

		Элемент = Дочерний(Узел);
		Если Элемент = Неопределено Тогда

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
						Аргументы = Новый Структура("ЭтотУзел", Узел);
						Аргумент = Атрибут(Узел);
						Пока НЕ Аргумент = Неопределено Цикл
							Если Аргумент.Имя = "Аргумент" ИЛИ Аргумент.Имя = "А" Тогда
								Аргументы.Вставить(Аргумент.Значение, Интерпретировать(Дочерний(Аргумент), , Ложь));
							КонецЕсли;
							Аргумент = Соседний(Аргумент);
						КонецЦикла;
						Параметры = Новый Массив;
						Параметры.Добавить(ЭтотОбъект);
						Параметры.Добавить(Аргументы);
						Элемент = Рефлектор.ВызватьМетод(Библиотека, ИмяФункции, Параметры);
						Прервать;
					КонецЦикла;
					Если Параметры = Неопределено Тогда
						ВызватьИсключение "Функция " + ИмяФункции + " не найдена";
					КонецЕсли;
				Иначе
					ВызватьИсключение "Библиотека " + ИмяБиблиотеки + " не найдена";
				КонецЕсли;

				Если НЕ Элемент = Неопределено Тогда
					Узел.Вставить("Дочерний", Элемент.Код);
				КонецЕсли;

			КонецЕсли;
		КонецЕсли;

		Если НЕ Элемент = Неопределено Тогда
			Состояние = Интерпретировать(Элемент, , Ложь);
		Иначе
			Состояние = "";
		КонецЕсли;
		//УзелСостояниеЗначение(Узел, "Состояние", Состояние); // Новое значение

	КонецЕсли;

	Возврат Состояние;

КонецФункции // ВызватьФункцию()


Функция Интерпретировать(Знач Узел, ЭтоАтрибут = Ложь, НачальныйУзел = Истина) Экспорт
	Перем Имя, Значение, Лямбда, Состояние;

	Если НЕ ТипЗнч(Узел) = Тип("Структура") Тогда
		//Возврат Узел;
		ВызватьИсключение "Неверный узел: " + Узел;
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
	ИначеЕсли (Имя = "Аргумент" ИЛИ Имя = "А") И этоАтрибут Тогда
		// объявление аргумента
		Если Значение = "Значение" Тогда
			УзелДочерний = Дочерний(Узел);
			Если НЕ УзелДочерний = Неопределено Тогда
				Состояние = " value=""" + Интерпретировать(УзелДочерний) + """ onchange=""addcmd(this)""";
			КонецЕсли;
		ИначеЕсли Значение = "ПриНажатии" Тогда
			Состояние = " onclick=""return addcmd(this)""";
		ИначеЕсли Значение = "ПриОтправке" Тогда
			Состояние = " onsubmit=""return addcmd(this)""";
		КонецЕсли;
	ИначеЕсли Имя = "Узел" ИЛИ Имя = "У" Тогда
		// объявление узла
	ИначеЕсли Имя = "Оператор" ИЛИ Имя = "О" Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ЭтотОбъект);
		Параметры.Добавить(Дочерний(Узел));
		Состояние = Рефлектор.ВызватьМетод(Операторы, "Оператор" + Значение, Параметры);
	ИначеЕсли Имя = "Ссылка" ИЛИ Имя = "С" Тогда
		Состояние = Дочерний(Узел);
		Если Состояние = Неопределено Тогда
			Если НЕ "" + Значение = "" Тогда // указано имя узла
				Состояние = ОпределениеУзла(Узел, Значение);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Имя = "Копия" ИЛИ Имя = "К" Тогда
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
	ИначеЕсли Имя = "Функция" ИЛИ Имя = "Ф" Тогда
		Состояние = ВызватьФункцию(Узел, Значение);
	ИначеЕсли Имя = "Значение" ИЛИ Имя = "З" Тогда
		Состояние = УзелЗначение(Узел);
	ИначеЕсли Имя = "Настройка" ИЛИ Имя = "Н" Тогда
		Состояние = Процесс.НастройкаЗначение(Узел, ЭтотОбъект);
	ИначеЕсли Имя = "Пусть" ИЛИ Имя = "П" Тогда
		Элемент = Интерпретировать(Дочерний(Узел));
		УзелУстановитьЗначение(Узел, Элемент);
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

		Если Имя = "Элемент" ИЛИ Имя = "Э" Тогда

			Состояние = Неопределено;

			Если УзелСостояние(Узел, "ОбновитьУзел") = Ложь ИЛИ Обновить Тогда
				Если НачальныйУзел И НЕ Обновить Тогда
					Состояние = "";
				Иначе
					Состояние = УзелСостояние(Узел, "Состояние");
				КонецЕсли;
			КонецЕсли;

			Если Состояние = Неопределено Тогда
				УзелДочерний = Дочерний(Узел);
				Если НЕ УзелДочерний = Неопределено Тогда
					Состояние = ПоказатьУзел(Узел, , Интерпретировать(Дочерний(Узел), , Ложь));
				Иначе
					Состояние = "";
				КонецЕсли;
				УзелСостояниеЗначение(Узел, "Состояние", Состояние);
				УзелСостояниеЗначение(Узел, "ОбновитьУзел", Ложь);
			КонецЕсли;

		Иначе

			Если НЕ ЭтоАтрибут Тогда
				УзелДочерний = Дочерний(Узел);
				Если НЕ УзелДочерний = Неопределено Тогда
					ЗначениеУзелДочерний = Интерпретировать(УзелДочерний, , Ложь);
				КонецЕсли;
				УзелАтрибут = Атрибут(Узел);
				Если НЕ УзелАтрибут = Неопределено Тогда
					ЗначениеУзелАтрибут = Интерпретировать(УзелАтрибут, Истина, Ложь);
				КонецЕсли;
				Состояние = ПоказатьУзел(Узел, ЗначениеУзелАтрибут, ЗначениеУзелДочерний);
			Иначе
				Состояние = ПоказатьУзел(Узел, , , Истина);
			КонецЕсли;

		КонецЕсли;

	КонецЕсли;

	Если НЕ НачальныйУзел Тогда
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			Состояние = "" + Состояние + Интерпретировать(УзелСоседний, ЭтоАтрибут, Ложь);
		КонецЕсли;
	КонецЕсли;

	Шаг = Шаг + 1;

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
	Стр = Данные.ПолучитьСтроку(Число(Код));
	// Попытка
	// 	Стр = Данные.ПолучитьСтроку(Число(Код));
	// Исключение
	// 	ВызватьИсключение "Неверный код узла: " + Код;
	// КонецПопытки;
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
		НовыйКод = "s" + Узлы.Количество();
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
	Если Служебный(Узел) Тогда
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

Функция СохранитьДанные(ИмяФайлаДанных) Экспорт
	Для каждого элУзел Из Узлы Цикл
		Если НЕ элУзел.Значение = Неопределено И НЕ Служебный(элУзел.Значение) Тогда
			Данные.ЗаменитьСтроку(ЭлУзел.Ключ, СтруктуруВСтроку(элУзел.Значение));
		КонецЕсли;
	КонецЦикла;
	Данные.Записать(ИмяФайлаДанных);
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


// поиск узла вглубь
Функция НайтиУзел(Знач Узел, ИмяУзла) Экспорт
	Объявление = Неопределено;
	Если Узел.Имя = "Узел" ИЛИ Узел.Имя = "У" ИЛИ Узел.Имя = "Элемент" ИЛИ Узел.Имя = "Э" Тогда
		Если "" + УзелСвойство(Узел, "Значение") = ИмяУзла Тогда
			Возврат Узел;
		КонецЕсли;
	КонецЕсли;
	УзелДочерний = Дочерний(Узел);
	Если НЕ УзелДочерний = Неопределено Тогда
		Объявление = НайтиУзел(УзелДочерний, ИмяУзла);
	КонецЕсли;
	Если Объявление = Неопределено Тогда
		УзелСоседний = Соседний(Узел);
		Если НЕ УзелСоседний = Неопределено Тогда
			Объявление = НайтиУзел(УзелСоседний, ИмяУзла);
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


Функция ПриСозданииОбъекта(обПроцесс, знБазаДанных = "", знИмяФайла)
	БазаДанных = знБазаДанных;
	ИмяФайла = знИмяФайла;
	Процесс = обПроцесс;
	Количество = 0;
	КодУзла = 0;
	Шаг = 0;
	Данные = Новый ТекстовыйДокумент;
	Узлы = Новый Соответствие;
	Если НЕ ИмяФайла = "" Тогда
		Попытка
			ИмяФайлаДанных = ОбъединитьПути(ТекущийКаталог(), "data", БазаДанных + ".files", ИмяФайла);
			Данные.Прочитать(ИмяФайлаДанных);
			Сообщить(ИмяФайлаДанных);
			Корень = ПолучитьУзел("1");
		Исключение
			Сообщить("Файл данных не найден: " + ИмяФайлаДанных);
		КонецПопытки;
		Если Корень = Неопределено Тогда
			Корень = НовыйУзел(Новый Структура("Имя, Значение", "У", "Корень"));
		КонецЕсли;
		Количество = Данные.КоличествоСтрок();
	КонецЕсли;
	Библиотеки = Новый Соответствие;
	Операторы = ЗагрузитьСценарий(ОбъединитьПути(ТекущийКаталог(), "lib", "Операторы.os"));
	Рефлектор = Новый Рефлектор;
	Пустой = НовыйУзел(Новый Структура("Имя", "Пустой"), Истина);
	УзлыОбновить = Новый Соответствие;
	Корень.Вставить("Старший", Неопределено);
	Корень.Вставить("Родитель", Неопределено);
	Обновить = Ложь;
	Изменены = Ложь;
	//ПроверитьДанные();
	Фронт = НайтиУзел(Корень, "Фронт");
	Если Фронт = Неопределено Тогда
		Сообщить("Фронт не найден");
		Фронт = Корень;
	КонецЕсли;
КонецФункции
