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

            var мУзел = Данные.ПолучитьМассив((int)Число(Код));

            var м2 = Новый.Массив();
            var мСтр = Данные.ПолучитьМассив((int)мУзел[2]);
            if ((int)мСтр[0] == 1)
                м2.Добавить(мСтр);
            else
            {
                var н1 = мСтр.Количество();
                for (var н = 1; н < н1; н++)
                    м2.Добавить(Данные.ПолучитьМассив((int)мУзел[н]));
            }

            var зСтр = "";
            var пр = "";
            foreach(Массив м1 in м2)
            {
                зСтр = пр + зСтр;
                var н1 = м1.Количество();
                for (var н = 1; н < н1; н++)
                    зСтр += Символ((int)м1[н]);
                пр = " ";
            }

            Узел = Узел.Новый("Код, Имя, Значение",
                              Код.ToString(),
                              Данные.ПолучитьСтроку((int)мУзел[1]),
                              зСтр
                             );

            if ((int)мУзел[3] != 0) Узел.Вставить("Атрибут", мУзел[3].ToString());
            if ((int)мУзел[4] != 0) Узел.Вставить("Дочерний", мУзел[4].ToString());
            if ((int)мУзел[5] != 0) Узел.Вставить("_Соседний", мУзел[5].ToString());
            if ((int)мУзел[6] != 0) Узел.Вставить("_Бывший", мУзел[6].ToString());

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

            Узел.Изменения = Ложь;
            return Узел;
        } // ПолучитьУзел()



        public int СохранитьУзел(Узел элУзел)
        {
            if (Служебный(элУзел)) return 0;

            if (элУзел.Изменения)
            {
                var а = 0;
                var д = 0;
                var с = 0;
                var б = 0;
                if (элУзел.Атрибут != Неопределено) а = СохранитьУзел(элУзел.Атрибут);
                if (элУзел.Дочерний != Неопределено) д = СохранитьУзел(элУзел.Дочерний);
                if (элУзел.Соседний != Неопределено) с = СохранитьУзел(элУзел.Соседний);
                if (Лев(элУзел.Код, 1) != "n") б = (int)Число(элУзел.Код);

                var у = Новый.Массив();
                у.Добавить(3); // узел
                у.Добавить(Данные.ДобавитьЗначение(МассивИзСтроки(элУзел.Имя)));

                Массив м2;
                var мСтр = Стр.Разделить(Строка(элУзел.Значение), " ");
                if (мСтр.Length == 1)
                    м2 = МассивИзСтроки(мСтр[0]);
                else
                {
                    м2 = Новый.Массив();
                    м2.Добавить(2); // предложение
                    foreach (var эСтр in мСтр)
                        м2.Добавить(Данные.ДобавитьЗначение(МассивИзСтроки(эСтр)));
                }

                у.Добавить(Данные.ДобавитьЗначение(м2));
                у.Добавить(а);
                у.Добавить(д);
                у.Добавить(с);
                у.Добавить(б);

                элУзел.Изменения = Ложь;
                var i = Данные.ДобавитьЗначение(у);
                Узлы.Удалить(элУзел.Код);
                элУзел.Вставить("_Код", элУзел.Код);
                элУзел["Код"] = i.ToString();
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


        public treedata(Ishowdata обПроцесс, string знИстДанных, string знИмяДанных) : base(обПроцесс, знИстДанных,  знИмяДанных)
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
                //Корень = НовыйУзел(ИмяЗначение("О", "Корень"));
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
