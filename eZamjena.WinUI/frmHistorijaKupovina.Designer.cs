namespace eZamjena.WinUI
{
    partial class frmHistorijaKupovina
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
            this.dgvHistorijaKupovina = new System.Windows.Forms.DataGridView();
            this.dtpOd = new System.Windows.Forms.DateTimePicker();
            this.dtpDo = new System.Windows.Forms.DateTimePicker();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.btnKreirajIzvještaj = new System.Windows.Forms.Button();
            this.Korisnik = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Proizvod = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Cijena = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.DatumKupovine = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.dgvHistorijaKupovina)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvHistorijaKupovina
            // 
            this.dgvHistorijaKupovina.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvHistorijaKupovina.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Korisnik,
            this.Proizvod,
            this.Cijena,
            this.DatumKupovine});
            this.dgvHistorijaKupovina.Location = new System.Drawing.Point(41, 122);
            this.dgvHistorijaKupovina.Name = "dgvHistorijaKupovina";
            this.dgvHistorijaKupovina.RowHeadersWidth = 51;
            this.dgvHistorijaKupovina.RowTemplate.Height = 29;
            this.dgvHistorijaKupovina.Size = new System.Drawing.Size(710, 280);
            this.dgvHistorijaKupovina.TabIndex = 0;
            // 
            // dtpOd
            // 
            this.dtpOd.Location = new System.Drawing.Point(105, 43);
            this.dtpOd.Name = "dtpOd";
            this.dtpOd.Size = new System.Drawing.Size(250, 27);
            this.dtpOd.TabIndex = 1;
            this.dtpOd.ValueChanged += new System.EventHandler(this.dtpOd_ValueChanged);
            // 
            // dtpDo
            // 
            this.dtpDo.Location = new System.Drawing.Point(501, 43);
            this.dtpDo.Name = "dtpDo";
            this.dtpDo.Size = new System.Drawing.Size(250, 27);
            this.dtpDo.TabIndex = 2;
            this.dtpDo.ValueChanged += new System.EventHandler(this.dtpDo_ValueChanged);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(41, 48);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(34, 20);
            this.label1.TabIndex = 3;
            this.label1.Text = "OD:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(406, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(34, 20);
            this.label2.TabIndex = 4;
            this.label2.Text = "DO:";
            // 
            // btnKreirajIzvještaj
            // 
            this.btnKreirajIzvještaj.Location = new System.Drawing.Point(651, 419);
            this.btnKreirajIzvještaj.Name = "btnKreirajIzvještaj";
            this.btnKreirajIzvještaj.Size = new System.Drawing.Size(94, 29);
            this.btnKreirajIzvještaj.TabIndex = 5;
            this.btnKreirajIzvještaj.Text = "Kreiraj izvještaj";
            this.btnKreirajIzvještaj.UseVisualStyleBackColor = true;
            this.btnKreirajIzvještaj.Click += new System.EventHandler(this.btnKreirajIzvještaj_Click);
            // 
            // Korisnik
            // 
            this.Korisnik.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Korisnik.DataPropertyName = "NazivKorisnika";
            this.Korisnik.HeaderText = "Korisnik";
            this.Korisnik.MinimumWidth = 6;
            this.Korisnik.Name = "Korisnik";
            // 
            // Proizvod
            // 
            this.Proizvod.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Proizvod.DataPropertyName = "NazivProizvoda";
            this.Proizvod.HeaderText = "Proizvod";
            this.Proizvod.MinimumWidth = 6;
            this.Proizvod.Name = "Proizvod";
            // 
            // Cijena
            // 
            this.Cijena.DataPropertyName = "Cijena";
            this.Cijena.HeaderText = "Cijena";
            this.Cijena.MinimumWidth = 6;
            this.Cijena.Name = "Cijena";
            this.Cijena.Width = 125;
            // 
            // DatumKupovine
            // 
            this.DatumKupovine.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.DatumKupovine.DataPropertyName = "formatiraniDatum";
            this.DatumKupovine.HeaderText = "Datum kupovine";
            this.DatumKupovine.MinimumWidth = 6;
            this.DatumKupovine.Name = "DatumKupovine";
            // 
            // frmHistorijaKupovina
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnKreirajIzvještaj);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.dtpDo);
            this.Controls.Add(this.dtpOd);
            this.Controls.Add(this.dgvHistorijaKupovina);
            this.Name = "frmHistorijaKupovina";
            this.Text = "frmHistorijaKupovina";
            this.Load += new System.EventHandler(this.frmHistorijaKupovina_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvHistorijaKupovina)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DataGridView dgvHistorijaKupovina;
        private DateTimePicker dtpOd;
        private DateTimePicker dtpDo;
        private Label label1;
        private Label label2;
        private Button btnKreirajIzvještaj;
        private DataGridViewTextBoxColumn Korisnik;
        private DataGridViewTextBoxColumn Proizvod;
        private DataGridViewTextBoxColumn Cijena;
        private DataGridViewTextBoxColumn DatumKupovine;
    }
}