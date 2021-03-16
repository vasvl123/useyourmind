/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.IO;
using System.Text;

using onesharp.Binary;

namespace onesharp
{
    /// <summary>
    /// Предназначен для последовательного чтения файлов, в том числе большого размера.
    /// </summary>
    public class ЧтениеТекста : IDisposable
    {
        // TextReader _reader;
        CustomLineFeedStreamReader _reader;
        string _lineDelimiter = "\n";

        public ЧтениеТекста ()
        {
            AnalyzeDefaultLineFeed = true;
        }

        /// <summary>
        /// Открывает текстовый файл для чтения. Ранее открытый файл закрывается.
        /// </summary>
        /// <param name="input">Путь к файлу или поток</param>
        /// <param name="encoding">Кодировка</param>
        /// <param name="lineDelimiter">Раздедитель строк</param>
        /// <param name="eolDelimiter">Разделитель строк в файле</param>
        /// <param name="monopoly">Открывать монопольно</param>
        public void Открыть(object input, string encoding = null, string lineDelimiter = "\n", string eolDelimiter = null,
            bool? monopoly = null)
        {
            Закрыть();
            if(IsStream(input, out var wrapper))
            {
                OpenStream(wrapper, encoding, lineDelimiter, eolDelimiter);
            }
            else
            {
                OpenFile((string)input, encoding, lineDelimiter, eolDelimiter, monopoly);
            }
        }

        private void OpenStream(IStreamWrapper streamObj, string encoding = null, string lineDelimiter = "\n", string eolDelimiter = null)
        {
            TextReader imReader;
            if (encoding == null)
            {
                imReader = FileOpener.OpenReader(streamObj.GetUnderlyingStream());
            }
            else
            {
                var enc = КодировкаТекста.GetEncoding(encoding);
                imReader = FileOpener.OpenReader(streamObj.GetUnderlyingStream(), enc);
            }
            _reader = GetCustomLineFeedReader(imReader, lineDelimiter, eolDelimiter, AnalyzeDefaultLineFeed);
        }

        private void OpenFile(string path, string encoding = null, string lineDelimiter = "\n", string eolDelimiter = null,
            bool? monopoly = null)
        {
            TextReader imReader;
            var shareMode = (monopoly ?? true) ? FileShare.None : FileShare.ReadWrite;
            if (encoding == null)
            {
                imReader = FileOpener.OpenReader(path, shareMode);
            }
            else
            {
                var enc = КодировкаТекста.GetEncoding(encoding);
                imReader = FileOpener.OpenReader(path, shareMode, enc);
            }
            _reader = GetCustomLineFeedReader(imReader, lineDelimiter, eolDelimiter, AnalyzeDefaultLineFeed);
        }

        private bool AnalyzeDefaultLineFeed { get; set; }

        private int ReadNext()
        {
            return _reader.Read ();
        }

        /// <summary>
        /// Считывает строку указанной длины или до конца файла.
        /// </summary>
        /// <param name="size">Размер строки. Если не задан, текст считывается до конца файла</param>
        /// <returns>Строка - считанная строка, Неопределено - в файле больше нет данных</returns>
        public string Прочитать(int size = 0)
        {
            RequireOpen();

            var sb = new StringBuilder();
            var read = 0;
            do {
                var ic = ReadNext();
                if (ic == -1)
                    break;
                sb.Append((char)ic);
                ++read;
            } while (size == 0 || read < size);

            if (sb.Length == 0)
                return "";

            return sb.ToString();
        }

        /// <summary>
        /// Считывает очередную строку текстового файла.
        /// </summary>
        /// <param name="overridenLineDelimiter">Подстрока, считающаяся концом строки. Переопределяет РазделительСтрок,
        /// переданный в конструктор или в метод Открыть</param>
        /// <returns>Строка - в случае успешного чтения, Неопределено - больше нет данных</returns>
        public string ПрочитатьСтроку(string overridenLineDelimiter = null)
        {
            RequireOpen();
            return _reader.ReadLine (overridenLineDelimiter ?? _lineDelimiter);
        }

        /// <summary>
        /// Закрывает открытый текстовый файл. Если файл был открыт монопольно, то после закрытия он становится доступен.
        /// </summary>
        public void Закрыть()
        {
            Dispose();
        }

        private void RequireOpen()
        {
            if (_reader == null)
            {
                throw new RuntimeException("Файл не открыт");
            }
        }

        /// <summary>
        /// Открывает текстовый файл для чтения.
        /// </summary>
        /// <param name="input">Путь к файлу или поток</param>
        /// <returns>ЧтениеТекста</returns>
        public static ЧтениеТекста Новый (string input)
        {
            var reader = new ЧтениеТекста ();
            reader.AnalyzeDefaultLineFeed = false;
            reader.Открыть (input, null, "\n", "\r\n");
            return reader;
        }

        /// <summary>
        /// Открывает текстовый файл или поток для чтения. Работает аналогично методу Открыть.
        /// </summary>
        /// <param name="input">Путь к файлу или поток</param>
        /// <param name="encoding">Кодировка</param>
        /// <param name="lineDelimiter">Разделитель строк</param>
        /// <param name="eolDelimiter">Разделитель строк в файле</param>
        /// <param name="monopoly">Открывать файл монопольно</param>
        /// <returns>ЧтениеТекста</returns>
        public static ЧтениеТекста Новый(object input, string encoding = null,
                                               string lineDelimiter = null, string eolDelimiter = null, bool? monopoly = null)
        {
            var reader = new ЧтениеТекста();
            if (lineDelimiter != null)
                reader.AnalyzeDefaultLineFeed = false;

            if(IsStream(input, out var wrapper))
            {
                reader.OpenStream(wrapper, encoding,
                        lineDelimiter ?? "\n",
                        eolDelimiter);
            }
            else
            {
                reader.OpenFile((string)input, encoding,
                    lineDelimiter ?? "\n",
                    eolDelimiter,
                    monopoly ?? true);
            }

            return reader;
        }

        /// <summary>
        /// Создаёт неинициализированный объект. Для инициализации необходимо открыть файл методом Открыть.
        /// </summary>
        /// <returns>ЧтениеТекста</returns>
        public static ЧтениеТекста Constructor()
        {
            var reader = new ЧтениеТекста();
            reader.AnalyzeDefaultLineFeed = false;
            return reader;
        }

        private static bool IsStream(object input, out IStreamWrapper wrapper)
        {
            wrapper = null;
            if (input is Поток)
            {
                var obj = input;
                if (obj is IStreamWrapper wrap)
                {
                    wrapper = wrap;
                    return true;
                }
            }
            return false;
        }

        private CustomLineFeedStreamReader GetCustomLineFeedReader(TextReader imReader, string lineDelimiter,
            string eolDelimiter, bool AnalyzeDefaultLineFeed)
        {
            _lineDelimiter = lineDelimiter ?? "\n";
            if (eolDelimiter != null)
                return new CustomLineFeedStreamReader(imReader, eolDelimiter, AnalyzeDefaultLineFeed);
            else
                return new CustomLineFeedStreamReader(imReader, "\r\n", AnalyzeDefaultLineFeed);
        }


        #region IDisposable Members

        public void Dispose()
        {
            if (_reader != null)
            {
                _reader.Dispose();
                _reader = null;
            }
        }

        #endregion
    }
}
