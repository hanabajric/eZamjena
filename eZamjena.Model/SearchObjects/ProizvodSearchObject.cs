using System;
using System.Collections.Generic;
using System.Text;

namespace eZamjena.Model.SearchObjects
{
    public class ProizvodSearchObject : BaseSearchObject
    {
        public string Naziv { get; set; }
        public virtual KategorijaProizvodum Kategorija { get; set; }
        //public string NazivKategorije => Kategorija.Naziv; // Dodano novo svojstvo za dohvaćanje naziva kategorije
        public string NazivKategorije
        {
            get { return Kategorija?.Naziv; }
            set
            {
                if (Kategorija == null)
                {
                    Kategorija = new KategorijaProizvodum();
                }
                Kategorija.Naziv = value;
            }
        }
    }
}
