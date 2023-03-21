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
    public class BaseCRUDService<T, TDb, TSearch, TInsert, TUpdate> 
        : BaseService<T, TDb, TSearch>, ICRUDService<T, TSearch, TInsert, TUpdate> 
        where T : class where TDb : class where TSearch : BaseSearchObject where TInsert : class where TUpdate : class
    {

        public BaseCRUDService(Ib190019Context context, IMapper mapper) : base(context, mapper) { }

        public virtual T Insert(TInsert insert)
        {
            var set = Context.Set<TDb>();
            TDb entity= Mapper.Map<TDb>(insert); // mapiramo insert objekat u bazu

            set.Add(entity);
            BeforeInsert(insert, entity);
            Context.SaveChanges();

            return Mapper.Map<T>(entity);
        }
        public virtual void BeforeInsert(TInsert insert ,TDb entity)
        {
           
        }

        public virtual T Update(int id, TUpdate update)
        {
            var set = Context.Set<TDb>();

            var entity = set.Find(id);
            if (entity != null)
            {
                Mapper.Map(update, entity); // mapiramo insert objekat u bazu
            }
            else { return null; }

           // set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<T>(entity);
        }
    }
}
