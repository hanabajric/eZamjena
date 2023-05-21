namespace eZamjena.WinUI
{
    partial class frmKorisnici
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
            this.dgvKorisnici = new System.Windows.Forms.DataGridView();
            this.KorisničkoIme = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Grad = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Ulica = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojTelefona = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Email = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojRazmjena = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojKupovina = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.BrojAktivnihArtikala = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Uredi = new System.Windows.Forms.DataGridViewButtonColumn();
            this.Obriši = new System.Windows.Forms.DataGridViewButtonColumn();
            this.txtKorisničkoIme = new System.Windows.Forms.TextBox();
            this.btnUčitaj = new System.Windows.Forms.Button();
            this.btnIzvještaj = new System.Windows.Forms.Button();
            this.cmbGrad = new System.Windows.Forms.ComboBox();
            ((System.ComponentModel.ISupportInitialize)(this.dgvKorisnici)).BeginInit();
            this.SuspendLayout();
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
            this.BrojAktivnihArtikala,
            this.Uredi,
            this.Obriši});
            this.dgvKorisnici.Location = new System.Drawing.Point(12, 116);
            this.dgvKorisnici.Name = "dgvKorisnici";
            this.dgvKorisnici.RowHeadersWidth = 51;
            this.dgvKorisnici.RowTemplate.Height = 29;
            this.dgvKorisnici.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvKorisnici.Size = new System.Drawing.Size(1178, 313);
            this.dgvKorisnici.TabIndex = 0;
            this.dgvKorisnici.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvKorisnici_CellContentClick);
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
            // Uredi
            // 
            this.Uredi.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Uredi.DataPropertyName = "Uredi";
            this.Uredi.HeaderText = "Uredi";
            this.Uredi.MinimumWidth = 6;
            this.Uredi.Name = "Uredi";
            this.Uredi.ReadOnly = true;
            this.Uredi.Text = "🖊️";
            this.Uredi.UseColumnTextForButtonValue = true;
            // 
            // Obriši
            // 
            this.Obriši.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Obriši.DataPropertyName = "Obriši";
            this.Obriši.HeaderText = "Obriši";
            this.Obriši.MinimumWidth = 6;
            this.Obriši.Name = "Obriši";
            this.Obriši.ReadOnly = true;
            this.Obriši.Text = "🗑";
            this.Obriši.UseColumnTextForButtonValue = true;
            // 
            // txtKorisničkoIme
            // 
            this.txtKorisničkoIme.ForeColor = System.Drawing.SystemColors.WindowFrame;
            this.txtKorisničkoIme.Location = new System.Drawing.Point(487, 71);
            this.txtKorisničkoIme.Name = "txtKorisničkoIme";
            this.txtKorisničkoIme.PlaceholderText = "🔍 pretraži po korisničkom imenu";
            this.txtKorisničkoIme.Size = new System.Drawing.Size(245, 27);
            this.txtKorisničkoIme.TabIndex = 1;
            this.txtKorisničkoIme.TextChanged += new System.EventHandler(this.txtKorisničkoIme_TextChanged);
            // 
            // btnUčitaj
            // 
            this.btnUčitaj.Location = new System.Drawing.Point(1096, 69);
            this.btnUčitaj.Name = "btnUčitaj";
            this.btnUčitaj.Size = new System.Drawing.Size(94, 29);
            this.btnUčitaj.TabIndex = 2;
            this.btnUčitaj.Text = "Učitaj";
            this.btnUčitaj.UseVisualStyleBackColor = true;
            // 
            // btnIzvještaj
            // 
            this.btnIzvještaj.Location = new System.Drawing.Point(1052, 479);
            this.btnIzvještaj.Name = "btnIzvještaj";
            this.btnIzvještaj.Size = new System.Drawing.Size(138, 29);
            this.btnIzvještaj.TabIndex = 3;
            this.btnIzvještaj.Text = "Kreiraj izvještaj";
            this.btnIzvještaj.UseVisualStyleBackColor = true;
            this.btnIzvještaj.Click += new System.EventHandler(this.btnIzvještaj_Click);
            // 
            // cmbGrad
            // 
            this.cmbGrad.FormattingEnabled = true;
            this.cmbGrad.Location = new System.Drawing.Point(314, 71);
            this.cmbGrad.Name = "cmbGrad";
            this.cmbGrad.Size = new System.Drawing.Size(151, 28);
            this.cmbGrad.TabIndex = 4;
            this.cmbGrad.SelectedIndexChanged += new System.EventHandler(this.cmbGrad_SelectedIndexChanged);
            this.cmbGrad.SelectionChangeCommitted += new System.EventHandler(this.cmbGrad_SelectionChangeCommitted);
            // 
            // frmKorisnici
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1221, 529);
            this.Controls.Add(this.cmbGrad);
            this.Controls.Add(this.btnIzvještaj);
            this.Controls.Add(this.btnUčitaj);
            this.Controls.Add(this.txtKorisničkoIme);
            this.Controls.Add(this.dgvKorisnici);
            this.Name = "frmKorisnici";
            this.Text = "frmKorisnici";
            this.Load += new System.EventHandler(this.frmKorisnici_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvKorisnici)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DataGridView dgvKorisnici;
        private TextBox txtKorisničkoIme;
        private Button btnUčitaj;
        private DataGridViewTextBoxColumn Naziv;
        private DataGridViewTextBoxColumn KorisničkoIme;
        private DataGridViewTextBoxColumn Grad;
        private DataGridViewTextBoxColumn Ulica;
        private DataGridViewTextBoxColumn BrojTelefona;
        private DataGridViewTextBoxColumn Email;
        private DataGridViewTextBoxColumn BrojRazmjena;
        private DataGridViewTextBoxColumn BrojKupovina;
        private DataGridViewTextBoxColumn BrojAktivnihArtikala;
        private DataGridViewTextBoxColumn UlogaNaziv;
        private DataGridViewButtonColumn Uredi;
        private DataGridViewButtonColumn Obriši;
        private Button btnIzvještaj;
        private ComboBox cmbGrad;
    }
}