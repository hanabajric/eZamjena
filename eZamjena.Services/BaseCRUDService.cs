using AutoMapper;
using eZamjena.Model;
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
            ValidateInsert(insert);
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
            ValidateUpdate(id, update);
            var set = Context.Set<TDb>();

            var entity = set.Find(id);
            if (entity != null)
            {
                Mapper.Map(update, entity);
                BeforeUpdate(entity, update);
            }
            else { return null; }

            Context.SaveChanges();

            return Mapper.Map<T>(entity);
        }
        public virtual void BeforeUpdate(TDb entity, TUpdate update) {
        }
        public virtual void BeforeDelete(int id) { }

        public virtual T Delete(int id)
        {
            ValidateDelete(id);
            var set = Context.Set<TDb>();

            var entity = set.Find(id);
            BeforeDelete(id);
            if (entity != null)
            {
                set.Remove(entity);
            }
            else { return null; }
            Context.SaveChanges();

            return Mapper.Map<T>(entity);
        }
      
        public virtual void ValidateInsert(TInsert insert) { }
        public virtual void ValidateUpdate(int id, TUpdate update) { }
        public virtual void ValidateDelete(int id)
        {
            if (Context.Set<TDb>().Find(id) == null)
                throw new UserException($"{typeof(TDb).Name} sa tim ID ne postoji!");
        }

    }
}
