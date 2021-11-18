﻿/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Dynamic;
using System.Collections.Generic;

namespace onesharp
{
    
    public class дСвойства : DynamicObject
    {
        private readonly Узел уз;
        
        public дСвойства(Узел _уз) 
        {
            уз = _уз;
        }
        
        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            result = null;
            return уз.д(binder.Name, out result);
        }

        // установить свойство
        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            var сУзел = уз.д(binder.Name);
            if (сУзел == null) return false;
            сУзел.Значение = value;
            return true;
        }

    }

    
    public class Узел
    {

        public bool Изменения = true;
        Структура _п;
        дСвойства св;
        
        public void Изменить()
        {
            Изменения = true;
            if (!(Старший == null))
                Старший.Изменить();
        }

        public Структура п
        {
            get
            {
                if (_п is null)
                    _п = Структура.Новый();
                return _п;
            }
        }
        
        public dynamic дс
        { 
            get 
            {
                if (св is null) 
                    св = new дСвойства(this);
                return св; 
            } 
        }        
        
        public bool д(string Имя, out object Знач)
        {
            Знач = this.д(Имя);
            return (Знач != null);
        }

        public Узел д(string Имя) 
        {
            var Узел = Дочерний;
            while (Узел != null)
            {
                if (Узел.Имя == Имя || Узел.Имя == Имя + ".")
                    return Узел;
                Узел = Узел.Соседний;                
            }
            return null;
        }
        
        public Узел а(string Имя) 
        {
            var Узел = Атрибут;
            while (Узел != null)
            {
                if (Узел.Имя == Имя)
                    return Узел;
                Узел = Узел.Соседний;                
            }
            return null;
        }

        public bool ЭтоАтрибут
        { get
            {
                if (this.Родитель is null) return false;
                return (this.Родитель.Атрибут == this || this.Старший.ЭтоАтрибут && this.Старший.Соседний == this);
            }
        }

        public string Код;
        public string Имя;
        public object Значение;

        public object _Атрибут;
        public object _Дочерний;
        public object _Соседний;
        public int _Бывший;

        public Узел Дочерний { get { return _Дочерний as Узел; } set { _Дочерний = value; } }
        public Узел Соседний { get { return _Соседний as Узел; } set { _Соседний = value; } }
        public Узел Атрибут { get { return _Атрибут as Узел; } set { _Атрибут = value; } }
        public Узел Старший;
        public Узел Родитель;

        public Узел() { }

        public Узел(Структура structure)
        {
           foreach (КлючИЗначение keyValue in structure)
            {
                var prop = (string)keyValue.Ключ;
                object v = keyValue.Значение;
                if (prop == "Код") Код = (string)v;
                else if (prop == "Имя") Имя = (string)v;
                else if (prop == "Значение") Значение = v;
                else if (prop == "Дочерний") Дочерний = (Узел)v;
                else if (prop == "Соседний") Соседний = (Узел)v;
                else if (prop == "Атрибут") Атрибут = (Узел)v;
                else if (prop == "Старший") Старший = (Узел)v;
                else if (prop == "Родитель") Родитель = (Узел)v;
                else if (prop == "_Соседний") _Соседний = (int)v;
                else if (prop == "_Бывший") _Бывший = (int)v;
                else if (prop == "Параметры")
                {
                    if (v is Структура)
                        _п = v as Структура;
                    else
                        this.п.Добавить("Параметры", v);
                }
           }

        }

        public Узел(string strProperties, params object[] values) 
        { 
            var props = strProperties.Split(',');

            for (int i = 0, nprop = 0; i < props.Length; i++)
            {
                var prop = props[i].Trim();
                if (prop.Equals(string.Empty))
                    continue;

                object v = nprop < values.Length ? values[nprop] : null;

                if (prop == "Код") Код = (string)v;
                else if (prop == "Имя") Имя = (string)v;
                else if (prop == "Значение") Значение = v;
                else if (prop == "Дочерний") Дочерний = (Узел)v;
                else if (prop == "Соседний") Соседний = (Узел)v;
                else if (prop == "Атрибут") Атрибут = (Узел)v;
                else if (prop == "Старший") Старший = (Узел)v;
                else if (prop == "Родитель") Родитель = (Узел)v;
                else if (prop == "_Соседний") _Соседний = (int)v;
                else if (prop == "_Бывший") _Бывший = (int)v;
                else if (prop == "Параметры")
                {
                    if (v is Структура)
                        _п = v as Структура;
                    else
                        this.п.Добавить("Параметры", v);
                }
                ++nprop;
            }        
        }

        public static Узел Новый(Структура fixedStruct)
        {
            return new Узел(fixedStruct);
        }

        public static Узел Новый(string param1, params object[] args)
        {
            return new Узел(param1, args);
        }

        public static Узел Новый()
        {
            return new Узел();
        }

    }
}
