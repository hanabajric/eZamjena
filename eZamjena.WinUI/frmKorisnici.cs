using eZamjena.Model;
using eZamjena.Model.SearchObjects;
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
    
        public partial class frmKorisnici : Form
        {
            public APIService KorisnikService { get; set; } = new APIService("Korisnik");
            private List<Korisnik> lista = new List<Korisnik>();
            private List<Grad> grad = new List<Grad>();
      
            private KorisnikSearchObject searchObject = new KorisnikSearchObject();
        
            public APIService GradService { get; set; } = new APIService("Grad");
        public APIService UlogaService { get; set; } = new APIService("Uloga");
        public frmKorisnici()
            {
                InitializeComponent();
                dgvKorisnici.AutoGenerateColumns = false;
        }
     
        private async void frmKorisnici_Load(object sender, EventArgs e)
            {

            
            await UcitajGradove();
            await UcitajUloge();
            await Ucitaj();

            }

        private async Task UcitajUloge()
        {
            var uloga = await UlogaService.Get<List<Uloga>>();
            cmbUloga.DataSource = uloga;
            cmbUloga.DisplayMember = "Naziv";

        }

        private async Task UcitajGradove()
        {
            var grad = await GradService.Get<List<Grad>>();

            // Dodaj "Svi gradovi" na početak liste
            grad.Insert(0, new Grad { Id = -1, Naziv = "Svi gradovi" });
            cmbGrad.DataSource = grad;
            cmbGrad.DisplayMember = "Naziv";
            cmbGrad.ValueMember = "Id";
            cmbGrad.Text = "Izaberi grad";
            //if (cmbGrad.Items.Count > 1)
            //{
            //    cmbGrad.SelectedValue = -1;//SelectedIndex
            //}

        }
        private async Task Ucitaj()
        {
            searchObject.KorisnickoIme = txtKorisničkoIme.Text;
            //searchObject.GradID = (int)cmbGrad.SelectedValue;

            //var gradidpomocni = cmbGrad.SelectedValue;
            //var type = cmbGrad.SelectedValue?.GetType();
            //
            //Debug.WriteLine("ovo je tip "+type);
            lista = await KorisnikService.Get<List<Korisnik>>(searchObject);
            //var odabranaLista = lista.Where(x => x.Grad == gradidpomocni);
            //Debug.WriteLine("Ovo su članovi odabrane liste. "+odabranaLista.Count());
            dgvKorisnici.DataSource = lista;
        }

      

        private async void dgvKorisnici_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            Korisnik? korisnik = dgvKorisnici.SelectedRows[0].DataBoundItem as Korisnik;
            if (korisnik != null)
            {
                if (e.ColumnIndex == 8)
                {
                    frmKorisniciDetails frm = new frmKorisniciDetails(korisnik);
                    frm.ShowDialog();

                    await Ucitaj();
                }
            }
        }

        private async void txtKorisničkoIme_TextChanged(object sender, EventArgs e)
        {
            searchObject.KorisnickoIme = txtKorisničkoIme.Text;
            await Ucitaj();
        }

        private void btnIzvještaj_Click(object sender, EventArgs e)
        {
            if (lista.Count() != 0)
            {
                IzvještajKorisnika izvještaj = new IzvještajKorisnika(lista);
                izvještaj.ShowDialog();
            }
            else
            {
                MessageBox.Show("Trenutno nemate niti jednu razmjenu kako bi kreirali izvještaj.");
            }
        }

        private async void cmbGrad_SelectedIndexChanged(object sender, EventArgs e)
        {


            //searchObject.GradID = cmbGrad.SelectedIndex ;
            //await Ucitaj();
        }

        private async void cmbGrad_SelectionChangeCommitted(object sender, EventArgs e)
        {
            lista = await KorisnikService.Get<List<Korisnik>>(searchObject);
            if(cmbGrad.SelectedIndex != 0)
            dgvKorisnici.DataSource = lista.Where(x => x.GradID == cmbGrad.SelectedIndex).ToList();
            else if(cmbGrad.SelectedIndex == 0)
                dgvKorisnici.DataSource = lista;



        }
    }
}
