using eZamjena.Model;
using eZamjena.Model.Requests;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace eZamjena.WinUI
{
    public partial class frmArtikliDetails : Form
    {
        public APIService ProizvodService { get; set; } = new APIService("Proizvod");
        public APIService KategorijaService { get; set; } = new APIService("KategorijaProizvodum");
        private Proizvod _proizvod=null;
        public frmArtikliDetails(Proizvod proizvod=null)
        {
            InitializeComponent();
            _proizvod = proizvod;
            
        }

        private async void frmArtikliDetails_Load(object sender, EventArgs e)
        {
            await UcitajKategorije();
            if (_proizvod != null)
            {
            txtNaziv.Text = _proizvod.Naziv;
                txtCijena.Text = _proizvod.Cijena.ToString();
                txtKorisnik.Text = _proizvod.NazivKorisnika;
                txtOpis.Text = _proizvod.Opis;
                cbStanje.Checked = _proizvod.StanjeNovo;
                cmbKategorija.SelectedValue = _proizvod.KategorijaProizvodaId;

            }
        }
        private async Task UcitajKategorije()
        {
            var kategorije = await KategorijaService.Get<List<KategorijaProizvodum>>();
            
            System.Console.WriteLine("Ovo je kategorija->" + kategorije.Any());
            cmbKategorija.DataSource = kategorije;
            cmbKategorija.DisplayMember = "Naziv";
            cmbKategorija.ValueMember = "Id";
            //cmbKategorija.DisplayMember =_proizvod.NazivKategorijeProizvoda;
            // System.Console.WriteLine("Ovo je kategorija proizvoda->" + _proizvod.NazivKategorijeProizvoda);
        }

        private async void btnSpremi_Click(object sender, EventArgs e)
        {
            var Kategorija = cmbKategorija.SelectedValue as KategorijaProizvodum;
            ProizvodUpsertRequest updateRequest = new ProizvodUpsertRequest()
            {
                Naziv = txtNaziv.Text,
                Cijena=Convert.ToDecimal(txtCijena.Text),
                Opis=txtOpis.Text,
                StanjeNovo=cbStanje.Checked,
                KategorijaProizvodaId=Kategorija.Id
                
            };
            _proizvod = await ProizvodService.Put<Proizvod>(_proizvod.Id, updateRequest);
        }
    }
}
