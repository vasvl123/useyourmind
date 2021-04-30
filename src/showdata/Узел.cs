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
    public class Узел : Структура
    {
 
        public Узел() : base() {}

        public Соответствие _с { get { return this["_с"] as Соответствие; } }
        public Структура _д { get { return this["д"] as Структура; } }
        public dynamic д { get { return this["д"]; } }
        public Структура _п { get { return this["п"] as Структура; } }
        public dynamic п { get { return this["п"]; } }

        public string Код { get { return (string)Получить("Код"); } }
        public string Имя { get { return (string)Получить("Имя"); } }
        public object Значение { get { return Получить("Значение"); } set { Вставить("Значение", value); } }

        public Узел Дочерний { get { return Получить("Дочерний") as Узел; } set { Вставить("Дочерний", value); } }
        public Узел Соседний { get { return Получить("Соседний") as Узел; } set { Вставить("Соседний", value); } }
        public Узел Атрибут { get { return Получить("Атрибут") as Узел; } set { Вставить("Атрибут", value); } }
        public Узел Старший { get { return Получить("Старший") as Узел; } set { Вставить("Старший", value); } }
        public Узел Родитель { get { return Получить("Родитель") as Узел; } set { Вставить("Родитель", value); } }

        public Узел(Структура structure) : base(structure) { }

        public Узел(string strProperties, params object[] values) : base(strProperties, values) { }


        /// <summary>
        /// Создает структуру по фиксированной структуре
        /// </summary>
        /// <param name="fixedStruct">Исходная структура</param>
        //[ScriptConstructor(Name = "Из фиксированной структуры")]
        public new static Узел Новый(Структура fixedStruct)
        {
            return new Узел(fixedStruct);
        }

        /// <summary>
        /// Создает структуру по заданному перечню свойств и значений
        /// </summary>
        /// <param name="param1">Фиксированная структура либо строка с именами свойств, указанными через запятую.</param>
        /// <param name="args">Только для перечня свойств:
        /// Значения свойств. Каждое значение передается, как отдельный параметр.</param>
        public new static Узел Новый(string param1, params object[] args)
        {
            return new Узел(param1, args);
        }

        public new static Узел Новый()
        {
            return new Узел();
        }

        private static RuntimeException InvalidPropertyNameException( string name )
        {
            return new RuntimeException($"Задано неправильное имя атрибута структуры '{name}'");
        }

    }
}
