
namespace onesharp
{
    public static class Новый
    {

        public static Массив Массив(object[] array)
        {
            return new Массив(array);
        }

        public static Массив Массив(params int[] dim)
        {
            return onesharp.Массив.Constructor(dim);
        }

        public static Массив Массив()
        {
            return new Массив();
        }

        public static Структура Структура(Структура fixedStruct)
        {
            return new Структура(fixedStruct);
        }

        public static Структура Структура(string param1, params object[] args)
        {
            return new Структура(param1, args);
        }

        public static Структура Структура()
        {
            return new Структура();
        }

        public static Соответствие Соответствие()
        {
            return new Соответствие();
        }

        public static ТекстовыйДокумент ТекстовыйДокумент()
        {
            return new ТекстовыйДокумент();
        }

    }
}
