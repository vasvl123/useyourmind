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
    public class Свойства : DynamicObject
    {
        private readonly Dictionary<string, object> _values;
        
        public Свойства(Dictionary<string, object> values) {
            _values = values;
        }
        
        public override bool TryGetMember(GetMemberBinder binder, out object result)
        {
            result = null;
            if (_values.ContainsKey(binder.Name))
            {
                _values.TryGetValue(binder.Name, out result);
                return true;
            }
            return false;
        }

        // установить свойство
        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            _values.Remove(binder.Name);
            _values.Add(binder.Name, value);  
            return true;
        }

    }

    public class Структура : IEnumerable<object>
    {
        private readonly Dictionary<string, object> _values = new Dictionary<string, object>();

        private Свойства св;

        public Структура() {}

        public dynamic с 
        { 
            get 
            {
                if (св is null) св = new Свойства(_values);
                return св; 
            } 
        }

        public object this[string key]
        {
            get { return Получить(key); }
            set { Вставить(key, value); }
        }

        public T Получить<T>(string key) => (T)this[key];
        

        public Структура(string strProperties, params object[] values)
        {
            var props = strProperties.Split(',');

            for (int i = 0, nprop = 0; i < props.Length; i++)
            {
                var prop = props[i].Trim();
                if (prop.Equals(string.Empty))
                    continue;

                Вставить(prop, nprop < values.Length ? values[nprop] : null);
                ++nprop;
            }
        }

        public Структура(Структура structure)
        {
            foreach (КлючИЗначение keyValue in structure)
            {
                Вставить((string)keyValue.Ключ, keyValue.Значение);
            }
        }

        private static bool IsValidIdentifier(string name)
        {
            if (name == null || name.Length == 0)
                return false;

            if (!(Char.IsLetter(name[0]) || name[0] == '_'))
                return false;

            for (int i = 1; i < name.Length; i++)
            {
                if (!(Char.IsLetterOrDigit(name[i]) || name[i] == '_'))
                    return false;
            }

            return true;
        }

        public bool Свойство(string key)
        {
            return _values.ContainsKey(key);
        }

        public bool Свойство(string key, out object value)
        {
            value = null;
            if (key is null || key == "") return false;
            if (_values.ContainsKey(key))
            {
                _values.TryGetValue(key, out value);
                return true;
            }
            return false;
        }

        public object Получить(string key)
        {
            if (key is null || key == "") return null;
            if (_values.ContainsKey(key)) {
                object value = null;
                _values.TryGetValue(key, out value);
                return value;
            }
            return null;
        }

        public void Вставить(string key, object value = null)
        {
            if (!IsValidIdentifier(key))
                throw InvalidPropertyNameException(key);

            _values.Remove(key);
            _values.Add(key, value);
        }

        public void Добавить(string key, object value = null)
        {
            _values.Remove(key);
            _values.Add(key, value);
        }

        public void Удалить(string key)
        {
            _values.Remove(key);
        }

        public int Количество()
        {
            return _values.Count;
        }

        public void Очистить()
        {
            _values.Clear();
        }

        #region IEnumerable<IValue> Members

        public IEnumerator<object> GetEnumerator()
        {
            foreach (var item in _values)
            {
                yield return new КлючИЗначение(
                    item.Key,
                    item.Value);
            }
        }

        #endregion

        #region IEnumerable Members

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        #endregion 


         /// <summary>
        /// Создает структуру по фиксированной структуре
        /// </summary>
        /// <param name="fixedStruct">Исходная структура</param>
        //[ScriptConstructor(Name = "Из фиксированной структуры")]
        public static Структура Новый(Структура fixedStruct)
        {
            return new Структура(fixedStruct);
        }

        /// <summary>
        /// Создает структуру по заданному перечню свойств и значений
        /// </summary>
        /// <param name="param1">Фиксированная структура либо строка с именами свойств, указанными через запятую.</param>
        /// <param name="args">Только для перечня свойств:
        /// Значения свойств. Каждое значение передается, как отдельный параметр.</param>
        public static Структура Новый(string param1, params object[] args)
        {
            return new Структура(param1, args);
        }

        public static Структура Новый()
        {
            return new Структура();
        }

        private static RuntimeException InvalidPropertyNameException(string name )
        {
            return new RuntimeException($"Задано неправильное имя атрибута структуры '{name}'");
        }
        
        public string ToClass()
        {
            string res = "";

            foreach (КлючИЗначение keyValue in this) 
            {
                var зн = keyValue.Значение;
                var тип = "string";
                if (зн != null) тип = зн.GetType().ToString();
                string имя = keyValue.Ключ.ToString();
                res = res + "public " + тип + " " + имя + @"{ get { return Получить(""" + имя + @""") as " + тип + @"; } set { Вставить(""" + имя + @""", value); } }" + "\n";
            }
            
            return res;
        }

    }
}
