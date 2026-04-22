namespace Adds
{
    partial class frmLogin
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
            this.cboDBList = new System.Windows.Forms.ComboBox();
            this.lblDBName = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.lblPwd = new System.Windows.Forms.Label();
            this.btnOk = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.txtUserID = new System.Windows.Forms.TextBox();
            this.chkboxSaveSettings = new System.Windows.Forms.CheckBox();
            this.btnCancel = new System.Windows.Forms.Button();
            this.txtAppPwd = new System.Windows.Forms.TextBox();
            this.txtAppID = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // cboDBList
            // 
            this.cboDBList.FormattingEnabled = true;
            this.cboDBList.Location = new System.Drawing.Point(80, 50);
            this.cboDBList.Name = "cboDBList";
            this.cboDBList.Size = new System.Drawing.Size(177, 21);
            this.cboDBList.TabIndex = 0;
            this.cboDBList.SelectedIndexChanged += new System.EventHandler(this.cboDBList_SelectedIndexChanged);
            this.cboDBList.SelectionChangeCommitted += new System.EventHandler(this.cboDBList_SelectionChangeCommitted);
            // 
            // lblDBName
            // 
            this.lblDBName.AutoSize = true;
            this.lblDBName.Location = new System.Drawing.Point(12, 53);
            this.lblDBName.Name = "lblDBName";
            this.lblDBName.Size = new System.Drawing.Size(59, 13);
            this.lblDBName.TabIndex = 1;
            this.lblDBName.Text = "Database: ";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(81, 86);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(170, 20);
            this.textBox1.TabIndex = 2;
            this.textBox1.UseSystemPasswordChar = true;
            // 
            // lblPwd
            // 
            this.lblPwd.AutoSize = true;
            this.lblPwd.Location = new System.Drawing.Point(16, 93);
            this.lblPwd.Name = "lblPwd";
            this.lblPwd.Size = new System.Drawing.Size(59, 13);
            this.lblPwd.TabIndex = 3;
            this.lblPwd.Text = "Password: ";
            // 
            // btnOk
            // 
            this.btnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOk.Location = new System.Drawing.Point(115, 137);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 4;
            this.btnOk.Text = "Login";
            this.btnOk.UseVisualStyleBackColor = true;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 19);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 6;
            this.label1.Text = "User ID: ";
            // 
            // txtUserID
            // 
            this.txtUserID.Location = new System.Drawing.Point(80, 15);
            this.txtUserID.Name = "txtUserID";
            this.txtUserID.Size = new System.Drawing.Size(170, 20);
            this.txtUserID.TabIndex = 5;
            // 
            // chkboxSaveSettings
            // 
            this.chkboxSaveSettings.AutoSize = true;
            this.chkboxSaveSettings.Location = new System.Drawing.Point(81, 113);
            this.chkboxSaveSettings.Name = "chkboxSaveSettings";
            this.chkboxSaveSettings.Size = new System.Drawing.Size(92, 17);
            this.chkboxSaveSettings.TabIndex = 9;
            this.chkboxSaveSettings.Text = "Save Settings";
            this.chkboxSaveSettings.UseVisualStyleBackColor = true;
            // 
            // btnCancel
            // 
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(209, 137);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 10;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // txtAppPwd
            // 
            this.txtAppPwd.Location = new System.Drawing.Point(19, 250);
            this.txtAppPwd.Name = "txtAppPwd";
            this.txtAppPwd.ReadOnly = true;
            this.txtAppPwd.Size = new System.Drawing.Size(10, 20);
            this.txtAppPwd.TabIndex = 11;
            this.txtAppPwd.TabStop = false;
            // 
            // txtAppID
            // 
            this.txtAppID.Location = new System.Drawing.Point(19, 250);
            this.txtAppID.Name = "txtAppID";
            this.txtAppID.ReadOnly = true;
            this.txtAppID.Size = new System.Drawing.Size(10, 20);
            this.txtAppID.TabIndex = 12;
            this.txtAppID.TabStop = false;
            // 
            // frmLogin
            // 
            this.AcceptButton = this.btnOk;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancel;
            this.ClientSize = new System.Drawing.Size(296, 179);
            this.ControlBox = false;
            this.Controls.Add(this.txtAppID);
            this.Controls.Add(this.txtAppPwd);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.chkboxSaveSettings);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.txtUserID);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.lblPwd);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.lblDBName);
            this.Controls.Add(this.cboDBList);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "frmLogin";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "ADDS Database Login";
            this.Load += new System.EventHandler(this.frmLogin_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.ComboBox cboDBList;
        private System.Windows.Forms.Label lblDBName;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.Label lblPwd;
        private System.Windows.Forms.Button btnOk;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtUserID;
        private System.Windows.Forms.CheckBox chkboxSaveSettings;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.TextBox txtAppPwd;
        private System.Windows.Forms.TextBox txtAppID;
    }
}