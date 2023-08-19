using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Services;
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
    public partial class frmKorisniciDetails : Form
    {
        private Korisnik _korisnik = null;
        public APIService KorisnikService { get; set; } = new APIService("Korisnik");
        public APIService GradService { get; set; } = new APIService("Grad");
        public frmKorisniciDetails(Korisnik korisnik=null)
        {
            InitializeComponent();
            _korisnik = korisnik;
        }

        private void btnOdustani_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private async void frmKorisniciDetails_Load(object sender, EventArgs e)
        {
            label1.Text = $"Pregled / uređivanje podataka o korisniku\n - {_korisnik.Ime} {_korisnik.Prezime}";
            await UcitajGradove();
            if (_korisnik != null)
            {
                txtKorisnickoIme.Text = _korisnik.KorisnickoIme;
                txtImePrezime.Text = _korisnik.Ime + " " + _korisnik.Prezime;
                txtEmail.Text= _korisnik.Email;
                txtBrojTelefona.Text = _korisnik.Telefon;
                txtAdresa.Text = _korisnik.Adresa;
                txtBrojKupovina.Text = _korisnik.BrojKupovina.ToString();
                txtBrojRazmjena.Text = _korisnik.BrojRazmjena.ToString();
                txtBrojAktivnihArtikala.Text = _korisnik.BrojAktivnihArtikala.ToString();
                cmbGrad.SelectedValue = _korisnik.GradID;
                pbKorisnici.Image = ImageHelper.FromByteToImage(_korisnik.Slika);


            }
        }
        private async Task UcitajGradove()
        {
            var grad = await GradService.Get<List<Grad>>();


            cmbGrad.DataSource = grad;
            cmbGrad.DisplayMember = "Naziv";
            cmbGrad.ValueMember = "Id";

        }

        private async void btnSpremi_Click(object sender, EventArgs e)
        {
            if (ValidateChildren())
            {
                string imePrezime = txtImePrezime.Text;
                string[] dijelovi = imePrezime.Split(' ');

                string ime = dijelovi[0];
                string prezime = dijelovi.Length > 1 ? dijelovi[1] : "";

                KorisnikUpdateRequest updateRequest = new KorisnikUpdateRequest()
                {
                    Ime = ime,
                    Prezime=prezime,
                    Adresa=txtAdresa.Text,
                    BrojAktivnihArtikala= Convert.ToInt32(txtBrojAktivnihArtikala.Text),
                    BrojKupovina=Convert.ToInt32(txtBrojKupovina.Text),
                    BrojRazmjena= Convert.ToInt32(txtBrojRazmjena.Text),
                    Email=txtEmail.Text,
                    Telefon=txtBrojTelefona.Text,
                    GradId = (int)cmbGrad.SelectedValue,
                    Slika = ImageHelper.FromImageToByte(pbKorisnici.Image),
                    //UlogaId=_korisnik.UlogaID,
                 

                };

                _korisnik = await KorisnikService.Put<Korisnik>(_korisnik.Id, updateRequest);
                MessageBox.Show("Uspješno izmijenjeni podaci o proizvodu " + _korisnik.KorisnickoIme);
                DialogResult = DialogResult.OK;// da je sve okej 
                Close();
            }
        }

        private void txtImePrezime_Validating(object sender, CancelEventArgs e)
        {
            
                if (string.IsNullOrWhiteSpace(txtImePrezime.Text))
                {
                    e.Cancel = true;
                txtImePrezime.Focus();
                    errorProvider1.SetError(txtImePrezime, "Ime i prezime korisnika je obavezno polje!");
                }
                else
                {
                    e.Cancel = false;
                    errorProvider1.SetError(txtImePrezime, "");
                }
            
        }

        private void pbKorisnici_Click(object sender, EventArgs e)
        {
            try
            {
                if (openFileDialog1.ShowDialog() == DialogResult.OK)
                {
                    pbKorisnici.Image = Image.FromFile(openFileDialog1.FileName);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Greska -> {ex.Message}");
            }
        }

        private void cmbGrad_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
