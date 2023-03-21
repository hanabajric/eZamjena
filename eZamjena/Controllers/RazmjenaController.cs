using eZamjena.Services;
using eZamjena.Model;
using Microsoft.AspNetCore.Mvc;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Requests;


namespace eZamjena.Controllers
{
   
    public class RazmjenaController : BaseCRUDController<Model.Razmjena, RazmjenaSearchObject, RazmjenaUpsertRequest, RazmjenaUpsertRequest> 
    {
       
        public RazmjenaController(IRazmjenaService razmjenaService):base(razmjenaService)
        {
            
        }

       
    }
}
