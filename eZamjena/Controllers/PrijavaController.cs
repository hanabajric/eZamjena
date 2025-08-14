using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    public class PrijavaController : BaseCRUDController<Model.Prijava, PrijavaSearchObject, PrijavaUpsertRequest, PrijavaUpsertRequest>
    {
        public PrijavaController(IPrijavaService service) : base(service)
        {
        }
    }
}
