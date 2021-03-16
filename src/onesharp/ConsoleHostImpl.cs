/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System;


namespace onesharp
{

    public enum СтатусСообщения
    {
        БезСтатуса,
        Важное,
        Внимание,
        Информация,
        Обычное,
        ОченьВажное
    }


    static class ConsoleHostImpl
    {
        public static void Echo(string text, СтатусСообщения status = СтатусСообщения.Обычное)
        {
            if (status == СтатусСообщения.Обычное)
                Output.WriteLine(text);
            else
            {
                ConsoleColor oldColor = Output.TextColor;
                ConsoleColor newColor;

                switch (status)
                {
                    case СтатусСообщения.Информация:
                        newColor = ConsoleColor.Green;
                        break;
                    case СтатусСообщения.Внимание:
                        newColor = ConsoleColor.Yellow;
                        break;
                    case СтатусСообщения.Важное:
                    case СтатусСообщения.ОченьВажное:
                        newColor = ConsoleColor.Red;
                        break;
                    default:
                        newColor = oldColor;
                        break;
                }

                try
                {
                    Output.TextColor = newColor;
                    Output.WriteLine(text);
                }
                finally
                {
                    Output.TextColor = oldColor;
                }
            }
        }

        public static void ShowExceptionInfo(Exception exc)
        {
            Echo(exc.Message);
        }

        public static bool InputString(out string result, int maxLen)
        {
            if (maxLen == 0)
            {
                result = Console.ReadLine();
            }
            else
            {
                result = Console.ReadLine().Substring(0, maxLen);
            }

            return result.Length > 0;

        }
    }
}
