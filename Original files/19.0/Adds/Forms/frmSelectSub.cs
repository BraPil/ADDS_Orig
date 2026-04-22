using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;

namespace Adds
{
    public partial class  frmSelectSub : Form
    {
        //private int sortColumn = -1;
        private string _SubCode = string.Empty;
        private string _SubDescription = null;
        private string _SubDwg = null;
        private string _SubOrg = null;
        private string _SubScada = null;
        private string _SubEMB = null;
        private string _SubID = null;

        private string _CurrentDivCode = null;
        private string _CurrentDivName = null;
        private int _CurrentDivID = -1;
        private string _TreeNode = null;

        private BindingSource bs = new BindingSource();
        private DataGridViewRow _SelectedRow = null;

        public string SubCode
        {
            get {return _SubCode;}
        }
        public string SubDescription
        {
            get { return _SubDescription; }
        }
        public string SubDwg
        {
            get { return _SubDwg; }
        }
        public string SubOrg
        {
            get { return _SubOrg; }
        }
        public string SubScada
        {
            get { return _SubScada; }
        }
        public string SubEMB
        {
            get { return _SubEMB; }
        }
        public string SubID
        {
            get { return _SubID; }
        }

        public string CurrentDiv
        {
            get { return _CurrentDivCode; }
        }

        public frmSelectSub()
        {
            InitializeComponent();
            
            //  Get Division from AutoLISP
            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            _CurrentDivCode = alResults[0].ToString();
            DecodeDiv(_CurrentDivCode);
            
            TreeViewFilterSetup();
                         
            PopulateSubs();
            DgvSetup();

        }

        private void DecodeDiv(string Div)
        {
            switch (Div.ToUpper())
            {
                case "BH":
                    _CurrentDivName = "Birmingham";
                    _CurrentDivCode = "BH";
                    _CurrentDivID = 1;
                    break;
                case "E_":
                    _CurrentDivName = "Eastern";
                    _CurrentDivCode = "E_";
                    _CurrentDivID = 2;
                    break;
                case "S_":
                    _CurrentDivName = "Southern";
                    _CurrentDivCode = "S_";
                    _CurrentDivID = 3;
                    break;
                case "W_":
                    _CurrentDivName = "Western";
                    _CurrentDivCode = "W_";
                    _CurrentDivID = 4;
                    break;
                case "M_":
                    _CurrentDivName = "Mobile";
                    _CurrentDivCode = "M_";
                    _CurrentDivID = 5;
                    break;
                case "SE":
                    _CurrentDivName = "Southeast";
                    _CurrentDivCode = "SE";
                    _CurrentDivID = 6;
                    break;
                case "AL":
                    _CurrentDivName = "ACC";
                    _CurrentDivCode = "AL";
                    break;
            }
        }
     

        private void TreeViewFilterSetup()
        {
            tvFilter.BeginUpdate();

            switch (_CurrentDivCode)
            {
                case "AL":
                    tvFilter.Nodes.Add("Southern Company");
                    tvFilter.Nodes[0].Nodes.Add("AL", "APC");
                    tvFilter.Nodes[0].Nodes.Add("FPC", "GULF");
                    tvFilter.Nodes[0].Nodes.Add("MPC", "MPC");
                    break;
                case "GA":
                    tvFilter.Nodes.Add("GA", "GPC Transmission");

                    break;
                default:
                    tvFilter.Nodes.Add("APC Distribution");
                    tvFilter.Nodes[0].Nodes.Add("BH","BH");
                    tvFilter.Nodes[0].Nodes.Add("E_", "E_");
                    tvFilter.Nodes[0].Nodes.Add("M_", "M_");
                    tvFilter.Nodes[0].Nodes.Add("S_", "S_");
                    tvFilter.Nodes[0].Nodes.Add("SE", "SE");
                    tvFilter.Nodes[0].Nodes.Add("W_", "W_");
                    
                    break;
            }   
            
            tvFilter.EndUpdate();
            tvFilter.HideSelection = false;

            //  Selects current division node when opening up dialog box.
            TreeNode[] tns = tvFilter.Nodes.Find(_CurrentDivCode, true);
            if (tns.Length > 0)
            {
                tvFilter.SelectedNode = tns[0];
                tvFilter.SelectedNode.EnsureVisible();
                tvFilter.Focus();
            }
        }

        private void DgvSetup()
        {
            this.dgvResults.AllowUserToAddRows = false;
            this.dgvResults.ReadOnly = true;
            this.dgvResults.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            this.dgvResults.MultiSelect = false;
            

            this.dgvResults.Columns["SubCode"].HeaderText = "ADDS Code";
            this.dgvResults.Columns["SubCode"].DisplayIndex = 0;

            if (_CurrentDivCode == "AL")
            {
                this.dgvResults.Columns["SubDivName"].HeaderText = "OPCO";
            }
            else if (_CurrentDivCode == "GA")
            {
                this.dgvResults.Columns["SubDivName"].HeaderText = "TMC";
            }
            else 
            {
                this.dgvResults.Columns["SubDivName"].HeaderText = "Division";
            }
            this.dgvResults.Columns["SubDivName"].DisplayIndex = 1;

            this.dgvResults.Columns["SubDescription"].HeaderText = "Description";
            this.dgvResults.Columns["SubDescription"].DisplayIndex = 2;

            this.dgvResults.Columns["SubDwg"].HeaderText = "Drawing";
            this.dgvResults.Columns["SubDwg"].DisplayIndex = 3;
        }

        private void PopulateSubs()
        {
            DataTable dtResults = null;
            string strOracleConn = Adds._strConn;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT lus.substation AS SubCode, lus.SubDivName, NVL(lus.subdwgname,' ') AS SubDwg, lus.subdescription AS SubDescription, ");
            sbSQL.Append("  NVL(lus.org_id,' ') AS SubOrg, NVL(lus.subdscadaname,' ') AS SubScada, ");
            sbSQL.Append("  NVL(lus.emb_panel_name,' ') AS Sub_EMB, NVL(lus.adds_panel_id,0) AS Sub_ID ");
            sbSQL.Append("FROM addsdb.lu_substations lus ");
            sbSQL.Append("WHERE lus.subdwgname IS NOT NULL AND lus.emb_panel_name IS NOT NULL ");
            sbSQL.Append("ORDER BY lus.subdescription");

            try
            {
                dtResults = Utilities.GetResults(sbSQL, strOracleConn);     // [CHECKED] Oracle 12.c - Connection String

                bs.DataSource = dtResults;
                dgvResults.DataSource = bs;

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {

            }
        }

        private void tvFilter_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            if (e.Node.Text.Length == 2)
            {
               
            }
        }

        private void frmSelectSub_FormClosing(object sender, FormClosingEventArgs e)
        {

        }

        private void tvFilter_AfterSelect(object sender, TreeViewEventArgs e)
        {
           switch (e.Node.Text)
            {
                case "SOUTHERN":
                    bs.Filter = "SubCode LIKE '%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
                case "APC":
                    bs.Filter = "SubCode NOT LIKE 'F%' AND SubCode NOT LIKE 'M%'";
                    dgvResults.DataSource = bs;
                    break;
                case "GPC Transmission":
                    bs.Filter = "Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
                case "GULF":
                    bs.Filter = "SubCode LIKE 'F%'";
                    dgvResults.DataSource = bs;
                    break;
                case "MPC":
                    bs.Filter = "SubCode LIKE 'M%'";
                    dgvResults.DataSource = bs;
                    break;
                case "Southern Company":
                    bs.Filter = "SubDivName LIKE '%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "BH":
                    bs.Filter = "SubDivName LIKE 'Birmingham%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "E_":
                    bs.Filter = "SubDivName LIKE 'Eastern%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "M_":
                    bs.Filter = "SubDivName LIKE 'Mobile%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "SE":
                    bs.Filter = "SubDivName LIKE 'SouthEast%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "S_":
                    bs.Filter = "SubDivName LIKE 'Southern%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
               case "W_":
                    bs.Filter = "SubDivName LIKE 'Western%' AND Sub_EMB NOT LIKE 'MobSub%'";
                    dgvResults.DataSource = bs;
                    break;
            }

           this.dgvResults.ClearSelection();

           _TreeNode = e.Node.Text;

           if (_CurrentDivCode != "AL" && _CurrentDivCode != "GA")
           {
               if (_CurrentDivCode == e.Node.Text)
               {
                   this.dgvResults.Enabled = true;
                   this.dgvResults.ReadOnly = true;
               }
               else
               {
                   this.dgvResults.Enabled = true;
                   this.dgvResults.ReadOnly = true;
               }
           }
        }

        private void dgvResults_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            //if (this.dgvResults.Enabled == true)

            if (_CurrentDivCode != "AL" && _CurrentDivCode != "GA" && _CurrentDivCode != _TreeNode)
            {
                MessageBox.Show("ADDS DLL","You can not open this substation, because you are not in the correct division.");
            }
            else
            {
                _SelectedRow = dgvResults.CurrentRow;

                _SubCode = _SelectedRow.Cells["SubCode"].Value.ToString();
                _SubDescription = _SelectedRow.Cells["SubDescription"].Value.ToString();
                _SubDwg = _SelectedRow.Cells["SubDwg"].Value.ToString();  //SubDivName
                _SubOrg = _SelectedRow.Cells["SubOrg"].Value.ToString();
                _SubScada = _SelectedRow.Cells["SubScada"].Value.ToString();
                _SubEMB = _SelectedRow.Cells["Sub_EMB"].Value.ToString();
                _SubID = _SelectedRow.Cells["Sub_ID"].Value.ToString();

                this.Close();
            }
         
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        
    }

   
}
