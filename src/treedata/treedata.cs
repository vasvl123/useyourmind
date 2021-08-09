// /*----------------------------------------------------------
// This Source Code Form is subject to the terms of the
// Mozilla Public License, v.2.0. If a copy of the MPL
// was not distributed with this file, You can obtain one
// at http://mozilla.org/MPL/2.0/.
// ----------------------------------------------------------*/
// Идея интерпретатора https://github.com/tsukanov-as/kojura

using System;


namespace onesharp
{
    public class treedata : pagedata
    {

        treedb Данные;

        public void СохранитьДанные(Узел элУзел = null)
        {
            if (элУзел == Неопределено) элУзел = Корень;
            if (!(Служебный(элУзел)))
            {

            }
        } // СохранитьДанные()

        public treedata(Ishowdata обПроцесс, string Текст = "", string знБазаДанных = "", string знИмяДанных = "", string знПозицияДанных = "") : base(обПроцесс)
        {
            Данные = new treedb(ИмяДанных + ".tdb");

        }

    }
}
