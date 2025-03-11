using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.SearchObjects
{
    public class ListaZeljaSearchObject : BaseSearchObject
    {
        public int KorisnikId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
