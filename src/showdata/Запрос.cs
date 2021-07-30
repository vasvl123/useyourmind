/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Dynamic;
using System.Collections.Generic;
using onesharp.Binary;

namespace onesharp
{
    public class Запрос : Структура
    {
 
        public Запрос() : base() {}

        public onesharp.Структура ЗапросДанных { get { return Получить("ЗапросДанных") as onesharp.Структура; } set { Вставить("ЗапросДанных", value); } }
        public System.String ИстДанных { get { return Получить("ИстДанных") as System.String; } set { Вставить("ИстДанных", value); } }
        public System.String БазаДанных { get { return Получить("БазаДанных") as System.String; } set { Вставить("БазаДанных", value); } }
        public string ИмяДанных { get { return Получить("ИмяДанных") as string; } set { Вставить("ИмяДанных", value); } }
        public string ПозицияДанных { get { return Получить("ПозицияДанных") as string; } set { Вставить("ПозицияДанных", value); } }
        public string ИмяШаблона { get { return Получить("ИмяШаблона") as string; } set { Вставить("ИмяШаблона", value); } }
        public onesharp.Структура РезультатДанные { get { return Получить("РезультатДанные") as onesharp.Структура; } set { Вставить("РезультатДанные", value); } }

        public string сЗадача { get { return Получить("сЗадача") as string; } set { Вставить("сЗадача", value); } }
        public Структура Параметры { get { return Получить("Параметры") as Структура; } set { Вставить("Параметры", value); } }

        public Структура Заголовок { get { return (Структура)Получить("Заголовок"); } set { Вставить("Заголовок", value); } }

        public pagedata Данные { get { return (pagedata)Получить("Данные"); } set { Вставить("Данные", value); } }
        public Узел Свойства { get { return (Узел)Получить("Свойства"); } set { Вставить("Свойства", value); } }
        public Узел События { get { return (Узел)Получить("События"); } set { Вставить("События", value); } }

        public Onesharp Библиотека { get { return (Onesharp)Получить("Библиотека"); } set { Вставить("Библиотека", value); } }

        public Запрос(Структура structure) : base(structure) { }

        public Запрос(string strProperties, params object[] values) : base(strProperties, values) { }


        private new static Задача Новый(Структура fixedStruct)
        {
            return new Задача(fixedStruct);
        }

        public new static Задача Новый(string param1, params object[] args)
        {
            return new Задача(param1, args);
        }

        public new static Задача Новый()
        {
            return new Задача();
        }

    }
}
