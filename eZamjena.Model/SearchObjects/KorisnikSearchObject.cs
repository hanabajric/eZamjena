using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.SearchObjects
{
    public class KorisnikSearchObject : BaseSearchObject
    {
        public string KorisnickoIme { get; set; }
        public int? GradID { get; set; }
        public Grad grad { get; set; }
    }
}
