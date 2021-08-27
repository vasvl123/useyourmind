﻿// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind

using System;

namespace onesharp.lib
{
	class Объекты : Onesharp
	{

		public Объекты() : base("Объекты") {}

		public object УзелСвойство(Структура Узел, string Свойство)
		{
			object УзелСвойство = null;
			if (!(Узел == Неопределено))
			{
				Узел.Свойство(Свойство, out УзелСвойство);
			}
			return УзелСвойство;
		} // УзелСвойство(Узел)


		public Узел ИмяЗначение(string Имя = "", object _Значение = null)
		{
			var Значение = (_Значение is null) ? "" : _Значение;
			return Узел.Новый("Имя, Значение", Имя, Значение);
		}

        public void ОбработатьОтвет(string Действие, treedata Данные, Узел Свойства, object Результат)
        {

            if (Действие == "ВнешниеДанные")
            {
                if (!(Результат == Неопределено))
                {
                    Свойства.д.с.Ответ.Значение = Результат;
                }
            }

            Данные.ОбъектыОбновитьДобавить(Свойства.Родитель);
            Свойства.Родитель.Вставить("Обновить", Неопределено);

        }

		public string НоваяФорма(string Имя)
		{
			var ткст =
			@"
			|Форма.
			|	name: '+Имя+' 
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
			|	scale_z: 2
			";
			ткст = Стр.Заменить(ткст, "+Имя+", Имя);
			return ткст;
		} // НоваяФорма()


		public string Субъект_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст = 
			@"
			|События
			|+НоваяФорма+
			|	camera_x: 0
			|	camera_y: 50
			|	camera_z: 100
			|	role: 'player'
			";
			ткст = Стр.Заменить(ткст, "+НоваяФорма+", НоваяФорма("Субъект"));
			return ткст;
		}


		public string Предмет_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст = 
			@"
			|События
			|+НоваяФорма+
			";
			ткст = Стр.Заменить(ткст, "+НоваяФорма+", НоваяФорма("Предмет"));
			return ткст;
		}


		public string Комната_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|+НоваяФорма+
			|	role: 'room'
			|	movable: false
			";
			ткст = Стр.Заменить(ткст, "+НоваяФорма+", НоваяФорма("Комната"));
			return ткст;
		}


		public string Кнопка_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|Текст
			|Вид
			|	button	class=btn btn - primary	onclick=addcmd(this); return false	type=button
			|		Значение: Текст
			";
			return ткст;
		}


		public string Надпись_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст = 
			@"
			|События
			|Текст
			|Вид
			";
			return ткст;
		}


		public string Задача_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст = 
			@"
			|События
			|Условие
			|Параметры.
			|Вид
			";
			return ткст;
		}

		public void Задача_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{
			var Условие = Данные.ЗначениеСвойства(Свойства.д.с.Условие) as bool?;
			if (!(Изменения.Получить(Свойства.Родитель) as bool? == Истина))
			{
				if (Изменения.Получить(Свойства.д.с.Условие) == Истина)
				{
					if (Условие == Истина)
					{
						Узел Параметры = Узел.Новый();
						foreach (КлючИЗначение элПар in Свойства.д.с.Параметры.д)
						{
							Параметры.Вставить(элПар.Ключ as string, Данные.ЗначениеСвойства(элПар.Значение as Структура));
						}
						Данные.Процесс.НоваяЗадача(Параметры, "Служебный");
					}
				}
			}
		}


		// Выполнить
		public string Выполнить_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст = 
			@"
			|События
			|Условие
			|Тогда
			|Иначе
			|Результат
			";
			return ткст;
		}

		public void Выполнить_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{
			var Инициализация = (Изменения.Получить(Свойства.Родитель) as bool? == Истина);
			if (Инициализация || Изменения.Получить(Свойства.д.с.Условие) == Истина)
			{
				object Результат;
				var Условие = Данные.ЗначениеСвойства(Свойства.д.с.Условие) as bool?;
				if (Условие == Истина)
				{
					Результат = Данные.ЗначениеСвойства(Свойства.д.с.Тогда);
				}
				else
				{
					Результат = Данные.ЗначениеСвойства(Свойства.д.с.Иначе);
				}
                Данные.НовоеЗначениеУзла(Свойства.д.с.Результат, ИмяЗначение(ТипЗнч(Результат), Результат), Истина);
				Изменения.Вставить(Свойства.д.с.Результат, Истина);
			}

		}


		public string ИсточникДанных_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|ЗапросДанных.
			|	БазаДанных
			|	УсловияОтбора
			|	Обновление: Авто
			|	ЧислоЗаписей: 10
			|	СписокПолей.
			|	Команда: НайтиЗаголовок
			|	Задача
			|Результат
			|Записи.
			";
			return ткст;
		}

		public void ИсточникДанных_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{
			var Инициализация = (Изменения.Получить(Свойства.Родитель) as bool? == Истина);
			var НовыйЗапрос = Инициализация || (Изменения.Получить(Свойства.д.с.ЗапросДанных.д.с.БазаДанных) == Истина);
			НовыйЗапрос = НовыйЗапрос || (Изменения.Получить(Свойства.д.с.ЗапросДанных) == Истина);

			if (Инициализация)
			{
				Данные.НовыйДочерний(Свойства.д.с.ЗапросДанных, ИмяЗначение("Направление"), Истина, Истина);
				Данные.НовыйДочерний(Свойства.д.с.ЗапросДанных, ИмяЗначение("НачальнаяПозиция"), Истина, Истина);
				Данные.НовыйДочерний(Свойства.д.с.ЗапросДанных, ИмяЗначение("КонечнаяПозиция"), Истина, Истина);
			}

			if (НовыйЗапрос)
			{
				var БазаДанных = Данные.ЗначениеСвойства(Свойства.д.с.ЗапросДанных.д.с.БазаДанных);
				var сЗадача = Данные.ЗначениеСвойства(Свойства.д.с.ЗапросДанных.д.с.Задача);
				if (ЗначениеЗаполнено(сЗадача))
				{
					// завершить задачу
					var Параметры = Структура.Новый("сЗадача, cmd", сЗадача, "ЗавершитьЗадачу");
					Данные.Процесс.НоваяЗадача(Параметры, "Служебный");
				}
				//Если БазаДанныхИзменена Тогда // очистить записи
				var кУзел = Свойства.д.с.Записи.Дочерний;
				while (!(кУзел == Неопределено))
				{
					кУзел.Значение = Данные.Пустой;
					Изменения.Вставить(кУзел, Истина);
					кУзел = кУзел.Соседний;
				}
				//КонецЕсли;
				var Запрос = Структура.Новый("Данные, Свойства, ЗапросДанных, cmd", Данные, Свойства, Данные.СвойстваВСтуктуру(Свойства.д.с.ЗапросДанных), "ЗапросДанных");
				var ИдЗадачи = Данные.Процесс.НоваяЗадача(Запрос, "Служебный").с.ИдЗадачи;
				Данные.НовоеЗначениеУзла(Свойства.д.с.ЗапросДанных.д.с.Задача, ИмяЗначение("Строка", ИдЗадачи), Истина);
				//Изменения.Вставить(Свойства.д.ЗапросДанных.д.Задача, Истина);
			}

			if (Изменения.Получить(Свойства.д.с.Результат) == Истина)
			{
				Узел дУзел = Свойства.д.с.Результат.Дочерний;
				while (!(дУзел == Неопределено))
				{
					var ЗапросДанные = дУзел.Значение as Структура;
					var ИмяЗаписи = "з" + ЗапросДанные.с.Позиция;
					Узел Запись = УзелСвойство(Свойства.д.с.Записи.д, ИмяЗаписи);
					if (!(Запись == Неопределено))
					{
						Запись.Значение = ЗапросДанные.с.Заголовок;
						Изменения.Вставить(Запись, Истина);
					}
					else
					{
						Запись = Узел.Новый("Имя, Значение", "з" + ЗапросДанные.с.Позиция, ЗапросДанные.с.Заголовок);
						var кУзел = Данные.НовыйДочерний(Свойства.д.с.Записи, Запись, Истина, Истина);
					}
					дУзел = дУзел.Соседний;
				}
				// удалить результаты
				дУзел = Свойства.д.с.Результат.Дочерний;
				if (!(дУзел == Неопределено))
				{
					Данные.УдалитьУзел(дУзел, Истина, Истина);
				}
				Изменения.Вставить(Свойства.д.с.Записи, Истина);
			}

		}

		public string ПанельДанных_Кнопка(int Начало, string Позиция)
		{
			var ткст =
			@"
			|*button	class=btn btn-light btn-sm	А=ПриНажатии	type=button	role=pos	pos=" + Позиция + @"
			|	Строка: " + Начало;

			return ткст;
		} ///

		// Панель данных
		public string ПанельДанных_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|ИсточникДанных
			|Количество: 10
			|Направление: Назад
			|*Начало
			|*кПозиция
			|*Страницы.
			|*Вид
			|	div
			|		div	class=btn-group
			|			button	class=btn btn-light btn-sm	А=ПриНажатии	type=button	role=bck
			|				Строка: +
			|			З: Страницы
			|			button	class=btn btn-light btn-sm	А=ПриНажатии	type=button	role=pos	pos=
			|				Строка: 0
			";
			return ткст;
		}

		public void ПанельДанных_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{

			var ИсточникДанных = Данные.ЗначениеСвойства(Свойства.д.с.ИсточникДанных);
			var Инициализация = (Изменения.Получить(Свойства.Родитель) as bool? == Истина);

			// Конструктор
			if (Инициализация)
			{
				ИсточникДанных.с.Свойства.д.с.ЗапросДанных.д.с.ЧислоЗаписей.Значение = Свойства.д.с.Количество.Значение;
				//ИсточникДанных.Свойства.д.ЗапросДанных.д.Направление.Значение = Свойства.д.Направление.Значение;
			}

			if (Изменения.Получить(Свойства.д.с.События) == Истина)
			{
				var дУзел = Свойства.д.с.События.Дочерний;
				if (!(дУзел == Неопределено))
				{
					var мСобытие = Стр.Разделить(дУзел.Значение, Символы.Таб);
					var Узел = Данные.ПолучитьУзел(мСобытие[1]);
					if (!(Узел == Неопределено))
					{
						var кПозиция = Свойства.д.с.кПозиция.Значение;
						var икПозиция = ИсточникДанных.с.Свойства.д.с.ЗапросДанных.д.с.КонечнаяПозиция.Значение;
						if (кПозиция == "" || Число(икПозиция) < Число(кПозиция))
						{
							кПозиция = икПозиция;
						}
						var Роль = "" + Данные.НайтиАтрибут(Узел, "role").Значение;
						if (Роль == "pos")
						{
							var Позиция = "" + Данные.НайтиАтрибут(Узел, "pos").Значение;
							ИсточникДанных.с.Свойства.д.с.ЗапросДанных.д.с.НачальнаяПозиция.Значение = Позиция;
						}
						else
						{
							var Количество = (int)Число(Свойства.д.с.Количество.Значение);
							var Начало = Свойства.д.с.Начало.Значение as object;
                            if (!ЗначениеЗаполнено(Начало))
							{
								Начало = 0;
							}
							else
							{
								Начало = Число(Начало);
							}
                            if (Роль == "bck")
                            {
                                ИсточникДанных.с.Свойства.д.с.ЗапросДанных.д.с.НачальнаяПозиция.Значение = кПозиция;
                                Начало = (int)Начало + Количество;
                                Свойства.д.с.Начало.Значение = "" + Начало;
                            }
							Данные.СоздатьСвойства(Свойства.д.с.Страницы, ПанельДанных_Кнопка((int)Начало, кПозиция), Истина, Ложь);
						}
						Свойства.д.с.кПозиция.Значение = кПозиция;
					}
					ИсточникДанных.с.Изменения.Вставить(ИсточникДанных.с.Свойства.д.с.ЗапросДанных, Истина);
					Данные.ОбъектыОбновить.Добавить(ИсточникДанных);
				}
				Данные.УдалитьУзел(дУзел, Истина, Истина);
				Изменения.Вставить(Свойства.д.с.События, Истина);
			}
		}

		// Таблица

		public string Таблица_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|СвойстваСтроки.
			|СписокПолей.
			|ИсточникСтрок
			|Вид
			";
			return ткст;
		}

		public void Таблица_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{

			var Инициализация = (Изменения.Получить(Свойства.Родитель) as bool? == Истина);
			var ИсточникСтрокИзменен = (Изменения.Получить(Свойства.д.с.ИсточникСтрок) == Истина);

			var УзелЗаголовок = Свойства.Соседний;

			// Конструктор
			if (Инициализация)
			{
				if (УзелЗаголовок == Неопределено)
				{ // создать заголовок
					УзелЗаголовок = Данные.НовыйСоседний(Свойства, ИмяЗначение("thread", ""), Истина);
					var Узел = Данные.НовыйДочерний(УзелЗаголовок, ИмяЗначение("tr", ""), Истина);
					foreach (КлючИЗначение элПоле in Свойства.д.с.СписокПолей.д)
					{
						Узел Поле = элПоле.Значение as Узел;
						var стрУзел = ИмяЗначение("th", Данные.ЗначениеСвойства(Поле.д.с.Заголовок));
						Данные.НовыйДочерний(Узел, стрУзел, Истина, Истина);
					}
				}
			}

			var ИсточникСтрок = Данные.ЗначениеСвойства(Свойства.д.с.ИсточникСтрок) as Узел;

			if (ИсточникСтрокИзменен)
			{
				var Строки = Соответствие.Новый();
				var УзелСтроки = Свойства;
				УзелЗаголовок = УзелСтроки.Соседний;
				while (!(УзелЗаголовок == Неопределено))
				{
					УзелСтроки = УзелЗаголовок;
					Строки.Вставить(УзелСтроки.Значение, "");
					УзелЗаголовок = УзелЗаголовок.Соседний;
				}
				// добавить строки
				if (!(ИсточникСтрок == Неопределено))
				{
                    ИсточникСтрок = ИсточникСтрок.Дочерний;
					while (!(ИсточникСтрок == Неопределено))
					{
						var ИмяСтроки = "СтрокаТаблицы " + ИсточникСтрок.Имя;
						var оСтрока = Строки.Получить(ИмяСтроки);
						if (оСтрока == Неопределено)
						{
							УзелСтроки = Данные.НовыйСоседний(УзелСтроки, ИмяЗначение("О", ИмяСтроки), Истина);
							var СвойстваСтроки = Данные.ОбработатьОбъект(УзелСтроки, Истина) as Узел;
							// дополнительные свойства
							if (Свойства.д.Свойство("СвойстваСтроки"))
							{
								Узел стСвойстваСтроки = null;
								Узел Узел = СвойстваСтроки.Дочерний;
								while (!(Узел == Неопределено))
								{
									стСвойстваСтроки = Узел;
									Узел = Узел.Соседний;
								}
								foreach (КлючИЗначение элСвойство in Свойства.д.с.СвойстваСтроки.д)
								{
									var свУзел = Данные.КопироватьВетку(элСвойство.Значение as Узел, Данные.ЭтотОбъект, стСвойстваСтроки, СвойстваСтроки);
									стСвойстваСтроки = Данные.НовыйСоседний(стСвойстваСтроки, свУзел, Истина);
								}
							}
							Данные.НовоеЗначениеУзла(СвойстваСтроки.д.с.Источник, ИмяЗначение("С", "у " + ИсточникСтрок.Код), Истина);
							var сУзел = Данные.НовыйДочерний(Свойства.д.с.Вид.Дочерний, ИмяЗначение("tr", ""), Истина, Истина);
							Данные.НовыйДочерний(сУзел, ИмяЗначение("З", "у " + СвойстваСтроки.д.с.Поля.Код), Истина, Истина);
						}
                        ИсточникСтрок = ИсточникСтрок.Соседний;
					}
				}
			}
		}

		// СтрокаТаблицы
		public string СтрокаТаблицы_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|Источник
			|Поля
			";
			return ткст;
		}

		public void СтрокаТаблицы_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{

			var Инициализация = (Изменения.Получить(Свойства.Родитель) as bool? == Истина);
			var ИсточникИзменен = (Изменения.Получить(Свойства.д.с.Источник) == Истина);

			if (ИсточникИзменен)
			{
				// удалить прежние поля
				var сУзел = Свойства.д.с.Поля.Дочерний;
				if (!(сУзел == Неопределено))
				{
					Данные.УдалитьУзел(сУзел, Истина, Истина);
				}
			}

			// Конструктор
			if (Инициализация || ИсточникИзменен)
			{
				var оУзел = Свойства.Родитель;
				Узел Источник = Данные.ЗначениеСвойства(Свойства.д.с.Источник); // получить узел по ссылке
				if (!(Источник.Значение == Данные.Пустой))
				{
					var Узел = Свойства.д.с.Поля;
					foreach (КлючИЗначение элПоле in оУзел.Родитель.с.Свойства.д.с.СписокПолей.д)
					{
						Узел свПоле = элПоле.Значение as Узел;
						Узел стрУзел = null;
						var Шаблон = УзелСвойство(свПоле.д, "Шаблон") as Узел;
						if (!(Шаблон == Неопределено))
						{
							стрУзел = Данные.КопироватьВетку(Шаблон.Дочерний, Данные.ЭтотОбъект, Узел, Свойства.д.с.Поля);
						}
						else
						{
							var Поле = элПоле.Ключ as string;
							var ПолеЗначение = УзелСвойство(Источник.с.Значение, Поле) as string;
							стрУзел = ИмяЗначение("td", ПолеЗначение);
						}
						Узел = Данные.НовыйДочерний(Свойства.д.с.Поля, стрУзел, Истина, Истина);
					}
				}
				Данные.ОбъектыОбновитьДобавить(оУзел.Родитель); // обновить таблицу
			}

		}


		public string Загрузить_Свойства(treedata Данные, Узел оУзел)
		{
			var ткст =
			@"
			|События
			|Файл
			|Сохранен
			";
			return ткст;
		}


		public void Загрузить_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
		{

			if (Изменения.Получить(Свойства.д.с.События) == Истина)
			{

				Узел дУзел = Свойства.д.с.События.Дочерний;
				if (!(дУзел == Неопределено))
				{
					var мСобытие = Стр.Разделить(дУзел.Значение as string, Символы.Таб);
					if (мСобытие[0] == "ПриОтправке")
					{
						if (дУзел.с.Параметры.Свойство("filename"))
						{
                            string[] расш = Стр.Разделить(дУзел.с.Параметры.с.filename, ".");
                            var уФайл = Свойства.д.с.Файл as Узел;
                            уФайл.Значение = "" + Цел(Данные.Процесс.ПолучитьИД()) + "." + расш[расш.Length - 1];
							Данные.Процесс.ПередатьДанныеД(Структура.Новый("ИстДанных, БазаДанных, Заголовок, Команда, дДанные, неОбратныйЗапрос", Данные.Процесс.ПолучитьСубъект(), "inbox", Структура.Новый("ИмяДанных, ТипДанных", Свойства.д.с.Файл.Значение, 2), "ЗаписатьДанные", дУзел.с.Параметры.с.fl, Неопределено));
						}
						Изменения.Вставить(Свойства.д.с.Файл, Истина);
					}
					Данные.УдалитьУзел(дУзел);
				}

			}
		}



        public string ВнешниеДанные_Свойства(treedata Данные, Узел оУзел)
        {
            object Свойства = null;
            var шСвойства = "";

            if (!(оУзел.Свойство("Свойства", out Свойства)))
            { // новый объект
                Свойства = Данные.НовыйДочерний(оУзел, ИмяЗначение("Свойства.", ""), Данные.Служебный(оУзел));
            }

            шСвойства = @"
            |*События
            |*ПараметрыЗапроса.
            |	Дата
            |*зФорма
            |	div
            |		div	class=btn-group
            |			button	class=btn btn-primary btn-sm	А=ПриНажатии	type=button	role=send
            |				Строка: Сформировать отчет
            |*Ответ: Нажмите Сформировать отчет
            |*Вид
            |	З: зФорма
            |	br
            |	З: Ответ
            ";

            Данные.СоздатьСвойства(Свойства as Узел, шСвойства, "Только");
            оУзел.Вставить("Свойства", Свойства);

            return null;

        }

        public void ВнешниеДанные_Модель(treedata Данные, Узел Свойства, Соответствие Изменения)
        {

            var оУзел = Свойства.Родитель;

            // обработать события
            if (Изменения.Получить(Свойства.д.с.События) as bool? == Истина)
            {
                var дУзел = Свойства.д.с.События.Дочерний as Узел;
                if (!(дУзел is null))
                {
                    var мСобытие = Стр.Разделить(дУзел.Значение as string, Символы.Таб);
                    var тСобытие = мСобытие[0];
                    if (тСобытие == "ПриНажатии")
                    {
                        var сУзел = Данные.ПолучитьУзел(мСобытие[1]);

                        var ЗначениеКнопка = УзелСвойство(дУзел, "Параметры") as string;
                        if (!(ЗначениеКнопка is null))
                        {

                            if (ЗначениеКнопка == "send")
                            {

                                var Запрос = Структура.Новый("Библиотека, Данные, Параметры, Свойства, cmd", this, Данные, "", Свойства, "ВнешниеДанные");
                                Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
                                
                                Свойства.д.с.Ответ.Значение = "Подождите ...";
                                Данные.ОбъектыОбновитьДобавить(Свойства.Родитель);
                                Свойства.Родитель.Вставить("Обновить", Неопределено);

                            }
                        }
                    }
                }
            }

        }



    }
}