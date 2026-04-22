using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Xml;

using OracleDb    = Oracle.DataAccess.Client;

namespace Adds
{
    public partial class frmLineDialog : Form
    {
        private string _mode = string.Empty;
        private string _title = string.Empty;

        private string _layerName = string.Empty;
        public string Layer
        {
            get { return _layerName; }
            set { _layerName = value; }
        }

        public frmLineDialog(string formTitle, string mode, string layerName)
        {
            InitializeComponent();
            _mode = mode;
            _title = formTitle;
            Layer = layerName;

            if (!string.IsNullOrEmpty(Layer))
            {
                BreakDownLayer();
            }

            switch (_mode)
            {
                case Constants.MODE_EDIT:
                    this.Text = _title;
                    this.btnOk.Visible = true;
                    break;

                case Constants.MODE_QUERY:
                    this.Text = _title;
                    this.cboSubstations.Enabled = false;
                    this.cboFacID.Enabled = false;
                    this.cboLines.Enabled = false;
                    this.cboLineId.Enabled = false;
                    this.cboVolts.Enabled = false;
                    this.btnOk.Visible = false;
                    break;
            }

            PopulateSubstations();
            PopulateTranLines();
            PopulateVoltages();
        }

        private void BreakDownLayer()
        {
            this.txtSubCode.Text = _layerName.Substring(0, 5);
            this.txtLineCode.Text = _layerName.Substring(5, 4);
            this.txtVolts.Text = _layerName.Substring(9, 2);
        }

        private void PopulateVoltages()
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(@"C:\Div_Map\Common\AddsLookups.xml");

            string strNodePath = "AddsLookup/Voltages/Voltage";
            XmlNodeList xNodes = doc.SelectNodes(strNodePath);

            DataTable dt = new DataTable();
            int TempColumn = 0;
            foreach (XmlNode xNode in xNodes.Item(0).ChildNodes)
            {
                TempColumn++;
                DataColumn dc = new DataColumn(xNode.Name, System.Type.GetType("System.String"));
                if (dt.Columns.Contains(xNode.Name))
                {
                    dt.Columns.Add(dc.ColumnName = dc.ColumnName + TempColumn.ToString());
                }
                else
                {
                    dt.Columns.Add(dc);
                }
            }
            int ColumnsCount = dt.Columns.Count;
            for (int i = 0; i < xNodes.Count; i++)
            {
                DataRow dr = dt.NewRow();
                for (int j = 0; j < ColumnsCount; j++)
                {
                    dr[j] = xNodes.Item(i).ChildNodes[j].InnerText;
                }
                dt.Rows.Add(dr);
            }

            dt.DefaultView.Sort = "OrderBy";
            cboVolts.DataSource = dt;
            cboVolts.DisplayMember = "Description";
            cboVolts.ValueMember = "Code";

            int indexValue;
            if (int.TryParse(this.txtVolts.Text.ToString(), out indexValue))
            {
                cboVolts.SelectedValue = txtVolts.Text;
            }
            else
            {
                cboVolts.SelectedValue = 99;
            }
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
                if (dvResults.Find(txtSubCode.Text) != -1)
                {
                    this.cboSubstations.SelectedValue = txtSubCode.Text;
                }
                else
                {
                    this.cboSubstations.SelectedValue = "-9999";
                    this.cboSubstations.BackColor = Color.Red;
                    this.cboSubstations.Font = new Font(this.cboSubstations.Font, this.cboSubstations.Font.Style | FontStyle.Bold);
                }
                
                this.cboFacID.DataSource = dvResults;
                this.cboFacID.DisplayMember = "substation";
                this.cboFacID.ValueMember = "substation";
                if (dvResults.Find(txtSubCode.Text) != -1)
                {
                    this.cboFacID.SelectedValue = txtSubCode.Text;
                }
                else
                {
                    this.cboFacID.SelectedValue = "-9999";
                    this.cboFacID.BackColor = Color.Red;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        private void PopulateTranLines()
        {
            DataTable dtResults = null;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT LPAD(lf.feeder_name, 4, '0') AS feeder_name, lf.feeder_breaker, lf.feeder_description ");
            sbSQL.Append("FROM AddsDB.Lu_Feeders lf ");
            sbSQL.Append("ORDER BY UPPER(lf.feeder_description) ");

            try
            {
                dtResults = Utilities.GetResults(sbSQL, Adds._strConn);     // [CHECKED] Oracle 12.c - Connection String
                DataView dvResults = new DataView(dtResults);
                dvResults.Sort = "Feeder_Name";

                this.cboLines.DataSource = dtResults;
                this.cboLines.DisplayMember = "feeder_description";
                this.cboLines.ValueMember = "feeder_name";

                if (dvResults.Find(txtLineCode.Text) != -1)
                {
                    this.cboLines.SelectedValue = txtLineCode.Text;
                }
                else
                {
                    this.cboLines.SelectedValue = "-999";
                    this.cboLines.BackColor = Color.Red;
                    this.cboLines.Font = new Font(this.cboLines.Font, this.cboLines.Font.Style |  FontStyle.Bold);
                }

                this.cboLineId.DataSource = dvResults;
                this.cboLineId.DisplayMember = "Feeder_Name";
                this.cboLineId.ValueMember = "Feeder_Name";
                if (dvResults.Find(txtLineCode.Text) != -1)
                {
                    this.cboLineId.SelectedValue = txtLineCode.Text;
                }
                else
                {
                    this.cboLineId.SelectedValue = "-999";
                    this.cboLineId.BackColor = Color.Red;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        private void cboVolts_SelectedIndexChanged(object sender, EventArgs e)
        {
            int indexValue;
            if (int.TryParse(this.cboVolts.SelectedValue.ToString(), out indexValue))
            {
                if (this.cboVolts.SelectedValue.ToString() != "99")
                {
                    _layerName = _layerName.Substring(0, 9) + cboVolts.SelectedValue.ToString();
                    BreakDownLayer();
                }
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
                        _layerName = cboSubstations.SelectedValue.ToString() + _layerName.Substring(5, 6);
                        BreakDownLayer();
                        this.cboSubstations.BackColor = Color.White;
                    }
                    cboFacID.SelectedValue = cboSubstations.SelectedValue;
                }
            }
        }

        private void cboLines_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strValue = null;

            if (this.cboLines.SelectedValue != null)
            {
                strValue = this.cboLines.SelectedValue.ToString();
                if (!(string.IsNullOrEmpty(strValue)) && strValue.Length < 5)
                {
                    if (strValue != "-999")                             //  Checks to see if valid line entry
                    {
                        _layerName =
                            _layerName.Substring(0, 5) +
                            cboLines.SelectedValue.ToString() +
                            _layerName.Substring(9, 2);
                        BreakDownLayer();
                        this.cboLines.BackColor = Color.White;
                    }
                    cboLineId.SelectedValue = cboLines.SelectedValue;
                }
            }
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            Layer = _layerName;
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
                    }
                }
            }
        }

        private void cboLineId_SelectedIndexChanged(object sender, EventArgs e)
        {
            string strValue = null;

            if (this.cboLineId.SelectedValue != null)
            {
                strValue = this.cboLineId.SelectedValue.ToString();
                if (!(string.IsNullOrEmpty(strValue)) && strValue.Length < 5)
                {
                    cboLines.SelectedValue = cboLineId.SelectedValue;
                    if (strValue != "-999")
                    {
                        this.cboLineId.BackColor = Color.White;
                    }
                }
            }
        }
    }
}
