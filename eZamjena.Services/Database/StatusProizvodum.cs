using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class StatusProizvodum
    {
        public StatusProizvodum()
        {
            Proizvods = new HashSet<Proizvod>();
        }

        public int Id { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Proizvod> Proizvods { get; set; }
    }
}
