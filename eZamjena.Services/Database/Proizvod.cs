using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class Proizvod
    {
        public Proizvod()
        {
            Kupovinas = new HashSet<Kupovina>();
            Ocjenas = new HashSet<Ocjena>();
            RazmjenaProizvod1s = new HashSet<Razmjena>();
            RazmjenaProizvod2s = new HashSet<Razmjena>();
        }

        public int Id { get; set; }
        public string Naziv { get; set; }
        public decimal? Cijena { get; set; }
        public bool? StanjeNovo { get; set; }
        public string? Opis { get; set; }
        public byte[]? Slika { get; set; }
        public int KorisnikId { get; set; }
        public int? StatusProizvodaId { get; set; }
        public int? KategorijaProizvodaId { get; set; }

        public virtual KategorijaProizvodum? KategorijaProizvoda { get; set; }
        public virtual Korisnik Korisnik { get; set; } = null!;
        public virtual StatusProizvodum? StatusProizvoda { get; set; }
        public virtual ICollection<Kupovina> Kupovinas { get; set; }
        public virtual ICollection<Ocjena> Ocjenas { get; set; }
        public virtual ICollection<Razmjena> RazmjenaProizvod1s { get; set; }
        public virtual ICollection<Razmjena> RazmjenaProizvod2s { get; set; }
    }
}
