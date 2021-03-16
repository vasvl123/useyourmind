/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System;
using System.IO;

namespace onesharp.Binary
{
    /// <summary>
    /// 
    /// Предоставляет методы для использования в типовых сценариях работы с файлами.
    /// </summary>
    public class МенеджерФайловыхПотоков
    {

        public static FileMode ConvertFileOpenModeToCLR(FileOpenModeEnum value)
        {
            switch (value)
            {
                case FileOpenModeEnum.Append:
                    return FileMode.Append;
                case FileOpenModeEnum.Create:
                    return FileMode.Create;
                case FileOpenModeEnum.CreateNew:
                    return FileMode.CreateNew;
                case FileOpenModeEnum.Open:
                    return FileMode.Open;
                case FileOpenModeEnum.OpenOrCreate:
                    return FileMode.OpenOrCreate;
                case FileOpenModeEnum.Truncate:
                    return FileMode.Truncate;

                default:
                    throw new ArgumentOutOfRangeException(nameof(value), value, null);
            }
        }

        public static FileAccess ConvertFileAccessToCLR(FileAccessEnum value)
        {
            switch (value)
            {
                case FileAccessEnum.Read:
                    return FileAccess.Read;
                case FileAccessEnum.Write:
                    return FileAccess.Write;
                default:
                    return FileAccess.ReadWrite;
            }
        }

        public МенеджерФайловыхПотоков()
        {
        }

        /// <summary>
        /// 
        /// Открывает файл в заданном режиме с возможностью чтения и записи. 
        /// Файл открывается в режиме разделяемого чтения.
        /// </summary>
        ///
        /// <param name="fileName">
        /// Имя открываемого файла. </param>
        /// <param name="openingMode">
        /// Режим открытия файла. </param>
        /// <param name="fileAccess">
        /// Режим доступа к файлу. </param>
        /// <param name="bufferSize">
        /// Размер буфера для операций с файлом. </param>
        ///
        /// <returns name="FileStream">
        /// Специализированная версия объекта Поток для работы данными, расположенными в файле на диске. Предоставляет возможность чтения из потока, записи в поток и изменения текущей позиции. 
        /// По умолчанию, все операции с файловым потоком являются буферизированными, размер буфера по умолчанию - 8 КБ.
        /// Размер буфера можно изменить, в том числе - полностью отключить буферизацию при вызове конструктора. 
        /// Следует учитывать, что помимо буферизации существует кэширование чтения и записи файлов в операционной системе, на которое невозможно повлиять программно.</returns>
        ///
        public ФайловыйПоток Открыть(string fileName, FileOpenModeEnum openingMode, FileAccessEnum fileAccess, object bufferSize = null)
        {
            if(bufferSize == null)
                return ФайловыйПоток.Constructor(fileName, openingMode, fileAccess);
            else
                return ФайловыйПоток.Constructor(fileName, openingMode, fileAccess, bufferSize);
        }


        /// <summary>
        /// 
        /// Открыть существующий файл для записи в конец. Если файл не существует, то будет создан новый файл. Запись в существующий файл выполняется с конца файла. Файл открывается в режиме разделяемого чтения.
        /// </summary>
        ///
        /// <param name="fileName">
        /// Имя открываемого файла. </param>
        /// 
        public ФайловыйПоток ОткрытьДляДописывания(string fileName)
        {
            return new ФайловыйПоток(fileName, FileOpenModeEnum.Append, FileAccessEnum.ReadAndWrite);
        }


        /// <summary>
        /// 
        /// Открывает существующий файл для записи. Файл открывается в режиме разделяемого чтения. Если файл не найден, будет создан новый файл. Запись в существующий файл производится с начала файла, замещая ранее сохраненные данные.
        /// </summary>
        ///
        /// <param name="fileName">
        /// Имя открываемого файла. </param>

        ///
        /// <returns name="FileStream">
        /// Специализированная версия объекта Поток для работы данными, расположенными в файле на диске. Предоставляет возможность чтения из потока, записи в поток и изменения текущей позиции. 
        /// По умолчанию, все операции с файловым потоком являются буферизированными, размер буфера по умолчанию - 8 КБ.
        /// Размер буфера можно изменить, в том числе - полностью отключить буферизацию при вызове конструктора. 
        /// Следует учитывать, что помимо буферизации существует кэширование чтения и записи файлов в операционной системе, на которое невозможно повлиять программно.</returns>

        ///
        public static ФайловыйПоток ОткрытьДляЗаписи(string fileName)
        {
            // TODO: Судя по описанию - открывается без обрезки (Truncate). Надо проверить в 1С.
            return new ФайловыйПоток(fileName, FileOpenModeEnum.OpenOrCreate, FileAccessEnum.Write);
        }


        /// <summary>
        /// 
        /// Открывает существующий файл для чтения с общим доступом на чтение.
        /// </summary>
        ///
        /// <param name="fileName">
        /// Имя открываемого файла. </param>
        ///
        /// <returns name="FileStream"/>
        ///
        public static ФайловыйПоток ОткрытьДляЧтения(string fileName)
        {
            return new ФайловыйПоток(fileName, FileOpenModeEnum.Open, FileAccessEnum.Read);
        }


        /// <summary>
        /// 
        /// Создает или перезаписывает файл и открывает поток с возможностью чтения и записи в файл. Файл открывается в режиме разделяемого чтения.
        /// </summary>
        ///
        /// <param name="fileName">
        /// Имя создаваемого файла. </param>
        /// <param name="bufferSize">
        /// Размер буфера. </param>
        ///
        /// <returns name="FileStream"/>
        public ФайловыйПоток Создать(string fileName, int bufferSize = 0)
        {
            return new ФайловыйПоток(fileName, new FileStream(fileName, FileMode.OpenOrCreate, FileAccess.ReadWrite, FileShare.Read, bufferSize == 0 ? 8192 : bufferSize));
        }


        /// <summary>
        /// НЕ РЕАЛИЗОВАН
        /// Создает временный файл и открывает его в монопольном режиме с возможностью чтения и записи. Дополнительно можно установить лимит в байтах, при превышении которого будет создан файл на диске. Пока размер файла не превышает данного лимита - вся работа ведётся в памяти.
        /// </summary>
        ///
        /// <param name="memoryLimit">
        /// Максимальный объем памяти (в байтах), при превышении которого будет создан файл на диске.
        /// Значение по умолчанию: 65535. </param>
        /// <param name="bufferSize">
        /// Размер буфера для операций с файлом (в байтах).
        /// Значение по умолчанию: 8192. </param>
        ///
        /// <returns name="FileStream"/>
        /// 
        public object СоздатьВременныйФайл(int memoryLimit = 0, int bufferSize = 0)
        {
            throw new NotImplementedException();
        }

    }
}
