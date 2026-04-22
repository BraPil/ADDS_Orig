namespace Adds
{
    partial class frmLineDialog
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
            this.lblSub = new System.Windows.Forms.Label();
            this.lblLine = new System.Windows.Forms.Label();
            this.lblVolts = new System.Windows.Forms.Label();
            this.cboSubstations = new System.Windows.Forms.ComboBox();
            this.cboLines = new System.Windows.Forms.ComboBox();
            this.cboVolts = new System.Windows.Forms.ComboBox();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnOk = new System.Windows.Forms.Button();
            this.txtLineCode = new System.Windows.Forms.TextBox();
            this.txtSubCode = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.txtVolts = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.cboFacID = new System.Windows.Forms.ComboBox();
            this.cboLineId = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // lblSub
            // 
            this.lblSub.AutoSize = true;
            this.lblSub.Location = new System.Drawing.Point(10, 49);
            this.lblSub.Name = "lblSub";
            this.lblSub.Size = new System.Drawing.Size(94, 13);
            this.lblSub.TabIndex = 0;
            this.lblSub.Text = "Substation\\FacID:";
            // 
            // lblLine
            // 
            this.lblLine.AutoSize = true;
            this.lblLine.Location = new System.Drawing.Point(10, 80);
            this.lblLine.Name = "lblLine";
            this.lblLine.Size = new System.Drawing.Size(30, 13);
            this.lblLine.TabIndex = 1;
            this.lblLine.Text = "Line:";
            // 
            // lblVolts
            // 
            this.lblVolts.AutoSize = true;
            this.lblVolts.Location = new System.Drawing.Point(10, 111);
            this.lblVolts.Name = "lblVolts";
            this.lblVolts.Size = new System.Drawing.Size(46, 13);
            this.lblVolts.TabIndex = 2;
            this.lblVolts.Text = "Voltage:";
            // 
            // cboSubstations
            // 
            this.cboSubstations.FormattingEnabled = true;
            this.cboSubstations.Location = new System.Drawing.Point(102, 46);
            this.cboSubstations.Name = "cboSubstations";
            this.cboSubstations.Size = new System.Drawing.Size(375, 21);
            this.cboSubstations.TabIndex = 3;
            this.cboSubstations.SelectedIndexChanged += new System.EventHandler(this.cboSubstations_SelectedIndexChanged);
            // 
            // cboLines
            // 
            this.cboLines.FormattingEnabled = true;
            this.cboLines.Location = new System.Drawing.Point(102, 76);
            this.cboLines.Name = "cboLines";
            this.cboLines.Size = new System.Drawing.Size(375, 21);
            this.cboLines.TabIndex = 4;
            this.cboLines.SelectedIndexChanged += new System.EventHandler(this.cboLines_SelectedIndexChanged);
            // 
            // cboVolts
            // 
            this.cboVolts.FormattingEnabled = true;
            this.cboVolts.Location = new System.Drawing.Point(102, 107);
            this.cboVolts.Name = "cboVolts";
            this.cboVolts.Size = new System.Drawing.Size(71, 21);
            this.cboVolts.TabIndex = 5;
            this.cboVolts.SelectedIndexChanged += new System.EventHandler(this.cboVolts_SelectedIndexChanged);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(499, 128);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 6;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            // 
            // btnOk
            // 
            this.btnOk.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOk.Location = new System.Drawing.Point(406, 128);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 7;
            this.btnOk.Text = "OK";
            this.btnOk.UseVisualStyleBackColor = true;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // txtLineCode
            // 
            this.txtLineCode.Location = new System.Drawing.Point(158, 16);
            this.txtLineCode.Name = "txtLineCode";
            this.txtLineCode.ReadOnly = true;
            this.txtLineCode.Size = new System.Drawing.Size(40, 20);
            this.txtLineCode.TabIndex = 13;
            // 
            // txtSubCode
            // 
            this.txtSubCode.Location = new System.Drawing.Point(102, 16);
            this.txtSubCode.Name = "txtSubCode";
            this.txtSubCode.ReadOnly = true;
            this.txtSubCode.Size = new System.Drawing.Size(50, 20);
            this.txtSubCode.TabIndex = 12;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(10, 19);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(67, 13);
            this.label1.TabIndex = 11;
            this.label1.Text = "Layer Name:";
            // 
            // txtVolts
            // 
            this.txtVolts.Location = new System.Drawing.Point(204, 16);
            this.txtVolts.Name = "txtVolts";
            this.txtVolts.ReadOnly = true;
            this.txtVolts.Size = new System.Drawing.Size(20, 20);
            this.txtVolts.TabIndex = 14;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(230, 19);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(161, 13);
            this.label2.TabIndex = 15;
            this.label2.Text = "(Fac ID - Line ID - Voltage Code)";
            // 
            // cboFacID
            // 
            this.cboFacID.FormattingEnabled = true;
            this.cboFacID.Location = new System.Drawing.Point(494, 46);
            this.cboFacID.Name = "cboFacID";
            this.cboFacID.Size = new System.Drawing.Size(80, 21);
            this.cboFacID.TabIndex = 16;
            this.cboFacID.SelectedIndexChanged += new System.EventHandler(this.cboFacID_SelectedIndexChanged);
            // 
            // cboLineId
            // 
            this.cboLineId.FormattingEnabled = true;
            this.cboLineId.Location = new System.Drawing.Point(494, 76);
            this.cboLineId.Name = "cboLineId";
            this.cboLineId.Size = new System.Drawing.Size(80, 21);
            this.cboLineId.TabIndex = 17;
            this.cboLineId.SelectedIndexChanged += new System.EventHandler(this.cboLineId_SelectedIndexChanged);
            // 
            // frmLineDialog
            // 
            this.AcceptButton = this.btnOk;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(586, 166);
            this.ControlBox = false;
            this.Controls.Add(this.cboLineId);
            this.Controls.Add(this.cboFacID);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtVolts);
            this.Controls.Add(this.txtLineCode);
            this.Controls.Add(this.txtSubCode);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.cboVolts);
            this.Controls.Add(this.cboLines);
            this.Controls.Add(this.cboSubstations);
            this.Controls.Add(this.lblVolts);
            this.Controls.Add(this.lblLine);
            this.Controls.Add(this.lblSub);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmLineDialog";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "frmLineDialog";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblSub;
        private System.Windows.Forms.Label lblLine;
        private System.Windows.Forms.Label lblVolts;
        private System.Windows.Forms.ComboBox cboSubstations;
        private System.Windows.Forms.ComboBox cboLines;
        private System.Windows.Forms.ComboBox cboVolts;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnOk;
        private System.Windows.Forms.TextBox txtLineCode;
        private System.Windows.Forms.TextBox txtSubCode;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtVolts;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.ComboBox cboFacID;
        private System.Windows.Forms.ComboBox cboLineId;
    }
}