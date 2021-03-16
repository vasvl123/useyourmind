/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/
using System;
using System.Text;
using System.Security.Cryptography;
using System.IO;

using onesharp.Binary;

namespace onesharp.Hash
{
    public enum ХешФункция
    {
        MD5,
        SHA1,
        SHA256,
        SHA384,
        SHA512,
        CRC32
    }

    public class ХешированиеДанных : IDisposable
    {
        protected HashAlgorithm _provider;
        protected ХешФункция _enumValue;
        protected CombinedStream _toCalculate=new CombinedStream();
        protected bool _calculated;
        protected byte[] _hash;

        public ХешированиеДанных(HashAlgorithm provider, ХешФункция enumValue)
        {
            _provider = provider;
            _enumValue = enumValue;
            _calculated = false;
        }

        public byte[] InternalHash
        {
            get
            {
                if (!_calculated)
                {
                    _hash = _provider.ComputeHash(_toCalculate);
                    _calculated = true;
                }
                return _hash;
            }
        }

        public string ХешФункция
        {
            get
            {
                return ХешФункция;
            }
        }

        public object ХешСумма
        {
            get
            {
                if (_provider is Crc32)
                {
                    var buffer = new byte[4];
                    Array.Copy(InternalHash, buffer, 4);
                    if (BitConverter.IsLittleEndian)
                        Array.Reverse(buffer);
                    var ret = BitConverter.ToUInt32(buffer, 0);
                    return (decimal)ret;
                }
                return new ДвоичныеДанные(InternalHash);
            }
        }

        public string ХешСуммаСтрокой
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < InternalHash.Length; i++)
                    sb.Append(InternalHash[i].ToString("X2"));
                return sb.ToString();
            }
        }


        public void Добавить(object toAdd, uint count = 0)
        {
            if (toAdd is String)
            {
                AddStream(new MemoryStream(Encoding.UTF8.GetBytes((string)toAdd)));
            }
            else if (toAdd is Поток stream)
            {
                var length = Math.Min(count == 0 ? stream.Размер() : count, stream.Размер() - stream.ТекущаяПозиция());
                var buffer = (stream.GetUnderlyingStream() as MemoryStream)?.GetBuffer();
                if (buffer == null)
                    throw RuntimeException.InvalidArgumentValue();
                AddStream(new MemoryStream(buffer, (int)stream.ТекущаяПозиция(), (int)length));
                stream.Перейти((int)length, ПозицияВПотоке.Текущая);
            }
            else if (toAdd is ДвоичныеДанные binaryData)
            {
                AddStream(new MemoryStream(binaryData.Buffer));
            }
            else
            {
            throw RuntimeException.InvalidArgumentType();
            }
        }

        public void ДобавитьФайл(string path)
        {
            if (!File.Exists(path))
                throw RuntimeException.InvalidArgumentType();
            AddStream(new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite));
        }

        public void Очистить()
        {
            _toCalculate.Close();
            _toCalculate.Dispose();
            _toCalculate = new CombinedStream();
            _calculated = false;
        }


        public static ХешированиеДанных Новый(ХешФункция providerEnum)
        {
            var algName = providerEnum.ToString();

            HashAlgorithm objectProvider = null;

            if (algName == "CRC32") 
                objectProvider = new Crc32();
            else
                objectProvider = HashAlgorithm.Create(algName);
  
            return new ХешированиеДанных(objectProvider, providerEnum);
        }

        public void Dispose()
        {
            _toCalculate.Close();
            _toCalculate.Dispose();
        }

        private void AddStream(Stream stream)
        {
            _toCalculate.AddStream(stream);
            _toCalculate.Seek(0, SeekOrigin.Begin);
            _calculated = false;
            
        }
    }
}
