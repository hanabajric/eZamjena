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
using System.Diagnostics;


namespace eZamjena.Services
{
    public class RazmjenaService :  BaseCRUDService<Model.Razmjena, Database.Razmjena, RazmjenaSearchObject, RazmjenaUpsertRequest, RazmjenaUpsertRequest> , IRazmjenaService
    {

        
        public RazmjenaService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            
        }
        public override IEnumerable<Model.Razmjena> Get(RazmjenaSearchObject search = null)
        {
            Debug.WriteLine("Ovo je funkcija učitavanja RAZMJENA.");
            var entity = Context.Razmjenas.Include(x=>x.Proizvod1.KategorijaProizvoda).Include(k => k.Proizvod2.KategorijaProizvoda).Include(x => x.Proizvod1.Korisnik).Include(x => x.Proizvod2.Korisnik).AsQueryable();

            entity = AddFilter(entity, search);
            

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                entity = entity.Take(search.Page.Value).Skip(search.PageSize.Value * search.Page.Value);
            }

            var list = entity.ToList();

            Debug.WriteLine("Ovo je filtriranje po datumu - " + search.Datum);
            return Mapper.Map<IList<Model.Razmjena>>(list);
        }


        public override IQueryable<Razmjena> AddFilter(IQueryable<Razmjena> query, RazmjenaSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);

            if (search?.DatumOd != null && search.DatumOd.Value != DateTime.MinValue)
            {
                filteredQuery=filteredQuery.Where(x=>x.Datum > search.DatumOd);
            }
            if (search?.DatumDo != null && search.DatumDo.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum < search.DatumDo);
            }
            if(search?.DatumOd != null && search.DatumOd.Value != DateTime.MinValue && search?.DatumDo != null && search.DatumDo.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum >search.DatumOd && x.Datum < search.DatumDo);
            }
            if (search?.Datum != null && search.Datum.Value != DateTime.MinValue)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum.HasValue && x.Datum.Value.Date == search.Datum.Value.Date);
            }


            return filteredQuery;
        }

    }
   
}
