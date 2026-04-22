//using System;
using System.Collections;
//using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Data;
using System.Windows.Forms;
using System.IO;
using System.Security.Cryptography;

using Microsoft.Win32;

using OracleDb = Oracle.DataAccess.Client;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad      = Autodesk.AutoCAD.Runtime;
using AcadAS    = Autodesk.AutoCAD.ApplicationServices;
using AcadDB    = Autodesk.AutoCAD.DatabaseServices;
using AcadEd    = Autodesk.AutoCAD.EditorInput;
using AcadGeo   = Autodesk.AutoCAD.Geometry;
using AcadWin   = Autodesk.AutoCAD.Windows;
using AcadColor = Autodesk.AutoCAD.Colors;
using AcadPS    = Autodesk.AutoCAD.PlottingServices;
using System;

namespace Adds
{
    public partial class Utilities
    {
        private static string _strNewLayerName = null;

        #region **** Public - AutoCAD Commands ****

        //  Acad.CommandFlags.UsePickSet    ~ tells AutoCAD to not clear the pickfirst set if there is one already selected.
        //  Acad.CommandFlags.Redraw        ~ Objects in these sets are redrawn with the proper grip handles and highlighting upon completion of the command
        //  Acad.CommandFlags.Modal         ~ tells AutoCAD the command cannot be invoked while another command is active.
        [Acad.CommandMethod("CFT",
            Acad.CommandFlags.UsePickSet | Acad.CommandFlags.Redraw | Acad.CommandFlags.Modal)]
        public static void ChangeToFixedText()
        {
            string strEntityType = null;
            int stat = 0;

            try
            {
                string strDate = Adds.GetStorDate();

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Gets pickfirst set if there is one already selected.
                AcadEd.PromptSelectionResult psrText = ed.SelectImplied();

                //  Checks to see if pickfirst set is available, if not gets user to select drawing objects.
                if (psrText.Status == AcadEd.PromptStatus.Error)
                {
                    //  Ask user to select entities
                    AcadEd.PromptSelectionOptions psoText = new AcadEd.PromptSelectionOptions();
                    psoText.MessageForAdding = "\nSelect Text to change to Fixed Text for IDMS: ";
                    psrText = ed.GetSelection(psoText);
                }
                else
                {
                    //  if there was a pickfirst set, clear it
                    ed.SetImpliedSelection(new AcadDB.ObjectId[0]);
                }

                if (psrText.Status == AcadEd.PromptStatus.OK)
                {
                    //  Gets user's NT ID
                    AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("MyUsrInfo", ref stat);
                    ArrayList alResults = Adds.ProcessInputParameters(rbResults);

                    //  Checks if layer exists if not then it adds the layer
                    Utilities.CheckLayer("----FT----");

                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.ObjectId[] objIds = psrText.Value.GetObjectIds();
                        foreach (AcadDB.ObjectId objID in objIds)
                        {
                            AcadDB.Entity ent = tr.GetObject(objID, AcadDB.OpenMode.ForWrite) as AcadDB.Entity;
                            strEntityType = ent.GetType().Name;
                            switch (strEntityType)
                            {
                                case "DBText":
                                    ent.Layer = "----FT----";
                                    ent.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, 4);

                                    //  Set XData for Text
                                    ArrayList al2 = alResults[0] as ArrayList;
                                    Adds.SetStoredXData(ent, "LINE_ID", "----FT----");
                                    Adds.SetStoredXData(ent, "FT", al2[2].ToString());
                                    Adds.SetStoredXData(ent, "EDIT_DTM", strDate);
                                    break;
                            }
                        }
                        tr.Commit();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.LispFunction("CheckURL")]
        public AcadDB.ResultBuffer CheckURLPath(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            string strURLIn = null;
            string strURLOut = null;
            try
            {
                strURLIn = alInputParameters[0].ToString();
                strURLOut = strURLIn.Replace("'", "");

                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                if (!string.IsNullOrEmpty(strURLOut))
                {
                    rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strURLOut));
                }
                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return rbResults;
        }

        [Acad.CommandMethod("CalLatLong")]
        public void CreateDataLink()
        {
            frmLatLongCals oCalLatLong = new frmLatLongCals();
            DialogResult drCalLatLong;

            //drCalLatLong = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow, oCalLatLong, true);
            drCalLatLong = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow.Handle, oCalLatLong, true);
            if (drCalLatLong == DialogResult.OK)
            {

            }
        }

        [Acad.CommandMethod("ChangeMultipleObjectLayer", Acad.CommandFlags.UsePickSet | Acad.CommandFlags.Redraw | Acad.CommandFlags.Modal)]
        public static void ChangeMultipleObjectLayer()
        {
            string strEntityType = null;
            string strLayerName = null;
            string strNewLayerName = null;

            AcadDB.BlockReference br = null;
            AcadDB.Polyline2d p2d = null;
            AcadDB.DBText brText = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<or"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, "AR001*,AR002*,AR003*,AR004*,AR005*,AR006*,AR007*"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, "AR001*,AR002*,AR003*,AR004*,AR005*,AR006*,AR007*"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "TEXT"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, "AR001*,AR002*,AR003*,AR004*,AR005*,AR006*,AR007*"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "or>")
                };

                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);


                //  Gets pickfirst set if there is one already selected.
                AcadEd.PromptSelectionResult psrText = ed.SelectImplied();

                //  Checks to see if pickfirst set is available, if not gets user to select drawing objects.
                if (psrText.Status == AcadEd.PromptStatus.Error)
                {
                    //  Ask user to select entities
                    AcadEd.PromptSelectionOptions psoBlocks = new AcadEd.PromptSelectionOptions();
                    psoBlocks.MessageForAdding = "\nSelect Blocks to change : ";
                    psrText = ed.GetSelection(psoBlocks, sFilter);
                }
                else
                {
                    //  if there was a pickfirst set, clear it
                    ed.SetImpliedSelection(new AcadDB.ObjectId[0]);
                }

                if (psrText.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.ObjectId[] objIds = psrText.Value.GetObjectIds();
                        foreach (AcadDB.ObjectId objID in objIds)
                        {
                            AcadDB.Entity ent = tr.GetObject(objID, AcadDB.OpenMode.ForWrite) as AcadDB.Entity;
                            strEntityType = ent.GetType().Name;
                            switch (strEntityType)
                            {
                                case "BlockReference":
                                    br = ent as AcadDB.BlockReference;
                                    strLayerName = br.Layer;
                                    strNewLayerName = "AR008" + strLayerName.Substring(5);
                                    Utilities.CheckLayer(strNewLayerName);
                                    br.Layer = strNewLayerName;
                                    break;
                                case "Polyline2d":
                                    p2d = ent as AcadDB.Polyline2d;
                                    strLayerName = p2d.Layer;
                                    strNewLayerName = "AR008" + strLayerName.Substring(5);
                                    Utilities.CheckLayer(strNewLayerName);
                                    p2d.Layer = strNewLayerName;
                                    break;
                                case "DBText":
                                    brText = ent as AcadDB.DBText;
                                    strLayerName = brText.Layer;
                                    strNewLayerName = "AR008" + strLayerName.Substring(5);
                                    Utilities.CheckLayer(strNewLayerName);
                                    brText.Layer = strNewLayerName;
                                    break;
                            }
                        }
                        tr.Commit();
                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("FindEED2")]
        public static void FindEED()
        {
            string strDeviceID = null;
            string strDeviceIDCheck = null;
            AcadEd.SelectionSet ssID;
            AcadDB.ViewTableRecord newVP = new AcadDB.ViewTableRecord();


            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadEd.PromptStringOptions pso = new AcadEd.PromptStringOptions("Enter DeviceID to search for: ");
                AcadEd.PromptResult pr = ed.GetString(pso);
                if (pr.Status == AcadEd.PromptStatus.OK)
                {
                    strDeviceID = pr.StringResult.ToString();
                    AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                    {
                        new AcadDB.TypedValue((int) AcadDB.DxfCode.Start, "INSERT"),
                        new AcadDB.TypedValue((int) AcadDB.DxfCode.XDataStart),
                        new AcadDB.TypedValue((int) AcadDB.DxfCode.ExtendedDataRegAppName, "ID"),
                    };
                    AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
                    AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                    if (pSelectResult.Status == AcadEd.PromptStatus.OK)
                    {
                        ssID = pSelectResult.Value;
                        using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
                        {
                            foreach (AcadDB.ObjectId objID in ssID.GetObjectIds())
                            {
                                AcadDB.DBObject dbObj = tr.GetObject(objID, AcadDB.OpenMode.ForRead);
                                AcadDB.ResultBuffer rb = dbObj.XData;
                                if (rb != null)
                                {
                                    bool flagReadNext = false;
                                    foreach (AcadDB.TypedValue tv in rb)
                                    {
                                        if (tv.Value.ToString() == "ID")
                                        {
                                            flagReadNext = true;
                                        }
                                        if (flagReadNext && (tv.Value.ToString() != "ID"))
                                        {
                                            strDeviceIDCheck = tv.Value.ToString();
                                            if (strDeviceIDCheck == strDeviceID)
                                            {
                                                AcadDB.Entity ent = dbObj as AcadDB.Entity;
                                                AcadDB.Extents3d ext = ent.GeometricExtents;

                                                ext.TransformBy(ed.CurrentUserCoordinateSystem.Inverse());

                                                AcadGeo.Point2d minPt = new AcadGeo.Point2d(ext.MinPoint.X, ext.MinPoint.Y);
                                                AcadGeo.Point2d maxPt = new AcadGeo.Point2d(ext.MaxPoint.X, ext.MaxPoint.Y);

                                                newVP.CenterPoint = minPt + ((maxPt - minPt) / 2.0);
                                                newVP.Height = maxPt.Y - minPt.Y;
                                                newVP.Width = maxPt.X - minPt.X;

                                                goto FoundIt;
                                            }
                                            flagReadNext = false;
                                        }
                                    }
                                }
                            }
                            FoundIt:
                            ed.SetCurrentView(newVP);
                            tr.Commit();
                        }
                    }
                }



            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        public class Device
        {
            public string ID { get; set; }
        }

        [Acad.CommandMethod("CompLstID2")]
        public static void CompLstID()
        {
            int stat = 0;
            AcadEd.SelectionSet ssID;
            string strDeviceID = null;

            StringBuilder sbSQLDeviceIDs = new StringBuilder();
            DataTable dtDeviceIDs = null;

            ArrayList alDeviceIDs = new ArrayList();

            try
            {


                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Get Panel List
                AcadDB.ResultBuffer rbResults2 = Adds.AcadGetSystemVariable("PanLst", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults2);
                ArrayList alPanelList = (ArrayList)alResults[0];

                //  Get Division for linetypes to be used.
                AcadDB.ResultBuffer rbResults3 = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults3 = Adds.ProcessInputParameters(rbResults3);
                string strDiv = alResults3[0].ToString();

                //  Check to make sure only one panel is open
                if (alPanelList.Count == 1)
                {
                    string strPanLst = Utilities.DecodeListParameter(alPanelList);

                    //  Filter to get all drawing objects with DeviceID EED

                    AcadDB.TypedValue[] tvFilterValuesTrans = new AcadDB.TypedValue[]
                    {
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<or"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE"),
                                       new AcadDB.TypedValue((int) AcadDB.DxfCode.XDataStart),
                                            new AcadDB.TypedValue((int) AcadDB.DxfCode.ExtendedDataRegAppName, "ID"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int) AcadDB.DxfCode.Start, "INSERT"),
                                        new AcadDB.TypedValue((int) AcadDB.DxfCode.XDataStart),
                                        new AcadDB.TypedValue((int) AcadDB.DxfCode.ExtendedDataRegAppName, "ID"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "TEXT"),
                                        new AcadDB.TypedValue((int) AcadDB.DxfCode.XDataStart),
                                        new AcadDB.TypedValue((int) AcadDB.DxfCode.ExtendedDataRegAppName, "ID"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "or>")
                    };

                    AcadDB.TypedValue[] tvFilterValuesDist = new AcadDB.TypedValue[]
                        {
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<or"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, "????CK-*"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int) AcadDB.DxfCode.Start, "INSERT"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName,"A###,A###S"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "TEXT"),
                                 new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "or>")
                        };

                    AcadEd.SelectionFilter sFilter;
                    if (strDiv == "GA" || strDiv == "AL")
                    {
                        sFilter = new AcadEd.SelectionFilter(tvFilterValuesTrans);
                    }
                    else
                    {
                        sFilter = new AcadEd.SelectionFilter(tvFilterValuesDist);
                    }

                    AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                    // Gets all unique drawing Device ID's
                    if (pSelectResult.Status == AcadEd.PromptStatus.OK)
                    {
                        ssID = pSelectResult.Value;
                        using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
                        {
                            foreach (AcadDB.ObjectId objID in ssID.GetObjectIds())
                            {
                                AcadDB.DBObject dbObj = tr.GetObject(objID, AcadDB.OpenMode.ForRead);
                                AcadDB.ResultBuffer rb = dbObj.XData;
                                if (rb != null)
                                {
                                    bool flagReadNext = false;
                                    foreach (AcadDB.TypedValue tv in rb)
                                    {
                                        if (tv.Value.ToString() == "ID")
                                        {
                                            flagReadNext = true;
                                        }
                                        if (flagReadNext && (tv.Value.ToString() != "ID"))
                                        {
                                            strDeviceID = tv.Value.ToString();
                                            if (!alDeviceIDs.Contains(strDeviceID))
                                            {
                                                alDeviceIDs.Add(new Device { ID = strDeviceID });
                                            }
                                            else
                                            {
                                            }
                                            flagReadNext = false;
                                        }
                                    }
                                }
                            }
                            // alDeviceIDs.Sort();
                            ed.WriteMessage("Processing {" + alDeviceIDs.Count.ToString() + "} Devices in Adds drawing panel \n");
                        }
                    }

                    //  Get list of all Device ID's from Oracle for the panel
                    sbSQLDeviceIDs.Append("SELECT omd.Device_Id ");
                    sbSQLDeviceIDs.Append("FROM AddsDB.Lu_Panel lp, AddsDB.ObjMstDev omd ");
                    sbSQLDeviceIDs.Append("WHERE lp.Panel_Name = '" + strPanLst + "' AND lp.Adds_Panel_Id = omd.Adds_Panel_Id ");
                    sbSQLDeviceIDs.Append("ORDER BY omd.Device_Id ");

                    dtDeviceIDs = GetResults(sbSQLDeviceIDs, Adds._strConn);            //
                    ed.WriteMessage("Processing {" + dtDeviceIDs.Rows.Count.ToString() + "} Devices in Adds databse \n");

                    var queryNotInOracle = from Device d in alDeviceIDs
                                           let orcaleIDs = from oraID in dtDeviceIDs.AsEnumerable()
                                                           select oraID.Field<string>("Device_Id")
                                           where orcaleIDs.Contains(d.ID) == false
                                           select d.ID;

                    var queryNotInAdds = (from oraID in dtDeviceIDs.AsEnumerable()
                                          let AddsIDs = from Device d in alDeviceIDs
                                                        select d.ID
                                          where AddsIDs.Contains(oraID.Field<string>("Device_Id")) == false
                                          select oraID);

                    ed.WriteMessage("Missing {" + queryNotInOracle.Count().ToString() + "} ID's from Oracle \n");
                    ed.WriteMessage("Missing {" + queryNotInAdds.Count().ToString() + "} ID's from Adds \n");

                    ArrayList alIDsNotInAdds = new ArrayList();
                    foreach (DataRow dr in queryNotInAdds)
                    {
                        alIDsNotInAdds.Add(dr[0].ToString());
                    }

                    string path = @"C:\Adds\ZommBee.txt";
                    using (StreamWriter sw = File.CreateText(path))
                    {
                        foreach (string id in alIDsNotInAdds)
                        {
                            sw.WriteLine(id);
                        }
                    }

                    if (alIDsNotInAdds.Count > 0)
                    {
                        using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                        {
                            oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String 
                            OracleDb.OracleCommand ocmdDestroyer = oracleConn.CreateCommand();
                            ocmdDestroyer.CommandText = "AddsDB.AddsDB_DESTROYER.DEL_OBJECT_BY_ID";
                            ocmdDestroyer.CommandType = CommandType.StoredProcedure;
                            ocmdDestroyer.ArrayBindCount = alIDsNotInAdds.Count;
                            ocmdDestroyer.BindByName = true;
                            //                        ocmdDestroyer.Transaction = ot;

                            string strBaseKey = @"Software\Southern Company\Adds\" + DateTime.Now.ToString("yyyMMdd");
                            RegistryKey rgk = Registry.LocalMachine.CreateSubKey(strBaseKey);
                            string strUserID = rgk.GetValue(@"mthUsrID").ToString();

                            string[] strDevIDs = (string[])alIDsNotInAdds.ToArray(typeof(string));
                            ArrayList alTemp1 = new ArrayList();
                            ArrayList alTemp2 = new ArrayList();
                            DateTime dtNowTimeStamp = DateTime.Now;
                            for (int index = 1; index <= alIDsNotInAdds.Count; index++)
                            {
                                alTemp1.Add(dtNowTimeStamp);
                                alTemp2.Add(strUserID);
                            }
                            DateTime[] strDate = (DateTime[])alTemp1.ToArray(typeof(DateTime));
                            string[] strNTID = (string[])alTemp2.ToArray(typeof(string));
                            // Create parameters
                            OracleDb.OracleParameter opDeviceID = new OracleDb.OracleParameter("n_DeviceID", OracleDb.OracleDbType.Varchar2, 25, ParameterDirection.Input);
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

                    //  Save the panel
                    StringBuilder sbCommand = new StringBuilder();
                    sbCommand.Append("(SavClosEm)");
                    //     Adds.AcadLispFunction(sbCommand);

                }
                else
                {
                    ed.WriteMessage("Error - You can only rebuild one panel at a time. Please close all panels except the one you want to rebuild.");
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("DrawingClose")]
        public static void DrawingCose()
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {

                //AcadAS.DocumentExtension.CloseAndDiscard(doc);

                //AcadAS.DocumentCollection docMgr = AcadAS.Application.DocumentManager;
                //AcadAS.Document document = docMgr .Add("");

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
          

            
        }

        #endregion **** Public - AutoCAD Commands ****

        #region **** Public - AutoCAD LispFunctions ****

        [Acad.LispFunction("BlockPanelTest")]
        public static void BlockPanelTest(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            string panelName = alInputParameters[0].ToString();

            AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();
            pts = GetPanelMinMaxPts(panelName);

            //  Build filter for obtaining every block except Grid or Lock blocks
            AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<AND"),
                        new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<NOT"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<OR"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName, "GRID"),
                                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName, "LOCK"),
                                new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "OR>"),
                            new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "NOT>"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "AND>")
                };
            CollectionStrips(pts, tvFilterValues, 250);
        }

        [Acad.LispFunction("BreakPan2")]
        public static AcadDB.ResultBuffer BreakPanel(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            string strAddsPanel = alInputParameters[0].ToString();

            AcadEd.SelectionSet ssIn = alInputParameters[1] as AcadEd.SelectionSet;

            //  Get Panel Min & Max points
            AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();
            pts = GetPanelMinMaxPts(strAddsPanel);

            return rbResults;
        }

        [Acad.LispFunction("Go_ChgFdr2")]
        public void ChangeObjectLayerBySubSet(AcadDB.ResultBuffer args)
        {
            AcadDB.BlockReference blockRef;
            AcadDB.Polyline2d pline2d;
            AcadDB.DBText dBText = null;

            string strNewBaseLayer = string.Empty;
            string strNewAttributeLayer = null;
            string strOldBaseLayer = string.Empty;
            string strFeederkVCode = string.Empty;

            try
            {
                //  Decode passed in parameters from LISP call
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                AcadEd.SelectionSet ssIn = alInputParameters[0] as AcadEd.SelectionSet;
                string strFeederCode = alInputParameters[1].ToString();
                string strFeederColor = alInputParameters[2].ToString();
                if (alInputParameters.Count >= 4)
                {
                    strFeederkVCode = alInputParameters[3].ToString();
                }

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Get ObjectIDs of passed in selection set
                AcadDB.ObjectIdCollection objectIDColl = new AcadDB.ObjectIdCollection();
                objectIDColl = new AcadDB.ObjectIdCollection(ssIn.GetObjectIds());

                //  Starts transaction to update Acad Object Database
                using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
                {
                    foreach (AcadDB.ObjectId oID in objectIDColl)
                    {
                        AcadDB.DBObject dbObj = tr.GetObject(oID, AcadDB.OpenMode.ForWrite);
                       
                        switch(dbObj.GetType().Name)
                        {
                            case "BlockReference":
                                blockRef = dbObj as AcadDB.BlockReference;

                                //  Get new layer name and create it if it does not exists
                                strOldBaseLayer = blockRef.Layer;
                                strNewBaseLayer = GetNewLayerNameBy(strOldBaseLayer, strFeederCode, strFeederkVCode);
                                CheckLayer(strNewBaseLayer);

                                //  Change layer name
                                blockRef.Layer = strNewBaseLayer;

                                //  Get new layer name for the attributes
                                strNewAttributeLayer = strNewBaseLayer.Substring(0, 6) + "D" + strNewBaseLayer.Substring(7);
                                Utilities.CheckLayer(strNewAttributeLayer);

                                //  Change all the attribute layer names
                                foreach (AcadDB.ObjectId arId in blockRef.AttributeCollection)
                                {
                                    AcadDB.AttributeReference ar = (AcadDB.AttributeReference)tr.GetObject(arId, AcadDB.OpenMode.ForWrite);
                                    ar.Layer = strNewAttributeLayer;
                                }
                                break;

                            case "Polyline2d":
                                pline2d = dbObj as AcadDB.Polyline2d;

                                //  Get new layer name and create it if it does not exists
                                strOldBaseLayer = pline2d.Layer;
                                strNewBaseLayer = GetNewLayerNameBy(strOldBaseLayer, strFeederCode, strFeederkVCode);
                                CheckLayer(strNewBaseLayer);

                                //  Change layer name
                                pline2d.Layer = strNewBaseLayer;

                                //  Change all vertex layer names
                                foreach (AcadDB.ObjectId vId in pline2d)
                                {
                                    AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForWrite);
                                    //  If node layer is not the same as the polyline definition change the node layer name to match.
                                    if (v2d.Layer != strNewBaseLayer)
                                    {
                                        v2d.Layer = strNewBaseLayer;
                                    }
                                }
                                break;

                            case "DBText":
                                dBText = dbObj as AcadDB.DBText;

                                //  Get new layer name and create it if it does not exists
                                strOldBaseLayer = dBText.Layer;
                                strNewBaseLayer = GetNewLayerNameBy(strOldBaseLayer, strFeederCode, strFeederkVCode);
                                CheckLayer(strNewBaseLayer);

                                //  Change layer name
                                dBText.Layer = strNewBaseLayer;

                                break;
                        }
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        internal static string GetDivision()
        {
            string strDiv = string.Empty;
            int stat = 0;

            //  Get current Division
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            strDiv = alResults[0].ToString();

            return strDiv;
        }

        internal static string GetNewLayerNameBy(string OldLayer, string FeederCode, string kVCode)
        {
            int stat = 0;
            string strNewLayerName = string.Empty;

            try
            {
                //  Get Division for linetypes to be used.
                AcadDB.ResultBuffer rbResults3 = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults3 = Adds.ProcessInputParameters(rbResults3);
                string strDiv = alResults3[0].ToString();

                if (strDiv != "AL" || strDiv != "GA")
                {
                    if (string.IsNullOrEmpty(kVCode))                                           //  DTS not Transmission
                    {
                        strNewLayerName = FeederCode + OldLayer.Substring(3, 7);                    //  Same Voltage as original feeder/line         
                    }
                    else
                    {
                        strNewLayerName = FeederCode + OldLayer.Substring(3, 5) + kVCode;           //  New Voltage
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(kVCode))                                           //  Is Transmission
                    {
                        strNewLayerName = "0000" + FeederCode + OldLayer.Substring(9, 2);           //  Same Voltage as original line
                    }
                    else
                    {
                        strNewLayerName = "0000" + FeederCode + kVCode;                             //  New Voltage
                    }
                }
            
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return strNewLayerName;
        }

        [Acad.LispFunction("ChangeObjectLayer")]
        public void ChangeObjectLayer(AcadDB.ResultBuffer args)
        {
            string strEntityType = null;
            string strLayerName = null;
            string strNewLayerName = null;

            AcadDB.Polyline2d p2d = null;
            AcadDB.BlockReference br = null;
            AcadDB.DBText brText = null;
            AcadDB.DBObject obj = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;


                //  Prompt User to select a Substation block to get layer name.
                AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect either Powerline or Symbol to get information from: ");
                peo.SetRejectMessage("\nYou need to select a polyline or symbol");
                peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
                peo.AddAllowedClass(typeof(AcadDB.Polyline2d), false);
                peo.AddAllowedClass(typeof(AcadDB.DBText), false);

                AcadEd.PromptEntityResult per = ed.GetEntity(peo);
                if (per.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        //  Gets information on the selected object ie. Layer Name
                        obj = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForWrite);
                        strEntityType = obj.GetType().Name;
                        switch (strEntityType)
                        {
                            case "Polyline2d":
                                p2d = obj as AcadDB.Polyline2d;
                                strLayerName = p2d.Layer;
                                break;
                            case "BlockReference":
                                br = obj as AcadDB.BlockReference;
                                strLayerName = br.Layer;

                                break;
                            case "DBText":
                                brText = obj as AcadDB.DBText;
                                strLayerName = brText.Layer;
                                break;
                        }

                        //  Opens Dialog box and seeds with existing layer information
                        frmLineDialog oLineDialog = new frmLineDialog("Circuit/Block Change Layer", Constants.MODE_EDIT, strLayerName);
                        DialogResult drLineDialog;
                        //drLineDialog = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow, oLineDialog, true);
                        drLineDialog = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow.Handle, oLineDialog, true);

                        if (drLineDialog == DialogResult.OK)
                        {
                            strNewLayerName = oLineDialog.Layer;
                            oLineDialog.Dispose();

                            //  Checks to make sure a new layer name is returrn from the dialog box.
                            if (!string.IsNullOrEmpty(strNewLayerName))
                            {
                                Utilities.CheckLayer(strNewLayerName);

                                if (strLayerName != strNewLayerName)
                                {
                                    switch (strEntityType)
                                    {
                                        case "Polyline2d":
                                            p2d.Layer = strNewLayerName;
                                            p2d.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 256);
                                            break;
                                        case "BlockReference":
                                            br.Layer = strNewLayerName;
                                            br.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 256);
                                            break;
                                        case "DBText":
                                            brText.Layer = strNewLayerName;
                                            brText.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 256);
                                            break;
                                    }
                                }
                            }
                        }
                        tr.Commit();
                    }
                    StringBuilder sb = new StringBuilder();
                    //sb.Append("(FixEED2 (handent \"" + br.Handle.ToString() + "\"))");
                    //Adds.AcadLispFunction(sb);
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("SetupSubDB")]
        public static void SetupSubDB()
        {
            string strPanelName = string.Empty;
            string strAddsPanelID = string.Empty;
            string strEMBPanelDesc = string.Empty;
            string strEMBPanelID = string.Empty;
            string strFacID = string.Empty;

            try
            {
                //  Opens Dialog box
                frmSpecialSub oSpecial = new frmSpecialSub();

                //frmLineDialog oLineDialog = new frmLineDialog("Circuit/Block Change Layer", Constants.MODE_EDIT, "00000000000");
                DialogResult drLineDialog;
                drLineDialog = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow.Handle, oSpecial, true);
                if (drLineDialog == DialogResult.OK)
                {
                    //_strNewLayerName = oLineDialog.Layer;
                    //strFacID = oLineDialog.Layer.Substring(0, 5);
                    //oLineDialog.Dispose();
                    strFacID = oSpecial.FacID;
                    strPanelName = oSpecial.AddsPanelName;
                    strEMBPanelDesc = oSpecial.EMBPanelName;
                }

                //  May want to look at ADDSDB & TMap DB changes here for Plant_Location table.
                //  if not there add to LU_Panels, EMB_Panel, ADDS2EMB, Update Lu_Substations 
                //strPanelName    = "A"   + strFacID.Substring(1, 4) + "DS";
                //strEMBPanelDesc = "Sub_A_"    + strFacID.Substring(1, 4) + "DS";

                string SQL_GETNEXTADDSPANELID = "SELECT MAX(lp.adds_panel_id) + 1 AS NextAddsPanelID " +
                                                "FROM AddsDB.Lu_Panel lp " +
                                                "WHERE lp.adds_panel_id BETWEEN 5200 AND 6999 ";

                //  Add new record into Lu_Panel Table
                string strSQLInsertLuPanel = string.Empty;
                strSQLInsertLuPanel += "INSERT INTO AddsDB.Lu_Panel lp ";
                strSQLInsertLuPanel += "   (lp.Panel_Name, lp.DIV_BIRMINGHAM, lp.DIV_EASTERN, lp.DIV_SOUTHERN, lp.DIV_WESTERN, lp.DIV_MOBILE, lp.DIV_SOUTHEAST, ";
                strSQLInsertLuPanel += "    lp.COMPLEVEL, lp.ADDS_PANEL_ID, lp.SHARED_AREA, lp.SHRCODE, lp.GEO_SW, lp.RETIRED_SW, ";
                strSQLInsertLuPanel += "    lp.SHR_BIRMINGHAM, lp.SHR_EASTERN, lp.SHR_SOUTHERN, lp.SHR_WESTERN, lp.SHR_MOBILE, lp.SHR_SOUTHEAST) ";
                strSQLInsertLuPanel += "VALUES ";
                strSQLInsertLuPanel += "   ('" + strPanelName + "', 0, 0, 0, 0, 0, 0, ";


                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String 
                    OracleDb.OracleCommand oracleCommand = oracleConn.CreateCommand();
                    oracleCommand.CommandType = CommandType.Text;

                    oracleCommand.CommandText = SQL_GETNEXTADDSPANELID;
                    strAddsPanelID = oracleCommand.ExecuteScalar().ToString();

                    strSQLInsertLuPanel += "    8, " + strAddsPanelID + ", 0, 0, 0, 0, ";
                    strSQLInsertLuPanel += "    0, 0, 0, 0, 0, 0)";

                    oracleCommand.CommandText = strSQLInsertLuPanel;

                    //  Insert all rows
                    int iRowsEffected = oracleCommand.ExecuteNonQuery();

                    oracleCommand.CommandText = "SELECT MAX(TO_NUMBER(ep.emb_panel_num)) + 1 AS NextEMBPanelID " +
                                                "FROM AddsDB.EMB_Panel ep ";
                    strEMBPanelID = oracleCommand.ExecuteScalar().ToString();

                    //  Add new record into EMB_Panel Table
                    string strSQLInsertEMBPanel = string.Empty;
                    strSQLInsertEMBPanel += "INSERT INTO AddsDB.EMB_Panel ep ";
                    strSQLInsertEMBPanel += "   (ep.EMB_Panel_Num, ep.EMB_Panel_Desc)";
                    strSQLInsertEMBPanel += "VALUES ";
                    strSQLInsertEMBPanel += "   (" + strEMBPanelID + ", '" + strEMBPanelDesc + "') ";

                    oracleCommand.CommandText = strSQLInsertEMBPanel;

                    //  Insert all rows
                    iRowsEffected = oracleCommand.ExecuteNonQuery();

                    //  Add new record to Adds_2_EMB Table
                    string strSQLInsertAdds2EMB = string.Empty;
                    strSQLInsertAdds2EMB += "INSERT INTO AddsDB.Adds_2_EMB a2e ";
                    strSQLInsertAdds2EMB += "   (a2e.EMB_Panel_Num, a2e.Adds_Panel_Id) ";
                    strSQLInsertAdds2EMB += "VALUES ";
                    strSQLInsertAdds2EMB += "   ('" + strEMBPanelID + "', " + strAddsPanelID + ") ";

                    oracleCommand.CommandText = strSQLInsertAdds2EMB;
                    iRowsEffected = oracleCommand.ExecuteNonQuery();

                    string strSQLUpDateSubs = string.Empty;
                    strSQLUpDateSubs += "UPDATE AddsDB.Lu_SubStations ls ";
                    strSQLUpDateSubs += "SET ls.SubDwgName = '" + strPanelName + "', ";
                    strSQLUpDateSubs += "    ls.emb_panel_name = '" + strEMBPanelDesc + "', ";
                    strSQLUpDateSubs += "    ls.adds_panel_id = '" + strAddsPanelID + "' ";
                    strSQLUpDateSubs += "WHERE ls.FAC_ID = '" + int.Parse(strFacID.Substring(1, 4)).ToString() + "' ";

                    oracleCommand.CommandText = strSQLUpDateSubs;
                    iRowsEffected = oracleCommand.ExecuteNonQuery();

                    //  TMap
                    //      Plant_Location table updates    - PlntLoc_Num = FacID for seaching or use FAC_ID
                    //                                      - Panel_Num set equal to view name ie Sub_A_Clairmont (limit 16 chars
                    //                                      - Rem_Db_Nam = current Db ie UnEmbA12
                    //                                      - Rem_Db_Panel_Num = Panel_Num
                    //                                      - OpCo_Ind = OpCo (new)
                    //                                      - Division_ID

                    //      Graphic_View updates/Adds       - 
                }
                // Add new panel to lisp Tables so it will open/load
                StringBuilder sbLispFunction = new StringBuilder();
                sbLispFunction.Append("(Tables)");
                Adds.ads_queueexpr(sbLispFunction.ToString());

                sbLispFunction.Clear();
                //sbLispFunction.Append("(GetSubT nil)");
                //Adds.ads_queueexpr(sbLispFunction.ToString());
            }
            catch (SystemException se)
            {
                MessageBox.Show(se.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("ConvertSub")]
        public static void ConvertDMCSubToTrans()
        {
            AcadDB.BlockReference blockRef;
            AcadDB.Polyline2d pline2d;
            AcadDB.DBText dbText;

            string strBaseLayerName = null;
            string strNewLayerName = null;
            string strFacID = null;


            try
            {

                if (string.IsNullOrEmpty(_strNewLayerName))
                {

                    //  Opens Dialog box
                    frmLineDialog oLineDialog = new frmLineDialog("Circuit/Block Change Layer", Constants.MODE_EDIT, "00000000000");
                    DialogResult drLineDialog;
                    drLineDialog = AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow.Handle, oLineDialog, true);
                    if (drLineDialog == DialogResult.OK)
                    {
                        strNewLayerName = oLineDialog.Layer;
                        strFacID = strNewLayerName.Substring(0, 5);
                        oLineDialog.Dispose();
                    }

                }
                else
                {
                    strNewLayerName = _strNewLayerName;

                }

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "TEXT,INSERT,POLYLINE,LWPOLYLINE")
                };
                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
                AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                // Create a collection containing the initial set of polylines
                AcadDB.ObjectIdCollection objs;
                if (pSelectResult.Status == AcadEd.PromptStatus.OK)
                {
                    objs = new AcadDB.ObjectIdCollection(pSelectResult.Value.GetObjectIds());
                }
                else
                {
                    objs = new AcadDB.ObjectIdCollection();
                }

                //  Check to see if there are any polylines in the panel, if so check them.
                if (objs.Count > 0)
                {
                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {
                        foreach (AcadDB.ObjectId PlId in objs)
                        {
                            AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForWrite);

                            switch (dbObj.GetType().Name)
                            {
                                case "Polyline2d":
                                    pline2d = dbObj as AcadDB.Polyline2d;
                                    strBaseLayerName = pline2d.Layer.ToString();
                                    if (strBaseLayerName != "0")
                                    {
                                        strNewLayerName = strNewLayerName.Substring(0, strNewLayerName.Length - 2) + strBaseLayerName.Substring(strBaseLayerName.Length - 2, 2);
                                        CheckLayer(strNewLayerName);
                                        pline2d.Layer = strNewLayerName;
                                    }
                                    break;

                                case "BlockReference":
                                    blockRef = dbObj as AcadDB.BlockReference;
                                    strBaseLayerName = blockRef.Layer.ToString();
                                    if (strBaseLayerName != "0")
                                    {
                                        strNewLayerName = strNewLayerName.Substring(0, strNewLayerName.Length - 2) + strBaseLayerName.Substring(strBaseLayerName.Length - 2, 2);
                                        //strNewLayerName = "000000000" + strBaseLayerName.Substring(strBaseLayerName.Length - 2, 2);
                                        CheckLayer(strNewLayerName);
                                        blockRef.Layer = strNewLayerName;
                                    }
                                    break;

                                case "DBText":
                                    dbText = dbObj as AcadDB.DBText;
                                    strBaseLayerName = dbText.Layer.ToString();
                                    if (strBaseLayerName != "0")
                                    {
                                        strNewLayerName = strNewLayerName.Substring(0, strNewLayerName.Length - 2) + strBaseLayerName.Substring(strBaseLayerName.Length - 2, 2);
                                        //strNewLayerName = "000000000" + strBaseLayerName.Substring(strBaseLayerName.Length - 2, 2);
                                        CheckLayer(strNewLayerName);
                                        dbText.Layer = strNewLayerName;
                                    }
                                    break;
                            }
                        }
                        tr.Commit();
                    }
                }
                AcadSymbol.CheckAttributes();
                AcadLine.CheckPolylineVertices(null);

                StringBuilder sbLispFunction = new StringBuilder();
                sbLispFunction.Append("(ChnGum T nil)");
                Adds.ads_queueexpr(sbLispFunction.ToString());

                // (ChnGum T nil) 
                // (FixEED2 nil)
            }
            catch (System.Exception se)
            {
                MessageBox.Show(se.ToString(), "System Exception");
            }
        }


        [Acad.LispFunction("CheckObjectColor")]
        public void CheckObjectColorFunction(AcadDB.ResultBuffer args)
        {
            CheckObjectColor();
        }

        [Acad.CommandMethod("CheckObjectColor")]
        public static void CheckObjectColor()
        {
            string strLayerName = null;
            string strVoltageCode = null;

            AcadDB.Polyline2d p2d = null;
            short colorPenNumber = -1;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Get Division
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();

                //  Create a filter to select all polylines in a drawing and use it to get the polylines.
                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE")
                };
                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
                AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                // Create a collection containing the initial set of polylines
                AcadDB.ObjectIdCollection objs;
                if (pSelectResult.Status == AcadEd.PromptStatus.OK)
                {
                    objs = new AcadDB.ObjectIdCollection(pSelectResult.Value.GetObjectIds());
                }
                else
                {
                    objs = new AcadDB.ObjectIdCollection();
                }

                //  Check to see if there are any polylines in the panel, if so check them.
                if (objs.Count > 0)
                {
                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {
                        foreach (AcadDB.ObjectId PlId in objs)
                        {
                            AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForWrite);

                            if (dbObj.GetType().Name == "Polyline2d")
                            {
                                p2d = dbObj as AcadDB.Polyline2d;
                                strLayerName = p2d.Layer;

                                if ((strLayerName.Length == 11) && (strDiv.ToUpper() == "GA"))
                                {
                                    if (strLayerName.EndsWith("23"))
                                    {
                                        strLayerName = strLayerName.Substring(0, 9) + "25";
                                        CheckLayer(strLayerName);
                                        p2d.Layer = strLayerName;
                                    }
                                }

                                // If Line is colored byBlock set it to color by layer {original import error for GCC}
                                if (p2d.Color.ColorMethod == AcadColor.ColorMethod.ByBlock)
                                {
                                    p2d.ColorIndex = 256;
                                }
                                // If line color is overridden check to see if the color is the same as if it where by color if so change to ByLayer to remove override
                                if (p2d.Color.ColorMethod != AcadColor.ColorMethod.ByLayer)
                                {

                                    if (strLayerName.Length == 11)
                                    {
                                        strVoltageCode = strLayerName.Substring(9, 2);
                                        switch (strVoltageCode)
                                        {
                                            case "00":              // 500kV
                                                colorPenNumber = 3;
                                                break;
                                            case "69":              // 069kV
                                            case "04":              // 004kV
                                                colorPenNumber = 5; //Blue
                                                break;

                                            case "12":              // 012kV
                                                colorPenNumber = 7;
                                                break;
                                            case "13":              // 013kV
                                                colorPenNumber = 4;
                                                break;
                                            case "15":              // 115kV
                                                colorPenNumber = 2;
                                                break;

                                            case "20":              // 020kV
                                                colorPenNumber = 1;
                                                break;
                                            case "23":              // 023kV
                                            case "25":              // 023kV
                                                colorPenNumber = 3;
                                                break;

                                            case "30":              // 230kV
                                                colorPenNumber = 4;
                                                break;
                                            case "35":              // 035kV
                                            case "38":              // 038kV
                                            case "44":              // 044kV
                                            case "46":              // 046kV
                                                colorPenNumber = 6;
                                                break;

                                            case "61":              // 161kV
                                            case "08":              // 161kV
                                                colorPenNumber = 30;
                                                break;
                                            case "99":
                                                colorPenNumber = 7;
                                                break;
                                        }
                                        //  Check line color if original line has a color override, 
                                        //  it checks to see if it is the same color as what is standard for the voltage color
                                        //  if so sets line color to colorbylayer
                                        if (p2d.Color == AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, colorPenNumber))
                                        {
                                            p2d.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 256);
                                        }
                                    }
                                }
                            }

                        }
                        tr.Commit();
                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }


        [Acad.LispFunction("MakeLayer2")]
        public static void MakeLayer(AcadDB.ResultBuffer args)
        {
            try
            {
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                string strLayerName = alInputParameters[0].ToString();

                CheckLayer(strLayerName);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.LispFunction("QueryObject")]
        public static void QueryObjectProperties(AcadDB.ResultBuffer args)
        {
            string strEntityType = null;
            string strLayerName = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Prompt User to select a Substation block to get layer name.
                AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect either Powerline or Symbol to get information from: ");
                peo.SetRejectMessage("\nYou need to select a polyline or symbol");
                peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
                peo.AddAllowedClass(typeof(AcadDB.Polyline2d), false);
                peo.AddAllowedClass(typeof(AcadDB.DBText), false);

                AcadEd.PromptEntityResult per = ed.GetEntity(peo);
                if (per.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        //  Gets information on the selected object ie. Layer Name
                        AcadDB.DBObject obj = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForRead);
                        strEntityType = obj.GetType().Name;
                        switch (strEntityType)
                        {
                            case "Polyline2d":
                                AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
                                strLayerName = p2d.Layer;
                                break;
                            case "BlockReference":
                                AcadDB.BlockReference br = obj as AcadDB.BlockReference;
                                strLayerName = br.Layer;
                                break;
                            case "DBText":
                                AcadDB.DBText brText = obj as AcadDB.DBText;
                                strLayerName = brText.Layer;
                                break;
                        }

                        //  Opens Dialog box and seeds with existing layer information
                        frmLineDialog oLineDialog = new frmLineDialog("Circuit/Block Data Query", Constants.MODE_QUERY, strLayerName);
                        DialogResult drLineDialog;
                        drLineDialog = AcadAS.Application.ShowModalDialog(null, oLineDialog, true);
                        oLineDialog.Dispose();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("ZoomExtents2")]
        public static void ZoomExtents()
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dwgDB = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            AcadGeo.Point3d minPt = dwgDB.Extmin;
            AcadGeo.Point3d maxPt = dwgDB.Extmax;

            AcadDB.ViewTableRecord newVP = new AcadDB.ViewTableRecord();
            newVP.Height = maxPt.Y - minPt.Y;
            newVP.Width = maxPt.X - minPt.X;
            AcadGeo.Point2d centerPt = new AcadGeo.Point2d(minPt.X + (newVP.Width / 2), minPt.Y + (newVP.Height / 2));

            newVP.CenterPoint = centerPt;


            ed.SetCurrentView(newVP);
        }

        [Acad.CommandMethod("MonitorWblockEvents")]
        public void MonitorWblockEvents_Method()
        {
            SubscribeToDb(Autodesk.AutoCAD.DatabaseServices.HostApplicationServices.WorkingDatabase);
        }

        public static void SubscribeToDb(AcadDB.Database db)
        {
            db.BeginWblockObjects += new AcadDB.BeginWblockObjectsEventHandler(db_BeginWblockObjects);
            db.BeginWblockSelectedObjects += new AcadDB.BeginWblockSelectedObjectsEventHandler(db_BeginWblockSelectedObjects);
            db.BeginWblockBlock += new AcadDB.BeginWblockBlockEventHandler(db_BeginWblockBlock);
            db.WblockEnded += new EventHandler(db_WblockEnded);

            db.WblockNotice += new AcadDB.WblockNoticeEventHandler(db_WblockNotice);
            db.DeepCloneEnded += new EventHandler(db_DeepCloneEnded);

            db.BeginDeepClone += new AcadDB.IdMappingEventHandler(db_BeginDeepClone);
        }

        private static void db_BeginDeepClone(object sender, AcadDB.IdMappingEventArgs e)
        {
            throw new NotImplementedException();
        }

        static void db_DeepCloneEnded(object sender, EventArgs e)
        {

        }

        static void db_BeginWblockObjects(object sender, AcadDB.BeginWblockObjectsEventArgs e)
        {
            AcadAS.Application.DocumentManager.GetDocument(sender as AcadDB.Database).Editor.WriteMessage(string.Format("\nBeginWBlockObjects from {0} \n", e.From.Filename));
        }

        static void db_BeginWblockSelectedObjects(object sender, AcadDB.BeginWblockSelectedObjectsEventArgs e)
        {
            AcadAS.Application.DocumentManager.GetDocument(sender as AcadDB.Database).Editor.WriteMessage(string.Format("\nBeginWblockSelectedObjects from {0}.\n", e.From.Filename));
        }

        static void db_BeginWblockBlock(object sender, AcadDB.BeginWblockBlockEventArgs e)
        {
            AcadAS.Application.DocumentManager.GetDocument(sender as AcadDB.Database).Editor.WriteMessage(string.Format("\nBeginWblockBlock from {0}.\n", e.From.Filename));
        }

        static void db_WblockEnded(object sender, EventArgs e)
        {
            AcadAS.Application.DocumentManager.GetDocument(sender as AcadDB.Database).Editor.WriteMessage(string.Format("\nWblockEnded.\n"));
        }

        static void db_WblockNotice(object sender, AcadDB.WblockNoticeEventArgs e)      //  A wblock operation is about to start.
        {
            AcadAS.Application.DocumentManager.GetDocument(sender as AcadDB.Database).Editor.WriteMessage(string.Format("\nWblockNotice to {0}.\n", e.To.Filename));
        }

        #endregion **** Public - AutoCAD LispFunctions ****


        #region **** Internal - functions ****

        internal static void CheckLayer(string layerName)
        {
            try
            {
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();
                short colorPenNumber = -1;

                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    //  Get the layer table from the drawing.
                    AcadDB.LayerTable lt = (AcadDB.LayerTable)tr.GetObject(db.LayerTableId, AcadDB.OpenMode.ForRead);

                    //  Check the layer name, to see whether it's already exists
                    if (!lt.Has(layerName))
                    {
                        //  Create new layer table record
                        AcadDB.LayerTableRecord ltr = new AcadDB.LayerTableRecord();

                        ltr.Name = layerName;

                        string strOracleConn = Adds._strConn;
                        StringBuilder sbSQL = new StringBuilder();

                        if (strDiv != "GA" && strDiv != "AL")
                        {
                            if (!layerName.StartsWith("-"))                                     // Checks to see if valid Substation
                            {
                                int itest;

                                if (!int.TryParse(layerName.Substring(2, 1), out itest) && layerName.Substring(2, 1) != "-")        // Checks to see if valid Feeder
                                {
                                    if (layerName.Length > 9)
                                    {
                                        string layECA = layerName.Substring(6, 1);
                                        if (layECA == "B" || layECA == "D" || layECA == "T")
                                        {
                                            colorPenNumber = 7; //  white or black pen
                                        }
                                        else
                                        {
                                            sbSQL.Append("SELECT lf.feeder_color ");
                                            sbSQL.Append("FROM AddsDB.Lu_Feeders lf ");
                                            sbSQL.Append("WHERE UPPER(lf.feeder_name) = UPPER(:feederCode) ");

                                            using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                                            {
                                                oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String 

                                                OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                                                oracleCommand.Connection = oracleConn;
                                                oracleCommand.CommandType = CommandType.Text;
                                                oracleCommand.CommandText = sbSQL.ToString();

                                                oracleCommand.Parameters.Add("feederCode", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = layerName.Substring(0, 3) ?? null;

                                                colorPenNumber = (short)oracleCommand.ExecuteScalar();
                                            }
                                        }
                                        //ltr.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, colorPenNumber);
                                    }
                                    else
                                    {
                                        colorPenNumber = 7; //  white or black pen
                                    }
                                }
                                else
                                {
                                    colorPenNumber = 7; //  white or black pen
                                }
                                ltr.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, colorPenNumber);
                            }
                        }
                        else
                        {
                            string strPlantNum = layerName.Substring(0, 5);    //5   00000 0744 30
                            string strLineId = layerName.Substring(5, 4);  //  DrawText 4
                            string strColorCode = layerName.Substring(9, 2);
                            switch (strColorCode)
                            {
                                case "00":              // 500kV
                                    colorPenNumber = 3;
                                    break;
                                case "69":              // 069kV
                                case "04":              // 004kV
                                    colorPenNumber = 5; //Blue
                                    break;

                                case "12":              // 012kV
                                    colorPenNumber = 7;
                                    break;
                                case "13":              // 013kV
                                    colorPenNumber = 4;
                                    break;
                                case "15":              // 115kV
                                    colorPenNumber = 2;
                                    break;

                                case "20":              // 020kV
                                    colorPenNumber = 1;
                                    break;
                                case "23":              // 023kV
                                case "25":              // 025kV
                                    colorPenNumber = 3;
                                    break;

                                case "30":              // 230kV
                                    colorPenNumber = 4;
                                    break;
                                case "35":              // 035kV
                                case "38":              // 038kV
                                case "44":              // 044kV
                                case "46":              // 046kV
                                    colorPenNumber = 6;
                                    break;

                                case "61":              // 161kV
                                case "08":              // 161kV ?
                                    colorPenNumber = 30;
                                    break;

                                case "91":                  //  ACC- Southwest Border
                                case "92":                  //  ACC - Alabama Border
                                case "93":                  //  Gulf Power Border
                                case "94":                  //  Mississippi Power Border
                                    colorPenNumber = 1;     //  Red
                                    break;

                                case "99":
                                    colorPenNumber = 7;
                                    break;
                            }
                            ltr.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, colorPenNumber);
                        }

                        //  Add the new color to the layer table
                        lt.UpgradeOpen();
                        AcadDB.ObjectId ltID = lt.Add(ltr);
                        tr.AddNewlyCreatedDBObject(ltr, true);

                        db.Clayer = ltID;

                        tr.Commit();
                    }

                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        internal static void CollectionStrips(AcadGeo.Point3dCollection ptsPanelLimits, AcadDB.TypedValue[] typeFilter,
            long lgOffset)
        {
            AcadEd.SelectionFilter filter = new AcadEd.SelectionFilter(typeFilter);
            AcadGeo.Point3dCollection ptsSS1 = new AcadGeo.Point3dCollection();
            AcadGeo.Point3dCollection ptsSS2 = new AcadGeo.Point3dCollection();

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            double dbMinX = ptsPanelLimits[0].X;
            double dbMinY = ptsPanelLimits[0].Y;
            double dbMaxX = ptsPanelLimits[1].X;
            double dbMaxY = ptsPanelLimits[1].Y;

            ptsSS1.Add(new AcadGeo.Point3d(dbMinX + lgOffset, dbMinY + lgOffset, ptsPanelLimits[0].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMinX - lgOffset, dbMinY - lgOffset, ptsPanelLimits[0].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMaxX + lgOffset, dbMinY - lgOffset, ptsPanelLimits[1].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMaxX + lgOffset, dbMaxY + lgOffset, ptsPanelLimits[0].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMaxX - lgOffset, dbMaxY - lgOffset, ptsPanelLimits[0].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMaxX - lgOffset, dbMinY + lgOffset, ptsPanelLimits[0].Z));
            ptsSS1.Add(new AcadGeo.Point3d(dbMinX + lgOffset, dbMinY + lgOffset, ptsPanelLimits[0].Z));

            AcadEd.PromptSelectionResult psr = ed.SelectCrossingPolygon(ptsSS1, filter);
            AcadEd.SelectionSet ss1 = psr.Value;

            ptsSS2.Add(new AcadGeo.Point3d(dbMinX + lgOffset, dbMinY + lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMinX - lgOffset, dbMinY - lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMinX - lgOffset, dbMaxY + lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMaxX + lgOffset, dbMaxY + lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMaxX - lgOffset, dbMaxY - lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMinX + lgOffset, dbMaxY - lgOffset, 0.0));
            ptsSS2.Add(new AcadGeo.Point3d(dbMinX + lgOffset, dbMinY + lgOffset, 0.0));

            AcadEd.PromptSelectionResult psr2 = ed.SelectCrossingPolygon(ptsSS2, filter);
            AcadEd.SelectionSet ss2 = psr2.Value;

        }

        internal static short GetAddsColorNumFromEMBColor(short EMBColor)
        {
            short addsColorNum = 0;

            switch (EMBColor)
            {
                case 4: addsColorNum = 4; break;      // Cyan/blue code changed for 230 KV new with ACC changes
                case 24: addsColorNum = 3; break;      // Blue new with ACC changes

                case 11: addsColorNum = 5; break;      //  Blue            AddsX
                case 29: addsColorNum = 4; break;      //  Cyan
                case 30: addsColorNum = 3; break;      //  Green           AddsX
                case 35: addsColorNum = 4; break;      //  Cyan            AddsX
                case 90: addsColorNum = 86; break;      //  Lincoln Green
                case 108: addsColorNum = 28; break;      //  ?

                case 109: addsColorNum = 29; break;      //  ?
                case 111: addsColorNum = 226; break;      //  Deep Purple
                case 114: addsColorNum = 24; break;      //  ?
                case 115: addsColorNum = 26; break;      //  Dirk Brick
                case 116: addsColorNum = 27; break;      //  ?

                case 120: addsColorNum = 34; break;      //  Brown
                case 126: addsColorNum = 25; break;      //  Mocha
                case 144: addsColorNum = 12; break;      //  Brick
                case 150: addsColorNum = 18; break;      //  ?
                case 152: addsColorNum = 23; break;      //  ?

                case 155: addsColorNum = 191; break;      //  Lavender        AddsX
                case 164: addsColorNum = 9; break;      //  Light Gray
                case 172: addsColorNum = 8; break;      //  Dray Gray
                case 180: addsColorNum = 1; break;      //  Red             AddsX
                case 181: addsColorNum = 17; break;      //  ?

                case 185: addsColorNum = 6; break;      //  Magenta         AddsX
                case 186: addsColorNum = 16; break;      //  Bad Moon Red
                case 187: addsColorNum = 15; break;      //  Light Brick     AddsX
                case 192: addsColorNum = 32; break;      //  Orange-Brown
                case 193: addsColorNum = 21; break;      //  ?

                case 194: addsColorNum = 22; break;      //  ?
                case 195: addsColorNum = 20; break;      //  Fire Engine
                case 198: addsColorNum = 30; break;      //  Orange          AddsX
                case 201: addsColorNum = 11; break;      //  Salmon
                case 204: addsColorNum = 40; break;      //  Maple           AddsX

                case 210: addsColorNum = 2; break;      //  Yellow          AddsX
                case 215: addsColorNum = 0; break;      //  Magenta         AddsX

                    //  AddsX 255
                    //  AddsX 50
                    //  AddsX  7
            }
            return addsColorNum;
        }

        internal static string GetAddsVoltageCode(string voltage)
        {
            string strVoltCode = null;

            switch (voltage)
            {
                case "500":
                    strVoltCode = "00";
                    break;
                case "4":
                    strVoltCode = "04";
                    break;
                case "12.47":
                    strVoltCode = "12";
                    break;
                case "12":
                    strVoltCode = "12";
                    break;
                case "13":
                    strVoltCode = "13";
                    break;
                case "115":
                    strVoltCode = "15";
                    break;
                case "20":
                    strVoltCode = "20";
                    break;
                case "23":                  // was 23 to 3 think it was an error
                    strVoltCode = "23";
                    break;
                case "25":                  // New because of GCC
                    strVoltCode = "25";
                    break;
                case "230":
                    strVoltCode = "30";
                    break;
                case "35":
                    strVoltCode = "35";
                    break;
                case "38":
                    strVoltCode = "38";
                    break;
                case "44":
                    strVoltCode = "44";
                    break;
                case "46":
                    strVoltCode = "46";
                    break;
                case "161":
                    strVoltCode = "61";
                    break;
                case "69":
                    strVoltCode = "69";
                    break;
                default:
                    strVoltCode = "99";
                    break;
            }
            return strVoltCode;
        }
        internal static string GetNextDeviceID(string acadObjectType)
        {
            object objResult;
            string strDeviceID = null;
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT addsdb.Get_Next_ID() AS myNextNum FROM dual");
            string strOracleConn = Adds._strConn;


            using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
            {
                oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String 
                oracleConn.ClientInfo = Adds._strUserID;

                OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                oracleCommand.Connection = oracleConn;
                oracleCommand.CommandType = CommandType.Text;
                oracleCommand.CommandText = sbSQL.ToString();

                objResult = oracleCommand.ExecuteScalar();

                strDeviceID = acadObjectType + objResult.ToString();

                oracleCommand.Dispose();
                oracleConn.Close();
            }
            return strDeviceID;
        }

        internal static AcadGeo.Point3dCollection GetPanelMinMaxPts(string panelName)
        {
            int stat = 0;
            long lgPanelNum, lgXPanel, lgYPanel, lgMinX, lgMinY, lgMaxX, lgMaxY;
            ArrayList alResults;
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();
            AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

            try
            {
                //  Check to see if geographic panel name type
                if (long.TryParse(panelName, out lgPanelNum))
                {
                    //  Get Adds system variables XPanel & YPanel they define the panel size.
                    rbResults = Adds.AcadGetSystemVariable("XPanel", ref stat);
                    alResults = Adds.ProcessInputParameters(rbResults);
                    if (long.TryParse(alResults[0].ToString(), out lgXPanel))
                    {
                        rbResults = Adds.AcadGetSystemVariable("YPanel", ref stat);
                        alResults = Adds.ProcessInputParameters(rbResults);
                        if (long.TryParse(alResults[0].ToString(), out lgYPanel))
                        {
                            //  Decode panel name to get min/max points.
                            lgMinX = long.Parse(panelName.Substring(0, 3)) * 1000;
                            lgMinY = long.Parse(panelName.Substring(3, 4)) * 1000;
                            lgMaxX = lgMinX + lgXPanel;
                            lgMaxY = lgMinY + lgYPanel;
                            pts.Add(new AcadGeo.Point3d(lgMinX, lgMinY, 0.0));
                            pts.Add(new AcadGeo.Point3d(lgMaxX, lgMaxY, 0.0));
                        }
                        else
                        {   // [TODO] this would be an error condition - YPanel value invalid
                        }
                    }
                    else
                    {   // [TODO] this would be an error condition  - XPanel value invalid
                    }
                }
                else
                {   // [TODO] this would be an error condition - Panel Name not correct format
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return pts;
        }

        internal static DataTable GetResults(StringBuilder SQL, string ConnString)
        {
            DataTable dtResults = null;
            using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(ConnString))
            {

                oracleConn.Open();                          // [CHECKED] Oracle 12.c - Connection String
                oracleConn.ClientInfo = Adds._strUserID;

                OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                oracleCommand.Connection = oracleConn;
                oracleCommand.CommandType = CommandType.Text;
                oracleCommand.CommandText = SQL.ToString();
                oracleCommand.InitialLONGFetchSize = 4000;

                DataSet ds = new DataSet();
                OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                da.TableMappings.Add("Table", "Results");
                da.Fill(ds);
                dtResults = ds.Tables["Results"] as DataTable;

                oracleCommand.Dispose();
                oracleConn.Close();
            }
            return dtResults;
        }

        internal static string DecodeListParameter(ArrayList acadList)
        {
            string strResults = null;
            long lgCount = acadList.Count;
            long lgIndex = 0;

            foreach (string item in acadList)
            {
                lgIndex += 1;
                if (lgIndex < lgCount)
                {
                    strResults += item + ", ";
                }
                else
                {
                    strResults += item;
                }
            }

            return strResults;
        }

        internal static AcadDB.ResultBuffer BuildList(DataTable dtIn)
        {
            AcadDB.ResultBuffer rbList = new AcadDB.ResultBuffer();
            decimal decTemp;

            DataRow oRow = dtIn.Rows[0];

            rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
            for (int intIndex = 0; intIndex < dtIn.Columns.Count; intIndex++)
            {
                switch (dtIn.Columns[intIndex].DataType.Name)
                {
                    case "String":
                        rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[intIndex].ToString()));
                        break;
                    case "Decimal":
                        decTemp = (decimal)oRow[intIndex];
                        if ((decTemp % 1) == 0)
                        {
                            rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[intIndex]));
                        }
                        else
                        {
                            rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[intIndex]));
                        }
                        break;
                    case "Int16":
                        rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[intIndex]));
                        break;
                }
            }
            rbList.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            return rbList;
        }

        internal static void BuildListOfList(DataTable dtIn, out AcadDB.ResultBuffer rbResults)
        {
            //AcadDB.ResultBuffer rbList = new AcadDB.ResultBuffer();

            decimal decTemp;

            rbResults = new AcadDB.ResultBuffer();

            // Builds CurMstDevLst
            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
            foreach (DataRow oRow in dtIn.Rows)
            {
                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                for (int intIndex = 0; intIndex < dtIn.Columns.Count; intIndex++)
                {
                    switch (dtIn.Columns[intIndex].DataType.Name)
                    {
                        case "String":
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[intIndex].ToString()));
                            break;
                        case "Decimal":
                            decTemp = (decimal)oRow[intIndex];
                            if ((decTemp % 1) == 0)
                            {
                                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, oRow[intIndex]));
                            }
                            else
                            {
                                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Double, oRow[intIndex]));
                            }
                            break;
                    }
                }
                rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }
            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));

            //return rbList;
        }

        internal static AcadGeo.Point3d PolarPoint(AcadGeo.Point3d basePoint, double angle, double distance)
        {
            AcadGeo.Point3d pt3Result = new AcadGeo.Point3d(basePoint.X + (distance * Math.Cos(angle)),
                                                            basePoint.Y + (distance * Math.Sin(angle)),
                                                            basePoint.Z);

            return pt3Result;
        }

        #endregion **** Internal - functions ****


        #region **** Private - functions ****

        private static void CreateLayer(string layerName, short autoCADColorIndex, string lineType)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    //  Get the layer table from the drawing.
                    AcadDB.LayerTable lt = (AcadDB.LayerTable)tr.GetObject(db.LayerTableId, AcadDB.OpenMode.ForRead);

                    //  Check the layer name, to see whether it's already in use
                    if (!lt.Has(layerName))
                    {
                        //  Create new layer table record
                        AcadDB.LayerTableRecord ltr = new AcadDB.LayerTableRecord();

                        ltr.Name = layerName;

                        //  Set color of new layer
                        if (autoCADColorIndex >= 0)
                        {
                            ltr.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, autoCADColorIndex);
                        }
                        else
                        {
                            ltr.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, 7); //  white or black pen
                        }

                        //  The layer record stores the linetype as an ObjectID, not a string.
                        AcadDB.LinetypeTable ltt = db.LinetypeTableId.GetObject(AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                        if (ltt.Has("Hidden2"))
                        {
                        }
                        //AcadDB.LinetypeTableRecord lttr = tr.GetObject(ltr.LinetypeObjectId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTableRecord;
                        //lttr.Name = "Hidden2";
                        //ltr.LinetypeObjectId = lttr.ObjectId;

                        //ltr.LinetypeObjectId

                        //  Add the new color to the layer table
                        lt.UpgradeOpen();
                        AcadDB.ObjectId ltID = lt.Add(ltr);
                        tr.AddNewlyCreatedDBObject(ltr, true);

                        db.Clayer = ltID;

                        tr.Commit();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

        }

        internal static void EndACAD()
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;

            AcadAS.Application.Quit();
        }

        public static string Encrypt(string encryptString)
        {
            string EncryptionKey = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            byte[] clearBytes = Encoding.Unicode.GetBytes(encryptString);

            using (Aes encryptor = Aes.Create())
            {
                //  Initializes a new instance of the Rfc2898DeriveBytes class using a password and salt to derive the key.
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey,
                    new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });

                //  Gets or sets the secret key for the symmetric algorithm.
                encryptor.Key = pdb.GetBytes(32);
                //  Gets or sets the initialization vector (IV) for the symmetric algorithm.
                encryptor.IV = pdb.GetBytes(16);

                using (MemoryStream ms = new MemoryStream())
                {
                    //  Initializes a new instance of the CryptoStream class with a target data stream, the transformation to use, and the mode of the stream.
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    //  Convert.ToBase64String - Converts the value of an array of 8-bit unsigned integers to its equivalent string representation that is encoded with base-64 digits.
                    encryptString = Convert.ToBase64String(ms.ToArray());
                }
            }
            return encryptString;
        }

        internal static string Decrypt(string cipherText)
        {
            string EncryptionKey = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            cipherText = cipherText.Replace(" ", "+");
            byte[] cipherBytes = Convert.FromBase64String(cipherText);
            using (Aes encryptor = Aes.Create())
            {
                //  Initializes a new instance of the Rfc2898DeriveBytes class using a password and salt to derive the key.
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[]
                {
                    0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76
                });
                //  Gets or sets the secret key for the symmetric algorithm.
                encryptor.Key = pdb.GetBytes(32);
                //  Gets or sets the initialization vector (IV) for the symmetric algorithm.
                encryptor.IV = pdb.GetBytes(16);


                using (MemoryStream ms = new MemoryStream())
                {
                    //  Initializes a new instance of the CryptoStream class with a target data stream, the transformation to use, and the mode of the stream.
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherBytes, 0, cipherBytes.Length);
                        cs.Close();
                    }
                    //  
                    cipherText = Encoding.Unicode.GetString(ms.ToArray());
                }
            }
            return cipherText;
        }

        internal static void UnlockAllLayers()
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;

            if (doc == null)
            {
                return;
            }
            doc.LockOrUnlockAllLayers(false);   // To unlock all layers 
        }

        #endregion **** Private - functions ****


    }

    public static class Extensions
    {
        public static void LockOrUnlockAllLayers(this AcadAS.Document doc, bool dolock, bool lockZero = false)
        {
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
            {
                AcadDB.LayerTable lt = (AcadDB.LayerTable)tr.GetObject(db.LayerTableId, AcadDB.OpenMode.ForRead);
                foreach (var ltrId in lt)
                {
                    // Don't try to lock/unlock either the current layer or layer 0
                    if (ltrId != db.Clayer && (lockZero || ltrId != db.LayerZero))
                    {
                        // Open the layer for write and lock/unlock it
                        AcadDB.LayerTableRecord ltr = (AcadDB.LayerTableRecord)tr.GetObject(ltrId, AcadDB.OpenMode.ForWrite);
                        ltr.IsLocked = dolock;
                        ltr.IsOff = ltr.IsOff;  // force a grahic update
                    }
                }
                tr.Commit();
            }
            ed.ApplyCurDwgLayerTableChanges();
            ed.Regen();
        }

        public static void TurnOnOrOffAllLayers(this AcadAS.Document doc, bool dolock, bool lockZero = false)
        {
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
            {
                AcadDB.LayerTable lt = tr.GetObject(db.LayerTableId, AcadDB.OpenMode.ForRead) as AcadDB.LayerTable;
                foreach (AcadDB.ObjectId objID in lt)
                {
                    AcadDB.LayerTableRecord ltr = tr.GetObject(objID, AcadDB.OpenMode.ForWrite) as AcadDB.LayerTableRecord;
                    ltr.IsOff = dolock;  //True for off, false for on
                    ltr.IsOff = ltr.IsOff;  // force a grahic update
                }
                tr.Commit();
            }

        }
    }

    public class AcadMessageFilter : IMessageFilter
    {
        public const int WM_KEYDOWN = 0x0100;
        public bool bCanceled = false;

        public bool PreFilterMessage(ref Message m)
        {
            if (m.Msg == WM_KEYDOWN)
            {
                //  Check for the Escape keypress
                Keys kc = (Keys)(int)m.WParam & Keys.KeyCode;
                if (m.Msg == WM_KEYDOWN && kc == Keys.Escape)
                {
                    bCanceled = true;
                }
                //  Returns true to filter all keypresses
                return true;
            }
            //  Returns false to let other messages through
            return false;
        }

    }

    public static class StringExtensions
    {
        /// <summary>
        /// Limits pass-in string to a specific number of charactures.  Returns string limited to the number of max charactures.
        /// </summary>
        /// <param name="string"></param>
        /// <param name="Max Lenght"></param>
        /// <returns></returns>
        public static string LimitString(this string value, int maxLenght)
        {
            if (string.IsNullOrEmpty(value)) return value;

            maxLenght = Math.Abs(maxLenght);

            if (value.Length <= maxLenght)
            {
                return value;
            }
            else
            {
                return value.Substring(0, maxLenght);
            }

        }
    }
}
