using Flurl.Http;
using Microsoft.Graph;
using Microsoft.Graph.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.WinUI
{
    public class KorisnikAPIService : APIService
    {
        public KorisnikAPIService(string resource) : base(resource)
        {
        }
        public override async Task<T> Post<T>(object request)
        {
            try
            {
                var rezultat = await $"{_endpoint}{_resource}".PostJsonAsync(request).ReceiveJson<T>();

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
    }
}
