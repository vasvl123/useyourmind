﻿// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/
// Идея интерпретатора https://github.com/tsukanov-as/kojura

using System;


namespace onesharp
{
    public class treedata : pagedata
    {
        treedb Данные;


        Массив МассивИзСтроки(string стр)
        {
            var м = Массив.Новый();
            м.Добавить(1);
            var дстр = Стр.Длина(стр);
            for (int н = 1; н <= дстр; н++)
            {
                м.Добавить(КодСимвола(Сред(стр, н, 1)));
            }
            return м;
        } // МассивИзСтроки()


        override public Узел ПолучитьУзел(object Код, Узел Старший = null)
        {
            if (Код is null) return null;

            var Узел = Узлы.Получить(Код) as Узел;
            if (!(Узел == Неопределено))
            {
                return Узел;
            }

            if (Код is Узел)
            {
                return (Узел)Код;
            }

            if (Лев(Код as string, 1) == "n") return null;

            Узел = Данные.ПрочитатьУзел((int)Число(Код));

            if (!(Старший == null))
            {
                Узел.Старший = Старший;
                var Родитель = Старший;
                var СтаршийСоседний = Старший._Соседний;
                if (СтаршийСоседний == Узел.Код)
                {
                    Родитель = Старший.Родитель;
                }
                Узел.Родитель = Родитель;
            }

            Узлы.Вставить(Код, Узел);

            if (Узел._Атрибут is int) Узел.Атрибут = ПолучитьУзел(Узел._Атрибут, Узел);
            if (Узел._Дочерний is int) Узел.Дочерний = ПолучитьУзел(Узел._Дочерний, Узел);

            if ((Узел._Соседний is int) && !(Узел.Имя == "Свойства."))
            {
                Узел.Соседний = ПолучитьУзел(Узел._Соседний, Узел);
            }

            Узел.Изменения = Ложь;
            return Узел;
        } // ПолучитьУзел()



        public int СохранитьУзел(Узел элУзел)
        {
            if (Служебный(элУзел)) return 0;

            if (элУзел.Изменения)
            {
                if (элУзел.Атрибут != Неопределено) СохранитьУзел(элУзел.Атрибут);
                if (элУзел.Дочерний != Неопределено) СохранитьУзел(элУзел.Дочерний);
                if (элУзел.Соседний != Неопределено) СохранитьУзел(элУзел.Соседний);

                Узлы.Удалить(элУзел.Код);
                Данные.ЗаписатьУзел(элУзел);

                элУзел.Изменения = Ложь;
                Узлы.Вставить(элУзел.Код, элУзел);
            }

            return (int)Число(элУзел.Код);
        }

        public void СохранитьДанные()
        {
            if (Данные is null)
            {
                Данные = new treedb(ОбъединитьПути(ОбъединитьПути(ТекущийКаталог(), "data"), ИстДанных, ИмяДанных + ".tdb"));
                Данные.ОткрытьПотокДанных(Истина);
                var м = Новый.Массив();
                м.Добавить(0);
                Данные.ДобавитьЗначение(м);
            }

        } // СохранитьДанные()


        public Узел _ПолучитьУзел(ТекстовыйДокумент _Данные, object Код, Узел Старший = null)
        {
            if (Код is null) return null;

            var Узел = Узлы.Получить(Код) as Узел;
            if (!(Узел == Неопределено))
            {
                return Узел;
            }
            if (Код is Узел)
            {
                return (Узел)Код;
            }
            // Если Лев(Код, 1) = "s" Тогда
            //  Возврат Неопределено
            // КонецЕсли;
            //Стр = Данные.ПолучитьСтроку(Число(Код));
            string стр;

            try
            {
                стр = _Данные.ПолучитьСтроку((int)Число(Код));
            }
            catch
            {
                return null;
                //ВызватьИсключение "Неверный код узла: " + Код;
            }
            var мСтр = Стр.Разделить(стр, Символы.Таб);
            string Ключ = null;
            foreach (string _знСтр in мСтр)
            {
                var знСтр = _знСтр;
                if (Ключ == null)
                {
                    Ключ = знСтр;
                }
                else
                {
                    if (Узел == Неопределено)
                    {
                        Узел = Узел.Новый("Код, Имя", Код, "");
                    }
                    if (Ключ == "И")
                    {
                        Узел.Имя = знСтр;
                    }
                    else if (Ключ == "З")
                    {
                        знСтр = Стр.Заменить(знСтр, "#x9", Символы.Таб);
                        знСтр = Стр.Заменить(знСтр, "#xA", Символы.ПС);
                        знСтр = Стр.Заменить(знСтр, "#xD", Символы.ВК);
                        Узел.Значение = знСтр;
                    }
                    else if (Ключ == "Д")
                    {
                        Узел.Дочерний = _ПолучитьУзел(_Данные, знСтр, Узел);
                    }
                    else if (Ключ == "С")
                    {
                        Узел._Соседний = _знСтр;
                    }
                    else if (Ключ == "А")
                    {
                        Узел.Атрибут = _ПолучитьУзел(_Данные, знСтр, Узел);
                    }
                    Ключ = null;
                }
            }

            if (!(Узел == Неопределено))
            {

                if (!(Старший == null))
                {
                    Узел.Старший = Старший;
                    var Родитель = Старший;
                    var СтаршийСоседний = Старший._Соседний;
                    if (СтаршийСоседний == Узел.Код)
                    {
                        Родитель = Старший.Родитель;
                    }
                    Узел.Родитель = Родитель;
                }

                Узлы.Вставить(Код, Узел);

                if (!(Узел._Соседний == null)) // && !(Узел.Имя == "Свойства."))
                {
                    Узел.Соседний = _ПолучитьУзел(_Данные, Узел._Соседний, Узел);
                    //Узел._Соседний = null;
                }

            }

            return Узел;
        } // ПолучитьУзел()


        void ПрочитатьВетку(Узел Узел)
        {
            if (!(Узел == Неопределено))
            {
                ПрочитатьВетку(ПолучитьУзел(Узел.Атрибут, Узел));
                ПрочитатьВетку(ПолучитьУзел(Узел.Дочерний, Узел));
                ПрочитатьВетку(ПолучитьУзел(Узел.Соседний, Узел));
            }
        }


        public treedata(Ishowdata обПроцесс, string знИстДанных, string знИмяДанных) : base(обПроцесс, знИстДанных,  знИмяДанных)
        {

            Данные = new treedb(ОбъединитьПути(ОбъединитьПути(ТекущийКаталог(), "data"), ИстДанных, ИмяДанных + ".tdb"));

            Данные.ОткрытьПотокДанных();
            if (Данные.Размер > 0)
                Корень = ПолучитьУзел(16);
            else
            {
                Данные.ОткрытьПотокДанных(Истина);
                var м = Новый.Массив();
                м.Добавить(0);
                Данные.ДобавитьЗначение(м);
                Данные.ЗаписатьУзел(Корень);
            }

            //Узлы.Вставить("1", Корень);
            Узлы.Вставить(Корень.Код, Корень);

            //ОбъектыОбновить.Добавить(Корень);

        }

        // pagedata
        public treedata(Ishowdata обПроцесс, string Текст = "", string знИстДанных = "", string знИмяДанных = "") : base(обПроцесс, знИстДанных, знИмяДанных)
        {

            var Данные = new ТекстовыйДокумент();

            if (!(Текст == ""))
            {
                Данные.УстановитьТекст(Текст);
                var Стр1 = Данные.ПолучитьСтроку(1);
                if (КодСимвола(Лев(Стр1, 1)) == 65279)
                { // BOM
                    Данные.ЗаменитьСтроку(1, Сред(Стр1, 2));
                }
            }

            Представление = "";

            if (!(Текст == ""))
            {
                Узлы = Соответствие.Новый();
                Корень = _ПолучитьУзел(Данные, "1");
                ПрочитатьВетку(Корень);
                //СохранитьДанные();
                Узлы.Вставить("1", Корень);
            }

            //ОбъектыОбновить.Добавить(Корень);

        }


    }
}
