// MIT License
// Copyright (c) 2018 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB
//
// Включает программный код https://github.com/tsukanov-as/kojura


Функция Оператор_Пустой(Данные, Знач Аргумент) Экспорт
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Аргумент = Данные.Интерпретировать(Аргумент, , Ложь);
	Возврат (Аргумент = Данные.Пустой);
КонецФункции // Пустой()

Функция Оператор_Сумма(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение + Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Сумма()

Функция Оператор_Разность(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		Возврат -Значение;
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение - Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Разность()

Функция Оператор_Произведение(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение * Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Произведение()

Функция Оператор_Частное(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение / Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Частное()

Функция Оператор_Остаток(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Пока Аргумент <> Неопределено Цикл
		Значение = Значение % Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Значение;
КонецФункции // Остаток()

Функция Оператор_Если(Данные, Знач Узел) Экспорт
	Перем СписокЕсли, СписокТогда, СписокИначе;
	СписокЕсли = Узел;
	СписокТогда = Данные.Соседний(СписокЕсли);
	СписокИначе = Данные.Соседний(СписокТогда);
	Если Данные.Интерпретировать(СписокЕсли) = Истина Тогда
		Возврат Данные.Интерпретировать(СписокТогда)
	ИначеЕсли НЕ СписокИначе = Неопределено Тогда
		Возврат Данные.Интерпретировать(СписокИначе)
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции // ЗначениеВыраженияЕсли()

Функция Оператор_Выбор(Данные, Знач Список) Экспорт
	Перем СписокКогда, СписокТогда;
	СписокКогда = Список;
	Если СписокКогда = Неопределено Тогда
		ВызватьИсключение "Ожидается условие";
	КонецЕсли;
	Пока СписокКогда <> Неопределено Цикл
		СписокТогда = Данные.Соседний(СписокКогда);
		Если СписокТогда = Неопределено Тогда
			ВызватьИсключение "Ожидается выражение";
		КонецЕсли;
		Если Данные.Интерпретировать(СписокКогда) = Истина Тогда
			Возврат Данные.Интерпретировать(СписокТогда);
		КонецЕсли;
		СписокКогда = Данные.Соседний(СписокТогда);
	КонецЦикла;
	ВызватьИсключение "Ни одно из условий не сработало!";
КонецФункции // ЗначениеВыраженияВыбор()

Функция Оператор_Равно(Данные, Знач Аргумент) Экспорт
	Перем Значение, Результат;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Результат = Результат И Значение = Данные.Интерпретировать(Аргумент);
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Равно()

Функция Оператор_Больше(Данные, Знач Аргумент) Экспорт
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение1 > Значение2;
		Значение1 = Значение2;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Больше()

Функция Оператор_Меньше(Данные, Знач Аргумент) Экспорт
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение1 < Значение2;
		Значение1 = Значение2;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // Меньше()

Функция Оператор_БольшеИлиРавно(Данные, Знач Аргумент) Экспорт
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение1 >= Значение2;
		Значение1 = Значение2;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // БольшеИлиРавно()

Функция Оператор_МеньшеИлиРавно(Данные, Знач Аргумент) Экспорт
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение1 <= Значение2;
		Значение1 = Значение2;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // МеньшеИлиРавно()

Функция Оператор_НеРавно(Данные, Знач Аргумент) Экспорт
	Перем Значение1, Значение2;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значение1 = Данные.Интерпретировать(Аргумент);
	Аргумент = Данные.Соседний(Аргумент);
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение2 = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение1 <> Значение2;
		Значение1 = Значение2;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // НеРавно()

Функция Оператор_И(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Значение;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИ()

Функция Оператор_Или(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Ложь;
	Пока Аргумент <> Неопределено И Не Результат Цикл
		Значение = Данные.Интерпретировать(Аргумент);
		Результат = Результат Или Значение;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеИли()

Функция Оператор_Не(Данные, Знач Аргумент) Экспорт
	Перем Значение;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Результат = Истина;
	Пока Аргумент <> Неопределено И Результат Цикл
		Значение = Данные.Интерпретировать(Аргумент);
		Результат = Результат И Не Значение;
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Возврат Результат;
КонецФункции // ЛогическоеНе()

Функция Оператор_ВывестиСообщение(Данные, Знач Аргумент) Экспорт
	Перем Значения;
	Если Аргумент = Неопределено Тогда
		ВызватьИсключение "Ожидается аргумент";
	КонецЕсли;
	Значения = Новый Массив;
	Пока Аргумент <> Неопределено Цикл
		Значения.Добавить(Данные.Интерпретировать(Аргумент));
		Аргумент = Данные.Соседний(Аргумент);
	КонецЦикла;
	Данные.Процесс.ЗаписатьСобытие("Интерпретатор", СтрСоединить(Значения, " "), 1);
	Возврат Неопределено;
КонецФункции // ВывестиСообщение

Функция Оператор_ВСтуктуру(Данные, Знач Аргумент, Результат = Неопределено) Экспорт
	Перем Ключ, Значение;
	Если НЕ Аргумент = Неопределено Тогда
		Если Аргумент.Имя = "Узел" ИЛИ Аргумент.Имя = "У" Тогда
			Если Результат = Неопределено Тогда
				Результат = Новый Структура;
			КонецЕсли;
			Аргумент.Свойство("Значение", Ключ);
			Если НЕ Ключ = Неопределено Тогда
				Дочерний = Данные.Дочерний(Аргумент);
				Если НЕ Дочерний = Неопределено Тогда
					Значение = Оператор_ВСтуктуру(Данные, Дочерний);
				Иначе
					Значение = "";
				КонецЕсли;
				Результат.Вставить(Ключ, Значение);
			КонецЕсли;
			Соседний = Данные.Соседний(Аргумент);
			Если НЕ Соседний = Неопределено Тогда
				Результат = Оператор_ВСтуктуру(Данные, Соседний, Результат);
			КонецЕсли;
		Иначе
			Возврат Данные.Интерпретировать(Аргумент);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция Оператор_Субъект(Данные, Знач Аргумент) Экспорт
	Возврат Данные.Процесс.Субъект;
КонецФункции

Функция Оператор_ТипСобытия(Данные, Знач Аргумент) Экспорт
	Возврат ?(Аргумент = "0", "Общее", ?(Аргумент = "1", "Успех", ?(Аргумент = "2", "Внимание", "Ошибка")));
КонецФункции // ТипСобытия()
