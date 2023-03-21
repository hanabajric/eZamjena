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
            var searchObject = new KorisnikSearchObject();
            searchObject.KorisnickoIme = txtKorisničkoIme.Text;


            var lista = await KorisnikService.Get<List<Korisnik>>(searchObject);
            dgvKorisnici.DataSource = lista;


        }

        private async void button1_Click(object sender, EventArgs e)
        {
            
        }
    }
}
