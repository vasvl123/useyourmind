﻿/*----------------------------------------------------------
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

        public System.Int32 ИдЗадачи { get { return (System.Int32)Получить("ИдЗадачи"); } set { Вставить("ИдЗадачи", value); } }
        public System.String Этап { get { return Получить("Этап") as System.String; } set { Вставить("Этап", value); } }
        public onesharp.Запрос Запрос { get { return Получить("Запрос") as Запрос; } set { Вставить("Запрос", value); } }
        public System.String Ответ { get { return Получить("Ответ") as System.String; } set { Вставить("Ответ", value); } }
        public object Результат { get { return Получить("Результат"); } set { Вставить("Результат", value); } }
        public System.Decimal ВремяНачало { get { return (System.Decimal)Получить("ВремяНачало"); } set { Вставить("ВремяНачало", value); } }
        public System.DateTime ВремяСоздания { get { return (System.DateTime)Получить("ВремяСоздания"); } set { Вставить("ВремяСоздания", value); } }

        public object Данные { get { return Получить("Данные"); } set { Вставить("Данные", value); } }
        public TCPСоединение Соединение { get { return (TCPСоединение)Получить("Соединение"); } set { Вставить("Соединение", value); } }

        public Задача(Структура structure) : base(structure) { }

        public Задача(string strProperties, params object[] values) : base(strProperties, values) { }


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
