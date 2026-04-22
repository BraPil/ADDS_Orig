namespace Adds.Forms
{
    partial class frmPlotGroupDef
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
            this.lblGroupName = new System.Windows.Forms.Label();
            this.lblSheet = new System.Windows.Forms.Label();
            this.cboGroupName = new System.Windows.Forms.ComboBox();
            this.txtSheetNo = new System.Windows.Forms.TextBox();
            this.lblSheetOf = new System.Windows.Forms.Label();
            this.txtSheetOf = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.cboPlotDef = new System.Windows.Forms.ComboBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.cboSheetSize = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.gboScale = new System.Windows.Forms.GroupBox();
            this.txtScaleFont = new System.Windows.Forms.TextBox();
            this.lblScaleFont = new System.Windows.Forms.Label();
            this.txtScaleSymbol = new System.Windows.Forms.TextBox();
            this.lblSymbol = new System.Windows.Forms.Label();
            this.txtScalePlot = new System.Windows.Forms.TextBox();
            this.lblPlotScale = new System.Windows.Forms.Label();
            this.gboCustoms = new System.Windows.Forms.GroupBox();
            this.clbCustoms = new System.Windows.Forms.CheckedListBox();
            this.dgvPlotDefs = new System.Windows.Forms.DataGridView();
            this.btnClear = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnAddPlotDef = new System.Windows.Forms.Button();
            this.btuRemovePlot = new System.Windows.Forms.Button();
            this.btnUp = new System.Windows.Forms.Button();
            this.btnDown = new System.Windows.Forms.Button();
            this.btnUpdate = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.btnAdd = new System.Windows.Forms.Button();
            this.lblDefinedBy = new System.Windows.Forms.Label();
            this.lblDefinedDate = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.gboScale.SuspendLayout();
            this.gboCustoms.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlotDefs)).BeginInit();
            this.SuspendLayout();
            // 
            // lblGroupName
            // 
            this.lblGroupName.AutoSize = true;
            this.lblGroupName.Location = new System.Drawing.Point(10, 10);
            this.lblGroupName.Name = "lblGroupName";
            this.lblGroupName.Size = new System.Drawing.Size(70, 13);
            this.lblGroupName.TabIndex = 0;
            this.lblGroupName.Text = "Group Name:";
            // 
            // lblSheet
            // 
            this.lblSheet.AutoSize = true;
            this.lblSheet.Location = new System.Drawing.Point(10, 40);
            this.lblSheet.Name = "lblSheet";
            this.lblSheet.Size = new System.Drawing.Size(38, 13);
            this.lblSheet.TabIndex = 1;
            this.lblSheet.Text = "Sheet:";
            // 
            // cboGroupName
            // 
            this.cboGroupName.FormattingEnabled = true;
            this.cboGroupName.Location = new System.Drawing.Point(100, 10);
            this.cboGroupName.Name = "cboGroupName";
            this.cboGroupName.Size = new System.Drawing.Size(121, 21);
            this.cboGroupName.TabIndex = 2;
            this.cboGroupName.Click += new System.EventHandler(this.cboGroupName_Click);
            // 
            // txtSheetNo
            // 
            this.txtSheetNo.Location = new System.Drawing.Point(100, 40);
            this.txtSheetNo.Name = "txtSheetNo";
            this.txtSheetNo.Size = new System.Drawing.Size(50, 20);
            this.txtSheetNo.TabIndex = 3;
            // 
            // lblSheetOf
            // 
            this.lblSheetOf.AutoSize = true;
            this.lblSheetOf.Location = new System.Drawing.Point(156, 43);
            this.lblSheetOf.Name = "lblSheetOf";
            this.lblSheetOf.Size = new System.Drawing.Size(16, 13);
            this.lblSheetOf.TabIndex = 4;
            this.lblSheetOf.Text = "of";
            // 
            // txtSheetOf
            // 
            this.txtSheetOf.Location = new System.Drawing.Point(175, 40);
            this.txtSheetOf.Name = "txtSheetOf";
            this.txtSheetOf.Size = new System.Drawing.Size(50, 20);
            this.txtSheetOf.TabIndex = 5;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 69);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(75, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "Plot Definition:";
            // 
            // cboPlotDef
            // 
            this.cboPlotDef.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboPlotDef.FormattingEnabled = true;
            this.cboPlotDef.Location = new System.Drawing.Point(100, 69);
            this.cboPlotDef.Name = "cboPlotDef";
            this.cboPlotDef.Size = new System.Drawing.Size(121, 21);
            this.cboPlotDef.TabIndex = 7;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.cboSheetSize);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.gboScale);
            this.groupBox1.Controls.Add(this.gboCustoms);
            this.groupBox1.Location = new System.Drawing.Point(325, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(297, 301);
            this.groupBox1.TabIndex = 9;
            this.groupBox1.TabStop = false;
            // 
            // cboSheetSize
            // 
            this.cboSheetSize.BackColor = System.Drawing.SystemColors.Window;
            this.cboSheetSize.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cboSheetSize.FormattingEnabled = true;
            this.cboSheetSize.Items.AddRange(new object[] {
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "NO"});
            this.cboSheetSize.Location = new System.Drawing.Point(94, 37);
            this.cboSheetSize.Name = "cboSheetSize";
            this.cboSheetSize.Size = new System.Drawing.Size(75, 21);
            this.cboSheetSize.TabIndex = 29;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 37);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(61, 13);
            this.label2.TabIndex = 28;
            this.label2.Text = "Sheet Size:";
            // 
            // gboScale
            // 
            this.gboScale.Controls.Add(this.txtScaleFont);
            this.gboScale.Controls.Add(this.lblScaleFont);
            this.gboScale.Controls.Add(this.txtScaleSymbol);
            this.gboScale.Controls.Add(this.lblSymbol);
            this.gboScale.Controls.Add(this.txtScalePlot);
            this.gboScale.Controls.Add(this.lblPlotScale);
            this.gboScale.Location = new System.Drawing.Point(9, 101);
            this.gboScale.Name = "gboScale";
            this.gboScale.Size = new System.Drawing.Size(150, 100);
            this.gboScale.TabIndex = 27;
            this.gboScale.TabStop = false;
            this.gboScale.Text = "Scales:";
            // 
            // txtScaleFont
            // 
            this.txtScaleFont.BackColor = System.Drawing.Color.Yellow;
            this.txtScaleFont.Location = new System.Drawing.Point(75, 69);
            this.txtScaleFont.Name = "txtScaleFont";
            this.txtScaleFont.Size = new System.Drawing.Size(50, 20);
            this.txtScaleFont.TabIndex = 5;
            this.txtScaleFont.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblScaleFont
            // 
            this.lblScaleFont.AutoSize = true;
            this.lblScaleFont.Location = new System.Drawing.Point(16, 72);
            this.lblScaleFont.Name = "lblScaleFont";
            this.lblScaleFont.Size = new System.Drawing.Size(31, 13);
            this.lblScaleFont.TabIndex = 4;
            this.lblScaleFont.Text = "Font:";
            // 
            // txtScaleSymbol
            // 
            this.txtScaleSymbol.BackColor = System.Drawing.Color.Yellow;
            this.txtScaleSymbol.Location = new System.Drawing.Point(75, 43);
            this.txtScaleSymbol.Name = "txtScaleSymbol";
            this.txtScaleSymbol.Size = new System.Drawing.Size(50, 20);
            this.txtScaleSymbol.TabIndex = 3;
            this.txtScaleSymbol.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblSymbol
            // 
            this.lblSymbol.AutoSize = true;
            this.lblSymbol.Location = new System.Drawing.Point(16, 47);
            this.lblSymbol.Name = "lblSymbol";
            this.lblSymbol.Size = new System.Drawing.Size(44, 13);
            this.lblSymbol.TabIndex = 2;
            this.lblSymbol.Text = "Symbol:";
            // 
            // txtScalePlot
            // 
            this.txtScalePlot.BackColor = System.Drawing.Color.Yellow;
            this.txtScalePlot.Location = new System.Drawing.Point(75, 17);
            this.txtScalePlot.Name = "txtScalePlot";
            this.txtScalePlot.Size = new System.Drawing.Size(50, 20);
            this.txtScalePlot.TabIndex = 1;
            this.txtScalePlot.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblPlotScale
            // 
            this.lblPlotScale.AutoSize = true;
            this.lblPlotScale.Location = new System.Drawing.Point(16, 20);
            this.lblPlotScale.Name = "lblPlotScale";
            this.lblPlotScale.Size = new System.Drawing.Size(28, 13);
            this.lblPlotScale.TabIndex = 0;
            this.lblPlotScale.Text = "Plot:";
            // 
            // gboCustoms
            // 
            this.gboCustoms.Controls.Add(this.clbCustoms);
            this.gboCustoms.Location = new System.Drawing.Point(9, 210);
            this.gboCustoms.Name = "gboCustoms";
            this.gboCustoms.Size = new System.Drawing.Size(275, 85);
            this.gboCustoms.TabIndex = 26;
            this.gboCustoms.TabStop = false;
            this.gboCustoms.Text = "Custom(s):";
            // 
            // clbCustoms
            // 
            this.clbCustoms.FormattingEnabled = true;
            this.clbCustoms.Location = new System.Drawing.Point(19, 19);
            this.clbCustoms.Name = "clbCustoms";
            this.clbCustoms.Size = new System.Drawing.Size(227, 49);
            this.clbCustoms.TabIndex = 19;
            // 
            // dgvPlotDefs
            // 
            this.dgvPlotDefs.AllowUserToAddRows = false;
            this.dgvPlotDefs.AllowUserToDeleteRows = false;
            this.dgvPlotDefs.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvPlotDefs.Location = new System.Drawing.Point(13, 111);
            this.dgvPlotDefs.MultiSelect = false;
            this.dgvPlotDefs.Name = "dgvPlotDefs";
            this.dgvPlotDefs.ReadOnly = true;
            this.dgvPlotDefs.Size = new System.Drawing.Size(296, 194);
            this.dgvPlotDefs.TabIndex = 10;
            this.dgvPlotDefs.SelectionChanged += new System.EventHandler(this.dgvPlotDefs_SelectionChanged);
            this.dgvPlotDefs.SortCompare += new System.Windows.Forms.DataGridViewSortCompareEventHandler(this.dgvPlotDefs_SortCompare);
            this.dgvPlotDefs.Click += new System.EventHandler(this.dgvPlotDefs_Click);
            // 
            // btnClear
            // 
            this.btnClear.Location = new System.Drawing.Point(200, 326);
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(75, 23);
            this.btnClear.TabIndex = 11;
            this.btnClear.Text = "&Clear";
            this.btnClear.UseVisualStyleBackColor = true;
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(548, 326);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(75, 23);
            this.btnClose.TabIndex = 12;
            this.btnClose.Text = "Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnAddPlotDef
            // 
            this.btnAddPlotDef.Location = new System.Drawing.Point(228, 69);
            this.btnAddPlotDef.Name = "btnAddPlotDef";
            this.btnAddPlotDef.Size = new System.Drawing.Size(23, 23);
            this.btnAddPlotDef.TabIndex = 13;
            this.btnAddPlotDef.Text = "+";
            this.btnAddPlotDef.UseVisualStyleBackColor = true;
            this.btnAddPlotDef.Click += new System.EventHandler(this.btnAddPlotDef_Click);
            // 
            // btuRemovePlot
            // 
            this.btuRemovePlot.Location = new System.Drawing.Point(257, 69);
            this.btuRemovePlot.Name = "btuRemovePlot";
            this.btuRemovePlot.Size = new System.Drawing.Size(23, 23);
            this.btuRemovePlot.TabIndex = 14;
            this.btuRemovePlot.Text = "-";
            this.btuRemovePlot.UseVisualStyleBackColor = true;
            this.btuRemovePlot.Click += new System.EventHandler(this.btuRemovePlot_Click);
            // 
            // btnUp
            // 
            this.btnUp.Location = new System.Drawing.Point(286, 53);
            this.btnUp.Name = "btnUp";
            this.btnUp.Size = new System.Drawing.Size(23, 23);
            this.btnUp.TabIndex = 15;
            this.btnUp.Text = "Up";
            this.btnUp.UseVisualStyleBackColor = true;
            this.btnUp.Click += new System.EventHandler(this.btnUp_Click);
            // 
            // btnDown
            // 
            this.btnDown.Location = new System.Drawing.Point(286, 82);
            this.btnDown.Name = "btnDown";
            this.btnDown.Size = new System.Drawing.Size(23, 23);
            this.btnDown.TabIndex = 16;
            this.btnDown.Text = "Down";
            this.btnDown.UseVisualStyleBackColor = true;
            this.btnDown.Click += new System.EventHandler(this.btnDown_Click);
            // 
            // btnUpdate
            // 
            this.btnUpdate.Location = new System.Drawing.Point(374, 326);
            this.btnUpdate.Name = "btnUpdate";
            this.btnUpdate.Size = new System.Drawing.Size(75, 23);
            this.btnUpdate.TabIndex = 17;
            this.btnUpdate.Text = "&Update";
            this.btnUpdate.UseVisualStyleBackColor = true;
            this.btnUpdate.Click += new System.EventHandler(this.btnUpdate_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Enabled = false;
            this.btnDelete.Location = new System.Drawing.Point(461, 326);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(75, 23);
            this.btnDelete.TabIndex = 18;
            this.btnDelete.Text = "&Delete";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(287, 326);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(75, 23);
            this.btnAdd.TabIndex = 19;
            this.btnAdd.Text = "&Add";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // lblDefinedBy
            // 
            this.lblDefinedBy.AutoSize = true;
            this.lblDefinedBy.Location = new System.Drawing.Point(16, 312);
            this.lblDefinedBy.Name = "lblDefinedBy";
            this.lblDefinedBy.Size = new System.Drawing.Size(56, 13);
            this.lblDefinedBy.TabIndex = 20;
            this.lblDefinedBy.Text = "DefinedBy";
            // 
            // lblDefinedDate
            // 
            this.lblDefinedDate.AutoSize = true;
            this.lblDefinedDate.Location = new System.Drawing.Point(16, 331);
            this.lblDefinedDate.Name = "lblDefinedDate";
            this.lblDefinedDate.Size = new System.Drawing.Size(67, 13);
            this.lblDefinedDate.TabIndex = 34;
            this.lblDefinedDate.Text = "DefinedDate";
            // 
            // frmPlotGroupDef
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(634, 361);
            this.Controls.Add(this.lblDefinedDate);
            this.Controls.Add(this.lblDefinedBy);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.btnDelete);
            this.Controls.Add(this.btnUpdate);
            this.Controls.Add(this.btnDown);
            this.Controls.Add(this.btnUp);
            this.Controls.Add(this.btuRemovePlot);
            this.Controls.Add(this.btnAddPlotDef);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnClear);
            this.Controls.Add(this.dgvPlotDefs);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.cboPlotDef);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtSheetOf);
            this.Controls.Add(this.lblSheetOf);
            this.Controls.Add(this.txtSheetNo);
            this.Controls.Add(this.cboGroupName);
            this.Controls.Add(this.lblSheet);
            this.Controls.Add(this.lblGroupName);
            this.Name = "frmPlotGroupDef";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.frmPlotGroupDef_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.gboScale.ResumeLayout(false);
            this.gboScale.PerformLayout();
            this.gboCustoms.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.dgvPlotDefs)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblGroupName;
        private System.Windows.Forms.Label lblSheet;
        private System.Windows.Forms.ComboBox cboGroupName;
        private System.Windows.Forms.TextBox txtSheetNo;
        private System.Windows.Forms.Label lblSheetOf;
        private System.Windows.Forms.TextBox txtSheetOf;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ComboBox cboPlotDef;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox gboCustoms;
        private System.Windows.Forms.CheckedListBox clbCustoms;
        private System.Windows.Forms.GroupBox gboScale;
        private System.Windows.Forms.TextBox txtScaleFont;
        private System.Windows.Forms.Label lblScaleFont;
        private System.Windows.Forms.TextBox txtScaleSymbol;
        private System.Windows.Forms.Label lblSymbol;
        private System.Windows.Forms.TextBox txtScalePlot;
        private System.Windows.Forms.Label lblPlotScale;
        private System.Windows.Forms.ComboBox cboSheetSize;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.DataGridView dgvPlotDefs;
        private System.Windows.Forms.Button btnClear;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.Button btnAddPlotDef;
        private System.Windows.Forms.Button btuRemovePlot;
        private System.Windows.Forms.Button btnUp;
        private System.Windows.Forms.Button btnDown;
        private System.Windows.Forms.Button btnUpdate;
        private System.Windows.Forms.Button btnDelete;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Label lblDefinedBy;
        private System.Windows.Forms.Label lblDefinedDate;
    }
}