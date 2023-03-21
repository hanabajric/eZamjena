using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class Kupovina
    {
        public int Id { get; set; }
        public DateTime? Datum { get; set; }
        public int? KorisnikId { get; set; }
        public int? ProizvodId { get; set; }

        public virtual Korisnik? Korisnik { get; set; }
        public virtual Proizvod? Proizvod { get; set; }
    }
}
