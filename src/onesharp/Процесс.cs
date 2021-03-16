/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Diagnostics;
using System.Linq;

namespace onesharp
{
    /// <summary>
    /// Позволяет управлять процессом операционной системы. Получать текст из стандартных потоков,
    /// проверять активность, pid, завершать процесс и т.п.
    /// </summary>
    public class Процесс : IDisposable
    {
        private readonly System.Diagnostics.Process _p;
        //private StdTextReadStream _stdOutContext;
        //private StdTextReadStream _stdErrContext;
        //private StdTextWriteStream _stdInContext;

        private readonly string _outputEncoding;

        private Процесс(System.Diagnostics.Process p, string encoding)
        {
            _p = p;
            _outputEncoding = encoding;
        }

        public Процесс(System.Diagnostics.Process p):this(p, null)
        {
        }

        private bool IsOutputRedirected => _p.StartInfo.RedirectStandardOutput && _p.StartInfo.RedirectStandardError;

        /// <summary>
        /// Устанавливает кодировку в которой будут считываться стандартные потоки вывода и ошибок.
        /// </summary>
        public string КодировкаВывода
        {
            get
            {
                return _outputEncoding;
            }
        }

        /// <summary>
        /// ПотокВыводаТекста. Стандартный поток вывода (stdout)
        ///     в методе "Завершен" смотрите пример правильной обработки цикла ожидания завершения процесса:
        /// </summary>
        //[ContextProperty("ПотокВывода", "StdOut")]
        //public StdTextReadStream StdOut
        //{
        //    get
        //    {
        //        return _stdOutContext;
        //    }
        //}

        /// <summary>
        /// ПотокВыводаТекста. Стандартный поток вывода ошибок (stderr)
        ///     в методе "Завершен" смотрите пример правильной обработки цикла ожидания завершения процесса:
        /// </summary>
        //[ContextProperty("ПотокОшибок", "StdErr")]
        //public StdTextReadStream StdErr
        //{
        //    get
        //    {
        //        return _stdErrContext;
        //    }
        //}

        /// <summary>
        /// ПотокВводаТекста. Стандартный поток ввода (stdin)
        /// </summary>
        //[ContextProperty("ПотокВвода", "StdIn")]
        //public StdTextWriteStream StdIn
        //{
        //    get
        //    {
        //        if (_stdInContext == null)
        //            _stdInContext = new StdTextWriteStream(_p.StandardInput);
        //        return _stdInContext;
        //    }
        //}

        /// <summary>
        /// Запустить процесс на выполнение.
        ///     в методе "Завершен" смотрите пример правильной обработки цикла ожидания завершения процесса:
        /// </summary>
        public void Запустить()
        {
            _p.Start();

            //if (IsOutputRedirected)
            //{
            //    var stream = new ProcessOutputWrapper(_p, ProcessOutputWrapper.OutputVariant.Stdout);
            //    stream.StartReading();
            //    _stdOutContext = new StdTextReadStream(stream);

            //    stream = new ProcessOutputWrapper(_p, ProcessOutputWrapper.OutputVariant.Stderr);
            //    stream.StartReading();

            //    //_stdErrContext = new StdTextReadStream(stream);

            //}
        }

        /// <summary>
        /// Флаг указывает, что процесс завершен (или нет)
        /// </summary>
        ///
        /// <example>
        /// // Пример правильной обработки цикла ожидания завершения процесса:
        /// // Процесс не завершается, пока любой из потоков (stdout, stderr) открыт для чтения.
        /// // Процесс висит и ждет, пока его освободят от текста в обоих потоках.
        ///
        /// Пока НЕ Процесс.Завершен ИЛИ Процесс.ПотокВывода.ЕстьДанные ИЛИ Процесс.ПотокОшибок.ЕстьДанные Цикл
        ///     Если ПериодОпросаВМиллисекундах &lt;&gt; 0 Тогда
        ///         Приостановить(ПериодОпросаВМиллисекундах);
        ///     КонецЕсли;
        /// 
        ///     ОчереднаяСтрокаВывода = Процесс.ПотокВывода.Прочитать();
        ///     ОчереднаяСтрокаОшибок = Процесс.ПотокОшибок.Прочитать();
        ///     Если Не ПустаяСтрока(ОчереднаяСтрокаВывода) Тогда
        ///         Сообщить(ОчереднаяСтрокаВывода, СтатусСообщения.Информация);
        ///     КонецЕсли;
        /// 
        ///     Если Не ПустаяСтрока(ОчереднаяСтрокаОшибок) Тогда
        ///         Сообщить(ОчереднаяСтрокаОшибок, СтатусСообщения.Важное);
        ///     КонецЕсли;
        /// КонецЦикла;        
        /// </example>
        public bool Завершен
        {
            get
            {
                return _p.HasExited;
            }
        }

        /// <summary>
        /// Код возврата завершенного процесса.
        /// </summary>
        public int КодВозврата
        {
            get
            {
                return _p.ExitCode;
            }
        }
        
        /// <summary>
        /// Приостановить выполнение скрипта и ожидать завершения процесса.
        /// </summary>
        /// <param name="timeout">Число. Таймаут в миллисекундах.</param>
        /// <returns>Булево. Ложь, если таймаут истек.</returns>
        public bool ОжидатьЗавершения(int timeout = 0)
        {
            if (timeout == 0)
            {
                _p.WaitForExit();
                return true;
            }

            return _p.WaitForExit(timeout);
        }

        /// <summary>
        /// PID процесса
        /// </summary>
        public int Идентификатор
        {
            get
            {
                return _p.Id;
            }
        }

        public void Завершить()
        {
            _p.Kill();
        }

        public void Dispose()
        {
            //if(_stdOutContext != null)
            //{
            //    _stdOutContext.Dispose();
            //    _stdOutContext = null;
            //}

            //if (_stdErrContext != null)
            //{
            //    _stdErrContext.Dispose();
            //    _stdErrContext = null;
            //}

            //if(_stdInContext != null)
            //{
            //    _stdInContext.Dispose();
            //    _stdInContext = null;
            //}

            _p.Dispose();
        }

        public static Процесс Новый(string cmdLine, string currentDir = null, bool redirectOutput = false, bool redirectInput = false, string encoding = null, Соответствие env = null)
        {
            var sInfo = PrepareProcessStartupInfo(cmdLine, currentDir);
            sInfo.UseShellExecute = false;
            if (redirectInput)
                sInfo.RedirectStandardInput = true;

            if (redirectOutput)
            {
                sInfo.RedirectStandardOutput = true;
                sInfo.RedirectStandardError = true;
            }

            if (encoding != null)
            {
                var enc = КодировкаТекста.GetEncoding(encoding);

                sInfo.StandardOutputEncoding = enc;
                sInfo.StandardErrorEncoding = enc;
            }

            //if (env != null)
            //{
            //    var source = env.Select(x => new
            //    {
            //        Key = x.Key.AsString(),
            //        Value = x.Value.AsString()
            //    }).Where(x => !string.IsNullOrWhiteSpace(x.Key));
                
            //    foreach (var kv in source)
            //    {
            //        sInfo.EnvironmentVariables[kv.Key] = kv.Value;
            //    }
            //}

            var p = new System.Diagnostics.Process();
            p.StartInfo = sInfo;

            return new Процесс(p, encoding);
        }

        public static ProcessStartInfo PrepareProcessStartupInfo(string cmdLine, string currentDir)
        {
            var sInfo = new ProcessStartInfo();

            int argsPosition;
            sInfo.FileName = ExtractExecutableName(cmdLine, out argsPosition);
            sInfo.Arguments = argsPosition >= cmdLine.Length ? "" : cmdLine.Substring(argsPosition);
            if (currentDir != null)
                sInfo.WorkingDirectory = currentDir;
            return sInfo;
        }

        private static string ExtractExecutableName(string cmdLine, out int argsPosition)
        {
            bool inQuotes = false;
            int startIdx = 0;
            int i;
            for (i = 0; i < cmdLine.Length; i++)
            {
                var symb = cmdLine[i];
                
                if (symb == '\"')
                {
                    if (inQuotes)
                    {
                        argsPosition = i + 1;
                        return cmdLine.Substring(startIdx, i - startIdx);
                    }
                    
                    inQuotes = true;
                    startIdx = i + 1;
                    
                }
                else if (symb == ' ' && !inQuotes)
                {
                    argsPosition = i + 1;
                    return cmdLine.Substring(startIdx, i - startIdx);
                }

            }

            if (inQuotes)
                throw RuntimeException.InvalidArgumentValue();

            argsPosition = i + 1;
            return cmdLine.Substring(startIdx, i - startIdx);
        }

    }
}
