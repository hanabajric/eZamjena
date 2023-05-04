using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public class Proizvod
    {

        public int Id { get; set; }
        public string Naziv { get; set; }
        public float Cijena { get; set; }
        public bool StanjeNovo { get; set; }
        public string Opis { get; set; }
        public byte[] Slika { get; set; }
        public int KorisnikId { get; set; }
        public int? StatusProizvodaId { get; set; }
        public int? KategorijaProizvodaId { get; set; }

        public virtual KategorijaProizvodum KategorijaProizvoda { get; set; }
        public string NazivKategorijeProizvoda => KategorijaProizvoda?.Naziv;
        public virtual Korisnik Korisnik { get; set; }
        public string NazivKorisnika => Korisnik?.KorisnickoIme;
        //public virtual StatusProizvodum StatusProizvoda { get; set; }
        //public string NazivStatusaProizvoda => StatusProizvoda?.Naziv;
        //public virtual ICollection<Kupovina> Kupovinas { get; set; }
        //public virtual ICollection<Ocjena> Ocjenas { get; set; }
        //public virtual ICollection<Razmjena> RazmjenaProizvod1s { get; set; }
        //public virtual ICollection<Razmjena> RazmjenaProizvod2s { get; set; }
    }
}
