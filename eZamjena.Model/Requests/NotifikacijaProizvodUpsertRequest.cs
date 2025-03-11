using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class NotifikacijaProizvodUpsertRequest
    {
        public int KorisnikId { get; set; }
        public int ProizvodId { get; set; }
        public DateTime VrijemeKreiranja { get; set; } 
        public string Poruka { get; set; }
    }
}
