using AutoMapper;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class KupovinaService : BaseCRUDService<Model.Kupovina,Database.Kupovina, KupovinaSearchObject, KupovinaUpsertRequest, KupovinaUpsertRequest>, IKupovinaService
    {
      
        public KupovinaService(Ib190019Context context, IMapper mapper):base(context,mapper)
        {
            
        }
        public override IQueryable<Kupovina> AddFilter(IQueryable<Kupovina> query, KupovinaSearchObject search = null)
        {
            var filteredQuery = base.AddFilter(query, search);

            if (search?.Datum!=null || search?.Datum.HasValue==true)
            {
                filteredQuery = filteredQuery.Where(x => x.Datum==search.Datum);
            }

     
           
            return filteredQuery;
        }
        //public IEnumerable<Model.Kupovina> Get()
        //{
        //    var result = Context.Kupovinas.ToList();
        //    return Mapper.Map<List<Model.Kupovina>>(result);
        //}
        //public Model.Kupovina GetById(int id)
        //{
        //    var result = Context.Kupovinas.Find(id);
        //    return Mapper.Map<Model.Kupovina>(result);
        //}
    }
   
}
