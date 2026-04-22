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
    public partial class frmPlotGroupDef : Form
    {
        private BindingSource bsGroups = new BindingSource();
        private BindingSource bsGroupsDefs = new BindingSource();
        private DataTable _dtCustoms = null;
        private DataTable _dtGroupsDefs = null;
        private string _strDiv = string.Empty;
        private string _GroupPassedIn = string.Empty;

        private string _ModuleName = "ADDSPlot Definitions - ";

        public frmPlotGroupDef(string strDivison, string strGroup)
        {
            _strDiv = strDivison;
            _GroupPassedIn = strGroup;
            InitializeComponent();
            this.Text = "ADDS - Plot Group Edit";
            Populate();
        }

        private void frmPlotGroupDef_Load(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(_GroupPassedIn))
            {

            }
            else
            {
                cboGroupName.SelectedValue = _GroupPassedIn;
            }

            dgvPlotDefs.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            dgvPlotDefs.MultiSelect = false;
            dgvPlotDefs.RowPrePaint += new DataGridViewRowPrePaintEventHandler(dgvPlotDefs_RowPrePaint);

            dgvPlotDefs.Columns["pldgroup"].Visible = false;
            dgvPlotDefs.Columns["defined_by_id"].Visible = false;
            dgvPlotDefs.Columns["defined_dtm"].Visible = false;
            dgvPlotDefs.Columns["Num_Shts"].Visible = false;
            dgvPlotDefs.Columns["SortNum"].Visible = false;
        }

        private void dgvPlotDefs_RowPrePaint(object sender, DataGridViewRowPrePaintEventArgs e)
        {
            e.PaintParts &= ~DataGridViewPaintParts.Focus;
        }

        private void Populate()
        {
            bsGroups.DataSource = Adds.GetPlotGroupNames();
            //bsGroupsDefs.DataSource = Adds.GetPlotDefsByPlotGroup("");

            cboGroupName.DataSource = bsGroups;
            cboGroupName.ValueMember = "PldGroup";
            cboGroupName.DisplayMember = "PldGroup";
            cboGroupName.SelectedIndex = -1;
            
            bsGroups.CurrentChanged += new EventHandler(bsGroups_CurrentChanged);


            _dtGroupsDefs = Adds.GetPlotDefsByPlotGroup("");
            bsGroupsDefs.DataSource = _dtGroupsDefs;
            //bsGroupsDefs.Sort = "SortNum";
            bsGroupsDefs.Filter = "PLDNAME = null";

            dgvPlotDefs.DataSource = bsGroupsDefs;
            dgvPlotDefs.Columns["PLDNAME"].HeaderText = "Plot Name";
            dgvPlotDefs.Columns["sht_Num"].HeaderText = "ShtNum";
            dgvPlotDefs.Columns["grporder"].HeaderText = "Order";
            dgvPlotDefs.AutoResizeColumns();
            
            cboPlotDef.DataSource = Adds.GetPlots(_strDiv);
            cboPlotDef.ValueMember = "PLDNAME";
            cboPlotDef.DisplayMember = "PLDNAME";
            cboPlotDef.SelectedIndex = -1;

            _dtCustoms = Adds.GetPlotDefCustoms(null);
            clbCustoms.DataSource = _dtCustoms;
            clbCustoms.DisplayMember = "CUSTNAME";
        }

        private void bsGroups_CurrentChanged(object sender, EventArgs e)
        {
            string strCurrentPlotGroup = string.Empty;

            //  Gets current selected Plot Definition row data
            DataRowView drvCurrentPlotGroup = this.bsGroups.Current as DataRowView;
            strCurrentPlotGroup = drvCurrentPlotGroup.Row["PLDGROUP"].ToString();

            //  Updates DataGridView Plots for new Plot Goup Selected
            _dtGroupsDefs = Adds.GetPlotDefsByPlotGroup(strCurrentPlotGroup);
            bsGroupsDefs.DataSource = _dtGroupsDefs;
            bsGroupsDefs.Filter = "PLDGROUP = '" + strCurrentPlotGroup + "'";
            dgvPlotDefs.DataSource = bsGroupsDefs;

            //  Select first plot row in DataGridView & resizes columns
            dgvPlotDefs.CurrentCell.Selected = true;
            dgvPlotDefs.CurrentRow.Selected = true;
            dgvPlotDefs.AutoResizeColumns();

            //lblDefinedBy.Text = drvCurrentPlotGroup.Row["DEFINED_BY_ID"].ToString();
            //lblDefinedDate.Text = drvCurrentPlotGroup.Row["DEFINED_DTM"].ToString();


        }


        private void ClearAllControls()
        {
            txtSheetNo.Text = string.Empty;
            txtSheetOf.Text = string.Empty;
            txtScaleFont.Text = string.Empty;
            txtScalePlot.Text = string.Empty;
            txtScaleSymbol.Text = string.Empty;

            cboPlotDef.SelectedIndex = -1;
            cboGroupName.SelectedIndex = -1;
            cboSheetSize.SelectedIndex = -1;

            bsGroupsDefs.Filter = "PLDNAME = null";

            //  Clear all checkmarks from Customs
            clbCustoms.DataSource = Adds.GetPlotDefCustoms("");

            btnDelete.Enabled = false;
        }

        private void dgvPlotDefs_SortCompare(object sender, DataGridViewSortCompareEventArgs e)
        {
            if (e.Column.Index == 1)
            {
                e.SortResult = int.Parse(e.CellValue1.ToString()).CompareTo(int.Parse(e.CellValue2.ToString()));
                e.Handled = true;
            }
        }

        private void dgvPlotDefs_Click(object sender, EventArgs e)
        {
            dgvPlotDef_Update();
        }

        private void dgvPlotDefs_SelectionChanged(object sender, EventArgs e)
        {
            dgvPlotDef_Update();
        }

        private void dgvPlotDef_Update()
        {
            string strPlotSelected = string.Empty;

            if (dgvPlotDefs.SelectedCells.Count > 0)
            {
                int iSelectedRowIndex = dgvPlotDefs.SelectedCells[0].RowIndex;

                DataGridViewRow dgvrSelectedRow = dgvPlotDefs.Rows[iSelectedRowIndex];
                strPlotSelected = dgvrSelectedRow.Cells["PLDNAME"].Value.ToString();

                cboPlotDef.SelectedValue = strPlotSelected;

                DataRowView drvCurrentSelect = this.bsGroupsDefs.Current as DataRowView;
                string strTemp = drvCurrentSelect.Row["SHT_NUM"].ToString();
                txtSheetNo.Text = strTemp;

                strTemp = drvCurrentSelect.Row["Num_SHTS"].ToString();
                txtSheetOf.Text = strTemp;

                strTemp = drvCurrentSelect.Row["DEFINED_BY_ID"].ToString();
                lblDefinedBy.Text = "Modified By: " + strTemp;

                strTemp = drvCurrentSelect.Row["DEFINED_DTM"].ToString();
                lblDefinedDate.Text = "Date: " + strTemp;

                if (iSelectedRowIndex > 0)
                {
                    btnUp.Enabled = true;
                }
                else
                {
                    btnUp.Enabled = false;
                }

                if (iSelectedRowIndex < dgvPlotDefs.RowCount -1)
                {
                    btnDown.Enabled = true;
                }
                else
                {
                    btnDown.Enabled = false;
                }
            }
            
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            ClearAllControls();
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnAddPlotDef_Click(object sender, EventArgs e)
        {
            bool blnIsInList = false;
            int iExistingPlots = 0;
            string strPlotDef = string.Empty;

            //  Check to make sure a Group name is specified (existing or new)
            if (cboGroupName.Text !=  string.Empty)
            {
                //  Check to make sure there is a  selected plot to add first
                if (cboPlotDef.SelectedIndex > -1)
                {
                    strPlotDef = this.cboPlotDef.Text;

                    //  Check to make sure the plot is not already in the group
                    foreach(DataGridViewRow dgvRow in dgvPlotDefs.Rows)
                    {
                        if (dgvRow.Cells["PLDNAME"].Value != null)
                        {
                            if (dgvRow.Cells["PLDNAME"].Value.ToString() == strPlotDef)
                            {
                                blnIsInList = true;
                            }
                        }
                    }

                    if (!blnIsInList)
                    {
                        //  Get number of plots in group
                        iExistingPlots = dgvPlotDefs.RowCount + 1;

                        DataRow dr = _dtGroupsDefs.NewRow();
                       
                        dr.ItemArray = (object[])_dtGroupsDefs.Rows[0].ItemArray.Clone();
                        dr["PLDGROUP"] = cboGroupName.Text;
                        dr["PLDNAME"] = strPlotDef;
                        dr["Sht_Num"] = iExistingPlots.ToString();
                        dr["SortNum"] = iExistingPlots;
                        _dtGroupsDefs.Rows.Add(dr);

                        dgvPlotDefs.DataSource = _dtGroupsDefs;
                        bsGroupsDefs.Filter = "PLDGROUP = '" + cboGroupName.Text + "'";
                        ReSortPlotDefs();

                    }
                    else
                    {
                        MessageBox.Show("The plot you selected is already in the group.", _ModuleName + "Add Plot to Group");
                    }
                }
                else
                {
                    MessageBox.Show("You need to select a plot to add to the group first.", _ModuleName + "Add Plot to Group");
                }
            }
            else
            {
                MessageBox.Show("You need to either add a new plot group or select an existing group to modifiy first.", _ModuleName + "Add Plot to Group");
            }
        }

        internal void ReSortPlotDefs()
        {
            int iNumberOfRows = dgvPlotDefs.RowCount;
            int iNewSheetNo = 0;

            foreach (DataGridViewRow dgvRow in dgvPlotDefs.Rows)
            {
                if (dgvRow.Cells["PLDNAME"].Value != null)
                {
                    iNewSheetNo ++;
                    dgvRow.Cells["SHT_NUM"].Value = iNewSheetNo.ToString();
                    dgvRow.Cells["NUM_SHTS"].Value = iNumberOfRows.ToString();
                    dgvRow.Cells["SortNum"].Value = iNewSheetNo;
                }
            }
            //this.dgvPlotDefs.Sort(this.dgvPlotDefs.Columns["SortNum"], ListSortDirection.Ascending);
            this.dgvPlotDefs.Refresh();
        }

        private DataTable CustomsToAddOrUpdate(DataTable dtGroupPlots)
        {
            //  Get Plot Customs to save
            DataTable dtNewCustoms = new DataTable("Customs");
            dtNewCustoms.Columns.Add("PLDNAME", typeof(string));
            //dtNewCustoms.Columns.Add("DIV", typeof(string));
            dtNewCustoms.Columns.Add("CUSTNAME", typeof(string));
            DataRow drNewRow;
            DataRowView oCustomRow = null;

            foreach (DataRow oRow in dtGroupPlots.Rows)
            {
                for (int iIndex = 0; iIndex < this.clbCustoms.CheckedItems.Count; iIndex++)
                {
                    drNewRow = dtNewCustoms.NewRow();
                    oCustomRow = (DataRowView)this.clbCustoms.CheckedItems[iIndex];
                    drNewRow["PLDNAME"] = oRow["PLDNAME"].ToString();   //cboPlotName.Text;
                    //drNewRow["DIV"] = cboDiv.Text;
                    drNewRow["CUSTNAME"] = oCustomRow["CUSTNAME"].ToString();

                    dtNewCustoms.Rows.Add(drNewRow);
                }
            }
            return dtNewCustoms;
        }

        private Plot PlotDefOverides()
        {
            int iNumber;
            Plot plotItem = new Plot();

            if(!string.IsNullOrEmpty(cboSheetSize.Text))
            {
                plotItem.Sheet = cboSheetSize.Text;
            }
            if(Int32.TryParse(txtScalePlot.Text, out iNumber))
            {
                plotItem.PlotScale = iNumber;
            }
            if (Int32.TryParse(txtScaleSymbol.Text, out iNumber))
            {
                plotItem.SymbolScale = iNumber;
            }
            if (Int32.TryParse(txtScaleFont.Text, out iNumber))
            {
                plotItem.TextScale = iNumber;
            }

            return plotItem;
        }


        private void btuRemovePlot_Click(object sender, EventArgs e)
        {
            bsGroupsDefs.RemoveCurrent();
            ReSortPlotDefs();
        }

        private void btnUp_Click(object sender, EventArgs e)
        {
            //  Get row positions for the move
            int iSelectedRowIndex = dgvPlotDefs.SelectedRows[0].Index;
            int iRowAboveIndex = iSelectedRowIndex - 1;

            DataRow drRowToMove = _dtGroupsDefs.Rows[iSelectedRowIndex];
            DataRow dr = _dtGroupsDefs.NewRow();
            dr.ItemArray = (object[])_dtGroupsDefs.Rows[iSelectedRowIndex].ItemArray.Clone();

            _dtGroupsDefs.Rows[iSelectedRowIndex].Delete();
            _dtGroupsDefs.AcceptChanges();

            _dtGroupsDefs.Rows.InsertAt(dr, iRowAboveIndex);
            _dtGroupsDefs.AcceptChanges();

            bsGroupsDefs.DataSource = _dtGroupsDefs;
            dgvPlotDefs.DataSource = bsGroupsDefs;
            bsGroupsDefs.Filter = "PLDGROUP = '" + cboGroupName.Text + "'";
            this.dgvPlotDefs.Refresh();
            ReSortPlotDefs();

            //  Set Cursor and Selected Row to moved plot location in datagridview
            dgvPlotDefs.CurrentCell = dgvPlotDefs.Rows[iRowAboveIndex].Cells[0];
            dgvPlotDefs.Rows[iRowAboveIndex].Selected = true;
        }

        private void btnDown_Click(object sender, EventArgs e)
        {
            //  Get row positions for the move
            int iSelectedRowIndex = dgvPlotDefs.SelectedRows[0].Index;
            int iRowBlowIndex = iSelectedRowIndex + 1;


            DataRow drRowToMove = _dtGroupsDefs.Rows[iSelectedRowIndex];
            DataRow dr = _dtGroupsDefs.NewRow();
            dr.ItemArray = (object[])_dtGroupsDefs.Rows[iSelectedRowIndex].ItemArray.Clone();

            _dtGroupsDefs.Rows[iSelectedRowIndex].Delete();
            _dtGroupsDefs.AcceptChanges();

            _dtGroupsDefs.Rows.InsertAt(dr, iRowBlowIndex);
            _dtGroupsDefs.AcceptChanges();

            bsGroupsDefs.DataSource = _dtGroupsDefs;
            dgvPlotDefs.DataSource = bsGroupsDefs;
            bsGroupsDefs.Filter = "PLDGROUP = '" + cboGroupName.Text + "'";
            this.dgvPlotDefs.Refresh();
            ReSortPlotDefs();

            //  Set Cursor and Selected Row to moved plot location in datagridview
            dgvPlotDefs.CurrentCell = dgvPlotDefs.Rows[iRowBlowIndex].Cells[0];
            dgvPlotDefs.Rows[iRowBlowIndex].Selected = true;
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            string strGroup = cboGroupName.Text;
            string strResults = string.Empty;
            int iRowsAffected = -1;

            //  Get PlotDefs for new group
            DataTable dt_GroupPlots = (DataTable)bsGroupsDefs.DataSource;
            DataRow[] drGroupPlots = dt_GroupPlots.Select("PLDGROUP ='" + strGroup + "'");
            DataTable dtResults = drGroupPlots.CopyToDataTable();

            iRowsAffected = Adds.AddPlotGroup(dtResults);

            //  Check results and update message based on results
            if (iRowsAffected > 0)
            {
                strResults = "Plot Group " + strGroup + " added to database";
            }
            else
            {
                strResults = "Plot Group " + strGroup + " there was an error records were not updated in the database";
            }

            //  Apply Custom Overrides if needed
            DataTable dtCustomsToUpdate = CustomsToAddOrUpdate(dtResults);
            if (dtCustomsToUpdate != null)
            {
                iRowsAffected = Adds.AddUpdatePlotDefCustoms(null, dtCustomsToUpdate);
                if (iRowsAffected > 0)
                {
                    strResults += "\n - Plot Custom Overides applied";
                }
            }

            //  Apply Plot Defintion overrides if needed
            Plot plotOverRides = PlotDefOverides();
            iRowsAffected = Adds.UpdatedAddsDefOverides(plotOverRides, dtResults);
            if (iRowsAffected > 0)
            {
                strResults += "\n - Plot Definition Overides applied";
            }

            MessageBox.Show(strResults, _ModuleName + " Update Plot Group");
        }

        private void btnUpdate_Click(object sender, EventArgs e)
        {
            string strGroup = cboGroupName.Text;
            string strResults = string.Empty;
            int iRowsAffected = -1;

            if (!string.IsNullOrEmpty(strGroup))
            {
                //  Delete existing Plot Group then add the updated one back in.
                iRowsAffected = Adds.DeletePlotGroup(strGroup);

                DataTable dt_GroupPlots = (DataTable)bsGroupsDefs.DataSource;
                DataRow[] drGroupPlots = dt_GroupPlots.Select("PLDGROUP ='" + strGroup + "'");
                DataTable dtResults = drGroupPlots.CopyToDataTable();
                iRowsAffected = Adds.AddPlotGroup(dtResults);

                //  Check results and update message based on results
                if (iRowsAffected > 0)
                {
                    strResults = "Plot Group " + strGroup + " has been updated";
                }
                else
                {
                    strResults = "Plot Group " + strGroup + " there was an error records were not updated in the database";
                }

                //  Apply Custom Overrides if needed
                DataTable dtCustomsToUpdate = CustomsToAddOrUpdate(dtResults);
                if (dtCustomsToUpdate.Rows.Count > 0)
                {
                    iRowsAffected = Adds.AddUpdatePlotDefCustoms(null, dtCustomsToUpdate);
                    if (iRowsAffected > 0)
                    {
                        strResults += "\n - Plot Custom Overides applied";
                    }
                }

                //  Apply Plot Defintion overrides if needed
                Plot plotOverRides = PlotDefOverides();
                iRowsAffected = Adds.UpdatedAddsDefOverides(plotOverRides, dtResults);
                if (iRowsAffected > 0)
                {
                    strResults += "\n - Plot Definition Overides applied";
                }

                MessageBox.Show(strResults, _ModuleName + " Update Plot Group");
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            string strGroup = cboGroupName.Text;
            string strResults = string.Empty;
            int iRowsAffected = -1;

            if (!string.IsNullOrEmpty(strGroup))
            {
                DialogResult drResult = MessageBox.Show("Are you SURE you want to delete Plot Group " + strGroup + " from the database?",
                    _ModuleName, MessageBoxButtons.YesNo);

                if (drResult == DialogResult.Yes)
                {
                    iRowsAffected = Adds.DeletePlotGroup(strGroup);

                    //  Update Form Controls to remove deleted GroupPlot info
                    bsGroups.RemoveCurrent();
                    bsGroups.EndEdit();
                    bsGroups.ResetBindings(false);
                    ClearAllControls();

                    if (iRowsAffected > 0)
                    {
                        strResults = "Group " + strGroup + " deleted from database";
                    }
                    else
                    {
                        strResults = "Group " + strGroup + " not found in database";
                    }
                }
                else
                {
                    strResults = "Plot Group delete canceled.";
                }
            }
            else
            {
                strResults = "Plot Group cannot be blank. You need to select a Plot Group.";
            }
            MessageBox.Show(strResults, _ModuleName + " Delete Plot Group");
        }

        private void cboGroupName_Click(object sender, EventArgs e)
        {
            btnDown.Enabled = false;
            btnUp.Enabled = false;

            btnDelete.Enabled = true;

        }
        
    }
}
