// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/

namespace parse
{

    class MainClass
    {

        public static void Main(string[] args)
        {
            var app = new parse();
            app.АргументыКоманднойСтроки = args;
            app.parse_ruez();
        }
    }
}
