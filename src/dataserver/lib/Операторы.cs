﻿// MIT License
// Copyright (c) 2020 vasvl123
// https://github.com/vasvl123/useyourmind
//
// Включает программный код https://github.com/tsukanov-as/kojura

using System;

namespace onesharp.lib
{
    class Операторы : Onesharp
    {

        public Операторы() : base("Операторы") { }

        public object Оператор_ЕСТЬЗНАЧЕНИЕ(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Значение = Данные.Интерпретировать(Аргумент, Неопределено, Ложь);
            return (!("" + Значение == ""));
        } // ЕстьЗначение()

        public object Оператор_ПУСТОЙ(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var _Аргумент = Данные.Интерпретировать(Аргумент, Неопределено, Ложь);
            return (_Аргумент == Данные.Пустой);
        } // Пустой()

        public object Оператор_СУММА(treedata Данные, Узел Аргумент)
        {
            object Значение;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            while (Аргумент != Неопределено)
            {
                Значение = (int)Число(Значение) + (int)Число(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            return Значение;
        } // Сумма()

        public object Оператор_РАЗНОСТЬ(treedata Данные, Узел Аргумент)
        {
            object Значение;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                return -(int)Число(Значение);
            }
            while (Аргумент != Неопределено)
            {
                Значение = (int)Число(Значение) - (int)Число(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            return Значение;
        } // Разность()

        public object Оператор_ПРОИЗВЕДЕНИЕ(treedata Данные, Узел Аргумент)
        {
            object Значение;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            while (Аргумент != Неопределено)
            {
                Значение = (int)Число(Значение) * (int)Число(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            return Значение;
        } // Произведение()

        public object Оператор_ЧАСТНОЕ(treedata Данные, Узел Аргумент)
        {
            object Значение;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            while (Аргумент != Неопределено)
            {
                Значение = (int)Число(Значение) / (int)Число(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            return Значение;
        } // Частное()

        public object Оператор_ОСТАТОК(treedata Данные, Узел Аргумент)
        {
            object Значение;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            while (Аргумент != Неопределено)
            {
                Значение = (int)Число(Значение) % (int)Число(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            return Значение;
        } // Остаток()

        public object Оператор_ЕСЛИ(treedata Данные, Узел Узел)
        {
            var СписокЕсли = Узел;
            var СписокТогда = СписокЕсли.Соседний;
            var СписокИначе = СписокТогда.Соседний;
            var зЕсли = Данные.Интерпретировать(СписокЕсли);
            if (зЕсли is string)
            {
                зЕсли = (зЕсли as string == "Истина" || зЕсли as string == "Да" || зЕсли as string == "True");
            }
            if (зЕсли as bool? == Истина)
            {
                return Данные.Интерпретировать(СписокТогда);
            }
            else if (!(СписокИначе == Неопределено))
            {
                return Данные.Интерпретировать(СписокИначе);
            }
            else
            {
                return Неопределено;
            }
        } // ЗначениеВыраженияЕсли()

        public object Оператор_ВЫБОР(treedata Данные, Узел Список)
        {
            dynamic СписокТогда;
            var СписокКогда = Список;
            if (СписокКогда == Неопределено)
            {
                ВызватьИсключение("Ожидается условие");
            }
            while (СписокКогда != Неопределено)
            {
                СписокТогда = СписокКогда.Соседний;
                if (СписокТогда == Неопределено)
                {
                    ВызватьИсключение("Ожидается выражение");
                }
                if (Данные.Интерпретировать(СписокКогда) as bool? == Истина)
                {
                    return Данные.Интерпретировать(СписокТогда);
                }
                СписокКогда = СписокТогда.Соседний;
            }
            ВызватьИсключение("Ни одно из условий не сработало!");
            return null;
        } // ЗначениеВыраженияВыбор()

        public object Оператор_РАВНО(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Значение = Данные.Интерпретировать(Аргумент) as string;
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                var знАрг = Данные.Интерпретировать(Аргумент) as string;
                Результат = (Результат && Значение as string == знАрг);
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // Равно()

        public object Оператор_БОЛЬШЕ(treedata Данные, Узел Аргумент)
        {
            int Значение1, Значение2;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение1 = (int)Число(Данные.Интерпретировать(Аргумент));
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                Значение2 = (int)Число(Данные.Интерпретировать(Аргумент));
                Результат = Результат && Значение1 > Значение2;
                Значение1 = Значение2;
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // Больше()

        public object Оператор_МЕНЬШЕ(treedata Данные, Узел Аргумент)
        {
            int Значение1, Значение2;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение1 = (int)Число(Данные.Интерпретировать(Аргумент));
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                Значение2 = (int)Число(Данные.Интерпретировать(Аргумент));
                Результат = Результат && Значение1 < Значение2;
                Значение1 = Значение2;
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // Меньше()

        public object Оператор_БОЛЬШЕИЛИРАВНО(treedata Данные, Узел Аргумент)
        {
            int Значение1, Значение2;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение1 = (int)Число(Данные.Интерпретировать(Аргумент));
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                Значение2 = (int)Число(Данные.Интерпретировать(Аргумент));
                Результат = Результат && Значение1 >= Значение2;
                Значение1 = Значение2;
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // БольшеИлиРавно()

        public object Оператор_МЕНЬШЕИЛИРАВНО(treedata Данные, Узел Аргумент)
        {
            int Значение1, Значение2;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение1 = (int)Число(Данные.Интерпретировать(Аргумент));
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                Значение2 = (int)Число(Данные.Интерпретировать(Аргумент));
                Результат = Результат && Значение1 <= Значение2;
                Значение1 = Значение2;
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // МеньшеИлиРавно()

        public object Оператор_НЕРАВНО(treedata Данные, Узел Аргумент)
        {
            object Значение1, Значение2;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            Значение1 = Данные.Интерпретировать(Аргумент);
            Аргумент = Аргумент.Соседний;
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                Значение2 = Данные.Интерпретировать(Аргумент);
                Результат = Результат && Значение1 != Значение2;
                Значение1 = Значение2;
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // НеРавно()

        public object Оператор_И(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                var Значение = Данные.Интерпретировать(Аргумент);
                if (Значение is bool) Результат = Результат && (bool)Значение;
                else if (Значение is string)
                {
                    Результат = Результат && (Значение as string == "Истина" || Значение as string == "Да" || Значение as string == "True");
                }
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // ЛогическоеИ()

        public object Оператор_ИЛИ(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Ложь;
            while (Аргумент != Неопределено && !(Результат))
            {
                var Значение = Данные.Интерпретировать(Аргумент);
                if (Значение is bool) Результат = Результат || (bool)Значение;
                else if (Значение is string)
                {
                    Результат = Результат || (Значение as string == "Истина" || Значение as string == "Да" || Значение as string == "True");
                }
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // ЛогическоеИли()

        public object Оператор_НЕ(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Результат = Истина;
            while (Аргумент != Неопределено && Результат)
            {
                var Значение = Данные.Интерпретировать(Аргумент);
                if (Значение is bool) Результат = Результат && !(bool)Значение;
                else if (Значение is string)
                {
                    Результат = Результат && !(Значение as string == "Истина" || Значение as string == "Да" || Значение as string == "True");
                }
                Аргумент = Аргумент.Соседний;
            }
            return Результат;
        } // ЛогическоеНе()

        public object Оператор_ВЫВЕСТИСООБЩЕНИЕ(treedata Данные, Узел Аргумент)
        {
            if (Аргумент == Неопределено)
            {
                ВызватьИсключение("Ожидается аргумент");
            }
            var Значения = Массив.Новый();
            while (Аргумент != Неопределено)
            {
                Значения.Добавить(Данные.Интерпретировать(Аргумент));
                Аргумент = Аргумент.Соседний;
            }
            Данные.Процесс.ЗаписатьСобытие("Интерпретатор", Стр.Соединить(Значения, " "), 1);
            return Неопределено;
        } // ВывестиСообщение

        public object Оператор_ВСТРУКТУРУ(treedata Данные, Узел Аргумент, Структура Результат = null)
        {
            object Ключ = null;
            object Значение;
            if (!(Аргумент == Неопределено))
            {
                if (Аргумент.Имя == "Ключ" || Аргумент.Имя == "К")
                {
                    if (Результат == Неопределено)
                    {
                        Результат = Структура.Новый();
                    }
                    Аргумент.Свойство("Значение", out Ключ);
                    if (!(Ключ == Неопределено))
                    {
                        var Дочерний = Аргумент.Дочерний;
                        if (!(Дочерний == Неопределено))
                        {
                            Значение = Оператор_ВСТРУКТУРУ(Данные, Дочерний);
                        }
                        else
                        {
                            Значение = "";
                        }
                        Результат.Вставить(Ключ as string, Значение);
                    }
                    var Соседний = Аргумент.Соседний;
                    if (!(Соседний == Неопределено))
                    {
                        Результат = Оператор_ВСТРУКТУРУ(Данные, Соседний, Результат) as Структура;
                    }
                }
                else
                {
                    return Данные.Интерпретировать(Аргумент);
                }
            }
            return Результат;
        }

        public object Оператор_СУБЪЕКТ(treedata Данные, Структура Аргумент)
        {
            return Данные.Процесс.ПолучитьСубъект();
        }

        public object Оператор_ТипСобытия(treedata Данные, object Аргумент)
        {
            return  (Аргумент as string == "0") ? "Общее" :  (Аргумент as string == "1") ? "Успех" : (Аргумент as string == "2") ? "Внимание" : "Ошибка";
        } // ТипСобытия()


    }
}
