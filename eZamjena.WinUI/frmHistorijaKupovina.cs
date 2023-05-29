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
    public partial class frmHistorijaKupovina : Form
    {
        public APIService KupovinaService = new APIService("Kupovina");
        KupovinaSearchObject searchObject = new KupovinaSearchObject();
        private List<Kupovina> lista = new List<Kupovina>();
        public frmHistorijaKupovina()
        {
            InitializeComponent();
            dgvHistorijaKupovina.AutoGenerateColumns = false;
        }

        private async void frmHistorijaKupovina_Load(object sender, EventArgs e)
        {
            await UcitajPodatke();
        }

        private async  Task UcitajPodatke()
        {

           lista = await KupovinaService.Get<List<Kupovina>>(searchObject);
            dgvHistorijaKupovina.DataSource = lista;
        }

        private async void dtpOd_ValueChanged(object sender, EventArgs e)
        {
            searchObject.DatumOd = dtpOd.Value;
            await UcitajPodatke();
        }

        private async void dtpDo_ValueChanged(object sender, EventArgs e)
        {
            searchObject.DatumDo = dtpDo.Value;
            await UcitajPodatke();
        }

        private void btnKreirajIzvještaj_Click(object sender, EventArgs e)
        {
            if (lista.Count() != 0)
            {
                IzvještajKupovina izvještaj = new IzvještajKupovina(lista, dtpOd.Value, dtpDo.Value);
                izvještaj.ShowDialog();
            }
            else
            {
                MessageBox.Show("Trenutno nemate niti jednu kupovinu kako bi kreirali izvještaj.");
            }
        }
    }
}
