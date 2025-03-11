using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class ListaZeljaProizvodUpsertRequest
    {

        public int ListaZeljaId { get; set; }
        public int ProizvodId { get; set; }
        public DateTime VrijemeDodavanja { get; set; }
        public int KorisnikId { get; set; }

    }
}
