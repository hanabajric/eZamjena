using System;
using System.Collections.Generic;

namespace eZamjena.Services.Database
{
    public partial class Razmjena
    {
        public int Id { get; set; }
        public DateTime? Datum { get; set; }
        public int? Proizvod1Id { get; set; }
        public int? Proizvod2Id { get; set; }
        public int? StatusRazmjeneId { get; set; }

        public virtual Proizvod? Proizvod1 { get; set; }
        public virtual Proizvod? Proizvod2 { get; set; }
        public virtual StatusRazmjene? StatusRazmjene { get; set; }
    }
}
