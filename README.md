![OneScriptDB](https://github.com/vasvl123/OneScriptDB/blob/master/resource/osdb.png "OneScriptDB")

# OneScriptDB - инструмент концептуального проектирования

[![Join the chat at https://gitter.im/OneScriptDB/Lobby](https://badges.gitter.im/OneScriptDB/Lobby.svg)](https://gitter.im/OneScriptDB/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Платформа OneScriptDB - это простой и удобный инструмент управления сложными структурами данными. Программный код OneScriptDB исполняется независимым кросплатформенным интерпретатором языка 1С - [OneScript](https://github.com/EvilBeaver/OneScript).

OneScriptDB является сервером веб-приложения, где выполняется обработка данных и формируется представление интерфейса пользователя. Результат (в виде обычного HTML) загружается в определяемый идентификатором узел DOM страницы браузера. Для работы с DOM используется библиотека JQuery. В качестве шаблона используется CoreUI и BootStrap 4.

## Цели и задачи проекта

Представление [концепции распределенного сообщества](https://github.com/vasvl123/distributed-community) в виде системы формализованных знаний. Разработка действующей модели сообщества, реализация механизма совместного разрешения проблем.

На текущий момент уже реализованы средства хранения, представления и управления структурами данных.
Начата разработка средств интерпретации данных, представленных в формализованном виде (онтологии).

## Структура проекта

1. Модуль запуска приложения и управления процессами (starter.os).
2. Модуль веб-сервера (webserver.os).
3. Модуль контроллера для статичных страниц (webdata.os).
4. Модуль интерфейса пользователя (showdata.os) Представление данных, редактор структуры данных.
5. Модуль интерпретации структуры данных (pagedata.os).
6. Модуль сервера данных (dataserver.os) Асинхронная обработка запросов к данным.
7. Модуль работы с контейнерами файлов данных (dbaccess.os)
8. Библиотеки подключаемых функций, операторов (/lib/Операторы.os, /lib/Системные.os).
9. Шаблоны интерфейса(howdata.html, webdata.html), CSS стили и скрипты JS находятся в каталоге /resources.


Адрес тестового сервера: http://vasvl123.github.io/OneScriptDB Имя/пароль - admin/admin

Для локального запуска на своем компьютере необходимо:
Скачать этот репозиторий к себе на диск.
Скачать и установить последнюю версию OneScript http://oscript.io/downloads
Установить библиотеку .Net версии не ниже 4.5 - для Windows, а для linux mono-complete не ниже 5.2.
Перейти в папку OneScriptDB и выполнить команду: oscript starter.os
Открыть в браузере ссылку: http://localhost:8888

## Описание

Платформа имеет собственный веб-сервер (модуль webserver.os) - однопоточный, но позволяющий работать в многопользовательском режиме благодаря перенаправлению запросов пользователей отдельным процессам. Сервер запускается в двух режимах: локальном и серверном (в котором процессы пользователей завершаются при бездействии). По умолчанию веб-сервер слушает порт 8888.

Доступ к файлам данных осуществляется через отдельный процесс - сервер данных (dataserver.os). Сервер обрабатывает запросы ассинхронно, отдавая результаты по ходу выполнения запросов.

Данные сохраняются в виде заголовков и файлов внутри одного файла-контейнера(.osdb), или в отдельном текстовом файле.

В текстовых файлах каждая строка хранит один узел DOM. Свойства узлов хранятся в виде пары ключ - значение, разделенные символом табуляции. Код узла соответствует номеру строки в файле. Узел загружается в память в виде структуры, содержащей стандартные свойства: Код, Имя, Значение, и ссылки на другие узлы: Соседний, Дочерний, Атрибут, Старший, Родитель; а также структура временных значений Состояние. Отдельные текстовые файлы данных хранятся в папке data\.files.

Текстовые файлы могут храниться внутри файла-контейнера(.osdb). Вместе с файлом в контейнере сохраняется заголовок файла, который может хранить произвольную информацию об этом файле.

Модуль процесса пользователя (showdata.os) хранит текущее состояние приложения, производит обработку запросов пользователя, содержит редактор структуры данных. Редактор запускается в отдельном окне из главного меню программы. Для изменения структуры данных нужно выбрать нужный узел и выполнить с ним действия. Узлы можно создавать, удалять, копировать, вырезать и вставлять, изменять имя и значение. Имя узла - его тип - определяет, как он будет обрабатываться внутренним интерпретатором (в модуле pagedata.os).

Интерпретатор формирует представление данных для отображения в браузере. Каждый узел, в зависимости от его имени обрабатывается интерпретатором по разному. У (Узел) - присваивает имя подчиненной структуре данных. Узел может иметь расширения: Р (Родитель) - использование другого узла как шаблона; Ф(Функция) - вызывает функцию из подключаемой библиотеки, аргументами являются атрибуты узла: А (Аргумент). Результат выполнения функции отображается как содержимое узла и может быть интерпретирован. (Оператор) - выполняет действие над вложенными узлами. С (Ссылка) - передает ссылку на подчиненный узел либо именованный узел (У). З (Значение) - интерпретирует значение узла(У). П (Пусть) - присваивает вычисленное значение определенному узлу. В (Вставить) - копирует дочерний узел в конкретный узел (У). Указатель - передает ссылку на узел по коду узла. Свойство - получает значение свойства ссылки (структуры) , Атрибут - получает значение атрибута узла. Первый, Соседний - передает ссылку на текущий или соседний узел. Истина, Ложь, Неопределенно, Пустой, Число, Строка - передает соответствующее значение. Теги HTML передаются в виде HTML разметки.
