using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Flurl.Http;
using Flurl;
using System.Net.Http;
using eZamjena.Model;


namespace eZamjena.WinUI
{
    public class APIService
    {
        protected string _resource = null;
        public string _endpoint = "https://localhost:49153/";//"https://localhost:49157/"; //"https://localhost:49153/"; //"https://localhost:49153/"; //"http://localhost:49156/"
        

        public static string Username = null;
        public static string Password = null;

        public APIService(string resource)
        {
            _resource = resource;
        }
        public virtual async Task<T> Get<T>(object search = null)
        {
            var query = "";
            if (search != null)
            {
                query = await search.ToQueryString();
            }

            var list = await $"{_endpoint}{_resource}?{query}".WithBasicAuth(Username, Password).GetJsonAsync<T>();

            return list;
        }
        public async Task<T> GetById<T>(object id)
        {
            var rezultat = await $"{_endpoint}{_resource}/{id}".WithBasicAuth(Username, Password).GetJsonAsync<T>();

            return rezultat;
        }
        public virtual async Task<T> Post<T>(object request)
        {
            try
            {
                var rezultat = await $"{_endpoint}{_resource}".WithBasicAuth(Username, Password).PostJsonAsync(request).ReceiveJson<T>();

                return rezultat;
            }
            catch (FlurlHttpException ex)
            {
                var errors = await ex.GetResponseJsonAsync<Dictionary<string, string[]>>();

                var stringBuilder = new StringBuilder();
                foreach (var error in errors)
                {
                    stringBuilder.AppendLine($"{error.Key}, ${string.Join(",", error.Value)}");
                }

                MessageBox.Show(stringBuilder.ToString(), "Greška", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return default(T);
            }
        }
        public async Task<T> Put<T>(object id, object request)
        {
            var rezultat = await $"{_endpoint}{_resource}/{id}".WithBasicAuth(Username, Password).PutJsonAsync(request).ReceiveJson<T>();

            return rezultat;
        }
        public async Task<T> Delete<T>(object id)
        {
            var rezultat = await $"{_endpoint}{_resource}/{id}".WithBasicAuth(Username, Password).DeleteAsync().ReceiveJson<T>();

            return rezultat;
        }
    }
}
