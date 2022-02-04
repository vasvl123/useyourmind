﻿using System;
using onesharp;
using onesharp.Binary;

namespace parse
{
    public class parse : useyourmind
    {

        public parse() : base("parse") { }

        public void parse_ruez()
        {
            
            //var кор = Новый.ТекстовыйДокумент();
            //кор.Прочитать(ОбъединитьПути(ТекущийКаталог(), "rutez.xml"));
            //var стр = кор.ПолучитьТекст();
            //стр = Стр.Заменить(стр, "<", Символы.ПС);
            //стр = Стр.Заменить(стр, ">", Символы.ПС);
            //кор.УстановитьТекст(стр);
            //кор.Записать(ОбъединитьПути(ТекущийКаталог(), "rutez.txt"));
            var тез = new treedb(ОбъединитьПути(ТекущийКаталог(), "Тезаурус1"));

            var кор = Новый.ТекстовыйДокумент();
            кор.Прочитать(ОбъединитьПути(ТекущийКаталог(), "rutez.txt"));
            var рр = "";
            var н = 3;

            Структура эл = null;
            Массив ма = null;
            Массив ва = null;
            var св = "";

            while (н < кор.КоличествоСтрок())
            {

                if (н % 1000 == 0)
                {
                    Сообщить(кор.КоличествоСтрок() - н);
                }
                н = н + 1;
                var стр = кор.ПолучитьСтроку(н);
                стр = СокрЛП(стр);
                if (стр == "item")
                {
                    эл = Новый.Структура("rels, words, name");
                    св = "";
                    рр = "";
                    ма = null;
                    ва = null;
                }
                else if (стр == "name")
                {
                    var зн = СокрЛП(кор.ПолучитьСтроку(н + 1));
                    эл["name"] = зн;
                    н = н + 3;
                }
                else if (стр == "rels")
                {
                    ма = Новый.Массив();
                    эл["rels"] = ма;
                    рр = "отн";
                }
                else if (стр == "words")
                {
                    ва = Новый.Массив();
                    эл["words"] = ва;
                    рр = "сл";
                }
                else if (стр == "value")
                {
                    var зн = СокрЛП(кор.ПолучитьСтроку(н + 1));
                    if (рр == "отн")
                    {
                        if (св == "")
                        {
                            св = зн;
                        }
                        else
                        {
                            ма.Добавить(Новый.Структура("Ключ, Значение", св, зн));
                            св = "";
                        }
                    }
                    else if (рр == "сл")
                    {
                        ва.Добавить(зн);
                    }
                }
                else if (стр == "/item")
                {

                    var Имя = тез.НайтиСтроку(эл["name"] as string, Истина);

                    foreach (Структура св1 in эл["rels"] as Массив)
                    {
                        var свойство = тез.НайтиСтроку(св1["Ключ"] as string, Истина);
                        var у = тез.ПрочитатьУзел(тез.СвойствоСтроки(Имя, свойство));

                        var ну = new _Узел();
                        ну._Имя = тез.НайтиСтроку(св1["Значение"] as string, Истина);
                        var нн = тез.ЗаписатьУзел(ref ну);

                        if (у._Атрибут == 0)
                        {
                            у._Атрибут = нн;
                            тез.ЗаписатьУзел(ref у);
                        }
                        else
                        {
                            var сс = тез.ПрочитатьУзел(у._Атрибут);
                            while (сс._Соседний != 0)
                                сс = тез.ПрочитатьУзел(сс._Соседний);

                            сс._Соседний = нн;
                            тез.ЗаписатьУзел(ref сс);
                        }

                    }

                    var син = тез.НайтиСтроку("СИНСЕТ", Истина);

                    var ус = тез.ПрочитатьУзел(тез.СвойствоСтроки(Имя, син));
                    var су = тез.ПрочитатьУзел(ус._Атрибут);

                    foreach (string св1 in эл["words"] as Массив)
                    {
                        var ну = new _Узел();
                        ну._Имя = тез.НайтиСтроку(св1, Истина);
                        var нн = тез.ЗаписатьУзел(ref ну);

                        if (ус._Атрибут == 0)
                        {
                            ус._Атрибут = нн;
                            тез.ЗаписатьУзел(ref ус);
                        }
                        else
                        {
                            while (су._Соседний != 0)
                                су = тез.ПрочитатьУзел(су._Соседний);

                            су._Соседний = нн;
                            тез.ЗаписатьУзел(ref су);
                        }

                        су = ну;

                    }
                }
            }

        }

        public void parse_slovar()
        {

            var Словарь = Новый.ТекстовыйДокумент();
            Словарь.Прочитать(ОбъединитьПути(ТекущийКаталог(),"dict.opcorpora.txt"));
            Сообщить("Прочитал словарь");

            var сл = new treedb(ОбъединитьПути(ТекущийКаталог(), "Словарь1"));

            var Номер = Неопределено;
            var нФорма = Неопределено;
            var нЛемма = Неопределено;
            Сообщить(Словарь.КоличествоСтрок());
            var лем = Новый.Соответствие();
            for (int нн = 1; нн <= Словарь.КоличествоСтрок(); нн++)
            {
                if (нн % 1000 == 0)
                {
                    Сообщить(нн);
                }
                var стр = Словарь.ПолучитьСтроку(нн);
                if (стр == "")
                {
                    Номер = Неопределено;
                    нФорма = Неопределено;
                }
                else if (Номер == Неопределено)
                {
                    Номер = стр;
                }
                else
                {
                    var мс = Стр.Разделить(стр, Символы.Таб);

                    var ну = new _Узел();

                    var сФорма = сл.НайтиСтроку(СокрЛП(мс[0]), Истина);

                    if (нФорма == Неопределено)
                    {
                        нЛемма = лем.Получить(мс[1]);
                        if (нЛемма == Неопределено)
                        {
                            нЛемма = сл.НайтиСтроку(Стр.Заменить(СокрЛП(мс[1]), ",", " "), Истина);
                            лем.Вставить(мс[1], нЛемма);
                        }
                        
                        нФорма = сФорма;

                        ну._Имя = (int)нФорма;
                        ну._Значение = (int)нЛемма;
                        ну._Атрибут = (int)нЛемма;
                        
                        сл.ЗаписатьУзел(ref ну);
                    }
                    else
                    {
                        var сЛемма = лем.Получить(мс[1]);
                        if (сЛемма == Неопределено)
                        {
                            сЛемма = сл.НайтиСтроку(Стр.Заменить(СокрЛП(мс[1]), ",", " "), Истина);
                            лем.Вставить(мс[1], сЛемма);
                        }

                        ну._Имя = (int)нФорма;
                        ну._Значение = (int)нЛемма;
                        ну._Атрибут = (int)сЛемма;
                    }

                    var нну = сл.ЗаписатьУзел(ref ну);
                    
                    var у = сл.ПрочитатьУзел((int)сФорма);
                    if (у._Дочерний == 0)
                        у._Дочерний = нну;
                    else
                    {
                        у = сл.ПрочитатьУзел(у._Дочерний);
                        while (у._Соседний != 0)
                            у = сл.ПрочитатьУзел(у._Соседний);
                        у._Соседний = нну;
                    }
                    сл.ЗаписатьУзел(ref у);

                }
            }
        
        }


        public void test()
        {

            var сл = new treedb(ОбъединитьПути(ТекущийКаталог(), "test"));

            //Сообщить(сл.НайтиСтроку("мама", Истина));
            //Сообщить(сл.ПрочитатьСтроку(сл.НайтиСтроку("мама")));


            //Сообщить(сл.НайтиСтроку("мама мыла", Истина));
            //Сообщить(сл.ПрочитатьСтроку(сл.НайтиСтроку("мыла")));

            Сообщить(сл.НайтиСтроку("мама мыла раму", Истина));
            Сообщить(сл.НайтиСтроку("мама мыла раму", Истина));

            Сообщить(сл.ПрочитатьСтроку(7));

            //Сообщить(сл.НайтиСтроку("мама мыла", Истина));

            //Сообщить(сл.ПрочитатьСтроку(сл.НайтиСтроку("мыла раму")));

            //Сообщить(сл.ПрочитатьСтроку(сл.НайтиСтроку("мама мыла?", Истина)));
            //Сообщить(сл.ПрочитатьСтроку(сл.НайтиСтроку("мама, мыла раму?", Истина)));

            //var у = сл.ПрочитатьУзел(сл.НайтиСтроку("мама, мыла раму?", Истина));
            //Сообщить(у._Код);

            //у = сл.ПрочитатьУзел(сл.СвойстваСтроки(сл.НайтиСтроку("мама, мыла", Истина), Истина));
            //Сообщить(у._Код);
        
        }
    }
}
