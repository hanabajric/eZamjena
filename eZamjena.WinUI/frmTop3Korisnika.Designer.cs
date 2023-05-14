namespace eZamjena.WinUI
{
    partial class frmTop3Korisnika
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnKreirajIzvještaj = new System.Windows.Forms.Button();
            this.dgvKorisnici = new System.Windows.Forms.DataGridView();
            this.KorisničkoIme = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Grad = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Ulica = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojTelefona = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Email = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojRazmjena = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojKupovina = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojAktivnihArtikala = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.dgvKorisnici)).BeginInit();
            this.SuspendLayout();
            // 
            // btnKreirajIzvještaj
            // 
            this.btnKreirajIzvještaj.Location = new System.Drawing.Point(967, 393);
            this.btnKreirajIzvještaj.Name = "btnKreirajIzvještaj";
            this.btnKreirajIzvještaj.Size = new System.Drawing.Size(126, 29);
            this.btnKreirajIzvještaj.TabIndex = 5;
            this.btnKreirajIzvještaj.Text = "Kreiraj izvještaj";
            this.btnKreirajIzvještaj.UseVisualStyleBackColor = true;
            // 
            // dgvKorisnici
            // 
            this.dgvKorisnici.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvKorisnici.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.KorisničkoIme,
            this.Grad,
            this.Ulica,
            this.BrojTelefona,
            this.Email,
            this.BrojRazmjena,
            this.BrojKupovina,
            this.BrojAktivnihArtikala});
            this.dgvKorisnici.Location = new System.Drawing.Point(10, 56);
            this.dgvKorisnici.Name = "dgvKorisnici";
            this.dgvKorisnici.RowHeadersWidth = 51;
            this.dgvKorisnici.RowTemplate.Height = 29;
            this.dgvKorisnici.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvKorisnici.Size = new System.Drawing.Size(1083, 313);
            this.dgvKorisnici.TabIndex = 3;
            // 
            // KorisničkoIme
            // 
            this.KorisničkoIme.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.KorisničkoIme.DataPropertyName = "KorisnickoIme";
            this.KorisničkoIme.HeaderText = "Korisničko ime";
            this.KorisničkoIme.MinimumWidth = 6;
            this.KorisničkoIme.Name = "KorisničkoIme";
            this.KorisničkoIme.ReadOnly = true;
            // 
            // Grad
            // 
            this.Grad.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Grad.DataPropertyName = "NazivGrada";
            this.Grad.HeaderText = "Grad";
            this.Grad.MinimumWidth = 6;
            this.Grad.Name = "Grad";
            this.Grad.ReadOnly = true;
            // 
            // Ulica
            // 
            this.Ulica.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Ulica.DataPropertyName = "Adresa";
            this.Ulica.HeaderText = "Ulica";
            this.Ulica.MinimumWidth = 6;
            this.Ulica.Name = "Ulica";
            this.Ulica.ReadOnly = true;
            // 
            // BrojTelefona
            // 
            this.BrojTelefona.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BrojTelefona.DataPropertyName = "Telefon";
            this.BrojTelefona.HeaderText = "Broj telefona";
            this.BrojTelefona.MinimumWidth = 6;
            this.BrojTelefona.Name = "BrojTelefona";
            this.BrojTelefona.ReadOnly = true;
            // 
            // Email
            // 
            this.Email.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Email.DataPropertyName = "Email";
            this.Email.HeaderText = "Email";
            this.Email.MinimumWidth = 6;
            this.Email.Name = "Email";
            this.Email.ReadOnly = true;
            // 
            // BrojRazmjena
            // 
            this.BrojRazmjena.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BrojRazmjena.DataPropertyName = "BrojRazmjena";
            this.BrojRazmjena.HeaderText = "Broj razmjena";
            this.BrojRazmjena.MinimumWidth = 6;
            this.BrojRazmjena.Name = "BrojRazmjena";
            this.BrojRazmjena.ReadOnly = true;
            // 
            // BrojKupovina
            // 
            this.BrojKupovina.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BrojKupovina.DataPropertyName = "BrojKupovina";
            this.BrojKupovina.HeaderText = "Broj Kupovina";
            this.BrojKupovina.MinimumWidth = 6;
            this.BrojKupovina.Name = "BrojKupovina";
            this.BrojKupovina.ReadOnly = true;
            // 
            // BrojAktivnihArtikala
            // 
            this.BrojAktivnihArtikala.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.BrojAktivnihArtikala.DataPropertyName = "BrojAktivnihArtikala";
            this.BrojAktivnihArtikala.HeaderText = "Broj aktivnih artikala";
            this.BrojAktivnihArtikala.MinimumWidth = 6;
            this.BrojAktivnihArtikala.Name = "BrojAktivnihArtikala";
            this.BrojAktivnihArtikala.ReadOnly = true;
            // 
            // frmTop3Korisnika
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1149, 450);
            this.Controls.Add(this.btnKreirajIzvještaj);
            this.Controls.Add(this.dgvKorisnici);
            this.Name = "frmTop3Korisnika";
            this.Text = "frmTop3Korisnika";
            this.Load += new System.EventHandler(this.frmTop3Korisnika_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvKorisnici)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Button btnKreirajIzvještaj;
        private DataGridView dgvKorisnici;
        private DataGridViewTextBoxColumn KorisničkoIme;
        private DataGridViewTextBoxColumn Grad;
        private DataGridViewTextBoxColumn Ulica;
        private DataGridViewTextBoxColumn BrojTelefona;
        private DataGridViewTextBoxColumn Email;
        private DataGridViewTextBoxColumn BrojRazmjena;
        private DataGridViewTextBoxColumn BrojKupovina;
        private DataGridViewTextBoxColumn BrojAktivnihArtikala;
    }
}