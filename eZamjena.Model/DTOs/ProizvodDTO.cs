using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.DTOs
{
    public class ProizvodDTO
    {
        public int Id { get; set; }
        public string Naziv { get; set; }
        public float Cijena { get; set; }
        public bool StanjeNovo { get; set; }
        public string Opis { get; set; }
        public byte[] Slika { get; set; }
        public int KorisnikId { get; set; }
        public int? StatusProizvodaId { get; set; }
        public int KategorijaProizvodaId { get; set; }

        public virtual KategorijaProizvodum KategorijaProizvoda { get; set; }
        public string NazivKategorijeProizvoda => KategorijaProizvoda?.Naziv;
        public virtual Korisnik Korisnik { get; set; }
        public string NazivKorisnika => Korisnik?.KorisnickoIme;

    }
}
