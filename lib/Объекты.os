// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind


Функция УзелСвойство(Узел, Свойство) Экспорт
	УзелСвойство = Неопределено;
	Если НЕ Узел = Неопределено Тогда
		Узел.Свойство(Свойство, УзелСвойство);
	КонецЕсли;
	Возврат УзелСвойство;
КонецФункции // УзелСвойство(Узел)


Функция ИмяЗначение(Имя, Значение)
	Возврат Новый Структура("Имя, Значение", Имя, Значение);
КонецФункции


Функция НоваяФорма(Имя)
	Возврат "
	|Форма.
	|	name: '" + Имя + "'
	|	form: 'box'
	|	role: 'thing'
	|	movable: true
	|	color: 0x555555
	|	transparent: true
	|	opacity: 0.3
	|	position_x: 0
	|	position_y: 0
	|	position_z: 0
	|	scale_x: 2
	|	scale_y: 2
	|	scale_z: 2
	|";
КонецФункции // НоваяФорма()


Функция Субъект_Свойства() Экспорт
	Возврат "
	|События
	|" + НоваяФорма("Субъект") + "
	|	camera_x: 0
	|	camera_y: 50
	|	camera_z: 100
	|	role: 'player'
	|";
КонецФункции


Функция Предмет_Свойства() Экспорт
	Возврат "
	|События
	|" + НоваяФорма("Предмет");
КонецФункции


Функция Комната_Свойства() Экспорт
	Возврат "
	|События
	|" + НоваяФорма("Комната") + "
	|	role: 'room'
	|	movable: false
	|";
КонецФункции


Функция Кнопка_Свойства() Экспорт
	Возврат "
	|События
	|Текст
	|Вид
	|	button	class=btn btn-primary	onclick=addcmd(this); return false	type=button
	|		Значение: Текст
	|";
КонецФункции


Функция Надпись_Свойства() Экспорт
	Возврат "
	|События
	|Текст
	|Вид
	|";
КонецФункции


// Выполнить
Функция Выполнить_Свойства() Экспорт
	Возврат "
	|События
	|Условие
	|Тогда
	|Иначе
	|Результат
	|";
КонецФункции

Функция Выполнить_Модель(Данные, Свойства, Изменения) Экспорт
	Если Изменения.Получить(Свойства.Условие) = Истина ИЛИ Изменения.Получить(Свойства.ЭтотУзел.Родитель) = Истина Тогда
		Условие = Данные.ЗначениеСвойства(Свойства.Условие);
		Если Условие Тогда
			Результат = Данные.ЗначениеСвойства(Свойства.Тогда);
		Иначе
			Результат = Данные.ЗначениеСвойства(Свойства.Иначе);
		КонецЕсли;
		Данные.НовоеЗначениеУзла(Свойства.Результат, ИмяЗначение("" + ТипЗнч(Результат), Результат), Истина);
		Изменения.Вставить(Свойства.Результат, Истина);
	КонецЕсли;
	Возврат Изменения;
КонецФункции


// Источник данных
Функция ИсточникДанных_Свойства() Экспорт
	Возврат "
	|События
	|ЗапросДанных.
	|	БазаДанных
	|	УсловияОтбора
	|	Обновление: Авто
	|	ЧислоЗаписей: 10
	|	СписокПолей
	|	Команда: НайтиЗаголовок
	|	Задача
	|Записи.
	|";
КонецФункции

Функция ИсточникДанных_Модель(Данные, Свойства, Изменения) Экспорт
	Если Данные.ЗначениеСвойства(Свойства.ЗапросДанных.Задача) = Данные.Пустой Тогда
		Запрос = Новый Структура("Данные, Узел, ЗапросДанных, cmd", Данные, Свойства.Записи.ЭтотУзел, Данные.СвойстваВСтуктуру(Свойства.ЗапросДанных.ЭтотУзел), "ЗапросДанных");
		ИдЗадачи = Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
		Данные.НовоеЗначениеУзла(Свойства.ЗапросДанных.Задача, ИмяЗначение("Строка", ИдЗадачи), Истина);
		Изменения.Вставить(Свойства.ЗапросДанных.Задача, Истина);
	КонецЕсли;
	Возврат Изменения;
КонецФункции


// СтрокаТаблицы
Функция СтрокаТаблицы_Свойства() Экспорт
	Возврат "
	|События
	|Источник
	|Поля
	|Вид
	|	tr
	|		Значение: Содержимое
	|";
КонецФункции

Функция СтрокаТаблицы_Модель(Данные, Свойства, Изменения) Экспорт
	Если Изменения.Получить(Свойства.Источник) = Истина Тогда
	КонецЕсли;

	// Конструктор
	Если Изменения.Получить(Свойства.ЭтотУзел.Родитель) = Истина Тогда
		УзелПоля = Данные.ЗначениеСвойства(Свойства.Поля); // получить узел по ссылке
		Поля = Данные.СтруктураСвойств(УзелПоля);
		Источник = Данные.ЗначениеСвойства(Свойства.Источник); // получить узел по ссылке
		Узел = Свойства.ЭтотУзел;
		Для каждого элПоле Из Поля Цикл
			Если элПоле.Ключ = "ЭтотУзел" Тогда
				Продолжить;
			КонецЕсли;
			Поле = элПоле.Ключ;
			ПолеЗначение = УзелСвойство(Источник.Значение, Поле);
			стрУзел = ИмяЗначение("td", ПолеЗначение);
			Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
		КонецЦикла;
	КонецЕсли;

	Возврат Изменения;
КонецФункции


// Таблица
Функция Таблица_Свойства() Экспорт
	Возврат "
	|События
	|СписокПолей
	|ИсточникСтрок
	|Вид
	|	table
	|		Значение: Содержимое
	|";
КонецФункции

Функция Таблица_Модель(Данные, Свойства, Изменения) Экспорт

	УзелСвойства = Свойства.ЭтотУзел;
	УзелЗаголовок = Данные.Соседний(УзелСвойства);

	// Конструктор
	Если Изменения.Получить(Свойства.ЭтотУзел.Родитель) = Истина Тогда
		Если УзелЗаголовок = Неопределено Тогда // создать заголовок
			УзелЗаголовок = Данные.НовыйСоседний(УзелСвойства, ИмяЗначение("thread",  ""), Истина);
			Узел = Данные.НовыйДочерний(УзелЗаголовок, ИмяЗначение("tr",  ""), Истина);
			Для каждого элПоле Из Свойства.СписокПолей Цикл
				Если элПоле.Ключ = "ЭтотУзел" Тогда
					Продолжить;
				КонецЕсли;
				Поле = элПоле.Значение;
				стрУзел = ИмяЗначение("th", Данные.ЗначениеСвойства(Поле.Заголовок));
				Если Узел.Имя = "tr" Тогда
					Узел = Данные.НовыйДочерний(Узел, стрУзел, Истина);
				Иначе
					Узел = Данные.НовыйСоседний(Узел, стрУзел, Истина);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	ИсточникСтрок = Данные.ЗначениеСвойства(Свойства.ИсточникСтрок);

	Если Изменения.Получить(Свойства.ИсточникСтрок) = Истина Тогда
		Строки = Новый Соответствие;
		Пока НЕ УзелЗаголовок = Неопределено Цикл
			УзелСтроки = УзелЗаголовок;
			Строки.Вставить(УзелСтроки.Значение, "");
			УзелЗаголовок = Данные.Соседний(УзелЗаголовок);
		КонецЦикла;
		// добавить строки
		Если НЕ ИсточникСтрок = Неопределено Тогда
			ИсточникСтрок = Данные.Дочерний(ИсточникСтрок);
			Пока НЕ ИсточникСтрок = Неопределено Цикл
				ИмяСтроки = "СтрокаТаблицы " + ИсточникСтрок.Имя;
				Если Строки.Получить(ИмяСтроки) = Неопределено Тогда
					УзелСтроки = Данные.НовыйСоседний(УзелСтроки, ИмяЗначение("О", ИмяСтроки), Истина);
					СвойстваСтроки = Данные.ОбработатьОбъект(УзелСтроки);
					Данные.НовоеЗначениеУзла(СвойстваСтроки.Источник, ИмяЗначение("Указатель", ИсточникСтрок.Код), Истина);
					Данные.НовоеЗначениеУзла(СвойстваСтроки.Поля, ИмяЗначение("Указатель", Свойства.СписокПолей.ЭтотУзел.Код), Истина);
				КонецЕсли;
				ИсточникСтрок = Данные.Соседний(ИсточникСтрок);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	Возврат Изменения;
КонецФункции
