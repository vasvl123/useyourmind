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
        string ИстДанных;

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


        public override Узел ПолучитьУзел(object Код, Узел Старший = null)
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

            var мУзел = Данные.ПолучитьМассив((int)Число(Код));

            мУзел[3] = мУзел[3].ToString();
            if ((string)мУзел[3] == "0") мУзел[3] = null;
            мУзел[4] = мУзел[4].ToString();
            if ((string)мУзел[4] == "0") мУзел[4] = null;
            мУзел[5] = мУзел[5].ToString();
            if ((string)мУзел[5] == "0") мУзел[5] = null;

            Узел = Узел.Новый("Код, Имя, Значение, Атрибут, Дочерний, _Соседний",
                              Код.ToString(),
                              Данные.ПолучитьСтроку((int)мУзел[1]),
                              Данные.ПолучитьСтроку((int)мУзел[2]),
                              мУзел[3],
                              мУзел[4],
                              мУзел[5]
                             );

            if (!(Узел == Неопределено))
            {

                if (!(Старший == null))
                {
                    Узел.Вставить("Старший", Старший);
                    var Родитель = Старший;
                    var СтаршийСоседний = Старший.Получить("_Соседний") as string;
                    if (СтаршийСоседний == Узел.Код)
                    {
                        Родитель = Старший.Родитель;
                    }
                    Узел.Вставить("Родитель", Родитель);
                    if (УзелСвойство(Родитель, "Атрибут") as string == Узел.Код || (Старший.Свойство("ЭтоАтрибут") == Истина && СтаршийСоседний == Узел.Код))
                    {
                        Узел.Вставить("ЭтоАтрибут", Истина);
                    }
                }

                Узлы.Вставить(Код, Узел);

                var УзелДочерний = Узел.Получить("Дочерний");
                if (!(УзелДочерний == Неопределено))
                {
                    Узел.Дочерний = ПолучитьУзел(УзелДочерний, Узел);
                }
                var УзелСоседний = Узел.Получить("_Соседний");
                if (!(УзелСоседний == Неопределено) && !(Узел.Имя == "Свойства."))
                {
                    Узел.Соседний = ПолучитьУзел(УзелСоседний, Узел);
                    Узел.Удалить("_Соседний");
                }
                var УзелАтрибут = Узел.Получить("Атрибут");
                if (!(УзелАтрибут == Неопределено))
                {
                    Узел.Атрибут = ПолучитьУзел(УзелАтрибут, Узел);
                }

            }

            return Узел;
        } // ПолучитьУзел()


        public override Узел НовыйУзел(Узел Узел, bool Служебный = false)
        {
            string НовыйКод;

            if (Служебный)
            {
                сКоличество = сКоличество + 1;
                НовыйКод = "s" + сКоличество.ToString();
            }
            else
            {
                Количество = Количество + 1;
                НовыйКод = Количество.ToString();
            }

            var УзелИмя = Узел.Имя;
            if (!(УзелИмя == ""))
            {
                if (Прав(УзелИмя, 1) == ".")
                {
                    Узел.Вставить("д", Структура.Новый());
                    УзелИмя = Лев(УзелИмя, Стр.Длина(УзелИмя) - 1);
                }
                var Родитель = УзелСвойство(Узел, "Родитель");
                if (!(Родитель == Неопределено))
                {
                    if (Узел.Родитель.Свойство("д"))
                    {
                        Узел.Родитель.д.Вставить(УзелИмя, Узел);
                    }
                }
            }

            if (!(Узел.Свойство("Дочерний")))
            {
                Узел.Вставить("Дочерний");
            }
            if (!(Узел.Свойство("Соседний")))
            {
                Узел.Вставить("Соседний");
            }
            if (!(Узел.Свойство("Атрибут")))
            {
                Узел.Вставить("Атрибут");
            }

            Узел.Вставить("Код", НовыйКод);
            Узлы.Вставить(Узел.Код, Узел);

            return Узел;
        } // НовыйУзел(СтруктураУзла)


        int СохранитьУзел(Узел элУзел = null) 
        {
            if (!(Служебный(элУзел)))
            {
                var а = 0;
                var д = 0;
                var с = 0;
                if (элУзел.Атрибут != Неопределено) а = СохранитьУзел(элУзел.Атрибут);
                if (элУзел.Дочерний != Неопределено) д = СохранитьУзел(элУзел.Дочерний);
                if (элУзел.Соседний != Неопределено) с = СохранитьУзел(элУзел.Соседний);
                var у = Новый.Массив();
                у.Добавить(2);
                у.Добавить(Данные.ДобавитьЗначение(МассивИзСтроки(элУзел.Имя)));
                у.Добавить(Данные.ДобавитьЗначение(МассивИзСтроки(элУзел.Значение.ToString())));
                у.Добавить(а);
                у.Добавить(д);
                у.Добавить(с);
                return Данные.ДобавитьЗначение(у);
            }
            return 0;
        }

        public override string СохранитьДанные()
        {
            Данные.ОткрытьПотокДанных(Истина);
            СохранитьУзел(Корень);
            return "";
        } // СохранитьДанные()

        public treedata(Ishowdata обПроцесс, string знИстДанных, string знИмяДанных) : base(обПроцесс)
        {
            ИстДанных = знИстДанных;
            ИмяДанных = знИмяДанных;
            Данные = new treedb(ОбъединитьПути(ИстДанных, ИмяДанных + ".tdb"));

            Данные.ОткрытьПотокДанных();
            var п = Данные.Размер - 16;
            if (п > 0) 
                Корень = ПолучитьУзел(п.ToString());
            else
            {
                Данные.ОткрытьПотокДанных(Истина);
                var м = Новый.Массив();
                м.Добавить(0);
                Данные.ДобавитьЗначение(м);
            }

            Корень.Вставить("Родитель", Неопределено);
            Корень.Вставить("Старший", Неопределено);
            Корень.Вставить("ИмяДанных", ИмяДанных);

            Узлы.Вставить("1", Корень);

        }

    }
}