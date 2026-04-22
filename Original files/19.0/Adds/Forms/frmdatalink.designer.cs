namespace Adds.Forms
{
    partial class frmDataLink
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
            this.txtDisplayText = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.txtURL = new System.Windows.Forms.TextBox();
            this.btnPlace = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnOK = new System.Windows.Forms.Button();
            this.txtDeviceID = new System.Windows.Forms.TextBox();
            this.rbtSOP = new System.Windows.Forms.RadioButton();
            this.rbnKeyRep = new System.Windows.Forms.RadioButton();
            this.rbnKeyAccount = new System.Windows.Forms.RadioButton();
            this.rbnPrint = new System.Windows.Forms.RadioButton();
            this.rbnPictures = new System.Windows.Forms.RadioButton();
            this.rbnSTA = new System.Windows.Forms.RadioButton();
            this.rbnWEBFG = new System.Windows.Forms.RadioButton();
            this.rbnOther = new System.Windows.Forms.RadioButton();
            this.rbnOA = new System.Windows.Forms.RadioButton();
            this.SuspendLayout();
            // 
            // txtDisplayText
            // 
            this.txtDisplayText.Location = new System.Drawing.Point(77, 57);
            this.txtDisplayText.Name = "txtDisplayText";
            this.txtDisplayText.Size = new System.Drawing.Size(386, 20);
            this.txtDisplayText.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(3, 57);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(68, 13);
            this.label1.TabIndex = 1;
            this.label1.Text = "Display Text:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(3, 89);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(53, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "File/URL:";
            // 
            // txtURL
            // 
            this.txtURL.Location = new System.Drawing.Point(77, 89);
            this.txtURL.Multiline = true;
            this.txtURL.Name = "txtURL";
            this.txtURL.Size = new System.Drawing.Size(386, 71);
            this.txtURL.TabIndex = 3;
            // 
            // btnPlace
            // 
            this.btnPlace.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnPlace.Location = new System.Drawing.Point(226, 166);
            this.btnPlace.Name = "btnPlace";
            this.btnPlace.Size = new System.Drawing.Size(75, 23);
            this.btnPlace.TabIndex = 4;
            this.btnPlace.Text = "Place Link";
            this.btnPlace.UseVisualStyleBackColor = true;
            this.btnPlace.Click += new System.EventHandler(this.btnPlace_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(388, 166);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 5;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            // 
            // btnOK
            // 
            this.btnOK.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Location = new System.Drawing.Point(307, 166);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(75, 23);
            this.btnOK.TabIndex = 6;
            this.btnOK.Text = "Ok";
            this.btnOK.UseVisualStyleBackColor = true;
            // 
            // txtDeviceID
            // 
            this.txtDeviceID.Location = new System.Drawing.Point(77, 166);
            this.txtDeviceID.Name = "txtDeviceID";
            this.txtDeviceID.ReadOnly = true;
            this.txtDeviceID.Size = new System.Drawing.Size(115, 20);
            this.txtDeviceID.TabIndex = 7;
            // 
            // rbtSOP
            // 
            this.rbtSOP.AutoSize = true;
            this.rbtSOP.Location = new System.Drawing.Point(89, 34);
            this.rbtSOP.Name = "rbtSOP";
            this.rbtSOP.Size = new System.Drawing.Size(47, 17);
            this.rbtSOP.TabIndex = 8;
            this.rbtSOP.TabStop = true;
            this.rbtSOP.Text = "SOP";
            this.rbtSOP.UseVisualStyleBackColor = true;
            this.rbtSOP.CheckedChanged += new System.EventHandler(this.rbtSOP_CheckedChanged);
            // 
            // rbnKeyRep
            // 
            this.rbnKeyRep.AutoSize = true;
            this.rbnKeyRep.Location = new System.Drawing.Point(196, 12);
            this.rbnKeyRep.Name = "rbnKeyRep";
            this.rbnKeyRep.Size = new System.Drawing.Size(71, 17);
            this.rbnKeyRep.TabIndex = 9;
            this.rbnKeyRep.TabStop = true;
            this.rbnKeyRep.Text = "KEY REP";
            this.rbnKeyRep.UseVisualStyleBackColor = true;
            this.rbnKeyRep.CheckedChanged += new System.EventHandler(this.rbnKeyRep_CheckedChanged);
            // 
            // rbnKeyAccount
            // 
            this.rbnKeyAccount.AutoSize = true;
            this.rbnKeyAccount.Location = new System.Drawing.Point(89, 11);
            this.rbnKeyAccount.Name = "rbnKeyAccount";
            this.rbnKeyAccount.Size = new System.Drawing.Size(101, 17);
            this.rbnKeyAccount.TabIndex = 10;
            this.rbnKeyAccount.TabStop = true;
            this.rbnKeyAccount.Text = "KEY ACCOUNT";
            this.rbnKeyAccount.UseVisualStyleBackColor = true;
            this.rbnKeyAccount.CheckedChanged += new System.EventHandler(this.rbnKeyAccount_CheckedChanged);
            // 
            // rbnPrint
            // 
            this.rbnPrint.AutoSize = true;
            this.rbnPrint.Location = new System.Drawing.Point(377, 11);
            this.rbnPrint.Name = "rbnPrint";
            this.rbnPrint.Size = new System.Drawing.Size(58, 17);
            this.rbnPrint.TabIndex = 11;
            this.rbnPrint.TabStop = true;
            this.rbnPrint.Text = "PRINT";
            this.rbnPrint.UseVisualStyleBackColor = true;
            this.rbnPrint.CheckedChanged += new System.EventHandler(this.rbnPrint_CheckedChanged);
            // 
            // rbnPictures
            // 
            this.rbnPictures.AutoSize = true;
            this.rbnPictures.Location = new System.Drawing.Point(273, 12);
            this.rbnPictures.Name = "rbnPictures";
            this.rbnPictures.Size = new System.Drawing.Size(79, 17);
            this.rbnPictures.TabIndex = 12;
            this.rbnPictures.TabStop = true;
            this.rbnPictures.Text = "PICTURES";
            this.rbnPictures.UseVisualStyleBackColor = true;
            this.rbnPictures.CheckedChanged += new System.EventHandler(this.rbnPictures_CheckedChanged);
            // 
            // rbnSTA
            // 
            this.rbnSTA.AutoSize = true;
            this.rbnSTA.Location = new System.Drawing.Point(143, 34);
            this.rbnSTA.Name = "rbnSTA";
            this.rbnSTA.Size = new System.Drawing.Size(46, 17);
            this.rbnSTA.TabIndex = 13;
            this.rbnSTA.TabStop = true;
            this.rbnSTA.Text = "STA";
            this.rbnSTA.UseVisualStyleBackColor = true;
            this.rbnSTA.CheckedChanged += new System.EventHandler(this.rbnSTA_CheckedChanged);
            // 
            // rbnWEBFG
            // 
            this.rbnWEBFG.AutoSize = true;
            this.rbnWEBFG.Location = new System.Drawing.Point(196, 34);
            this.rbnWEBFG.Name = "rbnWEBFG";
            this.rbnWEBFG.Size = new System.Drawing.Size(64, 17);
            this.rbnWEBFG.TabIndex = 14;
            this.rbnWEBFG.TabStop = true;
            this.rbnWEBFG.Text = "WEBFG";
            this.rbnWEBFG.UseVisualStyleBackColor = true;
            this.rbnWEBFG.CheckedChanged += new System.EventHandler(this.rbnWEBFG_CheckedChanged);
            // 
            // rbnOther
            // 
            this.rbnOther.AutoSize = true;
            this.rbnOther.Location = new System.Drawing.Point(377, 34);
            this.rbnOther.Name = "rbnOther";
            this.rbnOther.Size = new System.Drawing.Size(51, 17);
            this.rbnOther.TabIndex = 15;
            this.rbnOther.TabStop = true;
            this.rbnOther.Text = "Other";
            this.rbnOther.UseVisualStyleBackColor = true;
            this.rbnOther.CheckedChanged += new System.EventHandler(this.rbnOther_CheckedChanged);
            // 
            // rbnOA
            // 
            this.rbnOA.AutoSize = true;
            this.rbnOA.Location = new System.Drawing.Point(273, 34);
            this.rbnOA.Name = "rbnOA";
            this.rbnOA.Size = new System.Drawing.Size(40, 17);
            this.rbnOA.TabIndex = 16;
            this.rbnOA.TabStop = true;
            this.rbnOA.Text = "OA";
            this.rbnOA.UseVisualStyleBackColor = true;
            this.rbnOA.CheckedChanged += new System.EventHandler(this.rbnOA_CheckedChanged);
            // 
            // frmDataLink
            // 
            this.AcceptButton = this.btnOK;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(475, 201);
            this.ControlBox = false;
            this.Controls.Add(this.rbnOA);
            this.Controls.Add(this.rbnOther);
            this.Controls.Add(this.rbnWEBFG);
            this.Controls.Add(this.rbnSTA);
            this.Controls.Add(this.rbnPictures);
            this.Controls.Add(this.rbnPrint);
            this.Controls.Add(this.rbnKeyAccount);
            this.Controls.Add(this.rbnKeyRep);
            this.Controls.Add(this.rbtSOP);
            this.Controls.Add(this.txtDeviceID);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnPlace);
            this.Controls.Add(this.txtURL);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtDisplayText);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "frmDataLink";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "frmDataLink";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtDisplayText;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox txtURL;
        private System.Windows.Forms.Button btnPlace;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnOK;
        private System.Windows.Forms.TextBox txtDeviceID;
        private System.Windows.Forms.RadioButton rbtSOP;
        private System.Windows.Forms.RadioButton rbnKeyRep;
        private System.Windows.Forms.RadioButton rbnKeyAccount;
        private System.Windows.Forms.RadioButton rbnPrint;
        private System.Windows.Forms.RadioButton rbnPictures;
        private System.Windows.Forms.RadioButton rbnSTA;
        private System.Windows.Forms.RadioButton rbnWEBFG;
        private System.Windows.Forms.RadioButton rbnOther;
        private System.Windows.Forms.RadioButton rbnOA;
    }
}