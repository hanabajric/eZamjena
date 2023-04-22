using eZamjena.Model;
using eZamjena.Model.SearchObjects;
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
    
        public partial class frmKorisnici : Form
        {
            public APIService KorisnikService { get; set; } = new APIService("Korisnik");
            public frmKorisnici()
            {
                InitializeComponent();
                dgvKorisnici.AutoGenerateColumns = false;
        }

            private async void frmKorisnici_Load(object sender, EventArgs e)
            {

            await Ucitaj();

            }
        private async Task Ucitaj()
        {
            var searchObject = new KorisnikSearchObject();
            searchObject.KorisnickoIme = txtKorisničkoIme.Text;


            var lista = await KorisnikService.Get<List<Korisnik>>(searchObject);
            dgvKorisnici.DataSource = lista;
        }

        private async void button1_Click(object sender, EventArgs e)
        {
            
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
    }
}
