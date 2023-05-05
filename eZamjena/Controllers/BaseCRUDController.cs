using eZamjena.Services;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    public class BaseCRUDController<T, TSerach, TInsert, TUpdade> : BaseController<T, TSerach> where T : class where TSerach : class where TInsert : class where TUpdade : class
   
    {
        public BaseCRUDController(ICRUDService<T, TSerach, TInsert, TUpdade> service) : base(service)
        {
        }

        [HttpPost]
        public virtual  T Insert ([FromBody] TInsert insert)
        {
            var result= ((ICRUDService < T, TSerach, TInsert, TUpdade>)this.Service).Insert(insert);

            return result;
        }

        [HttpPut("{id}")]
        public virtual T Update(int id,[FromBody] TUpdade update)
        {
            var result = ((ICRUDService<T, TSerach, TInsert, TUpdade>)this.Service).Update(id,update);

            return result;
        }
        [HttpDelete("{id}")]
        public  virtual T Delete(int id)
        {
            var result = ((ICRUDService<T, TSerach, TInsert, TUpdade>)this.Service).Delete(id);
            return result;
        }
    }
}

