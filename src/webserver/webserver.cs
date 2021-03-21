﻿using System;

using onesharp.Binary;

namespace onesharp
{
    class webserver : Onesharp
    {

        public webserver() : base("webserver") { }

        functions Функции = new functions();

        int Порт;
        bool ОстановитьСервер;
        Соответствие СтатусыHTTP;
        Соответствие СоответствиеРасширенийТипамMIME;
        Соответствие Задачи;
        Массив мЗадачи;
        //Перем Ресурсы;
        Соответствие Контроллеры;
        string Загрузка = " ";
        Структура Параметры;
        Массив Сообщения;
        Массив Соединения;
        Массив СоединенияО;


        string УдаленныйУзелАдрес(string УдаленныйУзел)
        {
            return Лев(УдаленныйУзел, Найти(УдаленныйУзел, ":") - 1);
        }


        // Разбирает вошедший запрос и возвращает структуру запроса
        Структура РазобратьЗапросКлиента(string ТекстЗапроса, TCPСоединение Соединение)
        {
            string ИмяКонтроллера = "";
            string ИмяМетода = "";
            //Перем ПараметрыМетода;
            var Заголовок = Соответствие.Новый();
            var мТекстовыеДанные = ТекстЗапроса;
            var Разделитель = "";
            string Метод = null;
            string Путь = null;

            var GETСтруктура = Структура.Новый();

            while (Истина)
            {
                var П = Найти(мТекстовыеДанные, Символы.ПС);
                if (П == 0)
                {
                    break;
                }

                var Подстрока = Лев(мТекстовыеДанные, П);
                мТекстовыеДанные = Прав(мТекстовыеДанные, Стр.Длина(мТекстовыеДанные) - П);

                // Разбираем ключ значение
                if (Найти(Подстрока, "HTTP/1") > 0)
                {
                    // Это строка протокола
                    // Определим метод
                    var П1 = 0;
                    if (Лев(Подстрока, 3) == "GET")
                    {
                        Метод = "GET";
                        П1 = 3;
                    }
                    else if (Лев(Подстрока, 4) == "POST")
                    {
                        Метод = "POST";
                        П1 = 4;
                    }
                    else if (Лев(Подстрока, 3) == "PUT")
                    {
                        Метод = "PUT";
                        П1 = 3;
                    }
                    else if (Лев(Подстрока, 6) == "DELETE")
                    {
                        Метод = "DELETE";
                        П1 = 6;
                    }
                    Заголовок.Вставить("Method", Метод);

                    // Определим Путь
                    var П2 = Найти(Подстрока, "HTTP/1");
                    Путь = СокрЛП(Сред(Подстрока, П1 + 1, Стр.Длина(Подстрока) - 10 - П1));
                    Заголовок.Вставить("Path", Путь);
                }
                else
                {
                    if (Подстрока == Символы.ВК + Символы.ПС)
                    {
                        break;
                    }
                    else if (Найти(Подстрока, ":") > 0)
                    {
                        var П3 = Найти(Подстрока, ":");
                        var Ключ = СокрЛП(Лев(Подстрока, П3 - 1));
                        var Значение = СокрЛП(Прав(Подстрока, Стр.Длина(Подстрока) - П3));
                        Заголовок.Вставить(Ключ, Значение);
                        if (Ключ == "Content-Type")
                        {
                            if (Лев(Значение, 20) == "multipart/form-data;")
                            {
                                Разделитель = "--" + Сред(Значение, 31);
                            }
                        }
                    }
                    else
                    {
                        var Ключ = "unknown";
                        var Значение = СокрЛП(Подстрока);
                        if (Стр.Длина(Значение) > 0)
                        {
                            Заголовок.Вставить(Ключ, Значение);
                        }
                    }
                }
            }

            if (Метод == "POST")
            {
                // обработать позже
                Заголовок.Вставить("POSTData", Структура.Новый());
                Заголовок.Вставить("Разделитель", Разделитель);
            }

            //ЛогСообщить(ПД);
            // Разбор пути на имена контроллеров
            Путь = СокрЛП(Заголовок.Получить("Path") as string);
            // var ПараметрыМетода = Новый_Массив();
            if (!(Путь == null))
            {
                if (Лев(Путь, 1) == "/")
                {
                    Путь = Прав(Путь, Стр.Длина(Путь) - 1);
                }
                if (Прав(Путь, 1) != "/")
                {
                    Путь = Путь + "/";
                }
                var Сч = 0;
                while (Найти(Путь, "/") > 0)
                {
                    var П = Найти(Путь, "/");
                    Сч = Сч + 1;
                    var ЗначениеПараметра = РаскодироватьСтроку(Лев(Путь, П - 1), СпособКодированияСтроки.КодировкаURL);
                    Путь = Прав(Путь, Стр.Длина(Путь) - П);
                    if (Сч == 1)
                    {
                        ИмяКонтроллера = ЗначениеПараметра;
                    }
                    else if (Сч == 2)
                    {
                        ИмяМетода = ЗначениеПараметра;
                    }
                    else if (!(ЗначениеПараметра == ".."))
                    {
                        ИмяМетода = ОбъединитьПути(ИмяМетода, ЗначениеПараметра);
                    }
                }
                if (!(СокрЛП(ИмяМетода) == ""))
                {
                    if (Найти(ИмяМетода, "?") != 0)
                    {
                        var GETДанные = ИмяМетода;
                        ИмяМетода = Лев(GETДанные, Найти(GETДанные, "?") - 1);
                        GETДанные = Стр.Заменить(GETДанные, ИмяМетода + "?", "") + "&";

                        // Разбираем данные гет
                        while (Найти(GETДанные, "&") > 0)
                        {
                            var П1 = Найти(GETДанные, "&");
                            var П2 = Найти(GETДанные, "=");
                            var Ключ = Лев(GETДанные, П2 - 1);
                            var Значение = Сред(GETДанные, П2 + 1, П1 - (П2 + 1));
                            GETДанные = Прав(GETДанные, Стр.Длина(GETДанные) - П1);
                            if (!(Ключ == ""))
                            {
                                GETСтруктура.Вставить(Ключ, РаскодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL));
                            }
                        }
                    }
                }
            }
            Заголовок.Вставить("GETData", GETСтруктура);
            var Запрос = Структура.Новый();
            Запрос.Вставить("Заголовок", Заголовок);
            Запрос.Вставить("ИмяКонтроллера", "" + ИмяКонтроллера);
            Запрос.Вставить("ИмяМетода", "" + ИмяМетода);
            // Запрос.Вставить("ПараметрыМетода", ПараметрыМетода);

            return Запрос;

        } // РазобратьЗапросКлиента()


        object ОбработатьЗапросКлиента(Структура Запрос, TCPСоединение Соединение)
        {
            var Метод = Запрос.с.Заголовок.Получить("Method");

            if (!(Метод == Неопределено))
            {
                var ПараметрыЗапроса = Запрос.с.Заголовок.Получить(Метод + "Data") as Структура;

                if (ПараметрыЗапроса == Неопределено)
                {
                    return Неопределено;
                }

                var Задача = Структура.Новый();
                var ИдЗадачи = ПолучитьИД();
                Задачи.Вставить("" + ИдЗадачи, Задача);
                мЗадачи.Добавить(Задача);
                Задача.Вставить("ИдЗадачи", "" + ИдЗадачи);
                Задача.Вставить("структКонтроллер", Неопределено);
                Задача.Вставить("ВремяНачало", ТекущаяУниверсальнаяДатаВМиллисекундах());
                Задача.Вставить("Соединение", Соединение);
                Задача.Вставить("ИдКонтроллера", Неопределено);
                Задача.Вставить("Результат", Неопределено);
                Задача.Вставить("Этап", (Метод == "POST") ? "Данные" : "Новая");
                Задача.Вставить("УдаленныйУзел", УдаленныйУзелАдрес(Соединение.УдаленныйУзел));
                Задача.Вставить("Заголовок", Запрос.с.Заголовок);
                ПараметрыЗапроса.Вставить("УдаленныйУзел", Задача.с.УдаленныйУзел);
                ПараметрыЗапроса.Вставить("ИмяМетода", Запрос.с.ИмяМетода);
                ПараметрыЗапроса.Вставить("ИмяКонтроллера", Запрос.с.ИмяКонтроллера);
                Задача.Вставить("ПараметрыЗапроса", ПараметрыЗапроса);

                if (Запрос.с.ИмяКонтроллера == "resource")
                {
                    // запрос к файлам сервера
                    Задача.Вставить("ИмяДанных", ОбъединитьПути(Запрос.с.ИмяКонтроллера, Запрос.с.ИмяМетода));
                    Задача.Вставить("Результат", "Файл");
                    Задача.с.Этап = "Обработка";
                }
                else if (Запрос.с.ИмяКонтроллера == "favicon.ico" || Запрос.с.ИмяКонтроллера == "robots.txt")
                {
                    // запрос к файлам сервера
                    Задача.Вставить("ИмяДанных", ОбъединитьПути("resource", Запрос.с.ИмяКонтроллера));
                    Задача.Вставить("Результат", "Файл");
                    Задача.с.Этап = "Обработка";
                }

                ЛогСообщить(Задача.с.УдаленныйУзел + " -> taskid=" + Задача.с.ИдЗадачи + " " + СокрЛП(Запрос.с.Заголовок.Получить("Method")) + " " + Запрос.с.Заголовок.Получить("Path"));

            }

            return Неопределено;

        } // ОбработатьЗапросКлиента()


        void РазобратьДанныеЗапроса(Структура Задача)
        {

            Структура POSTСтруктура = Задача.с.ПараметрыЗапроса;
            string Содержимое = Задача.с.Заголовок.Получить("Content-Type");
            if (Содержимое == "text/plain;charset=UTF-8")
            {
                // параметры строкой
                // Получим данные запроса
                var POSTДанные = Задача.с.Соединение.ПолучитьСтроку();

                // Разбираем данные пост
                if (Стр.Длина(POSTДанные) > 0)
                {
                    POSTДанные = POSTДанные + "&";
                }
                while (Найти(POSTДанные, "&") > 0)
                {
                    var П1 = Найти(POSTДанные, "&");
                    var П2 = Найти(POSTДанные, "=");
                    var Ключ = Лев(POSTДанные, П2 - 1);
                    var Значение = Сред(POSTДанные, П2 + 1, П1 - (П2 + 1));
                    POSTДанные = Прав(POSTДанные, Стр.Длина(POSTДанные) - П1);
                    if (!(Ключ == ""))
                    {
                        POSTСтруктура.Вставить(Ключ, РаскодироватьСтроку(Значение, СпособКодированияСтроки.КодировкаURL));
                    }
                }
            }
            else if (Лев(Содержимое, 20) == "multipart/form-data;")
            {
                // параметры формы
                string Разделитель = Задача.с.Заголовок.Получить("Разделитель");
                string мТекстовыеДанные = Задача.с.Соединение.ПолучитьСтроку("windows-1251");
                while (Истина)
                {
                    var П = Найти(мТекстовыеДанные, Разделитель);
                    if (П == 0)
                    {
                        break;
                    }
                    var Подстрока = Лев(мТекстовыеДанные, П);
                    мТекстовыеДанные = Прав(мТекстовыеДанные, Стр.Длина(мТекстовыеДанные) - П - Стр.Длина(Разделитель) - 1);
                    if (Найти(Подстрока, "Content-Disposition: form-data;") != 0)
                    {
                        var П1 = Найти(Подстрока, "name=");
                        var П2 = Найти(Подстрока, Символы.ПС);
                        var П3 = Найти(Подстрока, Символы.ВК + Символы.ПС + Символы.ВК + Символы.ПС);
                        var П4 = Найти(Подстрока, "; filename");
                        string Ключ;
                        object Значение;
                        if (!(П4 == 0))
                        {
                            Значение = ПолучитьДвоичныеДанныеИзСтроки(Сред(Подстрока, П3 + 4, Стр.Длина(Подстрока) - П3 - 6), "windows-1251");
                            POSTСтруктура.Вставить("filename", РаскодироватьСтроку(Сред(Подстрока, П4 + 12, П2 - П4 - 14), СпособКодированияСтроки.КодировкаURL));
                            Ключ = Сред(Подстрока, П1 + 6, П4 - П1 - 7);
                        }
                        else
                        {
                            Ключ = Сред(Подстрока, П1 + 6, П2 - П1 - 8);
                            Значение = РаскодироватьСтроку(Сред(Подстрока, П2 + 3, Стр.Длина(Подстрока) - П2 - 5), СпособКодированияСтроки.КодировкаURL);
                        }
                        if (!(Ключ == ""))
                        {
                            POSTСтруктура.Вставить(Ключ, Значение);
                        }
                    }
                }
            }
            else if (Содержимое == "application/octet-stream")
            {
                // двоичные данные
                // Получим данные запроса
                POSTСтруктура.Вставить("Данные", Задача.с.Соединение.ПолучитьДвоичныеДанные());
            }

        } // РазобратьДанныеЗапроса()


        void ОбработатьОтветСервера(Структура Задача)
        {
            string ИмяФайла;
            try
            {
                var СтатусОтвета = 200;
                var Заголовок = Соответствие.Новый();
                ДвоичныеДанные ДвоичныеДанныеОтвета;
                if (Задача.с.Результат is ДвоичныеДанные)
                {
                    ДвоичныеДанныеОтвета = Задача.с.Результат;
                    Заголовок.Вставить("Content-Length", ДвоичныеДанныеОтвета.Размер());
                    if (Задача.с.Свойство("ContentType"))
                    {
                        Заголовок.Вставить("Content-Type", Задача.с.ContentType);
                    }
                }
                else
                {
                    ДвоичныеДанныеОтвета = ПолучитьДвоичныеДанныеИзСтроки(Задача.с.Результат);
                    Заголовок.Вставить("Content-Length", ДвоичныеДанныеОтвета.Размер());
                    Заголовок.Вставить("Content-Type", "text/html");
                    //Заголовок.Вставить("taskid", Задача.ИдЗадачи);
                }

                // Разбор маршрута
                if (Задача.Свойство("ИмяДанных"))
                {

                    ИмяФайла = ОбъединитьПути(ТекущийКаталог(), Задача.с.ИмяДанных);

                    //ЛогСообщить(ИмяФайла);

                    var файл = Файл.Новый(ИмяФайла);
                    var Расширение = файл.Расширение;

                    if (!(файл.Существует()))
                    {
                        ИмяФайла = Стр.Заменить(ИмяФайла, "/", @"\");
                        файл = Файл.Новый(ИмяФайла);
                    }

                    if (!(файл.Существует()))
                    {
                        СтатусОтвета = 404;
                    }

                    if (СтатусОтвета == 200)
                    {
                        var MIME = СоответствиеРасширенийТипамMIME.Получить(Расширение);
                        if (MIME == Неопределено)
                        {
                            MIME = СоответствиеРасширенийТипамMIME.Получить("default");
                        }
                        ДвоичныеДанныеОтвета = new ДвоичныеДанные(СокрЛП(ИмяФайла));
                        Заголовок.Вставить("Content-Length", ДвоичныеДанныеОтвета.Размер());
                        Заголовок.Вставить("Content-Type", MIME);
                    }
                }

                //Если Задача.Соединение.Активно Тогда

                try
                {
                    var ПС = Символы.ВК + Символы.ПС;
                    var ТекстОтветаКлиенту = СокрЛП(СтатусыHTTP.Получить(СтатусОтвета) as string) + ПС;
                    foreach (КлючИЗначение СтрокаЗаголовкаответа in Заголовок)
                    {
                        ТекстОтветаКлиенту = ТекстОтветаКлиенту + СтрокаЗаголовкаответа.Ключ + ":" + СтрокаЗаголовкаответа.Значение + ПС;
                    }

                    var мДанные = Массив.Новый();
                    мДанные.Добавить(ПолучитьДвоичныеДанныеИзСтроки(ТекстОтветаКлиенту + ПС));
                    //Сообщить(ТекстОтветаКлиенту);
                    мДанные.Добавить(ДвоичныеДанныеОтвета);

                    Задача.с.Соединение.ОтправитьДвоичныеДанныеАсинхронно(СоединитьДвоичныеДанные(мДанные), false);
                    Задача.с.Этап = "Вернуть";

                }
                catch (Exception e)
                {
                    Сообщить("webserver: " + ОписаниеОшибки(e));
                    Задача.с.Этап = "Удалить";
                }
            }
            catch (Exception e)
            {
                ЛогСообщить("Ошибка формирования ответа");
                ЛогСообщить(ОписаниеОшибки(e));
                Задача.с.Этап = "Удалить";
            }

        } // ОбработатьОтветСервера()


        void ОбработатьЗадачи()
        {

            var НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();

            var к = мЗадачи.Количество();
            while (к > 0 && !(ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла > 50))
            {
                к = к - 1;
                var Задача = мЗадачи.Получить(0) as Структура;
                мЗадачи.Удалить(0);

                if (Задача.с.Этап == "Данные")
                {
                    if (Задача.с.Соединение.Статус == "Данные")
                    {
                        РазобратьДанныеЗапроса(Задача);
                        Задача.с.Этап = "Новая";
                    }
                    else if (Задача.с.Соединение.Статус == "Ошибка")
                    {
                        ВызватьИсключение("Ошибка получения данных");
                    }

                }

                if (Задача.с.Этап == "Новая")
                {
                    var ПарИдКонтроллера = "";
                    var ИмяКонтроллера = Задача.с.ПараметрыЗапроса.ИмяКонтроллера;
                    if (ИмяКонтроллера == "procid")
                    {
                        // конкретный процесс
                        ПарИдКонтроллера = Задача.с.ПараметрыЗапроса.ИмяМетода;
                        if (Контроллеры.Получить(ПарИдКонтроллера) == Неопределено)
                        {
                            ПарИдКонтроллера = "";
                        }
                    }
                    else
                    {
                        if (ИмяКонтроллера == "" || ИмяКонтроллера == "doc")
                        {
                            // общий процесс
                            ПарИдКонтроллера = "1";
                        }
                        else
                        {
                            ПарИдКонтроллера = "" + ПолучитьИД();
                        }
                        if (Контроллеры.Получить(ПарИдКонтроллера) == Неопределено)
                        {
                            if (Функции.ПередатьДанные((string)Параметры.с.Хост, (int)Параметры.с.ПортС, Структура.Новый("procid, cmd", ПарИдКонтроллера, "startproc")) == Неопределено)
                            {
                                Сообщить("webserver: ошибка создания процесса");
                                ПарИдКонтроллера = "";
                            }
                        }
                    }
                    if (!(ПарИдКонтроллера == ""))
                    {
                        Задача.с.ИдКонтроллера = ПарИдКонтроллера;
                        Задача.с.Этап = "Ожидание";
                    }
                    else
                    {
                        Задача.с.Результат = "<div id='container' class='container-fluid data'>wrong session id</div><script>aupd=false</script>";
                        Задача.с.Этап = "Обработка";
                    }
                }

                if (Задача.с.Этап == "Ожидание")
                {
                    var структКонтроллер = Контроллеры.Получить(Задача.с.ИдКонтроллера) as Структура;
                    if (!(структКонтроллер == Неопределено))
                    {
                        структКонтроллер.Вставить("ВремяНачало", ТекущаяУниверсальнаяДатаВМиллисекундах());
                        Задача.Вставить("структКонтроллер", структКонтроллер);
                        Задача.Вставить("ВремяНачало", ТекущаяУниверсальнаяДатаВМиллисекундах());
                        Задача.с.ПараметрыЗапроса.Вставить("taskid", Задача.с.ИдЗадачи);
                        Задача.с.Этап = "Передать";
                    }
                }

                if (Задача.с.Этап == "Передать")
                {
                    if (!(Функции.ПередатьДанные(Задача.с.структКонтроллер.Хост, Задача.с.структКонтроллер.Порт, Задача.с.ПараметрыЗапроса) == Неопределено))
                    {
                        Задача.с.Этап = "Обработка";
                    }
                }

                if (Задача.с.Этап == "Обработка")
                {
                    if (!(Задача.с.Соединение == Неопределено))
                    {
                        if (НачалоЦикла - Задача.с.ВремяНачало > 30 * 1000)
                        {
                            Задача.с.ВремяНачало = НачалоЦикла;
                            if (!(Задача.с.Соединение.Активно))
                            {
                                Сообщить("webserver: соединение потеряно");
                                var структКонтроллер = Контроллеры.Получить(Задача.с.ИдКонтроллера) as Структура;
                                if (!(структКонтроллер == Неопределено))
                                {
                                    var ПараметрыЗапроса = Структура.Новый("ИдЗадачи, cmd", Задача.с.ИдЗадачи, "taskend");
                                    Функции.ПередатьДанные(структКонтроллер.с.Хост, структКонтроллер.с.Порт, ПараметрыЗапроса);
                                }
                                Задача.с.Этап = "Завершить";
                            }
                        }
                    }
                    if (!(Задача.с.Результат == Неопределено))
                    {
                        ОбработатьОтветСервера(Задача);
                    }
                }

                if (Задача.с.Этап == "Вернуть")
                {
                    if (!(Задача.с.Соединение.Статус == "Занят"))
                    {
                        Задача.с.Соединение.Закрыть();
                        Задача.с.Соединение = Неопределено;
                        Задача.с.Этап = "Завершить";
                    }
                }

                if (Задача.с.Этап == "Завершить")
                {
                    Задачи.Удалить(Задача.с.ИдЗадачи);
                    ЛогСообщить("<- taskid=" + СокрЛП(Задача.с.ИдЗадачи) + " time=" + Цел(ТекущаяУниверсальнаяДатаВМиллисекундах() - Задача.с.ВремяНачало) + Загрузка + Задачи.Количество() + " tasks");
                    continue;
                }

                мЗадачи.Добавить(Задача);

            }
        } // ОбработатьЗадачи()


        void ЛогСообщить(string Сообщение, int Тип = 0)
        {
            Сообщить("" + ТекущаяДата() + " " + Сообщение);
            // // Если нужен лог
            // Если НЕ Параметры = Неопределено Тогда
            // 	Сообщения.Добавить(Новый Структура("БазаДанных, Заголовок, Команда", "web", Новый Структура("Тип, Сообщение", Тип, Сообщение), "ЗаписатьЗаголовок"));
            // КонецЕсли;
        } // ЛогСообщить()


        void УдалитьКонтроллерИЗадачи(Структура структКонтроллер)
        {
            Контроллеры.Удалить(структКонтроллер.с.ИдКонтроллера);
            foreach (КлючИЗначение элЗадача in Задачи)
            {
                var Задача = элЗадача.Значение as Структура;
                if (Задача.с.структКонтроллер == структКонтроллер)
                {
                    Задача.с.Этап = "Вернуть";
                }
            }
        } // УдалитьКонтроллерИЗадачи()


        void ОбработатьСоединения()
        {
            //var Версия = "0.0.1";

            Порт = 8888;
            var ПортО = 8889;

            if (АргументыКоманднойСтроки.Length > 1)
            {
                ПортО = (int)Число(АргументыКоманднойСтроки[0]);
                Порт = (int)Число(АргументыКоманднойСтроки[1]);
            }

            var Таймаут = 5;

            var TCPСервер = new TCPСервер(Порт);
            TCPСервер.ПриниматьЗаголовки = Истина;
            TCPСервер.ЗапуститьАсинхронно();
            ЛогСообщить("Веб-сервер запущен на порту: " + Порт);

            var TCPСерверО = new TCPСервер(ПортО);
            TCPСерверО.ЗапуститьАсинхронно();
            ЛогСообщить("Ответы на порту: " + ПортО);

            ОстановитьСервер = Ложь;
            TCPСоединение Соединение;

            Задачи = Соответствие.Новый();
            мЗадачи = Массив.Новый();
            Контроллеры = Соответствие.Новый();
            Сообщения = Массив.Новый();

            Соединения = Массив.Новый();
            СоединенияО = Массив.Новый();

            var СуммаЦиклов = 0;
            var РабочийЦикл = 0;
            var ЗамерВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
            var Загрузка = " ";

            while (!(ОстановитьСервер))
            {
                var НачалоЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах();
                СуммаЦиклов = СуммаЦиклов + 1;

                if (СуммаЦиклов > 999)
                {
                    var ПредЗамер = ЗамерВремени;
                    ЗамерВремени = ТекущаяУниверсальнаяДатаВМиллисекундах();
                    Загрузка = " " + РабочийЦикл / 10 + "% " + Цел(1000 * РабочийЦикл / (ЗамерВремени - ПредЗамер)) + " q/s ";
                    СуммаЦиклов = 0;
                    РабочийЦикл = 0;
                }

                // Ожидаем ответ контроллера
                Соединение = TCPСерверО.ПолучитьСоединение(5);
                if (!(Соединение == Неопределено))
                {
                    СоединенияО.Добавить(Соединение);
                    Таймаут = 5;
                }

                var к = СоединенияО.Количество();
                while (к > 0)
                {
                    к = к - 1;
                    Соединение = (TCPСоединение)СоединенияО.Получить(0);
                    СоединенияО.Удалить(0);

                    if (Соединение.Статус == "Данные")
                    {
                        Структура КонтроллерЗапрос = null;
                        try
                        {
                            КонтроллерЗапрос = Функции.ДвоичныеДанныеВСтруктуру(Соединение.ПолучитьДвоичныеДанные()) as Структура;
                        }
                        catch (Exception e)
                        {
                            Сообщить("webserver: " + ОписаниеОшибки(e));
                        }
                        if (!(КонтроллерЗапрос == Неопределено))
                        {
                            if (КонтроллерЗапрос.Свойство("procid"))
                            {
                                var структКонтроллер = Контроллеры.Получить(КонтроллерЗапрос.с.procid) as Структура;
                                if (КонтроллерЗапрос.Свойство("cmd"))
                                {
                                    Сообщить("webserver: " + КонтроллерЗапрос.с.cmd);
                                    if (КонтроллерЗапрос.с.cmd == "termproc")
                                    {
                                        // удалить контроллер
                                        if (!(структКонтроллер == Неопределено))
                                        {
                                            УдалитьКонтроллерИЗадачи(структКонтроллер);
                                        }
                                    }
                                    else if (КонтроллерЗапрос.с.cmd == "init")
                                    {
                                        // зарегистрировать контроллер
                                        if (структКонтроллер == Неопределено)
                                        {
                                            ЛогСообщить("Подключен контроллер procid=" + КонтроллерЗапрос.с.procid);
                                            структКонтроллер = Структура.Новый("ИдКонтроллера, Хост, Порт, ВремяНачало", КонтроллерЗапрос.с.procid, КонтроллерЗапрос.с.Хост, КонтроллерЗапрос.с.Порт, ТекущаяУниверсальнаяДатаВМиллисекундах());
                                            Контроллеры.Вставить(КонтроллерЗапрос.с.procid, структКонтроллер);
                                        }
                                    }
                                }

                                if (КонтроллерЗапрос.Свойство("taskid"))
                                {
                                    var Задача = Задачи.Получить(КонтроллерЗапрос.с.taskid) as Структура;
                                    if (!(Задача == Неопределено))
                                    {
                                        if (КонтроллерЗапрос.Свойство("ContentType"))
                                        {
                                            Задача.Вставить("ContentType", Строка(КонтроллерЗапрос.с.ContentType));
                                        }
                                        Задача.с.Результат = КонтроллерЗапрос.с.Результат;
                                    }
                                }
                            }

                            else if (КонтроллерЗапрос.Свойство("cmd"))
                            {
                                if (КонтроллерЗапрос.с.cmd == "stopserver")
                                {
                                    ОстановитьСервер = Истина;
                                }
                                else if (КонтроллерЗапрос.с.cmd == "init")
                                {
                                    if (Параметры == Неопределено)
                                    {
                                        Сообщить("Получены параметры");
                                        Параметры = КонтроллерЗапрос;
                                    }
                                }
                            }
                        }

                        Соединение.Закрыть();
                        РабочийЦикл = РабочийЦикл + 1;
                        continue;

                    }

                    else if (Соединение.Статус == "Ошибка")
                    {
                        Соединение.Закрыть();
                        continue;
                    }

                    СоединенияО.Добавить(Соединение);

                }

                if (Параметры == Неопределено)
                {
                    Приостановить(50);
                    continue;
                }

                // Ожидаем подключение клиента
                Соединение = TCPСервер.ПолучитьСоединение(Таймаут);
                if (!(Соединение == Неопределено))
                {
                    Соединения.Добавить(Соединение);
                    Таймаут = 5;
                }

                к = Соединения.Количество();
                while (к > 0)
                {
                    к = к - 1;
                    Соединение = (TCPСоединение)Соединения.Получить(0);
                    Соединения.Удалить(0);

                    if (Соединение.Статус == "Заголовки" || Соединение.Статус == "Данные")
                    {
                        var ТекстовыеДанныеВходящие = "";
                        try
                        {
                            ТекстовыеДанныеВходящие = Соединение.ПолучитьЗаголовки();
                        }
                        catch (Exception e)
                        {
                            Сообщить("webserver: " + ОписаниеОшибки(e));
                        }

                        if (!(ТекстовыеДанныеВходящие == ""))
                        {
                            // Запрос http

                            try
                            {
                                var Запрос = РазобратьЗапросКлиента(ТекстовыеДанныеВходящие, Соединение);
                                ОбработатьЗапросКлиента(Запрос as Структура, Соединение);
                                //Сообщить("webserver: всего задач " + Задачи.Количество());
                            }
                            catch (Exception e)
                            {
                                ЛогСообщить(ОписаниеОшибки(e));
                                ЛогСообщить("Ошибка обработки запроса:");
                                ЛогСообщить(ТекстовыеДанныеВходящие);
                            }

                            РабочийЦикл = РабочийЦикл + 1;

                        }
                        continue;
                    }

                    else if (Соединение.Статус == "Ошибка")
                    {
                        Соединение.Закрыть();
                        Сообщить("webserver: ошибка соединения");
                        continue;
                    }

                    Соединения.Добавить(Соединение);

                }

                if (Задачи.Количество() != 0)
                {
                    ОбработатьЗадачи();
                }

                if (Сообщения.Количество() != 0)
                {
                    Функции.ПередатьДанные(Параметры.с.Хост, Параметры.с.ПортД, (Структура)Сообщения.Получить(0));
                    Сообщения.Удалить(0);
                }

                var ВремяЦикла = ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЦикла;
                if (ВремяЦикла > 100)
                {
                    Сообщить("!webserver ВремяЦикла=" + ВремяЦикла);
                }
                if (Таймаут < 50)
                {
                    Таймаут = Таймаут + 1;
                }
            }

            TCPСервер.Остановить();
            TCPСерверО.Остановить();

        } // ОбработатьСоединения()

        public void Main()
        {
            СтатусыHTTP = Соответствие.Новый();
            СтатусыHTTP.Вставить(200, "HTTP/1.1 200 OK");
            СтатусыHTTP.Вставить(400, "HTTP/1.1 400 Bad Request");
            СтатусыHTTP.Вставить(401, "HTTP/1.1 401 Unauthorized");
            СтатусыHTTP.Вставить(402, "HTTP/1.1 402 Payment Required");
            СтатусыHTTP.Вставить(403, "HTTP/1.1 403 Forbidden");
            СтатусыHTTP.Вставить(404, "HTTP/1.1 404 Not Found");
            СтатусыHTTP.Вставить(405, "HTTP/1.1 405 Method Not Allowed");
            СтатусыHTTP.Вставить(406, "HTTP/1.1 406 Not Acceptable");
            СтатусыHTTP.Вставить(500, "HTTP/1.1 500 Internal Server Error");
            СтатусыHTTP.Вставить(501, "HTTP/1.1 501 Not Implemented");
            СтатусыHTTP.Вставить(502, "HTTP/1.1 502 Bad Gateway");
            СтатусыHTTP.Вставить(503, "HTTP/1.1 503 Service Unavailable");
            СтатусыHTTP.Вставить(504, "HTTP/1.1 504 Gateway Timeout");
            СтатусыHTTP.Вставить(505, "HTTP/1.1 505 HTTP Version Not Supported");
            СоответствиеРасширенийТипамMIME = Соответствие.Новый();
            СоответствиеРасширенийТипамMIME.Вставить(".html", "text/html");
            СоответствиеРасширенийТипамMIME.Вставить(".css", "text/css");
            СоответствиеРасширенийТипамMIME.Вставить(".js", "text/javascript");
            СоответствиеРасширенийТипамMIME.Вставить(".jpg", "image/jpeg");
            СоответствиеРасширенийТипамMIME.Вставить(".svg", "image/svg+xml");
            СоответствиеРасширенийТипамMIME.Вставить(".jpeg", "image/jpeg");
            СоответствиеРасширенийТипамMIME.Вставить(".png", "image/png");
            СоответствиеРасширенийТипамMIME.Вставить(".gif", "image/gif");
            СоответствиеРасширенийТипамMIME.Вставить(".ico", "image/x-icon");
            СоответствиеРасширенийТипамMIME.Вставить(".zip", "application/x-compressed");
            СоответствиеРасширенийТипамMIME.Вставить(".rar", "application/x-compressed");
            СоответствиеРасширенийТипамMIME.Вставить("default", "text/plain");
            ОбработатьСоединения();
        }

    }

}