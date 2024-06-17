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
        private IProizvodService _proizvodService;

        public ProizvodController(IProizvodService proizvodService):base(proizvodService)
        {

            _proizvodService=proizvodService;


        }
        [HttpGet("Recommend/{userId}")]
        public ActionResult<IEnumerable<Model.Proizvod>> RecommendProducts(int userId)
        {
            try
            {
                var products = _proizvodService.RecommendProducts(userId);
                if (products == null || !products.Any())
                {
                    return NotFound("No recommended products found.");
                }
                return Ok(products);
            }
            catch (Exception ex)
            {
                return StatusCode(500, "An error occurred while fetching recommended products. " + ex.Message);
            }
        }
    }
}