using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class KorisnikInsertRequest
    {

        public string Ime { get; set; } 
        public string Prezime { get; set; } 
        public string Telefon { get; set; }
        public string Email { get; set; }
        public string KorisnickoIme { get; set; }
        public string Password { get; set; }
        public int? BrojKupovina { get; set; }
        public int? BrojRazmjena { get; set; }
        public int? BrojAktivnihArtikala { get; set; }
        public string Adresa { get; set; }
        public byte[] Slika { get; set; }
        public int? GradID { get; set; }
        public int? UlogaID { get; set; }

        //public List<int> UlogeIdList { get; set; }= new List<int>(){ };
    }
}
