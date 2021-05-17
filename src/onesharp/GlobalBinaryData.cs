/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System;
using onesharp.Binary;

namespace onesharp
{
    /// <summary>
    /// Глобальный контекст. Операции с двоичными данными.
    /// </summary>
    public sealed class GlobalBinaryData
    {
        private static byte[] StringToByteArray(String hex)
        {
            try
            {
                var newHex = hex.Replace(" ", String.Empty);
                int numberChars = newHex.Length;
                byte[] bytes = new byte[numberChars / 2];
                for (int i = 0; i < numberChars; i += 2)
                    bytes[i / 2] = Convert.ToByte(newHex.Substring(i, 2), 16);
                return bytes;
            }
            catch (FormatException)
            {
                throw new FormatException("Неверный формат шестнадцатеричной строки");
            }
            
        }
        
        /// <summary>
        /// Объединяет несколько объектов типа ДвоичныеДанные в один.
        /// </summary>
        /// <param name="array">Массив объектов типа ДвоичныеДанные.</param>
        /// <returns>Тип: ДвоичныеДанные.</returns>
        public static ДвоичныеДанные СоединитьДвоичныеДанные(Массив array)
        {
            // Сделано на int т.к. BinaryContext.Size имеет тип int;

            using (var stream = new System.IO.MemoryStream())
            {

                foreach (var cbd in array)
                {
                    byte[] buffer = ((ДвоичныеДанные) cbd).Buffer;
                    stream.Write(buffer, 0, buffer.Length);
                }

                return new ДвоичныеДанные(stream.ToArray());
            }
        }

        /// <summary>
        /// Разделяет двоичные данные на части заданного размера. Размер задается в байтах.
        /// </summary>
        /// <param name="data">Объект типа ДвоичныеДанные.</param>
        /// <param name="size">Размер одной части данных.</param>
        /// <returns>Массив объектов типа ДвоичныеДанные.</returns>
        public static Массив РазделитьДвоичныеДанные(ДвоичныеДанные data, int size)
        {
            // Сделано на int т.к. BinaryContext.Size имеет тип int;
            Массив array = new Массив();

            int readedBytes = 0;
            
            while (readedBytes < data.Buffer.Length)
            {
                int bytesToRead = size;
                if (bytesToRead > data.Buffer.Length - readedBytes)
                    bytesToRead = data.Buffer.Length - readedBytes;

                byte[] buffer = new byte[bytesToRead];
                Buffer.BlockCopy(data.Buffer, readedBytes, buffer, 0, bytesToRead);
                readedBytes += bytesToRead;
                array.Добавить(new ДвоичныеДанные(buffer));
            }

            return array;
        }

        /// <summary>
        /// Преобразует строку в значение типа ДвоичныеДанные с учетом кодировки текста.
        /// </summary>
        /// <param name="str">Строка, которую требуется преобразовать в ДвоичныеДанные.</param>
        /// <param name="encoding">Кодировка текста</param>
        /// <param name="addBOM">Определяет, будет ли добавлена метка порядка байт (BOM) кодировки текста в начало данных.</param>
        /// <returns>Тип: ДвоичныеДанные.</returns>
        public static ДвоичныеДанные ПолучитьДвоичныеДанныеИзСтроки(string str, string encoding = null, bool addBOM = false)
        {
            // Получаем кодировку
            // Из синтаксис помощника если кодировка не задана используем UTF8

            System.Text.Encoding enc = System.Text.Encoding.UTF8;
            if (encoding != null)
                enc = КодировкаТекста.GetEncoding(encoding, addBOM);

            return new ДвоичныеДанные(enc.GetBytes(str));
        }

        // ToDo: ПолучитьБуферДвоичныхДанныхИзСтроки 

        public static string ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные data, string encoding = null)
        {
            // Получаем кодировку
            // Из синтаксис помощника если кодировка не задана используем UTF8

            System.Text.Encoding enc = System.Text.Encoding.UTF8;
            if (encoding != null)
                enc = КодировкаТекста.GetEncoding(encoding);

            return enc.GetString(data.Buffer);
        }

        // ToDo: ПолучитьСтрокуИзБуфераДвоичныхДанных


        /// <summary>
        /// Преобразует строку формата Base64 в двоичные данные.
        /// </summary>
        /// <param name="str">Строка в формате Base64.</param>
        /// <returns>Тип: ДвоичныеДанные.</returns>
        public static ДвоичныеДанные ПолучитьДвоичныеДанныеИзBase64Строки(string str)
        {
            return new ДвоичныеДанные(System.Convert.FromBase64String(str));
        }

        // ToDo: ПолучитьБуферДвоичныхДанныхИзBase64Строки

        public static string ПолучитьBase64СтрокуИзДвоичныхДанных(ДвоичныеДанные data)
        {
            return System.Convert.ToBase64String(data.Buffer);
        }

        // ToDo: ПолучитьBase64СтрокуИзБуфераДвоичныхДанных

        // ToDo: ПолучитьДвоичныеДанныеИзBase64ДвоичныхДанных

        // ToDo: ПолучитьБуферДвоичныхДанныхИзBase64БуфераДвоичныхДанных

        // ToDo: ПолучитьBase64ДвоичныеДанныеИзДвоичныхДанных

        // ToDo: ПолучитьBase64БуферДвоичныхДанныхИзБуфераДвоичныхДанных

        /// <summary>
        /// Преобразует строку формата Base 16 (Hex) в двоичные данные.
        /// </summary>
        /// <param name="hex">Строка в формате Base 16 (Hex).</param>
        /// <returns>Тип: ДвоичныеДанные.</returns>
        public static ДвоичныеДанные ПолучитьДвоичныеДанныеИзHexСтроки(string hex)
        {
            return new ДвоичныеДанные(StringToByteArray(hex));
        }
        
        /// <summary>
        /// Преобразует строку в формате Base 16 (Hex) в буфер двоичных данных.
        /// </summary>
        /// <param name="hex">Строка в формате Base 16 (Hex).</param>
        /// <returns>Тип: БуферДвоичныхДанных.</returns>
        public static БуферДвоичныхДанных ПолучитьБуферДвоичныхДанныхИзHexСтроки(string hex)
        {
            return new БуферДвоичныхДанных(StringToByteArray(hex));
        }
        
        /// <summary>
        /// Преобразует двоичные данные в строку формата Base 16 (Hex).
        /// </summary>
        /// <param name="data">Двоичные данные.</param>
        /// <returns>Тип: Строка.</returns>
        public static string ПолучитьHexСтрокуИзДвоичныхДанных(ДвоичныеДанные data)
        {
            return BitConverter.ToString(data.Buffer).Replace("-","");
        }

        /// <summary>
        /// Преобразует буфер двоичных данных в строку формата Base 16 (Hex).
        /// </summary>
        /// <param name="buffer">Буфер двоичных данных.</param>
        /// <returns>Тип: Строка.</returns>
        public static string ПолучитьHexСтрокуИзБуфераДвоичныхДанных(БуферДвоичныхДанных buffer)
        {
            return BitConverter.ToString(buffer.Bytes).Replace("-","");
        }

        // ToDo: ПолучитьДвоичныеДанныеИзHexДвоичныхДанных

        // ToDo: ПолучитьБуферДвоичныхДанныхИзHexБуфераДвоичныхДанных

        // ToDo: ПолучитьHexДвоичныеДанныеИзДвоичныхДанных

        // ToDo: ПолучитьHexБуферДвоичныхДанныхИзБуфераДвоичныхДанных

        /// <summary>
        /// Преобразует двоичные данные в буфер двоичных данных.
        /// </summary>
        /// <param name="data">Двоичные данные.</param>
        /// <returns>Тип: БуферДвоичныхДанных.</returns>
        public static БуферДвоичныхДанных ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные data)
        {
            return new БуферДвоичныхДанных(data.Buffer);
        }

        /// <summary>
        /// Преобразует буфер двоичных данных в значение типа ДвоичныеДанные.
        /// </summary>
        /// <param name="buffer">Буфер двоичных данных.</param>
        /// <returns>Тип: ДвоичныеДанные.</returns>
        public static ДвоичныеДанные ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(БуферДвоичныхДанных buffer)
        {
            return new ДвоичныеДанные(buffer.Bytes);
        }

    }
}
