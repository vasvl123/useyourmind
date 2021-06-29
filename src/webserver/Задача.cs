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

        public System.String ИдЗадачи{ get { return Получить("ИдЗадачи") as System.String; } set { Вставить("ИдЗадачи", value); } }
        public Контроллер структКонтроллер{ get { return Получить("структКонтроллер") as Контроллер; } set { Вставить("структКонтроллер", value); } }
        public System.Decimal ВремяНачало{ get { return (System.Decimal)Получить("ВремяНачало"); } set { Вставить("ВремяНачало", value); } }
        public onesharp.TCPСоединение Соединение{ get { return Получить("Соединение") as onesharp.TCPСоединение; } set { Вставить("Соединение", value); } }
        public string ИдКонтроллера{ get { return Получить("ИдКонтроллера") as string; } set { Вставить("ИдКонтроллера", value); } }
        public object Результат{ get { return Получить("Результат"); } set { Вставить("Результат", value); } }
        public System.String Этап{ get { return Получить("Этап") as System.String; } set { Вставить("Этап", value); } }
        public System.String УдаленныйУзел{ get { return Получить("УдаленныйУзел") as System.String; } set { Вставить("УдаленныйУзел", value); } }
        public onesharp.Соответствие Заголовок{ get { return Получить("Заголовок") as onesharp.Соответствие; } set { Вставить("Заголовок", value); } }
        public onesharp.Структура ПараметрыЗапроса{ get { return Получить("ПараметрыЗапроса") as onesharp.Структура; } set { Вставить("ПараметрыЗапроса", value); } }
        public System.String ИмяДанных{ get { return Получить("ИмяДанных") as System.String; } set { Вставить("ИмяДанных", value); } }

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
