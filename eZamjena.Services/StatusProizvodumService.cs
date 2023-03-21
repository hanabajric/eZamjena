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
    public class StatusProizvodumService : BaseCRUDService<Model.StatusProizvodum, Database.StatusProizvodum, StatusProizvodumSearchObject, StatusProizvodumUpsertRequest, StatusProizvodumUpsertRequest>, IStatusProizvodumService
    {
        public StatusProizvodumService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<StatusProizvodum> AddFilter(IQueryable<StatusProizvodum> query, StatusProizvodumSearchObject search = null)
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
