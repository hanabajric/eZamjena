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
    public class KategorijaProizvodumService : BaseCRUDService<Model.KategorijaProizvodum, Database.KategorijaProizvodum, KategorijaProizvodumSearchObject, KategorijaProizvodumUpsertRequest, KategorijaProizvodumUpsertRequest>, IKategorijaProizvodumService
    {
        public KategorijaProizvodumService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<KategorijaProizvodum> AddFilter(IQueryable<KategorijaProizvodum> query, KategorijaProizvodumSearchObject search = null)
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
