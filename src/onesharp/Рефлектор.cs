using System;
namespace onesharp
{
    public static class Рефлектор
    {

        public static bool МетодСуществует(object obj, string metodname)
        {
            return (!(obj.GetType().GetMethod(metodname) is null));
        }
        public static object ВызватьМетод(object obj, string metodname, Массив par)
        {
            var m = obj.GetType().GetMethod(metodname);
            return m.Invoke(obj, par.Arr);
        }

    }

}
