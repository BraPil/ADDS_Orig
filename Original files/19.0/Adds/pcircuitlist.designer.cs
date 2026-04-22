namespace Adds
{
    partial class pCircuitList
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

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.txtInput = new System.Windows.Forms.TextBox();
            this.btnDoIt = new System.Windows.Forms.Button();
            this.btnGetCircuit = new System.Windows.Forms.Button();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.lblLayerSearch = new System.Windows.Forms.Label();
            this.lblDevice = new System.Windows.Forms.Label();
            this.toolTip1 = new System.Windows.Forms.ToolTip(this.components);
            this.SuspendLayout();
            // 
            // txtInput
            // 
            this.txtInput.Location = new System.Drawing.Point(114, 12);
            this.txtInput.Name = "txtInput";
            this.txtInput.Size = new System.Drawing.Size(100, 20);
            this.txtInput.TabIndex = 0;
            // 
            // btnDoIt
            // 
            this.btnDoIt.Location = new System.Drawing.Point(114, 38);
            this.btnDoIt.Name = "btnDoIt";
            this.btnDoIt.Size = new System.Drawing.Size(100, 23);
            this.btnDoIt.TabIndex = 1;
            this.btnDoIt.Text = "Get Circuit Data";
            this.toolTip1.SetToolTip(this.btnDoIt, "Used to return circuit information for the circuit layer name in textbox above\r\nt" +
        "he control results are displayed in AutoCAD text window.\r\nUse F2 key for a bette" +
        "r view of the AutoCAD text window.");
            this.btnDoIt.UseVisualStyleBackColor = true;
            this.btnDoIt.Click += new System.EventHandler(this.btnDoIt_Click);
            // 
            // btnGetCircuit
            // 
            this.btnGetCircuit.Location = new System.Drawing.Point(12, 38);
            this.btnGetCircuit.Name = "btnGetCircuit";
            this.btnGetCircuit.Size = new System.Drawing.Size(75, 23);
            this.btnGetCircuit.TabIndex = 2;
            this.btnGetCircuit.Text = "Pick Circuit";
            this.toolTip1.SetToolTip(this.btnGetCircuit, "Use to select circuit to get information on.");
            this.btnGetCircuit.UseVisualStyleBackColor = true;
            this.btnGetCircuit.Click += new System.EventHandler(this.btnGetCircuit_Click);
            // 
            // listBox1
            // 
            this.listBox1.AllowDrop = true;
            this.listBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.listBox1.FormattingEnabled = true;
            this.listBox1.HorizontalScrollbar = true;
            this.listBox1.ImeMode = System.Windows.Forms.ImeMode.On;
            this.listBox1.Location = new System.Drawing.Point(12, 92);
            this.listBox1.Name = "listBox1";
            this.listBox1.ScrollAlwaysVisible = true;
            this.listBox1.Size = new System.Drawing.Size(202, 95);
            this.listBox1.TabIndex = 3;
            this.listBox1.DragDrop += new System.Windows.Forms.DragEventHandler(this.listBox1_DragDrop);
            this.listBox1.DragEnter += new System.Windows.Forms.DragEventHandler(this.listBox1_DragEnter);
            this.listBox1.DragOver += new System.Windows.Forms.DragEventHandler(this.listBox1_DragOver);
            // 
            // lblLayerSearch
            // 
            this.lblLayerSearch.AutoSize = true;
            this.lblLayerSearch.Location = new System.Drawing.Point(9, 15);
            this.lblLayerSearch.Name = "lblLayerSearch";
            this.lblLayerSearch.Size = new System.Drawing.Size(82, 13);
            this.lblLayerSearch.TabIndex = 4;
            this.lblLayerSearch.Text = "Layer to Search";
            // 
            // lblDevice
            // 
            this.lblDevice.AutoSize = true;
            this.lblDevice.Location = new System.Drawing.Point(9, 71);
            this.lblDevice.Name = "lblDevice";
            this.lblDevice.Size = new System.Drawing.Size(171, 13);
            this.lblDevice.TabIndex = 5;
            this.lblDevice.Text = "Display Device Data (Drag && Drop)";
            // 
            // toolTip1
            // 
            this.toolTip1.AutoPopDelay = 60000;
            this.toolTip1.InitialDelay = 500;
            this.toolTip1.ReshowDelay = 100;
            // 
            // pCircuitList
            // 
            this.AllowDrop = true;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.lblDevice);
            this.Controls.Add(this.lblLayerSearch);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.btnGetCircuit);
            this.Controls.Add(this.btnDoIt);
            this.Controls.Add(this.txtInput);
            this.Name = "pCircuitList";
            this.Size = new System.Drawing.Size(232, 200);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox txtInput;
        private System.Windows.Forms.Button btnDoIt;
        private System.Windows.Forms.Button btnGetCircuit;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.Label lblLayerSearch;
        private System.Windows.Forms.Label lblDevice;
        private System.Windows.Forms.ToolTip toolTip1;
    }
}
