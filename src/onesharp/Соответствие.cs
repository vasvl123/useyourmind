/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System.Collections.Generic;

namespace onesharp
{
    public class Соответствие : IEnumerable<object>
    {
        private readonly Dictionary<object, object> _content = new Dictionary<object, object>();

        public Соответствие()
        {
        }

        public object this[object key]
        {
            get { return Получить(key); }
            set { Вставить(key, value); }
        }

        public Соответствие(IEnumerable<object> source)
        {
            foreach (КлючИЗначение kv in source)
            {
                _content.Add(kv.Ключ, kv.Значение);
            }
        }

        #region ICollectionContext Members

        public bool Содержит(object key)
        {
            if (key is null) return false;
            return _content.ContainsKey(key);
        }

        public T Получить<T>(object key) => (T)this[key];

        public object Получить(object key)
        {
            if (key is null) return null;
            if (_content.ContainsKey(key))
            {
                object value = null;
                _content.TryGetValue(key, out value);
                return value;
            }
            return null;
        }

        public void Вставить(object key, object value = null)
        {
            _content.Remove(key);
            _content.Add(key, value);
        }

        public void Добавить(object key, object value = null)
        {
            _content.Remove(key);
            _content.Add(key, value);
        }

        public void Удалить(object key)
        {
            _content.Remove(key);
        }

        public int Количество()
        {
            return _content.Count;
        }

        public void Очистить()
        {
            _content.Clear();
        }

        #endregion

        #region IEnumerable<IValue> Members

        public IEnumerator<object> GetEnumerator()
        {
            foreach (var item in _content)
            {
                yield return new КлючИЗначение(item.Key, item.Value);
            }
        }

        #endregion

        #region IEnumerable Members

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        #endregion

        public static Соответствие Constructor()
        {
            return new Соответствие();
        }

        public static Соответствие Новый()
        {
            return new Соответствие();
        }

        public static Соответствие Constructor(Соответствие source)
        {
            if (!(source is Соответствие fix))
                throw RuntimeException.InvalidArgumentType();
            
            return new Соответствие(fix);
        }
    }
}
