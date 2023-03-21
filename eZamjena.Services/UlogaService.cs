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
    public class UlogaService : BaseCRUDService<Model.Uloga, Database.Uloga, UlogaSearchObject, UlogaUpsertRequest, UlogaUpsertRequest>, IUlogaService
    {
        public UlogaService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Uloga> AddFilter(IQueryable<Uloga> query, UlogaSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);

            if (!string.IsNullOrWhiteSpace(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.StartsWith(search.Naziv));
            }
            return filteredQuery;
        }
    }
}
