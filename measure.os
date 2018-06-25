// изменяет код скрипта для оценки производительности в разрезе строк.
// результат пишет в .log файл

// //Функция ТочкаОстанова()
// 	СтрЗапрос = "";
// 	Пока НЕ СтрЗапрос = "Выйти" Цикл
// 		ВвестиСтроку(СтрЗапрос);
// 		Попытка
// 			Выполнить("Сообщить("+СтрЗапрос+");");
// 		Исключение
// 			Сообщить(ОписаниеОшибки());
// 		КонецПопытки;
// 	КонецЦикла;
// //КонецФункции // ТочкаОстанова()


Функция СтрокаВКод(ТекстовоеСодержимое)
	Возврат СтрЗаменить(ТекстовоеСодержимое, """", """""");
КонецФункции

Функция Вставка(ИмяФайлаСкрипта)

	Возврат "
	|
	|Var meass;
	|Var measv;
	|Var meas_file;
	|
	|Функция meas(НомерСтроки, measv1, стр)
	|	Если meas_file = Неопределено Тогда
	|		meas_file = Новый ЗаписьТекста(""" + ИмяФайлаСкрипта + ".log"");
	|		meass = ТекущаяДата();
	|	КонецЕсли;
	|	measv2 = ТекущаяДата();
	|	Замер = measv2 - ?(measv1 = Неопределено, measv2, measv1);
	|	meas_file.ЗаписатьСтроку("""" + Формат(measv2 - meass, ""ЧДЦ=3; ЧН=,0"") + Символы.Таб + Формат(Замер, ""ЧДЦ=3; ЧН=,0"") + Символы.Таб + НомерСтроки + Символы.Таб + стр);
	|	Возврат measv2;
	|КонецФункции
	|
	|Функция meas_end()
	|	meas_file.Закрыть();
	|КонецФункции
	|
	|";

КонецФункции


Функция ОбработатьФайл(ИмяФайлаСкрипта)

	ЧТ = Новый ЧтениеТекста;
	ЧТ.Открыть(ИмяФайлаСкрипта, КодировкаТекста.UTF8);

	ЗТ = Новый ЗаписьТекста(ИмяФайлаСкрипта + "m", КодировкаТекста.UTF8);

	оСтр = ЧТ.ПрочитатьСтроку();

	ПокаПерем = Истина;
	Стр = "";

	НомерСтроки = 1;
	Пока оСтр <> Неопределено Цикл // строки читаются до символа перевода строки

		Стр = СокрЛП(оСтр);
		Стр = СтрЗаменить(Стр, Символы.Таб, "");

		Если НЕ Стр = "" Тогда

			нРегСтр = нРег(Стр);
			Если ПокаПерем Тогда
				Если НЕ Лев(нРегСтр, 6) = "перем " И НЕ Лев(нРегСтр, 4) = "var " Тогда
					оСтр = Вставка(ИмяФайлаСкрипта) + оСтр;
					ПокаПерем = Ложь;
				КонецЕсли;
			КонецЕсли;
			Если Прав(Стр,1) = ";" И НЕ Лев(нРегСтр, 2) = "//" И НЕ Лев(нРегСтр, 6) = "перем " И НЕ Лев(нРегСтр, 4) = "var " И НЕ Найти("конеццикла; конецесли; endif; enddo;", нРегСтр) Тогда
				оСтр = оСтр + " стрр = """ +  СтрокаВКод(Стр) + """;";
				Если СтрНайти(стр, "Узел") Тогда
					оСтр = оСтр + Символы.Таб + "Попытка Выполнить(""стрр = стрр + (""""Узел.Код= """" + Узел.Код)""); Исключение КонецПопытки;";
				КонецЕсли;
				оСтр = оСтр + Символы.Таб + "measv = meas(" + НомерСтроки  + ", measv, стрр);";
			КонецЕсли;
			Если Лев(нРегСтр, 10) = "процедура " ИЛИ Лев(нРегСтр, 8) = "функция " ИЛИ Лев(нРегСтр, 10) = "procedure " ИЛИ Лев(нРегСтр, 9) = "function " Тогда
				оСтр = оСтр + Символы.ПС + "var measv;";
			КонецЕсли;
		КонецЕсли;
		ЗТ.ЗаписатьСтроку(оСтр);

		оСтр = ЧТ.ПрочитатьСтроку();
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;

	//ЗТ.ЗаписатьСтроку("meas_end();");

	ЧТ.Закрыть();
	ЗТ.Закрыть();

КонецФункции

ИмяФайлаСкрипта = "showdata.os";

ОбработатьФайл(ИмяФайлаСкрипта);

//ЗагрузитьСценарий(ИмяФайлаСкрипта + "m");
