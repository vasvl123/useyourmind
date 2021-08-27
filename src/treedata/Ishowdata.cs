using System;

namespace onesharp
{
    public interface Ishowdata
    {
        string get_procid();
        string ПолучитьСубъект();
        void ЗаписатьСобытие(string стрЗаголовок, string стрСообщение, int ТипСобытия = 0, string ПараметрКоманда = "");
        int ПолучитьИД();
        object ПолучитьБиблиотеку(string ИмяБиблиотеки, string Версия = "");
        Структура НоваяЗадача(Структура Запрос, string Тип = "Запрос", object ЗадачаВладелец = null);
        object ПередатьДанныеД(Структура стрДанные);
    }
}
