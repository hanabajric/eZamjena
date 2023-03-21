using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class KupovinaUpsertRequest
    {
        public DateTime? Datum { get; set; }
        public int? KorisnikId { get; set; }
        public int? ProizvodId { get; set; }

    }
}
