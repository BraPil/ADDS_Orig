namespace Adds.Forms
{
    partial class frmPlogGroupsByDef
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
            this.dgvPlotGroups = new System.Windows.Forms.DataGridView();
            this.lblPlotDef = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlotGroups)).BeginInit();
            this.SuspendLayout();
            // 
            // dgvPlotGroups
            // 
            this.dgvPlotGroups.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.dgvPlotGroups.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPlotGroups.Location = new System.Drawing.Point(10, 35);
            this.dgvPlotGroups.Name = "dgvPlotGroups";
            this.dgvPlotGroups.Size = new System.Drawing.Size(250, 100);
            this.dgvPlotGroups.TabIndex = 0;
            this.dgvPlotGroups.CellFormatting += new System.Windows.Forms.DataGridViewCellFormattingEventHandler(this.dgvPlotGroups_CellFormatting);
            this.dgvPlotGroups.DoubleClick += new System.EventHandler(this.dgvPlotGroups_DoubleClick);
            // 
            // lblPlotDef
            // 
            this.lblPlotDef.AutoSize = true;
            this.lblPlotDef.Location = new System.Drawing.Point(10, 10);
            this.lblPlotDef.Name = "lblPlotDef";
            this.lblPlotDef.Size = new System.Drawing.Size(35, 13);
            this.lblPlotDef.TabIndex = 1;
            this.lblPlotDef.Text = "label1";
            // 
            // frmPlogGroupsByDef
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(269, 151);
            this.Controls.Add(this.lblPlotDef);
            this.Controls.Add(this.dgvPlotGroups);
            this.Name = "frmPlogGroupsByDef";
            this.Text = "frmPlogGroupsByDef";
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlotGroups)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView dgvPlotGroups;
        private System.Windows.Forms.Label lblPlotDef;
    }
}