using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{

    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class StatusProizvodumController : BaseCRUDController<Model.StatusProizvodum, StatusProizvodumSearchObject, StatusProizvodumUpsertRequest, StatusProizvodumUpsertRequest>
    {
        public StatusProizvodumController(IStatusProizvodumService service) : base(service)
        {
        }
       
    }
}
