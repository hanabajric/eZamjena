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
    public class KupovinaService : BaseCRUDService<Model.Kupovina,Database.Kupovina, KupovinaSearchObject, KupovinaUpsertRequest, KupovinaUpsertRequest>, IKupovinaService
    {
      
        public KupovinaService(Ib190019Context context, IMapper mapper):base(context,mapper)
        {
            
        }
        public override IQueryable<Kupovina> AddFilter(IQueryable<Kupovina> query, KupovinaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.DatumOd != null && search.DatumOd.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum > search.DatumOd);
            }
            if (search?.DatumDo != null && search.DatumDo.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum < search.DatumDo);
            }
            if (search?.DatumOd != null && search.DatumOd.Value != DateTime.MinValue && search?.DatumDo != null && search.DatumDo.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum > search.DatumOd && x.Datum < search.DatumDo);
            }


            return filteredQuery;


        }
        public override IEnumerable<Model.Kupovina> Get(KupovinaSearchObject search = null)
        {
            var entity = Context.Kupovinas.Include(x => x.Proizvod).Include(k => k.Korisnik).AsQueryable();

            entity = AddFilter(entity, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                entity = entity.Take(search.Page.Value).Skip(search.PageSize.Value * search.Page.Value);
            }

            var list = entity.ToList();


            return Mapper.Map<IList<Model.Kupovina>>(list);
        }
       
    }
   
}
