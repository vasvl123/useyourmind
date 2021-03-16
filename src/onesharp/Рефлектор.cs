using System;
namespace onesharp
{
    public class Рефлектор
    {

        public Рефлектор()
        {
        }

        public bool МетодСуществует(object obj, string metodname)
        {
            return (!(obj.GetType().GetMethod(metodname) is null));
        }
        public object ВызватьМетод(object obj, string metodname, Массив par)
        {
            var m = obj.GetType().GetMethod(metodname);
            return m.Invoke(obj, par.Arr);
        }

        public static Рефлектор Новый()
        {
            return new Рефлектор();
        }

    }

}
