/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Collections.Generic;

namespace onesharp
{
    public class Массив : IEnumerable<object>
    {
        private readonly List<object> _values;

        public Массив()
        {
            _values = new List<object>();
        }

        public Массив(IEnumerable<object> values)
        {
            _values = new List<object>(values);
        }

        public object this [int index] {
            get { return Получить(index); }
            set { Установить(index, value); }
        }

        public object[] Arr
        {
            get
            {
                return _values.ToArray();
            }
        }


        #region ICollectionContext Members
        
        public int Количество()
        {
            return _values.Count;
        }

        public void Очистить()
        {
            _values.Clear();
        }

        #endregion

        #region IEnumerable<IRuntimeContextInstance> Members

        public IEnumerator<object> GetEnumerator()
        {
            foreach (var item in _values)
            {
                yield return item;
            }
        }

        #endregion

        #region IEnumerable Members

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        #endregion

        public void Добавить(object value = null)
        {
            _values.Add(value);
        }

        public void Вставить(int index, object value = null)
        {
            if (index < 0)
                throw IndexOutOfBoundsException();

            if (index > _values.Count)
                Extend(index - _values.Count);

            _values.Insert(index, value);
        }

        public int Найти(object what)
        {
            var idx = _values.FindIndex(x => x.Equals(what));
            return idx;
        }

        public void Удалить(int index)
        {
            if (index < 0 || index >= _values.Count)
                throw IndexOutOfBoundsException();

            _values.RemoveAt(index);
        }

        public int ВГраница()
        {
            return _values.Count - 1;
        }

        public object Получить(int index)
        {
            if (index < 0 || index >= _values.Count)
                throw IndexOutOfBoundsException();

            return _values[index];
        }

        public void Установить(int index, object value)
        {
            if (index < 0 || index >= _values.Count)
                throw IndexOutOfBoundsException();

            _values[index] = value;
        }

        private void Extend(int count)
        {
            for (int i = 0; i < count; ++i)
            {
                _values.Add(null);
            }
        }

        private static void FillArray(Массив currentArray, int bound)
        {
            for (int i = 0; i < bound; i++)
            {
                currentArray._values.Add(null);
            }
        }

        private static Массив CloneArray(Массив cloneable)
        {
            Массив clone = new Массив();
            foreach (var item in cloneable._values)
            {
                clone._values.Add(item);
            }
            return clone;
        }

        public static Массив Constructor()
        {
            return new Массив();
        }

        /// <summary>
        /// Позволяет задать измерения массива при его создании
        /// </summary>
        /// <param name="dimensions">Числовые размерности массива. Например, "Массив(2,3)", создает двумерный массив 2х3.</param>
        /// <returns></returns>
        public static Массив Constructor(int[] dimensions)
        {
            Массив cloneable = null;
            for (int dim = dimensions.Length - 1; dim >= 0; dim--)
            {

                int bound = dimensions[dim];

                var newInst = new Массив();
                FillArray(newInst, bound);
                if(cloneable != null)
                {
                    for (int i = 0; i < bound; i++)
                    {
                        newInst._values[i] = CloneArray(cloneable);
                    }
                }
                cloneable = newInst;
                
            }

            return cloneable;

        }

        public static Массив Новый(Массив fixedArray)
        {
            if (!(fixedArray is Массив val))
                throw new Exception("InvalidArgumentType");

            return new Массив(val);
        }

        public static Массив Новый(object[] array)
        {
            return new Массив(array);
        }

        public static Массив Новый()
        {
            return new Массив();
        }

        private static Exception IndexOutOfBoundsException()
        {
            return new Exception("Значение индекса выходит за пределы диапазона");
        }
    }
}
