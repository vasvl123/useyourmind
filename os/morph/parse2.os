ПодключитьСценарий(ОбъединитьПути(ТекущийКаталог(), "..", "pagedata.os"), "pagedata");

Данные = Новый pagedata(ЭтотОбъект, "");

д = Данные.ПолучитьУзел("1");
д = Данные.НовыйДочерний(д, Новый Структура("Имя, Значение", "Свойства.", ""));

Для нн = 1 По 5 Цикл//4070 Цикл

	кор	= Новый ЧтениеТекста(ОбъединитьПути(ТекущийКаталог(), "ocorp" , "" + нн + ".xml"), КодировкаТекста.UTF8);
	ткор = кор.Прочитать();
	ткор = СтрЗаменить(ткор, "<token", Символы.ПС + "<token");
	ткор = СтрЗаменить(ткор, "<source", Символы.ПС + "<source");
	ткор = СтрЗаменить(ткор, "<sentence", Символы.ПС + "<sentence");
	ткор = СтрРазделить(ткор, Символы.ПС);

	н = 0;
	Пока н < ткор.Количество() Цикл

		стр = ткор.Получить(н);

		к = СтрНайти(стр, "<text");
		Если к > 0 Тогда
			к = СтрНайти(стр, "name=");
			стр = Сред(стр, к + 6);
			стр = Лев(стр, стрНайти(стр, "parent=") - 3);
			д = Данные.НовыйСоседний(д, Новый Структура("Имя, Значение", "О", "Сем.Страница"));
			дс = Данные.НовыйДочерний(д, Новый Структура("Имя, Значение", "Свойства.", ""));
			Данные.НовыйДочерний(дс, Новый Структура("Имя, Значение", "Номер", "" + нн));
			Данные.НовыйДочерний(дс, Новый Структура("Имя, Значение", "Имя", стр));
		КонецЕсли;

		к = СтрНайти(стр, "<source>");
		Если к > 0 Тогда
			стр = Сред(стр, к + 8, стрДлина(стр) - 8 - 9);
			п = Данные.НовыйСоседний(дс, Новый Структура("Имя, Значение", "О", "Сем.Предложение"));
			а = Данные.НовыйАтрибут(п, Новый Структура("Имя, Значение", "Текст", стр));
			т = Данные.НовыйСоседний(а, Новый Структура("Имя, Значение", "Грам", ""));
			дс = п;
			н = н + 1;
			Пока Истина Цикл
				стр = ткор.Получить(н);
				//Сообщить(стр);
				Если СтрНайти(стр, "sentence>") Тогда
					Прервать;
				КонецЕсли;
				к = СтрНайти(стр, "<token ");
				Если к Тогда
					мк = СтрРазделить(стр, """");
					г = "";
					Для н2 = 12 По мк.Количество() - 1 Цикл
						Если Прав(мк[н2], 1) = "=" Тогда
							г = г + мк[н2 + 1] + " ";
						КонецЕсли;
					КонецЦикла;
					Данные.НовыйДочерний(т, Новый Структура("Имя, Значение", мк[3], СокрЛП(г)), , Истина);
				КонецЕсли;
				н = н + 1;
			КонецЦикла;

		КонецЕсли;

		н = н + 1;

	КонецЦикла;

КонецЦикла;

ф = Новый ТекстовыйДокумент;
Данные.Корень.Значение = "Сем.Корень";
ф.УстановитьТекст(Данные.СохранитьДанные());
ф.Записать("../data/admin/sem.sd");