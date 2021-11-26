﻿using System;
using onesharp;

namespace parse
{
    public class parse : useyourmind
    {

        public parse() : base("parse") { }

        public void parse_ruez()
        {
            var тез = new treedb(ОбъединитьПути(ТекущийКаталог(), "Тезаурус1"));
            var м = Новый.Массив();
            м.Добавить(0);
            тез.ДобавитьЗначение(м);
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
                    var гр = тез.МассивИзСтроки(эл["name"] as string);
                    var нн = тез.ДобавитьЗначение(гр);
                    foreach (Структура св1 in эл["rels"] as Массив)
                    {
                        var к = 0;
                        if (св1["Ключ"] as string == "АССОЦ")
                        {
                            к = 5;
                        }
                        else if (св1["Ключ"] as string  == "ЧАСТЬ")
                        {
                            к = 6;
                        }
                        else if (св1["Ключ"] as string  == "НИЖЕ")
                        {
                            к = 3;
                        }
                        else if (св1["Ключ"] as string  == "ВЫШЕ")
                        {
                            к = 2;
                        }
                        else if (св1["Ключ"] as string  == "ЦЕЛОЕ")
                        {
                            к = 4;
                        }
                        else
                        {
                        }
                        гр = тез.МассивИзСтроки(св1["Значение"] as string);
                        var з = тез.ДобавитьЗначение(гр);
                        гр = Новый.Массив();
                        гр.Добавить(0);
                        гр.Добавить(к);
                        гр.Добавить(з);
                        тез.ДобавитьЗначение(гр, нн);
                    }
                    foreach (string св1 in эл["words"] as Массив)
                    {
                        гр = тез.МассивИзСтроки(св1);
                        var з = тез.ДобавитьЗначение(гр);
                        гр = Новый.Массив();
                        гр.Добавить(0);
                        гр.Добавить(1);
                        гр.Добавить(з);
                        тез.ДобавитьЗначение(гр, нн);
                    }
                }
            }
        }
    }
}
