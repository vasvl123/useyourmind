﻿// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/

using System;
using onesharp.Binary;

namespace onesharp
{
    public struct _Узел
    {
        public int _Код;
        public int _Имя;
        public int _Значение;
        public int _Атрибут;
        public int _Дочерний;
        public int _Соседний;
    }

    public class treedb : Onesharp
    {

        string ИмяФайлаДанных;
        public ФайловыйПоток ПотокДанных;

        public long Размер => ПотокДанных.Размер();

        public Массив МассивИзСтроки(string стр)
        {
            var м = Массив.Новый();
            м.Добавить(1); // слово
            var дстр = Стр.Длина(стр);
            for (int н = 1; н <= дстр; н++)
            {
                м.Добавить(КодСимвола(Сред(стр, н, 1)));
            }
            return м;
        } // МассивИзСтроки()


        // открыть контейнер для чтения или записи
        public bool ОткрытьПотокДанных(bool ДляЗаписи = false, object Позиция = null)
        {

            try
            {

                if (ДляЗаписи)
                {

                    if (!(ПотокДанных == Неопределено))
                    {
                        if (!(ПотокДанных.ДоступнаЗапись))
                        {
                            ПотокДанных.Закрыть();
                            ПотокДанных = null;
                        }
                    }

                    if (ПотокДанных == Неопределено)
                    {
                        ПотокДанных = МенеджерФайловыхПотоков.ОткрытьДляЗаписи(ИмяФайлаДанных);
                    }

                    if (Позиция == Неопределено)
                    {
                        ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                    }
                    else
                    {
                        ПотокДанных.Перейти((int)Позиция, ПозицияВПотоке.Начало);
                    }

                    //ВремяИзменения = ТекущаяДата();

                }
                else
                {

                    if (!(ПотокДанных == Неопределено))
                    {
                        if (!(ПотокДанных.ДоступноЧтение))
                        {
                            ПотокДанных.Закрыть();
                            ПотокДанных = null;
                        }
                    }

                    if (ПотокДанных == Неопределено)
                    {
                        ПотокДанных = МенеджерФайловыхПотоков.ОткрытьДляЧтения(ИмяФайлаДанных);
                    }

                    if (!(Позиция == Неопределено))
                    {
                        ПотокДанных.Перейти((int)Позиция, ПозицияВПотоке.Начало);
                    }

                }

                return Истина;

            }
            catch (Exception e)
            {

                Сообщить(ОписаниеОшибки(e));
                return Ложь;

            }

        }

        public string _ПолучитьСтроку(int нз, int к = 1)
        {
            if (нз == 0) return "";

            var м2 = Новый.Массив();
            var мСтр = ПолучитьМассив(нз);
            if ((int)мСтр[0] == к) // слово
                м2.Добавить(мСтр);
            else // предложение
            {
                var н1 = мСтр.Количество();
                for (var н = 1; н < н1; н++)
                    м2.Добавить(ПолучитьМассив((int)мСтр[н]));
            }

            var зСтр = "";
            var пр = "";
            foreach (Массив м1 in м2)
            {
                зСтр = зСтр + пр;
                var н1 = м1.Количество();
                for (var н = 1; н < н1; н++)
                    зСтр += Символ((int)м1[н]);
                пр = " ";
            }

            return зСтр;
        } // ПолучитьСтроку()


        public int ЗаписатьУзел(ref _Узел Узел)
        {
            int Код = Узел._Код;

            if (Код == 0) Код = (int)ПотокДанных.Размер();
                        
            var буф = БуферДвоичныхДанных.Новый(20);

            буф.ЗаписатьЦелое32(0, Узел._Дочерний);
            буф.ЗаписатьЦелое32(4, Узел._Соседний);
            буф.ЗаписатьЦелое32(8, Узел._Атрибут);
            буф.ЗаписатьЦелое32(12, Узел._Имя);
            буф.ЗаписатьЦелое32(16, Узел._Значение);

            ОткрытьПотокДанных(Истина);
            ПотокДанных.Перейти(Код, ПозицияВПотоке.Начало);
            ПотокДанных.Записать(буф, 0, 20);
            ПотокДанных.СброситьБуферы();

            Узел._Код = Код;
            return Код;
        }


        public _Узел ПрочитатьУзел(int н = 1)
        {
            var нУзел = new _Узел();
            нУзел._Код = н;

            ОткрытьПотокДанных();
            ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
            var буф = БуферДвоичныхДанных.Новый(20);

            ПотокДанных.Прочитать(буф, 0, 20);

            нУзел._Дочерний = буф.ПрочитатьЦелое32(0);
            нУзел._Соседний = буф.ПрочитатьЦелое32(4);
            нУзел._Атрибут = буф.ПрочитатьЦелое32(8);
            нУзел._Имя = буф.ПрочитатьЦелое32(12);
            нУзел._Значение = буф.ПрочитатьЦелое32(16);

            return нУзел;
        }


        public int ДобавитьЗначение(Массив гр, int н = 0)
        {

            // пройти по дереву
            ОткрытьПотокДанных();
            var буф = БуферДвоичныхДанных.Новый(16);

            // н = 0;
            var к = 1;
            var рн = 0;

            var сгр = гр.Количество();

            if (!(ПотокДанных.Размер() == 0))
            {

                while (Истина)
                {
                    var ф = (int)гр.Получить(к - 1);
                    int нн = 0;
                    while (Истина)
                    {
                        ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                        ПотокДанных.Прочитать(буф, 0, 16);
                        var ф1 = буф.ПрочитатьЦелое32(0);
                        нн = буф.ПрочитатьЦелое32(4); // позиция следующего
                        if (ф1 == ф) // || ф == 0)
                        { // найден элемент
                            рн = н;
                            к = к + 1;
                            if (!(к > сгр))
                            {
                                нн = буф.ПрочитатьЦелое32(8); // позиция вложенного
                                if (нн == 0)
                                { // создать ссылку на вложенный
                                    ОткрытьПотокДанных(Истина);
                                    var кн = (int)ПотокДанных.Размер();
                                    буф.ЗаписатьЦелое32(8, кн); // вложенный в конец
                                    ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                                    ПотокДанных.Записать(буф, 0, 14);
                                    //ПотокДанных.СброситьБуферы();
                                }
                            }
                            break;
                        }
                        нн = буф.ПрочитатьЦелое32(4); // позиция следующего
                        if (нн == 0)
                        { // это последний
                            ОткрытьПотокДанных(Истина);
                            var кн = (int)ПотокДанных.Размер();
                            буф.ЗаписатьЦелое32(4, кн); // соседний в конец
                            ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                            ПотокДанных.Записать(буф, 0, 16);
                            //ПотокДанных.СброситьБуферы();
                            break;
                        }
                        н = нн;
                    }
                    if (нн == 0 || к > сгр)
                    {
                        break;
                    }
                    н = нн;
                }

            }

            if (!(к > сгр))
            {

                // создать новые элементы
                ОткрытьПотокДанных(Истина);

                for (; к <= сгр; к++) {
                    var ф = (int)гр.Получить(к - 1);
                    int кн = 0;
                    ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                    н = (int)ПотокДанных.ТекущаяПозиция();
                    if (!(к == сгр))
                    {
                        кн = н + 16;
                    }
                    else
                    {
                        кн = 0;
                    }
                    буф.ЗаписатьЦелое32(0, ф); // код символа
                    буф.ЗаписатьЦелое32(4, 0); // нет соседнего
                    буф.ЗаписатьЦелое32(8, кн); // вложенный в конец
                    буф.ЗаписатьЦелое32(12, рн); // родитель
                    ПотокДанных.Записать(буф, 0, 16);
                    рн = н;
                }

                ПотокДанных.СброситьБуферы();

            }

            return н;

        } // ДобавитьЗначение()


        public Структура ПолучитьЭлемент(int н)
        {
            var буф = БуферДвоичныхДанных.Новый(16);
            var эл = Структура.Новый();
            ОткрытьПотокДанных();
            ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
            ПотокДанных.Прочитать(буф, 0, 16);
            эл.Вставить("Значение", буф.ПрочитатьЦелое32(0));
            эл.Вставить("Соседний", буф.ПрочитатьЦелое32(4));
            эл.Вставить("Дочерний", буф.ПрочитатьЦелое32(8));
            эл.Вставить("Родитель", буф.ПрочитатьЦелое32(12));
            return эл;
        } // ПолучитьЭлемент()


        public Массив ПолучитьЗначения(int н)
        {
            var буф = БуферДвоичныхДанных.Новый(16);
            var мр = Массив.Новый();
            while (Истина)
            {
                if (н == 0)
                {
                    break;
                }
                ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 16);
                var ф = буф.ПрочитатьЦелое32(0);
                var сн = буф.ПрочитатьЦелое32(4);
                var мф = Массив.Новый();
                мф.Добавить(ф);
                мф.Добавить(н);
                мр.Добавить(мф);
                н = сн;
            }
            return мр;
        }


        public Массив ПолучитьВложенныеЗначения(int н)
        {
            var буф = БуферДвоичныхДанных.Новый(16);
            ОткрытьПотокДанных();
            ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
            ПотокДанных.Прочитать(буф, 0, 16);
            var вн = буф.ПрочитатьЦелое32(8); // позиция вложенного
            return ПолучитьЗначения(вн);
        } // ПолучитьВложенныеЗначения()

        
        public Массив ПолучитьЭлементы(int н, Массив м = null, int нн = 0)
        {
            var у = ПрочитатьУзел(н);

            if (м == null)
            {
                м = Массив.Новый();
                if (у._Код != 21) у = ПрочитатьУзел(у._Значение);
                нн = н;
            }
            else 
            {
                if (у._Атрибут != 0)
                {
                    м.Добавить(у._Атрибут);
                    return м;
                }
            }

            if (у._Дочерний != 0) м = ПолучитьЭлементы(у._Дочерний, м, нн);
            if (у._Соседний != 0) м = ПолучитьЭлементы(у._Соседний, м, нн);

            return м;
        }


        public _Узел НайтиСтроку(string знСтрока, bool Создать = false)
        {
            var Узел = new _Узел();
            if (!ЗначениеЗаполнено(знСтрока)) return Узел;

            var атр = Новый.Массив();

            var сСимв = @" .,!?:;()«»""'–…"; // - дефис потом

            var дСтр = Стр.Длина(знСтрока);
            var дКод = 21;

            var ус = true;

            ОткрытьПотокДанных();
            var буф = БуферДвоичныхДанных.Новый(20);

            var нс = 1;
            while (нс <= дСтр)
            {
                var сс = Сред(знСтрока, нс, 1);
                var с = КодСимвола(сс);
                var пус = ус;
                ус = (Стр.Найти(сСимв, сс) == 0);

                ПотокДанных.Перейти(дКод, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 20);
                var и = буф.ПрочитатьЦелое32(12);

                int нн = дКод;

                while (и != с || буф.ПрочитатьЦелое32(16) != дКод)
                {
                    var пн = нн;

                    if (и > с)
                        нн = буф.ПрочитатьЦелое32(0);
                    else
                        нн = буф.ПрочитатьЦелое32(4);

                    if (нн == 0)
                    {
                        if (!Создать) return Узел;

                        var буф1 = БуферДвоичныхДанных.Новый(20);
                        буф1.ЗаписатьЦелое32(12, с);
                        буф1.ЗаписатьЦелое32(16, дКод);

                        ОткрытьПотокДанных(Истина);
                        нн = (int)ПотокДанных.Размер();
                        ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                        ПотокДанных.Записать(буф1, 0, 20);

                        if (и > с)
                            буф.ЗаписатьЦелое32(0, нн);
                        else
                            буф.ЗаписатьЦелое32(4, нн);
                        ПотокДанных.Перейти(пн, ПозицияВПотоке.Начало);
                        ПотокДанных.Записать(буф, 0, 20);
                        ПотокДанных.СброситьБуферы();

                        ОткрытьПотокДанных();

                        буф = буф1;
                        break;
                    }

                    ПотокДанных.Перейти(нн, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 20);
                    и = буф.ПрочитатьЦелое32(12);
                }

                дКод = нн;

                if (!ус && пус || нс == дСтр) 
                {
                    var ан = буф.ПрочитатьЦелое32(8);

                    if (ан == 0)
                    {
                        if (!Создать) return Узел;

                        var буф1 = БуферДвоичныхДанных.Новый(20);
                        буф1.ЗаписатьЦелое32(8, 0);
                        буф1.ЗаписатьЦелое32(16, дКод);

                        ОткрытьПотокДанных(Истина);
                        ан = (int)ПотокДанных.Размер();
                        ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                        ПотокДанных.Записать(буф1, 0, 20);

                        буф.ЗаписатьЦелое32(8, ан);
                        ПотокДанных.Перейти(дКод, ПозицияВПотоке.Начало);
                        ПотокДанных.Записать(буф, 0, 20);
                        ПотокДанных.СброситьБуферы();

                        ОткрытьПотокДанных();
                    }

                    атр.Добавить(ан);

                    дКод = 21;
                }

                нс++;
            }

            var пКод = 0;

            нс = атр.Количество();
            while (нс > 0)
            {
                var ан = (int)атр[нс - 1];

                ПотокДанных.Перейти(ан, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 20);

                дКод = буф.ПрочитатьЦелое32(16);
                var а = буф.ПрочитатьЦелое32(8);

                while (а != пКод)
                {
                    var пн = ан;
                    
                    if (а > пКод)
                        ан = буф.ПрочитатьЦелое32(0);
                    else
                        ан = буф.ПрочитатьЦелое32(4);

                    if (ан == 0)
                    {
                        if (!Создать) return Узел;

                        var буф1 = БуферДвоичныхДанных.Новый(20);
                        буф1.ЗаписатьЦелое32(8, пКод);
                        буф1.ЗаписатьЦелое32(16, дКод);

                        ОткрытьПотокДанных(Истина);
                        ан = (int)ПотокДанных.Размер();
                        ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                        ПотокДанных.Записать(буф1, 0, 20);

                        if (а > пКод)
                            буф.ЗаписатьЦелое32(0, ан);
                        else
                            буф.ЗаписатьЦелое32(4, ан);
                        
                        ПотокДанных.Перейти(пн, ПозицияВПотоке.Начало);
                        ПотокДанных.Записать(буф, 0, 20);
                        ПотокДанных.СброситьБуферы();

                        ОткрытьПотокДанных();

                        буф = буф1;
                        break;
                    }

                    ПотокДанных.Перейти(ан, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 20);
                    а = буф.ПрочитатьЦелое32(8);
                    
                }

                пКод = ан;
                нс--;
            }

            Узел._Код = пКод;
            Узел._Дочерний = буф.ПрочитатьЦелое32(0);
            Узел._Соседний = буф.ПрочитатьЦелое32(4);
            Узел._Атрибут = буф.ПрочитатьЦелое32(8);
            Узел._Имя = буф.ПрочитатьЦелое32(12);
            Узел._Значение = буф.ПрочитатьЦелое32(16);
            
            return Узел;
        }


        public string ПрочитатьСтроку(int нз)
        {
            if (нз == 0) return "";

            var буф = БуферДвоичныхДанных.Новый(20);
            var буф1 = БуферДвоичныхДанных.Новый(20);

            var зСтр = "";

            ОткрытьПотокДанных();
            do
            {
                ПотокДанных.Перейти(нз, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 20);

                var сл = "";
                нз = буф.ПрочитатьЦелое32(16);
                while (нз != 21)
                {
                    ПотокДанных.Перейти(нз, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф1, 0, 20);
                    сл = Символ(буф1.ПрочитатьЦелое32(12)) + сл;
                    нз = буф1.ПрочитатьЦелое32(16);
                }
                зСтр = зСтр + сл;

                нз = буф.ПрочитатьЦелое32(8);
            }
            while (нз != 0);

            return зСтр;
        } // ПрочитатьСтроку()


        public Массив ПолучитьМассив(int н)
        {

            var гр = Массив.Новый();
            var буф = БуферДвоичныхДанных.Новый(16);

            ОткрытьПотокДанных();

            while (Истина)
            {
                ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 16);
                var ф = буф.ПрочитатьЦелое32(0);
                н = буф.ПрочитатьЦелое32(12); // позиция родителя
                гр.Вставить(0, ф);
                if (н == 0)
                { // это первый
                    break;
                }
            }

            return гр;

        } // ПолучитьМассив()



        public Массив НайтиПохожие(Массив нгр, int о = 0, int н = 0, Массив рез = null, int к = 1)
        {

            var буф = БуферДвоичныхДанных.Новый(16);

            ОткрытьПотокДанных();

            if (!(н == 0))
            { // искать внутри
                ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 16);
                н = буф.ПрочитатьЦелое32(8); // позиция вложенного
                if (н == 0)
                {
                    return null;
                }
            }

            // Если НЕ ТипЗнч(нгр) = Тип("Массив") Тогда
            //  зн = нгр;
            //  нгр = Новый Массив;
            //  нгр.Добавить(зн);
            // КонецЕсли;

            var сгр = нгр.Количество();

            // пройти по дереву

            //var к = 1;

            if (рез == null) рез = Новый.Массив();

            while (Истина)
            {
                var ф = (int)нгр.Получить(к - 1);
                var н1 = 0;
                var н2 = 0;
                while (Истина)
                {
                    if (н1 == 0) н1 = н; else н2 = н;
                    ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 16);
                    var ф1 = буф.ПрочитатьЦелое32(0);
                    if (ф1 == ф)
                    { // найден элемент
                        к = к + 1;
                        if (!(к > сгр))
                        {
                            н = буф.ПрочитатьЦелое32(8); // позиция вложенного
                        }
                        break;
                    }
                    н = буф.ПрочитатьЦелое32(4); // позиция следующего

                    if (н == 0 || к > сгр) break;
                }
                if (к > сгр) 
                {
                    рез.Добавить(new int[]{о, н});
                    break;
                }
                if (н == 0)
                { // это последний
                    if (к < сгр && о > 0)
                    {
                        if (н1 != 0) НайтиПохожие(нгр, о - 1, н1, рез, к + 1);
                        if (н2 != 0) НайтиПохожие(нгр, о - 1, н2, рез, к + 1);
                    }
                    break;
                }
            }

            return рез;

        } // НайтиЗначение()



        public int НайтиЗначение(Массив нгр, int н = 0)
        {

            var буф = БуферДвоичныхДанных.Новый(16);

            ОткрытьПотокДанных();

            if (!(н == 0))
            { // искать внутри
                ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 16);
                н = буф.ПрочитатьЦелое32(8); // позиция вложенного
                if (н == 0)
                {
                    return н;
                }
            }

            // Если НЕ ТипЗнч(нгр) = Тип("Массив") Тогда
            //  зн = нгр;
            //  нгр = Новый Массив;
            //  нгр.Добавить(зн);
            // КонецЕсли;

            var сгр = нгр.Количество();

            // пройти по дереву

            var к = 1;

            while (Истина)
            {
                var ф = (int)нгр.Получить(к - 1);
                while (Истина)
                {
                    ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 16);
                    var ф1 = буф.ПрочитатьЦелое32(0);
                    if (ф1 == ф || ф == 42)
                    { // найден элемент
                        if (ф == 42)
                        { // *
                            if (ф1 == (int)нгр.Получить(к + 1))
                            {
                                к = к + 1;
                            }
                        }
                        else
                        {
                            к = к + 1;
                        }
                        if (!(к > сгр))
                        {
                            н = буф.ПрочитатьЦелое32(8); // позиция вложенного
                        }
                        break;
                    }
                    н = буф.ПрочитатьЦелое32(4); // позиция следующего
                    if (н == 0 || к > сгр)
                    { // это последний
                        break;
                    }
                }
                if (н == 0 || к > сгр)
                {
                    break;
                }
            }

            return н;

        } // НайтиЗначение()


        public void УдалитьЗначение(int н)
        {

            var буф = БуферДвоичныхДанных.Новый(16);

            ОткрытьПотокДанных();
            ПотокДанных.Перейти(н, ПозицияВПотоке.Начало);
            ПотокДанных.Прочитать(буф, 0, 16);
            var сн = буф.ПрочитатьЦелое32(4); // позиция соседнего
            var рн = буф.ПрочитатьЦелое32(12); // позиция родителя

            ПотокДанных.Перейти(рн, ПозицияВПотоке.Начало);
            ПотокДанных.Прочитать(буф, 0, 16);
            var нн = буф.ПрочитатьЦелое32(8); // позиция дочернего

            if (нн == н)
            { // если это первый дочерний
                ОткрытьПотокДанных(Истина);
                буф.ЗаписатьЦелое32(8, сн);
                ПотокДанных.Перейти(рн, ПозицияВПотоке.Начало);
                ПотокДанных.Записать(буф, 0, 16);
                ПотокДанных.СброситьБуферы();

            }
            else
            { // перебрать остальные

                while (Истина)
                {
                    ПотокДанных.Перейти(нн, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 16);
                    var пс = буф.ПрочитатьЦелое32(4); // позиция следующего
                    if (пс == н)
                    { // найден элемент
                        ОткрытьПотокДанных(Истина);
                        буф.ЗаписатьЦелое32(4, сн);
                        ПотокДанных.Перейти(нн, ПозицияВПотоке.Начало);
                        ПотокДанных.Записать(буф, 0, 16);
                        ПотокДанных.СброситьБуферы();
                        break;
                    }
                    if (пс == 0)
                    {
                        break;
                    }
                    нн = пс;
                }

            }

        } // УдалитьЗначение()


        public void Закрыть()
        {
            if (!(ПотокДанных == Неопределено))
            {
                ПотокДанных.Закрыть();
            }
        } // Закрыть()


        public treedb(string ЗначИмяФайлаДанных) : base ("treedb")
        {
            ИмяФайлаДанных = ЗначИмяФайлаДанных;
            var _Файл = Файл.Новый(ИмяФайлаДанных);
            if (!(_Файл.Существует()))
            {
                var дФайл = ПолучитьДвоичныеДанныеИзСтроки("0");
                дФайл.Записать(ИмяФайлаДанных);
                ОткрытьПотокДанных(Истина);
                var Корень = new _Узел();
                ЗаписатьУзел(ref Корень);
                var Словарь = new _Узел();
                ЗаписатьУзел(ref Словарь);
            }

        }

    }
}
