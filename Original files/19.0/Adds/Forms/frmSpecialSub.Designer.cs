namespace Adds
{
    partial class frmSpecialSub
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
            this.cboFacID = new System.Windows.Forms.ComboBox();
            this.cboSubstations = new System.Windows.Forms.ComboBox();
            this.lblSub = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.btnCheckSLDName = new System.Windows.Forms.Button();
            this.btnChkEMBName = new System.Windows.Forms.Button();
            this.btnAdd = new System.Windows.Forms.Button();
            this.txtAddsPanel = new System.Windows.Forms.TextBox();
            this.txtAddsDwg = new System.Windows.Forms.TextBox();
            this.txtEMBName = new System.Windows.Forms.TextBox();
            this.txtDMCName = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // cboFacID
            // 
            this.cboFacID.FormattingEnabled = true;
            this.cboFacID.Location = new System.Drawing.Point(549, 49);
            this.cboFacID.Name = "cboFacID";
            this.cboFacID.Size = new System.Drawing.Size(80, 21);
            this.cboFacID.TabIndex = 19;
            this.cboFacID.SelectedIndexChanged += new System.EventHandler(this.cboFacID_SelectedIndexChanged);
            // 
            // cboSubstations
            // 
            this.cboSubstations.FormattingEnabled = true;
            this.cboSubstations.Location = new System.Drawing.Point(157, 49);
            this.cboSubstations.Name = "cboSubstations";
            this.cboSubstations.Size = new System.Drawing.Size(375, 21);
            this.cboSubstations.TabIndex = 18;
            this.cboSubstations.SelectedIndexChanged += new System.EventHandler(this.cboSubstations_SelectedIndexChanged);
            // 
            // lblSub
            // 
            this.lblSub.AutoSize = true;
            this.lblSub.Location = new System.Drawing.Point(23, 52);
            this.lblSub.Name = "lblSub";
            this.lblSub.Size = new System.Drawing.Size(94, 13);
            this.lblSub.TabIndex = 17;
            this.lblSub.Text = "Substation\\FacID:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(23, 127);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(113, 13);
            this.label1.TabIndex = 20;
            this.label1.Text = "ADDS Diagram Name:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(23, 154);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(122, 13);
            this.label2.TabIndex = 21;
            this.label2.Text = "EMB Panel/View Name:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(26, 94);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(101, 13);
            this.label3.TabIndex = 22;
            this.label3.Text = "ADDS Panel Name:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(263, 128);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(140, 13);
            this.label4.TabIndex = 23;
            this.label4.Text = "DMC ADDS Diagram Name:";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // btnCheckSLDName
            // 
            this.btnCheckSLDName.Location = new System.Drawing.Point(572, 123);
            this.btnCheckSLDName.Name = "btnCheckSLDName";
            this.btnCheckSLDName.Size = new System.Drawing.Size(117, 23);
            this.btnCheckSLDName.TabIndex = 24;
            this.btnCheckSLDName.Text = "Check Adds Name";
            this.btnCheckSLDName.UseVisualStyleBackColor = true;
            this.btnCheckSLDName.Click += new System.EventHandler(this.btnCheckSLDName_Click);
            // 
            // btnChkEMBName
            // 
            this.btnChkEMBName.Location = new System.Drawing.Point(572, 161);
            this.btnChkEMBName.Name = "btnChkEMBName";
            this.btnChkEMBName.Size = new System.Drawing.Size(117, 23);
            this.btnChkEMBName.TabIndex = 25;
            this.btnChkEMBName.Text = "Check EMB Name";
            this.btnChkEMBName.UseVisualStyleBackColor = true;
            // 
            // btnAdd
            // 
            this.btnAdd.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnAdd.Location = new System.Drawing.Point(572, 205);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(75, 23);
            this.btnAdd.TabIndex = 26;
            this.btnAdd.Text = "Add It";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // txtAddsPanel
            // 
            this.txtAddsPanel.Location = new System.Drawing.Point(157, 94);
            this.txtAddsPanel.Name = "txtAddsPanel";
            this.txtAddsPanel.Size = new System.Drawing.Size(100, 20);
            this.txtAddsPanel.TabIndex = 27;
            // 
            // txtAddsDwg
            // 
            this.txtAddsDwg.Location = new System.Drawing.Point(157, 125);
            this.txtAddsDwg.Name = "txtAddsDwg";
            this.txtAddsDwg.Size = new System.Drawing.Size(100, 20);
            this.txtAddsDwg.TabIndex = 28;
            // 
            // txtEMBName
            // 
            this.txtEMBName.Location = new System.Drawing.Point(157, 151);
            this.txtEMBName.MaxLength = 16;
            this.txtEMBName.Name = "txtEMBName";
            this.txtEMBName.Size = new System.Drawing.Size(199, 20);
            this.txtEMBName.TabIndex = 29;
            // 
            // txtDMCName
            // 
            this.txtDMCName.Location = new System.Drawing.Point(427, 128);
            this.txtDMCName.Name = "txtDMCName";
            this.txtDMCName.Size = new System.Drawing.Size(100, 20);
            this.txtDMCName.TabIndex = 30;
            // 
            // frmSpecialSub
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(721, 252);
            this.Controls.Add(this.txtDMCName);
            this.Controls.Add(this.txtEMBName);
            this.Controls.Add(this.txtAddsDwg);
            this.Controls.Add(this.txtAddsPanel);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.btnChkEMBName);
            this.Controls.Add(this.btnCheckSLDName);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cboFacID);
            this.Controls.Add(this.cboSubstations);
            this.Controls.Add(this.lblSub);
            this.Name = "frmSpecialSub";
            this.Text = "frmSpecialSub";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cboFacID;
        private System.Windows.Forms.ComboBox cboSubstations;
        private System.Windows.Forms.Label lblSub;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button btnCheckSLDName;
        private System.Windows.Forms.Button btnChkEMBName;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.TextBox txtAddsPanel;
        private System.Windows.Forms.TextBox txtAddsDwg;
        private System.Windows.Forms.TextBox txtEMBName;
        private System.Windows.Forms.TextBox txtDMCName;
    }
}