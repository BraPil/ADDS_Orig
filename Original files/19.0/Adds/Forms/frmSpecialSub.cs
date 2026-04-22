using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using OracleDb = Oracle.DataAccess.Client;

namespace Adds
{
    public partial class frmSpecialSub : Form
    {
        private string _FacID = string.Empty;
        public string FacID
        {
            get { return _FacID; }
            set { _FacID = value; }
        }
        private string _AddsSLDDwg = string.Empty;
        public string AddsSLDDwg
        {
            get { return _AddsSLDDwg; }
            set { _AddsSLDDwg = value; }
        }
        private string _AddsPanelName = string.Empty;
        public string AddsPanelName
        {
            get { return _AddsPanelName; }
            set { _AddsPanelName = value; }
        }
        private string _EMBPanelName = string.Empty;
        public string EMBPanelName
        {
            get { return _EMBPanelName; }
            set { _EMBPanelName = value; }
        }

        public frmSpecialSub()
        {
            InitializeComponent();
            PopulateSubstations();
        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void PopulateSubstations()
        {
            DataTable dtResults = null;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT LPAD(ls.substation, 5, '0') AS  substation, ls.subdescription ");
            sbSQL.Append("FROM AddsDB.Lu_Substations ls ");
            sbSQL.Append("ORDER BY UPPER(ls.subdescription) ");

            try
            {
                dtResults = Utilities.GetResults(sbSQL, Adds._strConn);         // [CHECKED] Oracle 12.c - Connection String
                DataView dvResults = new DataView(dtResults);
                dvResults.Sort = "substation";

                this.cboSubstations.DataSource = dtResults;
                this.cboSubstations.DisplayMember = "subdescription";
                this.cboSubstations.ValueMember = "substation";
                //if (dvResults.Find(txtSubCode.Text) != -1)
                //{
                //    this.cboSubstations.SelectedValue = txtSubCode.Text;
                //}
                //else
                //{
                    this.cboSubstations.SelectedValue = "-9999";
                    this.cboSubstations.BackColor = Color.Red;
                    this.cboSubstations.Font = new Font(this.cboSubstations.Font, this.cboSubstations.Font.Style | FontStyle.Bold);
                //}

                this.cboFacID.DataSource = dvResults;
                this.cboFacID.DisplayMember = "substation";
                this.cboFacID.ValueMember = "substation";
                //if (dvResults.Find(txtSubCode.Text) != -1)
                //{
                //    this.cboFacID.SelectedValue = txtSubCode.Text;
                //}
                //else
                //{
                    this.cboFacID.SelectedValue = "-9999";
                    this.cboFacID.BackColor = Color.Red;
                //}
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        private void cboSubstations_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strValue = null;

            if (this.cboSubstations.SelectedValue != null)
            {
                strValue = this.cboSubstations.SelectedValue.ToString();
                if (!(string.IsNullOrEmpty(strValue)) && strValue.Length < 6)
                {
                    if (strValue != "-9999")
                    {
                        //_layerName = cboSubstations.SelectedValue.ToString() + _layerName.Substring(5, 6);
                        //BreakDownLayer();
                        this.cboSubstations.BackColor = Color.White;
                    }
                    cboFacID.SelectedValue = cboSubstations.SelectedValue;
                }
            }
        }

        private void cboFacID_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strValue = null;

            if (this.cboFacID.SelectedValue != null)
            {
                strValue = this.cboFacID.SelectedValue.ToString();
                if (!(string.IsNullOrEmpty(strValue)) && strValue.Length < 6)
                {
                    cboSubstations.SelectedValue = cboFacID.SelectedValue;
                    if (strValue != "-9999")
                    {
                        this.cboFacID.BackColor = Color.White;
                        _FacID = "A" + strValue.Substring(1, 4);
                        _AddsPanelName = "A" + strValue.Substring(1, 4) + "DS";
                        this.txtAddsPanel.Text = _AddsPanelName;
                        _AddsSLDDwg = _AddsPanelName;
                        this.txtAddsDwg.Text = _AddsSLDDwg;
                    }
                    else
                    {
                        
                    }
                }
            }
        }

        private bool DoesSubStationDrawingExist()
        {
            bool statusFlag = false;
            string intRows;

            string SQL_SELECT =
                "SELECT COUNT(ls.subdwgname) " +
                "FROM AddsDB.Lu_SubStations ls " +
                "WHERE UPPER(ls.subdwgname) = '" + txtDMCName.Text.ToUpper() + "' " ;
            
            using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
            {
                oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String 
                OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();
                oracleCommand.CommandType = CommandType.Text;

                oracleCommand.CommandText = SQL_SELECT;

                intRows = oracleCommand.ExecuteScalar().ToString();

                if (intRows == "0")
                {
                    txtEMBName.Text = "SA_" + txtDMCName.Text;
                    _EMBPanelName = txtEMBName.Text;
                }
                else
                { 
                }
            }


            return statusFlag;
        }

        private void btnCheckSLDName_Click(object sender, EventArgs e)
        {
            bool bolExists = DoesSubStationDrawingExist();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            _EMBPanelName = txtEMBName.Text;
        }

    }
}
