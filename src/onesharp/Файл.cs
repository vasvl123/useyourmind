/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.IO;

namespace onesharp
{
    public class Файл
    {
        private readonly string _givenName;
        private string _name;
        private string _baseName;
        private string _fullName;
        private string _path;
        private string _extension;

        public Файл(string name)
        {
            if (String.IsNullOrWhiteSpace(name))
            {
                _name = "";
                _baseName = "";
                _fullName = "";
                _path = "";
                _extension = "";
            }
            
            _givenName = name;
        }
        
        private string LazyField(ref string value, Func<string, string> algo)
        {
            if (value == null)
                value = algo(_givenName);

            return value;
        }

        public string Имя
        {
            get
            {
                return LazyField(ref _name, GetFileNameV8Compatible);
            }
        }

        private string GetFileNameV8Compatible(string arg)
        {
            return System.IO.Path.GetFileName(arg.TrimEnd(System.IO.Path.DirectorySeparatorChar, System.IO.Path.AltDirectorySeparatorChar));
        }

        public string ИмяБезРасширения
        {
            get
            {
                return LazyField(ref _baseName, System.IO.Path.GetFileNameWithoutExtension);
            }
        }

        public string ПолноеИмя
        {
            get
            {
                return LazyField(ref _fullName, System.IO.Path.GetFullPath);
            }
        }

        public string Путь
        {
            get
            {
                return LazyField(ref _path, GetPathWithEndingDelimiter);
            }
        }

        private string GetPathWithEndingDelimiter(string src)
        {
            src = src.Trim ();
            if (src.Length == 1 && src[0] == System.IO.Path.DirectorySeparatorChar)
                return src; // корневой каталог

            var path = System.IO.Path.GetDirectoryName(src.TrimEnd(System.IO.Path.DirectorySeparatorChar, System.IO.Path.AltDirectorySeparatorChar));
            if (path == null)
                return src; // корневой каталог
            
            if (path.Length > 0 && path[path.Length - 1] != System.IO.Path.DirectorySeparatorChar)
                path += System.IO.Path.DirectorySeparatorChar;

            return path;
        }

        public string Расширение
        {
            get
            {
                return LazyField(ref _extension, System.IO.Path.GetExtension);
            }
        }

        public bool Существует()
        {
            if (_givenName == String.Empty)
                return false;

            try
            {
                File.GetAttributes(ПолноеИмя);
                return true;
            }
            catch (FileNotFoundException) { }
            catch (DirectoryNotFoundException) { }
            catch (ArgumentException) { }
            catch (NotSupportedException) { }
            catch (PathTooLongException) { }
            catch (UnauthorizedAccessException) { }
            catch (IOException) { }

            return false;
        }

        public long Размер()
        {
            return new FileInfo(ПолноеИмя).Length;
        }

        public bool ПолучитьНевидимость()
        {
            var attr = File.GetAttributes(ПолноеИмя);
            return attr.HasFlag(System.IO.FileAttributes.Hidden);
        }

        public bool ПолучитьТолькоЧтение()
        {
            var attr = File.GetAttributes(ПолноеИмя);
            return attr.HasFlag(System.IO.FileAttributes.ReadOnly);
        }

        public DateTime ПолучитьВремяИзменения()
        {
            return File.GetLastWriteTime(ПолноеИмя);
        }

        public DateTime ПолучитьВремяСоздания()
        {
            return File.GetCreationTime(ПолноеИмя);
        }

        public void УстановитьНевидимость(bool value)
        {
            FileSystemInfo entry = new FileInfo(ПолноеИмя);

            if(value)
                entry.Attributes |= System.IO.FileAttributes.Hidden;
            else
                entry.Attributes &= ~System.IO.FileAttributes.Hidden;
        }

        public void УстановитьТолькоЧтение(bool value)
        {
            FileSystemInfo entry = new FileInfo(ПолноеИмя);
            if (value)
                entry.Attributes |= System.IO.FileAttributes.ReadOnly;
            else
                entry.Attributes &= ~System.IO.FileAttributes.ReadOnly;
        }

        public void УстановитьВремяИзменения(DateTime dateTime)
        {
            FileSystemInfo entry = new FileInfo(ПолноеИмя);
            entry.LastWriteTime = dateTime;
        }

        public bool ЭтоКаталог()
        {
            var attr = File.GetAttributes(ПолноеИмя);
            return attr.HasFlag(FileAttributes.Directory);
        }

        public bool ЭтоФайл()
        {
            var attr = File.GetAttributes(ПолноеИмя);
            return !attr.HasFlag(FileAttributes.Directory);
        }

        public FileAttributes GetAttributes()
        {
            return File.GetAttributes(ПолноеИмя);
        }

        public static Файл Новый(string name)
        {
            return new Файл(name);
        }
    }
}
