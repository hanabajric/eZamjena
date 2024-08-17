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
using System.Diagnostics;
using Microsoft.ML;
using Microsoft.ML.Trainers;
using Microsoft.ML.Data;
using EasyNetQ;
using eZamjena.Model.Messages;

namespace eZamjena.Services
{
    public class ProizvodService :  BaseCRUDService<Model.Proizvod,Database.Proizvod,ProizvodSearchObject,ProizvodUpsertRequest, ProizvodUpsertRequest> ,IProizvodService
    {

        private static MLContext mlContext = new MLContext();
        private static ITransformer model;
        public ProizvodService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {
            if (model == null)
            {
                TrainModel();
            }
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
            var entitiy= base.Insert(insert);
            ProizvodInserted message = new ProizvodInserted { Proizvod= entitiy };
            var bus = RabbitHutch.CreateBus("host=localhost");
             bus.PubSub.Publish(message);

            return entitiy;
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
            Debug.WriteLine("Ovo je funkcija učitavanja PROIZVODA.");
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
            if (search?.NazivKategorije != null)
            {
                filteredQuery = filteredQuery.Where(x => x.KategorijaProizvoda.Naziv==search.NazivKategorije);
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
        private void TrainModel()
        {
            // Učitaj sve ocjene iz baze
            var data = Context.Ocjenas.Select(o => new RatingEntry
            {
                UserId = (uint)o.KorisnikId,
                ProductId = (uint)o.ProizvodId,
                Label = (float)o.Ocjena1
            }).ToList();

            var trainData = mlContext.Data.LoadFromEnumerable(data);

            // Konfiguracija Matrix Factorization trenera
            var options = new MatrixFactorizationTrainer.Options
            {
                MatrixColumnIndexColumnName = nameof(RatingEntry.ProductId),
                MatrixRowIndexColumnName = nameof(RatingEntry.UserId),
                LabelColumnName = "Label",
                NumberOfIterations = 20,
                ApproximationRank = 100
            };

            var trainer = mlContext.Recommendation().Trainers.MatrixFactorization(options);
            model = trainer.Fit(trainData);
        }


        public IEnumerable<Model.Proizvod> RecommendProducts(int userId)
        {
            // Učitaj sve proizvode
            var allProducts = Context.Proizvods.ToList();

            // Kreiraj PredictionEngine
            var engine = mlContext.Model.CreatePredictionEngine<RatingEntry, RatingPrediction>(model);

            var results = new List<Model.Proizvod>();

            foreach (var product in allProducts)
            {
                var prediction = engine.Predict(new RatingEntry
                {
                    UserId = (uint)userId,
                    ProductId = (uint)product.Id
                });

                if (prediction.Score > 3.5)  // Primjer: filtriranje proizvoda s visokom predviđenom ocjenom
                {
                    results.Add(Mapper.Map<Model.Proizvod>(product));
                }
            }

            return results;
        }

        public class RatingEntry
        {
            [KeyType(count: 10000)] // Primer: pretpostavimo da imate manje od 10,000 različitih korisnika
            public uint UserId { get; set; }

            [KeyType(count: 10000)] // Primer: pretpostavimo da imate manje od 10,000 različitih proizvoda
            public uint ProductId { get; set; }

            public float Label { get; set; }
        }

        public class RatingPrediction
        {
            public float Score { get; set; }
        }



    }

}
