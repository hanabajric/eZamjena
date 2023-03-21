using eZamjena.Services;
using eZamjena.Model;
using Microsoft.AspNetCore.Mvc;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Requests;
using Microsoft.AspNetCore.Authorization;

namespace eZamjena.Controllers
{
    
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class KorisnikController : BaseCRUDController<Model.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {

        public KorisnikController(IKorisnikService korisnikService) : base(korisnikService)
        {

        }

        //[AllowAnonymous]
        [Authorize("Klijent")]
        public override Korisnik Insert([FromBody] KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }
        //[Authorize("Administrator")]
        public override IEnumerable<Korisnik> Get([FromQuery] KorisnikSearchObject search = null)
        {
            return base.Get(search);    
        }
        
    }
}

