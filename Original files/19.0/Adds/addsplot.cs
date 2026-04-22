using System.Collections;
using System.Data;
//using System.Data.OracleClient;
using System.Text;
using System.Windows.Forms;

using OracleDb = Oracle.DataAccess.Client;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;

namespace Adds
{
    public partial class Adds
    {
        #region *** Module Constants and Variables *** 

        private const string APP_NAME = "AddsPlot";
        private const string PLOTDEF_SELECT_SQL =
            "Select Distinct pd.PLDNAME, NVL(pd.cordfile, ' ') AS CordFile, NVL(pd.cordkey, ' ') AS CordKey, " +
                "NVL(plca.custname, ' ') AS Cust1, NVL(plcb.custname, ' ') AS Cust2, " +
                "pd.x_l, pd.y_l, pd.x_u, pd.y_u, pd.buffer, NVL(pd.sheet, ' ') AS Sht, " +
                "pd.pltsc, pd.symsc, pd.txtsc, " +
                "NVL(pd.vlt,' ') AS Vlt, NVL(pd.job_nam,' ') AS JobNam, NVL(pd.detail,' ') AS Detail, " +
                "pd.description, " +
                "NVL(pd.defined_by_id,' ') AS Def_By, to_char(pd.defined_dtm,'YYYY-MM-DD HH24:MI:SS') As Def_DTM, " +
                "NVL(pd.dwg_num, ' ') AS DwgNum, pg.sht_num, pg.num_shts, " +
                "NVL(pd.mtch_to_lft, ' ') AS MtchLft, NVL(pd.mtch_to_top, ' ') AS MtchTop, " +
                "NVL(pd.mtch_to_rgt, ' ') AS MtchRgt, NVL(pd.mtch_to_btm, ' ') AS Mtchbtm  ";

        #endregion

        #region *** Public Functions calls - Used in AutoCAD Lisp code ***

        [Acad.LispFunction("DisplayPlotCustomsForm")]
        public void DisplayPlotCustomsForm(AcadDB.ResultBuffer args)
        {
            Forms.frmPlotCustoms ofrmPlotCustoms = new Forms.frmPlotCustoms();
            AcadAS.Application.ShowModalDialog(ofrmPlotCustoms);
        }

        [Acad.LispFunction("DisplayPlotDef")]
        public void DisplayPlotDef(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            string strDivision = alInputParameters[0].ToString();
            string strPlotDef = string.Empty;
            if (alInputParameters.Count > 1)
            {
                strPlotDef = alInputParameters[1].ToString();
            }

            Forms.frmPlot ofrmPlot = new Forms.frmPlot(strDivision, strPlotDef);
            AcadAS.Application.ShowModalDialog(null, ofrmPlot, false);
        }

        [Acad.LispFunction("DisplayPlotDefMain")]
        public void DisplayPlotDefMain(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            string strDivision = alInputParameters[0].ToString();

            Forms.frmPlotDefMain ofrmPlotDefMain = new Forms.frmPlotDefMain(strDivision);
            AcadAS.Application.ShowModalDialog(null, ofrmPlotDefMain, false);
        }

        [Acad.LispFunction("DisplayPlotGroupDef")]
        public void DisplayPlotGroupDef(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            string strDivision = alInputParameters[0].ToString();

            Forms.frmPlotGroupDef ofrmPlotGroupDef = new Forms.frmPlotGroupDef(strDivision, string.Empty);
            AcadAS.Application.ShowModalDialog(null, ofrmPlotGroupDef, false);
        }

        [Acad.LispFunction("GetPlotDefByPlotName")]
        public AcadDB.ResultBuffer GetPlotDefByPlotName(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = ProcessInputParameters(args);
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            DataTable dtResults = null;

            try
            {
                string strPlotName = alInputParameters[0].ToString();
                string strDivision = alInputParameters[1].ToString();

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT DISTINCT pd.PLDNAME, '" + _strConn.Substring(12, _strConn.IndexOf(";") - 12) + "' AS DBName, pd.DivNam, pd.PLDNAME,  ");
                sbSQL.Append("  NVL(plga.PldGroup,' ') As Grp1, NVL(plgb.PldGroup,' ') As Grp2, NVL(plca.CustName,' ') As Cust1, NVL(plcb.CustName,' ') As Cust2, ");
                sbSQL.Append("  NVL(pd.cordfile, ' ') AS CordFile, NVL(pd.cordkey, ' ') AS CordKey, ");
                sbSQL.Append("  pd.x_l, pd.y_l, pd.x_u, pd.y_u, pd.buffer, NVL(pd.sheet, ' ') AS Sht, ");
                sbSQL.Append("  pd.pltsc, pd.symsc, pd.txtsc, ");
                sbSQL.Append("  NVL(pd.vlt,' ') AS Vlt, NVL(pd.job_nam,' ') AS JobNam, NVL(pd.detail,' ') AS Detail, pd.description, ");
                sbSQL.Append("  NVL(pd.defined_by_id,' ') AS Def_By, to_char(pd.defined_dtm,'YYYY-MM-DD HH24:MI:SS') As Def_DTM, ");
                sbSQL.Append("  NVL(pd.dwg_num, ' ') AS DwgNum, pg.sht_num, '1' AS num_shts, ");
                sbSQL.Append("  NVL(pd.mtch_to_lft, ' ') AS MtchLft, NVL(pd.mtch_to_top, ' ') AS MtchTop, ");
                sbSQL.Append("  NVL(pd.mtch_to_rgt, ' ') AS MtchRgt, NVL(pd.mtch_to_btm, ' ') AS Mtchbtm ");

                sbSQL.Append("FROM AddsDB.PlotGroup pg, AddsDB.PlotDef pd, ");
                sbSQL.Append("(SELECT plc1.pldname, plc1.custname FROM addsdb.plotcustom plc1 WHERE plc1.custorder = 1) plca,  ");
                sbSQL.Append("(SELECT plc2.pldname, plc2.custname FROM addsdb.plotcustom plc2 WHERE plc2.custorder = 2) plcb, ");
                sbSQL.Append("(SELECT plg1.pldname, plg1.pldgroup, plg1.grporder FROM addsdb.plotgroup plg1 where plg1.grporder = 1) plga, ");
                sbSQL.Append("(SELECT plg2.pldname, plg2.pldgroup, plg2.grporder FROM addsdb.plotgroup plg2 where plg2.grporder = 2) plgb ");

                sbSQL.Append("WHERE UPPER(pd.pldname) = '" + strPlotName.ToUpper() + "' ");
                sbSQL.Append("AND pd.pldname = pg.pldname(+) ");
                sbSQL.Append("AND pd.pldname = plca.pldname(+) AND pd.pldname = plcb.pldname(+) ");
                sbSQL.Append("AND pd.pldname = plga.pldname(+) AND pd.pldname = plgb.pldname(+) ");

                dtResults = Utilities.GetResults(sbSQL, _strConn);          // [CHECKED] Oracle 12.c - Connection String

                if (dtResults.Rows.Count > 0)
                {
                    resultBuffer = Utilities.BuildList(dtResults);
                }
                else
                {
                    MessageBox.Show("Plot Definition not found.");
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {

            }
            return resultBuffer;
        }

        /// <summary>
        /// Called by RunPld.lsp!RunPld2 
        /// </summary>
        /// <param name="args"></param>
        /// <returns>Nested List of AddsPlot Definitions</returns>
        [Acad.LispFunction("GetPlotDefByPlotGroup")]
        public AcadDB.ResultBuffer GetPlotDefsByPlotGroup(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            try
            {
                string strOrcaleConn = _strConn;  //BuildConnectionString((ArrayList)alInputParameters[0]);      //  first parameter - Logon information list.
                string strDivision = alInputParameters[1].ToString();
                string strPlotGroup = alInputParameters[2].ToString();

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append(PLOTDEF_SELECT_SQL);

                sbSQL.Append("FROM AddsDB.PlotGroup pg, AddsDB.PlotDef pd, ");
                sbSQL.Append("(SELECT plc1.pldname, plc1.custname FROM addsdb.plotcustom plc1 WHERE plc1.custorder = 1) plca,  ");
                sbSQL.Append("(SELECT plc2.pldname, plc2.custname FROM addsdb.plotcustom plc2 WHERE plc2.custorder = 2) plcb ");

                sbSQL.Append("WHERE UPPER(pg.pldgroup) = '" + strPlotGroup.ToUpper() + "' ");
                sbSQL.Append("AND pg.pldname = pd.pldname ");
                sbSQL.Append("AND pd.pldname = plca.pldname(+) AND pd.pldname = plcb.pldname(+)");

                sbSQL.Append("ORDER BY pg.Sht_num ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (odReader.Read())
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        // AddsPlot-AutoLISP is expecting all values to be a string type in the returned list.
                        for (int index = 0; index < odReader.FieldCount; index++)
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(index).ToString()));
                        }

                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    odReader.Close();
                }
            }
            catch (OracleDb.OracleException oException)
            {
                MessageBox.Show(oException.ToString(), "Oracle Exception");
            }
            catch (Acad.Exception acadException)
            {
                MessageBox.Show(acadException.ToString(), "AutoCAD Exception");
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return resultBuffer;
        }

        /// <summary>
        /// Called by RunPld.lsp!RunPld2
        /// Returns a nested list of plot definitions for the division based panels have been changed per date(s) range. 
        /// </summary>
        /// <param name="args">MyUsrInfo(Orcale Login information based on user), Division Code</param>
        /// <returns>Nested List of AddsPlot Definitions</returns>
        [Acad.LispFunction("GetPlotsDefsByPanelDate")]
        public AcadDB.ResultBuffer GetPlotsDefsByPanelDate(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            try
            {
                string strDivision = alInputParameters[1].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[0]);      //  first parameter - Logon information list.

                //  Get start & end dates for SQL statement.
                ChangesDialog oChangesDialog = new ChangesDialog
                {

                    //  Set start up position of Dialog box to center of AutoCAD window to avoid never never land 
                    //  with dual monitor then switching to a signal monitor computer
                    StartPosition = FormStartPosition.CenterParent
                };

                //  Makes AutoCAD owns the form not Windows, notice icon on form
                //  This signature of ShowModalDialog is need to override reg last location display position 
                //  in this case the regedit location is at HKCU\Software\Autodesk\AutoCAD17.0\Acad-5002:409\Profiles\AddsPlot\Diaglogs\Adds.ChangesDialog Bounds key
                //AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow,oChangesDialog, false);
                AcadAS.Application.ShowModalDialog(null, oChangesDialog, false);

                string strDateStart = oChangesDialog.strDateStart;
                string strDateEnd = oChangesDialog.strDateEnd;

                if (strDateEnd == strDateStart)
                {
                    strDateEnd = string.Empty;
                }

                StringBuilder sbSQL = new StringBuilder();

                sbSQL.Append(PLOTDEF_SELECT_SQL);

                sbSQL.Append("FROM ADDSDB.PLOTDEF pd, ADDSDB.PLOTGROUP pg, ");
                sbSQL.Append("(SELECT plc1.pldname, plc1.custname FROM addsdb.plotcustom plc1 WHERE plc1.custorder = 1) plca, ");
                sbSQL.Append("(SELECT plc2.pldname, plc2.custname FROM addsdb.plotcustom plc2 WHERE plc2.custorder = 2) plcb, ");
                sbSQL.Append("(SELECT DISTINCT PanelNam, SUBSTR(pcl.panelnam, 0, 3) * 1000 AS PanelX, ");
                sbSQL.Append("SUBSTR(pcl.panelnam, 4) * 1000 AS PanelY ");
                sbSQL.Append("FROM AddsDB.PanelChgLog pcl ");
                sbSQL.Append("WHERE pcl.loaded_dtm >= TO_DATE('" + strDateStart + "', 'MM/DD/YYYY') ");
                if (strDateEnd != string.Empty)
                {
                    sbSQL.Append("AND pcl.loaded_dtm < TO_DATE('" + strDateEnd + "', 'MM/DD/YYYY') ");
                }
                sbSQL.Append("AND REGEXP_LIKE( pcl.panelnam, '[0-9]{7}')) panels ");
                sbSQL.Append("WHERE UPPER(pd.divnam) = '" + strDivision + "' ");
                sbSQL.Append("AND pd.PLDNAME = pg.PLDNAME ");
                sbSQL.Append("AND UPPER(pg.PLDGROUP) LIKE 'DIV" + strDivision + "%' ");
                sbSQL.Append("AND REGEXP_LIKE (UPPER(pd.pldname), '^[0D]') ");
                sbSQL.Append("AND pd.pldname = plca.pldname(+) AND pd.pldname = plcb.pldname(+) ");

                sbSQL.Append("AND ( ");
                sbSQL.Append("   ((X_L >= panels.PanelX AND X_L <= panels.PanelX + 6000)        AND (Y_L >= panels.PanelY AND Y_L <= panels.PanelY + 4000)) ");
                sbSQL.Append("OR ((X_U >= panels.PanelX AND X_U <= panels.PanelX + 6000)        AND (Y_U >= panels.PanelY AND Y_U <= panels.PanelY + 4000)) ");
                sbSQL.Append("OR ((X_L <= panels.PanelX AND X_U >= panels.PanelX)               AND (Y_L <= panels.PanelY + 4000 AND Y_U >= panels.PanelY + 4000)) ");
                sbSQL.Append("OR ((X_L <= panels.PanelX + 6000 AND X_U >= panels.PanelX + 6000) AND (Y_L <= panels.PanelY AND Y_U >= panels.PanelY)) ");
                sbSQL.Append("OR ((X_L <= panels.PanelX AND X_U >= panels.PanelX + 6000)        AND (Y_L <= panels.PanelY AND Y_U >= panels.PanelY + 4000)) ");
                sbSQL.Append("OR ((X_L <= panels.PanelX AND X_U >= panels.PanelX)               AND (Y_L >= panels.PanelY AND Y_U <= panels.PanelY + 4000)) ");
                sbSQL.Append("OR ((X_L >= panels.PanelX AND X_U <= panels.PanelX + 6000)        AND (Y_L <= panels.PanelY AND Y_U >= panels.PanelY)) ");
                sbSQL.Append(") ");

                //sbSQL.Append("UNION ");
                //sbSQL.Append(PLOTDEF_SELECT_SQL);
                //sbSQL.Append("FROM AddsDB.PlotGroup pg, AddsDB.PlotDef pd, ");
                //sbSQL.Append("(SELECT plc1.pldname, plc1.custname FROM addsdb.plotcustom plc1 WHERE plc1.custorder = 1) plca,  ");
                //sbSQL.Append("(SELECT plc2.pldname, plc2.custname FROM addsdb.plotcustom plc2 WHERE plc2.custorder = 2) plcb ");
                //sbSQL.Append("WHERE (pd.pldname IN ");
                //sbSQL.Append("(SELECT LPAD (pcl.panelnam, 8, '9') ");
                //sbSQL.Append("FROM AddsDB.PanelChgLog pcl ");
                //sbSQL.Append("WHERE pcl.loaded_dtm >= TO_DATE('" + strDateStart + "', 'MM/DD/YYYY') ");
                //if (strDateEnd != string.Empty)
                //{
                //    sbSQL.Append("AND pcl.loaded_dtm < TO_DATE('" + strDateEnd + "', 'MM/DD/YYYY') ");
                //}
                //sbSQL.Append("AND NOT REGEXP_LIKE( pcl.panelnam, '[0-9]{7}'))");
                //sbSQL.Append("AND pd.PLDNAME = pg.PLDNAME ");
                //sbSQL.Append("AND UPPER(pg.PLDGROUP) LIKE 'DIV" + strDivision + "%' ");
                //sbSQL.Append("AND pd.pldname = plca.pldname(+) AND pd.pldname = plcb.pldname(+)) ");


                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataAdapter oracleDataAdapter = new OracleDb.OracleDataAdapter(oracleCommand);
                    DataSet ds = new DataSet();
                    ds.Tables.Add("dtResults");
                    oracleDataAdapter.Fill(ds, "dtResults");

                    oracleConn.Close();

                    int intPlotDefCount = ds.Tables["dtResults"].Rows.Count;

                    if (intPlotDefCount == 0)
                    {
                        AcadAS.Application.ShowAlertDialog("There are no changes to plots for the date(s) you selected.");
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    else if (intPlotDefCount < 501)         // was 351 before memory cleanup in AddsPlot
                    {
                        foreach (DataRow oRow in ds.Tables["dtResults"].Rows)
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            foreach (DataColumn dc in ds.Tables["dtResults"].Columns)
                            {
                                resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[dc].ToString()));
                            }
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                    }
                    else
                    {
                        AcadAS.Application.ShowAlertDialog("The date range you selected has resulted in too many plots " + intPlotDefCount.ToString() + "\n for AutoCAD to run without crashing." +
                            "  Please narrow your date range and try again.");
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                }
            }
            catch (OracleDb.OracleException oException)
            {
                MessageBox.Show(oException.ToString(), "Oracle Exception");
            }
            catch (Acad.Exception acadException)
            {
                MessageBox.Show(acadException.ToString(), "AutoCAD Exception");
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return resultBuffer;
        }

        #endregion

        #region ****  internal/Private ***

        internal static void AddPlotDef(Plot plotItem)
        {
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("INSERT INTO AddsDB.PlotDef ");
            sbSQL.Append("(PLDNAME, DIVNAM, CORDFILE, CORDKEY, X_L, Y_L, X_U, Y_U,  ");
            sbSQL.Append("BUFFER, SHEET, PLTSC, SYMSC, TXTSC, VLT, JOB_NAM, DETAIL,  ");
            sbSQL.Append("DWG_NUM, MTCH_TO_LFT, MTCH_TO_TOP, MTCH_TO_RGT, MTCH_TO_BTM,  ");
            sbSQL.Append("DESCRIPTION, DEFINED_BY_ID) ");
            sbSQL.Append("VALUES ");
            sbSQL.Append("(:pldName, :divName, :cordFile, :cordKey, :xL, :yL, :xU, :yU, ");
            sbSQL.Append(":buffer, :sheet, :pLTSC, :symbolScale, :textScale,:voltageCode, :jobName, :detail, ");
            sbSQL.Append(":drgNum, :matchToLeft, :matchToTop, :matchToRight, :matchToBottom, ");
            sbSQL.Append(":descr, :identityName) ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            try
            {
                oracleConn.Open();
                oracleConn.ClientInfo = Adds._strUserID;
                oracleCommand.CommandText = sbSQL.ToString();

                oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = plotItem.PldName ?? null;
                oracleCommand.Parameters.Add("divName", OracleDb.OracleDbType.Varchar2).Value = plotItem.DivName.LimitString(2) ?? null;
                oracleCommand.Parameters.Add("cordFile", OracleDb.OracleDbType.Varchar2).Value = plotItem.CordFileType ?? null;
                oracleCommand.Parameters.Add("cordKey", OracleDb.OracleDbType.Varchar2).Value = plotItem.CordKey ?? null;
                oracleCommand.Parameters.Add("xL", OracleDb.OracleDbType.Int32).Value = plotItem.XL ?? 0;
                oracleCommand.Parameters.Add("yL", OracleDb.OracleDbType.Int32).Value = plotItem.YL ?? 0;
                oracleCommand.Parameters.Add("xU", OracleDb.OracleDbType.Int32).Value = plotItem.XU ?? 0;
                oracleCommand.Parameters.Add("yU", OracleDb.OracleDbType.Int32).Value = plotItem.YU ?? 0;

                oracleCommand.Parameters.Add("buffer", OracleDb.OracleDbType.Int32).Value = plotItem.Buffer ?? 0;
                oracleCommand.Parameters.Add("sheet", OracleDb.OracleDbType.Varchar2).Value = plotItem.Sheet ?? null;
                oracleCommand.Parameters.Add("pLTSC", OracleDb.OracleDbType.Int32).Value = plotItem.PlotScale ?? 0;
                oracleCommand.Parameters.Add("symbolScale", OracleDb.OracleDbType.Int32).Value = plotItem.SymbolScale ?? 0;
                oracleCommand.Parameters.Add("textScale", OracleDb.OracleDbType.Int32).Value = plotItem.TextScale ?? 0;
                oracleCommand.Parameters.Add("voltageCode", OracleDb.OracleDbType.Varchar2).Value = plotItem.VoltageCode ?? null;
                oracleCommand.Parameters.Add("jobName", OracleDb.OracleDbType.Varchar2).Value = plotItem.JobName.LimitString(36) ?? null;
                oracleCommand.Parameters.Add("detail", OracleDb.OracleDbType.Varchar2).Value = plotItem.Detail ?? null;

                oracleCommand.Parameters.Add("drgNum", OracleDb.OracleDbType.Varchar2).Value = plotItem.DrawingNumber ?? null;
                oracleCommand.Parameters.Add("matchToLeft", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToLeft ?? null;
                oracleCommand.Parameters.Add("matchToTop", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToTop ?? null;
                oracleCommand.Parameters.Add("matchToRight", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToRight ?? null;
                oracleCommand.Parameters.Add("matchToBottom", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToBottom ?? null;

                oracleCommand.Parameters.Add("descr", OracleDb.OracleDbType.Varchar2).Value = plotItem.Description ?? null;
                oracleCommand.Parameters.Add("identityName", OracleDb.OracleDbType.Varchar2).Value = "CETAYLOR";

                oracleCommand.ExecuteNonQuery();

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
        }

        internal static int AddPlotGroup(DataTable dtNewPlotGroup)
        {
            int iRowsAffected = 0;

            StringBuilder sbSQLInsert = new StringBuilder();
            sbSQLInsert.Append("INSERT INTO AddsDB.PlotGroup ");
            sbSQLInsert.Append("(PldName, PldGroup, Sht_Num, Num_Shts) ");
            sbSQLInsert.Append("VALUES (:pldName, :pldGroup, :shtNum, :numSht)");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            try
            {
                oracleConn.Open();
                oracleConn.ClientInfo = Adds._strUserID;

                oracleCommand.CommandText = sbSQLInsert.ToString();

                foreach (DataRow oRow in dtNewPlotGroup.Rows)
                {
                    oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = oRow["PldName"].ToString().LimitString(20) ?? null;
                    oracleCommand.Parameters.Add("pldGroup", OracleDb.OracleDbType.Varchar2).Value = oRow["PldGroup"].ToString().LimitString(20) ?? null;
                    oracleCommand.Parameters.Add("shtNum", OracleDb.OracleDbType.Varchar2).Value = oRow["Sht_Num"].ToString().LimitString(3) ?? null;
                    oracleCommand.Parameters.Add("numSht", OracleDb.OracleDbType.Varchar2).Value = oRow["Num_Shts"].ToString().LimitString(3) ?? null;

                    iRowsAffected = iRowsAffected + oracleCommand.ExecuteNonQuery();

                    oracleCommand.Parameters.Clear();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Close();
                oracleConn.Dispose();
            }
            return iRowsAffected;
        }

        internal static int AddUpdatePlotDefCustoms(string strPldName, DataTable dtNewCustoms)
        {
            int iRowsAffected = 0;

            //  Setup Orcale Connection and generic Oracle Command
            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            //  Deletion Code
            StringBuilder sbSQLDelete = new StringBuilder();
            sbSQLDelete.Append("DELETE FROM AddsDB.PlotCustom WHERE PLDNAME = :pldName ");

            try
            {
                oracleConn.Open();
                oracleConn.ClientInfo = Adds._strUserID;
                oracleCommand.CommandText = sbSQLDelete.ToString();

                //  Get Plots to delete
                if (dtNewCustoms.Rows.Count > 0)
                {
                    DataView dvDistinctPlotNames = new DataView(dtNewCustoms);
                    DataTable dtDistinctPlotNames = dvDistinctPlotNames.ToTable(true, "PldName");
                    foreach (DataRow oRow in dtDistinctPlotNames.Rows)
                    {
                        oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = oRow["PldName"].ToString() ?? null;
                        iRowsAffected = oracleCommand.ExecuteNonQuery();

                        oracleCommand.Parameters.Clear();
                    }
                }
                else if (strPldName != null)    //  For a Plot Def with no customs or delete all customs with the Plot Def
                {
                    oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = strPldName ?? null;
                    iRowsAffected = oracleCommand.ExecuteNonQuery();

                    oracleCommand.Parameters.Clear();
                }

                //  Insertion code
                iRowsAffected = 0;
                int iCostumOrder = 0;
                StringBuilder sbSQLInsert = new StringBuilder();
                sbSQLInsert.Append("INSERT INTO AddsDB.PlotCustom  ");
                sbSQLInsert.Append("(pldname, custname, custorder)");
                sbSQLInsert.Append("VALUES (:pldName, :custName, :custOrder)");

                oracleCommand.CommandText = sbSQLInsert.ToString();
                foreach (DataRow oRow in dtNewCustoms.Rows)
                {
                    iCostumOrder ++ ;
                    oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = oRow["PldName"].ToString() ?? null;
                    oracleCommand.Parameters.Add("custName", OracleDb.OracleDbType.Varchar2).Value = oRow["CustName"].ToString() ?? null;
                    oracleCommand.Parameters.Add("custOrder", OracleDb.OracleDbType.Varchar2).Value = iCostumOrder;
                    iRowsAffected = iRowsAffected + oracleCommand.ExecuteNonQuery();

                    oracleCommand.Parameters.Clear();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
            return iRowsAffected;
        }

        internal static void DeletePlotDef(string strPldName)
        {
            int iRowsAffected;

            StringBuilder sbSQLDeleteCustoms = new StringBuilder();
            sbSQLDeleteCustoms.Append("DELETE FROM AddsDB.PlotCustom WHERE UPPER(PLDNAME) = :pldName ");

            StringBuilder sbSQLDeleteGroups = new StringBuilder();
            sbSQLDeleteGroups.Append("DELETE FROM AddsDB.PlotGroup WHERE UPPER(PLDNAME)  = :pldName ");

            StringBuilder sbSQLDeletePlotDef = new StringBuilder();
            sbSQLDeletePlotDef.Append("DELETE FROM AddsDB.PlotDef WHERE UPPER(PLDNAME)  = :pldName ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            try
            {
                oracleConn.Open();
                oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = strPldName.ToUpper() ?? null;

                oracleCommand.CommandText = sbSQLDeleteCustoms.ToString();
                iRowsAffected = oracleCommand.ExecuteNonQuery();

                oracleCommand.CommandText = sbSQLDeleteGroups.ToString();
                iRowsAffected = oracleCommand.ExecuteNonQuery();

                oracleCommand.CommandText = sbSQLDeletePlotDef.ToString();
                iRowsAffected = oracleCommand.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
        }

        internal static int DeletePlotGroup(string strGroup)
        {
            int iRowsAffected = 0;

            StringBuilder sbSQLDelete = new StringBuilder();
            sbSQLDelete.Append("DELETE FROM AddsDb.PlotGroup ");
            sbSQLDelete.Append("WHERE UPPER(PldGroup) = :pldName  ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            try
            {
                oracleConn.Open();

                oracleCommand.Parameters.Add("pldGroup", OracleDb.OracleDbType.Varchar2).Value = strGroup.ToUpper().LimitString(20) ?? null;

                oracleCommand.CommandText = sbSQLDelete.ToString();
                iRowsAffected = oracleCommand.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
            return iRowsAffected;
        }

        internal static OracleDb.OracleDataAdapter GetCustomsAll()
        {
            DataSet dsetOracle = new DataSet();
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT * ");
            sbSQL.Append("FROM AddsDB.Valid_PlotCustom vpc ");
            sbSQL.Append("ORDER BY 1 ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleDataAdapter odaCustoms = new OracleDb.OracleDataAdapter();
            OracleDb.OracleCommandBuilder ocb = new OracleDb.OracleCommandBuilder(odaCustoms);

            try
            {
                odaCustoms.SelectCommand = new OracleDb.OracleCommand(sbSQL.ToString(), oracleConn);
                oracleConn.Open();
                oracleConn.ClientInfo = Adds._strUserID;

                odaCustoms.InsertCommand = ocb.GetInsertCommand();
                odaCustoms.UpdateCommand = ocb.GetUpdateCommand();
                odaCustoms.DeleteCommand = ocb.GetDeleteCommand();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return odaCustoms;
        }

        internal static DataTable GetPlotDefCustoms(string strPlotDef)
        {
            DataTable dtCustoms = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT CASE WHEN PD.pldname IS NOT NULL THEN -1 ELSE 0 END AS Selected, vpc.* ");
            sbSQL.Append("FROM AddsDB.Valid_PlotCustom vpc,  ");
            sbSQL.Append("  (SELECT pc.* FROM AddsDb.PlotCustom pc ");
            sbSQL.Append("   WHERE pc.pldname = '" + strPlotDef + "') PD ");
            sbSQL.Append("WHERE vpc.custname = PD.custname(+) ");
            sbSQL.Append("ORDER BY 1, 2 ");

            try
            {
                dtCustoms = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtCustoms;
        }

        internal static DataTable GetPlotDefsByPlotGroup(string strGroup)
        {
            DataTable dtDefs = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT *, To_NUMBER(pg.Sht_Num) AS SortNum ");
            sbSQL.Append("FROM AddsDb.PlotGroup pg ");

            try
            {
                if (!string.IsNullOrEmpty(strGroup))
                {
                    sbSQL.Append("WHERE UPPER(pg.PldGroup) = '" + strGroup.ToUpper() + "' ");
                    sbSQL.Append("ORDER BY TO_NUMBER(pg.Sht_Num) ASC ");
                }
                else
                {
                    sbSQL.Append("ORDER BY UPPER(pg.PldGroup), UPPER(pg.PLDNAME), SortNum  ");
                }

                dtDefs = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtDefs;
        }

        internal static DataTable GetPlotExtents(string strCordFile, string strCoorKey)
        {
            DataTable dtExtents = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT AddsDb.Get_Extent_MinX('" + strCordFile.ToUpper() + "', '" + strCoorKey + "') as MIN_X, ");
            sbSQL.Append("       AddsDb.Get_Extent_MinY('" + strCordFile.ToUpper() + "', '" + strCoorKey + "') as MIN_Y, ");
            sbSQL.Append("       AddsDb.Get_Extent_MaxX('" + strCordFile.ToUpper() + "', '" + strCoorKey + "') as MAX_X,  ");
            sbSQL.Append("       AddsDb.Get_Extent_MaxY('" + strCordFile.ToUpper() + "', '" + strCoorKey + "') as MAX_Y   ");
            sbSQL.Append("FROM Dual ");

            try
            {
                dtExtents = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {

            }
            return dtExtents;
        }

        internal static DataTable GetPlotGroupNames()
        {
            DataTable dtGroupNames = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT DISTINCT pg.PldGroup ");
            sbSQL.Append("FROM AddsDb.PlotGroup pg ");
            sbSQL.Append("ORDER BY UPPER(pg.PldGroup) ");

            try
            {
                dtGroupNames = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtGroupNames;
        }

        internal static DataTable GetPlotGroupsByPlotDef(string strPlotDef)
        {
            DataTable dtGroups = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT * ");
            sbSQL.Append("FROM AddsDb.PlotGroup pg ");
            sbSQL.Append("WHERE UPPER(pg.PLDName) = '" + strPlotDef.ToUpper() + "' ");

            try
            {
                dtGroups = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return dtGroups;
        }

        internal static DataTable GetPlotGroupsByPlotDefCount(string strPlotDef)
        {
            DataTable dtGroups = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT pg.PldGroup, COUNT(*) AS PlotCount ");
            sbSQL.Append("FROM AddsDb.PlotGroup pg ");
            sbSQL.Append("WHERE pg.PldGroup IN ");
            sbSQL.Append("  (SELECT pg2.PldGroup ");
            sbSQL.Append("   FROM  AddsDb.PlotGroup pg2 ");
            sbSQL.Append("   WHERE UPPER(pg2.PldName) = '" + strPlotDef.ToUpper() + "') ");
            sbSQL.Append("GROUP BY pg.PldGroup ");
            sbSQL.Append("ORDER BY 1 ");

            try
            {
                dtGroups = Utilities.GetResults(sbSQL, _strConn);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtGroups;
        }

        internal static DataTable GetPlots(string strDivision)
        {
            DataTable dtPlots = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT DISTINCT pd.PLDNAME, pd.DESCRIPTION, pd.DIVNAM, INITCAP(pd.CORDFILE) AS CORDFILE , pd.CORDKEY, ");
            sbSQL.Append("      pd.X_L, pd.Y_L, pd.X_U, pd.Y_U, pd.BUFFER, pd.SHEET, pd.PLTSC, pd.SYMSC, ");
            sbSQL.Append("      pd.TXTSC, pd.VLT, pd.JOB_NAM, pd.DETAIL, pd.DWG_NUM, pd.DEFINED_BY_ID, pd.DEFINED_DTM, ");
            sbSQL.Append("      pd.MTCH_TO_LFT, pd.MTCH_TO_RGT, pd.MTCH_TO_TOP, pd.MTCH_TO_BTM ");
            sbSQL.Append("FROM AddsDb.PlotDef pd ");

            try
            {
                if (!string.IsNullOrEmpty(strDivision))
                {
                    sbSQL.Append("WHERE pd.DivNam = '" + strDivision + "' ");
                }
                sbSQL.Append("ORDER BY pd.PLDNAME ");

                dtPlots = Utilities.GetResults(sbSQL, _strConn);

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtPlots;
        }

        internal static void UpdateAddsDef(Plot plotItem)
        {
            int iRowsAffected;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("UPDATE AddsDB.PlotDef ");
            sbSQL.Append("SET DIVNAM = :divName, CORDFILE = :cordFile, CORDKEY = :cordKey, ");
            sbSQL.Append("    X_L = :xL, Y_L = :yL, X_U = :xU, Y_U = :yU, ");
            sbSQL.Append("    BUFFER = :buffer, SHEET = :sheet, PLTSC = :pLTSC, SYMSC = :symbolScale, TXTSC = :textScale, ");
            sbSQL.Append("    VLT = :voltageCode, JOB_NAM = :jobName, DETAIL = :detail, Dwg_Num = :dwgNum, ");
            sbSQL.Append("    MTCH_TO_LFT = :matchToLeft, MTCH_TO_TOP = :matchToTop, MTCH_TO_RGT = :matchToRight, MTCH_TO_BTM = :matchToBottom, ");
            sbSQL.Append("    DESCRIPTION = :descr ");
            sbSQL.Append("WHERE PLDNAME = :pldName ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            try
            {
                oracleConn.Open();
                oracleConn.ClientInfo = Adds._strUserID;
                oracleCommand.CommandText = sbSQL.ToString();

                oracleCommand.Parameters.Add("divName", OracleDb.OracleDbType.Varchar2).Value = plotItem.DivName.LimitString(2) ?? null;
                oracleCommand.Parameters.Add("cordFile", OracleDb.OracleDbType.Varchar2).Value = plotItem.CordFileType ?? null;
                oracleCommand.Parameters.Add("cordKey", OracleDb.OracleDbType.Varchar2).Value = plotItem.CordKey ?? null;
                oracleCommand.Parameters.Add("xL", OracleDb.OracleDbType.Int32).Value = plotItem.XL ?? 0;
                oracleCommand.Parameters.Add("yL", OracleDb.OracleDbType.Int32).Value = plotItem.YL ?? 0;
                oracleCommand.Parameters.Add("xU", OracleDb.OracleDbType.Int32).Value = plotItem.XU ?? 0;
                oracleCommand.Parameters.Add("yU", OracleDb.OracleDbType.Int32).Value = plotItem.YU ?? 0;

                oracleCommand.Parameters.Add("buffer", OracleDb.OracleDbType.Int32).Value = plotItem.Buffer ?? 0;
                oracleCommand.Parameters.Add("sheet", OracleDb.OracleDbType.Varchar2).Value = plotItem.Sheet ?? null;
                oracleCommand.Parameters.Add("pLTSC", OracleDb.OracleDbType.Int32).Value = plotItem.PlotScale ?? 0;
                oracleCommand.Parameters.Add("symbolScale", OracleDb.OracleDbType.Int32).Value = plotItem.SymbolScale ?? 0;
                oracleCommand.Parameters.Add("textScale", OracleDb.OracleDbType.Int32).Value = plotItem.TextScale ?? 0;
                oracleCommand.Parameters.Add("voltageCode", OracleDb.OracleDbType.Varchar2).Value = plotItem.VoltageCode ?? null;
                oracleCommand.Parameters.Add("jobName", OracleDb.OracleDbType.Varchar2).Value = plotItem.JobName.LimitString(36) ?? null;
                oracleCommand.Parameters.Add("detail", OracleDb.OracleDbType.Varchar2).Value = plotItem.Detail ?? null;

                oracleCommand.Parameters.Add("dwgNum", OracleDb.OracleDbType.Varchar2).Value = plotItem.DrawingNumber ?? null;
                oracleCommand.Parameters.Add("matchToLeft", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToLeft ?? null;
                oracleCommand.Parameters.Add("matchToTop", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToTop ?? null;
                oracleCommand.Parameters.Add("matchToRight", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToRight ?? null;
                oracleCommand.Parameters.Add("matchToBottom", OracleDb.OracleDbType.Varchar2).Value = plotItem.MatchToBottom ?? null;

                oracleCommand.Parameters.Add("descr", OracleDb.OracleDbType.Varchar2).Value = plotItem.Description ?? null;

                oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2).Value = plotItem.PldName.ToUpper() ?? null;

                iRowsAffected = oracleCommand.ExecuteNonQuery();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
        }

        internal static int UpdatedAddsDefOverides(Plot plotOverRides, DataTable dtPlots)
        {
            int iRowsAffected = 0;
            bool flagSomeThingToUpdate = false;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("UPDATE AddsDB.PlotDef ");
            sbSQL.Append("SET ");

            OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(_strConn);
            OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

            if (plotOverRides.Sheet != null)
            {
                sbSQL.Append("SHEET = :sheet");
                oracleCommand.Parameters.Add("sheet", OracleDb.OracleDbType.Varchar2).Value = plotOverRides.Sheet ?? null;
                flagSomeThingToUpdate = true;
            }
            if (plotOverRides.PlotScale != null)
            {
                if (flagSomeThingToUpdate) sbSQL.Append(", ");
                sbSQL.Append("PLTSC = :pLTSC");
                oracleCommand.Parameters.Add("pLTSC", OracleDb.OracleDbType.Int32).Value = plotOverRides.PlotScale ?? 0;
                flagSomeThingToUpdate = true;
            }
            if (plotOverRides.SymbolScale != null)
            {
                if (flagSomeThingToUpdate) sbSQL.Append(", ");
                sbSQL.Append("SYMSC = :symbolScale");
                oracleCommand.Parameters.Add("symbolScale", OracleDb.OracleDbType.Int32).Value = plotOverRides.SymbolScale ?? null;
                flagSomeThingToUpdate = true;
            }
            if (plotOverRides.SymbolScale != null)
            {
                if (flagSomeThingToUpdate) sbSQL.Append(", ");
                sbSQL.Append("TXTSC = :textScale ");
                oracleCommand.Parameters.Add("textScale", OracleDb.OracleDbType.Int32).Value = plotOverRides.TextScale ?? null;
                flagSomeThingToUpdate = true;
            }
            sbSQL.Append("WHERE PLDNAME = :pldName ");

            oracleCommand.CommandText = sbSQL.ToString();

            try
            {
                if (flagSomeThingToUpdate)
                {
                    oracleConn.Open();
                    oracleCommand.Parameters.Add("pldName", OracleDb.OracleDbType.Varchar2);

                    foreach (DataRow oRow in dtPlots.Rows)
                    {
                        oracleCommand.Parameters["pldName"].Value = oRow["PLDNAME"].ToString().LimitString(20);
                        iRowsAffected = iRowsAffected + oracleCommand.ExecuteNonQuery();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                oracleCommand.Dispose();
                oracleConn.Dispose();
            }
            return iRowsAffected;
        }

        #endregion
    }   
}
