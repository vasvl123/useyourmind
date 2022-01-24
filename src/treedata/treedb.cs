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

            if (Код == 0) Код = (int)(ПотокДанных.Размер() / 20);
                
            var буф = БуферДвоичныхДанных.Новый(20);

            буф.ЗаписатьЦелое32(0, Узел._Дочерний);
            буф.ЗаписатьЦелое32(4, Узел._Соседний);
            буф.ЗаписатьЦелое32(8, Узел._Атрибут);
            буф.ЗаписатьЦелое32(12, Узел._Имя);
            буф.ЗаписатьЦелое32(16, Узел._Значение);

            ОткрытьПотокДанных(Истина);
            ПотокДанных.Перейти(Код * 20, ПозицияВПотоке.Начало);
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
            ПотокДанных.Перейти(н * 20, ПозицияВПотоке.Начало);
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


        public Массив ПолучитьСлова(int н, string с = "", Массив м = null)
        {
            var у = ПрочитатьУзел(н);

            if (м == null)
            {
                м = Массив.Новый();
                if (у._Дочерний == 0) return м;
                у = ПрочитатьУзел(у._Дочерний);
            }

            if (у._Имя != 0)
            {
                if (у._Дочерний != 0 || у._Соседний != 0)
                {
                    if (с != "")
                    {
                        м.Добавить(Новый.Структура("Тип, Имя, Поз", "Ф", с, у._Код));
                        return м;
                    }
                }
                if (у._Атрибут != 0)
                    м = ПолучитьСлова(у._Атрибут, с + ПрочитатьСтроку(у._Имя), м);
            }
            else
            {
                м.Добавить(Новый.Структура("Тип, Имя, Поз", "П", с, у._Код));
                return м;
            }

            if (у._Дочерний != 0) м = ПолучитьСлова(у._Дочерний, с, м);
            if (у._Соседний != 0) м = ПолучитьСлова(у._Соседний, с, м);

            return м;
        }


        public Массив ПолучитьЭлементы(int н, string с = "", Массив м = null)
        {
            var у = ПрочитатьУзел(н);

            if (м == null)
            {
                м = Массив.Новый();
                if (н == 0) у = ПрочитатьУзел(у._Соседний);
            }

            if (у._Имя == у._Код) return м; // свойства
            if (у._Имя != 0)
            {
                if (у._Дочерний != 0 || у._Соседний != 0)
                {
                    if (с != "")
                    {
                        м.Добавить(Новый.Структура("Тип, Имя, Поз", "Б", с, у._Код));
                        return м;
                    }
                }
                if (у._Атрибут != 0)
                    м = ПолучитьЭлементы(у._Атрибут, с + Символ(у._Имя), м);
            }
            else
            {
                м.Добавить(Новый.Структура("Тип, Имя, Поз", "С", с, у._Код));
                if (у._Соседний != 0) м = ПолучитьЭлементы(у._Соседний, с, м);
                
                return м;
            }
            
            if (у._Дочерний != 0) м = ПолучитьЭлементы(у._Дочерний, с, м);
            if (у._Соседний != 0) м = ПолучитьЭлементы(у._Соседний, с, м);

            return м;
        }
        

        public int СвойстваСтроки(int н, bool Создать = false)
        { 
            long нз = н * 20;

            if (н != 0)
            {
                var буф = БуферДвоичныхДанных.Новый(20);
    
                ОткрытьПотокДанных();
                do
                {
                    var пз = нз;
                    
                    ПотокДанных.Перейти(нз, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 20);

                    var и = буф.ПрочитатьЦелое32(12);

                    if (и == н)
                        break;
                    
                    if (и > н || и == 0)
                        нз = буф.ПрочитатьЦелое32(0) * 20;
                    else
                        нз = буф.ПрочитатьЦелое32(4) * 20;

                    if (нз == 0)
                    {
                        if (Создать)
                        {
                            ОткрытьПотокДанных(Истина);
                            нз = ПотокДанных.Размер();
                            
                            var буф1 = БуферДвоичныхДанных.Новый(20);
                            буф1.ЗаписатьЦелое32(12, н);
                            ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                            ПотокДанных.Записать(буф1, 0, 20);
                            
                            if (и > н || и == 0)
                                буф.ЗаписатьЦелое32(0, (int)(нз / 20));
                            else
                                буф.ЗаписатьЦелое32(4, (int)(нз / 20));
                            
                            ПотокДанных.Перейти(пз, ПозицияВПотоке.Начало);
                            ПотокДанных.Записать(буф, 0, 20);
                            ПотокДанных.СброситьБуферы();
                            break;
                        }
                    }
                }
                while (нз != 0);
    
            }
            return (int)(нз / 20);        
        }


        public int НайтиСтроку(string знСтрока, bool Создать = false)
        {
            if (!ЗначениеЗаполнено(знСтрока)) return 0;

            var слв = Новый.Массив();
            var атр = Новый.Массив();

            {
                var сСимв = @" .,!?:;()«»""'–…"; // - дефис потом
    
                var дСтр = Стр.Длина(знСтрока);
    
                var сл = "";
                var ус = true;
    
                for (var нс = 1; ; нс++)
                {
                    var сс = Сред(знСтрока, нс, 1);
                    var пус = ус;
                    ус = (Стр.Найти(сСимв, сс) == 0);
    
                    if (ус && !пус)
                    {
                        слв.Добавить(сл + Символ(0));
                        сл = сс;
                    }
                    else
                        сл = сл + сс;
    
                    if (нс == дСтр)
                    {
                        слв.Добавить(сл + Символ(0));
                        break;
                    }
                }
            }

            ОткрытьПотокДанных();
            var буф = БуферДвоичныхДанных.Новый(20);

            foreach(string слово in слв)
            {
                long ан = 1;
                long нн = 0;                
                long пн = 0;
                long вн = 0;
                var и = 0;
                
                for (var нс = 1; нс <= Стр.Длина(слово); нс++)
                {
                    var сс = Сред(слово, нс, 1);
                    var с = КодСимвола(сс);

                    нн = ан;

                    do
                    {
                        if (нн == 1)
                            нн = 0;
                        else if (нн == 0)
                        {
                            if (!Создать) return 0;

                            var буф1 = БуферДвоичныхДанных.Новый(20);
                            буф1.ЗаписатьЦелое32(12, с);
                            буф1.ЗаписатьЦелое32(16, (int)(вн / 20));

                            ОткрытьПотокДанных(Истина);
                            нн = ПотокДанных.Размер();
                            ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                            ПотокДанных.Записать(буф1, 0, 20);

                            if (ан == 0)
                                буф.ЗаписатьЦелое32(8, (int)(нн / 20));
                            else if (и > с)
                                буф.ЗаписатьЦелое32(0, (int)(нн / 20));
                            else
                                буф.ЗаписатьЦелое32(4, (int)(нн / 20));
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
                        пн = нн;

                        if (и == с)
                            break;
                        
                        if (и > с)
                            нн = буф.ПрочитатьЦелое32(0) * 20;
                        else
                            нн = буф.ПрочитатьЦелое32(4) * 20;

                    } while (true);
    
                    вн = нн;
                    пн = нн;
                    ан = буф.ПрочитатьЦелое32(8) * 20; // след. уровень
    
                }
                атр.Вставить(0, нн);

            }

            long пКод = 0;
            long ад = 0;
            long пдКод = 0;

            foreach (long ан in атр)
            {
                long дКод = ан;
                long нн = ан;
                long пн = нн;
                
                do
                {
                    if (нн == 0)
                    {
                        if (!Создать) return 0;
                        
                        var буф1 = БуферДвоичныхДанных.Новый(20);
                        буф1.ЗаписатьЦелое32(8, (int)(пКод / 20)); // след. указатель
                        буф1.ЗаписатьЦелое32(12, (int)(пдКод / 20)); // след. слово / или свойство
                        буф1.ЗаписатьЦелое32(16, (int)(дКод / 20)); // тек слово.

                        ОткрытьПотокДанных(Истина);
                        нн = ПотокДанных.Размер();
                        ПотокДанных.Перейти(0, ПозицияВПотоке.Конец);
                        ПотокДанных.Записать(буф1, 0, 20);

                        if (ад > пдКод || пн == ан)
                            буф.ЗаписатьЦелое32(0, (int)(нн / 20));
                        else
                            буф.ЗаписатьЦелое32(4, (int)(нн / 20));

                        ПотокДанных.Перейти(пн, ПозицияВПотоке.Начало);
                        ПотокДанных.Записать(буф, 0, 20);
                        ПотокДанных.СброситьБуферы();

                        ОткрытьПотокДанных();

                        буф = буф1;
                        break;
                    }

                    ПотокДанных.Перейти(нн, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф, 0, 20);

                    var а = буф.ПрочитатьЦелое32(8) * 20;
                    ад = буф.ПрочитатьЦелое32(12) * 20;
                    
                    пн = нн;
                    
                    if (а == пКод)
                        break;
                    if (ад > пдКод || пн == ан)
                        нн = буф.ПрочитатьЦелое32(0) * 20;
                    else
                        нн = буф.ПрочитатьЦелое32(4) * 20;

                } while (true);

                пКод = нн;
                пдКод = дКод;

            }

            return (int)(пКод / 20);
        }


        public string ПрочитатьСтроку(int н)
        {
            if (н == 0) return "";

            long нз = н * 20;
            
            var буф = БуферДвоичныхДанных.Новый(20);
            var буф1 = БуферДвоичныхДанных.Новый(20);

            var зСтр = "";

            ОткрытьПотокДанных();
            do
            {
                ПотокДанных.Перейти(нз, ПозицияВПотоке.Начало);
                ПотокДанных.Прочитать(буф, 0, 20);

                var сл = "";

                нз = буф.ПрочитатьЦелое32(16) * 20;
                
                while (нз != 0)
                {
                    ПотокДанных.Перейти(нз, ПозицияВПотоке.Начало);
                    ПотокДанных.Прочитать(буф1, 0, 20);
                    var с = буф1.ПрочитатьЦелое32(12);
                    if (с != 0 ) сл = Символ(с) + сл;
                    нз = буф1.ПрочитатьЦелое32(16) * 20;
                }
                зСтр = зСтр + сл;

                нз = буф.ПрочитатьЦелое32(8) * 20;
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
                var дФайл = ПолучитьДвоичныеДанныеИзСтроки("");
                дФайл.Записать(ИмяФайлаДанных);
                ОткрытьПотокДанных(Истина);
                var Словарь = new _Узел();
                ЗаписатьУзел(ref Словарь);
                var Корень = new _Узел();
                ЗаписатьУзел(ref Корень);
            }

        }

    }
}
