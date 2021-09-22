﻿// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind

using System;

namespace onesharp.lib
{
    public class Функции : Onesharp
    {
        public Функции() : base("Функции") { }

        public object УзелСвойство(Структура Узел, string Свойство)
        {
            object УзелСвойство = null;
            if (!(Узел == Неопределено))
            {
                Узел.Свойство(Свойство, out УзелСвойство);
            }
            return УзелСвойство;
        } // УзелСвойство(Узел)


        public object НоваяВкладка(pagedata Данные, Структура Параметры)
        {
            Параметры.Вставить("cmd", "newtab");
            Данные.Процесс.НоваяЗадача(Параметры, "Служебный");
            return Неопределено;
        } // НоваяВкладка()


        public object НоваяБаза(pagedata Данные, Структура Параметры)
        {
            var БазаДанных = Параметры.Получить<string>("БазаДанных");
            var Запрос = Структура.Новый("Данные, БазаДанных, cmd", Данные, БазаДанных, "НоваяБаза");
            Данные.Процесс.НоваяЗадача(Запрос, "Служебный");
            return Неопределено;
        }


    }
}
