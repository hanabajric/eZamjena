using System;
using System.Collections.Generic;

namespace eZamjena.Model
{
    public partial class Ocjena
    {
        public int Id { get; set; }
        public int? Ocjena1 { get; set; }
        public DateTime? Datum { get; set; }
        public int? ProizvodId { get; set; }
        public int? KorisnikId { get; set; }

       // public virtual Korisnik? Korisnik { get; set; }
        //public virtual Proizvod? Proizvod { get; set; }
    }
}
