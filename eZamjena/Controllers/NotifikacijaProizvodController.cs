using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NotifikacijaProizvodController : ControllerBase
    {
        private readonly INotifikacijaProizvodService _service;

        public NotifikacijaProizvodController(INotifikacijaProizvodService service)
        {
            _service = service;
        }

        [HttpGet]
        public IEnumerable<Model.NotifikacijaProizvod> Get([FromQuery] NotifikacijaProizvodSearchObject search)
        {
            return _service.Get(search);
        }

        [HttpPost]
        public Model.NotifikacijaProizvod Insert([FromBody] NotifikacijaProizvodUpsertRequest request)
        {
            return _service.Insert(request);
        }

        [HttpPut("{id}")]
        public Model.NotifikacijaProizvod Update(int id, [FromBody] NotifikacijaProizvodUpsertRequest request)
        {
            return _service.Update(id, request);
        }
    }

}
