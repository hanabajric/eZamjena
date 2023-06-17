using eZamjena.Services;
using eZamjena.Model;
using Microsoft.AspNetCore.Mvc;
using eZamjena.Model.SearchObjects;
using eZamjena.Model.Requests;
using Microsoft.AspNetCore.Authorization;
using eZamjena.Model.Utils;
using eZamjena.Utils;

namespace eZamjena.Controllers
{
    
    [ApiController]
    [Route("[controller]")]
    [Authorize]
    public class KorisnikController : BaseCRUDController<Model.Korisnik, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        public readonly IKorisnikService korisnikService;
        public KorisnikController(IKorisnikService korisnikService) : base(korisnikService)
        {
            this.korisnikService = korisnikService;
        }

        [AllowAnonymous]
        public override Korisnik Insert([FromBody] KorisnikInsertRequest insert)
        {
            return base.Insert(insert);
        }
        //[Authorize("Administrator")]
        public override IEnumerable<Korisnik> Get([FromQuery] KorisnikSearchObject search = null)
        {
            return base.Get(search);    
        }
       
        [HttpGet("user-role")]
        public Task<LoggedUser> GetUserRole()
        {
            Credentials credentials = CredentialsParser.ParseCredentials(Request);
            return korisnikService.GetUserRole(credentials.Username, credentials.Password);
        }

    }
}

