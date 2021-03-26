// кор = Новый ТекстовыйДокумент;
// кор.Прочитать(ОбъединитьПути(ТекущийКаталог(), "morph", "rutez.xml"));
// стр = кор.ПолучитьТекст();
// стр = СтрЗаменить(стр, "<", Символы.ПС);
// стр = СтрЗаменить(стр, ">", Символы.ПС);
// кор.УстановитьТекст(стр);
// кор.Записать(ОбъединитьПути(ТекущийКаталог(), "morph", "rutez.txt"));

// ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "pagedata.os"), "pagedata");
// Данные = Новый pagedata(ЭтотОбъект, "");
// д = Данные.ПолучитьУзел("1");

ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "treedb.os"), "treedb");
тез = Новый treedb(ОбъединитьПути(ТекущийКаталог(), "morph", "Тезаурус.dat"));

м = Новый Массив;
м.Добавить(0);
тез.ДобавитьЗначение(м);

кор = Новый ТекстовыйДокумент;
кор.Прочитать(ОбъединитьПути(ТекущийКаталог(), "morph", "rutez.txt"));

рр = "";

н = 3;
Пока н < кор.КоличествоСтрок() Цикл
	Если н%1000 = 0 Тогда
		Сообщить(кор.КоличествоСтрок()-н);
	КонецЕсли;

	н = н + 1;
	стр = кор.ПолучитьСтроку(н);
	стр = СокрЛП(стр);

	Если стр = "item" Тогда
		эл = Новый Структура("rels, words, name");
		св = "";
		рр = "";
		ма = Неопределено;
		ва = Неопределено;
	ИначеЕсли стр = "name" Тогда
		зн = СокрЛП(кор.ПолучитьСтроку(н+1));
		эл.name = зн;
		н = н + 3;
	ИначеЕсли стр = "rels" Тогда
		ма = Новый Массив;
		эл.rels = ма;
		рр = "отн";
	ИначеЕсли стр = "words" Тогда
		ва = Новый Массив;
		эл.words = ва;
		рр = "сл";
	ИначеЕсли стр = "value" Тогда
		зн = СокрЛП(кор.ПолучитьСтроку(н+1));
		Если рр = "отн" Тогда
			Если св = "" Тогда
				св = зн;
			Иначе
				ма.Добавить(Новый Структура("Ключ, Значение", св, зн));
				св = "";
			КонецЕсли;
		ИначеЕсли рр = "сл" Тогда
			ва.Добавить(зн);
		КонецЕсли;
	ИначеЕсли стр = "/item" Тогда
		//ЗаписатьЭлемент
		гр = тез.МассивИзСтроки(Символ(1) + эл.name);
		нн = тез.ДобавитьЗначение(гр);
		Для каждого св Из эл.rels Цикл
			к = 0;
			Если св.Ключ = "АССОЦ" Тогда
				к = 5;
			ИначеЕсли св.Ключ = "ЧАСТЬ" Тогда
				к = 6;
			ИначеЕсли св.Ключ = "НИЖЕ" Тогда
				к = 3;
			ИначеЕсли св.Ключ = "ВЫШЕ" Тогда
				к = 2;
			ИначеЕсли св.Ключ = "ЦЕЛОЕ" Тогда
				к = 4;
			Иначе
			КонецЕсли;
			гр = тез.МассивИзСтроки(Символ(1) + св.Значение);
			з = тез.ДобавитьЗначение(гр);
			гр = Новый Массив;
			гр.Добавить(0);
			гр.Добавить(к);
			гр.Добавить(з);
			тез.ДобавитьЗначение(гр, нн);
		КонецЦикла;
		Для каждого св Из эл.words Цикл
			гр = тез.МассивИзСтроки(Символ(1) + св);
			з = тез.ДобавитьЗначение(гр);
			гр = Новый Массив;
			гр.Добавить(0);
			гр.Добавить(1);
			гр.Добавить(з);
			тез.ДобавитьЗначение(гр, нн);
		КонецЦикла;
	КонецЕсли;

	// Если Лев(стр, 1) = "/" Тогда
	// 	д = д.Родитель;
	// ИначеЕсли стр = "value" Тогда
	// 	д = Данные.НовыйДочерний(д, Новый Структура("Имя, Значение", "value", кор.ПолучитьСтроку(н+1)), , Истина);
	// 	н = н + 1;
	// ИначеЕсли стр = "name" Тогда
	// 	д = Данные.НовыйДочерний(д, Новый Структура("Имя, Значение", "name", кор.ПолучитьСтроку(н+1)), , Истина);
	// 	н = н + 1;
	// ИначеЕсли НЕ стр = "" Тогда
	// 	д = Данные.НовыйДочерний(д, Новый Структура("Имя, Значение", стр, ""), , Истина);
	// КонецЕсли;

КонецЦикла;

// ф = Новый ТекстовыйДокумент;
// ф.УстановитьТекст(Данные.СохранитьДанные());
// ф.Записать("./data/public/rutez.sd");