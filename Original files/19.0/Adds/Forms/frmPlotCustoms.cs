using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using OracleDb = Oracle.DataAccess.Client;


namespace Adds.Forms
{
    public partial class frmPlotCustoms : Form
    {
        private OracleDb.OracleDataAdapter odaCustoms = null;
        DataSet dsetOracle = new DataSet();

        private BindingSource bsCustoms = new BindingSource();
        private DataTable _dtCustoms = null;
        private string _strDiv = string.Empty;

        private string _ModuleName = "ADDSPlot Definitions - Customs";

        public frmPlotCustoms()
        {
            InitializeComponent();
            this.Text = "ADDS - Plot Customs Edit";
            PopulateControls();
        }

        private void PopulateControls()
        {
            //  Define and populate binding source
            odaCustoms = Adds.GetCustomsAll();
            DataSet dsetOracle = new DataSet();
            odaCustoms.Fill(dsetOracle, "PlotCustom");
            _dtCustoms = dsetOracle.Tables["PlotCustom"];
            _dtCustoms.PrimaryKey = new DataColumn[] { _dtCustoms.Columns["CUSTNAME"] };

            bsCustoms.DataSource = _dtCustoms; //Adds.GetCustomsAll().Tables["PlotCustom"];
            bsCustoms.CurrentChanged += new EventHandler(bsCustoms_CurrentChanged);

            //  Combobox settings for Custom Name
            cboName.ValueMember = "CUSTNAME";
            cboName.DisplayMember = "CUSTNAME";
            cboName.DataSource = bsCustoms;
            
            //  Textbox binding see events for updates
            txtDescr.DataBindings.Add("Text", bsCustoms, "custdescription", true, DataSourceUpdateMode.OnPropertyChanged);

            Binding bByLabel = new Binding("Text", bsCustoms, "defined_by_id");
            bByLabel.Format += delegate (object sentFrom, ConvertEventArgs convertEventArgs)
            {
                convertEventArgs.Value = "Defined By:  " + convertEventArgs.Value;
            };
            lblDefinedBy.DataBindings.Add(bByLabel);

            Binding bDate = new Binding("Text", bsCustoms, "defined_dtm");
            bDate.Format += delegate(object sentFrom, ConvertEventArgs convertEventArgs)
            {
                convertEventArgs.Value = "Date:           " + convertEventArgs.Value;
            };
            lblDefinedDate.DataBindings.Add(bDate);

            ClearControls();
        }

        private void bsCustoms_CurrentChanged(object sender, EventArgs e)
        {
            string strTemp = string.Empty;
            //  Gets current selected Plot Definition row data
            DataRowView drvCurrentSelect = this.bsCustoms.Current as DataRowView;

            //  Selects the custom name to show in combobox
            strTemp = drvCurrentSelect.Row["custname"].ToString();
            if (string.IsNullOrEmpty(strTemp.Trim()))
            {
                cboName.SelectedIndex = -1;     //  Show blank line if set to nothing like with an ADD
            }
            else
            {
                cboName.SelectedValue = strTemp;
            }

            //  Updates textbox & Label controls for selected Plot Definition
            strTemp = drvCurrentSelect.Row["DIVNAM"].ToString();
            cboDiv.SelectedItem = strTemp;

        }

        private void frmPlotCustoms_Load(object sender, EventArgs e)
        {
            //ClearControls();
        }

        private void ClearControls()
        {
            cboName.SelectedIndex = -1;
            cboDiv.SelectedIndex = -1;

            bsCustoms.SuspendBinding();
            txtDescr.Text = string.Empty;
            lblDefinedBy.Text = string.Empty;
            lblDefinedDate.Text = string.Empty;
            bsCustoms.ResumeBinding();

            btnAdd.Text = "&Add";
        }


        #region *** Form Control Events *** 

        //  For update changes any changes do not get updated to DB until UpDate button clicked
        private void txtDescr_Leave(object sender, EventArgs e)
        {
            DataRowView drvChanged = bsCustoms.Current as DataRowView;
        }

        //  For update changes any changes do not get updated to DB until UpDate button clicked
        private void cboDiv_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataRowView drvChanged = bsCustoms.Current as DataRowView;
            drvChanged.Row["divnam"] = cboDiv.Text;
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            if (btnAdd.Text == "&Add")
            {

                DataRow drNew = _dtCustoms.NewRow();
                drNew["custname"] = cboName.Text;
                drNew["custdescription"] = txtDescr.Text;
                drNew["divnam"] = cboDiv.Text;
                drNew["defined_by_id"] = Adds._strUserID;
                drNew["defined_dtm"] = DateTime.Now;
                _dtCustoms.Rows.Add(drNew);

                odaCustoms.Update(_dtCustoms);

                ClearControls();

                MessageBox.Show("Custom " + cboName.Text + " added to database", _ModuleName);
            }
            else
            {
                bsCustoms.EndEdit();
                odaCustoms.Update(_dtCustoms);
                MessageBox.Show("Custom " + cboName.Text + " has been updated.", _ModuleName);
            }
        }

        private void btnDelete_Click(object sender, EventArgs e)
        {
            DialogResult drResult = MessageBox.Show("Custom " + cboName.Text + " deleted from database?", _ModuleName, MessageBoxButtons.YesNo);

            if (drResult == DialogResult.Yes)
            {
                _dtCustoms.Rows.Find(cboName.Text).Delete();    //  Sets row state to Delete heed by Oracle Adapter
                odaCustoms.Update(_dtCustoms);
            }
        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void cboName_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboName.SelectedIndex > -1)
            {
                btnAdd.Text = "&Update";
                btnDelete.Enabled = true;
            }
            else
            {
                btnAdd.Text = "&Add";
                ClearControls();
            }
        }

        #endregion
    }
}
