using System;

namespace onesharp
{
 
    public class КлючИЗначение
    {
        private readonly object _item;
        private readonly object _key;
        private readonly object _value;

        public object Impl
        {
            get
            {
                return _value;
            }
        }

        public КлючИЗначение(object key, object value, object item = null)
        {
            _key = key;
            _value = value;
            _item = item;
        }

        public string Представление
        {
            get
            {
                return (string)_key;
            }
        }

        public object Ключ
        {
            get
            {
                return _key;
            }
        }

        public object Значение
        {
            get
            {
                return _value;
            }
        }

    }

}
