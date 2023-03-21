using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{


    public class UlogaController : BaseCRUDController<Model.Uloga, UlogaSearchObject, UlogaUpsertRequest, UlogaUpsertRequest>
    {
        public UlogaController(IUlogaService service) : base(service)
        {
        }
       
    }
}
