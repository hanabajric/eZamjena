﻿namespace eZamjena.WinUI
{
    partial class frmArtikliDetails
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
            this.txtNaziv = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.pbSlikaArtikla = new System.Windows.Forms.PictureBox();
            this.cmbKategorija = new System.Windows.Forms.ComboBox();
            this.txtCijena = new System.Windows.Forms.TextBox();
            this.txtKorisnik = new System.Windows.Forms.TextBox();
            this.cbStanje = new System.Windows.Forms.CheckBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.txtOpis = new System.Windows.Forms.TextBox();
            this.btnOdustani = new System.Windows.Forms.Button();
            this.btnSpremi = new System.Windows.Forms.Button();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            ((System.ComponentModel.ISupportInitialize)(this.pbSlikaArtikla)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // txtNaziv
            // 
            this.txtNaziv.Location = new System.Drawing.Point(405, 111);
            this.txtNaziv.Name = "txtNaziv";
            this.txtNaziv.Size = new System.Drawing.Size(125, 27);
            this.txtNaziv.TabIndex = 0;
            this.txtNaziv.Validating += new System.ComponentModel.CancelEventHandler(this.txtNaziv_Validating);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 15F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label1.Location = new System.Drawing.Point(50, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(447, 35);
            this.label1.TabIndex = 1;
            this.label1.Text = "Pregled /uređivanje podataka o artiklu ";
            // 
            // pbSlikaArtikla
            // 
            this.pbSlikaArtikla.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.pbSlikaArtikla.Location = new System.Drawing.Point(23, 113);
            this.pbSlikaArtikla.Name = "pbSlikaArtikla";
            this.pbSlikaArtikla.Size = new System.Drawing.Size(188, 219);
            this.pbSlikaArtikla.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbSlikaArtikla.TabIndex = 2;
            this.pbSlikaArtikla.TabStop = false;
            this.pbSlikaArtikla.Click += new System.EventHandler(this.pbSlikaArtikla_Click);
            // 
            // cmbKategorija
            // 
            this.cmbKategorija.FormattingEnabled = true;
            this.cmbKategorija.Location = new System.Drawing.Point(405, 158);
            this.cmbKategorija.Name = "cmbKategorija";
            this.cmbKategorija.Size = new System.Drawing.Size(125, 28);
            this.cmbKategorija.TabIndex = 3;
            this.cmbKategorija.SelectedIndexChanged += new System.EventHandler(this.cmbKategorija_SelectedIndexChanged);
            // 
            // txtCijena
            // 
            this.txtCijena.Location = new System.Drawing.Point(476, 204);
            this.txtCijena.Name = "txtCijena";
            this.txtCijena.Size = new System.Drawing.Size(54, 27);
            this.txtCijena.TabIndex = 4;
            // 
            // txtKorisnik
            // 
            this.txtKorisnik.Location = new System.Drawing.Point(405, 255);
            this.txtKorisnik.Name = "txtKorisnik";
            this.txtKorisnik.ReadOnly = true;
            this.txtKorisnik.Size = new System.Drawing.Size(125, 27);
            this.txtKorisnik.TabIndex = 5;
            // 
            // cbStanje
            // 
            this.cbStanje.AutoSize = true;
            this.cbStanje.Location = new System.Drawing.Point(463, 312);
            this.cbStanje.Name = "cbStanje";
            this.cbStanje.Size = new System.Drawing.Size(67, 24);
            this.cbStanje.TabIndex = 6;
            this.cbStanje.Text = "Novo";
            this.cbStanje.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(293, 113);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(49, 20);
            this.label2.TabIndex = 7;
            this.label2.Text = "Naziv:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(293, 161);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(81, 20);
            this.label3.TabIndex = 8;
            this.label3.Text = "Kategorija:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(293, 204);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(132, 20);
            this.label4.TabIndex = 9;
            this.label4.Text = "Procjenjena cijena:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(293, 312);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(53, 20);
            this.label5.TabIndex = 10;
            this.label5.Text = "Stanje:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(293, 262);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(64, 20);
            this.label6.TabIndex = 11;
            this.label6.Text = "Korisnik:";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(23, 350);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(42, 20);
            this.label7.TabIndex = 12;
            this.label7.Text = "Opis:";
            // 
            // txtOpis
            // 
            this.txtOpis.Location = new System.Drawing.Point(23, 386);
            this.txtOpis.Multiline = true;
            this.txtOpis.Name = "txtOpis";
            this.txtOpis.Size = new System.Drawing.Size(509, 56);
            this.txtOpis.TabIndex = 13;
            // 
            // btnOdustani
            // 
            this.btnOdustani.Location = new System.Drawing.Point(23, 461);
            this.btnOdustani.Name = "btnOdustani";
            this.btnOdustani.Size = new System.Drawing.Size(94, 36);
            this.btnOdustani.TabIndex = 14;
            this.btnOdustani.Text = "Odustani";
            this.btnOdustani.UseVisualStyleBackColor = true;
            this.btnOdustani.Click += new System.EventHandler(this.btnOdustani_Click);
            // 
            // btnSpremi
            // 
            this.btnSpremi.Location = new System.Drawing.Point(438, 461);
            this.btnSpremi.Name = "btnSpremi";
            this.btnSpremi.Size = new System.Drawing.Size(94, 36);
            this.btnSpremi.TabIndex = 15;
            this.btnSpremi.Text = "Spremi";
            this.btnSpremi.UseVisualStyleBackColor = true;
            this.btnSpremi.Click += new System.EventHandler(this.btnSpremi_Click);
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.FileName = "openFileDialog1";
            // 
            // frmArtikliDetails
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(568, 509);
            this.Controls.Add(this.btnSpremi);
            this.Controls.Add(this.btnOdustani);
            this.Controls.Add(this.txtOpis);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.cbStanje);
            this.Controls.Add(this.txtKorisnik);
            this.Controls.Add(this.txtCijena);
            this.Controls.Add(this.cmbKategorija);
            this.Controls.Add(this.pbSlikaArtikla);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtNaziv);
            this.Name = "frmArtikliDetails";
            this.Text = "frmArtikliDetails";
            this.Load += new System.EventHandler(this.frmArtikliDetails_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pbSlikaArtikla)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private TextBox txtNaziv;
        private Label label1;
        private PictureBox pbSlikaArtikla;
        private ComboBox cmbKategorija;
        private TextBox txtCijena;
        private TextBox txtKorisnik;
        private CheckBox cbStanje;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label label5;
        private Label label6;
        private Label label7;
        private TextBox txtOpis;
        private Button btnOdustani;
        private Button btnSpremi;
        private ErrorProvider errorProvider1;
        private OpenFileDialog openFileDialog1;
    }
}