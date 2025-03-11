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
    public class ListaZeljaController : BaseCRUDController<Model.ListaZelja, ListaZeljaSearchObject, ListaZeljaUpsertRequest, ListaZeljaUpsertRequest>
    {
        public ListaZeljaController(IListaZeljaService service) : base(service)
        {

        }
       


    }
}
