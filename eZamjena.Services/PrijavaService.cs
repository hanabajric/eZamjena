using AutoMapper;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class PrijavaService : BaseCRUDService<Model.Prijava, Database.Prijava, PrijavaSearchObject,PrijavaUpsertRequest,PrijavaUpsertRequest>, IPrijavaService
    {


        public PrijavaService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Prijava> AddFilter(IQueryable<Prijava> query, PrijavaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (!string.IsNullOrEmpty(search?.Razlog))
            {
                filteredQuery = filteredQuery.Where(x => x.Razlog == search.Razlog);
            }


            return filteredQuery;
        }
        public override IEnumerable<Model.Prijava> Get(PrijavaSearchObject? search)
        {
            var q = Context.Prijavas
                .Include(x => x.Proizvod)
                .Include(x => x.PrijavioKorisnik)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search?.Razlog))
            {
                var r = search.Razlog.Trim().ToLower();
                q = q.Where(x => x.Razlog.ToLower().Contains(r));
            }

            var list = q.ToList();
            return Mapper.Map<List<Model.Prijava>>(list);
        }

    }
}
