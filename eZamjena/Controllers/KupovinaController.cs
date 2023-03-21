using eZamjena.Services;
using eZamjena.Model;
using Microsoft.AspNetCore.Mvc;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Requests;

namespace eZamjena.Controllers
{
    
    public class KupovinaController : BaseCRUDController<Model.Kupovina,KupovinaSearchObject, KupovinaUpsertRequest, KupovinaUpsertRequest> //dok nemamo search object za ovo
    {
       // private readonly IKupovinaService _kupovinaService;
        public KupovinaController(IKupovinaService kupovinaService):base(kupovinaService)
        {
            //_kupovinaService = kupovinaService;
        }

        //[HttpGet]
        //public IEnumerable<Kupovina> Get()
        //{
            
        //    return _kupovinaService.Get();
        //}
        //[HttpGet("{id}")]
        //public Kupovina GetById(int id)
        //{

        //    return _kupovinaService.GetById(id);
        //}
    }
}
