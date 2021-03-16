/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.Collections.Generic;

namespace onesharp
{
    /// <summary>
    /// Простой однопоточный tcp-сокет. Слушает входящие соединения на определенном порту
    /// </summary>
    public class TCPСервер 
    {
        private readonly TcpListener _listener;
        private Thread th;
        private string _Active = "none";
        private readonly Queue<TCPСоединение> _Conn = new Queue<TCPСоединение>();
        private bool _readheaders = false;

        public TCPСервер(int port)
        {
            _listener = new TcpListener(IPAddress.Any, port);
        }

        /// <summary>
        /// Метод инициализирует TCP-сервер и подготавливает к приему входящих соединений
        /// </summary>
        public void Запустить()
        {
            _listener.Start();
        }

        /// <summary>
        /// Метод инициализирует TCP-сервер и подготавливает к приему входящих соединений в отдельном потоке
        /// </summary>
        public void ЗапуститьАсинхронно()
        {
            _listener.Start();
            th = new Thread(new ThreadStart(StartList));
            th.Start();
            while (_Active != "true")
            {
                Thread.Sleep(5);
            }
        }

        private void StartList()
        {
            _Active = "true";
            while (_Active == "true")
            {
                try
                {
                    var client = _listener.AcceptTcpClient();
                    var _client = new TCPСоединение(client);
                    _client.ПриниматьЗаголовоки = _readheaders;
                    _client.ПрочитатьДвоичныеДанныеАсинхронно();
                    _Conn.Enqueue(_client);
                }
                catch
                {
                }
            }
            _Active = "none";
        }

        /// <summary>
        /// Останавливает прослушивание порта.
        /// </summary>
        public void Остановить()
        {
            _Active = "false";
            _listener.Stop();
        }

        /// <summary>
        /// Приостановить выполнение скрипта и ожидать соединений по сети.
        /// После получения соединения выполнение продолжается
        /// </summary>
        /// <param name="timeout">Значение таймаута в миллисекундах.</param>
        /// <returns>TCPСоединение. Объект, позволяющий обмениваться данными с удаленным хостом.</returns>
        public TCPСоединение ОжидатьСоединения(int timeout = 0)
        {
            while (0 < timeout && !_listener.Pending())
            {
                Thread.Sleep(5);
                timeout -= 5;
            }

            if (!_listener.Pending())
                return null;

            var client = _listener.AcceptTcpClient();
            return new TCPСоединение(client);
        }

        public TCPСоединение ПолучитьСоединение(int timeout = 0)
        {
            while (5 < timeout && _Conn.Count == 0)
            {
                Thread.Sleep(5);
                timeout -= 5;
            }
            if (_Conn.Count != 0)
            {
                TCPСоединение val = _Conn.Dequeue();
                return val;
            }
            
            return null;
        }

        public bool ПриниматьЗаголовки
        {
            get { return _readheaders; }
            set { _readheaders = value; }
        }

        /// <summary>
        /// Создает новый сокет с привязкой к порту.
        /// </summary>
        /// <param name="port">Порт, который требуется слушать.</param>
        public static TCPСервер ConstructByPort(int port)
        {
            return new TCPСервер(port);
        }
    }
}
