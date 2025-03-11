using AutoMapper;
using Azure.Core;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class NotifikacijaProizvodService : BaseCRUDService<Model.NotifikacijaProizvod, Database.NotifikacijaProizvod, NotifikacijaProizvodSearchObject, NotifikacijaProizvodUpsertRequest, NotifikacijaProizvodUpsertRequest>, INotifikacijaProizvodService
    {
        public NotifikacijaProizvodService(Ib190019Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override Model.NotifikacijaProizvod Insert(NotifikacijaProizvodUpsertRequest insert)
        {
            
            insert.VrijemeKreiranja = DateTime.Now;

            var insertedEntity = base.Insert(insert);

            return Mapper.Map<Model.NotifikacijaProizvod>(insertedEntity);
        }


    }
}
