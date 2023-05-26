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

        public KorisnikService(Ib190019Context context, IMapper mapper) : base(context, mapper)
        {

        }

        private byte[] GetDefaultImage()
        {
            string imagePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Image", "generic-user-icon-10.jpg");

            if (File.Exists(imagePath))
            {
                return File.ReadAllBytes(imagePath);
            }
            else
            {
                throw new Exception("Default image not found");
            }
        }
        
        public override Model.Korisnik Insert(KorisnikInsertRequest insert)
        {
            // Ukoliko je slika null ili prazna, dodajte default sliku
            if (insert.Slika == null || insert.Slika.Length == 0)
            {
                insert.Slika = GetDefaultImage();
            }
            if (insert.Password != insert.PasswordPotvrda)
            {
                throw new UserException("Password and confirmation must be the same");
            }
            return base.Insert(insert);
        }
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
            if (search?.grad != null && search.grad.Id != -1)
            {
                filtrirano = filtrirano.Where(x => x.Grad.Id == search.grad.Id);
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
