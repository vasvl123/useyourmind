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

        public Структура д { get { return Получить<Структура>("д"); } }
        public Структура п { get { return Получить<Структура>("п"); } }

        public string Код { get { return (string)Получить("Код"); } }
        public string Имя { get { return (string)Получить("Имя"); } }
        public object Значение { get { return Получить("Значение"); } set { Вставить("Значение", value); } }

        public Узел Дочерний { get { return Получить("Дочерний") as Узел; } set { Вставить("Дочерний", value); } }
        public Узел Соседний { get { return Получить("Соседний") as Узел; } set { Вставить("Соседний", value); } }
        public Узел Атрибут { get { return Получить("Атрибут") as Узел; } set { Вставить("Атрибут", value); } }
        public Узел Старший { get { return Получить("Старший") as Узел; } set { Вставить("Старший", value); } }
        public Узел Родитель { get { return Получить("Родитель") as Узел; } set { Вставить("Родитель", value); } }

        public string ТипОбъекта { get { return (string)Получить("ТипОбъекта"); } }
        public Узел Свойства { get { return (Узел)Получить("Свойства"); } }

        public Узел(Структура structure) : base(structure) { }

        public Узел(string strProperties, params object[] values) : base(strProperties, values) { }

        public new static Узел Новый(Структура fixedStruct)
        {
            return new Узел(fixedStruct);
        }

        public new static Узел Новый(string param1, params object[] args)
        {
            return new Узел(param1, args);
        }

        public new static Узел Новый()
        {
            return new Узел();
        }

    }
}
