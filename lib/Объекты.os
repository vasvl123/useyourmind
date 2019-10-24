// MIT License
// Copyright (c) 2019 Vladimir Vasiliev
// https://github.com/vasvl123/OneScriptDB

Функция СоздатьСвойства(Данные, парСвойства, стрСвойства)
	св = Неопределено;
	Свойства = Новый Структура;
	Для каждого эл Из стрСвойства Цикл
		Если св = Неопределено Тогда
			св = Данные.НовыйДочерний(парСвойства, Новый Структура("Имя, Значение", эл.Ключ, эл.Значение));
		Иначе
			св = Данные.НовыйСоседний(св, Новый Структура("Имя, Значение", эл.Ключ, эл.Значение));
		КонецЕсли;
		Свойства.Вставить(эл.Ключ, св);
	КонецЦикла;
	Данные.УзелСостояниеЗначение(парСвойства, "Свойства", Свойства); // оптимизация
	Возврат Свойства;
КонецФункции // СоздатьСвойства(стрСвойства)

Функция НоваяФорма(Данные, парФорма)
	стрСвойства = Новый Структура;
	стрСвойства.Вставить("type", "'box'");
	стрСвойства.Вставить("movable", "true");
	стрСвойства.Вставить("color", "0x555555");
	стрСвойства.Вставить("transparent", "true");
	стрСвойства.Вставить("opacity", "0.3");
	стрСвойства.Вставить("position_x", "0");
	стрСвойства.Вставить("position_y", "0");
	стрСвойства.Вставить("position_z", "0");
	стрСвойства.Вставить("scale_x", "20");
	стрСвойства.Вставить("scale_y", "10");
	стрСвойства.Вставить("scale_z", "20");
	Свойства = СоздатьСвойства(Данные, парФорма, стрСвойства);
	Возврат Свойства;
КонецФункции // НоваяФорма()

Функция ПолучитьСвойства(Данные, парСвойства)
	Свойства = Данные.УзелСостояние(парСвойства, "Свойства");
	Если Свойства = Неопределено Тогда
		Свойства = Новый Структура;
		св = Данные.Дочерний(парСвойства);
		Пока НЕ св = Неопределено Цикл
			Свойства.Вставить(св.Имя, св);
			св = Данные.Соседний(св);
		КонецЦикла;
		Данные.УзелСостояниеЗначение(парСвойства, "Свойства", Свойства); // оптимизация
	КонецЕсли;
	Возврат Свойства;
КонецФункции // ПолучитьСвойства()

Функция ФормаВид(Данные, парСвойства)
	Свойства = ПолучитьСвойства(Данные, парСвойства);
	Вид = "<script>var p = {id: '" + парСвойства.Код + "', fid: '" + Свойства.Форма.Код + "', name: '" + парСвойства.Родитель.Значение + "'";
	св = Данные.Дочерний(Свойства.Форма);
	Пока не св = Неопределено Цикл
		Вид = Вид + "," + св.Имя + ":" + св.Значение;
		св = Данные.Соседний(св);
	КонецЦикла;
	Вид = Вид + "};";
	Возврат Вид;
КонецФункции // ФормаВид()

Функция Комната(Данные, Параметры) Экспорт
	Перем парСвойства, Свойства;

	ЭтотУзел = Параметры.ЭтотУзел;

	Если НЕ Параметры.Свойство("Свойства", парСвойства) Тогда
		парСвойства = Данные.НовыйСоседний(Данные.Атрибут(ЭтотУзел), Новый Структура("Имя, Значение", "Свойства", ""));
		стрСвойства = Новый Структура;
		стрСвойства.Вставить("Тип", "Комната");
		стрСвойства.Вставить("Описание", "Комната");
		стрСвойства.Вставить("Форма", "");
		Свойства = СоздатьСвойства(Данные, парСвойства, стрСвойства);
		Форма = НоваяФорма(Данные, Свойства.Форма);
		Форма.type.Значение = "'room'";
		Форма.movable.Значение = "false";
	КонецЕсли;

	Если Свойства = Неопределено Тогда
		Свойства = ПолучитьСвойства(Данные, парСвойства);
		Форма = ПолучитьСвойства(Данные, Свойства.Форма);
	КонецЕсли;

	// обработка свойств

	// представление объекта
	Вид = ФормаВид(Данные, парСвойства);

	Возврат Вид + " var id=""_" + ЭтотУзел.Код + """; updifrm(id,p);</script>";

КонецФункции


Функция Предмет(Данные, Параметры) Экспорт
	Перем парСвойства, Свойства;

	ЭтотУзел = Параметры.ЭтотУзел;

	Если НЕ Параметры.Свойство("Свойства", парСвойства) Тогда
		парСвойства = Данные.НовыйСоседний(Данные.Атрибут(ЭтотУзел), Новый Структура("Имя, Значение", "Свойства", ""));
		стрСвойства = Новый Структура;
		стрСвойства.Вставить("Тип", "Предмет");
		стрСвойства.Вставить("Описание", "Предмет");
		стрСвойства.Вставить("Форма", "");
		Свойства = СоздатьСвойства(Данные, парСвойства, стрСвойства);
		НоваяФорма(Данные, Свойства.Форма);
	КонецЕсли;

	Если Свойства = Неопределено Тогда
		Свойства = ПолучитьСвойства(Данные, парСвойства);
		Форма = ПолучитьСвойства(Данные, Свойства.Форма);
	КонецЕсли;

	// обработка свойств

	// представление объекта
	Вид = ФормаВид(Данные, парСвойства);

	Возврат Вид + " var id=""_" + ЭтотУзел.Код + """; updifrm(id,p);</script>";

КонецФункции
