using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace eZamjena.Model.SearchObjects
{
    public class ProizvodSearchObject : BaseSearchObject
    {
        
        public string Naziv { get; set; }
        public virtual KategorijaProizvodum Kategorija { get; set; }
        public List<string> NazivKategorijeList { get; set; }
       public bool? Novo { get; set; }
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
        public List<KategorijaProizvodum> Kategorije { get; set; }
        public List<string> NaziviKategorija
        {
            get { return Kategorije?.Select(k => k.Naziv).ToList(); }

            set
            {
                if (Kategorije == null)
                {
                    Kategorije = new List<KategorijaProizvodum>();
                }
                Kategorije = value?.Select(naziv => new KategorijaProizvodum { Naziv = naziv }).ToList();
            }
        }
        public List<int> KategorijeIds
        {
            get { return Kategorije?.Select(k => k.Id).ToList(); }

            set
            {
                if (Kategorije == null)
                {
                    Kategorije = new List<KategorijaProizvodum>();
                }
                Kategorije = value?.Select(id => new KategorijaProizvodum { Id = id }).ToList();
            }
        }
    }
}
