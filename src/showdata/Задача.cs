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
    public class Задача : Структура
    {
 
        public Задача() : base() {}

        public string ИдЗадачи { get { return Получить("ИдЗадачи") as string; } set { Вставить("ИдЗадачи", value); } }
        public string Тип { get { return Получить("Тип") as string; } set { Вставить("Тип", value); } }

        public string Этап { get { return Получить("Этап") as string; } set { Вставить("Этап", value); } }
        public Структура Запрос { get { return Получить("Запрос") as Структура; } set { Вставить("Запрос", value); } }
        public string Действие { get { return Получить("Действие") as string; } set { Вставить("Действие", value); } }
        public string Содержимое { get { return Получить("Содержимое") as string; } set { Вставить("Содержимое", value); } }

        public object Результат { get { return Получить("Результат"); } set { Вставить("Результат", value); } }
        public decimal ВремяНачало { get { return (decimal)Получить("ВремяНачало"); } set { Вставить("ВремяНачало", value); } }
        public string ЗадачаВладелец { get { return Получить("ЗадачаВладелец") as string; } set { Вставить("ЗадачаВладелец", value); } }

        public Задача(Структура structure) : base(structure) { }

        public Задача(string strProperties, params object[] values) : base(strProperties, values) { }


        /// <summary>
        /// Создает структуру по фиксированной структуре
        /// </summary>
        /// <param name="fixedStruct">Исходная структура</param>
        //[ScriptConstructor(Name = "Из фиксированной структуры")]
        private new static Задача Новый(Структура fixedStruct)
        {
            return new Задача(fixedStruct);
        }

        /// <summary>
        /// Создает структуру по заданному перечню свойств и значений
        /// </summary>
        /// <param name="param1">Фиксированная структура либо строка с именами свойств, указанными через запятую.</param>
        /// <param name="args">Только для перечня свойств:
        /// Значения свойств. Каждое значение передается, как отдельный параметр.</param>
        public new static Задача Новый(string param1, params object[] args)
        {
            return new Задача(param1, args);
        }

        public new static Задача Новый()
        {
            return new Задача();
        }

        private static RuntimeException InvalidPropertyNameException( string name )
        {
            return new RuntimeException($"Задано неправильное имя атрибута структуры '{name}'");
        }

    }
}
