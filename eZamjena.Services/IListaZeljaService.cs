using eZamjena.Model;
using eZamjena.Model.DTOs;
using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;

namespace eZamjena.Services
{
    public interface IListaZeljaService : ICRUDService<ListaZelja, ListaZeljaSearchObject, ListaZeljaUpsertRequest, ListaZeljaUpsertRequest>
    {

    }
}
