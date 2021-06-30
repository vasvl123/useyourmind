/*----------------------------------------------------------
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
    public class Контроллер : Структура
    {
 
        public Контроллер() : base() {}

        public System.String ИдКонтроллера{ get { return Получить("ИдКонтроллера") as System.String; } set { Вставить("ИдКонтроллера", value); } }
        public System.String Хост{ get { return (System.String)Получить("Хост"); } set { Вставить("Хост", value); } }
        public System.Int32 Порт{ get { return (System.Int32)Получить("Порт"); } set { Вставить("Порт", value); } }
        public System.Decimal ВремяНачало{ get { return (System.Decimal)Получить("ВремяНачало"); } set { Вставить("ВремяНачало", value); } }


        public Контроллер(Структура structure) : base(structure) { }

        public Контроллер(string strProperties, params object[] values) : base(strProperties, values) { }

        private new static Контроллер Новый(Структура fixedStruct)
        {
            return new Контроллер(fixedStruct);
        }

        public new static Контроллер Новый(string param1, params object[] args)
        {
            return new Контроллер(param1, args);
        }

        public new static Контроллер Новый()
        {
            return new Контроллер();
        }

    }
}
