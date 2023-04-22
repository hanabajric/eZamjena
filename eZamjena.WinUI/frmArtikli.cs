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
        private string trenutnaKategorija = null;
        private List<string> _selectedCategories = new List<string>();
        private bool? _novo;
       
        public frmArtikli()
        {
            InitializeComponent();
            txtNaziv.TextChanged += txtNaziv_TextChanged_1;
            dgvArtikli.AutoGenerateColumns = false;
            // _novo = false;
        }

        private async void frmArtikli_Load(object sender, EventArgs e)
        {
            await UcitajPodatke();
        }

        private void btnTehnika_Click(object sender, EventArgs e)
        {
            SetTrenutnaKategorija("Tehnika");
            FilterByCategory("Tehnika");
        }

        private void btnOdjećaObuća_Click(object sender, EventArgs e)
        {
            SetTrenutnaKategorija("Odjeća i obuća");
            FilterByCategory("Odjeća i obuća");
        }

        private async void FilterByCategory(string category)
        {
            Button clickedButton = null;
            if (category == "Tehnika")
            {
                clickedButton = btnTehnika;
            }
            else if (category == "Odjeća i obuća")
            {
                clickedButton = btnOdjećaObuća;
            }
            // Dodajemo/uklanjamo odabranu kategoriju iz liste odabranih
            if (_selectedCategories.Contains(category) && clickedButton != null)
            {
                _selectedCategories.Remove(category);
                clickedButton.BackColor = Color.White;
            }
            else if (clickedButton != null)
            {
                _selectedCategories.Add(category);
                clickedButton.BackColor = Color.LightBlue;
            }
           
            // Kreiramo novi objekt za pretragu proizvoda
            var searchObject = new ProizvodSearchObject();

            // Dodajemo kategorije u pretragu
            if (_selectedCategories.Count > 0)
            {
                searchObject.NazivKategorijeList = _selectedCategories;
            }

            // Dodajemo naziv proizvoda u pretragu ako postoji
            if (!string.IsNullOrEmpty(txtNaziv.Text))
            {
                searchObject.Naziv = txtNaziv.Text;
            }
            if (_novo!=null)
            {
                searchObject.Novo = _novo;
            }

            // Pretražujemo proizvode i ažuriramo DataSource DataGridView kontrole
            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);

            //if (_selectedCategories.Count > 0)
            //{
            //    lista = lista.Where(p => _selectedCategories.Contains(p.KategorijaProizvoda.Naziv)).ToList();
            //}
            //if (_novo != null)
            //{
            //    lista = lista.Where(p => p.StanjeNovo == _novo).ToList();
            //}

            //if (!string.IsNullOrEmpty(txtNaziv.Text))
            //{
            //    lista = lista.Where(p => p.Naziv.ToLower().Contains(txtNaziv.Text.ToLower())).ToList();
            //}

            dgvArtikli.DataSource = lista;
        }

        
        private void SetTrenutnaKategorija(string kategorija)
        {
            if (trenutnaKategorija == kategorija)
            {
                trenutnaKategorija = null;
            }
            else
            {
                trenutnaKategorija = kategorija;
               
            }
        }
     
        private async Task UcitajPodatke()
        {
            var searchObject = new ProizvodSearchObject();

            // Dodajemo kategorije u pretragu
            if (_selectedCategories.Count > 0)
            {
                searchObject.NazivKategorijeList = _selectedCategories;
            }

            // Dodajemo naziv proizvoda u pretragu ako postoji
            if (!string.IsNullOrEmpty(txtNaziv.Text))
            {
                searchObject.Naziv = txtNaziv.Text;
            }
            if (_novo != null) 
            {
                searchObject.Novo = _novo;
            }
              
            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);
            dgvArtikli.DataSource = lista;
        }


        private async void txtNaziv_TextChanged_1(object sender, EventArgs e)
        {
            FilterByCategory(trenutnaKategorija);
            //await UcitajPodatke();
        }
        
      
        private async void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked) _novo = true;
            else _novo = false;
            //FilterByCategory(trenutnaKategorija);
            await UcitajPodatke();
        }

        private async void dgvArtikli_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            Proizvod? proizvod = dgvArtikli.SelectedRows[0].DataBoundItem as Proizvod;
            if (proizvod != null)
            {
                if (e.ColumnIndex == 5)
                {
                    frmArtikliDetails frm = new frmArtikliDetails(proizvod);
                    frm.ShowDialog();

                    await UcitajPodatke();
                }
            }
        }
        private void dgvArtikli_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            if (e.ColumnIndex == dgvArtikli.Columns["Slika"].Index && e.Value != null)
            {
                byte[] bytes = (byte[])e.Value;
                if (bytes.Length > 0)
                {
                    e.Value = Image.FromStream(new MemoryStream(bytes));
                }
                else
                {
                    Bitmap emptyImage = new Bitmap(100, 100);
                    using (Graphics g = Graphics.FromImage(emptyImage))
                    {
                        g.Clear(Color.White);
                    }
                    e.Value = emptyImage;
                }
            }
        }



    }
}
