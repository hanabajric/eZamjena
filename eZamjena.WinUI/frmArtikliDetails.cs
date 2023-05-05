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
            label1.Text = $"Pregled / uređivanje podataka o artiklu\n - {_proizvod.Naziv}";

            await UcitajKategorije();
            if (_proizvod != null)
            {
            txtNaziv.Text = _proizvod.Naziv;
                txtCijena.Text = _proizvod.Cijena.ToString();
                txtKorisnik.Text = _proizvod.NazivKorisnika;
                txtOpis.Text = _proizvod.Opis;
                cbStanje.Checked = _proizvod.StanjeNovo;
                cmbKategorija.SelectedValue = _proizvod.KategorijaProizvodaId;
                 pbSlikaArtikla.Image = ImageHelper.FromByteToImage(_proizvod.Slika);

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
            if (ValidateChildren())
            {

                var korisnik = _proizvod.KorisnikId;
                var status = _proizvod.StatusProizvodaId;
                ProizvodUpsertRequest updateRequest = new ProizvodUpsertRequest()
                {
                    Naziv = txtNaziv.Text,
                    Cijena = Convert.ToDecimal(txtCijena.Text),
                   
                    StanjeNovo = cbStanje.Checked,
                    Opis = txtOpis.Text,
                    Slika = ImageHelper.FromImageToByte(pbSlikaArtikla.Image),
                    KorisnikId = korisnik,
                    StatusProizvodaId = status,
                    KategorijaProizvodaId = (int)cmbKategorija.SelectedValue
                   
                 

            };
               
                _proizvod = await ProizvodService.Put<Proizvod>(_proizvod.Id, updateRequest);
                MessageBox.Show("Uspješno izmijenjeni podaci o proizvodu "+_proizvod.Naziv);
                DialogResult = DialogResult.OK;// da je sve okej 
                Close();
            }
           
        }

        private void txtNaziv_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNaziv.Text))
            {
                e.Cancel = true;
                txtNaziv.Focus();
                errorProvider1.SetError(txtNaziv, "Naziv proizvoda je obavezno polje!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtNaziv, "");
            }
        }

        

        private void pbSlikaArtikla_Click(object sender, EventArgs e)
        {
            try
            {
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    pbSlikaArtikla.Image = Image.FromFile(openFileDialog1.FileName);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Greska -> {ex.Message}");
            }
        }

        private void btnOdustani_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
