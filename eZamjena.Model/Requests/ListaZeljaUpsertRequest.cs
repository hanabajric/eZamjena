using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class ListaZeljaUpsertRequest
    {
        public int KorisnikId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
