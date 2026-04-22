using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Windows.Forms;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;
using OracleDb = Oracle.DataAccess.Client;


namespace Adds
{
    public partial class pCircuitList : UserControl
    {
        public string strInput = string.Empty;
        public pCircuitList()
        {
            InitializeComponent();
        }

        private void btnDoIt_Click(object sender, EventArgs e)
        {
            strInput = txtInput.Text;
            GetCircuitData();
        }

        private void btnGetCircuit_Click(object sender, EventArgs e)
        {
            AcadEd.Editor ed = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
            AcadDB.Transaction tr = AcadDB.HostApplicationServices.WorkingDatabase.TransactionManager.StartTransaction();

            try
            {
                using (AcadAS.DocumentLock doclock = AcadAS.Application.DocumentManager.MdiActiveDocument.LockDocument())
                {
                    AcadEd.PromptEntityOptions entityOpts = new AcadEd.PromptEntityOptions("\nSelect entity");
                    AcadEd.PromptEntityResult pEntityResult = ed.GetEntity(entityOpts);

                    if (pEntityResult != null)
                    {
                        AcadDB.DBObject dbo = tr.GetObject(pEntityResult.ObjectId, AcadDB.OpenMode.ForRead) as AcadDB.DBObject;
                        AcadDB.Polyline2d p2d = dbo as AcadDB.Polyline2d;
                        if (p2d != null)
                        {
                            txtInput.Text = p2d.Layer.ToString();
                        }

                        AcadDB.BlockReference br = tr.GetObject(pEntityResult.ObjectId, AcadDB.OpenMode.ForRead) as AcadDB.BlockReference;
                        if (br != null)
                        {
                            txtInput.Text = br.Layer.ToString();
                        }
                    }
                }
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("\nException in add entity method: {0}", ex.Message);
            }
            finally
            {
                tr.Commit();
                tr.Dispose();
            }
        }


        private void GetCircuitData()
        {
            if (strInput != string.Empty)
            {
                AcadEd.Editor ed = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
                AcadDB.Transaction tr = AcadDB.HostApplicationServices.WorkingDatabase.TransactionManager.StartTransaction();

                AcadDB.TypedValue[] tvFilterValues = new AcadDB.TypedValue[]
                {
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<or"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "POLYLINE,LWPOLYLINE"), 
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, strInput),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.ViewportVisibility, "0"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "<and"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Start, "INSERT"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.BlockName,"A###,A###S"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.LayerName, strInput.Replace("CK","??")),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "and>"),
                    new AcadDB.TypedValue((int)AcadDB.DxfCode.Operator, "or>")
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

                // Clear the pickfirst set...
                ed.SetImpliedSelection(new AcadDB.ObjectId[0]);

                // ...but highlight the objects
                if (objs.Count > 0)
                {
                    HighlightEntities(objs);
                }

                AcadEd.SelectionSet ss1 = pSelectResult.Value;
                //ss1 = pSelectResult.Value;


                if (ss1 != null)
                {
                    ed.WriteMessage("\nPOLYLINE, LWPOLYLINE + Primary Circuits: {0}", ss1.Count);
                    AcadDB.ObjectId[] objIdArray = ss1.GetObjectIds();
                    printOutSSData(objIdArray, ed, tr);
                }

                tr.Commit();
                tr.Dispose();
            }
            else
            {
                AcadAS.Application.ShowAlertDialog("You need to enter a layer name.  Re-execute the command.");
            }
        }

        private void printOutSSData(AcadDB.ObjectId[] objIdArray, AcadEd.Editor ed, AcadDB.Transaction tr)
        {
            foreach (AcadDB.ObjectId objId in objIdArray)
            {
                Object obj = tr.GetObject(objId, AcadDB.OpenMode.ForRead);
                ed.WriteMessage("\n\n" + obj.ToString());
                AcadDB.Entity ent = (AcadDB.Entity)obj;
                AcadDB.LayerTableRecord ly = (AcadDB.LayerTableRecord)tr.GetObject(ent.LayerId, AcadDB.OpenMode.ForRead);
                ed.WriteMessage("\nLayer Name:" + ly.Name);

                AcadDB.BlockReference brObj = obj as AcadDB.BlockReference;
                if (brObj != null)
                {
                    AcadDB.BlockTableRecord btr = tr.GetObject(brObj.BlockTableRecord, AcadDB.OpenMode.ForRead) as AcadDB.BlockTableRecord;



                    ed.WriteMessage("\n Block Name: {0} Location: {1}", btr.Name, brObj.Position.ToString());
                    AcadDB.AttributeCollection ac = brObj.AttributeCollection;
                    foreach (AcadDB.ObjectId id in ac)
                    {
                        AcadDB.AttributeReference ar = (AcadDB.AttributeReference)tr.GetObject(id, AcadDB.OpenMode.ForRead);
                        ed.WriteMessage("\n - Tag = {0} Vaule = {1}", ar.Tag, ar.TextString);
                    }
                }

                AcadDB.DBObject dbObj = obj as AcadDB.DBObject;
                AcadDB.ResultBuffer rb = dbObj.XData;
                if (rb != null)
                {
                    string strTemp = string.Empty; //,strDeviceId, strLineId, strPlantId, strEditYMDT;
                    foreach (AcadDB.TypedValue tv in rb)
                    {
                        strTemp = strTemp + tv.Value + ", ";
                    }
                    ed.WriteMessage("\n XData {0}", strTemp);
                }

                AcadDB.Polyline2d p2d = obj as AcadDB.Polyline2d;
                if (p2d != null)
                {
                    int index = 0;
                    bool first = true;
                    AcadGeo.Point3d ptLast = new AcadGeo.Point3d(0,0,0);  // Old was not initialized
                    decimal decTotal = 0, decSegment = 0;
                    foreach (AcadDB.ObjectId vId in p2d)
                    {
                        AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForRead);
                        if (first)
                        {
                            ptLast = v2d.Position;
                            first = false;
                        }
                        decSegment = decimal.Round((decimal)v2d.Position.GetVectorTo(ptLast).Length, 3);
                        decTotal += decSegment;
                        ed.WriteMessage("\n Vertex {0} - " + v2d.Position.ToString() + " length = {1} m Total = {2}", index++, decSegment.ToString(), decTotal.ToString());
                        ptLast = v2d.Position;
                    }
                }
            }
        }

        

        // Highlight the entities by opening them one by one
        public void HighlightEntities(AcadDB.ObjectIdCollection objIds)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();

            using (tr)
            {
                foreach (AcadDB.ObjectId objId in objIds)
                {
                    AcadDB.Entity ent = tr.GetObject(objId, AcadDB.OpenMode.ForRead) as AcadDB.Entity;
                    if (ent != null)
                        ent.Highlight();
                }
            }
        }

        private void listBox1_DragEnter(object sender, DragEventArgs e)
        {
            listBox1.Focus();
        }

        private void listBox1_DragOver(object sender, DragEventArgs e)
        {
            string[] frmts = e.Data.GetFormats();
            Object obj;
            
            for (int i = 0; i < frmts.Length; i++)
            {
                obj = e.Data.GetData(frmts[i]);
                if ("AutoCAD.r17" == frmts[i] || "AutoCAD.r18" == frmts[i] || "AutoCAD.r19" == frmts[i] || "AutoCAD.r22" == frmts[i])
                {
                    MemoryStream str = obj as MemoryStream;
                    byte[] bytes = new byte[4096];
                    int count = str.Read(bytes, 0, 4096);

                    string str1 = System.Text.Encoding.Unicode.GetString(bytes);    // Convert.ToBase64String(bytes)
                    e.Effect = DragDropEffects.Move;                                // The data from the drag source is moved to the drop target.
                 }
            }
        }

        private void listBox1_DragDrop(object sender, DragEventArgs e)
        {
            AcadEd.Editor ed = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
            AcadEd.PromptSelectionResult prs = ed.SelectPrevious();

            AcadEd.SelectionSet ss = prs.Value;
            if (ss.Count > 0)
            {
                AcadDB.ObjectId[] objId = ss.GetObjectIds();
                using (AcadDB.Transaction tr = AcadDB.HostApplicationServices.WorkingDatabase.TransactionManager.StartTransaction())
                {
                    AcadDB.Entity ent = tr.GetObject(objId[0], AcadDB.OpenMode.ForRead) as AcadDB.Entity;
                    this.listBox1.Items.Clear();
                    this.listBox1.Items.Add("Entity Name: " + ent.GetType().ToString());
                    this.listBox1.Items.Add("Entity ID: " + ent.Id.ToString());
                    this.listBox1.Items.Add("Entity Color: " + ent.Color.ToString());
                    this.listBox1.Items.Add("Entity LineType : " + ent.Linetype);
                    this.listBox1.Items.Add("Entity LineWeight: " + ent.LineWeight.ToString());

                    List<string> values = DecodeEntity(ref ent, tr);
                    foreach (string strItem in values)
                    {
                        this.listBox1.Items.Add(strItem);
                    }
                    tr.Commit();
                }
                
            }
        }
        private List<string> DecodeEntity(ref AcadDB.Entity ent, AcadDB.Transaction tr)
        {
            List<string> results = new List<string>();
            string strSubStationDesc = string.Empty;
            string strLineOrFeederBreaker = string.Empty;

            results.Add("");
            AcadDB.BlockReference brObj = tr.GetObject(ent.ObjectId, AcadDB.OpenMode.ForRead) as AcadDB.BlockReference;
            if (brObj != null)
            {
                AcadDB.BlockTableRecord btr = tr.GetObject(brObj.BlockTableRecord, AcadDB.OpenMode.ForRead) as AcadDB.BlockTableRecord;
                results.Add("Block Name: " + btr.Name.ToString() + " - " + GetBlockDescr(btr.Name.ToString()) );
                results.Add("Layer: " + ent.Layer);
                strSubStationDesc = GetSubStationDesc(ent.Layer);
                if (strSubStationDesc != string.Empty)
                {
                    results.Add("Substation    : " + strSubStationDesc);
                }
                strLineOrFeederBreaker = GetFeederBreaker(ent.Layer);
                if(strLineOrFeederBreaker != string.Empty)
                {
                    results.Add("Feeder/Breaker: " + strLineOrFeederBreaker);
                }
                results.Add("");
                results.Add("Location(X,Y,Z): " + brObj.Position.ToString());
                decimal dblRot = Convert.ToDecimal(brObj.Rotation * 180 / Math.PI);
                results.Add("Rotation: " + decimal.Round(dblRot, 4).ToString());
                results.Add("Scale(X,Y,Z): " + brObj.ScaleFactors.ToString());

                AcadDB.AttributeCollection ac = brObj.AttributeCollection;
                results.Add("Attributes");
                foreach (AcadDB.ObjectId id in ac)
                {
                    AcadDB.AttributeReference ar = (AcadDB.AttributeReference)tr.GetObject(id, AcadDB.OpenMode.ForRead);
                    results.Add(" - Tag: " + ar.Tag + " Value: " + ar.TextString);
                }
            }

            AcadDB.Polyline2d p2d = ent as AcadDB.Polyline2d;
            if (p2d != null)
            {
                results.Add("Layer: " + p2d.Layer);
                results.Add("Linetype: " + p2d.Linetype);
                strSubStationDesc = GetSubStationDesc(ent.Layer);
                if (strSubStationDesc != string.Empty)
                {
                    results.Add("Substation    : " + strSubStationDesc);
                }
                strLineOrFeederBreaker = GetFeederBreaker(ent.Layer);
                if(strLineOrFeederBreaker != string.Empty)
                {
                    results.Add("Feeder/Breaker: " + strLineOrFeederBreaker);
                }
                results.Add("");
                results.Add("Line Weight: " + p2d.LineWeight.ToString());
                results.Add("Line Thickness: " + p2d.Thickness.ToString());
                results.Add("Line default Start Width: " + p2d.DefaultStartWidth.ToString());
                results.Add("Line default End Width: " + p2d.DefaultEndWidth.ToString());
                results.Add("");
                int index = 0;
                bool first = true;
                AcadGeo.Point3d ptLast = new AcadGeo.Point3d(0,0,0);  // Old code not initialized
                decimal decTotal = 0, decSegment = 0;
                foreach (AcadDB.ObjectId vId in p2d)
                {
                    AcadDB.Vertex2d v2d = (AcadDB.Vertex2d)tr.GetObject(vId, AcadDB.OpenMode.ForRead);
                    if (first)
                    {
                        ptLast = v2d.Position;
                        first = false;
                    }
                    decSegment = decimal.Round((decimal)v2d.Position.GetVectorTo(ptLast).Length, 3);
                    decTotal += decSegment;
                    
                    results.Add("Vertex Number: " + index++.ToString());
                    results.Add(" - Layer: " + v2d.Layer);
                    results.Add(" - Position: " + v2d.Position.ToString());
                    results.Add(" - length: " + decSegment.ToString() + " Total length: " + decTotal.ToString());
                    ptLast = v2d.Position;
                }
            }

            AcadDB.DBText dbText = ent as AcadDB.DBText;
            if (dbText != null)
            {
                results.Add("Layer: " + dbText.Layer);
                results.Add("Location(X,Y,Z): " + dbText.Position.ToString());
                results.Add("Text Height: " + dbText.Height.ToString());
                results.Add("Text: " + dbText.TextString.ToString());

            }

            AcadDB.ResultBuffer rb = ent.XData;
            results.Add("XData");
            if (rb != null)
            {
                string strTemp = string.Empty; //,strDeviceId, strLineId, strPlantId, strEditYMDT;
                foreach (AcadDB.TypedValue tv in rb)
                {
                    results.Add(" - " + tv.Value.ToString());
                }
            }
            return results;
        }

        private string GetBlockDescr(string strBlockName)
        {
            string strResults = string.Empty;

            if (strBlockName != string.Empty && Adds._strConn != string.Empty)
            {
                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT ls.Adds_Symbol_Desc, ls.EMB_Symbol_Num ");
                sbSQL.Append("FROM AddsDB.Lu_Symbols ls ");
                sbSQL.Append("WHERE UPPER(ls.adds_blk_nam) = '" + strBlockName.ToUpper() + "' ");

                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    strResults = (string)oracleCommand.ExecuteScalar();
                    oracleConn.Close();
                }

            }

            return strResults;
        }

        private string GetSubStationDesc(string strLayerName)
        {
            string strResults = string.Empty;
            string strSubCode = string.Empty;


            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            string strDiv = alResults[0].ToString();

            if (strLayerName.Length > 1)
            {
                if ((strDiv == "GA") || (strDiv == "AL"))
                {
                    strSubCode = strLayerName.Substring(0, 5);
                }
                else
                {
                    strSubCode = strLayerName.Substring(0, 2);
                }
            }
            
            if (strSubCode != string.Empty && Adds._strConn != string.Empty)
            {
                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT ls.subdescription ");
                sbSQL.Append("FROM AddsDB.Lu_SubStations ls ");
                if ((strDiv == "GA") || (strDiv == "AL"))
                {
                    sbSQL.Append("WHERE LPAD(ls.substation, 5, '0') ='" + strSubCode.ToUpper() + "' ");
                }
                else
                {
                    sbSQL.Append("WHERE UPPER(ls.substation) = '" + strSubCode.ToUpper() + "' ");
                }

                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String 

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    strResults = (string)oracleCommand.ExecuteScalar();
                    oracleConn.Close();
                }
            }
            return strResults;
        }

        private string GetFeederBreaker(string strLayerName)
        {
            string strResults = string.Empty;
            string strFeederCode = string.Empty;

            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            string strDiv = alResults[0].ToString();

            if ((strDiv == "GA") || (strDiv == "AL"))
            {
                strFeederCode = strLayerName.Substring(5, 4);
            }
            else
            {
                strFeederCode = strLayerName.Substring(0, 3);
            }

            if (strFeederCode != string.Empty && Adds._strConn != string.Empty)
            {
                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT lf.feeder_breaker || ' - ' || feeder_description ");
                sbSQL.Append("FROM AddsDB.Lu_Feeders lf ");
                sbSQL.Append("WHERE UPPER(lf.feeder_name) = '" + strFeederCode.ToUpper() + "' ");

                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    strResults = (string)oracleCommand.ExecuteScalar();
                    oracleConn.Close();
                }
            }
            return strResults;
        }
    }
}
