using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{


    public class StatusRazmjeneController : BaseCRUDController<Model.StatusRazmjene, StatusRazmjeneSearchObject, StatusRazmjeneUpsertRequest, StatusRazmjeneUpsertRequest>
    {
        public StatusRazmjeneController(IStatusRazmjeneService service) : base(service)
        {
        }
       
    }
}
