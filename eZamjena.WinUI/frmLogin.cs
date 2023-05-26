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
    public partial class frmLogin : Form
    {

        private bool lozinkaPrikazana = false;
        private bool potvrdaLozinkePrikazana = false;

        private readonly APIService _api = new APIService("Korisnik");
        public frmLogin()
        {
            InitializeComponent();
        }

        private void frmLogin_Load(object sender, EventArgs e)
        {
            pbLozinka.Image = Properties.Resources.eye_icon;
            pbLozinka.Click += PrikaziSakrijLozinku;
        }
        


        private async void btnLogin_Click_1(object sender, EventArgs e)
        {
            APIService.Username = txtUsername.Text;
            APIService.Password = txtPassword.Text;  

            try
            {
                var result = await _api.Get<dynamic>();

                MDIParent1 frm = new MDIParent1();
                frm.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Wrong username or password");
            }
        }

        private void linklblReistracija_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            frmRegistracija frm = new frmRegistracija();
            frm.ShowDialog();
        }
        private void PrikaziSakrijLozinku(object sender, EventArgs e)
        {
            lozinkaPrikazana = !lozinkaPrikazana;
            pbLozinka.Image = lozinkaPrikazana ? Properties.Resources.eye_slash_icon : Properties.Resources.eye_icon;
            txtPassword.UseSystemPasswordChar = !lozinkaPrikazana;
        }
    }
}
