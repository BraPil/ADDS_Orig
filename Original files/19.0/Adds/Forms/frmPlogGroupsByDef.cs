using System;
using System.Collections.Generic;
using System.Collections;
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
    public partial class frmPlogGroupsByDef : Form
    {
        //private string _ModuleName = "ADDSPlot Definitions - ";
        private string _strPlotDef = string.Empty;

        private BindingSource bsGroups = new BindingSource();

        public frmPlogGroupsByDef(string strPlotDef)
        {
            InitializeComponent();
            _strPlotDef = strPlotDef;
            Populate();
        }

        private void Populate()
        {
            bsGroups.DataSource = Adds.GetPlotGroupsByPlotDefCount(_strPlotDef);

            this.dgvPlotGroups.DataSource = bsGroups;

            this.dgvPlotGroups.AllowUserToAddRows = false;
            this.dgvPlotGroups.ReadOnly = true;
            this.dgvPlotGroups.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            this.dgvPlotGroups.MultiSelect = false;

            this.dgvPlotGroups.Columns[0].ToolTipText = "Double Click to see group definition.";

            //ToolTip ttGrid = new ToolTip();
            //ttGrid.AutoPopDelay = 5000;
            //ttGrid.InitialDelay = 1000;
            //ttGrid.ReshowDelay = 500;
            //ttGrid.ShowAlways = true;

            //ttGrid.SetToolTip(this.dgvPlotGroups, "Double Click to see group definition.");

            this.lblPlotDef.Text = "Plot Groups for: " + _strPlotDef;
            this.Text = "Plot Groups";
        }

        private void ShowPlotGroupDiaglog()
        {
            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            string strDivision = alResults[0].ToString();

            String strPlotGroup = dgvPlotGroups.SelectedCells[0].Value.ToString();

            Forms.frmPlotGroupDef ofrmPlotGroupDef = new Forms.frmPlotGroupDef(strDivision, strPlotGroup);
            AcadAS.Application.ShowModalDialog(null, ofrmPlotGroupDef, false);
        }

        private void dgvPlotGroups_DoubleClick(object sender, EventArgs e)
        {
            ShowPlotGroupDiaglog();
        }

        private void dgvPlotGroups_CellFormatting(object sender, DataGridViewCellFormattingEventArgs e)
        {
            dgvPlotGroups.Rows[e.RowIndex].Cells[e.ColumnIndex].ToolTipText = "Double Click to see group definition.";
        }
    }
}
