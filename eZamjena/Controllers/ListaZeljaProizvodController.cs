using eZamjena.Model.Requests;
using eZamjena.Model.SearchObjects;
using eZamjena.Services;
using Microsoft.AspNetCore.Mvc;

namespace eZamjena.Controllers
{
    public class ListaZeljaProizvodController : BaseCRUDController<Model.ListaZeljaProizvod, ListaZeljaProizvodSearchObject, ListaZeljaProizvodUpsertRequest, ListaZeljaProizvodUpsertRequest>
    {
        public ListaZeljaProizvodController(IListaZeljaProizvodService service) : base(service)
        {
        }
    }
}
