using AutoMapper;
using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;


namespace eZamjena.Services
{
    public class KorisnikService : BaseCRUDService<Model.Korisnik, Database.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>, IKorisnikService
    {
    
      

        public  KorisnikService(Ib190019Context context, IMapper mapper):base(context,mapper) {
         
        }
       //public IEnumerable<Model.Korisnik> Get()
       // {
       //     //List<eZamjena.Model.Korisnik> list = new List<eZamjena.Model.Korisnik>();
       //     var result= Context.Korisniks.ToList();
       //    /* foreach(var item in result)
       //     {
       //         list.Add(new eZamjena.Model.Korisnik()
       //         {
       //             Adresa = item.Adresa,
       //             BrojAktivnihArtikala = item.BrojAktivnihArtikala,
       //             BrojKupovina = item.BrojKupovina,
       //             Id = item.Id,
       //             Ime = item.Ime,
       //             GradId = item.GradId,
       //             BrojRazmjena = item.BrojRazmjena,
       //             Email = item.Email,
       //             KorisnickoIme = item.KorisnickoIme,
       //             Prezime = item.Prezime,
       //             Slika = item.Slika,
       //             Telefon = item.Telefon,
       //             UlogaId = item.UlogaId
       //         });
       //     }*/
       //     return Mapper.Map<List<Model.Korisnik>>(result);
       // }
        public override IEnumerable<Model.Korisnik> Get(KorisnikSearchObject search = null)
        {
            var entity = Context.Korisniks.Include(k => k.Grad).AsQueryable();

            entity = AddFilter(entity, search);

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                entity = entity.Take(search.Page.Value).Skip(search.PageSize.Value * search.Page.Value);
            }

            var list = entity.ToList();

            return Mapper.Map<IList<Model.Korisnik>>(list);
        }

        public override Model.Korisnik Insert(KorisnikInsertRequest insert)
        {
            var entity= base.Insert(insert);
            entity.UlogaID = insert.UlogaID;
            /*foreach(var ulogaId in insert.UlogeIdList)
            {
                entity.UlogaId = ulogaId;
            }*/

            Context.SaveChanges();
            return entity;
        }
    
        public override void BeforeInsert(KorisnikInsertRequest insert, Database.Korisnik entity)
        {
            var salt = GenerateSalt();
            entity.LozinkaSalt = salt;
            entity.LozinkaHash = GenerateHash(salt, insert.Password);
            base.BeforeInsert(insert, entity);
        }

        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

        
            return Convert.ToBase64String(byteArray);
        }
        public static string GenerateHash(string salt, string password)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(password);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);
        }
        public override IQueryable<Database.Korisnik> AddFilter(IQueryable<Database.Korisnik> query, KorisnikSearchObject search = null)
        {
            var filtrirano = base.AddFilter(query, search);
            if (!String.IsNullOrWhiteSpace(search?.KorisnickoIme))
            {
                filtrirano=filtrirano.Where(x=>x.KorisnickoIme.Contains(search.KorisnickoIme));
            }
            return filtrirano;
        }

        public Model.Korisnik Login(string username, string password)
        {
            var korisnik = Context.Korisniks.FirstOrDefault(x => x.KorisnickoIme == username);
            var uloga = Context.Ulogas.FirstOrDefault(x => x.Id==korisnik.UlogaId);
            var entity=Context.Korisniks.Include(k=>k.Uloga).FirstOrDefault(x=>x.KorisnickoIme==username);

            if (entity == null)
            {
                return null;
            }
            var hash = GenerateHash(entity.LozinkaSalt, password);
          
            if (hash != entity.LozinkaHash)
            {
                
                return null;
            }
            return Mapper.Map < Model.Korisnik > (entity);
        }
    }
}
