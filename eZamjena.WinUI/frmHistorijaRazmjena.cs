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
    public partial class frmHistorijaRazmjena : Form
    {
        public APIService RazmjenaService { get; set; } = new APIService("Razmjena");
        RazmjenaSearchObject searchObject = new RazmjenaSearchObject();
        private List<Razmjena> lista = new List<Razmjena>();

        public frmHistorijaRazmjena()
        {
            InitializeComponent();
            dgvHistorijaRazmjena.AutoGenerateColumns = false;
        }

        private void dgvHistorijaRazmjena_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private async void frmHistorijaRazmjena_Load(object sender, EventArgs e)
        {
            await UcitajPodatke();
        }
        private async Task UcitajPodatke()
        {
           
             lista = await RazmjenaService.Get<List<Razmjena>>(searchObject);
            dgvHistorijaRazmjena.DataSource = lista;
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
                IzvještajRazmjena izvještaj = new IzvještajRazmjena(lista,dtpOd.Value,dtpDo.Value);
                izvještaj.ShowDialog();
            }
            else
            {
                MessageBox.Show("Trenutno nemate niti jednu razmjenu kako bi kreirali izvještaj.");
            }
        }
    }
}
