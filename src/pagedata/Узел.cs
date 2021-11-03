/*----------------------------------------------------------
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
    public class Узел
    {

        public bool Изменения = true;
        Структура _п;
        
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
        
        public Узел д(string Имя) 
        {
            var Узел = Дочерний;
            while (Узел != null)
            {
                if (Узел.Имя == Имя)
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

        public string Код;
        public string Имя;
        public object Значение;

        public Узел Дочерний;
        public Узел Соседний;
        public Узел Атрибут;
        public Узел Старший;
        public Узел Родитель;

        public string _Соседний;
        public string _Бывший;

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
                else if (prop == "_Соседний") _Соседний = (string)v;
                else if (prop == "_Бывший") _Бывший = (string)v;
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
                else if (prop == "_Соседний") _Соседний = (string)v;
                else if (prop == "_Бывший") _Бывший = (string)v;
                
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
