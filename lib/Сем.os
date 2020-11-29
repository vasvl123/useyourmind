// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind

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


Процедура ОбработатьОтвет(Действие, Данные, Свойства, Результат) Экспорт

	Если Действие = "ФормыСлов" Тогда
		Если НЕ Результат = Неопределено Тогда
			служ = Данные.Служебный(Формы);
			Для каждого Вариант Из Результат Цикл
				ф = Формы.с.Получить(Вариант.Значение.Слово);
				Если ф = Неопределено Тогда
					ф = Формы.с.Получить(СтрЗаменить(Вариант.Значение.Слово, "Ё", "Е"));
					Если ф = Неопределено Тогда
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				мРез = СтрРазделить(Вариант.Значение.Результат, Символы.ПС);
				Для каждого Рез Из мРез Цикл
					Если НЕ Рез = "" Тогда
						мФорм = СтрРазделить(Рез, Символы.Таб);
						ф0 = мФорм[0];
						ф1 = мФорм[1];
						Если ф1 = "PREP" ИЛИ ф1 = "PRCL" ИЛИ ф1 = "PNCT" ИЛИ ф1 = "CONJ" ИЛИ ф1 = "ADVB" Тогда
							ф1 = ф1 + " " + ф0;
						КонецЕсли;
						Запись = ИмяЗначение(ф0, ф1);
						у = Данные.НовыйДочерний(ф, Запись, служ, Истина); // Добавить форму
						Если мФорм.Количество() > 2 Тогда
							Данные.НовыйАтрибут(у, ИмяЗначение(мФорм[2], мФорм[3]), служ);
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		Свойства.д.Разбор.Значение = "Токены";

	ИначеЕсли Действие = "Грамматики" Тогда
		Если НЕ Свойства.Свойство("Грамматики") Тогда
			Свойства.Вставить("Грамматики", Новый Соответствие);
		КонецЕсли;
		Если НЕ Свойства.Свойство("Связи") Тогда
			Свойства.Вставить("Связи", Новый Соответствие);
		КонецЕсли;
		Для каждого б Из Результат Цикл
			мб = СтрРазделить(б.Значение, "_");
			Если Лев(б.Ключ, 2) = "св" Тогда
				св = Свойства.Связи.Получить(мб[0]);
				Если св = Неопределено Тогда
					св = Новый Массив();
					Свойства.Связи.Вставить(мб[0], св);
				КонецЕсли;
				Если св.Найти(мб[1]) = Неопределено Тогда
					св.Добавить(мб[1]);
				КонецЕсли;
			Иначе
				н = 0;
				Пока НЕ Свойства.Грамматики.Получить(мб[0] + "_" + н) = Неопределено Цикл
					н = н + 1;
				КонецЦикла;
				Свойства.Грамматики.Вставить(мб[0] + "_" + н, мб[1]);
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

	Данные.ОбъектыОбновитьДобавить(Свойства.Родитель);
	Свойства.Родитель.Вставить("Обновить", Неопределено);

КонецПроцедуры


Функция Корень_Свойства(Данные, оУзел) Экспорт

	Если НЕ оУзел.Свойство("Свойства") Тогда // новый объект
		Свойства = Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
		оУзел.Вставить("Свойства", Свойства);
	КонецЕсли;
	Если оУзел.Свойства.Дочерний = Неопределено Тогда
		шСвойства = "
		|*Формы
		|*Вид
		|	div	class=card mb-3 col-lg-7	style=background-color:rgba(255,255,255,0.3); min-height:20rem
		|		div	class=card-body
		|			h4: OpenCorpora datasets
		|			П: Содержимое
		|";
		Данные.СоздатьСвойства(оУзел.Свойства, шСвойства, "Только");
	КонецЕсли;
	Если Формы = Неопределено Тогда // формы слов
		Формы = оУзел.Свойства.д.Формы;
		Формы.Вставить("с", Новый Соответствие);
		фУзел = Формы.Дочерний;
		Пока НЕ фУзел = Неопределено Цикл
			Формы.с.Вставить(фУзел.Имя, фУзел);
			фУзел = фУзел.Соседний;
		КонецЦикла;
	КонецЕсли;
КонецФункции // Корень_Свойства()


Функция Страница_Свойства(Данные, оУзел) Экспорт

	//Если НЕ оУзел.Свойство("Свойства") Тогда // новый объект
		Свойства = оУзел.Дочерний; //Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
		шСвойства = "
		|*События
		|*Показать: Нет
		|*Кнопка
		|*Вид
		|	З: Кнопка
		|	: Если
		|		З: Показать
		|		П: Содержимое
		|";
		Данные.СоздатьСвойства(Свойства, шСвойства);
		оУзел.Вставить("Свойства", Свойства);
	//КонецЕсли;

КонецФункции


Функция Страница_Модель(Данные, Свойства, Изменения) Экспорт

	оУзел = Свойства.Родитель;

	// обработать события
	Если Изменения.Получить(Свойства.д.События) = Истина Тогда
		дУзел = Свойства.д.События.Дочерний;
		Если НЕ дУзел = Неопределено Тогда
			мСобытие = СтрРазделить(дУзел.Значение, Символы.Таб);
			тСобытие = мСобытие[0];
			Если тСобытие = "ПриНажатии" Тогда
				Если Свойства.д.Показать.Значение = "Да" Тогда
					Свойства.д.Показать.Значение = "Нет";
				Иначе
					Свойства.д.Показать.Значение = "Да";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Данные.УдалитьУзел(дУзел);
		Изменения.Вставить(Свойства.д.События, Истина);
	КонецЕсли;

	// сформировать представление
	ш = "<button id='_" + оУзел.Код + "' type='button' class='text-left btn1 btn-primary' onclick='addcmd(this,event); return false' role='sent'>.текст</button>";
	см = ?(Свойства.д.Показать.Значение = "Нет", "&#9655;", "&#9661;");
	Вид = СтрЗаменить(ш, ".текст", см);
	Вид = "<div class='btn-group' role='group'>" + Вид + СтрЗаменить(ш, ".текст", Свойства.д.Номер.Значение) + "</div>";

	Свойства.д.Кнопка.Значение = Вид;

КонецФункции


Функция Предложение_Свойства(Данные, оУзел) Экспорт
	Перем Свойства;

	Если НЕ оУзел.Свойство("Свойства", Свойства) Тогда // новый объект
		Свойства = Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
		шСвойства = "
		|Токены
		|Разбор: Нет";
		Данные.СоздатьСвойства(Свойства, шСвойства);
	КонецЕсли;

	шСвойства = "
	|*Открыть: Нет
	|*вТокен
	|*вПравило
	|*вСвязь
	|*События
	|*Вид";
	Данные.СоздатьСвойства(Свойства, шСвойства, "Только");
	оУзел.Вставить("Свойства", Свойства);

КонецФункции


Функция Предложение_Модель(Данные, Свойства, Изменения) Экспорт
	Перем Обновить, пр;

	оУзел = Свойства.Родитель;

	вТокен = Свойства.д.вТокен.Значение;
	вСвязь = Свойства.д.вСвязь.Значение;

	// обработать события
	Если Изменения.Получить(Свойства.д.События) = Истина Тогда
		дУзел = Свойства.д.События.Дочерний;
		Если НЕ дУзел = Неопределено Тогда
			мСобытие = СтрРазделить(дУзел.Значение, Символы.Таб);
			тСобытие = мСобытие[0];
			Если тСобытие = "ПриНажатии" Тогда
				сУзел = Данные.ПолучитьУзел(мСобытие[1]);

				ЗначениеКнопка = УзелСвойство(дУзел, "Параметры");
				Если НЕ ЗначениеКнопка = Неопределено Тогда

					Если ЗначениеКнопка = "sent" Тогда
						см = Свойства.д.Открыть.Значение;
						см = ?(см = "Да", "Нет", "Да");
						Свойства.д.Открыть.Значение = см;
						Если см = "Нет" Тогда
							Свойства.д.Разбор.Значение = "Нет";
							Если НЕ Свойства.д.Токены.Дочерний = Неопределено Тогда
								Данные.УдалитьУзел(Свойства.д.Токены.Дочерний, , Истина);
							КонецЕсли;
						КонецЕсли;

					ИначеЕсли ЗначениеКнопка = "optoken" Тогда

						Параметры = Новый Структура;
						Параметры.Вставить("nodeid", сУзел.Код);
						Параметры.Вставить("data", Данные.ИмяДанных);
						Параметры.Вставить("type", "win");
						Параметры.Вставить("mode", "struct");
						Параметры.Вставить("cmd", "newtab");
						Данные.Процесс.НоваяЗадача(Параметры, "Служебный");

					ИначеЕсли ЗначениеКнопка = "token" Тогда

						Если НЕ вТокен = сУзел Тогда
							Если НЕ вСвязь = "" И НЕ вТокен.Значение = "" И НЕ сУзел.Значение = "" Тогда
								// добавить связь
								фУзел1 = Формы.с.Получить(ВРег(вТокен.Имя)).Дочерний;
								Пока НЕ фУзел1 = Неопределено Цикл // варианты форм
									Если фУзел1.Значение = вТокен.Значение Тогда // форма известна
										Прервать;
									КонецЕсли;
									фУзел1 = фУзел1.Соседний;
								КонецЦикла;
								фУзел2 = Формы.с.Получить(ВРег(сУзел.Имя)).Дочерний;
								Пока НЕ фУзел2 = Неопределено Цикл // варианты форм
									Если фУзел2.Значение = сУзел.Значение Тогда // форма известна
										Прервать;
									КонецЕсли;
									фУзел2 = фУзел2.Соседний;
								КонецЦикла;
								Если НЕ фУзел1 = Неопределено И НЕ фУзел2 = Неопределено Тогда // форма токена известна
									нп = Данные.НовыйДочерний(вТокен, ИмяЗначение(вСвязь, сУзел.Имя), , Истина);
									нп.Вставить("п", Новый Структура); // параметры
									нп.п.Вставить("ток1имя", вТокен.Имя);
									нп.п.Вставить("ток1гр", фУзел1.Значение);
									нп.п.Вставить("ток1нач", ?(фУзел1.Атрибут = Неопределено, фУзел1.Имя, фУзел1.Атрибут.Имя));
									нп.п.Вставить("ток2имя", сУзел.Имя);
									нп.п.Вставить("ток2код", сУзел.Код);
									нп.п.Вставить("ток2гр", фУзел2.Значение);
									нп.п.Вставить("ток2нач", ?(фУзел2.Атрибут = Неопределено, фУзел2.Имя, фУзел2.Атрибут.Имя));
									нп.п.Вставить("б", "");
									Свойства.д.вСвязь.Значение = "";
									вСвязь = Свойства.д.вСвязь.Значение;
									сУзел.п.Вставить("т2", сУзел.п.т1); // привязка
									сУзел.п.Вставить("свкод", нп.Код);
									сУзел.п.Вставить("свимя", нп.Имя);
									сУзел.п.Вставить("ток2имя", сУзел.Имя);
								КонецЕсли;
							Иначе
								Свойства.д.вТокен.Значение = сУзел;
								вТокен = Свойства.д.вТокен.Значение;
							КонецЕсли;

						Иначе
							Свойства.д.вСвязь.Значение = "";
							вСвязь = Свойства.д.вСвязь.Значение;
							Свойства.д.вТокен.Значение = "";
							вТокен = Свойства.д.вТокен.Значение;
						КонецЕсли;

					ИначеЕсли ЗначениеКнопка = "link" Тогда

						Если НЕ Свойства.д.вПравило.Значение = сУзел Тогда
							Свойства.д.вПравило.Значение = сУзел;
						Иначе
							Свойства.д.вПравило.Значение = Неопределено;
						КонецЕсли;

					ИначеЕсли Лев(ЗначениеКнопка, 5) = "link_" Тогда

						св = Сред(ЗначениеКнопка, 6);
						Если НЕ вСвязь = св Тогда
							Свойства.д.вСвязь.Значение = св;
							вСвязь = Свойства.д.вСвязь.Значение;
						Иначе
							Свойства.д.вСвязь.Значение = "";
							вСвязь = Свойства.д.вСвязь.Значение;
						КонецЕсли;

					ИначеЕсли ЗначениеКнопка = "conf" ИЛИ ЗначениеКнопка = "excl" ИЛИ ЗначениеКнопка = "del"  ИЛИ ЗначениеКнопка = "delgr" Тогда

						Если ЗначениеКнопка = "conf" Тогда
							б = "+";
						ИначеЕсли ЗначениеКнопка = "excl" Тогда
							б = "-";
						ИначеЕсли ЗначениеКнопка = "del" Тогда
							б = "";
						ИначеЕсли ЗначениеКнопка = "delgr" Тогда
							б = "г";
						КонецЕсли;

						св = 	сУзел.п.ток1имя + Символы.Таб +
								сУзел.п.ток1нач + Символы.Таб +
								сУзел.п.ток1гр + Символы.Таб +
								сУзел.Имя + Символы.Таб +
								сУзел.п.ток2имя + Символы.Таб +
								сУзел.п.ток2нач + Символы.Таб +
								сУзел.п.ток2гр + Символы.Таб +
								б;

						Запрос = Новый Структура("Библиотека, Данные, Слова, Свойства, мДействие, cmd", ЭтотОбъект, Данные, св, Свойства, "Связи", "Морфология");
						Данные.Процесс.НоваяЗадача(Запрос, "Служебный");

						сУзел.п.б = б;

						Если б = "г" Тогда // удалить связь
							Данные.УдалитьУзел(сУзел);
						КонецЕсли;

					КонецЕсли;

				КонецЕсли;

			Иначе // изменение полей
				сУзел = Данные.ПолучитьУзел(мСобытие[1]);
				Свойства.д.вСвязь.Значение = дУзел.Параметры;
				вСвязь = Свойства.д.вСвязь.Значение;
			КонецЕсли;

		КонецЕсли;
		Данные.УдалитьУзел(дУзел);
		Изменения.Вставить(Свойства.д.События, Истина);
		оУзел.Вставить("Обновить", Истина);
	КонецЕсли;

	Если НЕ УзелСвойство(оУзел, "Обновить") = Ложь Тогда

		// найти формы
		Если Свойства.д.Разбор.Значение = "Нет" И Свойства.д.Открыть.Значение = "Да" Тогда
			Если Свойства.д.Свойство("Текст") Тогда
				служ = Данные.Служебный(Формы);
				пр = Данные.ЗначениеСвойства(Свойства.д.Текст);
				сСимв = ".,!?:;()«»""'-–…";
				Для н = 1 По стрДлина(сСимв) Цикл
					сс = Сред(сСимв, н, 1);
					пр = СтрЗаменить(пр, сс, " " + сс + " ");
				КонецЦикла;
				м = СтрРазделить(пр, " ");
				мсл = "";
				Для каждого сл Из м Цикл
					Если НЕ сл = "" Тогда
						// если есть взять готовую форму
						токФорма = "";
						Если Свойства.д.Свойство("Грам") Тогда
							тУзел = Свойства.д.Грам.Дочерний;
							Пока НЕ тУзел = Неопределено Цикл
								Если тУзел.Имя = сл Тогда
									токФорма = тУзел.Значение;
									Прервать;
								КонецЕсли;
								тУзел = тУзел.Соседний;
							КонецЦикла;
							Если токФорма = "PREP" ИЛИ токФорма = "PRCL" ИЛИ токФорма = "PNCT" ИЛИ токФорма = "CONJ" ИЛИ токФорма = "ADVB" Тогда
								токФорма = токФорма + " " + Врег(сл);
							КонецЕсли;
						КонецЕсли;
						т = Данные.НовыйДочерний(Свойства.д.Токены, ИмяЗначение(сл, токФорма), , Истина);
						Если стрНайти(сСимв, сл) = 0 Тогда
							всл = ВРег(сл);
							Если Формы.с.Получить(всл) = Неопределено Тогда
								ф = Данные.НовыйДочерний(Формы, ИмяЗначение(всл), служ, Истина);
								Формы.с.Вставить(всл, ф);
								мсл = мсл + Символы.ПС + всл;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				Запрос = Новый Структура("Библиотека, Данные, Слова, Свойства, мДействие, cmd", ЭтотОбъект, Данные, Сред(мсл, 2), Свойства, "ФормыСлов", "Морфология");
				Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
				Свойства.д.Разбор.Значение = "Формы";
			КонецЕсли;
			оУзел.Вставить("Обновить", Ложь);
		КонецЕсли;

		// найти правила
		Если Свойства.д.Разбор.Значение = "Токены" Тогда

			прГрамматики = УзелСвойство(Свойства, "Грамматики");
			Грамматики = "";
			ток1 = Свойства.д.Токены.Дочерний;
			Пока НЕ ток1 = Неопределено Цикл
				ток1.Вставить("п", Новый Структура);
				ток1Формы = Формы.с.Получить(ВРег(ток1.Имя));
				Если НЕ ток1Формы = Неопределено Тогда
					фУзел1 = ток1Формы.Дочерний;
					Пока НЕ фУзел1 = Неопределено Цикл // варианты форм
						Если НЕ "" + ток1.Значение = "" Тогда
							Если НЕ фУзел1.Значение = ток1.Значение Тогда // если форма известна
								фУзел1 = фУзел1.Соседний;
								Продолжить;
							КонецЕсли;
						КонецЕсли;
						Если Лев(фУзел1.Значение, 4) = "PREP" Тогда // предлог всегда перед
							Ток2 = Ток1.Соседний;
						Иначе
							ток2 = Свойства.д.Токены.Дочерний;
						КонецЕсли;
						Пока НЕ ток2 = Неопределено Цикл
							Если НЕ ток1 = ток2 Тогда
								ток2Формы = Формы.с.Получить(ВРег(ток2.Имя)); // формы токена
								Если НЕ ток2Формы = Неопределено Тогда
									фУзел2 = ток2Формы.Дочерний;
									Пока НЕ фУзел2 = Неопределено Цикл
										Если НЕ "" + ток2.Значение = "" Тогда // если форма известна
											Если НЕ фУзел2.Значение = ток2.Значение Тогда
												фУзел2 = фУзел2.Соседний;
												Продолжить;
											КонецЕсли;
										КонецЕсли;

										ток1нач = ?(фУзел1.Атрибут = Неопределено, фУзел1.Имя, фУзел1.Атрибут.Имя);
										ток2нач = ?(фУзел2.Атрибут = Неопределено, фУзел2.Имя, фУзел2.Атрибут.Имя);

										гр = фУзел1.Значение + Символы.Таб + фУзел2.Значение + Символы.Таб + ток1нач + Символы.Таб + ток2нач;

										Если прГрамматики = Неопределено Тогда
											Грамматики = Грамматики + Символы.ПС + гр;

										Иначе

											н = 0;
											Пока НЕ прГрамматики.Получить(гр + "_" + н) = Неопределено Цикл

												мсв = СтрРазделить(прГрамматики.Получить(гр + "_" + н), Символы.Таб);

												// найдено подходящее правило
												нп = Данные.НовыйДочерний(ток1, ИмяЗначение(мсв[0], ток2.Имя), , Истина);
												нп.Вставить("п", Новый Структура); // параметры
												нп.п.Вставить("ток1имя", ток1.имя);
												нп.п.Вставить("ток1гр", фУзел1.Значение);
												нп.п.Вставить("ток1нач", ток1нач);
												нп.п.Вставить("ток2имя", ток2.имя);
												нп.п.Вставить("ток2код", ток2.код);
												нп.п.Вставить("ток2гр", фУзел2.Значение);
												нп.п.Вставить("ток2нач", ток2нач);
												нп.п.Вставить("б", мсв[1]);

												н = н + 1;

											КонецЦикла;

										КонецЕсли;

										фУзел2 = фУзел2.Соседний;
									КонецЦикла;
								КонецЕсли;
							КонецЕсли;
							ток2 = ток2.Соседний;
						КонецЦикла;
						фУзел1 = фУзел1.Соседний;
					КонецЦикла;
				КонецЕсли;
				ток1 = ток1.Соседний;
			КонецЦикла;

			Если НЕ Грамматики = "" Тогда
				Запрос = Новый Структура("Библиотека, Данные, Слова, Свойства, мДействие, cmd", ЭтотОбъект, Данные, Сред(Грамматики, 2), Свойства, "Грамматики", "Морфология");
				Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
			Иначе
				Свойства.д.Разбор.Значение = "Привязать";
			КонецЕсли;

			оУзел.Вставить("Обновить", Ложь);

		КонецЕсли;

		//Привязать токены
		Если Свойства.д.Разбор.Значение = "Привязать" Тогда

			чРечи = Новый Массив; // порядок разбора
			чРечи.Добавить(Неопределено);
			чРечи.Добавить("ADJF");
			чРечи.Добавить("NOUN");
			чРечи.Добавить("PREP");
			чРечи.Добавить("VERB");
			чРечи.Добавить("");
			Для каждого элРечи Из чРечи Цикл
				ток1 = Свойства.д.Токены.Дочерний;
				т1 = 1;
				Пока НЕ ток1 = Неопределено Цикл
					Если элРечи = Неопределено Тогда // инициализация
						ток1.Вставить("п", Новый Структура);
						ток1.п.Вставить("т1", т1);
					ИначеЕсли ток1.п.Свойство("свкод") Тогда
						// уже привязан
					Иначе
						т2 = 1;
						ток2 = Свойства.д.Токены.Дочерний;
						Пока НЕ ток2 = Неопределено Цикл
							Если НЕ ток1 = ток2 Тогда
								св = ток2.Дочерний; // связи
								Пока НЕ св = Неопределено Цикл
									Если Лев(св.п.ток2гр, стрДлина(элРечи)) = элРечи Тогда
										Если св.п.ток2код = ток1.Код Тогда
											Если ток1.п.Свойство("т2") Тогда // уже привязан
												р1 = Число(ток1.п.т1) - Число(ток1.п.т2);
												р1 = ?(р1 < 0, - р1, р1);
												р2 = Число(ток1.п.т1) - Число(ток2.п.т1);
												р2 = ?(р2 < 0, - р2, р2);
												Если р1 < р2 Тогда
													//св.Имя = "_" + св.Имя;
													св = св.Соседний;
													Продолжить;
												КонецЕсли;
											КонецЕсли;
											Если св.п.б = "+" Тогда // корректная связь
												корр = Истина;
												Если Лев(ток1.Значение, 4) = "PREP" Тогда // если предлог проверить связь
													корр = Ложь;
													пв = ток1.Дочерний; // связи предлога
													Пока НЕ пв = Неопределено Цикл
														Если св.Имя = пв.Имя Тогда // связь та же
															пс = Данные.ПолучитьУзел(пв.п.ток2код); // токен связанный с предлогом
															Если пс.п.Свойство("свкод") Тогда
																Если пс.п.свкод = пв.Код Тогда // привязан к предлогу
																	корр = Истина;
																КонецЕсли;
															КонецЕсли;
														КонецЕсли;
														пв = пв.Соседний;
													КонецЦикла;
												КонецЕсли;
												Если корр Тогда
													ток1.п.Вставить("т2", ток2.п.т1);
													ток1.п.Вставить("свкод", св.Код);
													ток1.п.Вставить("свимя", св.Имя);
													ток1.п.Вставить("ток2имя", ток2.Имя);
												КонецЕсли;
											КонецЕсли;
									 	КонецЕсли;
									КонецЕсли;
									св = св.Соседний;
								КонецЦикла;
							КонецЕсли;
							ток2 = ток2.Соседний;
							т2 = т2 + 1;
						КонецЦикла;
					КонецЕсли;
					ток1 = ток1.Соседний;
					т1 = т1 + 1;
				КонецЦикла;
			КонецЦикла;

			Свойства.д.Разбор.Значение = "Выполнен";
			оУзел.Вставить("Обновить", Ложь);
		КонецЕсли;

		// сформировать представление
		Вид = "";
		Если Свойства.д.Свойство("Текст") Тогда // Предложение
			пр = Данные.ЗначениеСвойства(Свойства.д.Текст);
			ш = "<button id='_" + оУзел.Код + "' type='button' class='text-left btn1 btn-light' onclick='addcmd(this,event); return false' role='sent'>.текст</button>";
			см = ?(Свойства.д.Открыть.Значение = "Нет", "&#9655;", "&#9661;");
			Вид = СтрЗаменить(ш, ".текст", см);
			Если Свойства.д.Открыть.Значение = "Нет" Тогда
				Если Свойства.д.Свойство("фВид") Тогда // показать поле для ввода предложения
					Вид = Данные.ЗначениеСвойства(Свойства.д.фВид);
				Иначе
					Вид = "<div class='btn-group' role='group'>" + Вид + СтрЗаменить(ш, ".текст", пр) + "</div>";
				КонецЕсли;
			Иначе
				тУзел = Свойства.д.Токены.Дочерний;
				Пока НЕ тУзел = Неопределено Цикл
					Вид = Вид + "<button id='_" + тУзел.Код + "' type='button' class='text-left btn1 btn-" + ?(вТокен = тУзел, "info", "light") + "' onclick='addcmd(this,event); return false' role='token'>" + тУзел.Имя + "</button>";
					тУзел = тУзел.Соседний;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если НЕ Свойства.д.Разбор.Значение = "Нет" И Свойства.д.Открыть.Значение = "Да" Тогда // Токены
			тУзел = Свойства.д.Токены.Дочерний;
			Вид = Вид + "<p>" + ТокенВид(Данные, Свойства, тУзел) + "</p>";
		КонецЕсли;

		Если НЕ вТокен = "" Тогда // выбрать связь
			// показать виды связей
			нСв = "";
			Связи = Новый Массив;
			Если НЕ вСвязь = "" Тогда
				Связи.Добавить(вСвязь);
			Иначе
				Если НЕ вТокен = "" Тогда
					// м = Свойства.Связи.Получить(вТокен.Значение);
					// Если НЕ м = Неопределено Тогда
					// 	Для каждого св Из м Цикл
					// 		Связи.Добавить(св);
					// 	КонецЦикла;
					// КонецЕсли;
				КонецЕсли;
				Связи.Добавить("+");
			КонецЕсли;
			Если вСвязь = "+" Тогда
				нСв = нСв + "<input id='" + вТокен.Код + "' type='text' class='form-control-sm' onchange='addcmd(this,event); return false' role='link'></input>";
				нСв = нСв + "<script>$('#" + вТокен.Код + "')[0].focus();</script>";
			Иначе
				Для каждого св Из Связи Цикл
					Если вСвязь = "" ИЛИ св = вСвязь Тогда
						нСв = нСв + "<button id='_" + вТокен.Код + "' type='button' class='text-left btn1 btn-" + ?(вСвязь = "", "secondary", "warning") + "' onclick='addcmd(this,event); return false' role='link_" + св + "'>" + св + "</button>";
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			Вид = СтрЗаменить(Вид, "<!--t_" + вТокен.Код + "-->", "<ul>" + нСв + "</ul>");
		КонецЕсли;

		Свойства.д.Вид.Значение = "<p>" + Вид + "</p>";

	КонецЕсли;

	Возврат Обновить;

КонецФункции

Функция ТокенВид(Данные, Свойства, Знач дУзел, мУзел = Неопределено, рУзел = Неопределено)
	Связи = "";
	вТокен = Свойства.д.вТокен.Значение;
	Пока НЕ дУзел = Неопределено Цикл
		Связь = "";
		Если дУзел.Родитель = Свойства.д.Токены Тогда
			мУзел = Новый Массив;
			мУзел.Добавить(дУзел);
			Если вТокен = "" Тогда
				Если дУзел.Свойство("п") Тогда
					Если дУзел.п.Свойство("свкод") Тогда // привязан к другому
						дУзел = дУзел.Соседний;
						Продолжить;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если вТокен = "" ИЛИ вТокен = дУзел Тогда
				Связь = "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + ?(вТокен = дУзел, "info", "light") + "' onclick='addcmd(this,event); return false' role='" + ?(вТокен = дУзел, "optoken" , "token") + "'>" + дУзел.Имя + "</button>";
				Если НЕ дУзел.Дочерний = Неопределено Тогда
					Связь = Связь + ТокенВид(Данные, Свойства, дУзел.Дочерний, мУзел);
				КонецЕсли;
			КонецЕсли;
		Иначе
			Если НЕ рУзел = Неопределено Тогда
				Если НЕ рУзел.Имя = дУзел.Имя Тогда // у предлога должна совпадать связь
					дУзел = дУзел.Соседний;
					Продолжить;
			 	КонецЕсли;
			КонецЕсли;
			Если вТокен = дУзел.Родитель ИЛИ НЕ дУзел.п.б = "-" Тогда // связь не некорректная
				тУзел = Данные.ПолучитьУзел(дУзел.п.ток2код);
				Если НЕ вТокен = дУзел.Родитель И тУзел.п.Свойство("свкод") Тогда
					Если НЕ тУзел.п.свкод = дУзел.Код Тогда // не тот токен привязан
						тУзел = Неопределено;
					КонецЕсли;
				КонецЕсли;
				Если НЕ тУзел = Неопределено Тогда
					Если мУзел.Найти(тУзел) = Неопределено Тогда
						мУзел.Добавить(тУзел);
						Если вТокен = дУзел.Родитель ИЛИ дУзел.п.б = "+" Тогда
							Связь = "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + ?(дУзел.п.б = "-", "danger", ?(дУзел.п.б = "+" И НЕ вТокен = "", "success", "secondary")) + "' onclick='addcmd(this,event); return false' role='optoken'>" + дУзел.Имя + "</button>";
							Связь = Связь + "<button id='_" + тУзел.Код + "' type='button' class='text-left btn1 btn-light' onclick='addcmd(this,event); return false' role='token'>" + дУзел.Значение + "</button>";
							Если НЕ вТокен = "" Тогда
								Если дУзел.п.б = "" Тогда
									Связь = Связь + "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + "secondary" + "' onclick='addcmd(this,event); return false' role='conf'>&#9745;</button>";
									Связь = Связь + "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + "secondary" + "' onclick='addcmd(this,event); return false' role='excl'>&#9746;</button>";
									Связь = Связь + "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + "secondary" + "' onclick='addcmd(this,event); return false' role='delgr'>&#10008;</button>";
								Иначе
									Связь = Связь + "<button id='_" + дУзел.Код + "' type='button' class='text-left btn1 btn-" + "secondary" + "' onclick='addcmd(this,event); return false' role='del'>&#9744;</button>";
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
						Если НЕ тУзел.Дочерний = Неопределено И дУзел.п.б = "+" Тогда
							Если Лев(дУзел.п.ток2гр, 4) = "PREP" Тогда
								зСвязь = ТокенВид(Данные, Свойства, тУзел.Дочерний, мУзел, дУзел);
								Если НЕ вТокен = дУзел.Родитель И зСвязь = "" Тогда
									Связь = "";
								КонецЕсли;
								Связь = Связь + зСвязь;
							Иначе
								Связь = Связь + ТокенВид(Данные, Свойства, тУзел.Дочерний, мУзел);
							КонецЕсли;
						КонецЕсли;
						мУзел.Удалить(мУзел.Найти(тУзел));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если НЕ Связь = "" Тогда
			Связь = Связь + "<!--t_" + дУзел.Код + "-->";
			Связь = "<ul>" + Связь + "</ul>";
			Связи = Связи + Связь;
		КонецЕсли;
		дУзел = дУзел.Соседний;
	КонецЦикла;
	Возврат Связи;
КонецФункции // ТокенВид()
