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
using Acad      = Autodesk.AutoCAD.Runtime;
using AcadAS    = Autodesk.AutoCAD.ApplicationServices;
using AcadDB    = Autodesk.AutoCAD.DatabaseServices;
using AcadEd    = Autodesk.AutoCAD.EditorInput;
using AcadGeo   = Autodesk.AutoCAD.Geometry;
using AcadColor = Autodesk.AutoCAD.Colors;
using AcadIn = Autodesk.AutoCAD.Internal;

namespace Adds
{
    public class AcadSymbol
    {

        #region  *** Public Functions ***

        [Acad.LispFunction("BlocksOnTop")]
        public void BlocksOnTop()
        {
            Utilities.ZoomExtents();

            ////  Get handles to current AutoCAD drawing session.
            //AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            //AcadDB.Database dbDwg = doc.Database;
            //AcadEd.Editor ed = doc.Editor;

            ////  Get Selection Set of all Blocks
            //AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
            //   {
            //        new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT")
            //   };
            //AcadEd.SelectionFilter sFilter = new AcadEd.SelectionFilter(tvFilterValues);
            //AcadEd.PromptSelectionResult pSelectResult = ed.SelectAll(sFilter);

            //// Create a collection containing all blocks
            //AcadDB.ObjectIdCollection objs;
            //if (pSelectResult.Status == AcadEd.PromptStatus.OK)
            //{
            //    objs = new AcadDB.ObjectIdCollection(pSelectResult.Value.GetObjectIds());
            //}
            //else
            //{
            //    objs = new AcadDB.ObjectIdCollection();
            //}
            //if (objs.Count > 0)
            //{
            //    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
            //    {
            //        foreach (AcadDB.ObjectId objId in objs)
            //        {
            //            AcadDB.DBObject dbObj = tr.GetObject(objId, AcadDB.OpenMode.ForRead);

            //            if (dbObj.GetType().Name == "BlockReference")
            //            {
            //                //  Get the block
            //                AcadDB.BlockTableRecord btr = tr.GetObject(dbObj.ObjectId, AcadDB.OpenMode.ForRead) as AcadDB.BlockTableRecord;

            //                //  Get the draw order table
            //                AcadDB.DrawOrderTable drawOrder = tr.GetObject(btr.DrawOrderTableId, AcadDB.OpenMode.ForWrite) as AcadDB.DrawOrderTable;

            //                AcadDB.ObjectIdCollection ids = new AcadDB.ObjectIdCollection();
            //                ids.Add(dbObj.ObjectId);

            //                drawOrder.MoveToTop(ids);

            //                tr.Commit();
            //            }

            //        }
            //    }
            //}


        }
        [Acad.LispFunction("CheckAttributes")]
        public void CheckAttributesFunction(AcadDB.ResultBuffer args)
        {
            CheckAttributes();
        }

        [Acad.CommandMethod("CheckAttributes")]
        public static void CheckAttributes()
        {
            AcadDB.BlockReference blockRef;
            
            string strBaseLayerName = null;
            string strAttribute = null;
            string strDeviceID = null;
            string strErrorLayer = "\n-- Attribute(s) Incorrect layers format: \n";
            string strMessage = "Attributes that where not correct: \n";
            Int64 intVertexsChecked = 0;
            bool flagError = false;
            bool flagLayerNameError = false;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                //  Get Division 
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();
                
                //  Get Panel List
                AcadDB.ResultBuffer rbResults2 = Adds.AcadGetSystemVariable("PanLst", ref stat);
                ArrayList alResults2 = Adds.ProcessInputParameters(rbResults2);
                string strPanLst = Utilities.DecodeListParameter((ArrayList) alResults2[0]);
                
                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT") 
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

                            if (dbObj.GetType().Name == "BlockReference")
                            {
                                blockRef = dbObj as AcadDB.BlockReference;
                                
                                strBaseLayerName = blockRef.Layer.ToString();

                                if (((strBaseLayerName.Length == 10) && (strDiv != "AL") && (strDiv != "GA"))
                                     || ((strBaseLayerName.Length == 11) && (strDiv == "AL") || (strDiv == "GA"))
                                     || ((strBaseLayerName.Length == 12) && (strDiv == "AL") && strBaseLayerName.Substring(5,1) == "M")
                                     || (strBaseLayerName.StartsWith("---"))
                                    )
                                {
                                    if (!strBaseLayerName.StartsWith("---"))
                                    {
                                        if (strDiv.ToUpper() == "GA" || strDiv.ToUpper() == "AL")
                                        {
                                            strAttribute = strBaseLayerName;
                                        }
                                        else if (strBaseLayerName == "0")
                                        {
                                            strAttribute = "0";
                                        }
                                        else
                                        {
                                            strAttribute = strBaseLayerName.Substring(0, 6) + "D" + strBaseLayerName.Substring(7);
                                            //  Checks if layer exists if not then it adds the layer
                                            Utilities.CheckLayer(strAttribute);
                                        }
                                        foreach (AcadDB.ObjectId arId in blockRef.AttributeCollection)
                                        {
                                            AcadDB.AttributeReference ar = (AcadDB.AttributeReference)tr.GetObject(arId, AcadDB.OpenMode.ForWrite);
                                            if (ar.Layer != strAttribute)
                                            {
                                                flagError = true;
                                                int n = 0;
                                                strDeviceID = null;
                                                if (blockRef.XData != null)
                                                {
                                                    foreach (AcadDB.TypedValue tv in blockRef.XData)
                                                    {
                                                        n++;
                                                        if (tv.Value.ToString() == "ID")
                                                        {
                                                            Array tv2 = blockRef.XData.AsArray();
                                                            strDeviceID = tv2.GetValue(n).ToString();
                                                        }
                                                    }
                                                }
                                                if (strDeviceID == null)
                                                {
                                                    strDeviceID = "Missing ID";
                                                }
                                                else
                                                {
                                                    strDeviceID = strDeviceID.Substring(6);
                                                }
                                                strMessage += "DeviceID: " + strDeviceID + " Base Layer: " + strBaseLayerName + " Old: " + ar.Layer + " New:" + strAttribute + "\n";
                                                ar.Layer = strAttribute;
                                            }
                                            intVertexsChecked += 1;
                                        }
                                    }
                                }
                                else
                                {
                                    flagLayerNameError = true;
                                    strErrorLayer += "--- Layer Name: " + strBaseLayerName + "\n";
                                }
                            }
                        }
                        tr.Commit();
                    }
                }
                if (flagError)
                {
                    ed.WriteMessage(strMessage);
                }
                if (flagLayerNameError)
                {
                    strErrorLayer += "--- You should check drawing object on the above layer names. --- ";
                    ed.WriteMessage(strErrorLayer);
                    string strErrorLog = "\nDate: " + DateTime.Now.ToString() + " Panel(s): " + strPanLst;
                    strErrorLog += strErrorLayer;
                    strErrorLog = strErrorLog.Replace("\n", "\r\n"); 
                    File.AppendAllText(@"C:\Adds\Logs\AddsLog.log", strErrorLog);                    
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("FixAttributes")]
        public void FixAttributes()
        {
            AcadDB.BlockReference blockRef;
            string strBaseLayerName = null;
            string strAttribute = null;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            try
            {
                AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Block to fix attributes: ");
                peo.SetRejectMessage("\nYou need to select a block");
                peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
                AcadEd.PromptEntityResult entResult = ed.GetEntity(peo);

                if (entResult.Status == AcadEd.PromptStatus.OK)
                {
                    using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                    {
                        AcadDB.DBObject dbObj = tr.GetObject(entResult.ObjectId, AcadDB.OpenMode.ForWrite);

                        if (dbObj.GetType().Name == "BlockReference")
                        {
                            blockRef = dbObj as AcadDB.BlockReference;
                            strBaseLayerName = blockRef.Layer.ToString();
                            //  Note must be in or exists in layer table
                            strAttribute = strBaseLayerName.Substring(0, 6) + "D" + strBaseLayerName.Substring(7);

                            foreach (AcadDB.ObjectId arId in blockRef.AttributeCollection)
                            {
                                AcadDB.AttributeReference ar = (AcadDB.AttributeReference)tr.GetObject(arId, AcadDB.OpenMode.ForWrite);
                                if (ar.Layer != strAttribute)
                                {
                                    ar.Layer = strAttribute;
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

        [Acad.LispFunction("InsertBlock")]
        public void InsertAddsBlock(AcadDB.ResultBuffer args)
        {
            string strBlockName = null;
            if (args != null)
            {
                ArrayList alInputParameters = Adds.ProcessInputParameters(args);
                strBlockName = alInputParameters[0].ToString();
            }
            PolylineInfo polylineInfo = null;
            try
            {
                polylineInfo = AcadLine.GetPolyLineInfo();

                //  Get Division from AutoLISP
                int stat = 0;
                AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                string strDiv = alResults[0].ToString();

                if (strDiv == "GA")
                {
                    CheckGCCSubBlock(ref polylineInfo);  // if substation block then updates layer name.
                }

                InsertBlock(strBlockName, polylineInfo);
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        [Acad.CommandMethod("ReplaceBlock")]
        public void ReplaceBlock()
        {
            string strBlockName = null;
            string strNewBlockName = null;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            //  Prompts user to select the block to be changed and gets a BlockReference to the instance of the block.
            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Symbol to replace: ");
            peo.SetRejectMessage("\nYou need to select a symbol");
            peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);

            AcadEd.PromptEntityResult per = ed.GetEntity(peo);
            if (per.Status == AcadEd.PromptStatus.OK)
            {
                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    //  Get existing Block name and reference for modification.
                    AcadDB.BlockReference br = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForWrite) as AcadDB.BlockReference;
                    AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(br.BlockTableRecord, AcadDB.OpenMode.ForRead);
                    strBlockName = btr.Name;

                    //  Opens Dialog box and seeds with existing block name.  Form querries AddsDB to get list of blocks
                    Forms.frmReplaceBlock oReplaceBlock = new Forms.frmReplaceBlock(strBlockName);
                    DialogResult drLineDialog;
                    drLineDialog = AcadAS.Application.ShowModalDialog(null, oReplaceBlock, true);
                    if (drLineDialog == DialogResult.OK)
                    {
                        strNewBlockName = oReplaceBlock.BlockName;

                        oReplaceBlock.Dispose();

                        if (strNewBlockName != strBlockName)
                        {
                            //  Gets BlockTableRecord ID for new block
                            AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(db.BlockTableId, AcadDB.OpenMode.ForRead, false);
                            AcadDB.ObjectId tableID = AcadDB.ObjectId.Null;
                            if (!bt.Has(strNewBlockName))
                            {
                                ed.WriteMessage("\nblock not found.");
                                AcadDB.Database dbSymbol = new AcadDB.Database(false, true);
                                dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + strNewBlockName + ".dwg", System.IO.FileShare.None, false, null);
                                tableID = db.Insert(strNewBlockName, dbSymbol, false);
                            }
                            else
                            {
                                tableID = GetTableRecordId(bt.ObjectId, strNewBlockName);
                            }

                            //  Assigns or changes original selected block with new block
                            br.BlockTableRecord = tableID;

                            tr.Commit();
                            ed.WriteMessage("\nDone replacing block " + strBlockName + " with " + strNewBlockName + " Block");
                        }
                        else
                        {
                            ed.WriteMessage("\nThe ReplaceBlock command did not replace the block because you did not choose a new block.");
                        }
                    }
                    else
                    {
                        ed.WriteMessage("\nThe ReplaceBlock command was canceled.");
                    }
                }
            }
            else
            {
                ed.WriteMessage("\nThe ReplaceBlock command was canceled or you escaped.");
            }
        }

        [Acad.CommandMethod("TestObj")]
        public void GetBasicEntityInfoFromDwg()
        {
            string strEntityType = null;
            string strLayer = null;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect either Powerline or Symbol to get information from: ");
            peo.SetRejectMessage("\nYou need to select a polyline or symbol");
            peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
            peo.AddAllowedClass(typeof(AcadDB.Polyline2d), false);

            AcadEd.PromptEntityResult per = ed.GetEntity(peo);
            if (per.Status == AcadEd.PromptStatus.OK)
            {
                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    AcadDB.DBObject obj = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForRead);
                    strEntityType = obj.GetType().Name;
                    switch (strEntityType)
                    {
                        case "Polyline2d":
                            AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
                            strLayer = p2d.Layer;

                            break;
                        case "BlockReference":
                            AcadDB.BlockReference br = obj as AcadDB.BlockReference;
                            strLayer = br.Layer;
                            break;

                    }
                }

            }

        }

        [Acad.CommandMethod("TestWriteSW")]
        public void WriteSwitchesToFile()
        {
            string path = @"D:\ET Project Info\Adds Info\MPCo\Switches.txt";
            string strInvItemID = null;

            AcadDB.BlockReference blockRef;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName,"symbol1_1")
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
                    if (!File.Exists(path))
                    {
                        using (StreamWriter sw = File.CreateText(path))
                        {
                            using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                            {
                                foreach (AcadDB.ObjectId PlId in objs)
                                {
                                    AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForRead);
                                    if (dbObj.GetType().Name == "BlockReference")
                                    {
                                        blockRef = dbObj as AcadDB.BlockReference;
                                        AcadDB.ResultBuffer rb = dbObj.XData;
                                        if (rb != null)
                                        {
                                            string strTemp = string.Empty;
                                            bool flagReadNext = false;
                                            foreach (AcadDB.TypedValue tv in rb)
                                            {
                                                if (tv.Value.ToString() == "INVITM_ID")
                                                {
                                                    flagReadNext = true;
                                                }
                                                if (flagReadNext && (tv.Value.ToString() != "INVITM_ID"))
                                                {
                                                    strInvItemID = tv.Value.ToString();
                                                    flagReadNext = false;
                                                }
                                            }
                                        }
                                        sw.WriteLine(strInvItemID + ", " + blockRef.Position.ToString());
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

        [Acad.CommandMethod("TestWriteSub")]
        public void WriteGISBlocksTo()
        {
            int intIndex = 0;
            string strPlantCode = "AR101";  // AR201 for Gulf
            string strLineCode = "00000";
            string strFacID = string.Empty;
            //string strVoltage = null;
            string path = @"D:\ET Project Info\Adds Info\MPCo\SUBS.txt";
            AcadDB.BlockReference blockRef;
            DataTable dtResults = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName,"symbol1_0")
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
                    if (!File.Exists(path))
                    {
                        using (StreamWriter sw = File.CreateText(path))
                        {

                            using (AcadDB.Transaction tr = dbDwg.TransactionManager.StartTransaction())
                            {
                                foreach (AcadDB.ObjectId PlId in objs)
                                {
                                    AcadDB.DBObject dbObj = tr.GetObject(PlId, AcadDB.OpenMode.ForRead);

                                    if (dbObj.GetType().Name == "BlockReference")
                                    {
                                        blockRef = dbObj as AcadDB.BlockReference;

                                        AcadDB.ResultBuffer rb = dbObj.XData;
                                        if (rb != null)
                                        {
                                            string strTemp = string.Empty; //,strDeviceId, strLineId, strPlantId, strEditYMDT;
                                            bool flagReadNext = false;
                                            foreach (AcadDB.TypedValue tv in rb)
                                            {
                                                if (tv.Value.ToString() == "FAC_ID")
                                                {
                                                    flagReadNext = true;
                                                }
                                                if (flagReadNext && (tv.Value.ToString() != "FAC_ID"))
                                                {
                                                    strFacID = tv.Value.ToString();
                                                    strPlantCode = "M" + strFacID.PadLeft(4, '0');
                                                    flagReadNext = false;
                                                    dtResults = GetFacitlyInfoFromStomp(strFacID);
                                                }
                                            }
                                            ed.WriteMessage("\n XData {0}", strTemp);
                                        }
                                        if (dtResults.Rows.Count > 0)
                                        {
                                            DataRow drResult = dtResults.Rows[0];
                                            intIndex += 1;
                                            sw.WriteLine(intIndex.ToString() + ", " + strFacID + ", " + strPlantCode + ", " + strLineCode + ", " +
                                                    drResult["fac_hivolt_kv_num"].ToString() + ", " + drResult["fac_lowvolt_kv_num"].ToString() + ", " + drResult["fac_total_mva_num"].ToString() + ", " +
                                                    blockRef.Position.ToString() + ", " + drResult["fac_nam"].ToString().ToUpper() + " " + drResult["fac_type_cod"].ToString().ToUpper());
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

        [Acad.CommandMethod("TestDrawSw")]
        public void DrawSwsFromFile()
        {
            string path = @"D:\ET Project Info\Adds Info\MPCo\Switches.txt";
            string strTemp = null;
            string strTemp2 = null;
            string strInvItemID = null;
            string strLayerName = null;
            string strOptNum = null;
            string strPlantLoc = "AR101";
            string strLineID = null;
            //string strVoltage = null;
            string strVoltCode = "00";
            string strBlockName = null;
            string strDeBug = null;
                        
            double dblPtX;
            double dblPtY;
            double dblScaleFactor;

            int intFirstC = 0;
            int intFirstP = 0;
            int intSecP = 0;

            DataTable dtResults = null;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

                using (StreamReader sr = File.OpenText(path))
                {
                    while ((strTemp = sr.ReadLine()) != null)
                    {
                        //  Get STOMP Inventory ID from file
                        intFirstC = strTemp.IndexOf(",");
                        strInvItemID = strTemp.Substring(0, intFirstC);

                        // Get insertion point from file
                        intFirstP = strTemp.IndexOf("(");
                        intSecP = strTemp.IndexOf(")", intFirstP);
                        strTemp2 = strTemp.Substring(intFirstP + 1, intSecP - intFirstP - 2).TrimEnd(',');
                        dblPtX = double.Parse(strTemp2.Substring(0, strTemp2.IndexOf(",")));
                        dblPtY = double.Parse(strTemp2.Substring(strTemp2.IndexOf(",") + 1));
                        AcadGeo.Point3d pt = new AcadGeo.Point3d((double)dblPtX, (double)dblPtY, 0.0);
                        pts.Add(pt);

                        //  Get information from STOMP for creating Adds Layer, selecting which block to insert and Operator Number.
                        dtResults = GetSwitchInfoFromStomp(strInvItemID);

                        if (dtResults.Rows.Count > 0)
                        {
                            DataRow drResult = dtResults.Rows[0];

                            //  Create Adds Layer Name
                            strLineID = "M" + drResult["ln_id"].ToString().PadLeft(3, '0');
                            strVoltCode = Utilities.GetAddsVoltageCode(drResult["ln_oper_kv_num"].ToString());
                            strLayerName = strPlantLoc + strLineID + strVoltCode;

                            //  Determine which block to use
                            switch (drResult["equip_subclass_cod"].ToString())
                            {
                                case "LR":
                                    strBlockName = "A813";      // Motor Operated Gang Switch NC
                                    break;
                                case "GS":
                                    strBlockName = "A811";      // Gang Switch NC
                                    break;
                                case "SW_Unk":
                                    strBlockName = "A809";      // Fused Cutout NC
                                    break;
                                default:
                                    strBlockName = "A809";      // Gang Switch NC
                                    break;
                            }

                            //  Get OptNum
                            strOptNum = drResult["operpt_num"].ToString();

                            AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                            using (tr)
                            {
                                AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead);
                                AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, true, true);

                                //  Check to see if block class exists in drawing if not load it.
                                AcadDB.ObjectId tableID = AcadDB.ObjectId.Null;
                                if (!bt.Has(strBlockName))
                                {
                                    if (!string.IsNullOrEmpty(strDeBug))
                                    {
                                        ed.WriteMessage("\nblock " + strBlockName + " not found in AutoCAD drawing loading from C drive.");
                                    }
                                    AcadDB.Database dbSymbol = new AcadDB.Database(false, true);
                                    dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + strBlockName + ".dwg", System.IO.FileShare.Read, false, null);
                                    tableID = dbDwg.Insert(strBlockName, dbSymbol, false);
                                    dbSymbol.Dispose();
                                }
                                else
                                {
                                    tableID = GetTableRecordId(bt.ObjectId, strBlockName);
                                }
                                bt.Dispose();                                           //  Cleanup memory for AutoCAD wrapper

                                AcadDB.BlockTableRecord btrSymbol = (AcadDB.BlockTableRecord)tr.GetObject(tableID, AcadDB.OpenMode.ForRead);

                                AcadDB.BlockReference br = new AcadDB.BlockReference(pt, btrSymbol.ObjectId);

                                //  Set Block scale factors
                                dblScaleFactor = 100;
                                br.ScaleFactors = new AcadGeo.Scale3d(dblScaleFactor, dblScaleFactor, 1.0);

                                //  Set Block Layer
                                Utilities.CheckLayer(strLayerName);
                                br.Layer = strLayerName;

                                //  Adds new Block to AutoCAD drawing database
                                btrModelSpace.AppendEntity(br);
                                btrModelSpace.Dispose();                                          //  Cleanup memory for AutoCAD wrapper

                                tr.AddNewlyCreatedDBObject(br, true);

                                Dictionary<AcadDB.ObjectId, AttInfo> attInfo = new Dictionary<Autodesk.AutoCAD.DatabaseServices.ObjectId, AttInfo>();
                                if (btrSymbol.HasAttributeDefinitions)
                                {
                                    foreach (AcadDB.ObjectId id in btrSymbol)
                                    {
                                        AcadDB.DBObject obj = tr.GetObject(id, AcadDB.OpenMode.ForRead);
                                        AcadDB.AttributeDefinition ad = obj as AcadDB.AttributeDefinition;

                                        if (ad != null)  // if (ad != null && !ad.Constant)
                                        {
                                            AcadDB.AttributeReference ar = new AcadDB.AttributeReference();
                                            ar.SetAttributeFromBlock(ad, br.BlockTransform);
                                            ar.Position = ad.Position.TransformBy(br.BlockTransform);

                                            ar.Height = 20.0;
                                            Utilities.CheckLayer(strPlantLoc + "0000" + strVoltCode);
                                            ar.Layer = strPlantLoc + "0000" + strVoltCode;

                                            switch (ad.Tag)
                                            {
                                                case "LOC_NUM":
                                                    ar.TextString = strOptNum;
                                                    break;
                                                case "DESCRIPT":
                                                    ar.TextString = "";
                                                    break;
                                                case "UNIT":
                                                    ar.TextString = "";
                                                    break;
                                            }

                                            ar.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 7);

                                            AcadDB.ObjectId arID = br.AttributeCollection.AppendAttribute(ar);
                                            tr.AddNewlyCreatedDBObject(ar, true);
                                        }

 
                                    }
                                    tr.Commit();
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

        [Acad.CommandMethod("TestDrawSub")]
        public void DrawSubsFromFile()
        {
            string path = @"D:\ET Project Info\Adds Info\MPCo\SUBS.txt";
            string strTemp = null;
            string strTemp2 = null;
            string strPlantLoc = null;
            string strDescription = null;
            string strVoltage = null;
            string strVoltCode = "00";

            string BlockName = "A822";
            string strDeBug = null;

            double strPtX;
            double strPtY;
            double dblScaleFactor;

            int intFirstC = 0;
            int intSecC = 0;
            int intThridC = 0;
            int intForthC = 0;
            int intFifthC = 0;
            //int intSixthC = 0;

            int intFirstP = 0;
            int intSecP = 0;

            try
            {
                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database dbDwg = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();
                
                using (StreamReader sr = File.OpenText(path))
                {
                    while ((strTemp = sr.ReadLine()) != null)
                    {
                        //  Get PlantLoc
                        intFirstC   = strTemp.IndexOf(",");
                        intSecC     = strTemp.IndexOf(",", intFirstC + 1);
                        intThridC   = strTemp.IndexOf(",", intSecC + 1);
                        strPlantLoc = strTemp.Substring(intSecC + 2, intThridC - intSecC - 2);

                        // Get Sub Hi Side Voltage
                        intForthC   = strTemp.IndexOf(",", intThridC + 1);
                        intFifthC   = strTemp.IndexOf(",", intForthC + 1);
                        strVoltage = strTemp.Substring(intForthC + 2, intFifthC - intForthC - 2);
                        strVoltCode = "00";

                        switch (strVoltage)
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
                            case "13":
                                strVoltCode = "13";
                                break;
                            case "115":
                                strVoltCode = "15";
                                break;
                            case "20":
                                strVoltCode = "20";
                                break;
                            case "23":
                                strVoltCode = "03";
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



                        // Get Insertion Point
                        intFirstP = strTemp.IndexOf("(");
                        intSecP = strTemp.IndexOf(")", intFirstP);
                        strTemp2 = strTemp.Substring(intFirstP + 1, intSecP - intFirstP - 2).TrimEnd(','); 
                        strPtX = double.Parse(strTemp2.Substring(0, strTemp2.IndexOf(",")));
                        strPtY = double.Parse(strTemp2.Substring(strTemp2.IndexOf(",")+1));
                        AcadGeo.Point3d pt = new AcadGeo.Point3d((double)strPtX, (double)strPtY, 0.0);
                        pts.Add(pt);

                        //  Get Sub Description
                        strDescription = strTemp.Substring(strTemp.LastIndexOf(",") + 2);

                        AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                        using (tr)
                        {
                            AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead);
                            AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, true, true);

                            //  Check to see if block class exists in drawing if not load it.
                            AcadDB.ObjectId tableID = AcadDB.ObjectId.Null;
                            if (!bt.Has(BlockName))
                            {
                                if (!string.IsNullOrEmpty(strDeBug))
                                {
                                    ed.WriteMessage("\nblock " + BlockName + " not found in AutoCAD drawing loading from C drive.");
                                }
                                AcadDB.Database dbSymbol = new AcadDB.Database(false, true);
                                dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + BlockName + ".dwg", System.IO.FileShare.Read, false, null);
                                tableID = dbDwg.Insert(BlockName, dbSymbol, false);
                                dbSymbol.Dispose();
                            }
                            else
                            {
                                tableID = GetTableRecordId(bt.ObjectId, BlockName);
                            }
                            bt.Dispose();                                           //  Cleanup memory for AutoCAD wrapper

                            AcadDB.BlockTableRecord btrSymbol = (AcadDB.BlockTableRecord)tr.GetObject(tableID, AcadDB.OpenMode.ForRead);

                            AcadDB.BlockReference br = new AcadDB.BlockReference(pt, btrSymbol.ObjectId);

                            //  Set Block scale factors
                            dblScaleFactor = 100;
                            br.ScaleFactors = new AcadGeo.Scale3d(dblScaleFactor, dblScaleFactor, 1.0);

                            //  Set Block Layer
                            Utilities.CheckLayer(strPlantLoc + "0000" + strVoltCode);
                            br.Layer = strPlantLoc + "0000" + strVoltCode;

                            //  Adds new Block to AutoCAD drawing database
                            btrModelSpace.AppendEntity(br);
                            btrModelSpace.Dispose();                                          //  Cleanup memory for AutoCAD wrapper

                            tr.AddNewlyCreatedDBObject(br, true);

                            Dictionary<AcadDB.ObjectId, AttInfo> attInfo = new Dictionary<Autodesk.AutoCAD.DatabaseServices.ObjectId, AttInfo>();
                            //bool flagAlignment = false;
                            if (btrSymbol.HasAttributeDefinitions)
                            {
                                foreach (AcadDB.ObjectId id in btrSymbol)
                                {
                                    AcadDB.DBObject obj = tr.GetObject(id, AcadDB.OpenMode.ForRead);
                                    AcadDB.AttributeDefinition ad = obj as AcadDB.AttributeDefinition;

                                    if (ad != null)  // if (ad != null && !ad.Constant)
                                    {
                                        AcadDB.AttributeReference ar = new AcadDB.AttributeReference();
                                        ar.SetAttributeFromBlock(ad, br.BlockTransform);
                                        ar.Position = ad.Position.TransformBy(br.BlockTransform);

                                        ar.Height = 20.0;
                                        Utilities.CheckLayer(strPlantLoc + "0000" + strVoltCode);
                                        ar.Layer = strPlantLoc + "0000" + strVoltCode;

                                        switch (ad.Tag)
                                        {
                                            case "LOC_NUM":
                                                ar.TextString = strPlantLoc;
                                                break;
                                            case "DESCRIPT":
                                                ar.TextString = strDescription;
                                                break;
                                            case "UNIT":
                                                ar.TextString = "";
                                                break;
                                        }

                                        ar.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 7);

                                        AcadDB.ObjectId arID = br.AttributeCollection.AppendAttribute(ar);
                                        tr.AddNewlyCreatedDBObject(ar, true);
                                    }

 
                                }
                                tr.Commit();
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

        [Acad.CommandMethod("txt2at", Acad.CommandFlags.UsePickSet |
            Acad.CommandFlags.Redraw |
            Acad.CommandFlags.Modal)
        ]
        static public void PickFirstTest()
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            // Ask the user to select a block
            AcadEd.PromptEntityOptions peo2 = new AcadEd.PromptEntityOptions("\nSelect the block:");
            peo2.AllowNone = false;
            peo2.SetRejectMessage("\nMust select a block.");
            peo2.AddAllowedClass(typeof(AcadDB.BlockReference), false);
            AcadEd.PromptEntityResult per2 = ed.GetEntity(peo2);
            if (per2.Status != AcadEd.PromptStatus.OK)
                return;

            //Open the entity using a transaction
            AcadDB.Transaction tr = db.TransactionManager.StartTransaction();
            using (tr)
            {
                try
                {
                    AcadDB.BlockReference blck = (AcadDB.BlockReference)tr.GetObject(per2.ObjectId, AcadDB.OpenMode.ForRead);
                    AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(blck.BlockTableRecord, AcadDB.OpenMode.ForRead);
                    if (btr.HasAttributeDefinitions)
                    {
                        AcadDB.AttributeCollection attCol = blck.AttributeCollection;
                        foreach (AcadDB.ObjectId attId in attCol)
                        {
                            AcadDB.AttributeReference attRef = (AcadDB.AttributeReference)tr.GetObject(attId, AcadDB.OpenMode.ForWrite);
                            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect the text for " + attRef.Tag + ":");
                            peo.AllowNone = true;
                            peo.SetRejectMessage("\nSelect the text for " + attRef.Tag + ":");
                            peo.AddAllowedClass(typeof(AcadDB.DBText), false);
                            AcadEd.PromptEntityResult per = ed.GetEntity(peo);
                            if (per.Status == AcadEd.PromptStatus.OK)
                            {
                                //Get all the text attributes to transfer to the attribute
                                AcadDB.DBText txt = (AcadDB.DBText)tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForWrite);
                                double textX = txt.Position.X;
                                double texty = txt.Position.Y;
                                double textang = txt.Rotation;
                                double textsize = txt.Height;
                                Int32 txtcolor = txt.ColorIndex;

                                //Set the attribute Horizontal Mode to Left for .position to work
                                attRef.HorizontalMode = AcadDB.TextHorizontalMode.TextLeft;

                                //Apply the text attributes to the block attribute
                                attRef.Rotation = textang;
                                attRef.Height = textsize;
                                attRef.ColorIndex = 256;  // txtcolor;
                                attRef.TextString = txt.TextString;
                                attRef.Position = new AcadGeo.Point3d(textX, texty, 0);
                                attRef.Layer = blck.Layer;

                                //Erase text
                                txt.Erase();
                            }
                        }
                    }
                    tr.Commit();
                }
                catch (Autodesk.AutoCAD.Runtime.Exception e)
                {
                    // Something went wrong
                    ed.WriteMessage(e.ToString());
                }

            }
        }

        #endregion *** Public Functions ***


        #region *** Internal Functions ***

        internal static void DrawPanelSymbols(string strPanel, string strDeBug, ref AcadAS.Document doc, ref AcadDB.Database dbDwg, ref AcadEd.Editor ed)
        {
            //ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            //string strPanel = alInputParameters[0].ToString();
            
            //string strDeBug = null;
            //if (alInputParameters.Count == 2)
            //{
            //    strDeBug = alInputParameters[1].ToString();
            //}
            ed.WriteMessage("\nDrawPanelSymbols - started for panel: " + strPanel);

            string BlockName = null, strLayerName = null, strDeviceID = null;
            double doubleValueX, doubleValueY, doubleValueZ, doubleRotation;
            bool fCenter = false;

            try
            {
                //  Get all blocks in panel from the database
                DataSet dsFeederInfo = GetSymbolInfoFromAddsDB(strPanel);

                foreach (DataRow oRow in dsFeederInfo.Tables["Blocks"].Rows)
                {
                    strDeviceID = null;
                    strDeviceID = oRow["device_id"].ToString();

                    BlockName = null;
                    BlockName = oRow["adds_blk_nam"].ToString();
                    if (!string.IsNullOrEmpty(BlockName))
                    {
                        if (double.TryParse(oRow["blkpntx"].ToString(), out doubleValueX)
                            && double.TryParse(oRow["blkpnty"].ToString(), out doubleValueY)
                            && double.TryParse(oRow["blkpntz"].ToString(), out doubleValueZ))
                        {
                            AcadGeo.Point3d insertPt = new AcadGeo.Point3d(doubleValueX, doubleValueY, doubleValueZ);

                            if (double.TryParse(oRow["blksclx"].ToString(), out doubleValueX)
                                && double.TryParse(oRow["blkscly"].ToString(), out doubleValueY)
                                && double.TryParse(oRow["blksclz"].ToString(), out doubleValueZ))
                            {
                                AcadGeo.Scale3d scalefactors = new AcadGeo.Scale3d(doubleValueX, doubleValueY, doubleValueZ);

                                strLayerName = null;
                                strLayerName = oRow["adds_layer_nam"].ToString();
                                if (!string.IsNullOrEmpty(strLayerName))
                                {
                                    if (double.TryParse(oRow["blkrot"].ToString(), out doubleValueX))
                                    {
                                        doubleRotation = doubleValueX;

                                        using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                                        {
                                            AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead);
                                            AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, true, true);

                                            //  Check to see if block class exists in drawing if not load it.
                                            AcadDB.ObjectId tableID = AcadDB.ObjectId.Null;
                                            if (!bt.Has(BlockName))
                                            {
                                                if (!string.IsNullOrEmpty(strDeBug))
                                                {
                                                    ed.WriteMessage("\nblock " + BlockName + " not found in AutoCAD drawing loading from C drive.");
                                                }
                                                AcadDB.Database dbSymbol = new AcadDB.Database(false, true);
                                                dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + BlockName + ".dwg", System.IO.FileShare.Read, false, null);
                                                tableID = dbDwg.Insert(BlockName, dbSymbol, false);
                                                dbSymbol.Dispose();
                                            }
                                            else
                                            {
                                                tableID = GetTableRecordId(bt.ObjectId, BlockName);
                                            }
                                            bt.Dispose();                                           //  Cleanup memory for AutoCAD wrapper

                                            // Create Block reference for insertion at insertion point based on fields blkpntx, blkpnty, and blkpntz 
                                            AcadDB.BlockReference br = new AcadDB.BlockReference(insertPt, tableID);

                                            //  Sets up block properties from DB record
                                            br.ScaleFactors = scalefactors;

                                            Utilities.CheckLayer(strLayerName);
                                            br.Layer = strLayerName;
                                            br.Rotation = doubleRotation;

                                            //  Adds new Block to AutoCAD drawing database
                                            btrModelSpace.AppendEntity(br);
                                            btrModelSpace.Dispose();                                          //  Cleanup memory for AutoCAD wrapper
                                            tr.AddNewlyCreatedDBObject(br, true);

                                            AcadDB.BlockTableRecord btrAttRec = (AcadDB.BlockTableRecord)tr.GetObject(tableID, AcadDB.OpenMode.ForRead, true, true);
                                            if (btrAttRec.HasAttributeDefinitions)
                                            {
                                                AcadDB.BlockTableRecordEnumerator btrEnum = btrAttRec.GetEnumerator();      // List or pointer of attributes definitions used in while loop to look at all block tags
                                                AcadDB.Entity ent = null;
                                                btrAttRec.Dispose();                                      //  Cleanup memory for AutoCAD wrapper

                                                // Get the Attributes using Block Attribute prompts.
                                                AcadDB.AttributeCollection attrCol = br.AttributeCollection;

                                                DataRow[] oRowAttrs = dsFeederInfo.Tables["Attributes"].Select("Device_ID = '" + oRow["Device_ID"].ToString() + "'");
                                                int iCount = oRowAttrs.Length;
                                                while (btrEnum.MoveNext())
                                                {
                                                    ent = (AcadDB.Entity)btrEnum.Current.GetObject(AcadDB.OpenMode.ForWrite);
                                                    if (ent is AcadDB.AttributeDefinition)
                                                    {
                                                        AcadDB.AttributeDefinition attdef = (AcadDB.AttributeDefinition)ent;
                                                        AcadDB.AttributeReference attref = new AcadDB.AttributeReference(); // null;
                                                        attref.SetAttributeFromBlock(attdef, br.BlockTransform);

                                                        if (iCount > 0)
                                                        {
                                                            foreach (DataRow oRowAttr in oRowAttrs)
                                                            {
                                                                if (attdef.Tag == oRowAttr["atttag"].ToString())
                                                                {
                                                                    attref.Height = double.Parse(oRowAttr["atthgt"].ToString());
                                                                    attref.Rotation = double.Parse(oRowAttr["attrot"].ToString());
                                                                    attref.TextString = oRowAttr["attvalue"].ToString();
                                                                    Utilities.CheckLayer(oRowAttr["adds_layer_nam"].ToString());
                                                                    attref.Layer = oRowAttr["adds_layer_nam"].ToString();
                                                                    attref.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 7);

                                                                    attref.Position = new AcadGeo.Point3d(
                                                                    double.Parse(oRowAttr["attnpntx"].ToString()),
                                                                    double.Parse(oRowAttr["attnpnty"].ToString()),
                                                                    double.Parse(oRowAttr["attnpntz"].ToString()));

                                                                    //  Check to see if Alignment point is required, if not it will throw an error if created and not required.
                                                                    if (!(attdef.VerticalMode == AcadDB.TextVerticalMode.TextBase
                                                                        && (attdef.HorizontalMode == AcadDB.TextHorizontalMode.TextLeft
                                                                            || attdef.HorizontalMode == AcadDB.TextHorizontalMode.TextAlign
                                                                            || attdef.HorizontalMode == AcadDB.TextHorizontalMode.TextFit)))
                                                                    {
                                                                        attref.AlignmentPoint = new AcadGeo.Point3d(
                                                                                                    double.Parse(oRowAttr["attjpntx"].ToString()),
                                                                                                    double.Parse(oRowAttr["attjpnty"].ToString()),
                                                                                                    double.Parse(oRowAttr["attjpntz"].ToString()));
                                                                        fCenter = true;
                                                                    }
                                                                    else
                                                                    {
                                                                        attref.Position = new AcadGeo.Point3d(
                                                                                                double.Parse(oRowAttr["attnpntx"].ToString()),
                                                                                                double.Parse(oRowAttr["attnpnty"].ToString()),
                                                                                                double.Parse(oRowAttr["attnpntz"].ToString()));
                                                                        fCenter = false;
                                                                    }

                                                                    if (fCenter)    // This section for new ADDS DB based on TMap data restore.  If so un-comment code below so Left justification will be adjust to center 
                                                                    {
                                                                        AcadGeo.Point2d p2d = Autodesk.AutoCAD.Internal.Utils.GetTextExtents(attref.ObjectId, attref.TextString, attref.Height);
                                                                        attref.AlignmentPoint = new AcadGeo.Point3d(attref.AlignmentPoint.X + (p2d.X / 2),
                                                                                                        attref.AlignmentPoint.Y,
                                                                                                        0);
                                                                    }
                                                                    iCount--;
                                                                }
                                                                else
                                                                {
                                                                    //attref.TextString = "";
                                                                    attref.Layer = strLayerName;    //  [TODO] this maybe an incorrect assumption.
                                                                    attref.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 7);
                                                                }
                                                            }   // Loop End foreach
                                                            
                                                            //attdef.Dispose();                       //  Cleanup memory for AutoCAD wrapper
                                                        }
                                                        else
                                                        {
                                                            attref.TextString = "";
                                                            attref.Layer = strLayerName;    //  [TODO] this maybe an incorrect assumption.
                                                            attref.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByLayer, 7);
                                                        }
                                                        attdef.Dispose();                       //  Cleanup memory for AutoCAD wrapper
                                                        attrCol.AppendAttribute(attref);
                                                        tr.AddNewlyCreatedDBObject(attref, true);

                                                        attref.Dispose();                           //  Cleanup memory for AutoCAD wrapper

                                                    }  // this end
                                                }
                                                btrEnum.Dispose();                                  //  Cleanup memory for AutoCAD wrapper
                                            }

                                            //  Adds XData to block instance
                                            DataRow[] oRowsXData = dsFeederInfo.Tables["XData"].Select("Device_ID = '" + oRow["Device_ID"].ToString() + "'");
                                            foreach (DataRow oRowXData in oRowsXData)
                                            {
                                                Adds.SetStoredXData(br, oRowXData["xdtname"].ToString(), oRowXData["xdtvalue"].ToString());
                                            }
                                            bt.Dispose();                                           //  Cleanup memory for AutoCAD wrapper
                                            tr.Commit();
                                        }
                                    }
                                }
                                else
                                {
                                    ed.WriteMessage("\nBlock layer for Device ID: " + strDeviceID + " is not valid.");
                                }
                            }
                            else
                            {
                                ed.WriteMessage("\nBlock scale factor for Device ID: " + strDeviceID + "  not valid.");
                            }
                        }
                        else
                        {
                            ed.WriteMessage("\nBlock insertion point for Device ID: " + strDeviceID + " not valid.");
                        }
                    }
                    else
                    {
                        ed.WriteMessage("\nBlock name for Device ID: " + strDeviceID + " not valid.");
                    }
                }
                ed.WriteMessage("\nDrawPanelSymbols - Done. \n");
                ed.Regen();
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                //dbDwg.Dispose();
                //doc.Dispose();
            }
        }

        internal static DataTable GetFacitlyInfoFromStomp(string facID)
        {
            DataTable dtResult = null;
            string strOracleConn = "Data Source=tnmp;User ID=STOMPDMC;Password=richard;Pooling=false;";
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT f.fac_id,f.fac_hivolt_kv_num, f.fac_lowvolt_kv_num, f.fac_total_mva_num, ");
            sbSQL.Append("       NVL(f.fac_nam, 'Unknown') AS Fac_Nam, NVL(f.fac_type_cod,'?') AS Fac_Type_Cod, f.fac_owner_nam, f.fac_class_cod ");
            sbSQL.Append("FROM stomp.facility f ");
            sbSQL.Append("WHERE f.fac_id = " + facID);

            try
            {
                dtResult = Utilities.GetResults(sbSQL, strOracleConn);      // Special Function - For reading GIS line segements file and import line into ADDS
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtResult;
        }

        internal static DataTable GetSwitchInfoFromStomp(string InvItemID)
        {
            DataTable dtResult = null;
            string strOracleConn = "Data Source=tnmp;User ID=STOMPDMC;Password=richard;Pooling=false;";
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT DISTINCT ii.invitm_id, l.ln_id, l.ln_oper_kv_num, ii.operpt_num, ii.equip_subclass_cod, esc.equip_subclass_des ");
            sbSQL.Append("FROM STOMP.Inv_Item ii, STOMP.equip_sub_class esc, STOMP.structure s, STOMP.LnSeg_Strc lsS, STOMP.Line_Segment ls, STOMP.Line l ");
            sbSQL.Append("WHERE  ii.invitm_id = " + InvItemID );
            sbSQL.Append("  AND ii.equip_subclass_cod = esc.equip_subclass_cod ");
            sbSQL.Append("  AND ii.strc_id = s.strc_id ");
            sbSQL.Append("  AND s.strc_id = lsS.strc_id ");
            sbSQL.Append("  AND lsS.lnseg_id = ls.lnseg_id ");
            sbSQL.Append("  AND ls.ln_id = l.ln_id ");

            try
            {
                dtResult = Utilities.GetResults(sbSQL, strOracleConn);      // Special Function - For reading GIS line segements file and import line into ADDS
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dtResult;
        }

        internal static DataSet GetSymbolInfoFromAddsDB(string Panel)
        {
            DataSet dsResults = null;
            string strOracleConn = Adds._strConn;
            string PanelName = Panel;  //'5703576' '6843560' "3903392" "5163704" "CARVILD" "4203380"

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT lp.panel_name, omd.device_id, ob.adds_blk_nam, ob.adds_layer_nam, ");
            sbSQL.Append("  ob.blkpntx, ob.blkpnty, ob.blkpntz, ob.blksclx, ob.blkscly, 1.0 as blksclz, ");
            sbSQL.Append("  ob.blkrot, ob.blkspace, ob.blkattflw ");
            sbSQL.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjBlk ob ");
            sbSQL.Append("WHERE UPPER(lp.panel_name) = :panelName ");  //'5703576' '6843560' 
            sbSQL.Append("  AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQL.Append("  AND omd.device_id = ob.device_id ");
            sbSQL.Append("ORDER BY lp.panel_name, omd.device_id ");

            StringBuilder sbSQLAttr = new StringBuilder();
            sbSQLAttr.Append("SELECT lp.panel_name, omd.device_id, ob.adds_blk_nam, ");
            sbSQLAttr.Append("  oa.atttag, oa.attvalue, oa.adds_layer_nam, oa.attnpntx, oa.attnpnty, oa.attnpntz, ");
            sbSQLAttr.Append("  oa.attjpntx, oa.attjpnty, oa.attjpntz, oa.attthick, oa.atthgt, oa.attrot, oa.adds_style, ");
            sbSQLAttr.Append("  oa.attflag, oa.atttxtflag, oa.atthorzflag, oa.attvertflag ");
            sbSQLAttr.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjBlk ob, AddsDB.ObjAtt oa ");
            sbSQLAttr.Append("WHERE UPPER(lp.panel_name) = :panelName ");
            sbSQLAttr.Append("  AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQLAttr.Append("  AND omd.device_id = ob.device_id ");
            sbSQLAttr.Append("  AND ob.device_id = oa.device_id ");
            sbSQLAttr.Append("ORDER BY lp.panel_name, omd.device_id, oa.atttag DESC ");

            StringBuilder sbSQLXData = new StringBuilder();
            sbSQLXData.Append("SELECT lp.panel_name, omd.device_id, ora.xdtname, ora.xdtvalue ");
            sbSQLXData.Append("FROM AddsDb.Lu_Panel lp, AddsDB.ObjMstDev omd, AddsDB.ObjBlk ob, AddsDB.ObjRgApp ora ");
            sbSQLXData.Append("WHERE UPPER(lp.panel_name) = :panelName ");
            sbSQLXData.Append("     AND lp.adds_panel_id = omd.adds_panel_id ");
            sbSQLXData.Append("     AND omd.device_id = ob.device_id ");
            sbSQLXData.Append("     AND ob.device_id = ora.device_id ");
            sbSQLXData.Append("ORDER BY ob.device_id, ora.xdtname, ora.xdtvalue ");

            try
            {
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();
                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();
                    oracleCommand.Parameters.Add("panelName", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = PanelName;

                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "Blocks");
                    da.Fill(ds);

                    oracleCommand.CommandText = sbSQLAttr.ToString();
                    OracleDb.OracleDataAdapter daVertex = new OracleDb.OracleDataAdapter(oracleCommand);
                    daVertex.TableMappings.Add("Table", "Attributes");
                    daVertex.Fill(ds);
                    ds.Relations.Add("Blocks2Attributes",
                                        ds.Tables["Blocks"].Columns["device_id"],
                                        ds.Tables["Attributes"].Columns["device_id"]);

                    oracleCommand.CommandText = sbSQLXData.ToString();
                    OracleDb.OracleDataAdapter daXdata = new OracleDb.OracleDataAdapter(oracleCommand);
                    daXdata.TableMappings.Add("Table", "XData");
                    daXdata.Fill(ds);
                    ds.Relations.Add("Blocks2Xdata",
                                        ds.Tables["Blocks"].Columns["device_id"],
                                        ds.Tables["XData"].Columns["device_id"]);

                    dsResults = ds;
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return dsResults;
        }
        
        internal static SymbolInformation GetSymbolInformation(string symbolName)
        {
            SymbolInformation symbolInfo = new SymbolInformation();

            try
            {
                string strOrcaleConn = Adds._strConn;

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT ls.ADDS_BLK_NAM, ls.ADDS_SYMBOL_DESC, ls.EMB_SYMBOL_NUM, ls.ADDS_SYMBOL_DESC, ");
                sbSQL.Append("  ls.ADDS_ATTSIZE, ls.EMB_STATE, ls.EMB_CLASS, ls.EMB_SUBCLASS, ");
                sbSQL.Append("  NVL(ls.ADDS_GAPTYPE, 'unknown') AS ADDS_GAPTYPE, ");
                sbSQL.Append("  NVL(ls.ADDS_FUNCT, 'unknown') AS ADDS_FUNCT, ls.ADDS_GAPSIZE,  ");
                sbSQL.Append("  NVL(ls.ADDS_LTYPE, 'unknown') AS ADDS_LTYPE, ls.ADDS_SYMSIZE,  ");
                sbSQL.Append("  NVL(ls.adds_class, 'unknown') AS adds_class ");
                sbSQL.Append("FROM AddsDB.LU_SYMBOLS ls ");
                sbSQL.Append("WHERE UPPER(ls.ADDS_BLK_NAM) = UPPER(:blkName) ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand();

                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    oracleCommand.Parameters.Add("blkName", OracleDb.OracleDbType.Varchar2, 8).Value = symbolName;

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader();
                    while (odReader.Read())
                    {
                        symbolInfo.AttributeSize = (double)odReader.GetOracleDecimal(odReader.GetOrdinal("ADDS_ATTSIZE")).Value;
                        symbolInfo.BlockName = odReader.GetString(odReader.GetOrdinal("ADDS_BLK_NAM"));
                        symbolInfo.Description = odReader.GetString(odReader.GetOrdinal("ADDS_SYMBOL_DESC"));
                        symbolInfo.Function = odReader.GetString(odReader.GetOrdinal("ADDS_FUNCT"));

                        symbolInfo.GapSize = (double)odReader.GetOracleDecimal(odReader.GetOrdinal("ADDS_GAPSIZE")).Value;
                        symbolInfo.GapType = odReader.GetString(odReader.GetOrdinal("ADDS_GAPTYPE"));
                        symbolInfo.LayerType = odReader.GetString(odReader.GetOrdinal("ADDS_LTYPE"));
                        symbolInfo.SymbolSize = (double)odReader.GetOracleDecimal(odReader.GetOrdinal("ADDS_SYMSIZE")).Value;

                        symbolInfo.Class = odReader.GetString(odReader.GetOrdinal("adds_class"));

                    }
                    odReader.Close();
                    oracleConn.Close();
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return symbolInfo;
        }
        
        internal static AcadDB.ObjectId GetTableRecordId(AcadDB.ObjectId blockTableID, string blockName)
        {
            AcadDB.ObjectId id = AcadDB.ObjectId.Null;
            using (AcadDB.Transaction tr = blockTableID.Database.TransactionManager.StartTransaction())
            {
                AcadDB.SymbolTable table = (AcadDB.SymbolTable)tr.GetObject(blockTableID, AcadDB.OpenMode.ForRead);

                // Checks to see if block name is in Symbol Table returns both earsed and non-earased blocks (the problem with the API overrides flags don't work)
                if (table.Has(blockName))
                {
                    id = table[blockName];
                    if (!id.IsErased) return id;

                    //  if first symbol table record is erased block then check all records for a non-erased case
                    foreach (AcadDB.ObjectId recId in table)
                    {
                        if (!recId.IsErased)
                        {
                            //  Check to make sure there is an instance of the symbol is in the drawing and return its SymbolTableRecord objectId
                            AcadDB.SymbolTableRecord rec = (AcadDB.SymbolTableRecord)tr.GetObject(recId, AcadDB.OpenMode.ForRead);
                            if (string.Compare(rec.Name, blockName, true) == 0) return recId;
                        }
                    }
                }
                else
                {
                    // [TODO] code to insert the symbol in the symbol table

                }
            }
            return id;
        }
        
        #endregion *** Internal Functions ***
        

        #region *** Private Functions ****
        
        private void CheckGCCSubBlock(ref PolylineInfo polylineInfo)
        {
            string strOrgLayerName = polylineInfo.LayerName;
            string strNewLayerName = null;
            string strEntityType = null;

            //  Check if there is a line code
            if (strOrgLayerName.Substring(5, 4) != "0000")
            {
                return;                                         // if there is a line code exit and do nothing
            }
            else
            {

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    //  Prompt User to select a Substation block to get layer name.
                    AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect either Powerline or Symbol to get information from: ");
                    peo.SetRejectMessage("\nYou need to select a polyline or symbol");
                    peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
                    peo.AddAllowedClass(typeof(AcadDB.Polyline2d), false);

                    AcadEd.PromptEntityResult per = ed.GetEntity(peo);
                    if (per.Status == AcadEd.PromptStatus.OK)
                    {
                        AcadDB.DBObject obj = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForRead);
                        strEntityType = obj.GetType().Name;
                        switch (strEntityType)
                        {
                            case "Polyline2d":
                                AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
                                strNewLayerName = p2d.Layer;
                                break;
                            case "BlockReference":
                                AcadDB.BlockReference br = obj as AcadDB.BlockReference;
                                strNewLayerName = br.Layer;
                                break;
                        }
                    }

                    //  Check to see if there is a Plant Location
                    if (strNewLayerName.Substring(0, 5) != "00000")
                    {
                        polylineInfo.LayerName = strNewLayerName;
                    }
                    else
                    {
                        //ed.WriteMessage("Layer Name does not contain a plant location, the layer may not be correct");
                        
                        frmLineDialog oLineDialog = new frmLineDialog("Block Insert - Substation Layer Edit", Constants.MODE_EDIT, polylineInfo.LayerName);
                        DialogResult drLineDialog;
                        drLineDialog = AcadAS.Application.ShowModalDialog(null, oLineDialog, true);

                        if (drLineDialog == DialogResult.OK)
                        {
                            polylineInfo.LayerName = oLineDialog.Layer;
                        }
                        oLineDialog.Dispose();

                    }
                }
            }
        }
        
        private void InsertBlock(string BlockName, PolylineInfo polylineInfo)
        {
            int stat = 0;
            ArrayList alResults;
            double dblScaleFactor = 0.00;
            double sf = 1000.0;
            string strDeBug = null;
            string strDiv = null;
            string strBlockLayer = null;
            string strAttLayer = null;

            AcadGeo.Point3d insertedpt;

            //  Get Current AutoCAD System variables
            object oAttWas  = AcadAS.Application.GetSystemVariable("ATTREQ");
            object oBlpWas  = AcadAS.Application.GetSystemVariable("BLIPMODE");
            object oCmdWas  = AcadAS.Application.GetSystemVariable("CMDDIA");
            object oColWas  = AcadAS.Application.GetSystemVariable("CECOLOR");
            object oEchWas  = AcadAS.Application.GetSystemVariable("CMDECHO");
            object oExWas   = AcadAS.Application.GetSystemVariable("EXPERT");
            object oFilWas  = AcadAS.Application.GetSystemVariable("FILEDIA");
            object oLtWas   = AcadAS.Application.GetSystemVariable("CELTYPE");
            object oOsWas   = AcadAS.Application.GetSystemVariable("OSMODE");

            try
            {
                //  Set AutoCAD System variables for current operation
                AcadAS.Application.SetSystemVariable("ATTREQ", 1);          //  Determines whether the INSERT command uses default attribute settings 1~Turns on prompts or dialog box for attribute values
                AcadAS.Application.SetSystemVariable("BLIPMODE", 0);        //  Controls whether marker blips are visible 0~Turns off marker blips
                AcadAS.Application.SetSystemVariable("CELTYPE", "BYLAYER"); //  Sets the linetype of new objects
                AcadAS.Application.SetSystemVariable("CMDDIA", 0);          //  Controls the display of the In-Place Text Editor for the QLEADER command 0 ~ Off
                AcadAS.Application.SetSystemVariable("CMDECHO", 0);         //  Controls whether AutoCAD echoes prompts and input during the AutoLISP command function. 0~Turns off echoing 
                AcadAS.Application.SetSystemVariable("EXPERT", 5);          //  Controls whether certain prompts are issued.
                AcadAS.Application.SetSystemVariable("FILEDIA", 0);         //  Suppresses display of the file dialog boxes. 0~Does not display dialog boxes.
                AcadAS.Application.SetSystemVariable("OSMODE", 512);        //  Sets running Object Snap modes using the following bitcodes. 512~Nearest, 1~ENDpoint, 2~MIDpoint


                SymbolInformation symbolInfo = null;
                symbolInfo = GetSymbolInformation(BlockName);

                // Determing Layer block and attributes should be inserted on
                strDiv = Utilities.GetDivision();
                if ((strDiv != "AL") && (strDiv != "GA"))   //  For APC Distribution
                {
                    switch (symbolInfo.Function)
                    {
                        case "EF":      //  Electrical Free Standing  - Seems like blocks only for CADET not ADDS kept due to being in AutoLISP code
                            strBlockLayer   = polylineInfo.LayerName;
                            strAttLayer     = strBlockLayer;
                            break;
                        case "FS":      //  Free Standing
                            switch (symbolInfo.LayerType)
                            {
                                case "CE":      // Customer Equipment
                                    strBlockLayer   = polylineInfo.LayerName.Substring(0, 4) + symbolInfo.LayerType + polylineInfo.LayerName.Substring(6);
                                    strAttLayer     = strBlockLayer;
                                    break;
                                case "LM":      // Landmark
                                    strBlockLayer   = "----LM----";
                                    strAttLayer     = strBlockLayer;
                                    break;
                                case "ULO--":   //  Underground Location
                                case "-LO--":   //  Work Location
                                case "-NO--":
                                    strBlockLayer   = polylineInfo.LayerName.Substring(0, 3) + symbolInfo.LayerType + polylineInfo.LayerName.Substring(8);
                                    strAttLayer     = polylineInfo.LayerName.Substring(0, 3) + symbolInfo.LayerType + polylineInfo.LayerName.Substring(8);
                                    break;
                            }
                            break;
                        case "IL":      // Inline Device
                            switch (symbolInfo.LayerType)
                            {
                                case "CK":
                                    strBlockLayer   = polylineInfo.LayerName;
                                    strAttLayer     = polylineInfo.LayerName.Substring(0, 4) + "CKD" + polylineInfo.LayerName.Substring(7);
                                    break;

                                case "SW":
                                    strBlockLayer   = polylineInfo.LayerName.Substring(0, 4) + "SW" + polylineInfo.LayerName.Substring(6);
                                    strAttLayer     = polylineInfo.LayerName.Substring(0, 4) + "SWD" + polylineInfo.LayerName.Substring(7);
                                    break;
                            }
                            break;
                        case "LF":      //   Landbase Freestanding - None in current AddsDB kept due to being in AutoLISP code
                            strBlockLayer = polylineInfo.LayerName;
                            strAttLayer = strBlockLayer;
                            break;
                        case "PM":      //   Primary Meter
                            strBlockLayer   = polylineInfo.LayerName.Substring(0, 4) + "PM" + polylineInfo.LayerName.Substring(6);
                            strAttLayer     = polylineInfo.LayerName.Substring(0, 4) + "PMD" + polylineInfo.LayerName.Substring(7);
                            break;
                    }
                }
                else    //  For Transmission
                {
                    strBlockLayer   = polylineInfo.LayerName;
                    strAttLayer     = polylineInfo.LayerName;
                }

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;


                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(db.BlockTableId, AcadDB.OpenMode.ForRead);
                    AcadDB.BlockTableRecord btrModelSpace = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, true, true);

                    //  Check to see if block class exists in drawing if not load it.
                    AcadDB.ObjectId tableID = AcadDB.ObjectId.Null;
                    if (!bt.Has(BlockName))
                    {
                        if (!string.IsNullOrEmpty(strDeBug))
                        {
                            ed.WriteMessage("\nblock " + BlockName + " not found in AutoCAD drawing loading from C drive.");
                        }
                        AcadDB.Database dbSymbol = new AcadDB.Database(false, true);
                        dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + BlockName + ".dwg", System.IO.FileShare.Read, false, null);
                        tableID = db.Insert(BlockName, dbSymbol, false);
                        dbSymbol.Dispose();
                    }
                    else
                    {
                        tableID = GetTableRecordId(bt.ObjectId, BlockName);
                    }
                    bt.Dispose();                                           //  Cleanup memory for AutoCAD wrapper

                    AcadDB.BlockTableRecord btrSymbol = (AcadDB.BlockTableRecord)tr.GetObject(tableID, AcadDB.OpenMode.ForRead);

                    AcadDB.BlockReference br = new AcadDB.BlockReference(new AcadGeo.Point3d(), btrSymbol.ObjectId);

                    //  Set Block scale factors
                    AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("sf", ref stat);
                    if (rbResults != null)
                    {
                        alResults = Adds.ProcessInputParameters(rbResults);
                        sf = (double)alResults[0];
                    }
                    dblScaleFactor = sf * symbolInfo.SymbolSize;
                    br.ScaleFactors = new AcadGeo.Scale3d(dblScaleFactor, dblScaleFactor, 1.0);

                    //  Set Block Layer
                    Utilities.CheckLayer(strBlockLayer);
                    br.Layer = strBlockLayer;

                    //  Setup rotation
                    switch (BlockName)
                    {
                        case "A828":
                        case "A829":
                            br.Rotation = 0;
                            break;

                        default:
                            br.Rotation = polylineInfo.SlopeInRads;
                            break;
                    }

                    //  Adds new Block to AutoCAD drawing database
                    btrModelSpace.AppendEntity(br);
                    btrModelSpace.Dispose();                                          //  Cleanup memory for AutoCAD wrapper

                    tr.AddNewlyCreatedDBObject(br, true);

                    Dictionary<AcadDB.ObjectId, AttInfo> attInfo = new Dictionary<Autodesk.AutoCAD.DatabaseServices.ObjectId, AttInfo>();
                    bool flagAlignment = false;
                    if (btrSymbol.HasAttributeDefinitions)
                    {
                        Utilities.CheckLayer(strAttLayer);

                        foreach (AcadDB.ObjectId id in btrSymbol)
                        {
                            AcadDB.DBObject obj = tr.GetObject(id, AcadDB.OpenMode.ForRead);
                            AcadDB.AttributeDefinition ad = obj as AcadDB.AttributeDefinition;

                            if (ad != null && !ad.Constant)
                            {
                                AcadDB.AttributeReference ar = new AcadDB.AttributeReference();
                                ar.SetAttributeFromBlock(ad, br.BlockTransform);
                                ar.Position = ad.Position.TransformBy(br.BlockTransform);

                                if (ad.VerticalMode == AcadDB.TextVerticalMode.TextBase
                                    && (ad.HorizontalMode == AcadDB.TextHorizontalMode.TextLeft
                                        || ad.HorizontalMode == AcadDB.TextHorizontalMode.TextAlign
                                        || ad.HorizontalMode == AcadDB.TextHorizontalMode.TextFit))
                                {
                                    flagAlignment = false;
                                }
                                else
                                {
                                    ar.AlignmentPoint = ad.AlignmentPoint.TransformBy(br.BlockTransform);
                                    flagAlignment = true;
                                }

                                ar.Layer = strAttLayer;

                                //  If transmission set attribute hieght from Lu_Symbol table.  If distribution use block default scaling 
                                //  and rotate attributes to match line slope
                                if ((strDiv == "AL") || (strDiv == "GA"))
                                {
                                    ar.Height = sf * symbolInfo.AttributeSize;
                                    ar.Rotation = 0;
                                }
                                else
                                {
                                    ar.Rotation = ad.Rotation + polylineInfo.SlopeInRads;
                                }

                                AcadEd.PromptStringOptions pso = new AcadEd.PromptStringOptions("\n" + ad.Prompt); //[TODO] Modify to tie into DB prompts
                                AcadEd.PromptResult prAtt = ed.GetString(pso);
                                if (prAtt.Status == AcadEd.PromptStatus.OK)
                                {
                                    ar.TextString = prAtt.StringResult.ToString();
                                }

                                AcadDB.ObjectId arID = br.AttributeCollection.AppendAttribute(ar);
                                tr.AddNewlyCreatedDBObject(ar, true);

                                attInfo.Add(
                                    arID,
                                    new AttInfo(ad.Position, ad.AlignmentPoint, flagAlignment, ad.Rotation));
                            }
                        }
                    }

                    //  Run Jig to place block in drawing
                    BlockJig2 blockJig = new BlockJig2(tr, br, attInfo);
                    if (blockJig.Run() != AcadEd.PromptStatus.OK)
                        return;

                    tr.Commit();


                    // Get symbol insertion point from blockJig
                    insertedpt = blockJig._pos;

                    //  If block is an inline device then break the ployline.
                    if (symbolInfo.Function == "IL")
                    {
                        

                        AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();

                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ObjectId, polylineInfo.DxfEntityName));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Point3d, insertedpt));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        int intResult = Adds.AcadPutSym("breakpt", resultBuffer);

                        //  Calls existing AutoLISP code to break the ployline that the block is being placed on.
                        StringBuilder sb = new StringBuilder(256);
                        sb.Append("(TstBreakIt breakpt)");
                        resultBuffer = null;
                        //  FYI, The ads_queueexpr() is an undocumented function which sends a command but through a queue avoiding document state problems.
                        Adds.ads_queueexpr(sb.ToString());

                        
                    }

                    // [TODO] Future to do Gap line vertics change (LISP code conversion) not really needed.
                    
                }
                doc.SendStringToExecute("BlkLastFirst ", true, false, true);

                ed.Command("_REGENALL");

                //InsertBlockGap(polylineInfo, symbolInfo, insertedpt);

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            finally
            {
                //  Reset System variable back to original settings
                AcadAS.Application.SetSystemVariable("ATTREQ", oAttWas);
                AcadAS.Application.SetSystemVariable("BLIPMODE", oBlpWas);
                AcadAS.Application.SetSystemVariable("CMDDIA", oCmdWas);
                AcadAS.Application.SetSystemVariable("CMDECHO", oEchWas);
                AcadAS.Application.SetSystemVariable("EXPERT", oExWas);
                AcadAS.Application.SetSystemVariable("FILEDIA", oFilWas);
                AcadAS.Application.SetSystemVariable("OSMODE", oOsWas);
            }
        }

        [Acad.CommandMethod ("InsertGap")]
        public static void InsertGap()
        {
            string strBlockName = string.Empty;
            double dblRotation = 0.0;
            double scaleFactor = 0.0;
            int stat = 0;
            SymbolInformation symbolInformation = null;
            AcadGeo.Point3d insertedpt;

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database dbDwg = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            //  Prompts user to select the block to be changed and gets a BlockReference to the instance of the block.
            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Symbol to replace: ");
            peo.SetRejectMessage("\nYou need to select a symbol");
            peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
            AcadEd.PromptEntityResult per = ed.GetEntity(peo);

            if (per.Status == AcadEd.PromptStatus.OK)
            { 
                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    //  Get existing Block name and reference for modification.
                    AcadDB.BlockReference br = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForWrite) as AcadDB.BlockReference;
                    AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(br.BlockTableRecord, AcadDB.OpenMode.ForRead);
                    strBlockName = btr.Name;

                    symbolInformation = GetSymbolInformation(strBlockName);

                    //  Get Lower right and upper left points
                    AcadGeo.Point3d pt3DMin = br.GeometricExtents.MinPoint;
                    AcadGeo.Point3d pt3DMax = br.GeometricExtents.MaxPoint;

                    //  Create a filter to select polylines in a drawing and use it to get the polylines.
                    AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                    {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE")
                    };
                    AcadEd.SelectionFilter selectionFilter = new AcadEd.SelectionFilter(tvFilterValues);
                    AcadEd.PromptSelectionResult promptSelectionResult = ed.SelectCrossingWindow(pt3DMin, pt3DMax, selectionFilter);
                    AcadEd.SelectionSet selectionSet = promptSelectionResult.Value;
                    if (selectionSet != null)
                    {
                        insertedpt = br.Position;
                        dblRotation = br.Rotation;  //  In Rads

                        //  Get Block scale factor from LISP
                        AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("sf", ref stat);
                        if (rbResults != null)
                        {
                            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                            scaleFactor = (double)alResults[0];
                        }

                        //  Calculate symbol/block lenght
                        double dblDistance = symbolInformation.SymbolSize * scaleFactor * .5;

                        //  Get Lower right and upper left points
                        AcadGeo.Point3d pt3First = new AcadGeo.Point3d(0, 0, 0);
                        AcadGeo.Point3d pt3Second = new AcadGeo.Point3d(0, 0, 0);
                        if (symbolInformation.GapType == "C")
                        {
                            pt3First = Utilities.PolarPoint(insertedpt, dblRotation + Math.PI, dblDistance);
                            pt3Second = Utilities.PolarPoint(insertedpt, dblRotation, dblDistance);

                        }

                        foreach (AcadDB.ObjectId objectId in selectionSet.GetObjectIds())
                       {
                                using (AcadDB.Transaction tr2 = doc.TransactionManager.StartTransaction())
                                {
                                    AcadDB.Entity entity = tr2.GetObject(objectId, AcadDB.OpenMode.ForWrite) as AcadDB.Entity;
                                    ed.Command("_BREAK", entity, pt3Second, "");    //  Send to AutoCAD Break command
                                    tr2.Commit();
                                }
                       }
                       

                    }

                }
            }


        }
        internal static void InsertBlockGap(PolylineInfo polylineInfo, SymbolInformation symbolInformation, AcadGeo.Point3d insertedpt)
        {
            int stat = 0;
            double scaleFactor = 1000.0; 

            //  Get Block scale factor from LISP
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("sf", ref stat);
            if (rbResults != null)
            {
                ArrayList alResults = Adds.ProcessInputParameters(rbResults);
                scaleFactor = (double)alResults[0];
            }

            //  Calculate symbol/block lenght
            double dblDistance = symbolInformation.SymbolSize * scaleFactor * .5;

            //  Get Lower right and upper left points
            AcadGeo.Point3d pt3First = new AcadGeo.Point3d(0, 0, 0); 
            AcadGeo.Point3d pt3Second = new AcadGeo.Point3d(0, 0, 0);
            if (symbolInformation.GapType == "C")
            {
                pt3First    = Utilities.PolarPoint(insertedpt, polylineInfo.SlopeInRads + Math.PI, dblDistance);
                pt3Second   = Utilities.PolarPoint(insertedpt, polylineInfo.SlopeInRads, dblDistance);

            }

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            //  Create a filter to select polylines in a drawing and use it to get the polylines.
            AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
            {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE")
            };
            AcadEd.SelectionFilter selectionFilter = new AcadEd.SelectionFilter(tvFilterValues);
            AcadEd.PromptSelectionResult promptSelectionResult = ed.SelectCrossingWindow(pt3First, pt3Second, selectionFilter);
            AcadEd.SelectionSet selectionSet = promptSelectionResult.Value;
            if(selectionSet != null)
            {
                foreach (AcadDB.ObjectId objectId in selectionSet.GetObjectIds())
                {
                    using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
                    {
                        AcadDB.Entity entity = tr.GetObject(objectId, AcadDB.OpenMode.ForWrite) as AcadDB.Entity;
                        //doc.SendStringToExecute("BREAK " + entity + " " + pt3First + " \n", true, false, true);
                        ed.Command("_BREAK", entity, pt3Second, "");    //  Send to AutoCAD Break command
                        tr.Commit();
                    }
                }
            }

        }

        #endregion *** Private Functions ****
    }
}
