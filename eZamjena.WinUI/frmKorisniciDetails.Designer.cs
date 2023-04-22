namespace eZamjena.WinUI
{
    partial class frmKorisniciDetails
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
            this.components = new System.ComponentModel.Container();
            this.pbKorisnici = new System.Windows.Forms.PictureBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.txtKorisnickoIme = new System.Windows.Forms.TextBox();
            this.txtImePrezime = new System.Windows.Forms.TextBox();
            this.txtAdresa = new System.Windows.Forms.TextBox();
            this.txtBrojTelefona = new System.Windows.Forms.TextBox();
            this.txtEmail = new System.Windows.Forms.TextBox();
            this.txtBrojRazmjena = new System.Windows.Forms.TextBox();
            this.txtBrojKupovina = new System.Windows.Forms.TextBox();
            this.txtBrojAktivnihArtikala = new System.Windows.Forms.TextBox();
            this.btnSpremi = new System.Windows.Forms.Button();
            this.btnOdustani = new System.Windows.Forms.Button();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            this.cmbGrad = new System.Windows.Forms.ComboBox();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            ((System.ComponentModel.ISupportInitialize)(this.pbKorisnici)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // pbKorisnici
            // 
            this.pbKorisnici.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.pbKorisnici.Location = new System.Drawing.Point(33, 140);
            this.pbKorisnici.Name = "pbKorisnici";
            this.pbKorisnici.Size = new System.Drawing.Size(242, 275);
            this.pbKorisnici.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbKorisnici.TabIndex = 0;
            this.pbKorisnici.TabStop = false;
            this.pbKorisnici.Click += new System.EventHandler(this.pbKorisnici_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label1.Location = new System.Drawing.Point(33, 27);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(471, 35);
            this.label1.TabIndex = 1;
            this.label1.Text = "Pregled/uređivanje podataka o korisniku ";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(329, 149);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(109, 20);
            this.label2.TabIndex = 2;
            this.label2.Text = "Korisničko ime:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(329, 217);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(44, 20);
            this.label3.TabIndex = 3;
            this.label3.Text = "Grad:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(329, 178);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(103, 20);
            this.label4.TabIndex = 4;
            this.label4.Text = "Ime i prezime:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(329, 254);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(58, 20);
            this.label5.TabIndex = 5;
            this.label5.Text = "Adresa:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(329, 291);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(98, 20);
            this.label6.TabIndex = 6;
            this.label6.Text = "Broj telefona:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(329, 326);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(49, 20);
            this.label7.TabIndex = 7;
            this.label7.Text = "Email:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(329, 359);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(104, 20);
            this.label8.TabIndex = 8;
            this.label8.Text = "Broj razmjena:";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(329, 395);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(103, 20);
            this.label9.TabIndex = 9;
            this.label9.Text = "Broj kupovina:";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(329, 435);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(147, 20);
            this.label10.TabIndex = 10;
            this.label10.Text = "Broj aktivnih artikala:";
            // 
            // txtKorisnickoIme
            // 
            this.txtKorisnickoIme.Location = new System.Drawing.Point(485, 142);
            this.txtKorisnickoIme.Name = "txtKorisnickoIme";
            this.txtKorisnickoIme.Size = new System.Drawing.Size(125, 27);
            this.txtKorisnickoIme.TabIndex = 11;
            // 
            // txtImePrezime
            // 
            this.txtImePrezime.Location = new System.Drawing.Point(485, 175);
            this.txtImePrezime.Name = "txtImePrezime";
            this.txtImePrezime.Size = new System.Drawing.Size(125, 27);
            this.txtImePrezime.TabIndex = 12;
            this.txtImePrezime.Validating += new System.ComponentModel.CancelEventHandler(this.txtImePrezime_Validating);
            // 
            // txtAdresa
            // 
            this.txtAdresa.Location = new System.Drawing.Point(485, 251);
            this.txtAdresa.Name = "txtAdresa";
            this.txtAdresa.Size = new System.Drawing.Size(125, 27);
            this.txtAdresa.TabIndex = 14;
            // 
            // txtBrojTelefona
            // 
            this.txtBrojTelefona.Location = new System.Drawing.Point(485, 284);
            this.txtBrojTelefona.Name = "txtBrojTelefona";
            this.txtBrojTelefona.Size = new System.Drawing.Size(125, 27);
            this.txtBrojTelefona.TabIndex = 15;
            // 
            // txtEmail
            // 
            this.txtEmail.Location = new System.Drawing.Point(485, 317);
            this.txtEmail.Name = "txtEmail";
            this.txtEmail.Size = new System.Drawing.Size(125, 27);
            this.txtEmail.TabIndex = 16;
            // 
            // txtBrojRazmjena
            // 
            this.txtBrojRazmjena.Location = new System.Drawing.Point(485, 352);
            this.txtBrojRazmjena.Name = "txtBrojRazmjena";
            this.txtBrojRazmjena.Size = new System.Drawing.Size(39, 27);
            this.txtBrojRazmjena.TabIndex = 17;
            // 
            // txtBrojKupovina
            // 
            this.txtBrojKupovina.Location = new System.Drawing.Point(485, 392);
            this.txtBrojKupovina.Name = "txtBrojKupovina";
            this.txtBrojKupovina.Size = new System.Drawing.Size(39, 27);
            this.txtBrojKupovina.TabIndex = 18;
            // 
            // txtBrojAktivnihArtikala
            // 
            this.txtBrojAktivnihArtikala.Location = new System.Drawing.Point(485, 432);
            this.txtBrojAktivnihArtikala.Name = "txtBrojAktivnihArtikala";
            this.txtBrojAktivnihArtikala.Size = new System.Drawing.Size(39, 27);
            this.txtBrojAktivnihArtikala.TabIndex = 19;
            // 
            // btnSpremi
            // 
            this.btnSpremi.Location = new System.Drawing.Point(516, 500);
            this.btnSpremi.Name = "btnSpremi";
            this.btnSpremi.Size = new System.Drawing.Size(94, 39);
            this.btnSpremi.TabIndex = 20;
            this.btnSpremi.Text = "Spremi";
            this.btnSpremi.UseVisualStyleBackColor = true;
            this.btnSpremi.Click += new System.EventHandler(this.btnSpremi_Click);
            // 
            // btnOdustani
            // 
            this.btnOdustani.Location = new System.Drawing.Point(33, 497);
            this.btnOdustani.Name = "btnOdustani";
            this.btnOdustani.Size = new System.Drawing.Size(94, 42);
            this.btnOdustani.TabIndex = 21;
            this.btnOdustani.Text = "Odustani";
            this.btnOdustani.UseVisualStyleBackColor = true;
            this.btnOdustani.Click += new System.EventHandler(this.btnOdustani_Click);
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // cmbGrad
            // 
            this.cmbGrad.FormattingEnabled = true;
            this.cmbGrad.Location = new System.Drawing.Point(485, 216);
            this.cmbGrad.Name = "cmbGrad";
            this.cmbGrad.Size = new System.Drawing.Size(125, 28);
            this.cmbGrad.TabIndex = 22;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // frmKorisniciDetails
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(638, 574);
            this.Controls.Add(this.cmbGrad);
            this.Controls.Add(this.btnOdustani);
            this.Controls.Add(this.btnSpremi);
            this.Controls.Add(this.txtBrojAktivnihArtikala);
            this.Controls.Add(this.txtBrojKupovina);
            this.Controls.Add(this.txtBrojRazmjena);
            this.Controls.Add(this.txtEmail);
            this.Controls.Add(this.txtBrojTelefona);
            this.Controls.Add(this.txtAdresa);
            this.Controls.Add(this.txtImePrezime);
            this.Controls.Add(this.txtKorisnickoIme);
            this.Controls.Add(this.label10);
            this.Controls.Add(this.label9);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.pbKorisnici);
            this.Name = "frmKorisniciDetails";
            this.Text = "frmKorisniciDetails";
            this.Load += new System.EventHandler(this.frmKorisniciDetails_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pbKorisnici)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private PictureBox pbKorisnici;
        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label label5;
        private Label label6;
        private Label label7;
        private Label label8;
        private Label label9;
        private Label label10;
        private TextBox txtKorisnickoIme;
        private TextBox txtImePrezime;
        private TextBox txtAdresa;
        private TextBox txtBrojTelefona;
        private TextBox txtEmail;
        private TextBox txtBrojRazmjena;
        private TextBox txtBrojKupovina;
        private TextBox txtBrojAktivnihArtikala;
        private Button btnSpremi;
        private Button btnOdustani;
        private ErrorProvider errorProvider1;
        private ComboBox cmbGrad;
        private OpenFileDialog openFileDialog1;
    }
}