using Coop.WebApplication.Ppl.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Coop.WebApplication.Ppl.Helper
{

    public class Difference
    {
        public string NameProp { get; set; }
        public string value1 { get; set; }
        public string value2 { get; set; }
    }
    public class JsonUtility
    {
        public static string toJson(object obj)
        {
            return JsonConvert.SerializeObject(obj);
        }

        public static T convertToObject<T>(string str)
        {
            return JsonConvert.DeserializeObject<T>(str);
        }

        public static bool checkIfJsonObjectsAreEqualByJson<T>(T obj1, T obj2)
        {
            string o1 = toJson(obj1);
            string o2 = toJson(obj2);
            return o1 == o2;
        }
        public static void CompareAndPrintDifferences(List<Difference> diff, object obj1, object obj2)
        {
            if (obj1 == null || obj2 == null)
            {
                //Console.WriteLine("Both objects must not be null.");
                return;
            }

            Type type1 = obj1.GetType();
            Type type2 = obj2.GetType();

            if (type1 != type2)
            {
                //Console.WriteLine("Both objects must be of the same type.");
                return;
            }

            PropertyInfo[] properties = type1.GetProperties();

            bool differencesFound = false;

            foreach (PropertyInfo property in properties)
            {
                var isIter = obj2 as ICollection;
                if (isIter != null && isIter.Count > 0)
                {

                    AreCollectionsEqual(diff, (IEnumerable)obj1, (IEnumerable)obj2);
                    return;
                }
                object value1 = property.GetValue(obj1);
                object value2 = property.GetValue(obj2);

                if (!AreValuesEqual(value1, value2))
                {
                    if ((value1 != null && !isPrimiteveType(value1)) || (value2 != null && !isPrimiteveType(value2)))
                    {
                        CompareAndPrintDifferences(diff, value1, value2);
                    }
                    else
                    {
                        Difference d = new Difference()
                        {
                            NameProp = property.Name,
                            value1 = value1 == null ? null : value1.ToString(),
                            value2 = value2 == null ? null : value2.ToString()
                        };
                        diff.Add(d);
                        differencesFound = true;
                    }
                }
            }

            if (!differencesFound)
            {
                //Console.WriteLine("The objects are identical.");
            }
        }

        private static bool AreValuesEqual(object value1, object value2)
        {
            if (value1 == null && value2 == null)
                return true;
            if (value1 == null || value2 == null)
                return false;

            return value1.Equals(value2);
        }

        private static bool AreCollectionsEqual(List<Difference> diff, IEnumerable collection1, IEnumerable collection2)
        {
            var enumerator1 = collection1.GetEnumerator();
            var enumerator2 = collection2.GetEnumerator();

            while (enumerator1.MoveNext() && enumerator2.MoveNext())
            {
                CompareAndPrintDifferences(diff, enumerator1.Current, enumerator2.Current);
            }
            // Ensure both collections have the same number of elements
            return !enumerator1.MoveNext() && !enumerator2.MoveNext();
        }

        public static bool isIterable(object obj1, object obj2)
        {
            if (obj1 is IEnumerable enumerable1 && obj2 is IEnumerable enumerable2) return true;
            return false;
        }

        public static bool isPrimiteveType(object o)
        {
            if (o == null) return false;
            Type objectType = o.GetType();
            if (objectType.IsPrimitive || o is string || o is decimal || o is double || o is float || o is char) return true;
            return false;
        }

    }
}
