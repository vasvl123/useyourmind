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

Функция НоваяФорма(Имя)
	Возврат "
	|Форма
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


Функция Выполнить_Свойства() Экспорт
	Возврат "
	|События
	|Условие
	|Выражение
	|Результат
	|";
КонецФункции

Функция Выполнить_Модель(Данные, Свойства, Изменения) Экспорт
	Результат = Данные.Интерпретировать(Данные.Дочерний(Свойства.Выражение), , Ложь);
	//Если Изменения.Получить(Свойства.Условие) = Истина Тогда
	Если НЕ Результат = Неопределено Тогда
		Данные.НовоеЗначениеУзла(Свойства.Результат, Новый Структура("Имя, Значение", "" + ТипЗнч(Результат), Результат), Истина);
		Изменения.Вставить(Свойства.Результат, Истина);
	КонецЕсли;
	Возврат Изменения;
КонецФункции


Функция ИсточникДанных_Свойства() Экспорт
	Возврат "
	|События
	|Запрос
	|	БазаДанных
	|	УсловияОтбора
	|	Обновление: Авто
	|	ЧислоЗаписей: 10
	|	СписокПолей
	|	Команда: НайтиЗаголовок
	|	Задача
	|Строки
	|";
КонецФункции

Функция ИсточникДанных_Модель(Данные, Свойства, Изменения) Экспорт
	Возврат Изменения;
КонецФункции
