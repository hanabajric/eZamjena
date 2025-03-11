using AutoMapper;
using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

namespace eZamjena.Services
{
    public class ListaZeljaProizvodService : BaseCRUDService<Model.ListaZeljaProizvod, Database.ListaZeljaProizvod, ListaZeljaProizvodSearchObject, ListaZeljaProizvodUpsertRequest, ListaZeljaProizvodUpsertRequest>, IListaZeljaProizvodService
    {
        public ListaZeljaProizvodService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.ListaZeljaProizvod> AddFilter(IQueryable<Database.ListaZeljaProizvod> query, ListaZeljaProizvodSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.ListaZeljaId != null && search.ListaZeljaId > 0)
            {
                filteredQuery = filteredQuery.Where(x => x.ListaZeljaId == search.ListaZeljaId);
            }

           

            return filteredQuery;
        }
        public override IEnumerable<Model.ListaZeljaProizvod> Get(ListaZeljaProizvodSearchObject search = null)
        {
            var query = Context.ListaZeljaProizvods
                        .Include(x => x.Proizvod) 
                        .AsQueryable();

            query = AddFilter(query, search);

            var list = query.ToList();
            return Mapper.Map<List<Model.ListaZeljaProizvod>>(list);
        }

        public override Model.ListaZeljaProizvod Insert(ListaZeljaProizvodUpsertRequest request)
        {
            var wishlist = Context.ListaZeljas.FirstOrDefault(x => x.KorisnikId == request.KorisnikId);

            if (wishlist == null)
            {
                wishlist = new Database.ListaZelja
                {
                    KorisnikId = request.KorisnikId,
                    CreatedAt = DateTime.Now
                };

                Context.ListaZeljas.Add(wishlist);
                Context.SaveChanges();
            }

            request.ListaZeljaId = wishlist.Id;
            request.VrijemeDodavanja = DateTime.Now;

            var entity = Mapper.Map<Database.ListaZeljaProizvod>(request);
            Context.ListaZeljaProizvods.Add(entity);
            Context.SaveChanges();
            var insertedEntity = Context.ListaZeljaProizvods
    .Include(x => x.Proizvod)
    .FirstOrDefault(x => x.Id == entity.Id);

            return Mapper.Map<Model.ListaZeljaProizvod>(insertedEntity);
        }




    }
}
