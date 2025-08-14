using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services.Database
{
    public partial class Prijava
    {
        public int Id { get; set; }

        public int ProizvodId { get; set; }
        public int PrijavioKorisnikId { get; set; }

        public string Razlog { get; set; } = null!;
        public string? Poruka { get; set; }
        public DateTime Datum { get; set; } = DateTime.Now;

        public virtual Proizvod Proizvod { get; set; } = null!;
        public virtual Korisnik PrijavioKorisnik { get; set; } = null!;
    }
}
