using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services.Database
{
    public partial class ListaZelja
    {


        public int Id { get; set; }
        public int KorisnikId { get; set; }
        public DateTime CreatedAt { get; set; }

    
        public virtual Korisnik Korisnik { get; set; }
        public virtual ICollection<ListaZeljaProizvod> ListaZeljaProizvods { get; set; } = new HashSet<ListaZeljaProizvod>();
    }
}
