using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public class Korisnik
    {
        public int Id { get; set; }
        public string Ime { get; set; } 
        public string Prezime { get; set; }
        public string Telefon { get; set; }
        public string Email { get; set; }
        public string KorisnickoIme { get; set; } 
        public int? BrojKupovina { get; set; }
        public int? BrojRazmjena { get; set; }
        public int? BrojAktivnihArtikala { get; set; }
        public string Adresa { get; set; }
        public byte[] Slika { get; set; }
        public int? GradID { get; set; }
        public int? UlogaID { get; set; }

        public virtual Grad Grad { get; set; }
        public virtual Uloga Uloga { get; set; }

        public string NazivGrada => Grad?.Naziv;
        //public virtual ICollection<Kupovina> Kupovinas { get; set; }
        //public virtual ICollection<Ocjena> Ocjenas { get; set; }
        //public virtual ICollection<Proizvod> Proizvods { get; set; }
    }
}
