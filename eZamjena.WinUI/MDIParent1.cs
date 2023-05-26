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
    public partial class MDIParent1 : Form
    {
     

        public MDIParent1()
        {
            InitializeComponent();
        }

    
        private void OpenForm(Form frm)
        {
            if (!MdiChildren.Select(f => f.Name).Contains(frm.Name))
            {
                foreach (Form childForm in MdiChildren)
                {
                    childForm.Close();
                }

                frm.MdiParent = this;

                frm.ControlBox = false;
                frm.WindowState = FormWindowState.Maximized;
                frm.FormBorderStyle = FormBorderStyle.None;
                frm.Dock = DockStyle.Fill;

                frm.Show();
            }
        }
        private void artikli_Click(object sender, EventArgs e)
        {
            frmArtikli frm = new frmArtikli();
            OpenForm(frm);
        }

        private void zahtjevi_Click(object sender, EventArgs e)
        {
            frmZahtjevi frm = new frmZahtjevi();
            OpenForm(frm);
        }

        private void historijaRazmjena_Click(object sender, EventArgs e)
        {
            frmHistorijaRazmjena frm = new frmHistorijaRazmjena();
            OpenForm(frm);
        }

        private void profili_Click(object sender, EventArgs e)
        {

        }


        private void MDIParent1_Load(object sender, EventArgs e)
        {
            frmArtikli frm = new frmArtikli();
            OpenForm(frm);
        }

        private void profiliToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void sviProfili_Click(object sender, EventArgs e)
        {
            frmKorisnici frm = new frmKorisnici();
            OpenForm(frm);
        }

        private void top3Profila_Click(object sender, EventArgs e)
        {
            frmTop3Korisnika frm = new frmTop3Korisnika();
            OpenForm(frm);
        }

        private void odjava_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Da li ste sigurni da želite da se odjavite?", "Question", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.Yes)
                Application.Restart();
        }
    }
}
