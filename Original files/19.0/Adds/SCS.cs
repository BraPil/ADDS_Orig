using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data;
using System.Windows.Forms;
using System.IO;

using Microsoft.Win32;

using OracleDb = Oracle.DataAccess.Client;   //  Not installed in the new Windows 7 image

using CoolWindows = Com.SouthernCompany.Cool.Windows;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadASA = Autodesk.AutoCAD.ApplicationServices.Application;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;
using AcadWin = Autodesk.AutoCAD.Windows;
using AcadColor = Autodesk.AutoCAD.Colors;
using AcadPS = Autodesk.AutoCAD.PlottingServices;

namespace Adds
{
    public partial class SCS
    {
        static internal string strDeveId = null;
            
        static internal string g_strApplName = null;
        static internal bool g_flgAcadIsBusy = false;

        #region **** Public - AutoCAD Commands ****k

        [Acad.LispFunction("DisplaySplash_2012")]
        public void DisplaySplash(AcadDB.ResultBuffer args)
        {
            g_strApplName = null;
            if (args != null)
            {
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                g_strApplName = alInputParameters[0].ToString();
            }


            frmAcadSplash ofrmSplash = new frmAcadSplash(g_strApplName);
            ofrmSplash.StartPosition = FormStartPosition.CenterScreen;
            ofrmSplash.TopMost = true;

            // ofrmSplash.Show();  AcadAS.Application.MainWindow
            AcadAS.Application.ShowModalDialog(null, ofrmSplash, false);
        }

        [Acad.LispFunction("MyGetPanData_2012")]
        public Int32 GetCurOraData(AcadDB.ResultBuffer args)
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            ed.WriteMessage("\n *** GetCurOraData Started at " + DateTime.Now.ToLongTimeString());

            AcadDB.ResultBuffer rbResults;
            string strOracleConn = Adds._strConn;
            string strPanID = null;
            Int32 intCount = 0;
            decimal decPanID;

            StringBuilder sbSQL007 = new StringBuilder();   // Info from AddsDB.ObjMstDev table
            sbSQL007.Append("SELECT omd.device_id, to_char(omd.edit_dtm,'MM-DD-YYYY HH24:MI:SS'), omd.status_flag, omd.adds_panel_id ");
            sbSQL007.Append("FROM addsdb.objmstdev omd ");
            sbSQL007.Append("WHERE omd.adds_panel_id = :panID");

            StringBuilder sbSQL006 = new StringBuilder();   // Info from AddsDB.ObjRgApp table
            sbSQL006.Append("SELECT orp.device_id, orp.xdtname, orp.xdtvalue ");
            sbSQL006.Append("FROM addsdb.objrgapp orp ");
            sbSQL006.Append("WHERE orp.device_id in (select omd.device_id from addsdb.objmstdev omd ");
            sbSQL006.Append("WHERE omd.adds_panel_id = :panID) ");

            StringBuilder sbSQL004 = new StringBuilder();   // Info from AddsDB.ObjBlk table
            sbSQL004.Append("SELECT obk.adds_blk_nam, obk.blkhandle, obk.adds_layer_nam,  ");
            sbSQL004.Append("       ROUND(obk.blkpntx, 4), ROUND(obk.blkpnty, 4), ROUND(obk.blkpntz, 4), ROUND(obk.blksclx, 4), ROUND(obk.blkscly, 4), ROUND(obk.blksclz, 4), ");
            sbSQL004.Append("       ROUND(NVL2(obk.blkrot, obk.blkrot, 0.0), 4) AS blkrot, NVL2(obk.blkspace, obk.blkspace, 0.0) AS blkspace, NVL2(obk.blkattflw, obk.blkattflw, 0) AS blkattflw, ");
            sbSQL004.Append("       obk.device_id, obk.adds_panel_id, obk.operpt_num, obk.feeder_num ");
            sbSQL004.Append("FROM addsdb.objblk obk ");
            sbSQL004.Append("WHERE obk.adds_panel_id = :panID");

            StringBuilder sbSQL005 = new StringBuilder();   // Info from AddsDB.ObjAtt table
            sbSQL005.Append("SELECT oat.atttag, oat.attvalue, oat.atthandle, oat.adds_layer_nam, ");
            sbSQL005.Append("       ROUND(oat.attnpntx, 4), ROUND(oat.attnpnty, 4), ROUND(oat.attnpntz, 4), ");
            sbSQL005.Append("       ROUND(NVL2(oat.attjpntx, oat.attjpntx, 0.0), 4) AS attjpntx,  ROUND(NVL2(oat.attjpnty, oat.attjpnty,  0.0), 4) AS attjpnty, ROUND(NVL2(oat.attjpntz,oat.attjpntz, 0.0), 4) AS attjpntz, ");
            sbSQL005.Append("       NVL2(oat.attthick, oat.attthick, 0.0) AS attthick, NVL2(oat.atthgt, oat.atthgt, 0.0) AS atthgt, ");
         //   sbSQL005.Append("       NVL2(oat.attrot, oat.attrot, 0.0) as attrot, oat.adds_style, NVL2(oat.attflag, oat.attflag, 0) as attflag, ");
            sbSQL005.Append("       ROUND(NVL2(oat.attrot, oat.attrot, 0.0), 6) as attrot, oat.adds_style, NVL2(oat.attflag, oat.attflag, 0) as attflag, ");
            sbSQL005.Append("       NVL2(oat.atttxtflag, oat.atttxtflag, 0.0) as atttxtflag, NVL2(oat.atthorzflag, oat.atthorzflag, 0.0) as atthorzflag,  ");
            sbSQL005.Append("       NVL2(oat.attvertflag, oat.attvertflag, 0.0) as attvertflag, oat.device_id ");
            sbSQL005.Append("FROM addsdb.objatt oat ");
            sbSQL005.Append("WHERE (oat.device_id in  ");
            sbSQL005.Append("           (select omd.device_id from addsdb.objmstdev omd where omd.adds_panel_id = :panID) )");

            StringBuilder sbSQL001 = new StringBuilder();   // Info from AddsDB.ObjPl table
            sbSQL001.Append("SELECT opl.pldatatype, opl.plhandle, opl.adds_layer_nam, ROUND(NVL2(opl.plthick, opl.plthick, 0.0), 4) as plthick, ");
            sbSQL001.Append("       ROUND(NVL2(opl.plwidbegin,  opl.plwidbegin, 0.0), 4) as plwidbegin, ROUND(NVL2(opl.plwidend,    opl.plwidend,   0.0), 4) AS plwidend, ");
            sbSQL001.Append("       NVL2(opl.plattflw,    opl.plattflw,    0) AS plattflw,    NVL2(opl.plspace,     opl.plspace,     0) AS plspace,     NVL2(opl.plflag, opl.plflag, 0) AS plflag, ");
            sbSQL001.Append("       NVL2(opl.plpolymshm,  opl.plpolymshm,  0) AS plpolymshm,  NVL2(opl.plpolymshn,  opl.plpolymshn,  0) AS plpolymshn,  NVL2(opl.plpolysmthm, opl.plpolysmthm, 0) AS plpolysmthm, ");
            sbSQL001.Append("       NVL2(opl.plpolysmthn, opl.plpolysmthn, 0) AS plpolysmthn, NVL2(opl.plcrvsmttyp, opl.plcrvsmttyp, 0) AS plcrvsmttyp, opl.device_id, opl.adds_panel_id ");
            sbSQL001.Append("FROM addsdb.objpl opl ");
            sbSQL001.Append("WHERE opl.adds_panel_id = :panID ");

            StringBuilder sbSQL002 = new StringBuilder();   // Info from AddsDB.ObjVrt table
            sbSQL002.Append("SELECT ovt.vrtcnt, ovt.vrtdatatype, ovt.vrthandle, ovt.adds_layer_nam, ROUND(ovt.vrtpntx, 4), ROUND(ovt.vrtpnty, 4), ROUND(ovt.vrtpntz, 4), ");
            sbSQL002.Append("       ROUND(NVL2(ovt.vrtwidbegin, ovt.vrtwidbegin, 0.0), 4) as vrtwidbegin, ROUND(NVL2(ovt.vrtwidend, ovt.vrtwidend,  0.0), 4) as vrtwidend, ");
            sbSQL002.Append("       ROUND(NVL2(ovt.vrtbulge,    ovt.vrtbulge,    0.0), 4) as vrtbulge,    ROUND(NVL2(ovt.vrttan,    ovt.vrttan,     0.0), 4) as vrttan, ");
            sbSQL002.Append("       NVL2(ovt.vrtflag,     ovt.vrtflag,     0.0) as vrtflag, ovt.device_id ");
            sbSQL002.Append("FROM addsdb.objvrt ovt ");
            sbSQL002.Append("WHERE (ovt.device_id in  ");
            sbSQL002.Append("           (select omd.device_id from addsdb.objmstdev omd where omd.adds_panel_id = :panID) )");

            StringBuilder sbSQL008 = new StringBuilder();   // Info from AddsDB.Obj4PntPl table
            sbSQL008.Append("SELECT o4p.adds_layer_nam, ROUND(NVL2(o4p.plwid, o4p.plwid, 0.0), 4) as plwid, ");
            sbSQL008.Append("       ROUND(o4p.pntx1, 4), ROUND(o4p.pnty1, 4), ROUND(o4p.pntx2, 4), ROUND(o4p.pnty2, 4), ROUND(o4p.pntx3, 4), ROUND(o4p.pnty3, 4), ROUND(o4p.pntx4, 4), ROUND(o4p.pnty4, 4), ");
            sbSQL008.Append("       NVL2(o4p.point_cnt, o4p.point_cnt, 0) as point_cnt, o4p.device_id, o4p.adds_panel_id, o4p.segcnt ");
            sbSQL008.Append("FROM addsdb.obj4pntpl o4p ");
            sbSQL008.Append("WHERE o4p.adds_panel_id = :panID ");

            StringBuilder sbSQL003 = new StringBuilder();   // Info from AddsDB.ObjTxt table
            sbSQL003.Append("SELECT otx.txtdatatype, otx.txthandle, otx.adds_layer_nam, otx.txtvalue, otx.adds_style,  ");
            sbSQL003.Append("       ROUND(otx.txtnpntx, 4), ROUND(otx.txtnpnty, 4), ROUND(otx.txtnpntz, 4), ROUND(otx.txtjpntx, 4), ROUND(otx.txtjpnty, 4), ROUND(otx.txtjpntz, 4),  ");
            sbSQL003.Append("       ROUND(NVL2(otx.txtthick, otx.txtthick, 0.0), 4) AS txtthick, ROUND(NVL2(otx.txthgt, otx.txthgt, 0.0), 4) AS txthgt, ");
            sbSQL003.Append("       ROUND(NVL2(otx.txtrot,   otx.txtrot,   0.0), 4) as txtrot,   NVL2(otx.txtspace,    otx.txtspace,    0.0) AS txtspace, ");
            sbSQL003.Append("       NVL2(otx.txtflag,  otx.txtflag,  0.0) AS txtflag,  NVL2(otx.txthorzflag, otx.txthorzflag, 0.0) AS txthorzflag,  ");
            sbSQL003.Append("       NVL2(otx.txtvertflag, otx.txtvertflag, 0.0) AS txtvertflag, otx.device_id, otx.adds_panel_id ");
            sbSQL003.Append("FROM addsdb.objtxt otx ");
            sbSQL003.Append("where otx.adds_panel_id = :panID");

            DataSet ds = new DataSet();

            try
            {
                if (!string.IsNullOrEmpty(strOracleConn))
                {
                    //  Decode passed in parameters
                    ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                    strPanID = alInputParameters[0].ToString();
                    decimal.TryParse(strPanID, out decPanID);

                    AcadDB.ResultBuffer rbNil = new AcadDB.ResultBuffer();

                    //  Reset Lists to nil in AutoLISP session before re-populating list
                    Adds.AcadPutSym("CurMstDevLst", rbNil);
                    Adds.AcadPutSym("CurRegDatLst", rbNil);
                    Adds.AcadPutSym("CurObjBlkLst", rbNil);
                    Adds.AcadPutSym("CurObjPL_Lst", rbNil);
                    Adds.AcadPutSym("CurObjVrtLst", rbNil);
                    Adds.AcadPutSym("CurObj4PLLst", rbNil);
                    Adds.AcadPutSym("CurObjTxtLst", rbNil);     

                    using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))                   
                    {
                        oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                        //  Setup Oracle Command
                        OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
                        oracleCommand.Connection = oracleConn;
                        oracleCommand.CommandType = CommandType.Text;
                        oracleCommand.CommandText = sbSQL007.ToString();
                        
                        // Add SQL parameters
                        oracleCommand.Parameters.Add("panID", OracleDb.OracleDbType.Decimal).Value = decPanID;

                        // Get ObjMstDev - Oracle data from DB & store in DataSet
                        OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                        da.TableMappings.Add("Table", "ObjMstDev");
                        da.Fill(ds);
                        intCount = ds.Tables["ObjMstDev"].Rows.Count;

                        // Get ObjRgApp - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL006.ToString();
                        OracleDb.OracleDataAdapter daObjRgApp = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjRgApp.TableMappings.Add("Table", "ObjRgApp");
                        daObjRgApp.Fill(ds);

                        // Get ObjBlk - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL004.ToString();
                        OracleDb.OracleDataAdapter daObjBlk = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjBlk.TableMappings.Add("Table", "ObjBlk");
                        daObjBlk.Fill(ds);

                        // Get ObjAtt - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL005.ToString();
                        OracleDb.OracleDataAdapter daObjAtt = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjAtt.TableMappings.Add("Table", "ObjAtt");
                        daObjAtt.Fill(ds);

                        // Get ObjAtt - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL001.ToString();
                        OracleDb.OracleDataAdapter daObjPl = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjPl.TableMappings.Add("Table", "ObjPl");
                        daObjPl.Fill(ds);

                        // Get ObjVrt - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL002.ToString();
                        OracleDb.OracleDataAdapter daObjVrt = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjVrt.TableMappings.Add("Table", "ObjVrt");
                        daObjVrt.Fill(ds);

                        // Get Obj4PntPl - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL008.ToString();
                        OracleDb.OracleDataAdapter daObj4PntPl = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObj4PntPl.TableMappings.Add("Table", "Obj4PntPl");
                        daObj4PntPl.Fill(ds);

                        // Get ObjTxt - Oracle data from DB & store in DataSet
                        oracleCommand.CommandText = sbSQL003.ToString();
                        OracleDb.OracleDataAdapter daObjTxt = new OracleDb.OracleDataAdapter(oracleCommand);
                        daObjTxt.TableMappings.Add("Table", "ObjTxt");
                        daObjTxt.Fill(ds);

                        ed.WriteMessage("\n *** GetCurOraData Start passing List back at: " + DateTime.Now.ToLongTimeString());

                        // Builds CurMstDevLst & writes to variable in AutoLisp
                        Utilities.BuildListOfList(ds.Tables["ObjMstDev"], out rbResults);
                        Adds.AcadPutSym("CurMstDevLst", rbResults);

                        // Builds CurRegDatLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjRgApp"], out rbResults);
                        Adds.AcadPutSym("CurRegDatLst", rbResults);

                        // Builds CurObjBlkLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjBlk"], out rbResults);
                        Adds.AcadPutSym("CurObjBlkLst", rbResults);

                        // Builds CurObjAttLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjAtt"], out rbResults);
                        Adds.AcadPutSym("CurObjAttLst", rbResults);

                        // Builds CurObjPL_Lst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjPl"], out rbResults);
                        Adds.AcadPutSym("CurObjPL_Lst", rbResults);

                        // Builds CurObjVrtLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjVrt"], out rbResults);
                        Adds.AcadPutSym("CurObjVrtLst", rbResults);

                        // Builds CurObj4PLLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["Obj4PntPl"], out rbResults);
                        Adds.AcadPutSym("CurObj4PLLst", rbResults);

                        // Builds CurObjTxtLst & writes to variable in AutoLisp
                        //rbResults = new AcadDB.ResultBuffer();
                        Utilities.BuildListOfList(ds.Tables["ObjTxt"], out rbResults);
                        Adds.AcadPutSym("CurObjTxtLst", rbResults);
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            ed.WriteMessage("\n *** GetCurOraData Finished at " + DateTime.Now.ToLongTimeString());
            return intCount;
        }

        [Acad.LispFunction("MyNewPanObj_2012")]
        public void PutNewOraData(AcadDB.ResultBuffer args)
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            ed.WriteMessage("\n *** MyNewPanObj_New Started at " + DateTime.Now.ToLongTimeString());
            
            string strCurrentUser = null;
            DateTime dtLoadedDateTime;
            
            //  Decode passed in parameters
            ArrayList alInputParameters = ProcessSaveParameters(ref args);

            string strOracleConn = Adds._strConn;
            ArrayList alTxtRows = null;

            ArrayList MstDev_DeviceID = new ArrayList();
            ArrayList MstDev_EditDTM = new ArrayList();
            ArrayList MstDev_Status = new ArrayList();
            ArrayList MstDev_PanelID = new ArrayList();
            

            ArrayList RgApp_DeviceID = new ArrayList();
            ArrayList RgApp_XdName = new ArrayList();
            ArrayList RgApp_XdValue = new ArrayList();

            ArrayList ObjBl_BlkNam = new ArrayList();
            ArrayList ObjBl_BlkHandle = new ArrayList();
            ArrayList ObjBl_LayerNam = new ArrayList();
            ArrayList ObjBl_BlkPntX = new ArrayList();
            ArrayList ObjBl_BlkPntY = new ArrayList();
            ArrayList ObjBl_BlkPntZ = new ArrayList();
            ArrayList ObjBl_BlkCLX = new ArrayList();
            ArrayList ObjBl_BlkCLY = new ArrayList();
            ArrayList ObjBl_BlkCLZ = new ArrayList();
            ArrayList ObjBl_BlkRot = new ArrayList();
            ArrayList ObjBl_BlkSpace = new ArrayList();
            ArrayList ObjBl_AttFlW = new ArrayList();
            ArrayList ObjBl_DeviceID = new ArrayList();
            ArrayList ObjBl_AddsPanelId = new ArrayList();

            ArrayList ObjAtt_Tag = new ArrayList();
            ArrayList ObjAtt_Value = new ArrayList();
            ArrayList ObjAtt_Handle = new ArrayList();
            ArrayList ObjAtt_Layer = new ArrayList();
            ArrayList ObjAtt_NPtnX = new ArrayList();
            ArrayList ObjAtt_NPtnY = new ArrayList();
            ArrayList ObjAtt_NPtnZ = new ArrayList();
            ArrayList ObjAtt_JPtnX = new ArrayList();
            ArrayList ObjAtt_JPtnY = new ArrayList();
            ArrayList ObjAtt_JPtnZ = new ArrayList();
            ArrayList ObjAtt_Thick = new ArrayList();
            ArrayList ObjAtt_Hgh = new ArrayList();
            ArrayList ObjAtt_Rot = new ArrayList();
            ArrayList ObjAtt_Style = new ArrayList();
            ArrayList ObjAtt_Flag = new ArrayList();
            ArrayList ObjAtt_TxtFlag = new ArrayList();
            ArrayList ObjAtt_HorFlag = new ArrayList();
            ArrayList ObjAtt_VertFlag = new ArrayList();
            ArrayList ObjAtt_DeviceID = new ArrayList();

            ArrayList ObjPl_DataType = new ArrayList();
            ArrayList ObjPl_Handle = new ArrayList();
            ArrayList ObjPl_Layer = new ArrayList();
            ArrayList ObjPl_Thick = new ArrayList();
            ArrayList ObjPl_WidthStart = new ArrayList();
            ArrayList ObjPl_WidthEnd = new ArrayList();
            ArrayList ObjPl_AttFlw = new ArrayList();
            ArrayList ObjPl_Space = new ArrayList();
            ArrayList ObjPl_Flag = new ArrayList();
            ArrayList ObjPl_PolyMeshMCnt = new ArrayList();
            ArrayList ObjPl_PolyMeshNCnt = new ArrayList();
            ArrayList ObjPl_SmoothMCnt = new ArrayList();
            ArrayList ObjPl_SmoothNCnt = new ArrayList();
            ArrayList ObjPl_SmoothType = new ArrayList();
            ArrayList ObjPl_DeviceID = new ArrayList();
            ArrayList ObjPl_PanelID = new ArrayList();

            ArrayList ObjVrt_Count = new ArrayList();
            ArrayList ObjVrt_DataType = new ArrayList();
            ArrayList ObjVrt_Handle = new ArrayList();
            ArrayList ObjVrt_Layer = new ArrayList();
            ArrayList ObjVrt_PntX = new ArrayList();
            ArrayList ObjVrt_PntY = new ArrayList();
            ArrayList ObjVrt_PntZ = new ArrayList();
            ArrayList ObjVrt_WidthBegin = new ArrayList();
            ArrayList ObjVrt_WidthEnd = new ArrayList();
            ArrayList ObjVrt_Bulge = new ArrayList();
            ArrayList ObjVrt_BulgeTan = new ArrayList();
            ArrayList ObjVrt_Flag = new ArrayList();
            ArrayList ObjVrt_DeviceID = new ArrayList();

            ArrayList Obj4PntPl_Layer = new ArrayList();
            ArrayList Obj4PntPl_Width = new ArrayList();
            ArrayList Obj4PntPl_PntX1 = new ArrayList();
            ArrayList Obj4PntPl_PntY1 = new ArrayList();
            ArrayList Obj4PntPl_PntX2 = new ArrayList();
            ArrayList Obj4PntPl_PntY2 = new ArrayList();
            ArrayList Obj4PntPl_PntX3 = new ArrayList();
            ArrayList Obj4PntPl_PntY3 = new ArrayList();
            ArrayList Obj4PntPl_PntX4 = new ArrayList();
            ArrayList Obj4PntPl_PntY4 = new ArrayList();
            ArrayList Obj4PntPl_PntCount = new ArrayList();
            ArrayList Obj4PntPl_DeviceID = new ArrayList();
            ArrayList Obj4PntPl_PanelID = new ArrayList();
            ArrayList Obj4PntPl_SegCount = new ArrayList();

            ArrayList ObjTxt_DataType = new ArrayList();
            ArrayList ObjTxt_Handle = new ArrayList();
            ArrayList ObjTxt_Layer = new ArrayList();
            ArrayList ObjTxt_Value = new ArrayList();
            ArrayList ObjTxt_Style = new ArrayList();
            ArrayList ObjTxt_NPtnX = new ArrayList();
            ArrayList ObjTxt_NPtnY = new ArrayList();
            ArrayList ObjTxt_NPtnZ = new ArrayList();
            ArrayList ObjTxt_JPtnX = new ArrayList();
            ArrayList ObjTxt_JPtnY = new ArrayList();
            ArrayList ObjTxt_JPtnZ = new ArrayList();
            ArrayList ObjTxt_Thick = new ArrayList();
            ArrayList ObjTxt_Hgh = new ArrayList();
            ArrayList ObjTxt_Rot = new ArrayList();
            ArrayList ObjTxt_Space = new ArrayList();
            ArrayList ObjTxt_Flag = new ArrayList();
            ArrayList ObjTxt_HorFlag = new ArrayList();
            ArrayList ObjTxt_VertFlag = new ArrayList();
            ArrayList ObjTxt_DeviceID = new ArrayList();
            ArrayList ObjTxt_PanelID = new ArrayList();

            StringBuilder sbSqlCurPanLog = new StringBuilder();
            sbSqlCurPanLog.Append("INSERT INTO AddsDB.PanelChgLog ");
            sbSqlCurPanLog.Append("VALUES ");
            sbSqlCurPanLog.Append("(:divNam, :panelNam, :sclBlk, :fdrCkts, :ntId, :addSupMs, :bfkPanMs, TO_DATE( :loadedDtm, 'MM-DD-YYYY HH24:MI:SS'), 1)");

            try
            {
                int iParamtersCount = alInputParameters.Count;

                ArrayList alTemp0       = alInputParameters[0] as ArrayList;
                ArrayList alPanChgLog   = (ArrayList)alTemp0[0];                    //A row of values to insert into PanelChgLog Table

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String
                    OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();

                    oracleCommand.CommandType = CommandType.Text;
                    //oracleCommand.CommandText = Adds._strRoles;
                    //oracleCommand.ExecuteNonQuery();

                    oracleCommand.CommandText = sbSqlCurPanLog.ToString();

                    oracleCommand.Parameters.Add("divNam", OracleDb.OracleDbType.Varchar2).Value = alPanChgLog[0].ToString();
                    oracleCommand.Parameters.Add("panelNam", OracleDb.OracleDbType.Varchar2).Value = alPanChgLog[1].ToString();
                    oracleCommand.Parameters.Add("sclBlk", OracleDb.OracleDbType.Varchar2).Value = alPanChgLog[2].ToString();
                    oracleCommand.Parameters.Add("fdrCkts", OracleDb.OracleDbType.Decimal).Value = alPanChgLog[3];
                    oracleCommand.Parameters.Add("ntId", OracleDb.OracleDbType.Varchar2).Value = alPanChgLog[4].ToString();
                    oracleCommand.Parameters.Add("addSupMs", OracleDb.OracleDbType.Decimal).Value = alPanChgLog[5];
                    oracleCommand.Parameters.Add("bfkPanMs", OracleDb.OracleDbType.Decimal).Value = alPanChgLog[6];
                    oracleCommand.Parameters.Add("loadedDtm", OracleDb.OracleDbType.Varchar2).Value = alPanChgLog[7].ToString();
                    //oracleCommand.Parameters.Add("panelChgLogId",   OracleType.Number).Value    = 1;

                    strCurrentUser = alPanChgLog[4].ToString();
                    dtLoadedDateTime = Convert.ToDateTime(alPanChgLog[7].ToString());

                    int iRowsEffected = oracleCommand.ExecuteNonQuery();
                }
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String
                    OracleDb.OracleTransaction ot = oracleConn.BeginTransaction();

                    OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();
                    oracleCommand.Transaction = ot;
                    oracleCommand.CommandType = CommandType.Text;
                    //oracleCommand.CommandText = Adds._strRoles;
                    //oracleCommand.ExecuteNonQuery();

                    oracleCommand.BindByName = true;

                    try
                    {
                        if (iParamtersCount > 1)
                        {
                            ArrayList alDelDevIDs = alInputParameters[1] as ArrayList;        //An array of strings to run AddsDb_Destroyer.Del_Object_By_ID
                            if (alDelDevIDs != null)
                            {
                                string[] strDevIDs = (string[])alDelDevIDs.ToArray(typeof(string));

                                ArrayList alTemp1 = new ArrayList();
                                ArrayList alTemp2 = new ArrayList();
                                for (int index = 1; index <= alDelDevIDs.Count; index++)
                                {
                                    alTemp1.Add(dtLoadedDateTime);
                                    alTemp2.Add(strCurrentUser);
                                }
                                DateTime[] strDate = (DateTime[])alTemp1.ToArray(typeof(DateTime));
                                string[] strNTID = (string[])alTemp2.ToArray(typeof(string));

                                OracleDb.OracleCommand ocmdDestroyer = oracleConn.CreateCommand();
                                ocmdDestroyer.CommandText = "AddsDB.AddsDB_DESTROYER.DEL_OBJECT_BY_ID";
                                ocmdDestroyer.CommandType = CommandType.StoredProcedure;
                                ocmdDestroyer.ArrayBindCount = alDelDevIDs.Count;
                                ocmdDestroyer.BindByName = true;
                                ocmdDestroyer.Transaction = ot;

                                // Create parameters
                                OracleDb.OracleParameter opDeviceID = new OracleDb.OracleParameter("n_DeviceID", OracleDb.OracleDbType.Varchar2, 25,
                                    ParameterDirection.Input);
                                opDeviceID.Value = strDevIDs;
                                OracleDb.OracleParameter opDateTime = new OracleDb.OracleParameter("v2_operation_dtm", OracleDb.OracleDbType.Date, ParameterDirection.Input);
                                opDateTime.Value = strDate;
                                OracleDb.OracleParameter opNTID = new OracleDb.OracleParameter("v2_login_id", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input);
                                opNTID.Value = strNTID;

                                ocmdDestroyer.Parameters.Add(opDeviceID);
                                ocmdDestroyer.Parameters.Add(opDateTime);
                                ocmdDestroyer.Parameters.Add(opNTID);

                                int iRowsEffected = ocmdDestroyer.ExecuteNonQuery();
                            }
                        }

                        if (iParamtersCount > 2)
                        {
                            ArrayList alMstDevRows = alInputParameters[2] as ArrayList;        //Rows of inserts to ObjMstDev  Table 4 fields per row
                            if (alMstDevRows != null)
                            {
                                foreach (ArrayList alRow in alMstDevRows)
                                {
                                    MstDev_DeviceID.Add(alRow[0]);
                                    MstDev_EditDTM.Add(Convert.ToDateTime(alRow[1].ToString()));
                                    MstDev_Status.Add(alRow[2]);
                                    MstDev_PanelID.Add(Convert.ToDecimal(alRow[3].ToString()));
                                }
                                alMstDevRows.Clear();
                                alMstDevRows = null;

                                StringBuilder sbSqlObjMstDev = new StringBuilder();
                                sbSqlObjMstDev.Append("INSERT INTO AddsDB.ObjMstDev ");
                                sbSqlObjMstDev.Append("VALUES ");
                                sbSqlObjMstDev.Append("(:deviceID, :loadedDtm, :statusFlag, :addsPanelID)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjMstDev.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = MstDev_DeviceID.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("deviceID", OracleDb.OracleDbType.Varchar2, 25, ParameterDirection.Input).Value = MstDev_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("loadedDtm", OracleDb.OracleDbType.Date, ParameterDirection.Input).Value = MstDev_EditDTM.ToArray();
                                oracleCommand.Parameters.Add("statusFlag", OracleDb.OracleDbType.Varchar2, 1, ParameterDirection.Input).Value = MstDev_Status.ToArray();
                                oracleCommand.Parameters.Add("addsPanelID", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = MstDev_PanelID.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }

                        if (iParamtersCount > 3)
                        {
                            ArrayList alRgAppRows = alInputParameters[3] as ArrayList;        //Rows of inserts to ObjRgApp   Table 3 fields per row
                            if (alRgAppRows != null)
                            {
                                foreach (ArrayList alRow in alRgAppRows)
                                {
                                    RgApp_DeviceID.Add(alRow[0]);
                                    RgApp_XdName.Add(alRow[1]);
                                    RgApp_XdValue.Add(alRow[2]);
                                }
                                alRgAppRows.Clear();
                                alRgAppRows = null;

                                StringBuilder sbSqlObjRgApp = new StringBuilder();
                                sbSqlObjRgApp.Append("INSERT INTO AddsDB.ObjRgApp ");
                                sbSqlObjRgApp.Append("VALUES ");
                                sbSqlObjRgApp.Append("(:deviceID, :xdtName, :xdtValue)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjRgApp.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = RgApp_DeviceID.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("deviceID", OracleDb.OracleDbType.Varchar2, 25, ParameterDirection.Input).Value = RgApp_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("xdtName", OracleDb.OracleDbType.Varchar2, 50, ParameterDirection.Input).Value = RgApp_XdName.ToArray();
                                oracleCommand.Parameters.Add("xdtValue", OracleDb.OracleDbType.Varchar2, 250, ParameterDirection.Input).Value = RgApp_XdValue.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                        if (iParamtersCount > 4)
                        {
                            ArrayList alBlkRows = alInputParameters[4] as ArrayList;        //Rows of inserts to ObjBlk     Table 14 fields per row
                            if (alBlkRows != null)
                            {
                                foreach (ArrayList alBlkRow in alBlkRows)
                                {
                                    ObjBl_BlkNam.Add(alBlkRow[0]);
                                    ObjBl_BlkHandle.Add(alBlkRow[1]);
                                    ObjBl_LayerNam.Add(alBlkRow[2]);

                                    ObjBl_BlkPntX.Add(alBlkRow[3]);
                                    ObjBl_BlkPntY.Add(alBlkRow[4]);
                                    ObjBl_BlkPntZ.Add(alBlkRow[5]);
                                    ObjBl_BlkCLX.Add(alBlkRow[6]);
                                    ObjBl_BlkCLY.Add(alBlkRow[7]);
                                    ObjBl_BlkCLZ.Add(alBlkRow[8]);
                                    ObjBl_BlkRot.Add(alBlkRow[9]);
                                    ObjBl_BlkSpace.Add(alBlkRow[10]);
                                    ObjBl_AttFlW.Add(alBlkRow[11]);

                                    ObjBl_DeviceID.Add(alBlkRow[12]);
                                    ObjBl_AddsPanelId.Add(alBlkRow[13]);
                                }
                                alBlkRows.Clear();
                                alBlkRows = null;

                                StringBuilder sbSqlObjBlk = new StringBuilder();
                                sbSqlObjBlk.Append("INSERT INTO AddsDB.ObjBlk ");
                                sbSqlObjBlk.Append("(Adds_Blk_Nam, BlkHandle, Adds_Layer_Nam, BlkPntX, BlkPntY, BlkPntZ, ");
                                sbSqlObjBlk.Append(" BlksClx, BlksClY, BlksClZ, BlkRot, BlkSpace, BlkAttFlw, Device_ID, Adds_Panel_ID) ");
                                sbSqlObjBlk.Append("VALUES ");
                                sbSqlObjBlk.Append("(:addsBlkNam, :handle, :layer, ");
                        //        sbSqlObjBlk.Append("(:addsBlkNam, :handle, :layer, :blkPntX, :blkPntY, :blkPntZ, ");
                                sbSqlObjBlk.Append("ROUND(:blkPntX, 4), ROUND(:blkPntY, 4), ROUND(:blkPntZ, 4), ");
                                sbSqlObjBlk.Append("ROUND(:blkClX, 4),  ROUND(:blkClY, 4),  ROUND(:blkClZ, 4), ROUND(:blkRot, 4), :blkSpace, :blkAttFlw, :deviceId, :panelID)");
                        //        sbSqlObjBlk.Append(":blkClX, :blkClY, :blkClZ, :blkRot, :blkSpace, :blkAttFlw, :deviceId, :panelID)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjBlk.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = ObjBl_DeviceID.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("addsBlkNam", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjBl_BlkNam.ToArray();
                                oracleCommand.Parameters.Add("handle", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjBl_BlkHandle.ToArray();
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjBl_LayerNam.ToArray();

                                oracleCommand.Parameters.Add("blkPntX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkPntX.ToArray();
                                oracleCommand.Parameters.Add("blkPntY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkPntY.ToArray();
                                oracleCommand.Parameters.Add("blkPntZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkPntZ.ToArray();
                                oracleCommand.Parameters.Add("blkClX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkCLX.ToArray();
                                oracleCommand.Parameters.Add("blkClY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkCLY.ToArray();
                                oracleCommand.Parameters.Add("blkClZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkCLZ.ToArray();

                                oracleCommand.Parameters.Add("blkRot", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkRot.ToArray();
                                oracleCommand.Parameters.Add("blkSpace", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_BlkSpace.ToArray();
                                oracleCommand.Parameters.Add("blkAttFlw", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_AttFlW.ToArray();
                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjBl_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("panelId", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjBl_AddsPanelId.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                        if (iParamtersCount > 5)
                        {
                            ArrayList alAttRows = alInputParameters[5] as ArrayList;        //Rows of inserts to ObjAtt     Table 19 fields per row
                            if (alAttRows != null)
                            {
                                foreach (ArrayList alAttRow in alAttRows)
                                {
                                    ObjAtt_Tag.Add(alAttRow[0]);
                                    ObjAtt_Value.Add(alAttRow[1]);
                                    ObjAtt_Handle.Add(alAttRow[2]);
                                    ObjAtt_Layer.Add(alAttRow[3]);

                                    ObjAtt_NPtnX.Add(alAttRow[4]);
                                    ObjAtt_NPtnY.Add(alAttRow[5]);
                                    ObjAtt_NPtnZ.Add(alAttRow[6]);
                                    ObjAtt_JPtnX.Add(alAttRow[7]);
                                    ObjAtt_JPtnY.Add(alAttRow[8]);
                                    ObjAtt_JPtnZ.Add(alAttRow[9]);

                                    ObjAtt_Thick.Add(alAttRow[10]);
                                    ObjAtt_Hgh.Add(alAttRow[11]);
                                    ObjAtt_Rot.Add(alAttRow[12]);
                                    ObjAtt_Style.Add(alAttRow[13]);

                                    ObjAtt_Flag.Add(alAttRow[14]);
                                    ObjAtt_TxtFlag.Add(alAttRow[15]);
                                    ObjAtt_HorFlag.Add(alAttRow[16]);
                                    ObjAtt_VertFlag.Add(alAttRow[17]);
                                    ObjAtt_DeviceID.Add(alAttRow[18]);
                                }
                                alAttRows.Clear();
                                alAttRows = null;

                                StringBuilder sbSqlObjAtt = new StringBuilder();
                                sbSqlObjAtt.Append("INSERT INTO AddsDB.ObjAtt ");
                                sbSqlObjAtt.Append("VALUES ");
                                sbSqlObjAtt.Append("(:tag, :value, :handle, :layer, ");
                                sbSqlObjAtt.Append("  ROUND( :nPntX, 4),  ROUND( :nPntY, 4),  ROUND( :nPntZ, 4),  ROUND( :jPntX, 4),  ROUND( :jPntY, 4),  ROUND( :jPntZ, 4), ");
                           //     sbSqlObjAtt.Append(" :nPntX, :nPntY, :nPntZ, :jPntX, :jPntY, :jPntZ, ");
                                sbSqlObjAtt.Append("  ROUND( :thick, 4), ROUND( :hight, 4), ROUND( :rot, 4), :style, ");               //Test 
                           //     sbSqlObjAtt.Append(" :thick, :hight, :rot, :style, ");               //Test 
                                sbSqlObjAtt.Append(" :flag, :txtFlag, :horFlag, :vertFlag, :deviceId)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjAtt.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = ObjAtt_Tag.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("tag", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_Tag.ToArray();
                                oracleCommand.Parameters.Add("value", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_Value.ToArray();
                                oracleCommand.Parameters.Add("handle", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_Handle.ToArray();
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_Layer.ToArray();

                                oracleCommand.Parameters.Add("nPntX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_NPtnX.ToArray();
                                oracleCommand.Parameters.Add("nPntY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_NPtnY.ToArray();
                                oracleCommand.Parameters.Add("nPntZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_NPtnZ.ToArray();
                                oracleCommand.Parameters.Add("jPntX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_JPtnX.ToArray();
                                oracleCommand.Parameters.Add("jPntY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_JPtnY.ToArray();
                                oracleCommand.Parameters.Add("jPntZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_JPtnZ.ToArray();

                                oracleCommand.Parameters.Add("thick", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_Thick.ToArray();
                                oracleCommand.Parameters.Add("hight", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_Hgh.ToArray();
                                oracleCommand.Parameters.Add("rot", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_Rot.ToArray();
                                oracleCommand.Parameters.Add("style", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_Style.ToArray();

                                oracleCommand.Parameters.Add("flag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_Flag.ToArray();
                                oracleCommand.Parameters.Add("txtFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_TxtFlag.ToArray();
                                oracleCommand.Parameters.Add("horFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_HorFlag.ToArray();
                                oracleCommand.Parameters.Add("vertFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjAtt_VertFlag.ToArray();
                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjAtt_DeviceID.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                        if (iParamtersCount > 6)
                        {
                            ArrayList alPlRows = alInputParameters[6] as ArrayList;        //Rows of inserts to ObjPl      Table 16 fields per row
                            if (alPlRows != null)
                            {
                                foreach (ArrayList alPlRow in alPlRows)
                                {
                                    ObjPl_DataType.Add(alPlRow[0]);
                                    ObjPl_Handle.Add(alPlRow[1]);
                                    ObjPl_Layer.Add(alPlRow[2]);
                                    ObjPl_Thick.Add(alPlRow[3]);

                                    ObjPl_WidthStart.Add(alPlRow[4]);
                                    ObjPl_WidthEnd.Add(alPlRow[5]);
                                    ObjPl_AttFlw.Add(alPlRow[6]);
                                    ObjPl_Space.Add(alPlRow[7]);
                                    ObjPl_Flag.Add(alPlRow[8]);

                                    ObjPl_PolyMeshMCnt.Add(alPlRow[9]);
                                    ObjPl_PolyMeshNCnt.Add(alPlRow[10]);
                                    ObjPl_SmoothMCnt.Add(alPlRow[11]);
                                    ObjPl_SmoothNCnt.Add(alPlRow[12]);
                                    ObjPl_SmoothType.Add(alPlRow[13]);

                                    ObjPl_DeviceID.Add(alPlRow[14]);
                                    ObjPl_PanelID.Add(alPlRow[15]);
                                }
                                alPlRows.Clear();
                                alPlRows = null;

                                StringBuilder sbSqlObjPl = new StringBuilder();
                                sbSqlObjPl.Append("INSERT INTO AddsDB.ObjPL ");
                                sbSqlObjPl.Append("(PlDataType, PlHandle, Adds_Layer_Nam, PlThick, PlWidBegin, PlWidEnd, PlAttFlw, PlSpace, ");
                                sbSqlObjPl.Append(" PlFlag, PlPolymShM, PlPolymShN, PlPolySmThM, PlPolySmThN, PlCrvSmtTyp, Device_Id, Adds_Panel_Id) ");
                                sbSqlObjPl.Append("VALUES ");
                                sbSqlObjPl.Append("(:dataType, :handle, :layer, ROUND(:thick, 4), ROUND(:widBegin, 4), ROUND(:widEnd, 4), :attFlag, :space, ");
                                sbSqlObjPl.Append(" :flag, :polymShM, :polymShN, :polySmThM, :polySmThN, :crvSmtTyp, :deviceId, :panelId)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjPl.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = ObjPl_DataType.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("dataType", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjPl_DataType.ToArray();
                                oracleCommand.Parameters.Add("handle", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjPl_Handle.ToArray();
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjPl_Layer.ToArray();
                                oracleCommand.Parameters.Add("thick", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_Thick.ToArray();

                                oracleCommand.Parameters.Add("widBegin", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_WidthStart.ToArray();
                                oracleCommand.Parameters.Add("widEnd", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_WidthEnd.ToArray();
                                oracleCommand.Parameters.Add("attFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_AttFlw.ToArray();
                                oracleCommand.Parameters.Add("space", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_Space.ToArray();

                                oracleCommand.Parameters.Add("flag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_Flag.ToArray();
                                oracleCommand.Parameters.Add("polymShM", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_PolyMeshMCnt.ToArray();
                                oracleCommand.Parameters.Add("polymShN", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_PolyMeshNCnt.ToArray();
                                oracleCommand.Parameters.Add("polySmThM", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_SmoothMCnt.ToArray();
                                oracleCommand.Parameters.Add("polySmThN", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_SmoothNCnt.ToArray();

                                oracleCommand.Parameters.Add("crvSmtTyp", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_SmoothType.ToArray();
                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjPl_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("panelId", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjPl_PanelID.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                        if (iParamtersCount > 7)
                        {
                            ArrayList alVrtRows = alInputParameters[7] as ArrayList;        //Rows of inserts to ObjVrt     Table 13 fields per row
                            if (alVrtRows != null)
                            {
                                foreach (ArrayList alVrtRow in alVrtRows)
                                {
                                    ObjVrt_Count.Add(alVrtRow[0]);
                                    ObjVrt_DataType.Add(alVrtRow[1]);
                                    ObjVrt_Handle.Add(alVrtRow[2]);
                                    ObjVrt_Layer.Add(alVrtRow[3]);

                                    ObjVrt_PntX.Add(alVrtRow[4]);
                                    ObjVrt_PntY.Add(alVrtRow[5]);
                                    ObjVrt_PntZ.Add(alVrtRow[6]);
                                    ObjVrt_WidthBegin.Add(alVrtRow[7]);
                                    ObjVrt_WidthEnd.Add(alVrtRow[8]);
                                    ObjVrt_Bulge.Add(alVrtRow[9]);
                                    ObjVrt_BulgeTan.Add(alVrtRow[10]);

                                    ObjVrt_Flag.Add(alVrtRow[11]);
                                    ObjVrt_DeviceID.Add(alVrtRow[12]);
                                }
                                alVrtRows.Clear();
                                alVrtRows = null;

                                StringBuilder sbSqlObjVrt = new StringBuilder();
                                sbSqlObjVrt.Append("INSERT INTO AddsDB.ObjVrt ");
                                sbSqlObjVrt.Append("VALUES ");
                                sbSqlObjVrt.Append("(:count, :dataType, :handle, :layer, ROUND(:pntX, 4), ROUND(:pntY, 4), ROUND(:pntZ, 4), ");
                                sbSqlObjVrt.Append(" ROUND(:widBegin, 4), ROUND(:widEnd, 4), ROUND(:bulge, 4), ROUND(:bulgeTan, 4), :flag, :deviceID)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjVrt.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = ObjVrt_Count.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("count", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjVrt_Count.ToArray();
                                oracleCommand.Parameters.Add("dataType", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjVrt_DataType.ToArray();
                                oracleCommand.Parameters.Add("handle", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjVrt_Handle.ToArray();
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjVrt_Layer.ToArray();
                                oracleCommand.Parameters.Add("pntX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_PntX.ToArray();
                                oracleCommand.Parameters.Add("pntY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_PntY.ToArray();
                                oracleCommand.Parameters.Add("pntZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_PntZ.ToArray();

                                oracleCommand.Parameters.Add("widBegin", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_WidthBegin.ToArray();
                                oracleCommand.Parameters.Add("widEnd", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_WidthEnd.ToArray();
                                oracleCommand.Parameters.Add("bulge", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_Bulge.ToArray();
                                oracleCommand.Parameters.Add("bulgeTan", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_BulgeTan.ToArray();
                                oracleCommand.Parameters.Add("flag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjVrt_Flag.ToArray();
                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjVrt_DeviceID.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                        if (iParamtersCount > 8)
                        {
                            ArrayList al4PntPlRows = alInputParameters[8] as ArrayList;        //Rows of inserts to Obj4PntPl  Table 14 fields per row 
                            if (al4PntPlRows != null)
                            {
                                foreach (ArrayList al4ptPlRow in al4PntPlRows)
                                {
                                    Obj4PntPl_Layer.Add(al4ptPlRow[0]);
                                    Obj4PntPl_Width.Add(al4ptPlRow[1]);
                                    Obj4PntPl_PntX1.Add(al4ptPlRow[2]);
                                    Obj4PntPl_PntY1.Add(al4ptPlRow[3]);
                                    Obj4PntPl_PntX2.Add(al4ptPlRow[4]);
                                    Obj4PntPl_PntY2.Add(al4ptPlRow[5]);
                                    Obj4PntPl_PntX3.Add(al4ptPlRow[6]);
                                    Obj4PntPl_PntY3.Add(al4ptPlRow[7]);
                                    Obj4PntPl_PntX4.Add(al4ptPlRow[8]);
                                    Obj4PntPl_PntY4.Add(al4ptPlRow[9]);

                                    Obj4PntPl_PntCount.Add(al4ptPlRow[10]);
                                    Obj4PntPl_DeviceID.Add(al4ptPlRow[11]);
                                    Obj4PntPl_PanelID.Add(al4ptPlRow[12]);
                                    Obj4PntPl_SegCount.Add(al4ptPlRow[13]);
                                }
                                al4PntPlRows.Clear();
                                al4PntPlRows = null;

                                StringBuilder sbSqlObj4PltPl = new StringBuilder();
                                sbSqlObj4PltPl.Append("INSERT INTO AddsDB.Obj4PntPl ");
                                sbSqlObj4PltPl.Append("VALUES ");
                                sbSqlObj4PltPl.Append("(:layer, ROUND(:width, 4), ROUND(:pntX1, 4), ROUND(:pntY1, 4), ROUND(:pntX2, 4), ROUND(:pntY2, 4), ROUND(:pntX3, 4), ROUND(:pntY3, 4), ");
                                sbSqlObj4PltPl.Append(" ROUND(:pntX4, 4), ROUND(:pntY4, 4), :count, :deviceID, :panelId, :segCount)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObj4PltPl.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = Obj4PntPl_Layer.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = Obj4PntPl_Layer.ToArray();
                                oracleCommand.Parameters.Add("width", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_Width.ToArray();
                                oracleCommand.Parameters.Add("pntX1", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntX1.ToArray();
                                oracleCommand.Parameters.Add("pntY1", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntY1.ToArray();
                                oracleCommand.Parameters.Add("pntX2", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntX2.ToArray();
                                oracleCommand.Parameters.Add("pntY2", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntY2.ToArray();
                                oracleCommand.Parameters.Add("pntX3", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntX3.ToArray();
                                oracleCommand.Parameters.Add("pntY3", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntY3.ToArray();

                                oracleCommand.Parameters.Add("pntX4", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntX4.ToArray();
                                oracleCommand.Parameters.Add("pntY4", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntY4.ToArray();
                                oracleCommand.Parameters.Add("count", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PntCount.ToArray();
                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = Obj4PntPl_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("panelId", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_PanelID.ToArray();
                                oracleCommand.Parameters.Add("segCount", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = Obj4PntPl_SegCount.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }

                        if (iParamtersCount > 9)
                        {
                            alTxtRows = alInputParameters[9] as ArrayList;        //Rows of inserts to ObTxt  Table 14 fields per row 
                            if (alTxtRows != null)
                            {
                                foreach (ArrayList alTxtRow in alTxtRows)
                                {
                                    ObjTxt_DataType.Add(alTxtRow[0]);
                                    ObjTxt_Handle.Add(alTxtRow[1]);
                                    ObjTxt_Layer.Add(alTxtRow[2]);
                                    ObjTxt_Value.Add(alTxtRow[3]);
                                    ObjTxt_Style.Add(alTxtRow[4]);

                                    ObjTxt_NPtnX.Add(alTxtRow[5]);
                                    ObjTxt_NPtnY.Add(alTxtRow[6]);
                                    ObjTxt_NPtnZ.Add(alTxtRow[7]);
                                    ObjTxt_JPtnX.Add(alTxtRow[8]);
                                    ObjTxt_JPtnY.Add(alTxtRow[9]);
                                    ObjTxt_JPtnZ.Add(alTxtRow[10]);

                                    ObjTxt_Thick.Add(alTxtRow[11]);
                                    ObjTxt_Hgh.Add(alTxtRow[12]);
                                    ObjTxt_Rot.Add(alTxtRow[13]);
                                    ObjTxt_Space.Add(alTxtRow[14]);
                                    ObjTxt_Flag.Add(alTxtRow[15]);
                                    ObjTxt_HorFlag.Add(alTxtRow[16]);
                                    ObjTxt_VertFlag.Add(alTxtRow[17]);

                                    ObjTxt_DeviceID.Add(alTxtRow[18]);
                                    ObjTxt_PanelID.Add(alTxtRow[19]);
                                }
                                alTxtRows.Clear();
                                alTxtRows = null;

                                StringBuilder sbSqlObjTxt = new StringBuilder();
                                sbSqlObjTxt.Append("INSERT INTO AddsDB.ObjTxt ");
                                sbSqlObjTxt.Append("VALUES ");
                                sbSqlObjTxt.Append("(:dataType, :handle, :layer, :value, :style, ");
                                sbSqlObjTxt.Append("ROUND(:nPtnX, 4), ROUND(:nPtnY, 4),  ROUND(:nPtnZ, 4), ROUND(:jPtnX, 4), ROUND(:jPtnY, 4), ROUND(:jPtnZ, 4), ");
                                sbSqlObjTxt.Append("ROUND(:thick, 4), ROUND(:hieght, 4), ROUND(:rotation, 4), :space, :flag, :horFlag, :vertFlag, ");
                                sbSqlObjTxt.Append(":deviceId, :panelId)");

                                //  Setup Oracle Command for Array Binding
                                oracleCommand.CommandText = sbSqlObjTxt.ToString();
                                oracleCommand.Parameters.Clear();
                                oracleCommand.ArrayBindCount = ObjTxt_DataType.Count;

                                //  Set Parameters
                                oracleCommand.Parameters.Add("dataType", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_DataType.ToArray();
                                oracleCommand.Parameters.Add("handle", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_Handle.ToArray();
                                oracleCommand.Parameters.Add("layer", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_Layer.ToArray();
                                oracleCommand.Parameters.Add("value", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_Value.ToArray();
                                oracleCommand.Parameters.Add("style", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_Style.ToArray();

                                oracleCommand.Parameters.Add("nPtnX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_NPtnX.ToArray();
                                oracleCommand.Parameters.Add("nPtnY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_NPtnY.ToArray();
                                oracleCommand.Parameters.Add("nPtnZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_NPtnZ.ToArray();
                                oracleCommand.Parameters.Add("jPtnX", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_JPtnX.ToArray();
                                oracleCommand.Parameters.Add("jPtnY", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_JPtnY.ToArray();
                                oracleCommand.Parameters.Add("jPtnZ", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_JPtnZ.ToArray();

                                oracleCommand.Parameters.Add("thick", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_Thick.ToArray();
                                oracleCommand.Parameters.Add("hieght", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_Hgh.ToArray();
                                oracleCommand.Parameters.Add("rotation", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_Rot.ToArray();
                                oracleCommand.Parameters.Add("space", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_Space.ToArray();
                                oracleCommand.Parameters.Add("flag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_Flag.ToArray();
                                oracleCommand.Parameters.Add("horFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_HorFlag.ToArray();
                                oracleCommand.Parameters.Add("vertFlag", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_VertFlag.ToArray();

                                oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2, ParameterDirection.Input).Value = ObjTxt_DeviceID.ToArray();
                                oracleCommand.Parameters.Add("panelId", OracleDb.OracleDbType.Decimal, ParameterDirection.Input).Value = ObjTxt_PanelID.ToArray();

                                //  Insert all rows
                                int iRowsEffected = oracleCommand.ExecuteNonQuery();
                            }
                        }
                    ot.Commit();
                    }
                    catch (OracleDb.OracleException oxError)
                    {
                        ot.Rollback();
                        MessageBox.Show(oxError.ToString(), "Oracle Exception");
                        ed.WriteMessage(oxError.ToString());
                    }
                }
            }
            catch (System.Exception ex)
            {
              
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            ed.WriteMessage("\n *** MyNewPanObj_New Finished at " + DateTime.Now.ToLongTimeString());
        }

        [Acad.LispFunction("MyChkDevPan_2012")]
        public int GetPanel_ID(AcadDB.ResultBuffer args)
        {
            string strResult = null;
            string strOracleConn = Adds._strConn;
            string strDeviceID = null;
            int dblResult = 0;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT omd.Adds_Panel_ID ");
            sbSQL.Append("FROM AddsDB.ObjMstDev omd ");
            sbSQL.Append("WHERE omd.Device_ID = :deviceId ");

            try
            {
                if (!string.IsNullOrEmpty(strOracleConn))
                {
                    //  Decode passed in parameters
                    ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                    strDeviceID = alInputParameters[0].ToString().Trim();

                    using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                    {
                        oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String

                        //  Setup Oracle Command
                        OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                        oracleCommand.Connection = oracleConn;
                        oracleCommand.CommandType = CommandType.Text;
                        oracleCommand.CommandText = sbSQL.ToString();

                        // Add SQL parameters
                        oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2).Value = strDeviceID;

                        //  Execute & cleanup
                        strResult = oracleCommand.ExecuteScalar().ToString();
                        oracleConn.Close();
                    }
                    if (int.TryParse(strResult, out dblResult))
                    {
                        //dblResult = dblResult;
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return dblResult;
        }

        [Acad.LispFunction("GetDev_ID_2012")]
        public void GetDevByID(AcadDB.ResultBuffer args)
        {
            string strOracleConn = Adds._strConn;
            string strPanelName = null;

            Int32 intAddsPanelID = 0;
            Int32 intCompLevel = 0;

            DataTable dtResults = null;           

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT omd.adds_panel_id, lp.panel_name, lp.complevel ");
            sbSQL.Append("FROM AddsDB.ObjMstDev omd, AddsDB.Lu_Panel lp ");
            sbSQL.Append("WHERE omd.Device_ID = :deviceId ");
            sbSQL.Append("  AND omd.adds_panel_id = lp.adds_panel_id ");

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                doc.LispEnded += new EventHandler(doc_LispEnd);//AcadAS.LispEndedEventHandler(doc_LispEnd);

                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Prompt user for Device ID
                AcadEd.PromptStringOptions pso = new AcadEd.PromptStringOptions("\nEnter Device ID: ");
                AcadEd.PromptResult pr = ed.GetString(pso);
                if (pr.Status == AcadEd.PromptStatus.OK)
                {
                    strDeveId = pr.StringResult;
                }

                if (!string.IsNullOrEmpty(strDeveId))
                {
                    //  Get data from the database
                    using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                    {
                        //  Setup Oracle Command
                        OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                        oracleCommand.Connection = oracleConn;
                        oracleCommand.CommandType = CommandType.Text;
                        oracleCommand.CommandText = sbSQL.ToString();

                        // Add SQL parameters
                        oracleCommand.Parameters.Add("deviceId", OracleDb.OracleDbType.Varchar2).Value = strDeveId;

                        DataSet ds = new DataSet();
                        OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                        da.TableMappings.Add("Table", "Results");
                        da.Fill(ds);
                        dtResults = ds.Tables["Results"] as DataTable;
                    }

                    if (dtResults.Rows.Count == 1)
                    {
                        DataRow dr = dtResults.Rows[0];
                        intAddsPanelID = Int32.Parse(dr["adds_panel_id"].ToString());
                        strPanelName = dr["panel_name"].ToString();
                        intCompLevel = Int32.Parse(dr["complevel"].ToString());
                    }
                    g_flgAcadIsBusy = true;
                    string strTemp = "(GetPan \"" + strPanelName + "\") ";
                    doc.SendStringToExecute(strTemp, true, false, false);
                    //while (g_flgAcadIsBusy)
                    //{
                    //   // Application.DoEvents();
                    //}
                    //doc.LispEnded -= new EventHandler(doc_LispEnd);
                   // AcadAS.Application.Invoke();

                    //doc.SendStringToExecute("FindEED \"" + strDeveId + "\") ",true, false, true);
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }
        static void doc_LispEnd(object sendor, EventArgs args)
        {
            g_flgAcadIsBusy = false;
            Utilities.FindEED();
        }

        [Acad.LispFunction("MyChkDev_ID_Obj_2012")] 
        public string ChkDev_ID_Exist(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();

            string strOracleConn = Adds._strConn;
            string strSwitchNum = null;
            string strFeedNum = null;
            string strBlockName = null;
            string strResult = null;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT AddsDB.Chk_Dev_ID_Exist(:switchNum, :feederNum, :blockName) AS Device_ID ");
            sbSQL.Append("FROM DUAL");

            try
            {
                if (!string.IsNullOrEmpty(strOracleConn))
                {
                    //  Decode passed in parameters
                    ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                    strSwitchNum = alInputParameters[0].ToString().Trim();
                    strFeedNum = alInputParameters[1].ToString().Trim();
                    strBlockName = alInputParameters[2].ToString().Trim();

                    //using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                    using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                    {
                        oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String

                        //  Setup Oracle Command
                        OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                        oracleCommand.Connection = oracleConn;
                        oracleCommand.CommandType = CommandType.Text;
                        oracleCommand.CommandText = sbSQL.ToString();

                        // Add SQL parameters
                        oracleCommand.Parameters.Add("switchNum", OracleDb.OracleDbType.Varchar2).Value = strSwitchNum;
                        oracleCommand.Parameters.Add("feederNum", OracleDb.OracleDbType.Varchar2).Value = strFeedNum;
                        oracleCommand.Parameters.Add("blockName", OracleDb.OracleDbType.Varchar2).Value = strBlockName;

                        //  Execute & cleanup
                        strResult = oracleCommand.ExecuteScalar().ToString();
                        oracleConn.Close();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return strResult;
        }

        [Acad.LispFunction("GetNext_ID")]                      //[Acad.LispFunction("GetNext_ID_2012")]  Called by CGA, CGM -> ChngUm
        public double GetNext_ID(AcadDB.ResultBuffer args)
        {
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT AddsDB.Get_Next_ID ");
            sbSQL.Append("FROM DUAL");

            string strOracleConn = Adds._strConn;
            
            string strResult = null;
            double dblResult = 0.0;

            try
            {
                if (!string.IsNullOrEmpty(strOracleConn))
                {
                    using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                    {
                        oracleConn.Open();                                  // [CHECKED] Oracle 12.c - Connection String
                        oracleConn.ClientInfo = Adds._strUserID;            //    [Oracle 12.C]


                        OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                        oracleCommand.Connection = oracleConn;
                        oracleCommand.CommandType = CommandType.Text;

                        //oracleCommand.CommandText = Adds._strRoles;  Removed because of Oracle 12.c
                        //oracleCommand.ExecuteNonQuery();

                        oracleCommand.CommandText = sbSQL.ToString();
                        strResult = oracleCommand.ExecuteScalar().ToString();

                        oracleConn.Close();
                    }

                   if (double.TryParse(strResult, out dblResult))
                    {
                        //dblResult = dblResult;
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dblResult;
        }

        

        [Acad.LispFunction("MyLoginObj_2012")]
        public AcadDB.ResultBuffer MyLoginObj(AcadDB.ResultBuffer args)
        {
            int intRefValue = 0;
            string strPathToIni = null;
            string strUserID = null, strPwd = null, strConn = null, strSecLevel = null, strRoles = null, strAppID = null, strAppPwd = null;
            string strBaseKey = null;
            string strCleanUpKey = null;
            string strDevMark = null;
            Int32 intDBConnStatus = 0;

            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();
            AcadDB.ResultBuffer rbResultsList = new AcadDB.ResultBuffer();

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            ed.WriteMessage("\n *** MyLoginObj_New Started at " + DateTime.Now.ToLongTimeString());

            try
            {
                //  Get _Path-Person value from AutoLISP
                rbResults = Adds.AcadGetSystemVariable("_Path-Person", ref intRefValue);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strPathPerson = alResults[0].ToString();

                //string strPathPerson = System.Convert.ToString(AcadAS.Application.GetSystemVariable("_Path-Person"));

                //  Get DevMark value from AutoLISP
                rbResults = null;
                rbResults = Adds.AcadGetSystemVariable("DevMark", ref intRefValue);
                if (rbResults != null)
                {
                    alResults = Adds.ProcessInputParameters(rbResults);
                    strDevMark = alResults[0].ToString();
                }

                //strDevMark = System.Convert.ToString(AcadAS.Application.GetSystemVariable("DevMark"));

                //  Determine which ini file to use & call login dll
                if (strDevMark == "[Dev 1.0]")
                {
                    strPathToIni = strPathPerson + "AddsTestLogin.ini";
                }
                else
                {
                    strPathToIni = strPathPerson + "DIV_MAP.INI";
                }

                //  Opens Dialog box 
                frmLogin oLoginDialog = new frmLogin();
                DialogResult drLoginDialog;
                drLoginDialog = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow.Handle, oLoginDialog, true);

                if (drLoginDialog == DialogResult.OK)
                {
                    strUserID = oLoginDialog.DBCurrentUser;
                    Adds._strUserID = strUserID;
                    strPwd = oLoginDialog.DBPwd;
                    strConn = oLoginDialog.DBName;
                    strAppID = oLoginDialog.AppID;
                    strAppPwd = oLoginDialog.AppPwd;
                    strSecLevel = oLoginDialog.DBDescription;
                    strRoles = oLoginDialog.DBRole;
                    intDBConnStatus = oLoginDialog.DBConnStatus;
                    strAppID = oLoginDialog.AppID;
                    strAppPwd = oLoginDialog.AppPwd;


                    // Adds or updates reg keys under HKEY_LOCAL_MACHINE  at MyKey = "\Machine\Software\Southern Company\AddsPlot\" & Format(MyDate, "yyyymmdd")
                    int? iSpace = g_strApplName.IndexOf(" ");
                    int iSpacePos = iSpace ?? 0;

                    switch (g_strApplName.Substring(0, iSpacePos).ToUpper())
                    {
                        case "ADDS":
                            strBaseKey = @"Software\Southern Company\Adds\" + DateTime.Now.ToString("yyyMMdd");
                            strCleanUpKey = @"Software\Southern Company\Adds\";
                            break;
                        case "ADDSPLOT":
                            strBaseKey = @"Software\Southern Company\AddsPlot\" + DateTime.Now.ToString("yyyMMdd");
                            strCleanUpKey = @"Software\Southern Company\AddsPlot\";
                            break;
                    }

                    RegistryKey rgk = Registry.LocalMachine.CreateSubKey(strBaseKey);
                    rgk.SetValue(@"mthUsrID", strUserID);
                    rgk.SetValue(@"mthPsWrd", strPwd);
                    rgk.SetValue(@"mthdBcon", strConn);
                    rgk.SetValue(@"mthScLvl", strSecLevel);
                    rgk.SetValue(@"mthRoleS", strRoles);

                    rgk.SetValue(@"mthAppID", strAppID);
                    rgk.SetValue(@"mthAppPwd", strAppPwd);

                    // Cleanup Registery
                    if (!string.IsNullOrEmpty(strCleanUpKey))
                    { 
                        RegistryKey rgkOurKey = Registry.LocalMachine;
                        rgkOurKey = rgkOurKey.OpenSubKey(strCleanUpKey, true);
                        foreach (string Keyname in rgkOurKey.GetSubKeyNames())
                        {
                            using (RegistryKey key = rgkOurKey.OpenSubKey(Keyname))
                            {
                                if (Keyname != DateTime.Now.ToString("yyyMMdd"))
                                {
                                    rgkOurKey.DeleteSubKeyTree(Keyname, true);
                                }
                            }
                        }
                    }

                   
                }

                // Build list to return to AutoLISP 1, strUserID ...
                rbResults = null;
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, intDBConnStatus));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strConn ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strUserID ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strPwd ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strSecLevel ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strRoles ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strAppID ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strAppPwd ?? string.Empty));
                rbResultsList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {

            }
            ed.WriteMessage("\n *** MyLoginObj_New finished at " + DateTime.Now.ToLongTimeString());
            return rbResultsList;
        }

        #endregion **** Public - AutoCAD Commands ****

        #region **** Internal - support fucntions ****
        internal static ArrayList ProcessSaveParameters(ref AcadDB.ResultBuffer args)
        {
            AcadDB.TypedValue[] arArgs = args.AsArray();

            ArrayList alInputParameters = new ArrayList();
            ArrayList alItems = null;
            ArrayList alItems2 = null;
            ArrayList alItems3 = null;

            bool bListFlag = false;
            int intIndex = -1;
            int intIndexSub = -1;

            foreach (AcadDB.TypedValue tv in arArgs)
            {
                if (tv.TypeCode == (int)Acad.LispDataType.ListBegin)
                {
                    bListFlag = true;
                    intIndex++;
                    intIndexSub++;

                    switch (intIndexSub)
                    {
                        case 0:
                            alItems = new ArrayList();
                            break;
                        case 1:
                            alItems2 = new ArrayList();
                            break;
                        case 2:
                            alItems3 = new ArrayList();
                            break;
                    }

                }
                if (tv.TypeCode == (int)Acad.LispDataType.ListEnd)
                {
                    bListFlag = false;

                    switch (intIndexSub)
                    {
                        case 0:
                            //alInputParameters.Add(alItems);
                            alInputParameters = alItems;
                            alItems = null;
                            break;
                        case 1:
                            alItems.Add(alItems2);
                            alItems2 = null;
                            break;
                        case 2:
                            alItems2.Add(alItems3);
                            alItems3 = null;
                            break;
                    }
                    intIndexSub--;
                }
                if (tv.TypeCode == (int)Acad.LispDataType.Nil)
                {
                    // do something.
                    switch (intIndexSub)
                    {
                        case 0:
                            alItems.Add(tv.Value);
                            break;
                        case 1:
                            alItems2.Add(tv.Value);
                            break;
                        case 2:
                            alItems3.Add(tv.Value);
                            break;
                        case 3:
                            alItems3.Add(tv.Value);
                            break;
                    }
                }
                if ((tv.TypeCode == (int)Acad.LispDataType.Text
                    || tv.TypeCode == (int)Acad.LispDataType.Int16
                    || tv.TypeCode == (int)Acad.LispDataType.Int32
                    || tv.TypeCode == (int)Acad.LispDataType.Double) && bListFlag)
                {
                    switch (intIndexSub)
                    {
                        case 0:
                            alItems.Add(tv.Value);
                            break;
                        case 1:
                            alItems2.Add(tv.Value);
                            break;
                        case 2:
                            alItems3.Add(tv.Value);
                            break;
                        case 3:
                            alItems3.Add(tv.Value);
                            break;
                    }
                }
            }
            return alInputParameters;
        }

        #endregion  **** Internal - support fucntions ****
    }
}
