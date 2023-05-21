using eZamjena.Model;
using Microsoft.Reporting.WinForms;
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
    public partial class IzvještajKorisnika : Form
    {
        private List<Korisnik> lista;

     

        public IzvještajKorisnika(List<Korisnik> lista)
        {
            this.lista = lista;
            InitializeComponent();
        }

        private void IzvještajKorisnika_Load(object sender, EventArgs e)
        {
            reportViewer1.LocalReport.ReportEmbeddedResource = "eZamjena.WinUI.Korisnici.rdlc";
            ReportDataSource rds = new ReportDataSource();
            rds.Name = "DataSet1";
            rds.Value = lista;

            reportViewer1.LocalReport.DataSources.Add(rds);
            reportViewer1.RefreshReport();
        }
    }
}
