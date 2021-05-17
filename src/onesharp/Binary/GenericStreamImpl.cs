/*----------------------------------------------------------
This Source Code Form is subject to the terms of the 
Mozilla Public License, v.2.0. If a copy of the MPL 
was not distributed with this file, You can obtain one 
at http://mozilla.org/MPL/2.0/.
----------------------------------------------------------*/

using System.IO;

namespace onesharp.Binary
{
    internal class GenericStreamImpl
    {
        private Stream _underlyingStream;

        public GenericStreamImpl(Stream stream)
        {
            _underlyingStream = stream;
        }

        public void Write(БуферДвоичныхДанных buffer, int positionInBuffer, int number)
        {
            buffer.ThrowIfReadonly();
            _underlyingStream.Write(buffer.Bytes, positionInBuffer, number);
        }

        public void CopyTo(object targetStream, int bufferSize = 0)
        {
            IStreamWrapper sw = targetStream as IStreamWrapper;
            if (sw == null)
                throw RuntimeException.InvalidArgumentType("targetStream");

            var stream = sw.GetUnderlyingStream();
            if (bufferSize == 0)
                _underlyingStream.CopyTo(stream);
            else
                _underlyingStream.CopyTo(stream, bufferSize);
        }

        public long Seek(long offset, ПозицияВПотоке initialPosition = ПозицияВПотоке.Начало)
        {
            SeekOrigin origin;
            switch (initialPosition)
            {
                case ПозицияВПотоке.Конец:
                    origin = SeekOrigin.End;
                    break;
                case ПозицияВПотоке.Текущая:
                    origin = SeekOrigin.Current;
                    break;
                default:
                    origin = SeekOrigin.Begin;
                    break;
            }

            return _underlyingStream.Seek(offset, origin);
        }

        public Поток GetReadonlyStream()
        {
            return new Поток(_underlyingStream, true);
        }

        public long Read(БуферДвоичныхДанных buffer, int positionInBuffer, int number)
        {
            return _underlyingStream.Read(buffer.Bytes, positionInBuffer, number);
        }

        public long Size()
        {
            return _underlyingStream.Length;
        }

        public void Flush()
        {
            _underlyingStream.Flush();
        }

        public long CurrentPosition()
        {
            return _underlyingStream.Position;
        }

        public void SetSize(long size)
        {
            _underlyingStream.SetLength(size);
        }

    }
}
