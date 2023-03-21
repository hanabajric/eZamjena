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
    public class OcjenaController : BaseCRUDController<Model.Ocjena, OcjenaSearchObject, OcjenaUpsertRequest, OcjenaUpsertRequest>
    {
        public OcjenaController(IOcjenaService service) : base(service)
        {
        }
       
    }
}
