using AutoMapper;
using eZamjena.Model;
using eZamjena.Services;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    public class BaseCRUDController<T, TSerach, TInsert, TUpdate> : BaseController<T, TSerach> where T : class where TSerach : class where TInsert : class where TUpdate : class
    {


        public BaseCRUDController(ICRUDService<T, TSerach, TInsert,TUpdate> service) : base(service)
        {

        }

        [HttpPost]
        public virtual T Insert([FromBody] TInsert insert)
        {
            var result = ((ICRUDService<T, TSerach, TInsert, TUpdate>)Service).Insert(insert);
            return result;
        }

        [HttpPut("{id}")]
        public virtual T Update(int id, [FromBody] TUpdate update)
        {
            var result = ((ICRUDService<T, TSerach, TInsert, TUpdate>)Service).Update(id, update);
            return result;
        }

        [HttpDelete("{id}")]
        public virtual T Delete(int id)
        {
            var result = ((ICRUDService<T, TSerach, TInsert, TUpdate>)Service).Delete(id);
            return result;
        }

        [HttpPatch("{id}")]
        public virtual IActionResult Patch(int id, [FromBody] JsonPatchDocument<TUpdate> patchDoc)
        {
            if (patchDoc == null)
            {
                return BadRequest("patchDoc is null");
            }

            var result = ((ICRUDService<T, TSerach, TInsert, TUpdate>)Service).Patch(id, patchDoc);
            if (result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }


    }

}
