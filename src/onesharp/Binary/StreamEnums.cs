/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

namespace onesharp
{
    //[EnumerationType("РежимОткрытияФайла", "FileOpenMode")]
    public enum FileOpenModeEnum
    {
        //[EnumItem("Дописать")]
        Append,
        //[EnumItem("Обрезать")]
        Truncate,
        //[EnumItem("Открыть")]
        Open,
        //[EnumItem("ОткрытьИлиСоздать")]
        OpenOrCreate,
        //[EnumItem("Создать")]
        Create,
        //[EnumItem("СоздатьНовый")]
        CreateNew
    }

    //[EnumerationType("ДоступКФайлу", "FileAccess")]
    public enum FileAccessEnum
    {
        //[EnumItem("Запись")]
        Write,
        //[EnumItem("Чтение")]
        Read,
        //[EnumItem("ЧтениеИЗапись")]
        ReadAndWrite
    }

    //[EnumerationType("ПозицияВПотоке", "StreamPosition")]
    public enum ПозицияВПотоке
    {
        //[EnumItem("Начало")]
        Начало,
        //[EnumItem("Конец")]
        Конец,
        //[EnumItem("Текущая")]
        Текущая
    }

    //[EnumerationType("ПорядокБайтов", "ByteOrder")]
    public enum ByteOrderEnum
    {
        //[EnumItem("BigEndian")]
        BigEndian,
        //[EnumItem("LittleEndian")]
        LittleEndian
    }
}
