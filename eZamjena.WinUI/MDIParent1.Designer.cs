namespace eZamjena.WinUI
{
    partial class MDIParent1
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
            this.menuStrip = new System.Windows.Forms.MenuStrip();
            this.artikli = new System.Windows.Forms.ToolStripMenuItem();
            this.zahtjevi = new System.Windows.Forms.ToolStripMenuItem();
            this.historijaRazmjena = new System.Windows.Forms.ToolStripMenuItem();
            this.historijaKupovina = new System.Windows.Forms.ToolStripMenuItem();
            this.profiliToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.sviProfili = new System.Windows.Forms.ToolStripMenuItem();
            this.top3Profila = new System.Windows.Forms.ToolStripMenuItem();
            this.odjava = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.menuStrip.SuspendLayout();
            this.SuspendLayout();
            // 
            // menuStrip
            // 
            this.menuStrip.ImageScalingSize = new System.Drawing.Size(20, 20);
            this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.artikli,
            this.zahtjevi,
            this.historijaRazmjena,
            this.historijaKupovina,
            this.profiliToolStripMenuItem,
            this.odjava,
            this.toolStripMenuItem1});
            this.menuStrip.Location = new System.Drawing.Point(0, 0);
            this.menuStrip.Name = "menuStrip";
            this.menuStrip.Padding = new System.Windows.Forms.Padding(8, 3, 0, 3);
            this.menuStrip.Size = new System.Drawing.Size(1218, 30);
            this.menuStrip.TabIndex = 0;
            this.menuStrip.Text = "MenuStrip";
            // 
            // artikli
            // 
            this.artikli.ImageTransparentColor = System.Drawing.SystemColors.ActiveBorder;
            this.artikli.Name = "artikli";
            this.artikli.Size = new System.Drawing.Size(62, 24);
            this.artikli.Text = "Artikli";
            this.artikli.Click += new System.EventHandler(this.artikli_Click);
            // 
            // zahtjevi
            // 
            this.zahtjevi.Name = "zahtjevi";
            this.zahtjevi.Size = new System.Drawing.Size(76, 24);
            this.zahtjevi.Text = "Zahtjevi";
            this.zahtjevi.Click += new System.EventHandler(this.zahtjevi_Click);
            // 
            // historijaRazmjena
            // 
            this.historijaRazmjena.Name = "historijaRazmjena";
            this.historijaRazmjena.Size = new System.Drawing.Size(144, 24);
            this.historijaRazmjena.Text = "Historija razmjena";
            this.historijaRazmjena.Click += new System.EventHandler(this.historijaRazmjena_Click);
            // 
            // historijaKupovina
            // 
            this.historijaKupovina.Name = "historijaKupovina";
            this.historijaKupovina.Size = new System.Drawing.Size(143, 24);
            this.historijaKupovina.Text = "Historija kupovina";
            this.historijaKupovina.Click += new System.EventHandler(this.historijaKupovina_Click);
            // 
            // profiliToolStripMenuItem
            // 
            this.profiliToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.sviProfili,
            this.top3Profila});
            this.profiliToolStripMenuItem.Name = "profiliToolStripMenuItem";
            this.profiliToolStripMenuItem.Size = new System.Drawing.Size(62, 24);
            this.profiliToolStripMenuItem.Text = "Profili";
            this.profiliToolStripMenuItem.Click += new System.EventHandler(this.profiliToolStripMenuItem_Click);
            // 
            // sviProfili
            // 
            this.sviProfili.Name = "sviProfili";
            this.sviProfili.Size = new System.Drawing.Size(177, 26);
            this.sviProfili.Text = "Svi profili";
            this.sviProfili.Click += new System.EventHandler(this.sviProfili_Click);
            // 
            // top3Profila
            // 
            this.top3Profila.Name = "top3Profila";
            this.top3Profila.Size = new System.Drawing.Size(177, 26);
            this.top3Profila.Text = "Top 3 profila";
            this.top3Profila.Click += new System.EventHandler(this.top3Profila_Click);
            // 
            // odjava
            // 
            this.odjava.Name = "odjava";
            this.odjava.Size = new System.Drawing.Size(70, 24);
            this.odjava.Text = "Odjava";
            this.odjava.Click += new System.EventHandler(this.odjava_Click);
            // 
            // toolStripMenuItem1
            // 
            this.toolStripMenuItem1.Name = "toolStripMenuItem1";
            this.toolStripMenuItem1.Size = new System.Drawing.Size(14, 24);
            // 
            // MDIParent1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1218, 738);
            this.Controls.Add(this.menuStrip);
            this.IsMdiContainer = true;
            this.MainMenuStrip = this.menuStrip;
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "MDIParent1";
            this.Text = "MDIParent1";
            this.Load += new System.EventHandler(this.MDIParent1_Load);
            this.menuStrip.ResumeLayout(false);
            this.menuStrip.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion


        private System.Windows.Forms.MenuStrip menuStrip;
        private System.Windows.Forms.ToolStripMenuItem artikli;
        private System.Windows.Forms.ToolStripMenuItem zahtjevi;
        private System.Windows.Forms.ToolStripMenuItem historijaRazmjena;
        private System.Windows.Forms.ToolStripMenuItem historijaKupovina;
        private System.Windows.Forms.ToolStripMenuItem profili;
        private System.Windows.Forms.ToolStripMenuItem odjava;
        private ToolStripMenuItem sviProfiliToolStripMenuItem;
        private ToolStripMenuItem top3ProfilaToolStripMenuItem;
        private ToolStripMenuItem toolStripMenuItem1;
        private ToolStripMenuItem profiliToolStripMenuItem;
        private ToolStripMenuItem sviProfili;
        private ToolStripMenuItem top3Profila;
    }
}



