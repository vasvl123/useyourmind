/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System;
using System.Linq;

namespace onesharp
{
    public static class Стр
    {

        public static int Длина(string str)
        {
            return str.Length;
        }

        public static string Заменить(string sourceString, string searchVal, string newVal)
        {
            return sourceString.Replace(searchVal, newVal);
        }

        /// <summary>
        /// Определяет, что строка начинается с указанной подстроки.
        /// </summary>
        /// <param name="inputString">Строка, начало которой проверяется на совпадение с подстрокой поиска.</param>
        /// <param name="searchString">Строка, содержащая предполагаемое начало строки. В случае если переданное значение является пустой строкой генерируется исключительная ситуация.</param>
        public static bool НачинаетсяС(string inputString, string searchString)
        {
            bool result = false;

            if (!string.IsNullOrEmpty(inputString))
            {
                if (!string.IsNullOrEmpty(searchString))
                {
                    result = inputString.StartsWith(searchString);
                }
                else throw new Exception("Ошибка при вызове метода контекста (СтрНачинаетсяС): Недопустимое значение параметра (параметр номер '2')");
            }

            return result;
        }

        /// <summary>
        /// Определяет, заканчивается ли строка указанной подстрокой.
        /// </summary>
        /// <param name="inputString">Строка, окончание которой проверяется на совпадение с подстрокой поиска.</param>
        /// <param name="searchString">Строка, содержащая предполагаемое окончание строки. В случае если переданное значение является пустой строкой генерируется исключительная ситуация.</param>
        public static bool ЗаканчиваетсяНа(string inputString, string searchString)
        {
            bool result = false;

            if (!string.IsNullOrEmpty(inputString))
            {
                if (!string.IsNullOrEmpty(searchString))
                {
                    result = inputString.EndsWith(searchString);
                }
                else throw new Exception("Ошибка при вызове метода контекста (СтрЗаканчиваетсяНа): Недопустимое значение параметра (параметр номер '2')");
            }

            return result;
        }

        /// <summary>
        /// Разделяет строку на части по указанным символам-разделителям.
        /// </summary>
        /// <param name="inputString">Разделяемая строка.</param>
        /// <param name="stringDelimiter">Строка символов, каждый из которых является индивидуальным разделителем.</param>
        /// <param name="includeEmpty">Указывает необходимость включать в результат пустые строки, которые могут образоваться в результате разделения исходной строки. Значение по умолчанию: Истина. </param>
        public static string[] Разделить(string inputString, string stringDelimiter, bool? includeEmpty = true)
        {
            string[] arrParsed;
            if (includeEmpty == null)
                includeEmpty = true;

            if (!string.IsNullOrEmpty(inputString))
            {
                arrParsed = inputString.Split(stringDelimiter?.ToCharArray(), (bool)includeEmpty ? StringSplitOptions.None : StringSplitOptions.RemoveEmptyEntries);
            }
            else
            {
                arrParsed = (bool)includeEmpty ? new string[] { string.Empty } : new string[0];
            }
            return arrParsed;
        }

        /// <summary>
        /// Соединяет массив переданных строк в одну строку с указанным разделителем
        /// </summary>
        /// <param name="input">Массив - соединяемые строки</param>
        /// <param name="delimiter">Разделитель. Если не указан, строки объединяются слитно</param>
        public static string Соединить(Массив input, string delimiter = null)
        {
            var strings = input.Select(x => x);

            return String.Join(delimiter, strings);
        }

        public static string Соединить(string[] strings, string delimiter = null)
        {
            return String.Join(delimiter, strings);
        }

        /// <summary>
        /// Сравнивает строки без учета регистра.
        /// </summary>
        /// <param name="first"></param>
        /// <param name="second"></param>
        /// <returns>-1 первая строка больше, 1 - вторая строка больше. 0 - строки равны</returns>
        public static int Сравнить(string first, string second)
        {
            return String.Compare(first, second, true);
        }

        /// <summary>
        /// Находит вхождение искомой строки как подстроки в исходной строке
        /// </summary>
        /// <param name="haystack">Строка, в которой ищем</param>
        /// <param name="needle">Строка, которую надо найти</param>
        /// <param name="direction">значение перечисления НаправлениеПоиска (с конца/с начала)</param>
        /// <param name="startPos">Начальная позиция, с которой начинать поиск</param>
        /// <param name="occurance">Указывает номер вхождения искомой подстроки в исходной строке</param>
        /// <returns>Позицию искомой строки в исходной строке. Возвращает 0, если подстрока не найдена.</returns>
        public static int Найти(string haystack, string needle, НаправлениеПоиска direction = НаправлениеПоиска.СНачала, int startPos = 0, int occurance = 0)
        {
            int len = haystack.Length;
            if (len == 0 || needle.Length == 0)
                return 0;

            bool fromBegin = direction == НаправлениеПоиска.СНачала;

            if (startPos == 0)
            {
                startPos = fromBegin ? 1 : len;
            }

            if (startPos < 1 || startPos > len)
                throw RuntimeException.InvalidArgumentValue();

            if (occurance == 0)
                occurance = 1;

            int startIndex = startPos - 1;
            int foundTimes = 0;
            int index = len + 1;

            if (fromBegin)
            {
                while (foundTimes < occurance && index >= 0)
                {
                    index = haystack.IndexOf(needle, startIndex, StringComparison.Ordinal);
                    if (index >= 0)
                    {
                        startIndex = index + 1;
                        foundTimes++;
                    }
                    if (startIndex >= len)
                        break;
                }

            }
            else
            {
                while (foundTimes < occurance && index >= 0)
                {
                    index = haystack.LastIndexOf(needle, startIndex, StringComparison.Ordinal);
                    if (index >= 0)
                    {
                        startIndex = index - 1;
                        foundTimes++;
                    }
                    if (startIndex < 0)
                        break;
                }

            }

            if (foundTimes == occurance)
                return index + 1;
            else
                return 0;
        }

        public static string Шаблон(string srcFormat, params string[] arguments)
        {
            if (srcFormat == String.Empty)
                return "";

            var re = new System.Text.RegularExpressions.Regex(@"(%%)|(%\d+)|(%\D)");
            int matchCount = 0;
            int passedArgsCount = arguments.Count(x => !(x is null));
            var result = re.Replace(srcFormat, (m) =>
            {
                if (m.Groups[1].Success)
                    return "%";

                if (m.Groups[2].Success)
                {
                    matchCount++;
                    var number = int.Parse(m.Groups[2].Value.Substring(1));
                    if (number < 1 || number > 11)
                        throw new Exception("Ошибка при вызове метода контекста (СтрШаблон): Ошибка синтаксиса шаблона в позиции " + (m.Index + 1));

                    if (arguments[number-1] != null && !(arguments[number-1]is null))
                        return arguments[number-1];
                    else
                        return "";
                }

                throw new Exception("Ошибка при вызове метода контекста (СтрШаблон): Ошибка синтаксиса шаблона в позиции " + (m.Index + 1));

            });

            if (passedArgsCount > matchCount)
                throw RuntimeException.TooManyArgumentsPassed();

            return result;
        }

    }

    public enum НаправлениеПоиска
    {
        СНачала,
        СКонца
    }


}
