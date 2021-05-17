/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System.Collections;


namespace onesharp
{
    /// <summary>
    /// Класс предоставляет информацию о системе
    /// </summary>
    public class СистемнаяИнформация
    {
        /// <summary>
        /// Имя машины, на которой выполняется сценарий
        /// </summary>
        public string ИмяКомпьютера 
        {
            get
            {
                return System.Environment.MachineName;
            }
        }

        /// <summary>
        /// Версия операционной системы, на которой выполняется сценарий
        /// </summary>
        public string ВерсияОС
        {
            get
            {
                return System.Environment.OSVersion.VersionString;
            }
        }

        /// <summary>
        /// Версия OneScript, выполняющая данный сценарий
        /// </summary>
        public string Версия 
        { 
            get
            {
                return System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString();
            }
        }

        /// <summary>
        /// Имя пользователя ОС с учетом домена
        /// Формат строки: \\ИмяДомена\ИмяПользователя. 
        /// </summary>
        public string ПользовательОС
        {
            get
            {
                string DomainName = System.Environment.UserDomainName;

                if (DomainName != "")
                {
                    return @"\\" + DomainName + @"\" + System.Environment.UserName;
                }

                return System.Environment.UserName;
            }
        }

        /// <summary>
        /// Определяет, является ли текущая операционная система 64-разрядной.
        /// </summary>
        public bool Это64БитнаяОперационнаяСистема
        {
            get { return System.Environment.Is64BitOperatingSystem; }
        }

        /// <summary>
        /// Возвращает число процессоров.
        /// 32-битовое целое число со знаком, которое возвращает количество процессоров на текущем компьютере. 
        /// Значение по умолчанию отсутствует. Если текущий компьютер содержит несколько групп процессоров, 
        /// данное свойство возвращает число логических процессоров, доступных для использования средой CLR
        /// </summary>
        public int КоличествоПроцессоров
        {
            get { return System.Environment.ProcessorCount; }
        }

        /// <summary>
        /// Возвращает количество байтов на странице памяти операционной системы
        /// </summary>
        public int РазмерСистемнойСтраницы
        {
            get { return System.Environment.SystemPageSize; }
        }

        /// <summary>
        /// Возвращает время, истекшее с момента загрузки системы (в миллисекундах).
        /// </summary>
        public long ВремяРаботыСМоментаЗагрузки
        {
            get
            {
                var unsig = (uint)System.Environment.TickCount;
                return unsig;
            }
        }

        /// <summary>
        /// Возвращает путь для специальной папки. Поддерживаемые значения:
        /// 
        /// * МоиДокументы / MyDocuments            
        /// * ДанныеПриложений / ApplicationData
        /// * ЛокальныйКаталогДанныхПриложений / LocalApplicationData            
        /// * РабочийСтол / Desktop
        /// * КаталогРабочийСтол / DesktopDirectory
        /// * МояМузыка / MyMusic
        /// * МоиРисунки / MyPictures
        /// * Шаблоны / Templates
        /// * МоиВидеозаписи / MyVideos
        /// * ОбщиеШаблоны / CommonTemplates
        /// * ПрофильПользователя / UserProfile
        /// * ОбщийКаталогДанныхПриложения / CommonApplicationData
        /// </summary>
        /// <param name="folder">Тип: СпециальнаяПапка</param>
        /// <returns>Строка</returns>
        public string ПолучитьПутьПапки(System.Environment.SpecialFolder folder)
        {
            return System.Environment.GetFolderPath(folder);
        }

        /// <summary>
        /// Возвращает массив строк, содержащий имена логических дисков текущего компьютера.
        /// </summary>
        public Массив ИменаЛогическихДисков
        {
            get
            {
                var arr = new Массив();
                var data = System.Environment.GetLogicalDrives();
                foreach (var itm in data)
                {
                    arr.Добавить(itm);
                }
                return arr;
            }
        }


        /// <summary>
        /// Возвращает соответствие переменных среды. Ключом является имя переменной, а значением - значение переменной
        /// </summary>
        /// <example>
        /// СИ = Новый СистемнаяИнформация();
        /// Для Каждого Переменная Из СИ.ПеременныеСреды() Цикл
        ///     Сообщить(Переменная.Ключ + " = " + Переменная.Значение);
        /// КонецЦикла;
        /// </example>
        /// <returns>Соответствие</returns>
        public Соответствие ПеременныеСреды()
        {
            //SystemLogger.Write("WARNING! Deprecated method: 'SystemInfo.EnvironmentVariables' is deprecated, use 'EnvironmentVariables' from global context");
            var varsMap = new Соответствие();
            var allVars = System.Environment.GetEnvironmentVariables();
            foreach (DictionaryEntry item in allVars)
            {
                varsMap.Вставить(
                    (string)item.Key,
                    (string)item.Value);
            }

            return varsMap;
        }
        
        /// <summary>
        /// Позволяет установить переменную среды. 
        /// Переменная устанавливается в области видимости процесса и очищается после его завершения.
        /// </summary>
        /// <param name="varName">Имя переменной</param>
        /// <param name="value">Значение переменной</param>
        public void УстановитьПеременнуюСреды(string varName, string value)
        {
            //SystemLogger.Write(string.Format(Locale.NStr("en='{0}';ru='{1}'"),
                //"WARNING! Deprecated method: \"SystemInfo.SetEnvironmentVariable\" is deprecated, use \"SetEnvironmentVariable\" from global context",
                //"Предупреждение! Устаревший метод: \"СистемнаяИнформация.УстановитьПеременнуюСреды\" устарел, используйте метод глобального контекста \"УстановитьПеременнуюСреды\""));
            System.Environment.SetEnvironmentVariable(varName, value);
        }

        /// <summary>
        /// Получить значение переменной среды.
        /// </summary>
        /// <param name="varName">Имя переменной</param>
        /// <returns>Строка. Значение переменной</returns>
        public string ПолучитьПеременнуюСреды(string varName)
        {
            //SystemLogger.Write(string.Format(Locale.NStr("en='{0}';ru='{1}'"),
               //"WARNING! Deprecated method: \"SystemInfo.GetEnvironmentVariable\" is deprecated, use \"GetEnvironmentVariable\" from global context",
                //"Предупреждение! Устаревший метод: \"СистемнаяИнформация.ПолучитьПеременнуюСреды\" устарел, используйте метод глобального контекста \"ПолучитьПеременнуюСреды\""));
            string value = System.Environment.GetEnvironmentVariable(varName);
            return value;
        }

        public static СистемнаяИнформация Новый()
        {
            return new СистемнаяИнформация();
        }
    }
}
