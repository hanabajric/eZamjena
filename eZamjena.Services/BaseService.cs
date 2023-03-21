using AutoMapper;
using eZamjena.Model.SearchObjects;
using eZamjena.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eZamjena.Services
{
    public class BaseService<T, TDb, TSearch> :IService<T,TSearch> where T : class where TDb : class where TSearch : BaseSearchObject
    {
        public Ib190019Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public BaseService(Ib190019Context context, IMapper mapper)
        {
            Context = context;
            Mapper = mapper;
        }
        public virtual IEnumerable<T> Get(TSearch search=null)
        {
            var entity = Context.Set<TDb>().AsQueryable();

            entity=AddFilter(entity, search);

            if (search?.Page.HasValue==true && search?.PageSize.HasValue == true)
            {
                entity = entity.Take(search.Page.Value).Skip(search.PageSize.Value * search.Page.Value);
            }

            var list = entity.ToList();
            return Mapper.Map<IList<T>>(list);
        }
        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query, TSearch search = null)
        {
            return query;
        }
        public T GetById(int id)
        {
            var entity = Context.Set<TDb>();
            var result = entity.Find(id);
            return Mapper.Map<T>(result);
        }
    }
}
