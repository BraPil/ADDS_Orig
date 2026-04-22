using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

using System.Data;
//using System.Data.OracleClient;
using System.IO;
using System.Windows.Forms;

using OracleDb = Oracle.DataAccess.Client;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadColor = Autodesk.AutoCAD.Colors;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;


namespace Adds
{
    public class AcadLine
    {

        #region  *** Public Functions ***

        [Acad.CommandMethod("DrawBoxGTC")]
        public void DrawBoxGTC()
        {
            DrawPolyLine("00000000015", "1", "Hidden");
        }

        [Acad.CommandMethod("DrawPolylineSp")]
        public void DrawPolylineFromSeed()
        {
            PolylineInfo polyLineInfo = GetPolyLineInfo();                                  // Gets layer name of existing polyline as seed layer.
            DrawPolyLine(polyLineInfo.LayerName, string.Empty, string.Empty);               // Allows user to draw a polyline based on seed layer
        }

        [Acad.CommandMethod("DrawPolylineFromFile")]
        public void DrawPolylineFromFile1()
        {
            PolylineInfo polyLineInfo = GetPolyLineInfo();                                  // Gets layer name of existing polyline as seed layer.
            DrawPolylineFromFileSp(polyLineInfo.LayerName, string.Empty, string.Empty);     //Draws polyline from GIS point file

        }

        /// <summary>
        /// Out Date code keeping around for testing newer code.
        /// </summary>
        /// <param name="args"></param>
        [Acad.LispFunction("DrawPolylineSp_Old")]
        public void DrawPolyline_Old(AcadDB.ResultBuffer args)
        {
            int intArrayNum = -1;
            string strLayerName = null;
            string strColorNum = null;
            string strLineType = null;

            try
            {
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                intArrayNum = alInputParameters.Count;

                if (intArrayNum > 0)
                {
                    strLayerName = alInputParameters[0].ToString();
                }
                if (intArrayNum > 1)
                {
                    strColorNum = alInputParameters[1].ToString();
                }
                if (intArrayNum > 2)
                {
                    strLineType = alInputParameters[2].ToString();
                }

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Creates a collection of points to store vertices
                AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

                //  Setup the selection options/dialog interface for all the vertices in the polyline
                AcadEd.PromptPointOptions ppOptions = new AcadEd.PromptPointOptions("\nSelect polyline vertex: ")
                {
                    AllowNone = true
                };
                ppOptions.Keywords.Add("Close","lC", "[C]lose");

                //  Get starting point
                AcadEd.PromptPointResult ppResult = ed.GetPoint(ppOptions);

                //  Get points until there are no more
                while (ppResult.Status == AcadEd.PromptStatus.OK && ppResult.Status != AcadEd.PromptStatus.Keyword)
                {
                    //  Add the selected point to the list
                    pts.Add(ppResult.Value);

                    ppOptions.UseBasePoint = true;
                    ppOptions.BasePoint = ppResult.Value;
                    ppResult = ed.GetPoint(ppOptions);
                    if (ppResult.Status == AcadEd.PromptStatus.OK)
                    {
                        ed.DrawVector(
                                pts[pts.Count - 1],         //  start point
                                ppResult.Value,             //  end point
                                7,                          //  line color
                                false);                     //  draw highlighted
                    }

                }

                if (ppResult.Status == AcadEd.PromptStatus.Keyword)
                {
                    switch (ppResult.StringResult)
                    {
                        case "Close":
                            pts.Add(pts[0]);
                            break;

                    }
                }

                if (ppResult.Status == AcadEd.PromptStatus.None || ppResult.StringResult == "Close" )
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                        AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                        bt.Dispose();       //  Cleanup memory for AutoCAD wrapper

                        //  Create Polyline
                        AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null);

                        if (!string.IsNullOrEmpty(strLayerName))
                        {
                            Utilities.CheckLayer(strLayerName);         // Creates layer if it does not exists.
                            pline.Layer = strLayerName;
                        }

                        if (!string.IsNullOrEmpty(strColorNum))
                        {
                            if (short.TryParse(strColorNum, out short sintColorNum))
                            {
                                pline.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, sintColorNum);
                                Adds.SetStoredXData(pline, "CLR_NUM", strColorNum);
                            }
                        }

                        if (!string.IsNullOrEmpty(strLineType))
                        {
                            AcadDB.LinetypeTable ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                            if (!ltt.Has(strLineType))
                            {
                                dbDwg.LoadLineTypeFile(strLineType, "acad.lin");
                            }
                            if (ltt.Has(strLineType))
                            {
                                pline.Linetype = strLineType;
                            }
                            if (strLineType == "Hidden")
                            {
                                Adds.SetStoredXData(pline, "LINE_TYP", "1");
                            }
                        }

                        //  Adds new polyline to AutoCAD drawing database
                        btrModelSpace.AppendEntity(pline);
                        tr.AddNewlyCreatedDBObject(pline, true);

                        pline.Dispose();
                        tr.Commit();

                        //  Causes the polyline to be displayed in AutoCAD
                        ed.Regen();
                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }

        }

        // Special Function - For re-Building ADDS panel Dwg from TMap DB pass in panel name
        [Acad.LispFunction("DrawPanel")]
        public void DrawPanel(AcadDB.ResultBuffer args)
        {
            try
            {
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                string strPanel = alInputParameters[0].ToString();
                string strDeBug = null;
                if (alInputParameters.Count == 2)
                {
                    strDeBug = alInputParameters[1].ToString();
                }
                
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Build the panel
                DrawPanelFeeders(strPanel, ref doc, ref dbDwg, ref ed);
                AcadSymbol.DrawPanelSymbols(strPanel, strDeBug, ref doc, ref dbDwg, ref ed);
                AcadText.DrawPanelText(strPanel, ref doc, ref dbDwg, ref ed);

                //  Save the panel locally
                Utilities.ZoomExtents();
                dbDwg.SaveAs(@"C:\Adds\DWG\" + strPanel + ".dwg", AcadDB.DwgVersion.Current);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        [Acad.LispFunction("CheckPolylineVertices")]
        public static void CheckPolylineVertices(AcadDB.ResultBuffer args)
        {
            AcadDB.Polyline2d pline2d;
            string strBaseLayerName = null;
            //string strMessage = null;
            Int64 intVertexsChecked = 0;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

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
                            AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForRead);

                            if (dbObj.GetType().Name == "Polyline2d")
                            {
                                pline2d = dbObj as AcadDB.Polyline2d;
                                strBaseLayerName = pline2d.Layer.ToString();
                                
                                foreach (AcadDB.ObjectId vId in pline2d)
                                {
                                    AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForWrite);
                                    //  If node layer is not the same as the polyline definition change the node layer name to match.
                                    if (v2d.Layer != strBaseLayerName)
                                    {
                                        v2d.Layer = strBaseLayerName;
                                    }
                                    intVertexsChecked += 1;
                                }
                            }
                        }
                        tr.Commit();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        [Acad.CommandMethod("FixVertices")]
        public void FixVertices()
        {
            AcadDB.Polyline2d pline2d;
            string strBaseLayerName = null;

            try
            {

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Polyline to fix vertices: ");
                peo.SetRejectMessage("\nYou need to select a polyline");
                peo.AddAllowedClass(typeof(AcadDB.Polyline2d), false);
                AcadEd.PromptEntityResult entResult = ed.GetEntity(peo);

                if (entResult.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {
                        AcadDB.DBObject dbObj = tr.GetObject(entResult.ObjectId, AcadDB.OpenMode.ForRead);

                        if (dbObj.GetType().Name == "Polyline2d")
                        {
                            pline2d = dbObj as AcadDB.Polyline2d;
                            strBaseLayerName = pline2d.Layer.ToString();

                            foreach (AcadDB.ObjectId vId in pline2d)
                            {
                                AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForWrite);
                                if (v2d.Layer != strBaseLayerName)
                                {
                                    v2d.Layer = strBaseLayerName;
                                }
                            }
                        }
                        tr.Commit();
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        // Special Function - For writting GIS line segements to file for use as ADDS line vertices for import into ADDS
        [Acad.CommandMethod("TestWriteLines")]
        public void TestWriteLines()
        {
            int iCount = 0;
            int iIndex = 0;
            string path = @"D:\ET Project Info\Adds Info\Gulf\";
            string strFullPath = null;
            string strLN_ID = null;
            string strLineID = null;
            AcadDB.Polyline pline;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE"),   // LINE_SELECT_DISSOLVE
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, "LINE_SELECT_DISSOLVE")
                };
                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
                AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                // Create a collection containing the initial set
                AcadDB.ObjectIdCollection objs;
                if (pSelectResult.Status == AcadEd.PromptStatus.OK)
                {
                    objs = new AcadDB.ObjectIdCollection(pSelectResult.Value.GetObjectIds());
                }
                else
                {
                    objs = new AcadDB.ObjectIdCollection();
                }

                if (objs.Count > 0)
                {

                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {

                        foreach (AcadDB.ObjectId PlId in objs)
                        {
                            AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForRead);
                            if (dbObj.GetType().Name == "Polyline")
                            {
                                pline = dbObj as AcadDB.Polyline;
                                AcadDB.ResultBuffer rb = dbObj.XData;
                                if (rb != null)
                                {
                                    string strTemp = string.Empty; //,strDeviceId, strLineId, strPlantId, strEditYMDT;
                                    bool flagReadNext = false;
                                    foreach (AcadDB.TypedValue tv in rb)
                                    {
                                        if (tv.Value.ToString() == "LN_ID")
                                        {
                                            flagReadNext = true;
                                        }
                                        if (flagReadNext && (tv.Value.ToString() != "LN_ID"))
                                        {
                                            strLN_ID    = tv.Value.ToString();
                                            strLineID = "F" + strLN_ID.PadLeft(3, '0');
                                            flagReadNext = false;
                                        }
                                    }
                                    if (!string.IsNullOrEmpty(strLineID))
                                    {
                                        iIndex += 1;
                                        strFullPath = path + "LINE_" + strLineID + "_" + iIndex.ToString() + ".txt";
                                        using (StreamWriter sw = File.CreateText(strFullPath))
                                        {
                                            iCount = pline.NumberOfVertices;
                                            for (int index = 0; index < iCount; ++index)
                                            {
                                                AcadGeo.Point2d pt = pline.GetPoint2dAt(index);
                                                ed.WriteMessage("\n" + pt.ToString() + ", " + strLineID);
                                                sw.WriteLine(pt.ToString());
                                            }
                                        }

                                    }
                                }

                            }
                        }

                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }

        }

        // Special Function - For reading a GIS line segement file and import line into ADDS
        [Acad.CommandMethod("ReadVerticesToFile",
            Acad.CommandFlags.UsePickSet | Acad.CommandFlags.Redraw | Acad.CommandFlags.Modal)]
        public void ReadVerticesToFile()
        {
            int iCount = -1;
            string path = @"D:\ET Project Info\Adds Info\ACC\ACC_TMC.txt";
            AcadDB.Polyline plineLW;

            try
            {
                                
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Gets pickfirst set if there is one already selected.
                AcadEd.PromptSelectionResult psr = ed.SelectImplied();
                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE")
                };
                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);

                //  Checks to see if pickfirst set is available, if not gets user to select drawing objects.
                if (psr.Status == AcadEd.PromptStatus.Error)
                {
                    //  Ask user to select entities
                    AcadEd.PromptSelectionOptions psoBlocks = new AcadEd.PromptSelectionOptions
                    {
                        MessageForAdding = "\nSelect Polyline to fix vertices: "
                    };
                    psr = ed.GetSelection(psoBlocks, sFilter);
                }
                else
                {
                    //  if there was a pickfirst set, clear it
                    ed.SetImpliedSelection(new AcadDB.ObjectId[0]);
                }

                if (psr.Status == AcadEd.PromptStatus.OK)
                {
                    if (!File.Exists(path))
                    {
                        using (StreamWriter sw = File.CreateText(path))

                        using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                        {
                             AcadDB.ObjectId[] objIds = psr.Value.GetObjectIds();
                             foreach (AcadDB.ObjectId objID in objIds)
                             {
                                 AcadDB.Entity ent = tr.GetObject(objID, AcadDB.OpenMode.ForWrite) as AcadDB.Entity;


                                 if (ent.GetType().Name == "Polyline")
                                 {
                                     plineLW = ent as AcadDB.Polyline;
                                     iCount = plineLW.NumberOfVertices;

                                     for (int index = 0; index < iCount; ++index)
                                     {
                                         AcadGeo.Point2d pt = plineLW.GetPoint2dAt(index);
                                         ed.WriteMessage("\n" + pt.ToString());
                                         sw.WriteLine(pt.ToString());
                                     }
                                 }

                             }
                        }
                    }
                }
                //}
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        // Special Function - For reading GIS line segements file and import line into ADDS
        [Acad.CommandMethod("TestReadMult")]
        public void ReadMultFromFiles()
        {
            string dirPath = @"E:\ET Project Info\Adds Info\Gulf";
            string strFullPath = null;
            string strLineID = null;
            string strLayerName = null;
            string strVoltageCode = "99";
            string strTemp = null;
            string strLineType = null;

            double strPtX;
            double strPtY;


            DataTable dtResults = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;
                

                //  Check if the directory exists
                DirectoryInfo diSource = new DirectoryInfo(dirPath);
                if (Directory.Exists(dirPath))
                {
                    foreach (FileInfo fi in diSource.GetFiles())
                    {
                        if (fi.Name.StartsWith("LINE_"))
                        {
                            strFullPath = dirPath + @"\" + fi.Name.ToString();
                            strLineID = fi.Name.Substring(5, 4);
                            dtResults = GetLineInfoFromStomp(strLineID.Remove(0,1));
                            if (dtResults.Rows.Count > 0)
                            {
                                DataRow drResult = dtResults.Rows[0];
                                strVoltageCode = Utilities.GetAddsVoltageCode(drResult["ln_oper_kv_num"].ToString());
                                if (!string.IsNullOrEmpty(strVoltageCode))
                                {
                                    strLayerName = "AR201" + strLineID + strVoltageCode;
                                    AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

                                    using (StreamReader sr = File.OpenText(strFullPath))
                                    {
                                        while ((strTemp = sr.ReadLine()) != null)
                                        {
                                            strTemp = strTemp.Replace("(", "");
                                            strTemp = strTemp.Replace(")", "");
                                            strPtX = double.Parse(strTemp.Substring(0, strTemp.IndexOf(",")));
                                            strPtY = double.Parse(strTemp.Substring(strTemp.IndexOf(",") +1));
                    
                                            AcadGeo.Point3d pt = new AcadGeo.Point3d((double)strPtX, (double)strPtY, 0.0);
                                            pts.Add(pt);
                                        }
                                    }
                                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                                    {
                                        AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                                        AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                                        bt.Dispose();       //  Cleanup memory for AutoCAD wrapper

                                        //  Create Polyline
                                        AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null);

                                        if (!string.IsNullOrEmpty(strLayerName))
                                        {
                                            Utilities.CheckLayer(strLayerName);         // Creates layer if it does not exists.
                                            pline.Layer = strLayerName;
                                        }

                                        //if (!string.IsNullOrEmpty(strColorNum))
                                        //{
                                        //    short sintColorNum;
                                        //    if (short.TryParse(strColorNum, out sintColorNum))
                                        //    {
                                        //        pline.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, sintColorNum);
                                        //        Adds.SetStoredXData(pline, "CLR_NUM", strColorNum);
                                        //    }
                                        //}

                                        if (!string.IsNullOrEmpty(strLineType))
                                        {
                                            AcadDB.LinetypeTable ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                                            if (!ltt.Has(strLineType))
                                            {
                                                dbDwg.LoadLineTypeFile(strLineType, "acad.lin");
                                            }
                                            if (ltt.Has(strLineType))
                                            {
                                                pline.Linetype = strLineType;
                                            }
                                            if (strLineType == "Hidden")
                                            {
                                                Adds.SetStoredXData(pline, "LINE_TYP", "1");
                                            }
                                        }

                                        btrModelSpace.AppendEntity(pline);
                                        tr.AddNewlyCreatedDBObject(pline, true);

                                        pline.Dispose();
                                        tr.Commit();

                                        //  Causes the polyline to be displayed in AutoCAD
                                        ed.Regen();
                                    }

                                }
                            }
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        //  Cleanup command to remove vertices 
        [Acad.CommandMethod("RemoveVertices")]
        public void RemoveVerticesPickTwoPoints()
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                {

                    AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nPick first point on line:");
                    peo.SetRejectMessage("\nMust pick a ployline");
                    peo.AddAllowedClass(typeof(AcadDB.Polyline2d), true);

                    AcadEd.PromptEntityResult pEntResult = ed.GetEntity(peo);


                    if (pEntResult.Status != AcadEd.PromptStatus.OK)
                        return;

                    AcadDB.Polyline2d pline2d = (AcadDB.Polyline2d)tr.GetObject(pEntResult.ObjectId, AcadDB.OpenMode.ForRead);

                    //  Gets Polyline segment index ~ starts at zero
                    AcadGeo.Point3d ptOnePline = new AcadGeo.Point3d(0, 0, 0);
                    ptOnePline = pline2d.GetClosestPointTo(pEntResult.PickedPoint, true);
                    int indexOnePline = (int)pline2d.GetParameterAtPoint(ptOnePline);
                    ptOnePline = pline2d.GetPointAtParameter((double)indexOnePline);

                    peo.Message = "\nPick second point on line:";
                    pEntResult = ed.GetEntity(peo);
                    if (pEntResult.Status != AcadEd.PromptStatus.OK)
                        return;

                    //  Gets Polyline segment index ~ end
                    AcadGeo.Point3d ptTwoPline = new AcadGeo.Point3d(0, 0, 0);
                    ptTwoPline = pline2d.GetClosestPointTo(pEntResult.PickedPoint, true);
                    int indexSecPline = (int)pline2d.GetParameterAtPoint(ptTwoPline);
                    ptTwoPline = pline2d.GetPointAtParameter((double)indexSecPline);

                    AcadGeo.Point3dCollection pointsList = new AcadGeo.Point3dCollection();
                    int intIndex = 0;
                    if (indexOnePline < indexSecPline)
                    {
                        while (indexOnePline + intIndex <= indexSecPline)
                        {
                            pointsList.Add(pline2d.GetPointAtParameter((double)indexOnePline + intIndex));
                            intIndex += 1;
                        }
                    }
                    else
                    {
                        while (indexSecPline + intIndex <= indexOnePline)
                        {
                            pointsList.Add(pline2d.GetPointAtParameter((double)indexSecPline + intIndex));
                            intIndex += 1;
                        }
                    }


                    AcadGeo.Point3d ptV2dPosition = new AcadGeo.Point3d(0, 0, 0);
                    foreach (AcadDB.ObjectId vId in pline2d)
                    {
                        AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForRead);
                        ptV2dPosition = v2d.Position;

                        foreach (AcadGeo.Point3d pt3d in pointsList)
                        {
                            if (ptV2dPosition == pt3d)
                            {
                                v2d.UpgradeOpen();
                                v2d.Erase(true);     //   Erases vertex
                            }
                        }
                    }
                    tr.Commit();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        //  Cleanup command to join two polylines
        [Acad.CommandMethod("JoinPolylines",
            Acad.CommandFlags.UsePickSet | Acad.CommandFlags.Redraw | Acad.CommandFlags.Modal)]
        public void JoinPloylines()
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                //  Create a filter to select all polylines in a drawing and use it to get the polylines.
                AcadEd.PromptSelectionResult psr = ed.SelectImplied();
                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE") 
                };
                AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
                AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

                //  Checks to see if pickfirst set is available, if not gets user to select drawing objects.
                if (psr.Status == AcadEd.PromptStatus.Error)
                {
                    AcadEd.PromptSelectionOptions pso = new AcadEd.PromptSelectionOptions
                    {
                        MessageForAdding = "\nYou need to select polylines for joining"
                    };
                    psr = ed.GetSelection(pso, sFilter);
                }
                else
                {
                    //  if there was a pickfirst set, clear it
                    ed.SetImpliedSelection(new AcadDB.ObjectId[0]);
                }

                List<PolylineInfo> entities = new List<PolylineInfo>();

                if (psr.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {
                        AcadDB.ObjectId[] objIds = psr.Value.GetObjectIds();
                        foreach (AcadDB.ObjectId objID in objIds)
                        {
                            AcadDB.Entity ent = tr.GetObject(objID, AcadDB.OpenMode.ForRead) as AcadDB.Entity;
                            PolylineInfo plInfo = new PolylineInfo
                            {
                                Entity = ent,
                                StartPoint = GetStartPointData(ent),
                                EndPoint = GetEndPointData(ent)
                            };

                            entities.Add(plInfo);
                        }


                        if (entities.Count > 0)
                        {
                            for (int i = entities.Count - 1; i >= 0; i--)  // Count down for first ID
                            {
                                for (int j = i - 1; j >= 0; j--)          // Get next ID
                                {
                                    if ((entities[i].StartPoint == entities[j].StartPoint) ||
                                        (entities[i].StartPoint == entities[j].EndPoint) ||
                                        (entities[i].EndPoint == entities[j].StartPoint) ||
                                        (entities[i].EndPoint == entities[j].EndPoint))
                                    {
                                        AcadDB.Entity srcPline = entities[i].Entity;
                                        AcadDB.Entity addPline = entities[j].Entity;

                                        //  Join both Polylines
                                        srcPline.UpgradeOpen();
                                        srcPline.JoinEntity(addPline);

                                        //  Delete the joined polyline
                                        addPline.UpgradeOpen();
                                        entities.RemoveAt(j);
                                        addPline.Erase();

                                        PolylineInfo plInfo2 = new PolylineInfo
                                        {
                                            Entity = srcPline,
                                            StartPoint = GetStartPointData(srcPline),
                                            EndPoint = GetEndPointData(srcPline)
                                        };
                                        entities[i - 1] = plInfo2;

                                        i = entities.Count;
                                        j = 0;

                                    }
                                }
                            }
                            tr.Commit();
                        }
                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }

        

        #endregion  *** Public Functions ***


        #region *** Internal Functions ***

        internal static DataTable GetLineInfoFromStomp(string lineID)
        {
            DataTable dtResult = null;
            string strOracleConn = "Data Source=tnfp;User ID=STOMPDMC;Password=richard;Pooling=false;";

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT l.ln_id, l.ln_oper_kv_num, UPPER(l.ln_nam) AS Ln_Nam, l.ln_mile_length_num ");
            sbSQL.Append("FROM STOMP.Line l ");
            sbSQL.Append("WHERE l.ln_id = " + lineID);

            try
            {
                dtResult = Utilities.GetResults(sbSQL, strOracleConn);          // Special Function - For reading GIS line segements file and import line into ADDS
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtResult;
        }


        internal void DrawPanelFeeders(string strPanel, ref AcadAS.Document doc, ref AcadDB.Database dbDwg, ref AcadEd.Editor ed)
        {
            //ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            //string strPanel = alInputParameters[0].ToString();
            string strLayerName = null;

            ed.WriteMessage("\nDrawFeeders - started for panel: " + strPanel);

            try
            {
                //  Get Division for linetypes to be used.
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();

                //  Get polyline information from database
                DataSet dsFeederInfo = GetPloylineInfoFromAddsDB(strPanel);

                foreach (DataRow oRow in dsFeederInfo.Tables["Polylines"].Rows)
                {
                    strLayerName = oRow["adds_layer_nam"].ToString();

                    if (!string.IsNullOrEmpty(strLayerName))
                    {
                        using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                        {
                            AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                            AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                            bt.Dispose();           //  Cleanup memory for AutoCAD wrapper

                            AcadDB.Polyline2d pline = new AcadDB.Polyline2d();

                            //op.pldatatype, op.plattflw,
                            //op.plspace, op.plflag, op.plpolymshm, op.plpolymshn, op.plpolysmthm, op.plpolysmthn, op.plcrvsmttyp,
                            //op.device_id, op.adds_panel_id, op.plength

                            Utilities.CheckLayer(strLayerName);
                            pline.Layer = strLayerName;
                            pline.Thickness = double.Parse(oRow["plthick"].ToString());
                            pline.DefaultStartWidth = double.Parse(oRow["plwidbegin"].ToString());
                            pline.DefaultEndWidth = double.Parse(oRow["plwidend"].ToString());

                            AcadDB.LinetypeTable ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;

                            bool flagPowerLine = false;

                            if (strDiv == "GA")
                            {
                                if ((pline.Layer.Substring(5, 4) != "0000"))
                                {
                                    if (!ltt.Has("POWER_LINE"))
                                    {
                                        dbDwg.LoadLineTypeFile("POWER_LINE", "custom.lin");
                                    }
                                    pline.Linetype = "POWER_LINE";
                                    flagPowerLine = true;
                                }
                                else
                                {
                                    pline.Linetype = "CONTINUOUS";
                                }
                            }
                            ltt.Dispose();      //  Cleanup memory for AutoCAD wrapper

                            DataRow[] oRowsXData = dsFeederInfo.Tables["XData"].Select("Device_ID = '" + oRow["Device_ID"].ToString() + "'");
                            //  Reads XData from ADDSDB to modify polyline features
                            foreach (DataRow oRowXData in oRowsXData)
                            {
                                if (oRowXData["xdtname"].ToString() == "CLR_NUM" && !flagPowerLine)
                                {
                                    pline.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci,
                                        Utilities.GetAddsColorNumFromEMBColor(short.Parse(oRowXData["xdtvalue"].ToString())));
                                }
                                if (oRowXData["xdtname"].ToString() == "LINE_TYP")
                                {
                                    switch (oRowXData["xdtvalue"].ToString())
                                    {
                                        case "1":
                                            ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                                            if (!ltt.Has("Hidden"))
                                            {
                                                dbDwg.LoadLineTypeFile("Hidden", "acad.lin");
                                            }
                                            pline.Linetype = "Hidden";
                                            pline.LinetypeScale = 0.2;
                                            break;
                                        default:
                                            pline.Linetype = "CONTINUOUS";
                                            break;
                                    }
                                }
                            }

                            //  Adds new polylines to AutoCAD drawing database
                            btr.AppendEntity(pline);
                            btr.Dispose();                              //  Cleanup memory for AutoCAD wrapper
                            tr.AddNewlyCreatedDBObject(pline, true);


                            //  Adds vertexs for the polyline to AutoCAD drawing database 
                            //  Note that pline needs to be added to modelspace first before adding vertex data
                            DataRow[] oRowVertexs = dsFeederInfo.Tables["Vertex"].Select("Device_ID = '" + oRow["Device_ID"].ToString() + "'");
                            foreach (DataRow oRowVec in oRowVertexs)
                            {
                                //ov.vrtcnt, ov.vrtdatatype, ov.adds_layer_nam, 
                                //ov.vrtbulge, ov.vrttan, ov.vrtflag
                                AcadDB.Vertex2d vertex2d = new AcadDB.Vertex2d
                                {
                                    StartWidth = double.Parse(oRowVec["vrtwidbegin"].ToString()),
                                    EndWidth = double.Parse(oRowVec["vrtwidend"].ToString()),
                                    Position = new AcadGeo.Point3d(double.Parse(oRowVec["vrtpntx"].ToString()),
                                                                        double.Parse(oRowVec["vrtpnty"].ToString()),
                                                                        double.Parse(oRowVec["vrtpntz"].ToString())),
                                    Layer = pline.Layer  // [BUG FIX] 
                                };

                                //  Adds Vertex to AutoCAD drawing Database
                                pline.AppendVertex(vertex2d);
                                tr.AddNewlyCreatedDBObject(vertex2d, true);
                                
                                //  Cleanup memory for AutoCAD wrapper
                                vertex2d.Dispose();             //  Cleanup memory for AutoCAD wrapper
                            }

                            //  Adds any existing XData to AutoCAD drawing database
                            foreach (DataRow oRowXData in oRowsXData)
                            {
                                Adds.SetStoredXData(pline, oRowXData["xdtname"].ToString(), oRowXData["xdtvalue"].ToString());
                            }
                            Adds.SetStoredXData(pline, "ID", oRow["Device_ID"].ToString());
                            pline.Dispose();                    //  Cleanup memory for AutoCAD wrapper

                            tr.Commit();
                            tr.Dispose();
                        }
                    }
                }
                ed.WriteMessage("\nDrawFeeders - Done. \n");
                ed.Regen();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        //[Acad.CommandMethod("TestRead")]
        internal void DrawPolylineFromFileSp(string strLayerName, string strColorNum, string strLineType) //
        {
            string path = @"D:\ET Project Info\Adds Info\Gulf\ACC_TMC.txt";
            string strTemp = null;
            double strPtX;
            double strPtY;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                // Gets X and Y points from text file (path) and creates a collection of points for polyline vertices 
                AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();
                using (StreamReader sr = File.OpenText(path))
                {
                    while((strTemp = sr.ReadLine()) != null)
                    {
                        strTemp = strTemp.Replace("(", "");
                        strTemp = strTemp.Replace(")", "");
                        strPtX = double.Parse(strTemp.Substring(0, strTemp.IndexOf(",")));
                        strPtY = double.Parse(strTemp.Substring(strTemp.IndexOf(",") +1));
                    

                        AcadGeo.Point3d pt = new AcadGeo.Point3d((double)strPtX, (double)strPtY, 0.0);
                        pts.Add(pt);
                    }
                }

                using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                    AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                    bt.Dispose();       //  Cleanup memory for AutoCAD wrapper

                    //  Create Polyline
                    AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null);

                    if (!string.IsNullOrEmpty(strLayerName))
                    {
                        Utilities.CheckLayer(strLayerName);         // Creates layer if it does not exists.
                        pline.Layer = strLayerName;
                    }

                    if (!string.IsNullOrEmpty(strColorNum))
                    {
                        if (short.TryParse(strColorNum, out short sintColorNum))
                        {
                            pline.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, sintColorNum);
                            Adds.SetStoredXData(pline, "CLR_NUM", strColorNum);
                        }
                    }

                    if (!string.IsNullOrEmpty(strLineType))
                    {
                        AcadDB.LinetypeTable ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                        if (!ltt.Has(strLineType))
                        {
                            dbDwg.LoadLineTypeFile(strLineType, "acad.lin");
                        }
                        if (ltt.Has(strLineType))
                        {
                            pline.Linetype = strLineType;
                        }
                        if (strLineType == "Hidden")
                        {
                            Adds.SetStoredXData(pline, "LINE_TYP", "1");
                        }
                    }

                    btrModelSpace.AppendEntity(pline);
                    tr.AddNewlyCreatedDBObject(pline, true);

                    pline.Dispose();
                    tr.Commit();

                    //  Causes the polyline to be displayed in AutoCAD
                    ed.Regen();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }
        }
        internal void DrawPolyLine(string strLayerName, string strColorNum, string strLineType)
        {
            
            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Creates a collection of points to store vertices
                AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

                //  Setup the selection options/dialog interface for all the vertices in the polyline
                AcadEd.PromptPointOptions ppOptions = new AcadEd.PromptPointOptions("\nSelect polyline vertex: ")
                {
                    AllowNone = true
                };
                ppOptions.Keywords.Add("Close", "lC", "[C]lose");

                //  Get starting point
                AcadEd.PromptPointResult ppResult = ed.GetPoint(ppOptions);

                //  Get points until there are no more
                while (ppResult.Status == AcadEd.PromptStatus.OK && ppResult.Status != AcadEd.PromptStatus.Keyword)
                {
                    //  Add the selected point to the list
                    pts.Add(ppResult.Value);

                    ppOptions.UseBasePoint = true;
                    ppOptions.BasePoint = ppResult.Value;
                    ppResult = ed.GetPoint(ppOptions);
                    if (ppResult.Status == AcadEd.PromptStatus.OK)
                    {
                        ed.DrawVector(
                                pts[pts.Count - 1],         //  start point
                                ppResult.Value,             //  end point
                                7,                          //  line color
                                false);                     //  draw highlighted
                    }

                }

                if (ppResult.Status == AcadEd.PromptStatus.Keyword)
                {
                    switch (ppResult.StringResult)
                    {
                        case "Close":
                            pts.Add(pts[0]);
                            break;

                    }
                }

                if (ppResult.Status == AcadEd.PromptStatus.None || ppResult.StringResult == "Close")
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                        AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                        bt.Dispose();       //  Cleanup memory for AutoCAD wrapper

                        //  Create Polyline
                        AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null);

                        if (!string.IsNullOrEmpty(strLayerName))
                        {
                            Utilities.CheckLayer(strLayerName);         // Creates layer if it does not exists.
                            pline.Layer = strLayerName;
                        }

                        if (!string.IsNullOrEmpty(strColorNum))
                        {
                            if (short.TryParse(strColorNum, out short sintColorNum))
                            {
                                pline.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, sintColorNum);
                                Adds.SetStoredXData(pline, "CLR_NUM", strColorNum);
                            }
                        }

                        if (!string.IsNullOrEmpty(strLineType))
                        {
                            AcadDB.LinetypeTable ltt = tr.GetObject(dbDwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                            if (!ltt.Has(strLineType))
                            {
                                dbDwg.LoadLineTypeFile(strLineType, "acad.lin");
                            }
                            if (ltt.Has(strLineType))
                            {
                                pline.Linetype = strLineType;
                            }
                            if (strLineType == "Hidden")
                            {
                                Adds.SetStoredXData(pline, "LINE_TYP", "1");
                            }
                        }

                        //  Adds new polyline to AutoCAD drawing database
                        btrModelSpace.AppendEntity(pline);
                        tr.AddNewlyCreatedDBObject(pline, true);

                        pline.Dispose();
                        tr.Commit();

                        //  Causes the polyline to be displayed in AutoCAD
                        ed.Regen();
                    }
                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "ADDS DLL - System Exception");
            }

        }

        internal static AcadGeo.Point3d GetStartPointData(AcadDB.Entity obj)
        {
            AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
            if (p2d != null)
            {
                return new AcadGeo.Point3d(p2d.StartPoint.X, p2d.StartPoint.Y, p2d.Elevation);
            }
            return new AcadGeo.Point3d(0, 0, 0);
        }

        internal static AcadGeo.Point3d GetEndPointData(AcadDB.Entity obj)
        {
            AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
            if (p2d != null)
            {
                return new AcadGeo.Point3d(p2d.EndPoint.X, p2d.EndPoint.Y, p2d.Elevation);
            }
            return new AcadGeo.Point3d(0, 0, 0);
        }


        internal static PolylineInfo GetPolyLineInfo()
        {
            PolylineInfo polyLineInfo = new PolylineInfo();

            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            double dblSlopeInRads;
            double dblSlopeInDegs;
            double dblPerpendicularSlopeInRads;
            double dblPerpendicularSlopeInDegs;

            string strPolylineName = string.Empty;

            try
            {
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();

                AcadEd.PromptEntityResult entResult = ed.GetEntity("\nPick primary line: ");
                if (entResult.Status == AcadEd.PromptStatus.OK)
                {
                    AcadGeo.Point3d ptPicked = entResult.PickedPoint;
                    AcadGeo.Point3d ptOnPline = new AcadGeo.Point3d(0, 0, 0);
                    AcadDB.Polyline2d pline2d;

                    using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
                    {
                        AcadDB.DBObject dbObj = tr.GetObject(entResult.ObjectId, AcadDB.OpenMode.ForRead);
                        polyLineInfo.EntityName = dbObj.GetType().Name;

                        if (dbObj.GetType().Name == "Polyline2d")
                        {
                            pline2d = dbObj as AcadDB.Polyline2d;
                            ptOnPline = pline2d.GetClosestPointTo(ptPicked, true);
                            polyLineInfo.PickedPoint = ptPicked;
                            polyLineInfo.ClosestPoint = ptOnPline;
                            polyLineInfo.LayerName = pline2d.Layer;
                            
                            //long[] objName = new long[]{0,0};
                            //Adds.acdbGetAdsName(objName, entResult.ObjectId);
                            //Adds.acdbEntUpd(objName);
                            
                            polyLineInfo.DxfEntityName = dbObj.ObjectId; //objName[0].ToString("x");

                            //  Figure out Slope & Perpendicular slope.
                            if (ptPicked.X == ptOnPline.X && ptPicked.Y == ptOnPline.Y)          //  Check if horizontal line
                            {
                                dblSlopeInRads = 0;
                                dblPerpendicularSlopeInRads = Math.PI / 2;
                            }
                            else
                            {
                                dblPerpendicularSlopeInRads = Math.Atan((ptPicked.Y - ptOnPline.Y) / (ptPicked.X - ptOnPline.X));
                                if (dblPerpendicularSlopeInRads > 0)
                                {
                                    dblSlopeInRads = dblPerpendicularSlopeInRads - (Math.PI / 2);
                                }
                                else
                                {
                                    dblSlopeInRads = dblPerpendicularSlopeInRads + (Math.PI / 2);
                                    dblPerpendicularSlopeInRads = dblPerpendicularSlopeInRads + Math.PI;
                                }
                            }

                            polyLineInfo.SlopeInRads = dblSlopeInRads;
                            polyLineInfo.SlopePerpendicularInRads = dblPerpendicularSlopeInRads;

                            //  Convert to Degrees
                            dblSlopeInDegs = (dblSlopeInRads * 180.0) / Math.PI;
                            polyLineInfo.SlopeInDegs = dblSlopeInDegs;

                            dblPerpendicularSlopeInDegs = (dblPerpendicularSlopeInRads * 180.0) / Math.PI;
                            polyLineInfo.SlopePerpendicularInDegs = dblPerpendicularSlopeInDegs;
                            polyLineInfo.Thickness = pline2d.Thickness;

                            if (strDiv == "GA")
                            {
                                polyLineInfo.Type = "T";
                                polyLineInfo.PlantLoc = polyLineInfo.LayerName.Substring(0, 5);
                                polyLineInfo.LineID = polyLineInfo.LayerName.Substring(5, 4);
                                polyLineInfo.Voltage = polyLineInfo.LayerName.Substring(9, 2);
                            }

                            AcadDB.ResultBuffer resultBuffer = dbObj.GetXDataForApplication("ID");
                            if (resultBuffer != null)
                            {
                                AcadDB.TypedValue[] XdataOut = resultBuffer.AsArray();
                                polyLineInfo.DeviceID = XdataOut[1].Value.ToString();
                            }
                            resultBuffer = null;
                            resultBuffer = dbObj.GetXDataForApplication("CLR_NUM");
                            if (resultBuffer != null)
                            {
                                AcadDB.TypedValue[] XdataOut = resultBuffer.AsArray();
                                polyLineInfo.OverRideColorNumber = XdataOut[1].Value.ToString();
                            }
                            resultBuffer = null;
                            resultBuffer = dbObj.GetXDataForApplication("LINE_WDT");
                            if (resultBuffer != null)
                            {
                                AcadDB.TypedValue[] XdataOut = resultBuffer.AsArray();
                                polyLineInfo.OverRideLineWeight = XdataOut[1].Value.ToString();
                            }
                        }

                    }
                }
                else
                {
                    ed.WriteMessage("Canceled");

                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return polyLineInfo;
        }

        internal static DataSet GetPloylineInfoFromAddsDB(string Panel)
        {
            DataSet dsResults = null;
            string strOracleConn = Adds._strConn;
            string PanelName = Panel;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT lp.panel_name, omd.device_id, ");
            sbSQL.Append("  op.pldatatype, op.adds_layer_nam, op.plthick, op.plwidbegin, op.plwidend, op.plattflw, ");
            sbSQL.Append("  op.plspace, op.plflag, op.plpolymshm, op.plpolymshn, op.plpolysmthm, op.plpolysmthn, op.plcrvsmttyp, ");
            sbSQL.Append("  op.device_id, op.adds_panel_id "); //, op.plength
            sbSQL.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjPl op ");
            sbSQL.Append("WHERE UPPER(lp.panel_name) = :panelName ");  //'5703576' '6843560' 
            sbSQL.Append("  AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQL.Append("  AND omd.device_id = op.device_id ");
            sbSQL.Append("ORDER BY lp.panel_name, omd.device_id ");

            StringBuilder sbSQLVector = new StringBuilder();
            sbSQLVector.Append("SELECT lp.panel_name, omd.device_id, ");
            sbSQLVector.Append("    ov.vrtcnt, ov.vrtdatatype, ov.adds_layer_nam, ov.vrtpntx, ov.vrtpnty, ov.vrtpntz, ");
            sbSQLVector.Append("    ov.vrtwidbegin, ov.vrtwidend, ov.vrtbulge, ov.vrttan, ov.vrtflag ");
            sbSQLVector.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjPl op, AddsDB.ObjVrt ov ");
            sbSQLVector.Append("WHERE UPPER(lp.panel_name) = :panelName ");
            sbSQLVector.Append("    AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQLVector.Append("    AND omd.device_id = op.device_id ");
            sbSQLVector.Append("    AND op.device_id = ov.device_id ");
            sbSQLVector.Append("ORDER BY ov.device_id, ov.vrtcnt ");

            StringBuilder sbSQLXData = new StringBuilder();
            sbSQLXData.Append("SELECT lp.panel_name, omd.device_id, ora.xdtname, ora.xdtvalue ");
            sbSQLXData.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjPl op, AddsDB.ObjRgApp ora ");
            sbSQLXData.Append("WHERE UPPER(lp.panel_name) = :panelName ");
            sbSQLXData.Append("     AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQLXData.Append("     AND omd.device_id = op.device_id ");
            sbSQLXData.Append("     AND op.device_id = ora.device_id ");
            sbSQLXData.Append("ORDER BY op.device_id, ora.xdtname, ora.xdtvalue ");

            try
            {
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();          // [CHECKED] Oracle 12.c - Connection String

                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand
                    {
                        Connection = oracleConn,
                        CommandType = CommandType.Text,
                        CommandText = sbSQL.ToString()
                    };
                    oracleCommand.Parameters.Add("panelName", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = PanelName;


                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "Polylines");
                    da.Fill(ds);

                    oracleCommand.CommandText = sbSQLVector.ToString();
                    OracleDb.OracleDataAdapter daVertex = new OracleDb.OracleDataAdapter(oracleCommand);
                    daVertex.TableMappings.Add("Table", "Vertex");
                    daVertex.Fill(ds);
                    ds.Relations.Add("Polyline2Vertex",
                                        ds.Tables["Polylines"].Columns["device_id"],
                                        ds.Tables["Vertex"].Columns["device_id"]);


                    oracleCommand.CommandText = sbSQLXData.ToString();
                    OracleDb.OracleDataAdapter daXdata = new OracleDb.OracleDataAdapter(oracleCommand);
                    daXdata.TableMappings.Add("Table", "XData");
                    daXdata.Fill(ds);
                    ds.Relations.Add("Polyline2Xdata",
                                        ds.Tables["Polylines"].Columns["device_id"],
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

        #endregion *** Internal Functions ***
    }
}
