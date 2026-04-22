namespace Adds.Forms
{
    partial class frmPlotDefMain
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
            this.dgvPlots = new System.Windows.Forms.DataGridView();
            this.cmsPlotDefMain = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.plotToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.plotGroupsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.groupsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlots)).BeginInit();
            this.cmsPlotDefMain.SuspendLayout();
            this.SuspendLayout();
            // 
            // dgvPlots
            // 
            this.dgvPlots.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvPlots.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPlots.ContextMenuStrip = this.cmsPlotDefMain;
            this.dgvPlots.Location = new System.Drawing.Point(12, 12);
            this.dgvPlots.Name = "dgvPlots";
            this.dgvPlots.Size = new System.Drawing.Size(680, 377);
            this.dgvPlots.TabIndex = 0;
            this.dgvPlots.DoubleClick += new System.EventHandler(this.dgvPlots_DoubleClick);
            // 
            // cmsPlotDefMain
            // 
            this.cmsPlotDefMain.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.plotToolStripMenuItem,
            this.plotGroupsToolStripMenuItem,
            this.groupsToolStripMenuItem});
            this.cmsPlotDefMain.Name = "cmsPlotDefMain";
            this.cmsPlotDefMain.Size = new System.Drawing.Size(153, 92);
            // 
            // plotToolStripMenuItem
            // 
            this.plotToolStripMenuItem.Name = "plotToolStripMenuItem";
            this.plotToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.plotToolStripMenuItem.Text = "Definition";
            this.plotToolStripMenuItem.Click += new System.EventHandler(this.plotToolStripMenuItem_Click);
            // 
            // plotGroupsToolStripMenuItem
            // 
            this.plotGroupsToolStripMenuItem.Name = "plotGroupsToolStripMenuItem";
            this.plotGroupsToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.plotGroupsToolStripMenuItem.Text = "Plot";
            this.plotGroupsToolStripMenuItem.Click += new System.EventHandler(this.plotGroupsToolStripMenuItem_Click);
            // 
            // groupsToolStripMenuItem
            // 
            this.groupsToolStripMenuItem.Name = "groupsToolStripMenuItem";
            this.groupsToolStripMenuItem.Size = new System.Drawing.Size(152, 22);
            this.groupsToolStripMenuItem.Text = "Groups";
            this.groupsToolStripMenuItem.Click += new System.EventHandler(this.groupsToolStripMenuItem_Click);
            // 
            // frmPlotDefMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(704, 401);
            this.Controls.Add(this.dgvPlots);
            this.Name = "frmPlotDefMain";
            this.Text = "frmPlotDefMain";
            this.Load += new System.EventHandler(this.frmPlotDefMain_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlots)).EndInit();
            this.cmsPlotDefMain.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvPlots;
        private System.Windows.Forms.ContextMenuStrip cmsPlotDefMain;
        private System.Windows.Forms.ToolStripMenuItem plotToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem plotGroupsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem groupsToolStripMenuItem;
    }
}