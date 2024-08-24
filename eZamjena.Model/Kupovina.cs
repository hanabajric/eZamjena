using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public partial class Kupovina
    {
        public int Id { get; set; }
        public DateTime? Datum { get; set; }
        public int? KorisnikId { get; set; }
        public int? ProizvodId { get; set; }
        public virtual Korisnik Korisnik { get; set; }
        public virtual Proizvod Proizvod { get; set; }
        public float? Cijena =>Proizvod?.Cijena;
        public string NazivProizvoda => Proizvod?.Naziv;
        public string NazivKorisnika => Korisnik?.KorisnickoIme;
        //public string formatiraniDatum => Datum.HasValue ? Datum.Value.ToString("dd/MM/yyyy") : "";
    }
}
