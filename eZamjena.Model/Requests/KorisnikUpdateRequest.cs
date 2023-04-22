using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class KorisnikUpdateRequest
    {
        [Required(AllowEmptyStrings = false)]
        public string Ime { get; set; }
        [Required(AllowEmptyStrings = false)]
        public string Prezime { get; set; }
        public string Telefon { get; set; }
        public string Email { get; set; }
   
        public string Password { get; set; }
        public int? BrojKupovina { get; set; }
        public int? BrojRazmjena { get; set; }
        public int? BrojAktivnihArtikala { get; set; }
        public string Adresa { get; set; }
        public byte[] Slika { get; set; }
        public int? GradId { get; set; }
        public int? UlogaId { get; set; }
    }
}
