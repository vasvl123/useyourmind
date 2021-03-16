/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System;
using System.Text;

using onesharp.Binary;

namespace onesharp
{
    public enum СпособКодированияСтроки
    {
        КодировкаURL,
        URLВКодировкеURL
    }

    public static class ПрочиеФункции
    {
        public static string Base64Строка(ДвоичныеДанные data)
        {
            return Convert.ToBase64String(data.Buffer);
        }

        public static ДвоичныеДанные Base64Значение(string data)
        {
            byte[] bytes = Convert.FromBase64String(data);
            return new ДвоичныеДанные(bytes);
        }

        /// <summary>
        /// Кодирует строку для передачи в URL (urlencode)
        /// </summary>
        /// <param name="sourceString"></param>
        /// <param name="codeType"></param>
        /// <param name="encoding"></param>
        public static string КодироватьСтроку(string sourceString, СпособКодированияСтроки codeType, string encoding = null)
        {
            Encoding enc;
            if (encoding != null)
                enc = КодировкаТекста.GetEncoding(encoding);
            else
                enc = Encoding.UTF8;

            if (codeType == СпособКодированияСтроки.КодировкаURL)
                return EncodeStringImpl(sourceString, enc, false);
            else
                return EncodeStringImpl(sourceString, enc, true);
        }

        // http://en.wikipedia.org/wiki/Percent-encoding
        private static string EncodeStringImpl(string sourceString, Encoding enc, bool skipUrlSymbols)
        {
            var bytes = enc.GetBytes(sourceString);
            var builder = new StringBuilder(bytes.Length * 2);
            for (int i = 0; i < bytes.Length; i++)
            {
                byte current = bytes[i];
                if (IsUnreservedSymbol(current))
                    builder.Append((char)current);
                else
                {
                    if(skipUrlSymbols && IsUriSpecialChar(current))
                    {
                        builder.Append((char)current);
                    }
                    else
                    {
                        builder.AppendFormat("%{0:X2}", (int)current);
                    }
                }
            }

            return builder.ToString();
        }

        private static bool IsUriSpecialChar(byte symbolByte)
        {
            switch(symbolByte)
            {
                case 47: // /
                case 37: // %
                case 63: // ?
                case 43: // +
                case 61: // =
                case 33: // !
                case 35: // #
                case 36: // $
                case 39: // '
                case 40: // (
                case 41: // )
                case 42: // *
                case 44: // ,
                case 58: // :
                case 59: // ;
                case 64: // @
                case 91: // [
                case 93: // ]
                    return true;
                default:
                    return false;
            }
        }

        private static bool IsUnreservedSymbol(byte symbolByte)
        {
            if (symbolByte >= 65 && symbolByte <= 90 // A-Z
                || symbolByte >= 97 && symbolByte <= 122 // a-z
                || symbolByte >= 48 && symbolByte <= 57 // 0-9
                || symbolByte == 45 // -
                || symbolByte == 46 // .
                || symbolByte == 95 // _
                || symbolByte == 126 // ~
                )
                return true;
            else
                return false;
        }

        /// <summary>
        /// Раскодирует строку из URL формата.
        /// </summary>
        /// <param name="encodedString"></param>
        /// <param name="codeType"></param>
        /// <param name="encoding"></param>
        /// <returns></returns>
        public static string РаскодироватьСтроку(string encodedString, СпособКодированияСтроки codeType, string encoding = null)
        {
            if (encoding != null)
                throw new NotSupportedException("Явное указание кодировки в данной версии не поддерживается (только utf-8 согласно RFC 3986)");

            return Uri.UnescapeDataString(encodedString);
        }

    }

}
