using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{


    public class GradController : BaseCRUDController<Model.Grad, GradSearchObject, GradUpsertRequest, GradUpsertRequest>
    {
        public GradController(IGradService service) : base(service)
        {
        }

        [AllowAnonymous]
        public override IEnumerable<Grad> Get([FromQuery] GradSearchObject search = null)
        {
            return base.Get(search);
        }

    }
}
