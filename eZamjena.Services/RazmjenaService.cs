using AutoMapper;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class RazmjenaService :  BaseCRUDService<Model.Razmjena, Database.Razmjena, RazmjenaSearchObject, RazmjenaUpsertRequest, RazmjenaUpsertRequest> , IRazmjenaService
    {

        
        public RazmjenaService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            
        }
        

        public override IQueryable<Razmjena> AddFilter(IQueryable<Razmjena> query, RazmjenaSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);

            if (!string.IsNullOrEmpty(search?.Datum.ToString()))
            {
                filteredQuery=filteredQuery.Where(x=>x.Datum.ToString()==search.Datum.ToString());
            }

         
            return filteredQuery;
        }

    }
   
}
