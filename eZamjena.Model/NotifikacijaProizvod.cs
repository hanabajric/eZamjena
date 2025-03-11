using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public partial class NotifikacijaProizvod
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public int ProizvodId { get; set; }
        public DateTime VrijemeKreiranja { get; set; }
        public string Poruka { get; set; }

        public virtual Korisnik Korisnik { get; set; }
        public virtual Proizvod Proizvod { get; set; }
    }
}
