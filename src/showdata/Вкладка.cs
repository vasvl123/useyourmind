/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Dynamic;
using System.Collections.Generic;

namespace onesharp
{
    public class Вкладка : Структура
    {
 
        public Вкладка() : base() {}

        public int ИдВкладки { get { return (int)Получить("ИдВкладки"); } set { Вставить("ИдВкладки", value); } }
        public string ИдУзла { get { return Получить("ИдУзла") as string; } set { Вставить("ИдУзла", value); } }

        public string Заголовок { get { return Получить("Заголовок") as string; } set { Вставить("Заголовок", value); } }
        public string Режим { get { return Получить("Режим") as string; } set { Вставить("Режим", value); } }
        public string ТипВкладки { get { return Получить("ТипВкладки") as string; } set { Вставить("ТипВкладки", value); } }
        public string Прокрутка { get { return Получить("Прокрутка") as string; } set { Вставить("Прокрутка", value); } }

        public bool ОбновитьУзел { get { return (bool)Получить("ОбновитьУзел"); } set { Вставить("ОбновитьУзел", value); } }
        public Соответствие УзлыОбновить { get { return Получить("УзлыОбновить") as Соответствие; } set { Вставить("УзлыОбновить", value); } }

        public string ИстДанных { get { return Получить("ИстДанных") as string; } set { Вставить("ИстДанных", value); } }
        public string БазаДанных { get { return Получить("БазаДанных") as string; } set { Вставить("БазаДанных", value); } }
        public string ИмяДанных { get { return Получить("ИмяДанных") as string; } set { Вставить("ИмяДанных", value); } }
        public string ПозицияДанных { get { return Получить("ПозицияДанных") as string; } set { Вставить("ПозицияДанных", value); } }

        public object Данные { get { return Получить("Данные"); } set { Вставить("Данные", value); } }
        public Соответствие Состояния { get { return Получить("Состояния") as Соответствие; } set { Вставить("Состояния", value); } }


        public Вкладка(Структура structure) : base(structure) { }

        public Вкладка(string strProperties, params object[] values) : base(strProperties, values) { }


        /// <summary>
        /// Создает структуру по фиксированной структуре
        /// </summary>
        /// <param name="fixedStruct">Исходная структура</param>
        //[ScriptConstructor(Name = "Из фиксированной структуры")]
        public new static Вкладка Новый(Структура fixedStruct)
        {
            return new Вкладка(fixedStruct);
        }

        /// <summary>
        /// Создает структуру по заданному перечню свойств и значений
        /// </summary>
        /// <param name="param1">Фиксированная структура либо строка с именами свойств, указанными через запятую.</param>
        /// <param name="args">Только для перечня свойств:
        /// Значения свойств. Каждое значение передается, как отдельный параметр.</param>
        public new static Вкладка Новый(string param1, params object[] args)
        {
            return new Вкладка(param1, args);
        }

        public new static Вкладка Новый()
        {
            return new Вкладка();
        }

        private static RuntimeException InvalidPropertyNameException( string name )
        {
            return new RuntimeException($"Задано неправильное имя атрибута структуры '{name}'");
        }

    }
}
