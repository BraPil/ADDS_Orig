using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Xml;
using System.Security.Principal;

using OracleDb = Oracle.DataAccess.Client;

using AcadASA = Autodesk.AutoCAD.ApplicationServices.Application;


namespace Adds
{
    public partial class frmLogin : Form
    {
        private string _DBCurrentUser = string.Empty;
        public string DBCurrentUser
        {
            get { return _DBCurrentUser; }
        }
        
        private string _DBName = string.Empty;
        public string DBName
        {
            get { return _DBName; }
            set { _DBName = value; }
        }

        private string _DBDescription = string.Empty;
        public string DBDescription
        {
            get { return _DBDescription; }
            set { _DBDescription = value; }
        }

        private string _DBPwd = string.Empty;
        public string DBPwd
        {
            get { return _DBPwd; }
            set { _DBPwd = value; }
        }

        private string _DBRole = string.Empty;
        public string DBRole
        {
            get { return _DBRole; }
        }
        
        private Int32 _DBConnStatus;
        public Int32 DBConnStatus
        {
            get { return _DBConnStatus; }
        }

        private string _AppID = string.Empty;
        public string AppID
        {
            get { return _AppID; }
            set { _AppID = value; }
        }

        private string _AppPwd = string.Empty;
        public string AppPwd
        {
            get { return _AppPwd; }
            set { _AppPwd = value; }
        }

        private BindingSource bsLoggins = new BindingSource();

        public frmLogin()
        {
            InitializeComponent();

            int? iSpace = SCS.g_strApplName.IndexOf(" ");
            int iSpacePos = iSpace ?? 0;
            this.Text = SCS.g_strApplName.Substring(0, iSpacePos) + " - Database Login";  


        }
        
        private void PopulateDB()
        {
            string strPreferLogingDB = string.Empty;

            XmlDocument doc = new XmlDocument();
            doc.Load(@"C:\Div_Map\Common\AddsLookups.xml");

            string strNodePath = "AddsLookup/Logins/*";
            XmlNodeList xNodes = doc.SelectNodes(strNodePath);

            DataTable dt = new DataTable();

            //  Reads and setup column names
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
            //  Reads rows and adds them to the table.
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

            bsLoggins.DataSource = dt;

            //  Check for preferencs Login DB
            strNodePath = "AddsLookup/Preferences/*";
            xNodes = doc.SelectNodes(strNodePath);
            foreach (XmlNode aNode in xNodes)
            {
                switch (aNode.Name)
                {
                    case "LoginDB":
                        strPreferLogingDB = aNode.InnerText.ToString();
                        break;
                }
            }

            cboDBList.DataSource = bsLoggins;
            cboDBList.DisplayMember = "Description";
            cboDBList.ValueMember = "Instance";

            //if (strPreferLogingDB != string.Empty)
            //{
            //    cboDBList.SelectedValue = strPreferLogingDB;
            //}

            string strCurrentWorkSpaceName = (string)AcadASA.GetSystemVariable("WSCURRENT");
            switch (strCurrentWorkSpaceName)
            {
                case "APC Transmission":
                    cboDBList.SelectedValue = "PnEmbA21";
                    break;
                case "GPC Transmission":
                    cboDBList.SelectedValue = "PnEmbG21";
                    break;
                case "APC Distribution":
                    cboDBList.SelectedValue = "PnEmbD21";
                    break;
                case "AddsPlot":
                    cboDBList.SelectedValue = "PnEmbD21";
                    break;
                case "(UA) APC Transmission":
                    cboDBList.SelectedValue = "UnEmbA21";
                    break;
                case "(UA) GPC Transmission":
                    cboDBList.SelectedValue = "UnEmbG21";
                    break;
                case "(UA) APC Distribution":
                    cboDBList.SelectedValue = "UnEmbD21"; 
                    break;
                case "UA - AddsPlot":
                    cboDBList.SelectedValue = "UnEmbD21";  
                    break;
            }

            this._DBName = cboDBList.SelectedValue.ToString();
            this._DBDescription = cboDBList.Text;

        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            string strConn = string.Empty;
            DataTable dt = new DataTable();

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT oud.UserInt_ID, oud.NT_ID, oud.UserFullName, oud.UserDivision ");
            sbSQL.Append("FROM AddsDB.ObjUserData oud ");
            sbSQL.Append("WHERE oud.NT_ID  LIKE :ntID AND oud.UserDivision LIKE 'ROLE' ");

            //  Gets users ID and Password
            _DBCurrentUser = this.txtUserID.Text.ToUpper();
            _DBPwd = this.textBox1.Text;

            //  Checks if prefered DB is selected and updates it in XML if needed.
            if (chkboxSaveSettings.Checked== true)
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(@"C:\Div_Map\Common\AddsLookups.xml");
                string strNodePath = "AddsLookup/Preferences/*";

                XmlNodeList xNodes = doc.SelectNodes(strNodePath);
                foreach (XmlNode aNode in xNodes)
                {
                    switch (aNode.Name)
                    {
                        case "LoginDB":
                            aNode.InnerText = cboDBList.SelectedValue.ToString();
                            break;
                    }
                }
                doc.Save(@"C:\Div_Map\Common\AddsLookups.xml");
            }

            //  Formats selected Application ID and Password and decodes if needed.
            if (!String.IsNullOrEmpty(_DBCurrentUser) && !String.IsNullOrEmpty(_DBPwd))
            {
                switch(txtAppID.Text.Substring(0,5).ToLower())
                {
                    case "ace1:":
                        _AppID = Utilities.Decrypt(txtAppID.Text.Remove(0, 5));
                        break;
                    case "text:":
                        _AppID = txtAppID.Text.Remove(0, 5);
                        break;
                    default:
                        _AppID = txtAppID.Text;
                        break;
                }

                switch (txtAppPwd.Text.Substring(0, 5).ToLower())
                {
                    case "ace1:":
                        _AppPwd = Utilities.Decrypt(txtAppPwd.Text.Remove(0, 5));
                        break;
                    case "text:":
                        _AppPwd = txtAppPwd.Text.Remove(0, 5);
                        break;
                    default:
                        _AppPwd = txtAppPwd.Text;
                        break;
                }

                //  Checks if selected DB is valid or online
                strConn = "Data Source=" + _DBName + ";User ID=" + _AppID + ";Password=" + _AppPwd + ";Pooling=false;";

                OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strConn);
                try
                {
                    oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String
                    _DBConnStatus = 1;

                    //  Checks if User has been setup in security for ADDS and the DB
                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    oracleCommand.Parameters.Add("ntID", OracleDb.OracleDbType.Varchar2, 8).Value = _DBCurrentUser;

                    OracleDb.OracleDataAdapter oda = new OracleDb.OracleDataAdapter(oracleCommand);
                    oda.Fill(dt);

                    if (dt.Rows.Count < 1)
                    {
                        throw new ArithmeticException("Access denied \n  - You are not an authorized user");
                    }
                }
                catch (Exception ex)
                {
                    _DBConnStatus = 0;
                    MessageBox.Show("Login Database error Cannot connect to : "  + _DBName + "\n\n" + ex.ToString(), "ADDS.DLL - Login");
                    Utilities.EndACAD();
                }
                finally
                {
                    oracleConn.Close();
                }

                

                //  Set Public Properties of form
                DBName = _DBName;
                DBDescription = _DBDescription;
                DBPwd = _DBPwd;

                _DBRole = GetRoleStatement();

                AppID = _AppID;
                AppPwd = _AppPwd;
            }
            else
            {
                MessageBox.Show("UserID and/or Password cannot be blank", "ADDS Login error");
            }
        }

        private void cboDBList_SelectedIndexChanged(object sender, EventArgs e)
        {
            this._DBName = cboDBList.SelectedValue.ToString();
            this._DBDescription = cboDBList.Text;

            DataRowView cRow = bsLoggins.Current as DataRowView;
            _AppPwd = cRow.Row["AppPwd"].ToString();

        }

        private void frmLogin_Load(object sender, EventArgs e)
        {
            bsLoggins = new BindingSource();

            PopulateDB();
            _DBCurrentUser = WindowsIdentity.GetCurrent().Name.ToString().Split('\\')[1].ToUpper();
            this.txtUserID.Text = _DBCurrentUser;

            this.txtAppID.DataBindings.Add("Text", bsLoggins, "AppId");
            this.txtAppPwd.DataBindings.Add("Text", bsLoggins, "AppPwd");

            ToolTip ttp = new ToolTip();

            ttp.SetToolTip(this.chkboxSaveSettings, "Check to set the selected database above as your default database");
            ttp.SetToolTip(this.txtUserID, "Enter your NTID");
            ttp.SetToolTip(this.cboDBList, "Select which database to log into");
            ttp.SetToolTip(this.textBox1, "Enter your computer login password");
            ttp.SetToolTip(this.btnOk, "To login to ADDS");
            ttp.SetToolTip(this.btnCancel, "To Exit ADDS");
        }

        private string GetRoleStatement()
        {
            string strRoleStatement = string.Empty;
            string strRoleName = string.Empty;
            string strSecLevel = string.Empty;
            string strConn = string.Empty;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT oud.UserFullName AS role_name ");
            sbSQL.Append("FROM AddsDb.ObjUserData oud ");
            sbSQL.Append("WHERE UPPER(oud.nt_id) = :Cuser AND UPPER(oud.UserDivision) = 'ROLE' ");

            try
            {
                strConn = "Data Source=" + _DBName + ";User ID=" + _AppID + ";Password=" + _AppPwd + ";Pooling=false;";
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strConn))
                {
                    OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand(sbSQL.ToString(), oracleConn);
                    oracleCommand.Parameters.Add("Cuser", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = _DBCurrentUser;

                    DataTable dt = new DataTable();
                    OracleDb.OracleDataAdapter oda = new OracleDb.OracleDataAdapter(oracleCommand);
                    oda.Fill(dt);

                    //strRoleStatement = "Set role ";
                    foreach (DataRow oRow in dt.Rows)
                    {
                        //strSecLevel = oRow["appl_sec_level_id"].ToString();
                        strRoleName = oRow["role_name"].ToString();
                        switch (strRoleName)
                        {
                            case "EMBADDSADM_ROLE":
                                strRoleStatement += strRoleName + " identified by adds1adm, ";
                                break;
                            case "EMBADDSUSR_ROLE":
                                strRoleStatement += strRoleName + " identified by adds2usr, ";
                                break;
                            default:
                                strRoleStatement += strRoleName + ", ";
                                break;
                        }
                    }
                    strRoleStatement = strRoleStatement.Trim().TrimEnd(',');
                    _DBDescription = strSecLevel;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return strRoleStatement;
        }

        private void cboDBList_SelectionChangeCommitted(object sender, EventArgs e)
        {
            DataRowView cRow = bsLoggins.Current as DataRowView;
            _AppPwd = cRow.Row["AppPwd"].ToString();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            Utilities.EndACAD();
        }
    }
}
