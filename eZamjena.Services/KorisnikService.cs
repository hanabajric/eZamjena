using AutoMapper;
using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Utils;
using eZamjena.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics;
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
            //if (insert.Password != insert.PasswordPotvrda)
            //{
            //    throw new UserException("Password and confirmation must be the same");
            //}
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

        public override Model.Korisnik GetById(int id)
        {
            Debug.WriteLine("Ovo je funkcija učitavanja po ID korisnika: " + id);

            var entity = Context.Korisniks.Include(k => k.Grad).FirstOrDefault(k => k.Id == id);

            if (entity == null)
            {
                return null;
            }

            return Mapper.Map<Model.Korisnik>(entity);
        }


        public override void BeforeInsert(KorisnikInsertRequest insert, Database.Korisnik entity)
        {
            var salt = GenerateSalt();
            entity.LozinkaSalt = salt;
            entity.LozinkaHash = GenerateHash(salt, insert.Password);
            base.BeforeInsert(insert, entity);
        }
        public override void BeforeUpdate(Database.Korisnik entity, KorisnikUpdateRequest update)
        {
            if (!string.IsNullOrWhiteSpace(update.Password) )
            {
                var passwordSalt = GenerateSalt();
                var passwordHash = GenerateHash(passwordSalt, update.Password);
                entity.LozinkaSalt = passwordSalt;
                entity.LozinkaHash = passwordHash;
                base.BeforeUpdate(entity,update);
            }
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

        public async Task<Model.Korisnik> Login(string username, string password)
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
        public override void ValidateInsert(KorisnikInsertRequest insert)
        {
            if (Context.Korisniks.Where(u => u.KorisnickoIme == insert.KorisnickoIme).Count() > 0)
                throw new UserException("Korisničko ime je zauzeto!");
            if (insert.Password != insert.PasswordPotvrda)
                throw new UserException("Lozinka i potvrda lozinke moraju biti iste!");
        }
        public override void ValidateUpdate(int id, KorisnikUpdateRequest update)
        {
            if (Context.Korisniks.Find(id) == null)
                throw new UserException("Odabrani korisnik ne postoji!");
            //if (!string.IsNullOrWhiteSpace(update.Password) && !string.IsNullOrWhiteSpace(update.PasswordPotvrda))
            //{
            //    if (update.Password != update.PasswordPotvrda)
            //        throw new UserException("Lozinka i potvrda lozinke moraju biti iste!");
            //}
        }
        public async Task<LoggedUser> GetUserRole(string username, string password)
        {
            Model.Korisnik trenutniKorisnik =await  Login(username, password);
            return new LoggedUser { UserId = trenutniKorisnik.Id, UserRole = trenutniKorisnik.Uloga.Naziv };
        }
        public async Task<Model.Korisnik> AdminUpdate(int id, AdminKorisnikUpdateRequest update)
        {
            var entity = Context.Korisniks.FirstOrDefault(k => k.Id == id);
            if (entity == null)
                throw new UserException("Korisnik ne postoji.");

            if (update.Slika == null || update.Slika.Length == 0)
            {
                update.Slika = GetDefaultImage();
            }

            // Mapping the update request to the entity while ignoring the password fields
            Mapper.Map(update, entity);

            // Optionally update other fields if needed, exclude password update logic
            // entity.SomeOtherField = update.SomeOtherField;

            await Context.SaveChangesAsync();
            return Mapper.Map<Model.Korisnik>(entity);
        }


    }
}
