using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class KorisnikInsertRequest
    {
        [Required(AllowEmptyStrings=false)]
        public string Ime { get; set; }

        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; } 
        public string Telefon { get; set; }

        [Required(AllowEmptyStrings = false)]
        [EmailAddress()]
        public string Email { get; set; }

        [Required(AllowEmptyStrings = false)]
        [MinLength(4)]
        public string KorisnickoIme { get; set; }
        public string Password { get; set; }
        public string PasswordPotvrda { get; set; }
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
