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
       
       private readonly APIService _api = new APIService("Korisnik");
        public frmLogin()
        {
            InitializeComponent();
        }

        private void frmLogin_Load(object sender, EventArgs e)
        {

        }
        

        //private async void btnLogin_Click(object sender, EventArgs e)
        //{
        //    APIService.Username = txtUsername.Text;
        //    APIService.Password = txtPassword.Text;

        //    try
        //    {
        //        var result = await _api.Get<dynamic>();

        //        frmKorisnici frm = new frmKorisnici();
        //        frm.Show();
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show("Wrong username or password");
        //    }
        //}

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
    }
}
