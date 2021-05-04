using System;
using System.Dynamic;
using System.Globalization;
using System.Collections.Generic;
using System.Linq;

using onesharp.Binary;

namespace onesharp
{

    public class Onesharp
    {

        public Onesharp(string _ИмяМодуля)
        {
            МоментЗапуска = ТекущаяУниверсальнаяДатаВМиллисекундах();
            ИмяМодуля = _ИмяМодуля;
        }

        public static object Неопределено = null;
        public static bool Истина = true;
        public static bool Ложь = false;

        public decimal МоментЗапуска;
        public string[] АргументыКоманднойСтроки;
        public string ИмяМодуля;

        public int ПолучитьИД()
        {
            МоментЗапуска -= 1;
            return (int)Цел(ТекущаяУниверсальнаяДатаВМиллисекундах() - МоментЗапуска);
        }

        public static void ВызватьИсключение(string msg)
        {
            throw new SystemException(msg);
        }

        public static void Приостановить(int delay)
        {
            System.Threading.Thread.Sleep(delay);
        }

        public static object Цел(object n)
        {
            if (n is int) return n;
            var m = Math.Truncate((decimal)n);
            try {
                return Decimal.ToInt32(m);
            } catch {
                return m;
            }
        }

        public static decimal ТекущаяУниверсальнаяДатаВМиллисекундах()
        {
            return (decimal)DateTime.UtcNow.Ticks / TimeSpan.TicksPerMillisecond;
        }

        public static DateTime ТекущаяДата()
        {
            var date = DateTime.Now;
            date = date.AddTicks(-(date.Ticks % TimeSpan.TicksPerSecond));
            return date;
        }

        public static string Лев(string str, int len)
        {
            if (len > str.Length)
                len = str.Length;
            else if (len < 0)
            {
                return "";
            }

            return str.Substring(0, len);
        }

        public static string Прав(string str, int len)
        {
            if (len > str.Length)
                len = str.Length;
            else if (len < 0)
            {
                return "";
            }

            int startIdx = str.Length - len;
            return str.Substring(startIdx, len);
        }

        public static string Сред(string str, int start)
        {
            return Сред(str, start, str.Length - start + 1);
        }

        public static string Сред(string str, int start, int len)
        {
            if (start < 1)
                start = 1;

            if (start + len > str.Length || len < 0)
                len = str.Length - start + 1;

            string result;

            if (start > str.Length || len == 0)
            {
                result = "";
            }
            else
            {
                result = str.Substring(start - 1, len);
            }

            return result;
        }

        public static string ВРег(string arg)
        {
            return arg.ToUpper();
        }

        public static string НРег(string arg)
        {
            return arg.ToLower();
        }


        public static int КодСимвола(string strChar, int position = 0)
        {
            int result;
            if (strChar.Length == 0)
                result = 0;
            else if (position >= 0 && position < strChar.Length)
                result = (int)strChar[position];
            else
                throw RuntimeException.InvalidArgumentValue();

            return result;
        }

        public static string Символ(int code)
        {
            return new string(new char[1] { (char)code });
        }

        public static int Найти(string haystack, string needle)
        {
            return haystack.IndexOf(needle, StringComparison.Ordinal) + 1;
        }

        public static string СокрЛП(string str)
        {
            return str.Trim();
        }

        public static class Символы
        {

            public static string ПС
            {
                get
                {
                    return "\n";
                }
            }

            public static string ВК
            {
                get
                {
                    return "\r";
                }
            }

            public static string ВТаб
            {
                get
                {
                    return "\v";
                }
            }

            public static string Таб
            {
                get
                {
                    return "\t";
                }
            }

            public static string ПФ
            {
                get
                {
                    return "\f";
                }
            }

            public static string НПП
            {
                get
                {
                    return "\u00A0";
                }
            }

        }

        public void Сообщить(string message, СтатусСообщения status = СтатусСообщения.Обычное)
        {
            ConsoleHostImpl.Echo(message, status);
        }

        public void Сообщить(object message, СтатусСообщения status = СтатусСообщения.Обычное)
        {
            ConsoleHostImpl.Echo(message.ToString(), status);
        }

        public static object Parse(object obj, Type type)
        {

            string presentation = obj.ToString();
            object result;
            if (type == typeof(bool))
            {
                if (String.Compare(presentation, "истина", StringComparison.OrdinalIgnoreCase) == 0
                    || String.Compare(presentation, "true", StringComparison.OrdinalIgnoreCase) == 0
                    || String.Compare(presentation, "да", StringComparison.OrdinalIgnoreCase) == 0)
                    result = true;
                else if (String.Compare(presentation, "ложь", StringComparison.OrdinalIgnoreCase) == 0
                         || String.Compare(presentation, "false", StringComparison.OrdinalIgnoreCase) == 0
                         || String.Compare(presentation, "нет", StringComparison.OrdinalIgnoreCase) == 0)
                    result = false;
                else
                    throw RuntimeException.ConvertToBooleanException();
            }
            else if (type == typeof(DateTime))
            {
                string format;
                if (presentation.Length == 14)
                    format = "yyyyMMddHHmmss";
                else if (presentation.Length == 8)
                    format = "yyyyMMdd";
                else if (presentation.Length == 12)
                    format = "yyyyMMddHHmm";
                else
                    throw RuntimeException.ConvertToDateException();

                if (presentation == "00000000"
                 || presentation == "000000000000"
                 || presentation == "00000000000000")
                {
                    result = null;
                }
                else
                    try
                    {
                        result = DateTime.ParseExact(presentation, format, System.Globalization.CultureInfo.InvariantCulture);
                    }
                    catch (FormatException)
                    {
                        throw RuntimeException.ConvertToDateException();
                    }
            }
            else if (type == typeof(decimal))
            {
                var numInfo = NumberFormatInfo.InvariantInfo;
                var numStyle = NumberStyles.AllowDecimalPoint
                            | NumberStyles.AllowLeadingSign
                            | NumberStyles.AllowLeadingWhite
                            | NumberStyles.AllowTrailingWhite;

                try
                {
                    result = Decimal.Parse(presentation, numStyle, CultureInfo.CurrentCulture);
                }
                catch (FormatException)
                {
                    throw RuntimeException.ConvertToNumberException();
                }
            }
            else if (type == typeof(string))
            {
                result = presentation;
            }
            else throw new NotSupportedException("constant type is not supported");

            return result;
        }


        public static object Число(object arg)
        {
            var n = (decimal)Parse(arg, typeof(decimal));
            var m = Цел(n);
            if (m is int) if ((int)m == n) return m;
            return n;
        }

        public static string Строка(object arg)
        {
            if (arg is null) return "";
            return (string)Parse(arg, typeof(string));
        }

        public static string ТипЗнч(object arg)
        {
            if (arg is int || arg is long || arg is ulong || arg is decimal) return "Число";
            if (arg is string) return "Строка";
            if (arg is bool) return "Булево";
            if (arg is DateTime) return "Дата";
            return "";
        }

        public static string Тип(string arg)
        {
            return arg;
        }

        public string ОписаниеОшибки(Exception e) { return ИмяМодуля + " ошибка!\n" + e.InnerException + "\n" + e.Message + "\n" + e.StackTrace; }


        public string ТекущийКаталог()
        {
            return ФайловыеОперации.ТекущийКаталог();
        }

        public string ОбъединитьПути(string path1, string path2, string path3 = null, string path4 = null)
        {
            return ФайловыеОперации.ОбъединитьПути(path1, path2, path3, path4);
        }

        public void СоздатьКаталог(string path)
        {
            ФайловыеОперации.СоздатьКаталог(path);
        }

        public Массив НайтиФайлы(string dir, string mask = null, bool recursive = false)
        {
            return ФайловыеОперации.НайтиФайлы(dir, mask, recursive);
        }

        public ДвоичныеДанные СоединитьДвоичныеДанные(Массив arg)
        {
            return GlobalBinaryData.СоединитьДвоичныеДанные(arg);
        }

        public ДвоичныеДанные ПолучитьДвоичныеДанныеИзСтроки(string arg, string enc)
        {
            return GlobalBinaryData.ПолучитьДвоичныеДанныеИзСтроки(arg, enc);
        }

        public ДвоичныеДанные ПолучитьДвоичныеДанныеИзСтроки(string arg)
        {
            return GlobalBinaryData.ПолучитьДвоичныеДанныеИзСтроки(arg);
        }

        public ДвоичныеДанные ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(БуферДвоичныхДанных arg)
        {
            return GlobalBinaryData.ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(arg);
        }

        public БуферДвоичныхДанных ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(ДвоичныеДанные arg)
        {
            return GlobalBinaryData.ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(arg);
        }

        public string ПолучитьСтрокуИзДвоичныхДанных(ДвоичныеДанные arg)
        {
            return GlobalBinaryData.ПолучитьСтрокуИзДвоичныхДанных(arg);
        }
        public ДвоичныеДанные ПолучитьДвоичныеДанныеИзBase64Строки(string arg)
        {
            return GlobalBinaryData.ПолучитьДвоичныеДанныеИзBase64Строки(arg);
        }

        public string ПолучитьBase64СтрокуИзДвоичныхДанных(ДвоичныеДанные data)
        {
            return GlobalBinaryData.ПолучитьBase64СтрокуИзДвоичныхДанных(data);
        }

        public string РаскодироватьСтроку(string encodedString, СпособКодированияСтроки codeType, string encoding = null)
        {
            return ПрочиеФункции.РаскодироватьСтроку(encodedString, codeType, encoding);
        }

        public string КодироватьСтроку(string sourceString, СпособКодированияСтроки codeType, string encoding = null)
        {
            return ПрочиеФункции.КодироватьСтроку(sourceString, codeType, encoding);
        }

        public void ОсвободитьОбъект(object obj)
        {
            var disposable = obj as IDisposable;
            if (disposable != null)
            {
                disposable.Dispose();
            }
        }

        public void ЗапуститьПриложение(string cmdLine, string currentDir = null, bool wait = false, object retCode = null)
        {

            var sInfo = Процесс.PrepareProcessStartupInfo(cmdLine, currentDir);

            var p = new System.Diagnostics.Process();
            p.StartInfo = sInfo;
                p.Start();

                if(wait)
                {
                    p.WaitForExit();
                    if(retCode != null)
                        retCode = p.ExitCode;
                }
        }

        /// <summary>
        /// Проверяет заполненность значения по принципу, заложенному в 1С:Предприятии
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool ЗначениеЗаполнено(object value)
        {
            if (value == null)
            {
                return false;
            }
            if (value is bool)
                return true;
            else if (value is string)
                return !String.IsNullOrWhiteSpace(value as string);
            else if (value is decimal)
                return (decimal)value != 0;
            else if (value is int)
                return (int)value != 0;
            else if (value is DateTime)
            {
                var emptyDate = new DateTime(1, 1, 1, 0, 0, 0);
                return (DateTime)value != emptyDate;
            }
            else if (value is IEnumerable<object>)
            {
                var col = value as IEnumerable<object>;
                return col.Count() != 0;
            }
            else
                return true;

        }

        public static bool ПустаяСтрока(string str)
        {
            return String.IsNullOrWhiteSpace(str);
        }

        public static string Формат(object valueToFormat, string formatString)
        {
            return ValueFormatter.Format(valueToFormat, formatString);
        }

        public static DateTime Дата(object arg1, params int[] factArgs)
        {
            if (factArgs.Count() == 1)
            {
                return (DateTime)Parse((string)arg1, typeof(DateTime));
            }
            else if (factArgs.Count() >= 3 && factArgs.Count() <= 6)
            {
                var date = new DateTime(
                                factArgs[0],
                                factArgs[1],
                                factArgs[2],
                                factArgs[3],
                                factArgs[4],
                                factArgs[5]);

                return date;

            }
            else
            {
                throw new RuntimeException("Неверное количество параметров");
            }

        }


    }
}
