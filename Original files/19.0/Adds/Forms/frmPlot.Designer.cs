namespace Adds.Forms
{
    partial class frmPlot
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(frmPlot));
            this.lblName = new System.Windows.Forms.Label();
            this.cboPlotName = new System.Windows.Forms.ComboBox();
            this.lblDesc = new System.Windows.Forms.Label();
            this.txtDesc = new System.Windows.Forms.TextBox();
            this.lblDwgNo = new System.Windows.Forms.Label();
            this.txtDwgNo = new System.Windows.Forms.TextBox();
            this.lblDivision = new System.Windows.Forms.Label();
            this.lblVoltage = new System.Windows.Forms.Label();
            this.cboDiv = new System.Windows.Forms.ComboBox();
            this.cboVolts = new System.Windows.Forms.ComboBox();
            this.lblJob = new System.Windows.Forms.Label();
            this.txtJob = new System.Windows.Forms.TextBox();
            this.txtDetail = new System.Windows.Forms.TextBox();
            this.lblDetail = new System.Windows.Forms.Label();
            this.txtBuffer = new System.Windows.Forms.TextBox();
            this.lblBuffer = new System.Windows.Forms.Label();
            this.cboSheetSize = new System.Windows.Forms.ComboBox();
            this.lblSheet = new System.Windows.Forms.Label();
            this.gboScale = new System.Windows.Forms.GroupBox();
            this.txtScaleFont = new System.Windows.Forms.TextBox();
            this.lblScaleFont = new System.Windows.Forms.Label();
            this.txtScaleSymbol = new System.Windows.Forms.TextBox();
            this.lblSymbol = new System.Windows.Forms.Label();
            this.txtScalePlot = new System.Windows.Forms.TextBox();
            this.lblPlotScale = new System.Windows.Forms.Label();
            this.clbCustoms = new System.Windows.Forms.CheckedListBox();
            this.gboCoord = new System.Windows.Forms.GroupBox();
            this.txtKeys = new System.Windows.Forms.TextBox();
            this.btnGetExtents = new System.Windows.Forms.Button();
            this.lblKeys = new System.Windows.Forms.Label();
            this.lblFile = new System.Windows.Forms.Label();
            this.cboCordFile = new System.Windows.Forms.ComboBox();
            this.gboMatch = new System.Windows.Forms.GroupBox();
            this.cboMatchBottom = new System.Windows.Forms.ComboBox();
            this.lblMatchBottom = new System.Windows.Forms.Label();
            this.cboMatchTop = new System.Windows.Forms.ComboBox();
            this.lblMatchTop = new System.Windows.Forms.Label();
            this.cboMatchRight = new System.Windows.Forms.ComboBox();
            this.lblMatchRight = new System.Windows.Forms.Label();
            this.cboMatchLeft = new System.Windows.Forms.ComboBox();
            this.lblMatchLeft = new System.Windows.Forms.Label();
            this.gboExtents = new System.Windows.Forms.GroupBox();
            this.txtURY = new System.Windows.Forms.TextBox();
            this.txtURX = new System.Windows.Forms.TextBox();
            this.lblUpperRight = new System.Windows.Forms.Label();
            this.txtLLY = new System.Windows.Forms.TextBox();
            this.txtLLX = new System.Windows.Forms.TextBox();
            this.lblY = new System.Windows.Forms.Label();
            this.lblX = new System.Windows.Forms.Label();
            this.lblLowerLeft = new System.Windows.Forms.Label();
            this.lboGroups = new System.Windows.Forms.ListBox();
            this.lblGroups = new System.Windows.Forms.Label();
            this.gboCustoms = new System.Windows.Forms.GroupBox();
            this.btnClear = new System.Windows.Forms.Button();
            this.btnUpdate = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnDelete = new System.Windows.Forms.Button();
            this.btnAdd = new System.Windows.Forms.Button();
            this.btnPlot = new System.Windows.Forms.Button();
            this.lblDefinedBy = new System.Windows.Forms.Label();
            this.lblDefinedDate = new System.Windows.Forms.Label();
            this.pbxLogo = new System.Windows.Forms.PictureBox();
            this.gboScale.SuspendLayout();
            this.gboCoord.SuspendLayout();
            this.gboMatch.SuspendLayout();
            this.gboExtents.SuspendLayout();
            this.gboCustoms.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pbxLogo)).BeginInit();
            this.SuspendLayout();
            // 
            // lblName
            // 
            this.lblName.AutoSize = true;
            this.lblName.Location = new System.Drawing.Point(12, 12);
            this.lblName.Name = "lblName";
            this.lblName.Size = new System.Drawing.Size(35, 13);
            this.lblName.TabIndex = 0;
            this.lblName.Text = "Name";
            // 
            // cboPlotName
            // 
            this.cboPlotName.BackColor = System.Drawing.Color.Yellow;
            this.cboPlotName.FormattingEnabled = true;
            this.cboPlotName.Location = new System.Drawing.Point(100, 9);
            this.cboPlotName.Name = "cboPlotName";
            this.cboPlotName.Size = new System.Drawing.Size(250, 21);
            this.cboPlotName.TabIndex = 1;
            this.cboPlotName.SelectedIndexChanged += new System.EventHandler(this.cboPlotName_SelectedIndexChanged);
            // 
            // lblDesc
            // 
            this.lblDesc.AutoSize = true;
            this.lblDesc.Location = new System.Drawing.Point(11, 93);
            this.lblDesc.Name = "lblDesc";
            this.lblDesc.Size = new System.Drawing.Size(63, 13);
            this.lblDesc.TabIndex = 2;
            this.lblDesc.Text = "Description:";
            // 
            // txtDesc
            // 
            this.txtDesc.Location = new System.Drawing.Point(100, 93);
            this.txtDesc.Multiline = true;
            this.txtDesc.Name = "txtDesc";
            this.txtDesc.Size = new System.Drawing.Size(250, 50);
            this.txtDesc.TabIndex = 3;
            // 
            // lblDwgNo
            // 
            this.lblDwgNo.AutoSize = true;
            this.lblDwgNo.Location = new System.Drawing.Point(12, 152);
            this.lblDwgNo.Name = "lblDwgNo";
            this.lblDwgNo.Size = new System.Drawing.Size(66, 13);
            this.lblDwgNo.TabIndex = 4;
            this.lblDwgNo.Text = "Drawing No:";
            // 
            // txtDwgNo
            // 
            this.txtDwgNo.Location = new System.Drawing.Point(100, 152);
            this.txtDwgNo.Name = "txtDwgNo";
            this.txtDwgNo.Size = new System.Drawing.Size(250, 20);
            this.txtDwgNo.TabIndex = 5;
            // 
            // lblDivision
            // 
            this.lblDivision.AutoSize = true;
            this.lblDivision.Location = new System.Drawing.Point(12, 194);
            this.lblDivision.Name = "lblDivision";
            this.lblDivision.Size = new System.Drawing.Size(47, 13);
            this.lblDivision.TabIndex = 6;
            this.lblDivision.Text = "Division:";
            // 
            // lblVoltage
            // 
            this.lblVoltage.AutoSize = true;
            this.lblVoltage.Location = new System.Drawing.Point(200, 194);
            this.lblVoltage.Name = "lblVoltage";
            this.lblVoltage.Size = new System.Drawing.Size(46, 13);
            this.lblVoltage.TabIndex = 7;
            this.lblVoltage.Text = "Voltage:";
            // 
            // cboDiv
            // 
            this.cboDiv.BackColor = System.Drawing.Color.Yellow;
            this.cboDiv.FormattingEnabled = true;
            this.cboDiv.Items.AddRange(new object[] {
            "BH",
            "E_",
            "M_",
            "W_",
            "S_",
            "SE",
            "AL"});
            this.cboDiv.Location = new System.Drawing.Point(100, 194);
            this.cboDiv.Name = "cboDiv";
            this.cboDiv.Size = new System.Drawing.Size(75, 21);
            this.cboDiv.TabIndex = 8;
            // 
            // cboVolts
            // 
            this.cboVolts.BackColor = System.Drawing.Color.Yellow;
            this.cboVolts.FormattingEnabled = true;
            this.cboVolts.Items.AddRange(new object[] {
            "04",
            "12",
            "13",
            "23",
            "25",
            "35",
            "44",
            "15",
            "61",
            "30",
            "AL"});
            this.cboVolts.Location = new System.Drawing.Point(250, 193);
            this.cboVolts.Name = "cboVolts";
            this.cboVolts.Size = new System.Drawing.Size(75, 21);
            this.cboVolts.TabIndex = 9;
            // 
            // lblJob
            // 
            this.lblJob.AutoSize = true;
            this.lblJob.Location = new System.Drawing.Point(12, 227);
            this.lblJob.Name = "lblJob";
            this.lblJob.Size = new System.Drawing.Size(27, 13);
            this.lblJob.TabIndex = 10;
            this.lblJob.Text = "Job:";
            // 
            // txtJob
            // 
            this.txtJob.Location = new System.Drawing.Point(100, 227);
            this.txtJob.Name = "txtJob";
            this.txtJob.Size = new System.Drawing.Size(250, 20);
            this.txtJob.TabIndex = 11;
            // 
            // txtDetail
            // 
            this.txtDetail.Location = new System.Drawing.Point(100, 261);
            this.txtDetail.Name = "txtDetail";
            this.txtDetail.Size = new System.Drawing.Size(250, 20);
            this.txtDetail.TabIndex = 13;
            // 
            // lblDetail
            // 
            this.lblDetail.AutoSize = true;
            this.lblDetail.Location = new System.Drawing.Point(12, 261);
            this.lblDetail.Name = "lblDetail";
            this.lblDetail.Size = new System.Drawing.Size(37, 13);
            this.lblDetail.TabIndex = 12;
            this.lblDetail.Text = "Detail:";
            // 
            // txtBuffer
            // 
            this.txtBuffer.Location = new System.Drawing.Point(100, 296);
            this.txtBuffer.Name = "txtBuffer";
            this.txtBuffer.Size = new System.Drawing.Size(250, 20);
            this.txtBuffer.TabIndex = 15;
            // 
            // lblBuffer
            // 
            this.lblBuffer.AutoSize = true;
            this.lblBuffer.Location = new System.Drawing.Point(12, 296);
            this.lblBuffer.Name = "lblBuffer";
            this.lblBuffer.Size = new System.Drawing.Size(38, 13);
            this.lblBuffer.TabIndex = 14;
            this.lblBuffer.Text = "Buffer:";
            // 
            // cboSheetSize
            // 
            this.cboSheetSize.BackColor = System.Drawing.Color.Yellow;
            this.cboSheetSize.FormattingEnabled = true;
            this.cboSheetSize.Items.AddRange(new object[] {
            "A",
            "B",
            "C",
            "D",
            "E",
            "F",
            "NO"});
            this.cboSheetSize.Location = new System.Drawing.Point(100, 337);
            this.cboSheetSize.Name = "cboSheetSize";
            this.cboSheetSize.Size = new System.Drawing.Size(75, 21);
            this.cboSheetSize.TabIndex = 17;
            // 
            // lblSheet
            // 
            this.lblSheet.AutoSize = true;
            this.lblSheet.Location = new System.Drawing.Point(12, 337);
            this.lblSheet.Name = "lblSheet";
            this.lblSheet.Size = new System.Drawing.Size(61, 13);
            this.lblSheet.TabIndex = 16;
            this.lblSheet.Text = "Sheet Size:";
            // 
            // gboScale
            // 
            this.gboScale.Controls.Add(this.txtScaleFont);
            this.gboScale.Controls.Add(this.lblScaleFont);
            this.gboScale.Controls.Add(this.txtScaleSymbol);
            this.gboScale.Controls.Add(this.lblSymbol);
            this.gboScale.Controls.Add(this.txtScalePlot);
            this.gboScale.Controls.Add(this.lblPlotScale);
            this.gboScale.Location = new System.Drawing.Point(200, 337);
            this.gboScale.Name = "gboScale";
            this.gboScale.Size = new System.Drawing.Size(150, 100);
            this.gboScale.TabIndex = 18;
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
            // clbCustoms
            // 
            this.clbCustoms.FormattingEnabled = true;
            this.clbCustoms.Location = new System.Drawing.Point(25, 15);
            this.clbCustoms.Name = "clbCustoms";
            this.clbCustoms.Size = new System.Drawing.Size(250, 64);
            this.clbCustoms.TabIndex = 19;
            // 
            // gboCoord
            // 
            this.gboCoord.Controls.Add(this.txtKeys);
            this.gboCoord.Controls.Add(this.btnGetExtents);
            this.gboCoord.Controls.Add(this.lblKeys);
            this.gboCoord.Controls.Add(this.lblFile);
            this.gboCoord.Controls.Add(this.cboCordFile);
            this.gboCoord.Location = new System.Drawing.Point(400, 93);
            this.gboCoord.Name = "gboCoord";
            this.gboCoord.Size = new System.Drawing.Size(300, 125);
            this.gboCoord.TabIndex = 20;
            this.gboCoord.TabStop = false;
            this.gboCoord.Text = "Coordinates:";
            // 
            // txtKeys
            // 
            this.txtKeys.Location = new System.Drawing.Point(50, 57);
            this.txtKeys.MaxLength = 1000;
            this.txtKeys.Multiline = true;
            this.txtKeys.Name = "txtKeys";
            this.txtKeys.Size = new System.Drawing.Size(225, 60);
            this.txtKeys.TabIndex = 4;
            // 
            // btnGetExtents
            // 
            this.btnGetExtents.Location = new System.Drawing.Point(203, 25);
            this.btnGetExtents.Name = "btnGetExtents";
            this.btnGetExtents.Size = new System.Drawing.Size(75, 23);
            this.btnGetExtents.TabIndex = 3;
            this.btnGetExtents.Text = "Get Extents";
            this.btnGetExtents.UseVisualStyleBackColor = true;
            this.btnGetExtents.Click += new System.EventHandler(this.btnGetExtents_Click);
            // 
            // lblKeys
            // 
            this.lblKeys.AutoSize = true;
            this.lblKeys.Location = new System.Drawing.Point(10, 57);
            this.lblKeys.Name = "lblKeys";
            this.lblKeys.Size = new System.Drawing.Size(39, 13);
            this.lblKeys.TabIndex = 2;
            this.lblKeys.Text = "Key(s):";
            // 
            // lblFile
            // 
            this.lblFile.AutoSize = true;
            this.lblFile.Location = new System.Drawing.Point(10, 28);
            this.lblFile.Name = "lblFile";
            this.lblFile.Size = new System.Drawing.Size(26, 13);
            this.lblFile.TabIndex = 1;
            this.lblFile.Text = "File:";
            // 
            // cboCordFile
            // 
            this.cboCordFile.FormattingEnabled = true;
            this.cboCordFile.Items.AddRange(new object[] {
            "Feeder",
            "Sub",
            "Switch",
            "Panel"});
            this.cboCordFile.Location = new System.Drawing.Point(54, 25);
            this.cboCordFile.Name = "cboCordFile";
            this.cboCordFile.Size = new System.Drawing.Size(121, 21);
            this.cboCordFile.TabIndex = 0;
            // 
            // gboMatch
            // 
            this.gboMatch.Controls.Add(this.cboMatchBottom);
            this.gboMatch.Controls.Add(this.lblMatchBottom);
            this.gboMatch.Controls.Add(this.cboMatchTop);
            this.gboMatch.Controls.Add(this.lblMatchTop);
            this.gboMatch.Controls.Add(this.cboMatchRight);
            this.gboMatch.Controls.Add(this.lblMatchRight);
            this.gboMatch.Controls.Add(this.cboMatchLeft);
            this.gboMatch.Controls.Add(this.lblMatchLeft);
            this.gboMatch.Location = new System.Drawing.Point(400, 218);
            this.gboMatch.Name = "gboMatch";
            this.gboMatch.Size = new System.Drawing.Size(300, 150);
            this.gboMatch.TabIndex = 21;
            this.gboMatch.TabStop = false;
            this.gboMatch.Text = "Match To:";
            // 
            // cboMatchBottom
            // 
            this.cboMatchBottom.FormattingEnabled = true;
            this.cboMatchBottom.Location = new System.Drawing.Point(75, 110);
            this.cboMatchBottom.Name = "cboMatchBottom";
            this.cboMatchBottom.Size = new System.Drawing.Size(200, 21);
            this.cboMatchBottom.TabIndex = 7;
            // 
            // lblMatchBottom
            // 
            this.lblMatchBottom.AutoSize = true;
            this.lblMatchBottom.Location = new System.Drawing.Point(10, 113);
            this.lblMatchBottom.Name = "lblMatchBottom";
            this.lblMatchBottom.Size = new System.Drawing.Size(43, 13);
            this.lblMatchBottom.TabIndex = 6;
            this.lblMatchBottom.Text = "Bottom:";
            // 
            // cboMatchTop
            // 
            this.cboMatchTop.FormattingEnabled = true;
            this.cboMatchTop.Location = new System.Drawing.Point(75, 80);
            this.cboMatchTop.Name = "cboMatchTop";
            this.cboMatchTop.Size = new System.Drawing.Size(200, 21);
            this.cboMatchTop.TabIndex = 5;
            // 
            // lblMatchTop
            // 
            this.lblMatchTop.AutoSize = true;
            this.lblMatchTop.Location = new System.Drawing.Point(10, 83);
            this.lblMatchTop.Name = "lblMatchTop";
            this.lblMatchTop.Size = new System.Drawing.Size(29, 13);
            this.lblMatchTop.TabIndex = 4;
            this.lblMatchTop.Text = "Top:";
            // 
            // cboMatchRight
            // 
            this.cboMatchRight.FormattingEnabled = true;
            this.cboMatchRight.Location = new System.Drawing.Point(75, 50);
            this.cboMatchRight.Name = "cboMatchRight";
            this.cboMatchRight.Size = new System.Drawing.Size(200, 21);
            this.cboMatchRight.TabIndex = 3;
            // 
            // lblMatchRight
            // 
            this.lblMatchRight.AutoSize = true;
            this.lblMatchRight.Location = new System.Drawing.Point(13, 53);
            this.lblMatchRight.Name = "lblMatchRight";
            this.lblMatchRight.Size = new System.Drawing.Size(35, 13);
            this.lblMatchRight.TabIndex = 2;
            this.lblMatchRight.Text = "Right:";
            // 
            // cboMatchLeft
            // 
            this.cboMatchLeft.FormattingEnabled = true;
            this.cboMatchLeft.Location = new System.Drawing.Point(75, 20);
            this.cboMatchLeft.Name = "cboMatchLeft";
            this.cboMatchLeft.Size = new System.Drawing.Size(200, 21);
            this.cboMatchLeft.TabIndex = 1;
            // 
            // lblMatchLeft
            // 
            this.lblMatchLeft.AutoSize = true;
            this.lblMatchLeft.Location = new System.Drawing.Point(13, 20);
            this.lblMatchLeft.Name = "lblMatchLeft";
            this.lblMatchLeft.Size = new System.Drawing.Size(28, 13);
            this.lblMatchLeft.TabIndex = 0;
            this.lblMatchLeft.Text = "Left:";
            // 
            // gboExtents
            // 
            this.gboExtents.Controls.Add(this.txtURY);
            this.gboExtents.Controls.Add(this.txtURX);
            this.gboExtents.Controls.Add(this.lblUpperRight);
            this.gboExtents.Controls.Add(this.txtLLY);
            this.gboExtents.Controls.Add(this.txtLLX);
            this.gboExtents.Controls.Add(this.lblY);
            this.gboExtents.Controls.Add(this.lblX);
            this.gboExtents.Controls.Add(this.lblLowerLeft);
            this.gboExtents.Location = new System.Drawing.Point(400, 368);
            this.gboExtents.Name = "gboExtents";
            this.gboExtents.Size = new System.Drawing.Size(300, 80);
            this.gboExtents.TabIndex = 22;
            this.gboExtents.TabStop = false;
            this.gboExtents.Text = "Extents:";
            // 
            // txtURY
            // 
            this.txtURY.BackColor = System.Drawing.Color.Yellow;
            this.txtURY.Location = new System.Drawing.Point(200, 53);
            this.txtURY.Name = "txtURY";
            this.txtURY.Size = new System.Drawing.Size(75, 20);
            this.txtURY.TabIndex = 7;
            this.txtURY.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // txtURX
            // 
            this.txtURX.BackColor = System.Drawing.Color.Yellow;
            this.txtURX.Location = new System.Drawing.Point(100, 53);
            this.txtURX.Name = "txtURX";
            this.txtURX.Size = new System.Drawing.Size(75, 20);
            this.txtURX.TabIndex = 6;
            this.txtURX.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblUpperRight
            // 
            this.lblUpperRight.AutoSize = true;
            this.lblUpperRight.Location = new System.Drawing.Point(13, 56);
            this.lblUpperRight.Name = "lblUpperRight";
            this.lblUpperRight.Size = new System.Drawing.Size(67, 13);
            this.lblUpperRight.TabIndex = 5;
            this.lblUpperRight.Text = "Upper Right:";
            // 
            // txtLLY
            // 
            this.txtLLY.BackColor = System.Drawing.Color.Yellow;
            this.txtLLY.Location = new System.Drawing.Point(200, 27);
            this.txtLLY.Name = "txtLLY";
            this.txtLLY.Size = new System.Drawing.Size(75, 20);
            this.txtLLY.TabIndex = 4;
            this.txtLLY.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // txtLLX
            // 
            this.txtLLX.BackColor = System.Drawing.Color.Yellow;
            this.txtLLX.Location = new System.Drawing.Point(100, 27);
            this.txtLLX.Name = "txtLLX";
            this.txtLLX.Size = new System.Drawing.Size(75, 20);
            this.txtLLX.TabIndex = 3;
            this.txtLLX.TextAlign = System.Windows.Forms.HorizontalAlignment.Right;
            // 
            // lblY
            // 
            this.lblY.AutoSize = true;
            this.lblY.Location = new System.Drawing.Point(223, 10);
            this.lblY.Name = "lblY";
            this.lblY.Size = new System.Drawing.Size(14, 13);
            this.lblY.TabIndex = 2;
            this.lblY.Text = "Y";
            this.lblY.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblX
            // 
            this.lblX.AutoSize = true;
            this.lblX.Location = new System.Drawing.Point(125, 10);
            this.lblX.Name = "lblX";
            this.lblX.Size = new System.Drawing.Size(14, 13);
            this.lblX.TabIndex = 1;
            this.lblX.Text = "X";
            this.lblX.TextAlign = System.Drawing.ContentAlignment.MiddleCenter;
            // 
            // lblLowerLeft
            // 
            this.lblLowerLeft.AutoSize = true;
            this.lblLowerLeft.Location = new System.Drawing.Point(13, 30);
            this.lblLowerLeft.Name = "lblLowerLeft";
            this.lblLowerLeft.Size = new System.Drawing.Size(60, 13);
            this.lblLowerLeft.TabIndex = 0;
            this.lblLowerLeft.Text = "Lower Left:";
            // 
            // lboGroups
            // 
            this.lboGroups.FormattingEnabled = true;
            this.lboGroups.Location = new System.Drawing.Point(100, 36);
            this.lboGroups.Name = "lboGroups";
            this.lboGroups.SelectionMode = System.Windows.Forms.SelectionMode.None;
            this.lboGroups.Size = new System.Drawing.Size(250, 43);
            this.lboGroups.Sorted = true;
            this.lboGroups.TabIndex = 23;
            this.lboGroups.TabStop = false;
            // 
            // lblGroups
            // 
            this.lblGroups.AutoSize = true;
            this.lblGroups.Location = new System.Drawing.Point(11, 36);
            this.lblGroups.Name = "lblGroups";
            this.lblGroups.Size = new System.Drawing.Size(71, 13);
            this.lblGroups.TabIndex = 24;
            this.lblGroups.Text = "Plot Group(s):";
            // 
            // gboCustoms
            // 
            this.gboCustoms.Controls.Add(this.clbCustoms);
            this.gboCustoms.Location = new System.Drawing.Point(400, 6);
            this.gboCustoms.Name = "gboCustoms";
            this.gboCustoms.Size = new System.Drawing.Size(300, 85);
            this.gboCustoms.TabIndex = 25;
            this.gboCustoms.TabStop = false;
            this.gboCustoms.Text = "Custom(s):";
            // 
            // btnClear
            // 
            this.btnClear.Location = new System.Drawing.Point(200, 458);
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(75, 23);
            this.btnClear.TabIndex = 26;
            this.btnClear.Text = "&Clear";
            this.btnClear.UseVisualStyleBackColor = true;
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // btnUpdate
            // 
            this.btnUpdate.Location = new System.Drawing.Point(366, 458);
            this.btnUpdate.Name = "btnUpdate";
            this.btnUpdate.Size = new System.Drawing.Size(75, 23);
            this.btnUpdate.TabIndex = 27;
            this.btnUpdate.Text = "&Update";
            this.btnUpdate.UseVisualStyleBackColor = true;
            this.btnUpdate.Click += new System.EventHandler(this.btnUpdate_Click);
            // 
            // btnClose
            // 
            this.btnClose.Location = new System.Drawing.Point(544, 458);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(75, 23);
            this.btnClose.TabIndex = 28;
            this.btnClose.Text = "&Close";
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnDelete
            // 
            this.btnDelete.Location = new System.Drawing.Point(454, 458);
            this.btnDelete.Name = "btnDelete";
            this.btnDelete.Size = new System.Drawing.Size(75, 23);
            this.btnDelete.TabIndex = 29;
            this.btnDelete.Text = "&Delete";
            this.btnDelete.UseVisualStyleBackColor = true;
            this.btnDelete.Click += new System.EventHandler(this.btnDelete_Click);
            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(285, 458);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(75, 23);
            this.btnAdd.TabIndex = 30;
            this.btnAdd.Text = "&Add";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // btnPlot
            // 
            this.btnPlot.Location = new System.Drawing.Point(625, 458);
            this.btnPlot.Name = "btnPlot";
            this.btnPlot.Size = new System.Drawing.Size(75, 23);
            this.btnPlot.TabIndex = 31;
            this.btnPlot.Text = "&Plot";
            this.btnPlot.UseVisualStyleBackColor = true;
            this.btnPlot.Click += new System.EventHandler(this.btnPlot_Click);
            // 
            // lblDefinedBy
            // 
            this.lblDefinedBy.AutoSize = true;
            this.lblDefinedBy.Location = new System.Drawing.Point(10, 430);
            this.lblDefinedBy.Name = "lblDefinedBy";
            this.lblDefinedBy.Size = new System.Drawing.Size(33, 13);
            this.lblDefinedBy.TabIndex = 32;
            this.lblDefinedBy.Text = "Label";
            // 
            // lblDefinedDate
            // 
            this.lblDefinedDate.AutoSize = true;
            this.lblDefinedDate.Location = new System.Drawing.Point(10, 445);
            this.lblDefinedDate.Name = "lblDefinedDate";
            this.lblDefinedDate.Size = new System.Drawing.Size(35, 13);
            this.lblDefinedDate.TabIndex = 33;
            this.lblDefinedDate.Text = "label1";
            // 
            // pbxLogo
            // 
            this.pbxLogo.Image = ((System.Drawing.Image)(resources.GetObject("pbxLogo.Image")));
            this.pbxLogo.Location = new System.Drawing.Point(18, 364);
            this.pbxLogo.Name = "pbxLogo";
            this.pbxLogo.Size = new System.Drawing.Size(144, 62);
            this.pbxLogo.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.pbxLogo.TabIndex = 34;
            this.pbxLogo.TabStop = false;
            // 
            // frmPlot
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(734, 486);
            this.Controls.Add(this.pbxLogo);
            this.Controls.Add(this.lblDefinedDate);
            this.Controls.Add(this.lblDefinedBy);
            this.Controls.Add(this.btnPlot);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.btnDelete);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnUpdate);
            this.Controls.Add(this.btnClear);
            this.Controls.Add(this.gboCustoms);
            this.Controls.Add(this.lblGroups);
            this.Controls.Add(this.lboGroups);
            this.Controls.Add(this.gboExtents);
            this.Controls.Add(this.gboMatch);
            this.Controls.Add(this.gboCoord);
            this.Controls.Add(this.gboScale);
            this.Controls.Add(this.cboSheetSize);
            this.Controls.Add(this.lblSheet);
            this.Controls.Add(this.txtBuffer);
            this.Controls.Add(this.lblBuffer);
            this.Controls.Add(this.txtDetail);
            this.Controls.Add(this.lblDetail);
            this.Controls.Add(this.txtJob);
            this.Controls.Add(this.lblJob);
            this.Controls.Add(this.cboVolts);
            this.Controls.Add(this.cboDiv);
            this.Controls.Add(this.lblVoltage);
            this.Controls.Add(this.lblDivision);
            this.Controls.Add(this.txtDwgNo);
            this.Controls.Add(this.lblDwgNo);
            this.Controls.Add(this.txtDesc);
            this.Controls.Add(this.lblDesc);
            this.Controls.Add(this.cboPlotName);
            this.Controls.Add(this.lblName);
            this.Name = "frmPlot";
            this.Text = "frmPlot";
            this.Load += new System.EventHandler(this.frmPlot_Load);
            this.gboScale.ResumeLayout(false);
            this.gboScale.PerformLayout();
            this.gboCoord.ResumeLayout(false);
            this.gboCoord.PerformLayout();
            this.gboMatch.ResumeLayout(false);
            this.gboMatch.PerformLayout();
            this.gboExtents.ResumeLayout(false);
            this.gboExtents.PerformLayout();
            this.gboCustoms.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.pbxLogo)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblName;
        private System.Windows.Forms.ComboBox cboPlotName;
        private System.Windows.Forms.Label lblDesc;
        private System.Windows.Forms.TextBox txtDesc;
        private System.Windows.Forms.Label lblDwgNo;
        private System.Windows.Forms.TextBox txtDwgNo;
        private System.Windows.Forms.Label lblDivision;
        private System.Windows.Forms.Label lblVoltage;
        private System.Windows.Forms.ComboBox cboDiv;
        private System.Windows.Forms.ComboBox cboVolts;
        private System.Windows.Forms.Label lblJob;
        private System.Windows.Forms.TextBox txtJob;
        private System.Windows.Forms.TextBox txtDetail;
        private System.Windows.Forms.Label lblDetail;
        private System.Windows.Forms.TextBox txtBuffer;
        private System.Windows.Forms.Label lblBuffer;
        private System.Windows.Forms.ComboBox cboSheetSize;
        private System.Windows.Forms.Label lblSheet;
        private System.Windows.Forms.GroupBox gboScale;
        private System.Windows.Forms.TextBox txtScaleFont;
        private System.Windows.Forms.Label lblScaleFont;
        private System.Windows.Forms.TextBox txtScaleSymbol;
        private System.Windows.Forms.Label lblSymbol;
        private System.Windows.Forms.TextBox txtScalePlot;
        private System.Windows.Forms.Label lblPlotScale;
        private System.Windows.Forms.CheckedListBox clbCustoms;
        private System.Windows.Forms.GroupBox gboCoord;
        private System.Windows.Forms.TextBox txtKeys;
        private System.Windows.Forms.Button btnGetExtents;
        private System.Windows.Forms.Label lblKeys;
        private System.Windows.Forms.Label lblFile;
        private System.Windows.Forms.ComboBox cboCordFile;
        private System.Windows.Forms.GroupBox gboMatch;
        private System.Windows.Forms.ComboBox cboMatchBottom;
        private System.Windows.Forms.Label lblMatchBottom;
        private System.Windows.Forms.ComboBox cboMatchTop;
        private System.Windows.Forms.Label lblMatchTop;
        private System.Windows.Forms.ComboBox cboMatchRight;
        private System.Windows.Forms.Label lblMatchRight;
        private System.Windows.Forms.ComboBox cboMatchLeft;
        private System.Windows.Forms.Label lblMatchLeft;
        private System.Windows.Forms.GroupBox gboExtents;
        private System.Windows.Forms.TextBox txtURY;
        private System.Windows.Forms.TextBox txtURX;
        private System.Windows.Forms.Label lblUpperRight;
        private System.Windows.Forms.TextBox txtLLY;
        private System.Windows.Forms.TextBox txtLLX;
        private System.Windows.Forms.Label lblY;
        private System.Windows.Forms.Label lblX;
        private System.Windows.Forms.Label lblLowerLeft;
        private System.Windows.Forms.ListBox lboGroups;
        private System.Windows.Forms.Label lblGroups;
        private System.Windows.Forms.GroupBox gboCustoms;
        private System.Windows.Forms.Button btnClear;
        private System.Windows.Forms.Button btnUpdate;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.Button btnDelete;
        private System.Windows.Forms.Button btnAdd;
        private System.Windows.Forms.Button btnPlot;
        private System.Windows.Forms.Label lblDefinedBy;
        private System.Windows.Forms.Label lblDefinedDate;
        private System.Windows.Forms.PictureBox pbxLogo;
    }
}