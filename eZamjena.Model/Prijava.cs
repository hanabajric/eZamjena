using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public class Prijava
    {
            public int Id { get; set; }
            public int ProizvodId { get; set; }
            public int PrijavioKorisnikId { get; set; }

            public string Razlog { get; set; } 
            public string Poruka { get; set; }
            public DateTime Datum { get; set; } = DateTime.Now;
            public string ProizvodNaziv { get; set; }
            public string PrijavioKorisnik { get; set; }



    }
    
}
