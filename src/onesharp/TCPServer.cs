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
using System.Threading.Tasks;

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
        private bool _http = false;

        public bool br = false;

        public TCPСервер(int port, bool http = false)
        {
            _listener = new TcpListener(IPAddress.Any, port);
            _http = http;
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
            StartList();
            while (_Active != "true")
            {
                Thread.Sleep(5);
            }
        }

        private async void newclient(TcpClient client) 
        { 
            await Task.Run(() =>
            {
                var _client = new TCPСоединение(client, this);
                _client.HTTP = _http;
                _client.ПрочитатьДвоичныеДанныеАсинхронно();
                _Conn.Enqueue(_client);
            });
        }

        private async void StartList()
        {
            _Active = "true";
            while (_Active == "true")
            {
                try
                {
                    var client = await _listener.AcceptTcpClientAsync();
                    newclient(client);
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
            return new TCPСоединение(client, this);
        }

        public TCPСоединение ПолучитьСоединение(int timeout = 0)
        {
            while (5 < timeout && _Conn.Count == 0 && !br)
            {
                Thread.Sleep(5);
                timeout -= 5;
            }

            br = false;
            
            if (_Conn.Count != 0)
            {
                TCPСоединение val = _Conn.Dequeue();
                return val;
            }
            
            return null;
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
