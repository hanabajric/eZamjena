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
using System.Drawing;
using System.Drawing.Imaging;



namespace eZamjena.Services
{
    public class ProizvodService :  BaseCRUDService<Model.Proizvod,Database.Proizvod,ProizvodSearchObject,ProizvodUpsertRequest, ProizvodUpsertRequest> ,IProizvodService
    {

        
        public ProizvodService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            
        }
        private byte[] GetDefaultImage()
        {
            string imagePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Image", "default-image-300x169.png");

            if (File.Exists(imagePath))
            {
                return File.ReadAllBytes(imagePath);
            }
            else
            {
                throw new Exception("Default image not found");
            }
        }
        public override Model.Proizvod Insert(ProizvodUpsertRequest insert)
        {
            // Ukoliko je slika null ili prazna, dodajte default sliku
            if (insert.Slika == null || insert.Slika.Length == 0)
            {
                insert.Slika = GetDefaultImage();
            }

            return base.Insert(insert);
        }
        public override Model.Proizvod GetById(int id)
        {
            //var entity = Context.Proizvods .Include(k => k.KategorijaProizvoda).Include(x => x.Korisnik).FirstOrDefault(p => p.Id == id);
            var entity = Context.Proizvods.Include(k => k.KategorijaProizvoda).FirstOrDefault(p => p.Id == id);

            Context.Entry(entity).Reference(x => x.Korisnik).Load();
            return Mapper.Map<Model.Proizvod>(entity);
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
       

        public override IQueryable<Proizvod> AddFilter(IQueryable<Proizvod> query, ProizvodSearchObject search = null)
        {
            var filteredQuery= base.AddFilter(query, search);



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

        public override void BeforeDelete(int id)
        {
            //List<int> orderIds = context.OrderItems.Where(oi => oi.FurnitureItemId == id).Select(oi => oi.OrderId).ToList();

            List<Kupovina> kupovina = Context.Kupovinas.Where(k => k.ProizvodId == id).ToList();
            List<Razmjena> razmjena = Context.Razmjenas.Where(r=> r.Proizvod1Id==id || r.Proizvod2Id==id).ToList();
            List<Ocjena> ocjena = Context.Ocjenas.Where(o => o.ProizvodId == id).ToList();

            Context.RemoveRange(kupovina);
            Context.RemoveRange(razmjena);
            Context.RemoveRange(ocjena);


            //var orders = context.Orders.Where(o => orderIds.Contains(o.OrderId)).ToList();

            //context.RemoveRange(orders);

            Context.SaveChanges();
        }


    }
   
}
