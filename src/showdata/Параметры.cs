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
    public class Параметры : Структура
    {
 
        public Параметры() : base() {}

        public string procid { get { return Получить("procid") as string; } set { Вставить("procid", value); } }
        public string ПараметрХост { get { return Получить("ПараметрХост") as string; } set { Вставить("ПараметрХост", value); } }
        public string УдаленныйУзел { get { return Получить("УдаленныйУзел") as string; } set { Вставить("УдаленныйУзел", value); } }
        public string Локальный { get { return Получить("Локальный") as string; } set { Вставить("Локальный", value); } }
        public string Хост { get { return Получить("Хост") as string; } set { Вставить("Хост", value); } }
        public int ПортВ { get { return (int)Получить("ПортВ"); } set { Вставить("ПортВ", value); } }
        public int ПортД { get { return (int)Получить("ПортД"); } set { Вставить("ПортД", value); } }
        public int ПортС { get { return (int)Получить("ПортС"); } set { Вставить("ПортС", value); } }
        public int ПортМ { get { return (int)Получить("ПортМ"); } set { Вставить("ПортМ", value); } }


        public Параметры(Структура structure) : base(structure) { }

        public Параметры(string strProperties, params object[] values) : base(strProperties, values) { }


        /// <summary>
        /// Создает структуру по фиксированной структуре
        /// </summary>
        /// <param name="fixedStruct">Исходная структура</param>
        //[ScriptConstructor(Name = "Из фиксированной структуры")]
        public new static Параметры Новый(Структура fixedStruct)
        {
            return new Параметры(fixedStruct);
        }

        /// <summary>
        /// Создает структуру по заданному перечню свойств и значений
        /// </summary>
        /// <param name="param1">Фиксированная структура либо строка с именами свойств, указанными через запятую.</param>
        /// <param name="args">Только для перечня свойств:
        /// Значения свойств. Каждое значение передается, как отдельный параметр.</param>
        public new static Параметры Новый(string param1, params object[] args)
        {
            return new Параметры(param1, args);
        }

        public new static Параметры Новый()
        {
            return new Параметры();
        }

        private static RuntimeException InvalidPropertyNameException( string name )
        {
            return new RuntimeException($"Задано неправильное имя атрибута структуры '{name}'");
        }

    }
}
