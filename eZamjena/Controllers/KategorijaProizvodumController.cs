using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    public class KategorijaProizvodumController : BaseCRUDController<Model.KategorijaProizvodum, KategorijaProizvodumSearchObject, KategorijaProizvodumUpsertRequest, KategorijaProizvodumUpsertRequest>
    {
        public KategorijaProizvodumController(IKategorijaProizvodumService service) : base(service)
        {
        }
        [AllowAnonymous]
        public override IEnumerable<KategorijaProizvodum> Get([FromQuery] KategorijaProizvodumSearchObject search = null)
        {
            return base.Get(search);
        }
        [AllowAnonymous]
        public override KategorijaProizvodum Insert([FromBody] KategorijaProizvodumUpsertRequest insert)
        {
            return base.Insert(insert);
        }
    }
}
