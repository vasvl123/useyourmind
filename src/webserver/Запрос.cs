﻿/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Dynamic;
using System.Collections.Generic;
using onesharp;

namespace webserver
{
    public class Запрос : Структура
    {
 
        public Запрос() : base() {}

        public onesharp.Соответствие Заголовок{ get { return Получить("Заголовок") as onesharp.Соответствие; } set { Вставить("Заголовок", value); } }
        public System.String ИмяКонтроллера{ get { return Получить("ИмяКонтроллера") as System.String; } set { Вставить("ИмяКонтроллера", value); } }
        public System.String ИмяМетода{ get { return Получить("ИмяМетода") as System.String; } set { Вставить("ИмяМетода", value); } }

        public Запрос(Структура structure) : base(structure) { }

        public Запрос(string strProperties, params object[] values) : base(strProperties, values) { }

        private new static Запрос Новый(Структура fixedStruct)
        {
            return new Запрос(fixedStruct);
        }

        public new static Запрос Новый(string param1, params object[] args)
        {
            return new Запрос(param1, args);
        }

        public new static Запрос Новый()
        {
            return new Запрос();
        }

    }
}
