using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class Korisnik
    {
        public Korisnik()
        {
            Kupovinas = new HashSet<Kupovina>();
            Ocjenas = new HashSet<Ocjena>();
            Proizvods = new HashSet<Proizvod>();
        }

        public int Id { get; set; }
        public string Ime { get; set; } = null!;
        public string Prezime { get; set; } = null!;
        public string? Telefon { get; set; }
        public string? Email { get; set; }
        public string KorisnickoIme { get; set; } = null!;
        public string LozinkaHash { get; set; } = null!;
        public string LozinkaSalt { get; set; } = null!;
        public int? BrojKupovina { get; set; }
        public int? BrojRazmjena { get; set; }
        public int? BrojAktivnihArtikala { get; set; }
        public string? Adresa { get; set; }
        public byte[]? Slika { get; set; }
        public int? GradId { get; set; }
        public int? UlogaId { get; set; }

        public virtual Grad? Grad { get; set; }
        public virtual Uloga? Uloga { get; set; }
        public virtual ICollection<Kupovina> Kupovinas { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Proizvod> Proizvods { get; set; }
    }
}
