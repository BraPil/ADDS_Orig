namespace Adds.Forms
{
    partial class frmPlotCustoms
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
            this.lblName = new System.Windows.Forms.Label();
            this.lblDescr = new System.Windows.Forms.Label();
            this.lblDiv = new System.Windows.Forms.Label();
            this.lblDefinedDate = new System.Windows.Forms.Label();
            this.lblDefinedBy = new System.Windows.Forms.Label();
            this.cboName = new System.Windows.Forms.ComboBox();
            this.txtDescr = new System.Windows.Forms.TextBox();
            this.cboDiv = new System.Windows.Forms.ComboBox();
            this.btnAdd = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblName
            // 
            this.lblName.AutoSize = true;
            this.lblName.Location = new System.Drawing.Point(10, 16);
            this.lblName.Name = "lblName";
            this.lblName.Size = new System.Drawing.Size(38, 13);
            this.lblName.TabIndex = 0;
            this.lblName.Text = "Name:";
            // 
            // lblDescr
            // 
            this.lblDescr.AutoSize = true;
            this.lblDescr.Location = new System.Drawing.Point(9, 54);
            this.lblDescr.Name = "lblDescr";
            this.lblDescr.Size = new System.Drawing.Size(63, 13);
            this.lblDescr.TabIndex = 1;
            this.lblDescr.Text = "Description:";
            // 
            // lblDiv
            // 
            this.lblDiv.AutoSize = true;
            this.lblDiv.Location = new System.Drawing.Point(9, 123);
            this.lblDiv.Name = "lblDiv";
            this.lblDiv.Size = new System.Drawing.Size(47, 13);
            this.lblDiv.TabIndex = 2;
            this.lblDiv.Text = "Division:";
            // 
            // lblDefinedDate
            // 
            this.lblDefinedDate.AutoSize = true;
            this.lblDefinedDate.Location = new System.Drawing.Point(10, 163);
            this.lblDefinedDate.Name = "lblDefinedDate";
            this.lblDefinedDate.Size = new System.Drawing.Size(67, 13);
            this.lblDefinedDate.TabIndex = 35;
            this.lblDefinedDate.Text = "DefinedDate";
            // 
            // lblDefinedBy
            // 
            this.lblDefinedBy.AutoSize = true;
            this.lblDefinedBy.Location = new System.Drawing.Point(10, 150);
            this.lblDefinedBy.Name = "lblDefinedBy";
            this.lblDefinedBy.Size = new System.Drawing.Size(56, 13);
            this.lblDefinedBy.TabIndex = 34;
            this.lblDefinedBy.Text = "DefinedBy";
            // 
            // cboName
            // 
            this.cboName.FormattingEnabled = true;
            this.cboName.Location = new System.Drawing.Point(75, 13);
            this.cboName.Name = "cboName";
            this.cboName.Size = new System.Drawing.Size(121, 21);
            this.cboName.TabIndex = 36;
            this.cboName.SelectedIndexChanged += new System.EventHandler(this.cboName_SelectedIndexChanged);
            // 
            // txtDescr
            // 
            this.txtDescr.Location = new System.Drawing.Point(75, 50);
            this.txtDescr.Multiline = true;
            this.txtDescr.Name = "txtDescr";
            this.txtDescr.Size = new System.Drawing.Size(200, 50);
            this.txtDescr.TabIndex = 37;
            this.txtDescr.Leave += new System.EventHandler(this.txtDescr_Leave);
            // 
            // cboDiv
            // 
            this.cboDiv.BackColor = System.Drawing.SystemColors.Window;
            this.cboDiv.FormattingEnabled = true;
            this.cboDiv.Items.AddRange(new object[] {
            "BH",
            "E_",
            "M_",
            "W_",
            "S_",
            "SE",
            "AL"});
            this.cboDiv.Location = new System.Drawing.Point(75, 120);
            this.cboDiv.Name = "cboDiv";
            this.cboDiv.Size = new System.Drawing.Size(75, 21);
            this.cboDiv.TabIndex = 38;
            this.cboDiv.SelectedIndexChanged += new System.EventHandler(this.cboDiv_SelectedIndexChanged);
            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(10, 180);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(75, 23);
            this.btnAdd.TabIndex = 39;
            this.btnAdd.Text = "&Add";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Location = new System.Drawing.Point(105, 180);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(75, 23);
            this.btnDelete.TabIndex = 40;
            this.btnDelete.Text = "&Delete";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(200, 180);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(75, 23);
            this.btnClose.TabIndex = 41;
            this.btnClose.Text = "&Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // frmPlotCustoms
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 211);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnDelete);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.cboDiv);
            this.Controls.Add(this.txtDescr);
            this.Controls.Add(this.cboName);
            this.Controls.Add(this.lblDefinedDate);
            this.Controls.Add(this.lblDefinedBy);
            this.Controls.Add(this.lblDiv);
            this.Controls.Add(this.lblDescr);
            this.Controls.Add(this.lblName);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "frmPlotCustoms";
            this.Text = "frmPlotCustoms";
            this.Load += new System.EventHandler(this.frmPlotCustoms_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblName;
        private System.Windows.Forms.Label lblDescr;
        private System.Windows.Forms.Label lblDiv;
        private System.Windows.Forms.Label lblDefinedDate;
        private System.Windows.Forms.Label lblDefinedBy;
        private System.Windows.Forms.ComboBox cboName;
        private System.Windows.Forms.TextBox txtDescr;
        private System.Windows.Forms.ComboBox cboDiv;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Button btnDelete;
        private System.Windows.Forms.Button btnClose;
    }
}