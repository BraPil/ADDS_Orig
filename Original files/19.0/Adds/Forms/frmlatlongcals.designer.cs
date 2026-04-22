namespace Adds
{
    partial class frmLatLongCals
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
            this.label1 = new System.Windows.Forms.Label();
            this.txtLat1 = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.txtLong1 = new System.Windows.Forms.TextBox();
            this.txtLong2 = new System.Windows.Forms.TextBox();
            this.txtLat2 = new System.Windows.Forms.TextBox();
            this.btnOk = new System.Windows.Forms.Button();
            this.txtResult = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 34);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(51, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Latitde 1:";
            // 
            // txtLat1
            // 
            this.txtLat1.Location = new System.Drawing.Point(75, 31);
            this.txtLat1.Name = "txtLat1";
            this.txtLat1.Size = new System.Drawing.Size(131, 20);
            this.txtLat1.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 70);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(51, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Latitde 2:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(246, 34);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(66, 13);
            this.label3.TabIndex = 3;
            this.label3.Text = "Longitude 1:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(246, 70);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(66, 13);
            this.label4.TabIndex = 4;
            this.label4.Text = "Longitude 2:";
            // 
            // txtLong1
            // 
            this.txtLong1.Location = new System.Drawing.Point(318, 34);
            this.txtLong1.Name = "txtLong1";
            this.txtLong1.Size = new System.Drawing.Size(100, 20);
            this.txtLong1.TabIndex = 5;
            // 
            // txtLong2
            // 
            this.txtLong2.Location = new System.Drawing.Point(318, 70);
            this.txtLong2.Name = "txtLong2";
            this.txtLong2.Size = new System.Drawing.Size(100, 20);
            this.txtLong2.TabIndex = 6;
            // 
            // txtLat2
            // 
            this.txtLat2.Location = new System.Drawing.Point(75, 67);
            this.txtLat2.Name = "txtLat2";
            this.txtLat2.Size = new System.Drawing.Size(131, 20);
            this.txtLat2.TabIndex = 7;
            // 
            // btnOk
            // 
            this.btnOk.Location = new System.Drawing.Point(451, 163);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 8;
            this.btnOk.Text = "Ok";
            this.btnOk.UseVisualStyleBackColor = true;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // txtResult
            // 
            this.txtResult.Location = new System.Drawing.Point(196, 111);
            this.txtResult.Name = "txtResult";
            this.txtResult.Size = new System.Drawing.Size(100, 20);
            this.txtResult.TabIndex = 9;
            // 
            // frmLatLongCals
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(538, 198);
            this.Controls.Add(this.txtResult);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.txtLat2);
            this.Controls.Add(this.txtLong2);
            this.Controls.Add(this.txtLong1);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.txtLat1);
            this.Controls.Add(this.label1);
            this.Name = "frmLatLongCals";
            this.Text = "LatLongCals";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtLat1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtLong1;
        private System.Windows.Forms.TextBox txtLong2;
        private System.Windows.Forms.TextBox txtLat2;
        private System.Windows.Forms.Button btnOk;
        private System.Windows.Forms.TextBox txtResult;
    }
}