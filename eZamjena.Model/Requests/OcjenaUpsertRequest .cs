using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class OcjenaUpsertRequest
    {
       
        public int? Ocjena1 { get; set; }
        public DateTime? Datum { get; set; }
        public int? ProizvodId { get; set; }
        public int? KorisnikId { get; set; }

    }
}
