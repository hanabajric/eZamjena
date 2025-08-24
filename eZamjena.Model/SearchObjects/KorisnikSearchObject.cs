using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.SearchObjects
{
    public class KorisnikSearchObject : BaseSearchObject
    {
        public string KorisnickoIme { get; set; }
        public int? GradId { get; set; }
    }
}
