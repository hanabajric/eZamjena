using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model
{
    public partial class ListaZeljaProizvod
    {

        public int Id { get; set; }
        public int ListaZeljaId { get; set; }
        public int ProizvodId { get; set; }
        public DateTime VrijemeDodavanja { get; set; }

        public virtual ListaZelja ListaZelja { get; set; }
        public virtual Proizvod Proizvod { get; set; }
    }
}
