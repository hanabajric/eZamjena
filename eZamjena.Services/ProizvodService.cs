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
    public class ProizvodService :  BaseCRUDService<Model.Proizvod,Database.Proizvod,ProizvodSearchObject,ProizvodUpsertRequest, ProizvodUpsertRequest> ,IProizvodService
    {

        
        public ProizvodService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            
        }
        public override IEnumerable<Model.Proizvod> Get(ProizvodSearchObject search = null)
        {
            var entity = Context.Proizvods.Include(k => k.KategorijaProizvoda).Include(x => x.Korisnik).AsQueryable();

            entity = AddFilter(entity, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                entity = entity.Take(search.Page.Value).Skip(search.PageSize.Value * search.Page.Value);
            }

            var list = entity.ToList();

            return Mapper.Map<IList<Model.Proizvod>>(list);
        }
        public override Model.Proizvod Update(int id, ProizvodUpsertRequest update)
        {
            return base.Update(id, update);
        }

        public override IQueryable<Proizvod> AddFilter(IQueryable<Proizvod> query, ProizvodSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);


            

            //if (search.NazivKategorije != null)
            //{
            //    filteredQuery = filteredQuery.Where(x => x.KategorijaProizvoda.Naziv == search.NazivKategorije);
            //}

            if (search.NazivKategorijeList != null)
            {
                filteredQuery = filteredQuery.Where(x => search.NazivKategorijeList.Contains(x.KategorijaProizvoda.Naziv));
            }
            if (search.Novo != null)
            {
                filteredQuery = filteredQuery.Where(x => search.Novo == x.StanjeNovo);
            }
            if (!string.IsNullOrEmpty(search?.Naziv))
            {
                filteredQuery = filteredQuery.Where(x => x.Naziv.Contains(search.Naziv));
            }
           
            return filteredQuery;
        }

        
    }
   
}
