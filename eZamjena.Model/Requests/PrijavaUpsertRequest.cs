using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class PrijavaUpsertRequest
    {

        public int ProizvodId { get; set; }
        public int PrijavioKorisnikId { get; set; }

        public string Razlog { get; set; }
        public string Poruka { get; set; }
    }
}
