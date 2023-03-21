using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class StatusRazmjene
    {
        public StatusRazmjene()
        {
            Razmjenas = new HashSet<Razmjena>();
        }

        public int Id { get; set; }
        public string? Naziv { get; set; }

        public virtual ICollection<Razmjena> Razmjenas { get; set; }
    }
}
