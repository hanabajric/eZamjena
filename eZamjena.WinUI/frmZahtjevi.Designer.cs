namespace eZamjena.WinUI
{
    partial class frmZahtjevi
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
            this.dgvZahtjevi = new System.Windows.Forms.DataGridView();
            this.Naziv = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Kategorija = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Opis = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Cijena = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Slika = new System.Windows.Forms.DataGridViewImageColumn();
            this.Korisnik = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Prihvati = new System.Windows.Forms.DataGridViewButtonColumn();
            this.Odbij = new System.Windows.Forms.DataGridViewButtonColumn();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.btnTehnika = new System.Windows.Forms.Button();
            this.btnOstalo = new System.Windows.Forms.Button();
            this.btnNamještaj = new System.Windows.Forms.Button();
            this.btnOdjećaObuća = new System.Windows.Forms.Button();
            this.btnIgračke = new System.Windows.Forms.Button();
            this.btnStvariZaKuću = new System.Windows.Forms.Button();
            this.btnKnjige = new System.Windows.Forms.Button();
            this.btnBiciklaRoleri = new System.Windows.Forms.Button();
            this.btnPrivatiSve = new System.Windows.Forms.Button();
            this.btnOdbijSve = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dgvZahtjevi)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvZahtjevi
            // 
            this.dgvZahtjevi.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvZahtjevi.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Naziv,
            this.Kategorija,
            this.Opis,
            this.Cijena,
            this.Slika,
            this.Korisnik,
            this.Prihvati,
            this.Odbij});
            this.dgvZahtjevi.Location = new System.Drawing.Point(23, 185);
            this.dgvZahtjevi.Name = "dgvZahtjevi";
            this.dgvZahtjevi.RowHeadersWidth = 51;
            this.dgvZahtjevi.RowTemplate.Height = 29;
            this.dgvZahtjevi.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvZahtjevi.Size = new System.Drawing.Size(1000, 285);
            this.dgvZahtjevi.TabIndex = 0;
            this.dgvZahtjevi.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvZahtjevi_CellContentClick);
            // 
            // Naziv
            // 
            this.Naziv.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Naziv.DataPropertyName = "Naziv";
            this.Naziv.HeaderText = "Naziv";
            this.Naziv.MinimumWidth = 6;
            this.Naziv.Name = "Naziv";
            // 
            // Kategorija
            // 
            this.Kategorija.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Kategorija.DataPropertyName = "NazivKategorijeProizvoda";
            this.Kategorija.HeaderText = "Kategorija";
            this.Kategorija.MinimumWidth = 6;
            this.Kategorija.Name = "Kategorija";
            // 
            // Opis
            // 
            this.Opis.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Opis.DataPropertyName = "Opis";
            this.Opis.HeaderText = "Opis";
            this.Opis.MinimumWidth = 6;
            this.Opis.Name = "Opis";
            // 
            // Cijena
            // 
            this.Cijena.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Cijena.DataPropertyName = "Cijena";
            this.Cijena.HeaderText = "Cijena";
            this.Cijena.MinimumWidth = 6;
            this.Cijena.Name = "Cijena";
            // 
            // Slika
            // 
            this.Slika.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Slika.DataPropertyName = "Slika";
            this.Slika.HeaderText = "Slika";
            this.Slika.MinimumWidth = 6;
            this.Slika.Name = "Slika";
            // 
            // Korisnik
            // 
            this.Korisnik.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Korisnik.DataPropertyName = "Korisnik";
            this.Korisnik.HeaderText = "Korisnik";
            this.Korisnik.MinimumWidth = 6;
            this.Korisnik.Name = "Korisnik";
            this.Korisnik.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Korisnik.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.NotSortable;
            // 
            // Prihvati
            // 
            this.Prihvati.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Prihvati.HeaderText = "Prihvati";
            this.Prihvati.MinimumWidth = 6;
            this.Prihvati.Name = "Prihvati";
            this.Prihvati.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Prihvati.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Prihvati.Text = " ✓";
            this.Prihvati.UseColumnTextForButtonValue = true;
            // 
            // Odbij
            // 
            this.Odbij.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.Odbij.HeaderText = "Odbij";
            this.Odbij.MinimumWidth = 6;
            this.Odbij.Name = "Odbij";
            this.Odbij.Resizable = System.Windows.Forms.DataGridViewTriState.True;
            this.Odbij.SortMode = System.Windows.Forms.DataGridViewColumnSortMode.Automatic;
            this.Odbij.Text = "X";
            this.Odbij.UseColumnTextForButtonValue = true;
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.checkBox1.Location = new System.Drawing.Point(458, 114);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(79, 29);
            this.checkBox1.TabIndex = 28;
            this.checkBox1.Text = "Novo";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // btnTehnika
            // 
            this.btnTehnika.BackColor = System.Drawing.SystemColors.Window;
            this.btnTehnika.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnTehnika.Location = new System.Drawing.Point(68, 62);
            this.btnTehnika.Name = "btnTehnika";
            this.btnTehnika.Size = new System.Drawing.Size(94, 29);
            this.btnTehnika.TabIndex = 19;
            this.btnTehnika.Text = "Tehnika";
            this.btnTehnika.UseVisualStyleBackColor = false;
            this.btnTehnika.Click += new System.EventHandler(this.btnTehnika_Click);
            // 
            // btnOstalo
            // 
            this.btnOstalo.BackColor = System.Drawing.SystemColors.Window;
            this.btnOstalo.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnOstalo.Location = new System.Drawing.Point(919, 62);
            this.btnOstalo.Name = "btnOstalo";
            this.btnOstalo.Size = new System.Drawing.Size(94, 29);
            this.btnOstalo.TabIndex = 26;
            this.btnOstalo.Text = "Ostalo";
            this.btnOstalo.UseVisualStyleBackColor = false;
            // 
            // btnNamještaj
            // 
            this.btnNamještaj.BackColor = System.Drawing.SystemColors.Window;
            this.btnNamještaj.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnNamještaj.Location = new System.Drawing.Point(416, 62);
            this.btnNamještaj.Name = "btnNamještaj";
            this.btnNamještaj.Size = new System.Drawing.Size(121, 29);
            this.btnNamještaj.TabIndex = 22;
            this.btnNamještaj.Text = "Namještaj";
            this.btnNamještaj.UseVisualStyleBackColor = false;
            // 
            // btnOdjećaObuća
            // 
            this.btnOdjećaObuća.BackColor = System.Drawing.SystemColors.Window;
            this.btnOdjećaObuća.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnOdjećaObuća.Location = new System.Drawing.Point(168, 62);
            this.btnOdjećaObuća.Name = "btnOdjećaObuća";
            this.btnOdjećaObuća.Size = new System.Drawing.Size(141, 29);
            this.btnOdjećaObuća.TabIndex = 20;
            this.btnOdjećaObuća.Text = "Odjeća i obuća";
            this.btnOdjećaObuća.UseVisualStyleBackColor = false;
            this.btnOdjećaObuća.Click += new System.EventHandler(this.btnOdjećaObuća_Click);
            // 
            // btnIgračke
            // 
            this.btnIgračke.BackColor = System.Drawing.SystemColors.Window;
            this.btnIgračke.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnIgračke.Location = new System.Drawing.Point(315, 62);
            this.btnIgračke.Name = "btnIgračke";
            this.btnIgračke.Size = new System.Drawing.Size(95, 29);
            this.btnIgračke.TabIndex = 21;
            this.btnIgračke.Text = "Igračke";
            this.btnIgračke.UseVisualStyleBackColor = false;
            // 
            // btnStvariZaKuću
            // 
            this.btnStvariZaKuću.BackColor = System.Drawing.SystemColors.Window;
            this.btnStvariZaKuću.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnStvariZaKuću.Location = new System.Drawing.Point(768, 62);
            this.btnStvariZaKuću.Name = "btnStvariZaKuću";
            this.btnStvariZaKuću.Size = new System.Drawing.Size(145, 29);
            this.btnStvariZaKuću.TabIndex = 25;
            this.btnStvariZaKuću.Text = "Stvari za kuću";
            this.btnStvariZaKuću.UseVisualStyleBackColor = false;
            // 
            // btnKnjige
            // 
            this.btnKnjige.BackColor = System.Drawing.SystemColors.Window;
            this.btnKnjige.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnKnjige.Location = new System.Drawing.Point(679, 62);
            this.btnKnjige.Name = "btnKnjige";
            this.btnKnjige.Size = new System.Drawing.Size(83, 29);
            this.btnKnjige.TabIndex = 24;
            this.btnKnjige.Text = "Knjige";
            this.btnKnjige.UseVisualStyleBackColor = false;
            // 
            // btnBiciklaRoleri
            // 
            this.btnBiciklaRoleri.BackColor = System.Drawing.SystemColors.Window;
            this.btnBiciklaRoleri.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnBiciklaRoleri.Location = new System.Drawing.Point(543, 62);
            this.btnBiciklaRoleri.Name = "btnBiciklaRoleri";
            this.btnBiciklaRoleri.Size = new System.Drawing.Size(130, 29);
            this.btnBiciklaRoleri.TabIndex = 23;
            this.btnBiciklaRoleri.Text = "Bicikla i roleri";
            this.btnBiciklaRoleri.UseVisualStyleBackColor = false;
            // 
            // btnPrivatiSve
            // 
            this.btnPrivatiSve.Location = new System.Drawing.Point(791, 503);
            this.btnPrivatiSve.Name = "btnPrivatiSve";
            this.btnPrivatiSve.Size = new System.Drawing.Size(94, 29);
            this.btnPrivatiSve.TabIndex = 29;
            this.btnPrivatiSve.Text = "Prihvati sve";
            this.btnPrivatiSve.UseVisualStyleBackColor = true;
            this.btnPrivatiSve.Click += new System.EventHandler(this.btnPrivatiSve_Click);
            // 
            // btnOdbijSve
            // 
            this.btnOdbijSve.Location = new System.Drawing.Point(929, 503);
            this.btnOdbijSve.Name = "btnOdbijSve";
            this.btnOdbijSve.Size = new System.Drawing.Size(94, 29);
            this.btnOdbijSve.TabIndex = 30;
            this.btnOdbijSve.Text = "Odbij sve";
            this.btnOdbijSve.UseVisualStyleBackColor = true;
            this.btnOdbijSve.Click += new System.EventHandler(this.btnOdbijSve_Click);
            // 
            // frmZahtjevi
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1056, 544);
            this.Controls.Add(this.btnOdbijSve);
            this.Controls.Add(this.btnPrivatiSve);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.btnTehnika);
            this.Controls.Add(this.btnOstalo);
            this.Controls.Add(this.btnNamještaj);
            this.Controls.Add(this.btnOdjećaObuća);
            this.Controls.Add(this.btnIgračke);
            this.Controls.Add(this.btnStvariZaKuću);
            this.Controls.Add(this.btnKnjige);
            this.Controls.Add(this.btnBiciklaRoleri);
            this.Controls.Add(this.dgvZahtjevi);
            this.Name = "frmZahtjevi";
            this.Text = "frmZahtjevi";
            this.Load += new System.EventHandler(this.frmZahtjevi_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvZahtjevi)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private DataGridView dgvZahtjevi;
        private CheckBox checkBox1;
        private Button btnTehnika;
        private Button btnOstalo;
        private Button btnNamještaj;
        private Button btnOdjećaObuća;
        private Button btnIgračke;
        private Button btnStvariZaKuću;
        private Button btnKnjige;
        private Button btnBiciklaRoleri;
        private DataGridViewTextBoxColumn Naziv;
        private DataGridViewTextBoxColumn Kategorija;
        private DataGridViewTextBoxColumn Opis;
        private DataGridViewTextBoxColumn Cijena;
        private DataGridViewImageColumn Slika;
        private DataGridViewTextBoxColumn Korisnik;
        private DataGridViewButtonColumn Prihvati;
        private DataGridViewButtonColumn Odbij;
        private Button btnPrivatiSve;
        private Button btnOdbijSve;
    }
}