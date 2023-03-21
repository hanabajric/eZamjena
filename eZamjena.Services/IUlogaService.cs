using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public interface IUlogaService : ICRUDService<Uloga, UlogaSearchObject, UlogaUpsertRequest, UlogaUpsertRequest>
    {
    }
}
