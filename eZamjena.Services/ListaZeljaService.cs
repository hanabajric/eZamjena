using AutoMapper;
using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using System.Collections.Generic;
using System.Linq;

namespace eZamjena.Services
{
    public class ListaZeljaService : BaseCRUDService<Model.ListaZelja, Database.ListaZelja, ListaZeljaSearchObject, ListaZeljaUpsertRequest, ListaZeljaUpsertRequest>, IListaZeljaService
    {
        public ListaZeljaService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Database.ListaZelja> AddFilter(IQueryable<Database.ListaZelja> query, ListaZeljaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.KorisnikId != null && search.KorisnikId > 0)
            {
                filteredQuery = filteredQuery.Where(x => x.KorisnikId == search.KorisnikId);
            }

            if (search?.CreatedAt != null)
            {
                filteredQuery = filteredQuery.Where(x => x.CreatedAt.Date == search.CreatedAt.Date);
            }


            return filteredQuery;
        }
        public override IEnumerable<Model.ListaZelja> Get(ListaZeljaSearchObject search = null)
        {
            var query = Context.ListaZeljas
                        //.Include(x => x.ListaZeljaProizvods)
                        .AsQueryable();

            //query = AddFilter(query, search);

            var list = query.ToList();
            System.Diagnostics.Debug.WriteLine($"Pronađeno lista želja: {list.Count}");

            return Mapper.Map<List<Model.ListaZelja>>(list);
        }

        public override Model.ListaZelja Insert(ListaZeljaUpsertRequest request)
        {
            try
            {
                request.CreatedAt = DateTime.Now;

                var insertedEntity = base.Insert(request);
                return Mapper.Map<Model.ListaZelja>(insertedEntity);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[ERROR] Insert ListaZelja failed: {ex.Message}");
                Console.WriteLine($"StackTrace: {ex.StackTrace}");
                if (ex.InnerException != null)
                {
                    Console.WriteLine($"Inner Exception: {ex.InnerException.Message}");
                }
                throw;
            }
        }


        public Model.ListaZelja GetOrCreateWishlist(int korisnikId)
        {
            var existingWishlist = Context.ListaZeljas.FirstOrDefault(x => x.KorisnikId == korisnikId);
            if (existingWishlist != null)
            {
                return Mapper.Map<Model.ListaZelja>(existingWishlist);
            }

            var newWishlist = new Database.ListaZelja
            {
                KorisnikId = korisnikId,
                CreatedAt = DateTime.Now
            };

            Context.ListaZeljas.Add(newWishlist);
            Context.SaveChanges();

            return Mapper.Map<Model.ListaZelja>(newWishlist);
        }




    }
}
