using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.DTOs
{
    public class ListaZeljaDTO
    {
        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public DateTime CreatedAt { get; set; }
        public List<ListaZeljaProizvodDTO> ListaZeljaProizvods { get; set; }
    }

    public class ListaZeljaProizvodDTO
    {
        public int Id { get; set; }
        public int ProizvodId { get; set; }
        public DateTime VrijemeDodavanja { get; set; }
    }

}
