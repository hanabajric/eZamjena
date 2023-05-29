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
    public partial class IzvještajKupovina : Form
    {
        private List<Kupovina> lista;
        private DateTime datumOd;
        private DateTime datumDo;


        public IzvještajKupovina(List<Kupovina> lista, DateTime value1, DateTime value2)
        {
            InitializeComponent();
            this.lista = lista;
            this.datumOd = value1;
            this.datumDo = value2;
        }

        private void IzvještajKupovina_Load(object sender, EventArgs e)
        {
            ReportParameterCollection rpc = new ReportParameterCollection();
            if (datumOd.Date == DateTime.Today)
            {
                rpc.Add(new ReportParameter("DatumOd", "-"));
            }
            else
            {
                rpc.Add(new ReportParameter("DatumOd", datumOd.ToString("dd/MM/yyyy")));
            }

            rpc.Add(new ReportParameter("DatumDo", datumDo.ToString("dd/MM/yyyy")));
            reportViewer1.LocalReport.ReportEmbeddedResource = "eZamjena.WinUI.HistorijaKupovina.rdlc";
            ReportDataSource rds = new ReportDataSource();
            rds.Name = "DataSet1";
            rds.Value = lista;
            reportViewer1.LocalReport.SetParameters(rpc);
            reportViewer1.LocalReport.DataSources.Add(rds);
            reportViewer1.RefreshReport();
        }
    }
}
