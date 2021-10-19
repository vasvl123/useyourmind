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

            Узел.Изменения = Ложь;
            return Узел;
        } // ПолучитьУзел()



        int СохранитьУзел(Узел элУзел)
        {
            if (Служебный(элУзел)) return 0;

            if (элУзел.Изменения)
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
                у.Добавить(Данные.ДобавитьЗначение(МассивИзСтроки(Строка(элУзел.Значение))));
                у.Добавить(а);
                у.Добавить(д);
                у.Добавить(с);
                элУзел.Изменения = Ложь;
                var i = Данные.ДобавитьЗначение(у);
                элУзел["Код"] = i.ToString();
            }

            return (int)Число(элУзел.Код);
        }

        public string СохранитьДанные()
        {
            Данные.ОткрытьПотокДанных(Истина);
            СохранитьУзел(Корень);
            return "";
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
                        Узел = Узел.Новый("Код, Имя, Значение, Дочерний, Соседний, Атрибут", Код, "");
                    }
                    if (Ключ == "И")
                    {
                        Ключ = "Имя";
                    }
                    else if (Ключ == "З")
                    {
                        Ключ = "Значение";
                        знСтр = Стр.Заменить(знСтр, "#x9", Символы.Таб);
                        знСтр = Стр.Заменить(знСтр, "#xA", Символы.ПС);
                        знСтр = Стр.Заменить(знСтр, "#xD", Символы.ВК);
                    }
                    else if (Ключ == "Д")
                    {
                        Ключ = "Дочерний";
                    }
                    else if (Ключ == "С")
                    {
                        Ключ = "_Соседний";
                    }
                    else if (Ключ == "А")
                    {
                        Ключ = "Атрибут";
                    }
                    Узел.Вставить(Ключ, знСтр);
                    Ключ = null;
                }
            }

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
                    Узел.Дочерний = _ПолучитьУзел(_Данные, УзелДочерний, Узел);
                }
                var УзелСоседний = Узел.Получить("_Соседний");
                if (!(УзелСоседний == Неопределено)) // && !(Узел.Имя == "Свойства."))
                {
                    Узел.Соседний = _ПолучитьУзел(_Данные, УзелСоседний, Узел);
                    Узел.Удалить("_Соседний");
                }
                var УзелАтрибут = Узел.Получить("Атрибут");
                if (!(УзелАтрибут == Неопределено))
                {
                    Узел.Атрибут = _ПолучитьУзел(_Данные, УзелАтрибут, Узел);
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


        public treedata(Ishowdata обПроцесс, string знИстДанных, string знИмяДанных) : base(обПроцесс, знИстДанных,  знИмяДанных, "1")
        {

            Данные = new treedb(ОбъединитьПути(ОбъединитьПути(ТекущийКаталог(), "data"), ИстДанных, ИмяДанных + ".tdb"));

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
                Корень = НовыйУзел(ИмяЗначение("О", "Корень"));
            }
            
            Узлы.Вставить("1", Корень);
            Узлы.Вставить(Корень.Код, Корень);

            //ОбъектыОбновить.Добавить(Корень);

        }

        // pagedata
        public treedata(Ishowdata обПроцесс, string Текст = "", string знИстДанных = "", string знИмяДанных = "") : base(обПроцесс, знИстДанных, знИмяДанных, "1")
        {

            var Данные = new ТекстовыйДокумент();
            Узлы = Соответствие.Новый();

            if (!(Текст == ""))
            {
                Данные.УстановитьТекст(Текст);
                var Стр1 = Данные.ПолучитьСтроку(1);
                if (КодСимвола(Лев(Стр1, 1)) == 65279)
                { // BOM
                    Данные.ЗаменитьСтроку(1, Сред(Стр1, 2));
                }
            }

            this.Данные = new treedb(ОбъединитьПути(ОбъединитьПути(ТекущийКаталог(), "data"), ИстДанных, ИмяДанных + ".tdb"));
            this.Данные.ОткрытьПотокДанных(Истина);
            var м = Новый.Массив();
            м.Добавить(0);
            this.Данные.ДобавитьЗначение(м);

            Представление = "";
            Корень = _ПолучитьУзел(Данные, "1");

            ПрочитатьВетку(Корень);

            СохранитьДанные();

            Узлы = Соответствие.Новый();
            Узлы.Вставить("1", Корень);

            //ОбъектыОбновить.Добавить(Корень);

        }


    }
}
