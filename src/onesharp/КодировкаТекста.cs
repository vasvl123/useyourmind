/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System.Text;

namespace onesharp
{
    public static class КодировкаТекста
    {

        public static Encoding GetEncodingByName(string encoding, bool addBOM = true)
        {
            Encoding enc;
            if (encoding == null)
                enc = new UTF8Encoding(addBOM);
            else
            {
                switch (encoding.ToUpper())
                {
                    case "ANSI":
                        enc = Encoding.GetEncoding("windows-1251");
                        break;
                    case "UTF-8":
                        enc = new UTF8Encoding(addBOM);
                        break;
                    case "UTF-16":
                    case "UTF-16LE":
                    // предположительно, варианты UTF16_PlatformEndian\UTF16_OppositeEndian
                    // зависят от платформы x86\m68k\SPARC. Пока нет понимания как корректно это обработать.
                    // Сейчас сделано исходя из предположения что PlatformEndian должен быть LE поскольку 
                    // платформа x86 более широко распространена
                    case "UTF16_PLATFORMENDIAN":
                        enc = new UnicodeEncoding(false, addBOM);
                        break;
                    case "UTF-16BE":
                    case "UTF16_OPPOSITEENDIAN":
                        enc = new UnicodeEncoding(true, addBOM);
                        break;
                    case "UTF-32":
                    case "UTF-32LE":
                    case "UTF32_PLATFORMENDIAN":
                        enc = new UTF32Encoding(false, addBOM);
                        break;
                    case "UTF-32BE":
                    case "UTF32_OPPOSITEENDIAN":
                        enc = new UTF32Encoding(true, addBOM);
                        break;
                    default:
                        enc = Encoding.GetEncoding(encoding);
                        break;

                }
            }

            return enc;
        }

        public static Encoding GetEncoding(string encoding, bool addBOM = true)
        {
            return GetEncodingByName(encoding, addBOM);
        }
    }
}
