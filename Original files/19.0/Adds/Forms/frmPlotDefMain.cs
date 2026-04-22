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
    public partial class frmPlotDefMain : Form
    {
        private DataTable _dtPlots = null;
        private BindingSource bsPlots = new BindingSource();
        private string _strDiv = string.Empty;

        public frmPlotDefMain(string strDiv)
        {
            _strDiv = strDiv;
            InitializeComponent();
            Populate();
        }

        private void frmPlotDefMain_Load(object sender, EventArgs e)
        {
            //this.dgvPlots.MouseDown += new MouseEventHandler(this.dgvPlots_MouseDown);
        }

        private void dgvPlots_MouseDown(object sender, MouseEventArgs e)
        {
            //switch (e.Button)
            //{
            //    case MouseButtons.Right:
            //        int iCurrentRow = dgvPlots.HitTest(e.X, e.Y).RowIndex;
            //        cmsPlotDefMain.Show(cmsPlotDefMain, new Point(e.X, e.Y));

            //        break;

            //}
        }

        private void Populate()
        {
            _dtPlots = Adds.GetPlots(_strDiv);
            //DataRow dr = _dtPlots.NewRow();
            //_dtPlots.Rows.Add(dr);
            bsPlots.DataSource = _dtPlots;

            this.dgvPlots.DataSource = bsPlots;

            this.dgvPlots.AllowUserToAddRows = false;
            this.dgvPlots.ReadOnly = true;
            this.dgvPlots.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            this.dgvPlots.MultiSelect = false;

        }

        private void plotToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ShowPlotDefinitionDialog();
        }

        private void dgvPlots_DoubleClick(object sender, EventArgs e)
        {
            ShowPlotDefinitionDialog();           
        }

        private void ShowPlotDefinitionDialog()
        {
            string strPlotDef = string.Empty;
            strPlotDef = dgvPlots.SelectedCells[0].Value.ToString();
            Forms.frmPlot ofrmPlot = new Forms.frmPlot(_strDiv, strPlotDef);   //00019458
            AcadAS.Application.ShowModalDialog(null, ofrmPlot, false);
        }

        private void plotGroupsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            String strCommand = string.Empty;
            string strPlotDef = string.Empty;
            strPlotDef = dgvPlots.SelectedCells[0].Value.ToString();

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            //  Build & send Lisp command to plot selected plot definition to AutoCAD LISP
            strCommand = "(PlotDef \"" + strPlotDef + "\" PrtDesc)\n";
            doc.SendStringToExecute(strCommand, true, false, true);
            //this.Close();
        }

        private void groupsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string strPlotDef = dgvPlots.SelectedCells[0].Value.ToString();
            Forms.frmPlogGroupsByDef ofrmPlotGroups = new frmPlogGroupsByDef(strPlotDef);
            AcadAS.Application.ShowModalDialog(null, ofrmPlotGroups, false);
        }
    }
}
