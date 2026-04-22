using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadColor = Autodesk.AutoCAD.Colors;

using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;


namespace Adds.Forms
{
    public partial class frmPlot : Form
    {
        private BindingSource bsPlots = new BindingSource();
        DataTable _dtPlots = new DataTable();
        DataTable _dtCustoms = new DataTable();
        private string _strDiv = string.Empty;
        private string _PlotDefPassedIn = string.Empty;

        private string _ModuleName = "ADDSPlot Definitions - Plot Definition";

        public frmPlot(string strDiv, string strPlotDef)
        {
            _strDiv = strDiv;
            _PlotDefPassedIn = strPlotDef;
            InitializeComponent();
            this.Text = "ADDS - Plot Definition";
            Populate();
            
        }

        private void frmPlot_Load(object sender, EventArgs e)
        {

            if (string.IsNullOrEmpty(_PlotDefPassedIn))
            {
                ClearAllControls();                             //  Clears form if open for Adding a Plot Def
                cboDiv.SelectedItem = _strDiv;
                cboDiv.Refresh();
            }
            else
            {
                cboPlotName.SelectedValue = _PlotDefPassedIn;   //  Sets Plot Def Name and gets all data
            }
        }

        internal void Populate()
        {
            _dtPlots = Adds.GetPlots(_strDiv);
            DataRow dr = _dtPlots.NewRow();
            _dtPlots.Rows.Add(dr);
            bsPlots.DataSource = _dtPlots;

            bsPlots.CurrentChanged += new EventHandler(bsPlots_CurrentChanged);

            cboPlotName.DataSource = bsPlots;
            cboPlotName.ValueMember = "PLDNAME";
            cboPlotName.DisplayMember = "PLDNAME";
            cboPlotName.SelectedIndex = -1;

            txtDesc.DataBindings.Add("Text", bsPlots, "DESCRIPTION");
            txtDwgNo.DataBindings.Add("Text", bsPlots, "DWG_NUM");
            txtJob.DataBindings.Add("Text", bsPlots, "JOB_NAM");
            txtDetail.DataBindings.Add("Text", bsPlots, "DETAIL");
            txtBuffer.DataBindings.Add("Text", bsPlots, "BUFFER");

            txtScalePlot.DataBindings.Add("Text", bsPlots, "PLTSC");
            txtScaleSymbol.DataBindings.Add("Text", bsPlots, "SYMSC");
            txtScaleFont.DataBindings.Add("Text", bsPlots, "TXTSC");

            _dtCustoms = Adds.GetPlotDefCustoms(null);
            clbCustoms.DataSource = _dtCustoms;
            clbCustoms.DisplayMember = "CUSTNAME";
            
            txtKeys.DataBindings.Add("Text", bsPlots, "CORDKEY");

            txtLLX.DataBindings.Add("Text", bsPlots, "X_L");
            txtLLY.DataBindings.Add("Text", bsPlots, "Y_L");
            txtURX.DataBindings.Add("Text", bsPlots, "X_U");
            txtURY.DataBindings.Add("Text", bsPlots, "Y_U");

            cboMatchBottom.DataSource = _dtPlots;
            cboMatchBottom.DisplayMember = "PLDNAME";
            cboMatchBottom.ValueMember = "PLDNAME";

            cboMatchLeft.BindingContext = new BindingContext();
            cboMatchLeft.DataSource = _dtPlots;
            cboMatchLeft.DisplayMember = "PLDNAME";
            cboMatchLeft.ValueMember = "PLDNAME";

            cboMatchRight.BindingContext = new BindingContext();
            cboMatchRight.DataSource = _dtPlots;
            cboMatchRight.DisplayMember = "PLDNAME";
            cboMatchRight.ValueMember = "PLDNAME";

            cboMatchTop.BindingContext = new BindingContext();
            cboMatchTop.DataSource = _dtPlots;
            cboMatchTop.DisplayMember = "PLDNAME";
            cboMatchTop.ValueMember = "PLDNAME";
        }

        private void CustomsSelectedPlotDefUpdate()
        {
            //  Determins if custom has been selected and updates checked status.
            DataRowView oCustomRow = null;
            for (int iIndex = 0; iIndex < this.clbCustoms.Items.Count; iIndex++)
            {
                oCustomRow = (DataRowView)this.clbCustoms.Items[iIndex];
                if (oCustomRow["Selected"].ToString() == "-1")
                {
                    this.clbCustoms.SetItemChecked(iIndex, true);
                }
                else
                {
                    this.clbCustoms.SetItemChecked(iIndex, false);
                }
            }
        }

        private void cboPlotName_SelectedIndexChanged(object sender, EventArgs e)
        {
            //cboDiv.SelectedItem = ((DataRowView)this.bsPlots.Current).Row["SHEET"].ToString();
        }

        private void bsPlots_CurrentChanged(object sender, EventArgs e)
        {
            string strTemp = string.Empty;

            //  Gets current selected Plot Definition row data
            DataRowView drvCurrentSelect = this.bsPlots.Current as DataRowView;

            //  Gets Plot Groups for selected Plot Definition
            strTemp = drvCurrentSelect.Row["PLDNAME"].ToString();
            lboGroups.DataSource = Adds.GetPlotGroupsByPlotDef(strTemp);
            lboGroups.DisplayMember = "PLDGROUP";

            //  Gets/Updates Customs for selected Plot Definition
            _dtCustoms = Adds.GetPlotDefCustoms(strTemp);
            clbCustoms.DataSource = _dtCustoms;
            clbCustoms.DisplayMember = "CUSTNAME";
            CustomsSelectedPlotDefUpdate();

            //  Updates textbox & Label controls for selected Plot Definition
            strTemp = drvCurrentSelect.Row["DIVNAM"].ToString();
            cboDiv.SelectedItem = strTemp;

            strTemp = drvCurrentSelect.Row["VLT"].ToString();
            cboVolts.SelectedItem = strTemp;

            strTemp = drvCurrentSelect.Row["SHEET"].ToString();
            cboSheetSize.SelectedItem = strTemp;

            strTemp = drvCurrentSelect.Row["DEFINED_BY_ID"].ToString();
            lblDefinedBy.Text = "Modified By: " + strTemp;

            strTemp = drvCurrentSelect.Row["DEFINED_DTM"].ToString();
            lblDefinedDate.Text = "Modified Date: " + strTemp;

            //  Updates  comboboxes for selected Plot Definition, if no date sets to blank
            strTemp = drvCurrentSelect.Row["CORDFILE"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboCordFile.SelectedIndex = -1;
            }
            else
            {
                cboCordFile.SelectedItem = strTemp;
            }

            strTemp = drvCurrentSelect.Row["MTCH_TO_BTM"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboMatchBottom.SelectedIndex = -1;
            }
            else
            {
                cboMatchBottom.SelectedValue = strTemp;
            }
            strTemp = drvCurrentSelect.Row["MTCH_TO_LFT"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboMatchLeft.SelectedIndex = -1;
            }
            else
            {
                cboMatchLeft.SelectedValue = strTemp;
            }
            strTemp = drvCurrentSelect.Row["MTCH_TO_RGT"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboMatchRight.SelectedIndex = -1;
            }
            else
            {
                cboMatchRight.SelectedValue = strTemp;
            }
            strTemp = drvCurrentSelect.Row["MTCH_TO_TOP"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboMatchTop.SelectedIndex = -1;
            }
            else
            {
                cboMatchTop.SelectedValue = strTemp;
            }
        }

        
        private void btnClear_Click(object sender, EventArgs e)
        {
            ClearAllControls();
        }

        private void ClearAllControls()
        {
            //  Set all comboboxes to blank selection, all chioces are still intacted
            cboCordFile.SelectedIndex   = -1;
            cboDiv.SelectedIndex        = -1;
            cboMatchBottom.SelectedIndex= -1;
            cboMatchLeft.SelectedIndex  = -1;
            cboMatchRight.SelectedIndex = -1;
            cboMatchTop.SelectedIndex   = -1;
            cboPlotName.SelectedIndex   = -1;
            cboSheetSize.SelectedIndex  = -1;
            cboVolts.SelectedIndex      = -1;

            //  Set all textboxes to empty string, still linked to binding source
            txtDesc.Text        = string.Empty;
            txtDetail.Text      = string.Empty;
            txtBuffer.Text      = string.Empty;
            txtDwgNo.Text       = string.Empty;
            txtJob.Text         = string.Empty;
            txtKeys.Text        = string.Empty;
            txtLLX.Text         = string.Empty;
            txtLLY.Text         = string.Empty;
            txtScaleFont.Text   = string.Empty;
            txtScalePlot.Text   = string.Empty;
            txtScaleSymbol.Text = string.Empty;
            txtURX.Text         = string.Empty;
            txtURY.Text         = string.Empty;

            //  Clear plot groups listbox
            lboGroups.DataSource    = Adds.GetPlotGroupsByPlotDef("");
            lboGroups.DisplayMember = "PLDGROUP";

            //  Clear all checkmarks from Customs
            clbCustoms.DataSource   = Adds.GetPlotDefCustoms("");
            CustomsSelectedPlotDefUpdate();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnPlot_Click(object sender, EventArgs e)
        {
            string strCommand = string.Empty;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            //  Build & send Lisp command to plot selected plot definition to AutoCAD LISP
            strCommand = "(PlotDef \"" + cboPlotName.SelectedValue.ToString() + "\" PrtDesc)\n" ;
            doc.SendStringToExecute(strCommand, true, false, true);
            //ed.CommandAsync(strCommand);
            //this.Close();
        }

        

        private void btnGetExtents_Click(object sender, EventArgs e)
        {
            DataTable dtExtents = Adds.GetPlotExtents(cboCordFile.Text, txtKeys.Text);

            if (dtExtents != null)
            {
                this.txtLLX.Text = dtExtents.Rows[0].ItemArray[0].ToString();
                this.txtLLY.Text = dtExtents.Rows[0].ItemArray[1].ToString();
                this.txtURX.Text = dtExtents.Rows[0].ItemArray[2].ToString();
                this.txtURY.Text = dtExtents.Rows[0].ItemArray[3].ToString();
            }
            else
            {
                MessageBox.Show("The combination Coorfile and key are not valid.  Please verify", _ModuleName);
            }
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            DataRowView drvAdd = bsPlots.Current as DataRowView;

            //  Get info to Add new PlotDef
            Plot plotItem = GetCurrentPlotDefValues();

            //  Get Plot Customs to save
            DataTable dtNewCustoms = CustomsToAddOrUpdate();

            //  Add to DB
            Adds.AddPlotDef(plotItem);
            Adds.AddUpdatePlotDefCustoms(plotItem.PldName, dtNewCustoms);

            //  Insert New Plot in controls or repopulate plotdefs
            bsPlots.DataSource = Adds.GetPlots(_strDiv);
            bsPlots.ResetBindings(false);
            ClearAllControls();
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            string strPlotDef = cboPlotName.Text;
            if (!string.IsNullOrEmpty(strPlotDef))
            {
                Adds.DeletePlotDef(strPlotDef);

                //  Update Form Controls to remove deleted Plot info
                bsPlots.RemoveCurrent();
                bsPlots.EndEdit();
                bsPlots.ResetBindings(false);
            }
            ClearAllControls();
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            Plot plotItem = GetCurrentPlotDefValues();
            Adds.UpdateAddsDef(plotItem);

            DataTable dtCustomsToUpdate = CustomsToAddOrUpdate();
            Adds.AddUpdatePlotDefCustoms(plotItem.PldName, dtCustomsToUpdate);

        }

        private Plot GetCurrentPlotDefValues()
        {

            //  Setup Plot Definition Item for saving or Updating to AddsDb.PlotDef table
            Plot plotItem = new Plot
            {
                PldName = cboPlotName.Text.ToUpper(),
                Description = txtDesc.Text,
                DrawingNumber = txtDwgNo.Text,
                DivName = cboDiv.Text,

                VoltageCode = cboVolts.Text,
                JobName = txtJob.Text,
                Detail = txtDetail.Text,
                Sheet = cboSheetSize.Text,
                CordFileType = cboCordFile.Text,
                CordKey = txtKeys.Text,

                MatchToLeft = cboMatchLeft.Text,
                MatchToRight = cboMatchRight.Text,
                MatchToTop = cboMatchTop.Text,
                MatchToBottom = cboMatchBottom.Text
            };

            Int32.TryParse(txtBuffer.Text, out int iBuffer);
            Int32.TryParse(txtScalePlot.Text, out int iScalePlot);
            Int32.TryParse(txtScaleSymbol.Text, out int iScaleSymbol);
            Int32.TryParse(txtScaleFont.Text, out int iScaleFont);

            Int32.TryParse(txtLLX.Text, out int iLLX);
            Int32.TryParse(txtLLY.Text, out int iLLY);
            Int32.TryParse(txtURX.Text, out int iURX);
            Int32.TryParse(txtURY.Text, out int iURY);

            plotItem.Buffer = iBuffer;
            plotItem.PlotScale = iScalePlot;
            plotItem.SymbolScale = iScaleSymbol;
            plotItem.TextScale = iScaleFont;

            plotItem.XL = iLLX;
            plotItem.YL = iLLY;
            plotItem.XU = iURX;
            plotItem.YU = iURY;

            return plotItem;
        }

        private DataTable CustomsToAddOrUpdate()
        {
            //  Get Plot Customs to save
            DataTable dtNewCustoms = new DataTable("Customs");
            dtNewCustoms.Columns.Add("PLDNAME", typeof(string));
            dtNewCustoms.Columns.Add("DIV", typeof(string));
            dtNewCustoms.Columns.Add("CUSTNAME", typeof(string));
            DataRow drNewRow;
            DataRowView oCustomRow = null;

            for (int iIndex = 0; iIndex < this.clbCustoms.CheckedItems.Count; iIndex++)
            {
                drNewRow = dtNewCustoms.NewRow();
                oCustomRow = (DataRowView)this.clbCustoms.CheckedItems[iIndex];
                drNewRow["PLDNAME"] = cboPlotName.Text;
                drNewRow["DIV"] = cboDiv.Text;
                drNewRow["CUSTNAME"] = oCustomRow["CUSTNAME"].ToString();

                dtNewCustoms.Rows.Add(drNewRow);
            }

            return dtNewCustoms;
        }
    }
}
