// Источник https://github.com/pintov/1c-jwt/blob/master/src/Cryptography.bsl
// Адаптировал vasvl123

// Computes a Hash-based Message Authentication Code (HMAC)
// RFC 2104 https://www.ietf.org/rfc/rfc2104.txt
//
// Parameters:
//  Key			- BinaryData	- the key to use in the hash algorithm
//  Message		- BinaryData	- the input to compute the hash code for
//  HashFunc	- HashFunction	- the name of the hash algorithm to use for hashing
//
// Returns:
//  BinaryData - The computed hash code
//

Function HMAC(Val SecretKey, Val Message, Val HashFunc) Export

	CheckHashFuncIsSupported(HashFunc);

	BlSz = 64;

	If SecretKey.Size() > BlSz Then
		SecretKey = Hash(SecretKey, HashFunc);
	EndIf;

	EmptyBin = GetBinaryDataFromString("");
	SecretKey = BinLeft(SecretKey, BlSz);

	Ê0 = BinRightPad(SecretKey, BlSz, 0); // "0x00"

	ipad = BinRightPad(EmptyBin, BlSz, 54); // "0x36"
	k_ipad = BinBitwiseXOR(Ê0, ipad);

	opad = BinRightPad(EmptyBin, BlSz, 92); // "0x5C"
	k_opad = BinBitwiseXOR(Ê0, opad);

	k_ipad_Message = BinConcat(k_ipad, Message);
	k_opad_Hash = BinConcat(k_opad, Hash(k_ipad_Message, HashFunc));
	res = Hash(k_opad_Hash, HashFunc);

	Return res;

EndFunction


Procedure CheckHashFuncIsSupported(HashFunc)

	If HashFunc <> HashFunction.MD5 And	HashFunc <> HashFunction.SHA1 And HashFunc <> HashFunction.SHA256 Then
		Raise "HMAC: unsupported hash function: " + HashFunc;
	EndIf;

EndProcedure

Function BinLeft(Val BinaryData, Val CountOfBytes)

	Buffer = GetBinaryDataBufferFromBinaryData(BinaryData);
	If CountOfBytes > Buffer.Size Then
		CountOfBytes = Buffer.Size;
	EndIf;
	Buffer1 = Buffer.Read(0, CountOfBytes);

	Return GetBinaryDataFromBinaryDataBuffer(Buffer1);

EndFunction

Function BinRightPad(Val BinaryData, Val Length, Val PadByte)

	Buffer = GetBinaryDataBufferFromBinaryData(BinaryData);

	Buffer1Size = Length - Buffer.Size;
	Buffer1 = New BinaryDataBuffer(Buffer1Size);

	For n = 0 To Buffer1Size - 1 Do
		Buffer1.Set(n, PadByte);
	EndDo;

	Return GetBinaryDataFromBinaryDataBuffer(Buffer.Concat(Buffer1));

EndFunction

// такая функция еще не реализована
Function WriteBitwiseXor(Buffer1, Start, Buffer2, Size)

	For n = Start To Start + Size - 1 Do
		Buffer1.Set(n, BitwiseXor(Buffer1.Get(n), Buffer2.Get(n)));
	EndDo;

EndFunction

Function BinBitwiseXOR(Val BinaryData1, Val BinaryData2)

	Buffer1 = GetBinaryDataBufferFromBinaryData(BinaryData1);
	Buffer2 = GetBinaryDataBufferFromBinaryData(BinaryData2);

	If Buffer1.Size > Buffer2.Size Then
		WriteBitwiseXor(Buffer1, 0, Buffer2, Buffer2.Size);
		Return GetBinaryDataFromBinaryDataBuffer(Buffer1);
	Else
		WriteBitwiseXor(Buffer2, 0, Buffer1, Buffer1.Size);
		Return GetBinaryDataFromBinaryDataBuffer(Buffer2);
	EndIf;

EndFunction

Function Hash(Val Value, Val HashFunc) Export
	DataHashing = New DataHashing(HashFunc);
	DataHashing.Append(Value);
	Return DataHashing.HashSum;
EndFunction

Function BinConcat(Val BinaryData1, Val BinaryData2)

	Buffer1 = GetBinaryDataBufferFromBinaryData(BinaryData1);
	Buffer2 = GetBinaryDataBufferFromBinaryData(BinaryData2);

	Return GetBinaryDataFromBinaryDataBuffer(Buffer1.Concat(Buffer2));

EndFunction
