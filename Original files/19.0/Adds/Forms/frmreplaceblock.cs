using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using OracleDb = Oracle.DataAccess.Client;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;
using AcadColor = Autodesk.AutoCAD.Colors;


namespace Adds.Forms
{
    public partial class frmReplaceBlock : Form
    {
        private string _existingBlockName = string.Empty;

        private string _BlockName = string.Empty;
        public string BlockName
        {
            get { return _BlockName; }
            set { _BlockName = value; }
        }

        public frmReplaceBlock(string existingBlockName)
        {
            InitializeComponent();
            _existingBlockName = existingBlockName;
            txtBlockName.Text = existingBlockName;
            PopulateNewBlockChoices();
        }

        private void PopulateNewBlockChoices()
        {   
            DataTable dtResults = null;
            
            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            string strDiv = alResults[0].ToString();
                
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT ls.adds_blk_nam, ls.adds_symbol_desc || ' - ' || ls.adds_blk_nam as adds_symbol_desc ");
            sbSQL.Append("FROM AddsDb.Lu_Symbols ls, ");
            sbSQL.Append("  (SELECT ls.emb_class, ls.emb_subclass, ls.emb_state  FROM AddsDb.Lu_Symbols ls WHERE ls.adds_blk_nam LIKE '" + _existingBlockName + "') oldbk ");
            //if (strDiv.ToUpper() == "GA")
            //{
            //    sbSQL.Append("WHERE ls.adds_blk_nam LIKE 'A9%' ");
            //}
            //else
            //{
            //    sbSQL.Append("WHERE REGEXP_LIKE (ls.adds_blk_nam, '^A[0|1|2].*$') ");
            //}

            switch (strDiv.ToUpper())
            {
                case "AL":
                    sbSQL.Append("WHERE ls.adds_blk_nam LIKE 'A8%' ");
                    break;
                case "GA":
                    sbSQL.Append("WHERE ls.adds_blk_nam LIKE 'A9%' ");
                    break;
                default:
                    sbSQL.Append("WHERE REGEXP_LIKE (ls.adds_blk_nam, '^A[0|1|2].*$') ");
                    break;
            }

            sbSQL.Append("  AND ls.emb_state IN ");
            sbSQL.Append("      (SELECT  vs.equip_state_cod  ");
            sbSQL.Append("       FROM TMap.Valid_States vs ");
            sbSQL.Append("       WHERE vs.equip_class_cod = oldbk.emb_class AND vs.equip_subclass_cod = oldbk.emb_subclass) ");
            sbSQL.Append("ORDER BY ls.adds_symbol_desc ");

            try
            {
                dtResults = Utilities.GetResults(sbSQL, Adds._strConn);         // [CHECKED] Oracle 12.c - Connection String

                cboNewBlock.DataSource = dtResults;
                cboNewBlock.DisplayMember = "adds_symbol_desc";
                cboNewBlock.ValueMember = "adds_blk_nam";
                cboNewBlock.SelectedValue = _existingBlockName;
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            BlockName = _BlockName;
        }

        private void cboNewBlock_SelectedIndexChanged(object sender, EventArgs e)
        {
            _BlockName = cboNewBlock.SelectedValue.ToString();
        }
    }
}
