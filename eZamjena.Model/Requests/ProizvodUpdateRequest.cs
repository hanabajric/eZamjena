using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class ProizvodUpdateRequest
    {

        public string Naziv { get; set; }
        public decimal Cijena { get; set; }
        public bool StanjeNovo { get; set; }
        public string Opis { get; set; }
        public byte[] Slika { get; set; }
        public int? StatusProizvodaId { get; set; }
        public int KategorijaProizvodaId { get; set; }
    }
}
