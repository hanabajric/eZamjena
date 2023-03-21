using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.Requests
{
    public class RazmjenaUpsertRequest
    {
        public DateTime? Datum { get; set; }
        public int? Proizvod1Id { get; set; }
        public int? Proizvod2Id { get; set; }
        public int? StatusRazmjeneId { get; set; }


    }
}
