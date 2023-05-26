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

    public class UlogaAPIService: APIService
    {
    

        public UlogaAPIService(string resource): base(resource)
        {
           
        }
        public override async Task<T> Get<T>(object search = null)
        {
            var query = "";
            if (search != null)
            {
                query = await search.ToQueryString();
            }

            var list = await $"{_endpoint}{_resource}?{query}".GetJsonAsync<T>();

            return list;
        }
    }
}
