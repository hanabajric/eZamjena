using eZamjena.Model;
using eZamjena.Model.Requests;
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
    public partial class frmZahtjevi : Form
    {
        public APIService ProizvodService { get; set; } = new APIService("Proizvod");
        public APIService StatusProizvodaService { get; set; } = new APIService("StatusProizvodum");
        private string trenutnaKategorija = null;
        private List<string> _selectedCategories = new List<string>();
        private bool? _novo;
     

        public frmZahtjevi()
        {
            InitializeComponent();
            dgvZahtjevi.AutoGenerateColumns = false;
        }

        private async void frmZahtjevi_Load(object sender, EventArgs e)
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
            var statusi = await StatusProizvodaService.Get<List<StatusProizvodum>>();
            var status = statusi.FirstOrDefault(x => x.Naziv == "Na čekanju");
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

         
            if (_novo != null)
            {
                searchObject.Novo = _novo;
            }

            // Pretražujemo proizvode i ažuriramo DataSource DataGridView kontrole
            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);

            if (status != null)
                dgvZahtjevi.DataSource = lista.Where(x => x.StatusProizvodaId == status.Id).ToList();
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
            var statusi = await StatusProizvodaService.Get<List<StatusProizvodum>>();
            var status = statusi.FirstOrDefault(x => x.Naziv == "Na čekanju");

            // Dodajemo kategorije u pretragu
            if (_selectedCategories.Count > 0)
            {
                searchObject.NazivKategorijeList = _selectedCategories;
            }

           
            if (_novo != null)
            {
                searchObject.Novo = _novo;
            }

            var lista = await ProizvodService.Get<List<Proizvod>>(searchObject);
            if(status!=null)
            dgvZahtjevi.DataSource = lista.Where(x => x.StatusProizvodaId==status.Id).ToList();
        }

        private async void dgvZahtjevi_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            Proizvod? proizvod = dgvZahtjevi.SelectedRows[0].DataBoundItem as Proizvod;
            var statusi = await StatusProizvodaService.Get<List<StatusProizvodum>>();
            var status = statusi.FirstOrDefault(x => x.Naziv == "U prodaji");
            if (proizvod != null)
            {
                if (e.ColumnIndex == 6)
                {
                    if (status != null)
                    {
                        ProizvodUpsertRequest update = new ProizvodUpsertRequest()
                        {

                            StatusProizvodaId = status.Id,
                            Cijena= (decimal)proizvod.Cijena,
                            KategorijaProizvodaId= proizvod.KategorijaProizvodaId,
                            KorisnikId=proizvod.KorisnikId,
                            Naziv=proizvod.Naziv,
                            Opis=proizvod.Opis,
                            Slika=proizvod.Slika,
                            StanjeNovo=proizvod.StanjeNovo
                   

                           
                        };
                        System.Console.WriteLine("OVO JE ID STATUSA PROIZVODA" + update.StatusProizvodaId);
                        proizvod = await ProizvodService.Put<Proizvod>(proizvod.Id, update);
                        MessageBox.Show("Uspješno odobren zatjev");
                        DialogResult = DialogResult.OK;// da je sve okej 
                        Close();
                    }
                    else
                    {
                        MessageBox.Show("Status nije pronadjen status proizvoda.");
                    }
                }
                if (e.ColumnIndex == 7)
                    {
                        await ProizvodService.Delete<Proizvod>(proizvod.Id);
                        MessageBox.Show("Uspješno odbijen zatjev");
                        DialogResult = DialogResult.OK;// da je sve okej 
                        Close();
                    }

                        await UcitajPodatke();
                
            }
        }

        private async void btnPrivatiSve_Click(object sender, EventArgs e)
        {
            List < Proizvod > listaZahtjeva = new List<Proizvod>();
            var statusi = await StatusProizvodaService.Get<List<StatusProizvodum>>();
            var status = statusi.FirstOrDefault(x => x.Naziv == "U prodaji");
           
            foreach (DataGridViewRow red in dgvZahtjevi.Rows)
            {
                
                    Proizvod zahtjev = (Proizvod)red.DataBoundItem;
                    listaZahtjeva.Add(zahtjev);
                
            }
            
            Debug.WriteLine("OVO JE BROJ REDOVA U DGV-U : " + listaZahtjeva.Count());
            if (listaZahtjeva.Count == 0)
            {
                MessageBox.Show("Lista zahtjeva je prazna.");
            }
            else
            {
                DialogResult result = MessageBox.Show("Da li ste sigurni da želite prihvatiti sve zahtjeve?", "Potvrda", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    foreach (Proizvod proizvod in listaZahtjeva)
                    {
                        if (status != null)
                        {
                            ProizvodUpsertRequest update = new ProizvodUpsertRequest()
                            {

                                StatusProizvodaId = status.Id,
                                Cijena = (decimal)proizvod.Cijena,
                                KategorijaProizvodaId = proizvod.KategorijaProizvodaId,
                                KorisnikId = proizvod.KorisnikId,
                                Naziv = proizvod.Naziv,
                                Opis = proizvod.Opis,
                                Slika = proizvod.Slika,
                                StanjeNovo = proizvod.StanjeNovo



                            };
                            await ProizvodService.Put<Proizvod>(proizvod.Id, update);
                        }

                    }

                    MessageBox.Show("Uspješno odobreni zatjevi");
                    DialogResult = DialogResult.OK;// da je sve okej 
                   
                }
              

                await UcitajPodatke();
            }
        }
        
        private async void btnOdbijSve_Click(object sender, EventArgs e)
        {
            List<Proizvod> listaZahtjeva = new List<Proizvod>();
            foreach (DataGridViewRow red in dgvZahtjevi.Rows)
            {

                Proizvod zahtjev = (Proizvod)red.DataBoundItem;
                listaZahtjeva.Add(zahtjev);

            }
            if (listaZahtjeva.Count == 0)
            {
                MessageBox.Show("Lista zahtjeva je prazna.");
            }
            else
            {
                DialogResult result = MessageBox.Show("Da li ste sigurni da želite odbiti sve zahtjeve?", "Potvrda", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

                if (result == DialogResult.Yes)
                {
                    foreach (Proizvod proizvod in listaZahtjeva)
                    {
                        
                            await ProizvodService.Delete<Proizvod>(proizvod.Id);
                       
                    }

                    MessageBox.Show("Uspješno obrisani zatjevi");
                    DialogResult = DialogResult.OK;// da je sve okej 
                    
                }
                await UcitajPodatke();
            }
        }
    }
}
