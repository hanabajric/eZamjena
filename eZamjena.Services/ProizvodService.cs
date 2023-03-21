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
    public class ProizvodService :  BaseCRUDService<Model.Proizvod,Database.Proizvod,ProizvodSearchObject,ProizvodUpsertRequest, ProizvodUpsertRequest> ,IProizvodService
    {

        
        public ProizvodService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            
        }
        //public override IEnumerable<Model.Proizvod> Get(ProizvodSearchObject search = null)
        //{
        //    return base.Get(search);
        //}

        public override IQueryable<Proizvod> AddFilter(IQueryable<Proizvod> query, ProizvodSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);

            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                filteredQuery=filteredQuery.Where(x=>x.Naziv.Contains(search.Naziv));
            }

            if (search.NazivKategorije != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KategorijaProizvoda.Naziv == search.NazivKategorije);
            }
            return filteredQuery;
        }

        //public IEnumerable<Model.Proizvod> Get()
        //{
        //    var result = Context.Proizvods.ToList();
        //    return Mapper.Map<List<Model.Proizvod>>(result);
        //}
        //public Model.Proizvod GetById(int id)
        //{
        //    var result = Context.Proizvods.Find(id);
        //    return Mapper.Map<Model.Proizvod>(result);
        //}
    }
   
}
