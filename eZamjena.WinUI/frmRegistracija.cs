using eZamjena.Model;
using eZamjena.Model.Requests;
using eZamjena.Services;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace eZamjena.WinUI
{
    public partial class frmRegistracija : Form
    {
        private bool lozinkaPrikazana = false;
        private bool potvrdaLozinkePrikazana = false;
        public UlogaAPIService UlogaService { get; set; } = new UlogaAPIService("Uloga");
        public KorisnikAPIService KorisnikService { get; set; } = new KorisnikAPIService("Korisnik");
        private List<Uloga> uloga = new List<Uloga>();


        public frmRegistracija()
        {
            InitializeComponent();
        }

        private async void frmRegistracija_Load(object sender, EventArgs e)
        {
            pbLozinka.Image = Properties.Resources.eye_icon; 
            
            pbLozinkaPotvrda.Image = Properties.Resources.eye_icon; 

            pbLozinka.Click += PrikaziSakrijLozinku;
            pbLozinkaPotvrda.Click += PrikaziSakrijPotvrduLozinke;
            await UcitajUloge();
        }

        private async Task UcitajUloge()
        {
             uloga = await UlogaService.Get<List<Uloga>>();
        }

        private void PrikaziSakrijLozinku(object sender, EventArgs e)
        {
            lozinkaPrikazana = !lozinkaPrikazana;
            pbLozinka.Image = lozinkaPrikazana ? Properties.Resources.eye_slash_icon : Properties.Resources.eye_icon;
            txtLozinka.UseSystemPasswordChar = !lozinkaPrikazana;
        }

        private void PrikaziSakrijPotvrduLozinke(object sender, EventArgs e)
        {
            potvrdaLozinkePrikazana = !potvrdaLozinkePrikazana;
            pbLozinkaPotvrda.Image = potvrdaLozinkePrikazana ? Properties.Resources.eye_slash_icon : Properties.Resources.eye_icon;
            txtPotvrdaLozinke.UseSystemPasswordChar = !potvrdaLozinkePrikazana;
        }

        private async void btnRegistracija_Click(object sender, EventArgs e)
        {
            int ulogaID = 1;
            var ulogaAdministrator = uloga.FirstOrDefault(x => x.Naziv == "Administrator");
            if (ulogaAdministrator != null)
            {
                 ulogaID = ulogaAdministrator.Id;
                // Nastavite sa daljim korištenjem ulogaID
            }
          

            if (ValidateChildren())
            {
                KorisnikInsertRequest insertRequest = new KorisnikInsertRequest()
                {
                    Ime = txtIme.Text,
                    Prezime = txtPrezime.Text,
                    Email = txtEmail.Text,
                    Telefon = txtBrojTelefona.Text,
                    UlogaID = ulogaID,
                    KorisnickoIme = txtKorisnickoIme.Text,
                    Password = txtLozinka.Text,
                    PasswordPotvrda = txtPotvrdaLozinke.Text,
                    Slika = null,
                    BrojAktivnihArtikala = 0,
                    BrojKupovina = 0,
                    BrojRazmjena = 0,
                    Adresa = null,
                    GradID = null


                };
                if (insertRequest.Password != insertRequest.PasswordPotvrda)
                    MessageBox.Show("Lozinka i potvrda lozinke se trebaju podudarati!", "Error", MessageBoxButtons.OK, MessageBoxIcon.Hand);
                else
                {
                     await KorisnikService.Post<Korisnik>(insertRequest);
                    //if (response != null)
                    //{
                        MessageBox.Show("Reistracija uspješna! Sada se možete prijaviti", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information);
                        DialogResult = DialogResult.OK;
                    //}
                }
                //Close();
            }

        }

        private void txtIme_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtIme.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtIme, "Polje ime mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtIme, null);
            }
        }

        private void txtPrezime_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPrezime.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtPrezime, "Polje prezime mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtPrezime, null);
            }
        }

        private void txtKorisnickoIme_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtKorisnickoIme.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtKorisnickoIme, "Polje korisničko ime mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtKorisnickoIme, null);
            }
        }

        private void txtLozinka_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtLozinka.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtLozinka, "Polje lozinka mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtLozinka, null);
            }
        }

        private void txtPotvrdaLozinke_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtPotvrdaLozinke.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtPotvrdaLozinke, "Polje potvrda lozinke mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtPotvrdaLozinke, null);
            }
        }

        private void txtEmail_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtEmail, "Polje email mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtEmail, null);
            }
        }

        private void txtBrojTelefona_Validating(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtBrojTelefona.Text))
            {
                e.Cancel = true;
                txtIme.Focus();
                errorProvider1.SetError(txtBrojTelefona, "Polje email mora biti popunjeno!");
            }
            else
            {
                e.Cancel = false;
                errorProvider1.SetError(txtBrojTelefona, null);
            }
        }
    }
}
