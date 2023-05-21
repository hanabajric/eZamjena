using eZamjena.Model;
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
    public partial class frmTop3Korisnika : Form
    {
        public APIService KorisnikService { get; set; } = new APIService("Korisnik");
        private List<Korisnik> lista= new List<Korisnik>();
        private List<Korisnik> top3Korisnika = new List<Korisnik>();
        public frmTop3Korisnika()
        {
            InitializeComponent();
            dgvKorisnici.AutoGenerateColumns=false;
        }

        private async void frmTop3Korisnika_Load(object sender, EventArgs e)
        {
            await Ucitaj();
        }
        private async Task Ucitaj()
        {
          
            lista = await KorisnikService.Get<List<Korisnik>>();
            var sortiranaLista = lista.OrderByDescending(korisnik => korisnik.BrojKupovina + korisnik.BrojRazmjena + korisnik.BrojAktivnihArtikala).ToList();
            top3Korisnika = sortiranaLista.Take(3).ToList();
            dgvKorisnici.DataSource = top3Korisnika;

        }

        private void btnKreirajIzvještaj_Click(object sender, EventArgs e)
        {
            if (top3Korisnika.Count() != 0)
            {
                IzvještajTop3Korisnika frm = new IzvještajTop3Korisnika(top3Korisnika);

                frm.ShowDialog();
            }
            else
            {
                MessageBox.Show("Trenutno nemate niti jednu razmjenu kako bi kreirali izvještaj.");
            }
          
        }
    }
}
