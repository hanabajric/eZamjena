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
    public partial class frmArtikli : Form
    {
        public APIService ProizvodService { get; set; } = new APIService("Proizvod");
        public frmArtikli()
        {
            InitializeComponent();
            txtNaziv.TextChanged += txtNaziv_TextChanged;
        }
    

        private  void btnProfili_Click(object sender, EventArgs e)
        {
            frmKorisnici frm = new frmKorisnici();
            frm.ShowDialog();
        }

        private async void frmArtikli_Load(object sender, EventArgs e)
        {
            //var searchObject = new ProizvodSearchObject();
            //searchObject.Naziv = txtNaziv.Text;


            //var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);
            //dgvArtikli.DataSource = lista;
            await UcitajPodatke();
        }

        private void btnTehnika_Click(object sender, EventArgs e)
        {
            FilterByCategory("Tehnika");
        }

        private void btnOdjećaObuća_Click(object sender, EventArgs e)
        {
            FilterByCategory("Odjeća i obuća");
        }

        private async void FilterByCategory(string category)
        {
            var searchObject = new ProizvodSearchObject();
            searchObject.NazivKategorije = category;
            if (!string.IsNullOrEmpty(txtNaziv.Text))
            {
                searchObject.Naziv = txtNaziv.Text;
            }
            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);
            dgvArtikli.DataSource = lista.Where(p => p.KategorijaProizvoda.Naziv == category).ToList();
        }


        private async Task UcitajPodatke()
        {
            var searchObject = new ProizvodSearchObject();
            searchObject.Naziv = txtNaziv.Text;
            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);
            dgvArtikli.DataSource = lista;
        }

        private async void btnArtikli_Click(object sender, EventArgs e)
        {
            await UcitajPodatke();
        }

        private async void txtNaziv_TextChanged(object sender, EventArgs e)
        {
            await UcitajPodatke();
        }
      
    }
}
