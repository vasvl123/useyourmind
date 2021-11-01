/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Net.Sockets;
using System.Text;
using System.IO;

using System.Threading;
using System.Collections.Generic;

using onesharp.Binary;

namespace onesharp
{
    /// <summary>
    /// Соединение по протоколу TCP. Позволяет отправлять и принимать данные с использованием TCP сокета.
    /// </summary>
    public class TCPСоединение : IDisposable
    {
        private readonly TcpClient _client;
        private readonly TCPСервер _server;

        private string status = "Готов";
        private const int BUFFERSIZE = 4096;
        private byte[] m_Buffer;
        private byte[] l_Buffer = new byte[8];
        private MemoryStream data;
        private MemoryStream headers;
        private bool _http = false;
        private Int64 numberOfBytes;

        private readonly Queue<byte[]> _sdata = new Queue<byte[]>();
        private readonly Queue<byte[]> _rdata = new Queue<byte[]>();

        public TCPСоединение(TcpClient client, TCPСервер server)
        {
            this._client = client;
            this._server = server;
        }

        /// <summary>
        /// Прочитать данные из сокета в виде строки.
        /// </summary>
        /// <param name="encoding">КодировкаТекста или Строка. Указывает в какой кодировке интерпретировать входящий поток байт.
        /// Значение по умолчанию: utf-8</param>
        /// <returns>Строка. Данные прочитанные из сокета</returns>
        public string ПрочитатьСтроку(string encoding = null)
        {
            const int NO_LIMIT = 0;
            var memStream = ReadAllData(_client.GetStream(), NO_LIMIT);
            var enc = GetEncodingByName(encoding);
            if (memStream.Length == 0)
                return "";

            using (var reader = new StreamReader(memStream, enc))
            {
                return reader.ReadToEnd();
            }

        }

        /// <summary>
        /// Читает сырые байты из сокета.
        /// </summary>
        /// <param name="len">Количество байт, которые требуется прочитать. 0 - читать до конца потока.
        /// Значение по умолчанию: 0</param>
        /// <returns>ДвоичныеДанные</returns>
        public ДвоичныеДанные ПрочитатьДвоичныеДанные(int len = 0)
        {
            var stream = _client.GetStream();
            var ms = ReadAllData(stream, len);
            var data = ms.ToArray();

            return new ДвоичныеДанные(data);
        }

        private MemoryStream ReadAllData(NetworkStream source, int limit)
        {
            byte[] readBuffer = new byte[BUFFERSIZE];

            bool useLimit = limit > 0;
            var ms = new MemoryStream();

            do
            {
                int portion = useLimit ? Math.Min(limit, BUFFERSIZE) : BUFFERSIZE;
                int numberOfBytesRead = source.Read(readBuffer, 0, portion);
                ms.Write(readBuffer, 0, numberOfBytesRead);
                if (useLimit)
                {
                    limit -= numberOfBytesRead;
                    if (limit == 0) break;
                }
            } while (source.DataAvailable || useLimit);

            if (ms.Length > 0)
                ms.Position = 0;

            return ms;

        }

        /// <summary>
        /// Читает сырые байты из сокета асинхронно.
        /// </summary>
        public void ПрочитатьДвоичныеДанныеАсинхронно()
        {
            var stream = _client.GetStream();
            try
            {
                if (_http)
                {
                    status = "Ожидание";
                    headers = new MemoryStream();
                    data = new MemoryStream();
                    m_Buffer = new byte[BUFFERSIZE];
                    stream.BeginRead(m_Buffer, 0, m_Buffer.Length, new AsyncCallback(_OnDataReceive), null);
                }
                else
                    stream.BeginRead(l_Buffer, 0, 8, new AsyncCallback(OnDataReceive), null);
            }
            catch
            {
                status = "Ошибка";
            }

        }

        private void _OnDataReceive(IAsyncResult iar)
        {
            try
            {
                var stream = _client.GetStream();
                int ret = stream.EndRead(iar);
                if (ret > 0)
                {
                    int n = 0;
                    if (status == "Ожидание")
                    {
                        for (n = 0; n < ret; n++)
                        {
                            if (m_Buffer[n] == 10)
                            {
                                if (n > 3)
                                {
                                    if (m_Buffer[n - 1] == 13 && m_Buffer[n - 2] == 10 && m_Buffer[n - 3] == 13) // конец заголовка
                                    {
                                        headers.Write(m_Buffer, 0, n);
                                        if (n < ret) n++;

                                        status = "Заголовки";
                                        _server.br = true;
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    if (ret > n)
                    {
                        data.Write(m_Buffer, n, ret - n);

                        if (stream.DataAvailable)
                        {
                            status = "Чтение";
                            m_Buffer = new byte[BUFFERSIZE];
                            int numr = m_Buffer.Length;
                            stream.BeginRead(m_Buffer, 0, numr, new AsyncCallback(_OnDataReceive), null);
                        }
                        else
                        {
                            status = "Данные";
                            _server.br = true;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                status = "Ошибка\n" + e.Message;
            }

        }

        public void ДочитатьДанные()
        {
            if (status != "Чтение")
            { 
                var stream = _client.GetStream();
                status = "Чтение";
                m_Buffer = new byte[BUFFERSIZE];
                int numr = m_Buffer.Length;
                stream.BeginRead(m_Buffer, 0, numr, new AsyncCallback(_OnDataReceive), null);
            }

        }

        private void OnDataReceive(IAsyncResult iar)
        {
            try
            {
                var stream = _client.GetStream();
                int ret = stream.EndRead(iar);
                if (ret == 8)
                {
                    numberOfBytes = BitConverter.ToInt64(l_Buffer, 0);
                    _rdata.Enqueue(ReadAllData(stream, (int)numberOfBytes).ToArray());
                    status = "Данные";
                    _server.br = true;
                    
                    stream.BeginRead(l_Buffer, 0, 8, new AsyncCallback(OnDataReceive), null);
                }
                else status = "Ошибка";
            }
            catch (Exception e)
            {
                status = "Ошибка\n" + e.Message;
            }
        }


        /// <summary>
        /// Возвращает полученные сырые байты из сокета.
        /// </summary>
        /// <returns>ДвоичныеДанные</returns>
        public ДвоичныеДанные ПолучитьДвоичныеДанные()
        {
            if (_http) 
            { 
                var a = data.ToArray();
                data = null;
                status = "Готов";
                return new ДвоичныеДанные(a);
            }
            else
            {
                if (_rdata.Count == 0) return null;
                if (_rdata.Count == 1) status = "Ожидание";
                return new ДвоичныеДанные(_rdata.Dequeue());
            }
        }

        /// <summary>
        /// Прочитать данные из сокета в виде строки.
        /// </summary>
        /// <param name="encoding">КодировкаТекста или Строка. Указывает в какой кодировке интерпретировать входящий поток байт.
        /// Значение по умолчанию: utf-8</param>
        /// <returns>Строка. Данные прочитанные из сокета</returns>
        public string ПолучитьСтроку(string encoding = null)
        {
            var enc = GetEncodingByName(encoding);
            if (data.Length == 0)
                return "";

            data.Seek(0, SeekOrigin.Begin);

            using (var reader = new StreamReader(data, enc))
            {
                var str = reader.ReadToEnd();
                data = new MemoryStream();
                return str;
            }

        }


        public string ПолучитьЗаголовки(string encoding = null)
        {
            if (headers is null || headers.Length == 0)
                return "";

            headers.Seek(0, SeekOrigin.Begin);

            var enc = GetEncodingByName(encoding);
            using (var reader = new StreamReader(headers, enc))
            {
                var str = reader.ReadToEnd();
                headers = null;
                return str;
            }

        }


        /// <summary>
        /// Отправка строки на удаленный хост
        /// </summary>
        /// <param name="data">Строка. Данные для отправки</param>
        /// <param name="encoding">КодировкаТекста или Строка. Кодировка в которой нужно записать данные в поток. По умолчанию utf-8</param>
        public void ОтправитьСтроку(string data, string encoding = null)
        {
            if (data == String.Empty)
                return;

            var enc = GetEncodingByName(encoding);
            byte[] bytes = enc.GetBytes(data);
            var stream = _client.GetStream();

            stream.Write(bytes, 0, bytes.Length);
            stream.Flush();
        }

        /// <summary>
        /// Отправка сырых двоичных данных на удаленный хост.
        /// </summary>
        /// <param name="data">ДвоичныеДанные которые нужно отправить.</param>
        public void ОтправитьДвоичныеДанные(ДвоичныеДанные data)
        {
            if (data.Buffer.Length == 0)
                return;

            var stream = _client.GetStream();
            stream.Write(data.Buffer, 0, data.Buffer.Length);
            stream.Flush();

        }

        //// завершение асинхронной отправки
        private void OnWriteComplete(IAsyncResult ar)
        {
            try
            {
                var stream = _client.GetStream();
                stream.EndWrite(ar);
                status = "Успех";

                ОтправитьДвоичныеДанныеАсинхронно();
            }
            catch
            {
                status = "Ошибка";
            }
        }

        /// <summary>
        /// Отправка сырых двоичных данных на удаленный хост асинхронно.
        /// </summary>
        /// <param name="data">ДвоичныеДанные которые нужно отправить.</param>
        public void ОтправитьДвоичныеДанныеАсинхронно(ДвоичныеДанные _data = null)
        {
            
            if (_data != null)
            {
                if (!_http) _sdata.Enqueue(BitConverter.GetBytes((long)_data.Buffer.Length));
                _sdata.Enqueue(_data.Buffer);
            }

            try
            {
                if (Статус != "Запись")
                {
                    if (_sdata.Count != 0)
                    {
                        var val = _sdata.Dequeue();

                        if (val.Length != 0)
                        {
                            status = "Запись";
                            var stream = _client.GetStream();
                            stream.BeginWrite(val, 0, val.Length, OnWriteComplete, null);
                        }
                        else
                            ОтправитьДвоичныеДанныеАсинхронно();
                    }
                    else if (_http)
                        ПрочитатьДвоичныеДанныеАсинхронно(); // передача окончена
                }
            }
            catch
            {
                status = "Ошибка";
            }

        }

        /// <summary>
        /// Состояние выполнения асинхронной операции.
        /// </summary>
        public string Статус
        {
            get { return status; }
            set { status = value; }
        }

        /// <summary>
        /// Признак активности соединения.
        /// Данный признак не является надежным признаком существования соединения. 
        /// Он говорит лишь о том, что на момент получения значения данного свойства соединение было активно.
        /// </summary>
        public bool Активно
        {
            get
            {
                const int POLL_INTERVAL = 500;
                var socket = _client.Client;

                return !((socket.Poll(POLL_INTERVAL, SelectMode.SelectRead) && (socket.Available == 0)) || !socket.Connected);
            }
        }
        
        public long Длина
        {
            get
            {
                return data.Position;
            }
        }

        /// <summary>
        /// Таймаут, в течение которого система ожидает отправки данных. Если таймаут не установлен, то скрипт будет ждать начала отправки бесконечно.
        /// </summary>
        public int ТаймаутОтправки
        {
            get { return _client.GetStream().WriteTimeout; }
            set { _client.GetStream().WriteTimeout = value; }
        }

        /// <summary>
        /// Таймаут чтения данных. Если таймаут не установлен, то скрипт будет ждать начала приема данных бесконечно.
        /// </summary>
        public int ТаймаутЧтения
        {
            get { return _client.GetStream().ReadTimeout; }
            set { _client.GetStream().ReadTimeout = value; }
        }


        public bool HTTP
        {
            get { return _http; }
            set { _http = value; }
        }


        private static Encoding GetEncodingByName(string encoding)
        {
            Encoding enc;
            if (encoding == null)
            {
                enc = new UTF8Encoding();
            }
            else
            {
                enc = Encoding.GetEncoding(encoding);
            }

            return enc;
        }

        /// <summary>
        /// Закрывает соединение с удаленным хостом.
        /// </summary>
        public void Закрыть()
        {
            _client.Close();
        }

        /// <summary>
        /// Возвращает адрес удаленного узла соединения
        /// </summary>
        public string УдаленныйУзел => _client.Client.RemoteEndPoint.ToString();


        public void Dispose()
        {
            Закрыть();
        }

        /// <summary>
        /// Подключение к удаленному TCP-сокету
        /// </summary>
        /// <param name="host">адрес машины</param>
        /// <param name="port">порт сокета</param>
        public static TCPСоединение Новый(string host, int port)
        {
            var client = new TcpClient(host, port);
            return new TCPСоединение(client, null);
        }
    }
}
