using System;
using System.Data;
using System.Collections;
// using System.Data.OracleClient;
using System.Text;
using System.Windows.Forms;
//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadColor = Autodesk.AutoCAD.Colors;

using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;
using OracleDb = Oracle.DataAccess.Client;

namespace Adds
{
    public class AcadText
    {
        #region  *** Public Functions ***

        [Acad.CommandMethod("CreateDataLink")]
        public void CreateDataLink()
        {
            Forms.frmDataLink oReplaceBlock = new Forms.frmDataLink();
            DialogResult drDataLinkDialog;

            drDataLinkDialog = AcadAS.Application.ShowModalDialog(null, oReplaceBlock, true);
            if (drDataLinkDialog == DialogResult.OK)
            {

            }
        }

        [Acad.CommandMethod("AddText")]
        public void AddTextToDWG()
        {
            string strDeviceID = string.Empty;
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                AcadEd.PromptStringOptions psoText = new AcadEd.PromptStringOptions("\nEnter your text: ")
                {
                    AllowSpaces = true
                };
                AcadEd.PromptResult prStrText = ed.GetString(psoText);

                if (prStrText.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                        AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                        bt.Dispose();                                                                   //  Cleanup memory for AutoCAD wrapper

                        AcadDB.DBText acadText = new AcadDB.DBText()
                        {
                            Layer = "0",
                            TextString = prStrText.StringResult,
                            Height = 30,
                            Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, 256)  // 0~By Block,1-255 std Acad colors 256~By Layer
                        };

                        //  Adds new text to AutoCAD drawing database
                        btr.AppendEntity(acadText);
                        btr.Dispose();                              //  Cleanup memory for AutoCAD wrapper
                        tr.AddNewlyCreatedDBObject(acadText, true);

                        TextJig textJig = new TextJig(acadText);

                        if (textJig.Run() != AcadEd.PromptStatus.OK)
                            return;

                        strDeviceID = Utilities.GetNextDeviceID("T_");
                        Adds.SetStoredXData(acadText, "ID", strDeviceID);
                        //Adds.SetStoredXData(acadText, "CLR_NUM", txtURL.Text);
                        tr.Commit();
                    }
                }
            }
            catch (SystemException sx)
            {
                MessageBox.Show(sx.ToString(), "System Exception");
            }

        }

        #endregion  *** Public Functions ***


        #region *** Internal Functions ***

        internal static void DrawPanelText(string strPanel, ref AcadAS.Document doc, ref AcadDB.Database dbDwg, ref AcadEd.Editor ed)
        {
            //ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            //string strPanel = alInputParameters[0].ToString();
            ed.WriteMessage("\nInsertPanelText - started for panel: " + strPanel);
            
            
            DataSet dsText = GetTextInfoFromAddsDB(strPanel); // GetTextInfoFromTMap();

            foreach (DataRow oRow in dsText.Tables["Text"].Rows)
            {
                using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                    AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                    bt.Dispose();                                                                   //  Cleanup memory for AutoCAD wrapper

                    AcadDB.DBText acadText = new AcadDB.DBText();

                    Utilities.CheckLayer(oRow["adds_layer_nam"].ToString());
                    acadText.Layer = oRow["adds_layer_nam"].ToString();
                    acadText.TextString = oRow["txtvalue"].ToString();   //"This is a test";


                    //acadText.TextStyle = AcadDB.tex oRow["Adds_Style"].ToString();
                    
                    AcadGeo.Point3d ptTemp = new AcadGeo.Point3d(double.Parse(oRow["txtnpntx"].ToString()), double.Parse(oRow["txtnpnty"].ToString()), 0);
                    
                    if (oRow["txthorzflag"].ToString() == "0" && oRow["txtvertflag"].ToString() == "2")  // 0 was 1
                    {
                        acadText.HorizontalMode = Autodesk.AutoCAD.DatabaseServices.TextHorizontalMode.TextCenter;
                        acadText.VerticalMode = Autodesk.AutoCAD.DatabaseServices.TextVerticalMode.TextVerticalMid;
                        acadText.AlignmentPoint = ptTemp;
                    }
                    else
                    {
                        acadText.HorizontalMode = Autodesk.AutoCAD.DatabaseServices.TextHorizontalMode.TextLeft;
                        acadText.Position = ptTemp;
                    }

                    //AcadGeo.Point3d ptTemp2 = new AcadGeo.Point3d(double.Parse(oRow["txtjpntx"].ToString()), double.Parse(oRow["txtjpnty"].ToString()), 0);
                    //acadText.AlignmentPoint = ptTemp;
                    //acadText.AlignmentPoint = ptTemp2;
                    acadText.Height = double.Parse(oRow["txthgt"].ToString());
                    acadText.Rotation = double.Parse(oRow["txtrot"].ToString()); // *(Math.PI / 180);

                    DataRow[] oRowsXData = dsText.Tables["XData"].Select("Device_ID = '" + oRow["Device_ID"].ToString() + "'");
                    foreach (DataRow oRowXData in oRowsXData)
                    {
                        Adds.SetStoredXData(acadText, oRowXData["xdtname"].ToString(), oRowXData["xdtvalue"].ToString());
                        if (oRowXData["xdtname"].ToString() == "CLR_NUM")
                        {
                            acadText.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci,
                                    Utilities.GetAddsColorNumFromEMBColor(short.Parse(oRowXData["xdtvalue"].ToString())));
                        }
                    }

                    btr.AppendEntity(acadText);
                    btr.Dispose();                                                                  //  Cleanup memory for AutoCAD wrapper

                    tr.AddNewlyCreatedDBObject(acadText, true);
                    acadText.Dispose();                                                             //  Cleanup memory for AutoCAD wrapper

                    tr.Commit();
                    tr.Dispose();
                }
            }
            ed.WriteMessage("\nInsertPanelText - done for panel: " + strPanel + "\n");
            ed.Regen();

        }
        
        internal static DataSet GetTextInfoFromAddsDB(string Panel)
        {
            DataSet dsResults = null;
            //DataTable dtResults = null;
            string strOracleConn = Adds._strConn;
            string PanelName = Panel; 

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT lp.panel_name, omd.device_id,  ");   //ora.xdtname, ora.xdtvalue,
            sbSQL.Append("  ot.txtdatatype, ot.txthandle, ot.adds_layer_nam, ot.txtvalue, ot.Adds_Style,  ot.txtnpntx, ");
            sbSQL.Append("  ot.txtnpnty, ot.txtnpntz, ot.txtjpntx, ot.txtjpnty, ot.txtjpntz, ");
            sbSQL.Append("  ot.txtthick, ot.txthgt, ot.txtrot, ot.txtspace, ot.txtflag, ot.txthorzflag, ot.txtvertflag ");
            sbSQL.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjTxt ot ");  //, AddsDB.ObjRgApp ora
            sbSQL.Append("WHERE UPPER(lp.panel_name) = :panelName ");  
            sbSQL.Append("  AND lp.adds_panel_id = omd.adds_panel_id ");
         //   sbSQL.Append("  AND omd.device_id = ora.device_id ");
            sbSQL.Append("  AND omd.device_id = ot.device_id ");
            sbSQL.Append("ORDER BY lp.panel_name, omd.device_id ");

            StringBuilder sbSQLXData = new StringBuilder();
            sbSQLXData.Append("SELECT lp.panel_name, omd.device_id, ora.xdtname, ora.xdtvalue ");
            sbSQLXData.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjTxt op, AddsDB.ObjRgApp ora ");
            sbSQLXData.Append("WHERE UPPER(lp.panel_name) = :panelName ");
            sbSQLXData.Append("     AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQLXData.Append("     AND omd.device_id = op.device_id ");
            sbSQLXData.Append("     AND op.device_id = ora.device_id ");
            sbSQLXData.Append("ORDER BY op.device_id, ora.xdtname, ora.xdtvalue ");

            try
            {
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand
                    {
                        Connection = oracleConn,
                        CommandType = CommandType.Text,
                        CommandText = sbSQL.ToString()
                    };

                    oracleCommand.Parameters.Add("panelName", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = PanelName;

                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "Text");
                    da.Fill(ds);

                    oracleCommand.CommandText = sbSQLXData.ToString();
                    OracleDb.OracleDataAdapter daXdata = new OracleDb.OracleDataAdapter(oracleCommand);
                    daXdata.TableMappings.Add("Table", "XData");
                    daXdata.Fill(ds);
                    ds.Relations.Add("Text2Xdata",
                                        ds.Tables["Text"].Columns["device_id"],
                                        ds.Tables["XData"].Columns["device_id"]);
                    dsResults = ds;
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

            return dsResults;
        }

        internal static DataSet GetTextInfoFromTMap()
        {
            DataSet dsResults = null;
            //DataTable dtResults = null;
            string strOracleConn = Adds._strConn;
            string PanelName = "CRGFLDC";  //'5703576' '6843560' "3903392" "5163704" "CARVILD"

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT DISTINCT tgo.Data_Des as txtvalue, tgo.device_id, (tgo.scale_factor/10) AS txthgt, tgo.rotation_angle AS txtrot, '000000000015' AS adds_layer_nam, ");
            sbSQL.Append("  ROUND(Addsdb.Get_RePosG_X(tgo.x1), 3) AS txtnpntx,   ROUND(Addsdb.Get_RePosG_Y(tgo.Y1),3) AS txtnpnty,  ");
            sbSQL.Append("  null AS xdtname, null as xdtvalue ");
            sbSQL.Append("FROM TMap.Graphic_Object tgo ");
            sbSQL.Append("WHERE tgo.device_id LIKE 'T%' AND tgo.deleted_ind = 0 AND tgo.x1 > -32658.93 AND tgo.x1 < 28285.2 AND tgo.y1 > -162617.59 AND tgo.y1 < -127617.59 ");
            //sbSQL.Append("ORDER BY lp.panel_name, omd.device_id ");


            try
            {
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();                              // [ABANDON CODE]

                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand
                    {
                        Connection = oracleConn,
                        CommandType = CommandType.Text,
                        CommandText = sbSQL.ToString()
                    };

                    oracleCommand.Parameters.Add("panelName", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = PanelName;

                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "Text");
                    da.Fill(ds);

                    dsResults = ds;
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

            return dsResults;

        }

        #endregion *** Internal Functions ***

    }
}
