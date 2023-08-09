using System;
using System.Collections.Generic;

namespace eZamjena.Model
{
    public partial class Razmjena
    {
        public int Id { get; set; }
        public DateTime? Datum { get; set; }
        public int? Proizvod1Id { get; set; }
        public int? Proizvod2Id { get; set; }
        public int? StatusRazmjeneId { get; set; }

        public virtual Proizvod Proizvod1 { get; set; }
        public virtual Proizvod Proizvod2 { get; set; }
        public string Proizvod1Naziv => Proizvod1?.Naziv;
        public string Proizvod2Naziv => Proizvod2?.Naziv;
        public string Korisnik1 => Proizvod1?.NazivKorisnika;
        public string Korisnik2 => Proizvod2?.NazivKorisnika;
        public int? Korisnik1Id => Proizvod1?.KorisnikId;
        public int? Korisnik2Id => Proizvod2?.KorisnikId;
        public string formatiraniDatum => Datum.HasValue ? Datum.Value.ToString("dd/MM/yyyy") : "";



        //public virtual StatusRazmjene? StatusRazmjene { get; set; }
    }
}
