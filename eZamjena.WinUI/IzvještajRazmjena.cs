using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using eZamjena.Model;
using Microsoft.Reporting.WinForms;

namespace eZamjena.WinUI
{
    public partial class IzvještajRazmjena : Form
    {
        private List<Razmjena> lista;
        private DateTime datumOd;
        private DateTime datumDo;

        public IzvještajRazmjena(List<Razmjena> lista)
        {

            this.lista = lista;

            InitializeComponent();
        }

        public IzvještajRazmjena(List<Razmjena> lista, DateTime value1, DateTime value2) : this(lista)
        {
            this.datumOd = value1;
            this.datumDo = value2;
        }

        private void IzvještajRazmjena_Load(object sender, EventArgs e)
        {
            ReportParameterCollection rpc = new ReportParameterCollection();
            if (datumOd.Date == DateTime.Today) {
                rpc.Add(new ReportParameter("DatumOd","-"));
            }
            else {
                rpc.Add(new ReportParameter("DatumOd", datumOd.ToString("dd/MM/yyyy")));
            }
          
            rpc.Add(new ReportParameter("DatumDo", datumDo.ToString("dd/MM/yyyy")));
            reportViewer1.LocalReport.ReportEmbeddedResource = "eZamjena.WinUI.HistorijaRazmjena.rdlc";
            ReportDataSource rds = new ReportDataSource();
            rds.Name = "DataSet1";
            rds.Value = lista;
            reportViewer1.LocalReport.SetParameters(rpc);
            reportViewer1.LocalReport.DataSources.Add(rds);
            reportViewer1.RefreshReport();

        }
    }
}
