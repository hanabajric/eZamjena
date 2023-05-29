namespace eZamjena.WinUI
{
    partial class frmRegistracija
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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.txtIme = new System.Windows.Forms.TextBox();
            this.txtEmail = new System.Windows.Forms.TextBox();
            this.txtPrezime = new System.Windows.Forms.TextBox();
            this.txtKorisnickoIme = new System.Windows.Forms.TextBox();
            this.txtLozinka = new System.Windows.Forms.TextBox();
            this.txtPotvrdaLozinke = new System.Windows.Forms.TextBox();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.txtBrojTelefona = new System.Windows.Forms.TextBox();
            this.btnRegistracija = new System.Windows.Forms.Button();
            this.pbLozinka = new System.Windows.Forms.PictureBox();
            this.pbLozinkaPotvrda = new System.Windows.Forms.PictureBox();
            this.errorProvider1 = new System.Windows.Forms.ErrorProvider(this.components);
            ((System.ComponentModel.ISupportInitialize)(this.pbLozinka)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbLozinkaPotvrda)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).BeginInit();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Segoe UI", 20F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
            this.label1.Location = new System.Drawing.Point(52, 22);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(189, 46);
            this.label1.TabIndex = 0;
            this.label1.Text = "Registracija";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(63, 117);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(37, 20);
            this.label2.TabIndex = 1;
            this.label2.Text = "Ime:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(63, 160);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(65, 20);
            this.label3.TabIndex = 2;
            this.label3.Text = "Prezime:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(63, 202);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(109, 20);
            this.label4.TabIndex = 3;
            this.label4.Text = "Korisničko ime:";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(63, 243);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(62, 20);
            this.label5.TabIndex = 4;
            this.label5.Text = "Lozinka:";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(63, 283);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(122, 20);
            this.label6.TabIndex = 5;
            this.label6.Text = "Potvrdite lozinku:";
            // 
            // txtIme
            // 
            this.txtIme.Location = new System.Drawing.Point(237, 110);
            this.txtIme.Name = "txtIme";
            this.txtIme.Size = new System.Drawing.Size(163, 27);
            this.txtIme.TabIndex = 6;
            this.txtIme.Validating += new System.ComponentModel.CancelEventHandler(this.txtIme_Validating);
            // 
            // txtEmail
            // 
            this.txtEmail.Location = new System.Drawing.Point(237, 318);
            this.txtEmail.Name = "txtEmail";
            this.txtEmail.Size = new System.Drawing.Size(163, 27);
            this.txtEmail.TabIndex = 7;
            this.txtEmail.Validating += new System.ComponentModel.CancelEventHandler(this.txtEmail_Validating);
            this.txtEmail.PlaceholderText = "example@email.com";
           
            // 
            // txtPrezime
            // 
            this.txtPrezime.Location = new System.Drawing.Point(237, 153);
            this.txtPrezime.Name = "txtPrezime";
            this.txtPrezime.Size = new System.Drawing.Size(163, 27);
            this.txtPrezime.TabIndex = 8;
            this.txtPrezime.Validating += new System.ComponentModel.CancelEventHandler(this.txtPrezime_Validating);
            // 
            // txtKorisnickoIme
            // 
            this.txtKorisnickoIme.Location = new System.Drawing.Point(237, 195);
            this.txtKorisnickoIme.Name = "txtKorisnickoIme";
            this.txtKorisnickoIme.Size = new System.Drawing.Size(163, 27);
            this.txtKorisnickoIme.TabIndex = 9;
            this.txtKorisnickoIme.Validating += new System.ComponentModel.CancelEventHandler(this.txtKorisnickoIme_Validating);
            // 
            // txtLozinka
            // 
            this.txtLozinka.Location = new System.Drawing.Point(237, 236);
            this.txtLozinka.Name = "txtLozinka";
            this.txtLozinka.Size = new System.Drawing.Size(163, 27);
            this.txtLozinka.TabIndex = 10;
            this.txtLozinka.UseSystemPasswordChar = true;
            this.txtLozinka.Validating += new System.ComponentModel.CancelEventHandler(this.txtLozinka_Validating);
            // 
            // txtPotvrdaLozinke
            // 
            this.txtPotvrdaLozinke.Location = new System.Drawing.Point(237, 276);
            this.txtPotvrdaLozinke.Name = "txtPotvrdaLozinke";
            this.txtPotvrdaLozinke.Size = new System.Drawing.Size(163, 27);
            this.txtPotvrdaLozinke.TabIndex = 11;
            this.txtPotvrdaLozinke.UseSystemPasswordChar = true;
            this.txtPotvrdaLozinke.Validating += new System.ComponentModel.CancelEventHandler(this.txtPotvrdaLozinke_Validating);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(63, 325);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(49, 20);
            this.label7.TabIndex = 12;
            this.label7.Text = "Email:";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(63, 367);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(98, 20);
            this.label8.TabIndex = 13;
            this.label8.Text = "Broj telefona:";
            // 
            // txtBrojTelefona
            // 
            this.txtBrojTelefona.Location = new System.Drawing.Point(237, 360);
            this.txtBrojTelefona.Name = "txtBrojTelefona";
            this.txtBrojTelefona.Size = new System.Drawing.Size(163, 27);
            this.txtBrojTelefona.TabIndex = 14;
            this.txtBrojTelefona.Validating += new System.ComponentModel.CancelEventHandler(this.txtBrojTelefona_Validating);
            // 
            // btnRegistracija
            // 
            this.btnRegistracija.Location = new System.Drawing.Point(306, 409);
            this.btnRegistracija.Name = "btnRegistracija";
            this.btnRegistracija.Size = new System.Drawing.Size(94, 29);
            this.btnRegistracija.TabIndex = 15;
            this.btnRegistracija.Text = "Registruj se";
            this.btnRegistracija.UseVisualStyleBackColor = true;
            this.btnRegistracija.Click += new System.EventHandler(this.btnRegistracija_Click);
            // 
            // pbLozinka
            // 
            this.pbLozinka.Location = new System.Drawing.Point(373, 238);
            this.pbLozinka.Name = "pbLozinka";
            this.pbLozinka.Size = new System.Drawing.Size(27, 25);
            this.pbLozinka.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbLozinka.TabIndex = 16;
            this.pbLozinka.TabStop = false;
            // 
            // pbLozinkaPotvrda
            // 
            this.pbLozinkaPotvrda.Location = new System.Drawing.Point(373, 278);
            this.pbLozinkaPotvrda.Name = "pbLozinkaPotvrda";
            this.pbLozinkaPotvrda.Size = new System.Drawing.Size(27, 25);
            this.pbLozinkaPotvrda.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.pbLozinkaPotvrda.TabIndex = 17;
            this.pbLozinkaPotvrda.TabStop = false;
            // 
            // errorProvider1
            // 
            this.errorProvider1.ContainerControl = this;
            // 
            // frmRegistracija
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(476, 472);
            this.Controls.Add(this.pbLozinkaPotvrda);
            this.Controls.Add(this.pbLozinka);
            this.Controls.Add(this.btnRegistracija);
            this.Controls.Add(this.txtBrojTelefona);
            this.Controls.Add(this.label8);
            this.Controls.Add(this.label7);
            this.Controls.Add(this.txtPotvrdaLozinke);
            this.Controls.Add(this.txtLozinka);
            this.Controls.Add(this.txtKorisnickoIme);
            this.Controls.Add(this.txtPrezime);
            this.Controls.Add(this.txtEmail);
            this.Controls.Add(this.txtIme);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.label5);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "frmRegistracija";
            this.Text = "frmRegistracija";
            this.Load += new System.EventHandler(this.frmRegistracija_Load);
            ((System.ComponentModel.ISupportInitialize)(this.pbLozinka)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.pbLozinkaPotvrda)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.errorProvider1)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label label1;
        private Label label2;
        private Label label3;
        private Label label4;
        private Label label5;
        private Label label6;
        private TextBox txtIme;
        private TextBox txtEmail;
        private TextBox txtPrezime;
        private TextBox txtKorisnickoIme;
        private TextBox txtLozinka;
        private TextBox txtPotvrdaLozinke;
        private Label label7;
        private Label label8;
        private TextBox txtBrojTelefona;
        private Button btnRegistracija;
        private PictureBox pbLozinka;
        private PictureBox pbLozinkaPotvrda;
        private ErrorProvider errorProvider1;
          
        }
}