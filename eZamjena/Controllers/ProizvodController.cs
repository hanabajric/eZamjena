using eZamjena.Services;
using eZamjena.Model;
using Microsoft.AspNetCore.Mvc;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Requests;

namespace eZamjena.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProizvodController : BaseCRUDController<Model.Proizvod,ProizvodSearchObject,ProizvodUpsertRequest, ProizvodUpsertRequest>
    {
        
        public ProizvodController(IProizvodService proizvodService):base(proizvodService)
        {
           
        }

       
    }
}
