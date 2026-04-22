#region References & Notes

using System;
using System.Collections;
using System.Text;
using System.Data;            
using System.Windows.Forms;
using System.Runtime.InteropServices;
using System.Collections.Generic;
using System.IO;
using System.Xml;

using Microsoft.Win32;

using OracleDb    = Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad      = Autodesk.AutoCAD.Runtime;
using AcadAS    = Autodesk.AutoCAD.ApplicationServices;
using AcadASA    = Autodesk.AutoCAD.ApplicationServices.Application;
using AcadDB    = Autodesk.AutoCAD.DatabaseServices;
using AcadEd    = Autodesk.AutoCAD.EditorInput;
using AcadGeo   = Autodesk.AutoCAD.Geometry;
using AcadWin   = Autodesk.AutoCAD.Windows;
using Autodesk.AutoCAD.Interop;
using Autodesk.AutoCAD.Interop.Common;

//15dec14 - karl - added a delay after the file copy before the "CompareFileDate" to fix
//                 roger's & annette's file save failures.
//22dec14 - karl - increased delay from 2 sec to 5 sec (issue occured to james)

#endregion

namespace Adds
{
     public partial class Adds : Acad.IExtensionApplication
     {
        public static AcadWin.PaletteSet ps = null;
         
        public void Initialize()
        {
            AcadEd.Editor ed = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
            ed.WriteMessage("\nInitializing - Adds.dll");
        }

        public void Terminate()
        {

        }

        [System.Security.SuppressUnmanagedCodeSecurity]                                                    //Allows managed code to call into unmanaged code without a stack walk
        [DllImport("acCore.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.Cdecl)]    //Indicates that the attributed method is exposed by an unmanaged dynamic-link library (DLL) as a static entry point.
        extern static private int acedGetSym(string args, out IntPtr result);

        [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("acCore.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        extern static private int acedPutSym([MarshalAs(UnmanagedType.LPWStr)] string args, IntPtr result);

        [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("acad.exe", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl,
            EntryPoint = "?acedEvaluateLisp@@YAHPEB_WAEAPEAUresbuf@@@Z")]   // ?acedEvaluateLisp@@YAHPB_WAAPAUresbuf@@@Z  2007
        extern static private int acedEvaluateLisp([MarshalAs(UnmanagedType.LPWStr)] StringBuilder lispLine, out IntPtr result);

        [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("accore.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.Cdecl)]
        extern static internal int ads_queueexpr(string strExpr);

        [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("acdb17.dll", CallingConvention = CallingConvention.Cdecl,
            EntryPoint = "?acdbGetAdsName@@YA?AW4ErrorStatus@Acad@@AAY01JVAcDbObjectId@@@Z")]
        public extern static int acdbGetAdsName(long[] objName, AcadDB.ObjectId objID);

        [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("acad.exe", CallingConvention = CallingConvention.Cdecl,
            EntryPoint = "acdbEntUpd")]
        public extern static int acdbEntUpd(long[] ent);
       
        static internal string _strConn = string.Empty;
        static internal string _strRoles = string.Empty;
        static internal string _strUserID = string.Empty;

        static internal DataTable _MasterDeviceIds = null;

        static internal string _WorkSpaceOld = string.Empty;

        #region *** Public Functions calls - Used in AutoCAD Lisp code ***

        [Acad.LispFunction("OpenSubtest")]
        public AcadDB.ResultBuffer ETTest(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResult = new AcadDB.ResultBuffer();

            frmSelectSub oSelectSub = new frmSelectSub();
            AcadAS.Application.ShowModalDialog(null, oSelectSub, false);

            if (!string.IsNullOrEmpty(oSelectSub.SubCode.ToString()))
            {
                //     (list WellDid dBName dSubDiv dSubNam dSubDwg dSubOrg dSscada dSubEMB dSub_ID)
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Double, -1));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, ""));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.CurrentDiv));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubDescription));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubDwg));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubOrg));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubScada));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubEMB));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oSelectSub.SubID));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }
            else
            {
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                rbResult.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }

            return rbResult;
        }


        [Acad.CommandMethod("DrawEMBHiddenLine")]
        public void DrawHiddenLine()
        {
        AcadEd.Editor ed       = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
        AcadDB.Database dwgDB  = AcadAS.Application.DocumentManager.MdiActiveDocument.Database;
        AcadDB.Transaction tr  = AcadDB.HostApplicationServices.WorkingDatabase.TransactionManager.StartTransaction();

        try
        {
            // Create a collection of points to store vertices
            AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();

            // Setup the selection options for all vertices
            AcadEd.PromptPointOptions ppOptions = new AcadEd.PromptPointOptions("\nSelect polyline vertex: ")
            {
                AllowNone = true
            };

            // Get the start point for the polyline
            AcadEd.PromptPointResult ppResult = ed.GetPoint(ppOptions);

            // Get points until there are no more
            while (ppResult.Status == AcadEd.PromptStatus.OK)
            {
                // Add the selected point to the list
                pts.Add(ppResult.Value);

                // 
                ppOptions.UseBasePoint = true;
                ppOptions.BasePoint = ppResult.Value;
                ppResult = ed.GetPoint(ppOptions);
                if (ppResult.Status == AcadEd.PromptStatus.OK)
                {
                    // for each point selected draw a temporary segment
                    ed.DrawVector(
                        pts[pts.Count - 1],     //  start point
                        ppResult.Value,         //  end point
                        7,                      //  line color
                        false);                 //  Draw highlighted
                }
            }
               
            if (ppResult.Status == AcadEd.PromptStatus.None)
            {
                AcadDB.BlockTableRecord btr = tr.GetObject(dwgDB.CurrentSpaceId, AcadDB.OpenMode.ForWrite, false) as AcadDB.BlockTableRecord;

                //  Checks to see if --AOCK-020 layer exists for transfer to EMB if not it will create the layer also load in hidden linetype if not in current drawing.
                AcadDB.LayerTable lt = tr.GetObject(dwgDB.LayerTableId, AcadDB.OpenMode.ForWrite) as AcadDB.LayerTable;
                if (!lt.Has("--AOCK-020"))
                {
                    AcadDB.LayerTableRecord ltr = new AcadDB.LayerTableRecord
                    {
                        Name = "--AOCK-020",
                        Color = Autodesk.AutoCAD.Colors.Color.FromColorIndex(Autodesk.AutoCAD.Colors.ColorMethod.ByAci, 7)
                    };

                    AcadDB.LinetypeTable ltt = tr.GetObject(dwgDB.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                    if (!ltt.Has("Hidden"))
                    {
                        dwgDB.LoadLineTypeFile("Hidden", "acad.lin");
                    }
                    ltr.LinetypeObjectId = ltt["Hidden"];
                    lt.Add(ltr);
                    tr.AddNewlyCreatedDBObject(ltr, true);
                }

                // Create Polyline
                AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null)
                {
                    LinetypeScale = 0.50,
                    Layer = "--AOCK-020"
                };
                SetStoredXData(pline,"LINE_WDT","1");

                //  Adds new polylines to AutoCAD drawing database
                btr.AppendEntity(pline);
                tr.AddNewlyCreatedDBObject(pline, true);

                //  Causes the polylines to be displayed in AutoCAD
                ed.Regen();
            }
        }
        catch (System.Exception ex)
        {
            MessageBox.Show(ex.ToString(), "System Exception");
        }
        finally
        {
            tr.Commit();
            tr.Dispose();
        }
        }

         [Acad.CommandMethod("DrawSeqLine")]
         public void DrawSeqSwLine()
         {
             AcadEd.Editor ed = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor;
             AcadDB.Transaction tr = AcadDB.HostApplicationServices.WorkingDatabase.TransactionManager.StartTransaction();
             AcadGeo.Point3d pt1, pt2, pt3, pos1, pos2, pos3;



             bool fPositionOrder = false;

             try
             {
                 // Dummy points
                 pt1 = new AcadGeo.Point3d(0, 0, 0);
                 pt2 = new AcadGeo.Point3d(0, 0, 0);
                 pt3 = new AcadGeo.Point3d(0, 0, 0);

                 //  Get Symbol insertion points
                 pos1 = GetBlockInsertionPt(ref ed, ref tr, "\nSelect first switch");
                 pos2 = GetBlockInsertionPt(ref ed, ref tr, "\nSelect second switch");
                 pos3 = GetBlockInsertionPt(ref ed, ref tr, "\nSelect third switch");

                 //  Figure out switch order
                 double delta = 0.250;
                 if (Math.Abs(pos1.X - pos2.X) <= delta)   // Same vertical plain
                 {
                     if (pos1.Y > pos2.Y)    //First Block is on top
                     {
                         pt1 = pos1;
                         pt2 = pos2;
                     }
                     else
                     {
                         pt1 = pos2;
                         pt2 = pos1;
                     }
                     pt3 = pos3;
                     fPositionOrder = true;
                 }
                 else if (Math.Abs(pos1.X - pos3.X) <= delta)
                 {
                     if (pos1.Y > pos3.Y)    //First Block is on top
                     {
                         pt1 = pos1;
                         pt2 = pos3;
                     }
                     else
                     {
                         pt1 = pos3;
                         pt2 = pos1;
                     }
                     pt3 = pos2;
                     fPositionOrder = true;
                 }
                 else if (Math.Abs(pos2.X - pos3.X) <= delta)
                 {
                     if (pos2.Y > pos3.Y)    //First Block is on top
                     {
                         pt1 = pos2;
                         pt2 = pos3;
                     }
                     else
                     {
                         pt1 = pos3;
                         pt2 = pos2;
                     }
                     pt3 = pos1;
                     fPositionOrder = true;
                 }


                 if (fPositionOrder)
                 {
                     //  Sets vertex points for new polylines
                     AcadGeo.Point3dCollection pts = new AcadGeo.Point3dCollection();
                     AcadGeo.Point3dCollection pts2 = new AcadGeo.Point3dCollection();
                     if (pt1.X < pt3.X)  // Draw first line to the right
                     {
                         AcadGeo.Point3d ptTemp = new AcadGeo.Point3d(pt1.X + 12.5, pt1.Y, 0.0);
                         pts.Add(ptTemp);
                         AcadGeo.Point3d ptTemp2 = new AcadGeo.Point3d(((pt3.X - pt1.X) / 2) + pt1.X, pt1.Y, 0.0);
                         pts.Add(ptTemp2);
                         AcadGeo.Point3d ptTemp3 = new AcadGeo.Point3d(((pt3.X - pt1.X) / 2) + pt2.X, pt2.Y, 0.0);
                         pts.Add(ptTemp3);
                         AcadGeo.Point3d ptTemp4 = new AcadGeo.Point3d(pt2.X + 12.5, pt2.Y, 0.0);
                         pts.Add(ptTemp4);

                         AcadGeo.Point3d ptTemp5 = new AcadGeo.Point3d(pt3.X - 12.5, pt3.Y, 0.0);
                         pts2.Add(ptTemp5);
                         AcadGeo.Point3d ptTemp6 = new AcadGeo.Point3d(pt3.X - ((pt3.X - pt1.X) / 2), pt3.Y, 0.0);
                         pts2.Add(ptTemp6);
                     }
                     else                //  Draws first line to the left
                     {
                         AcadGeo.Point3d ptTemp = new AcadGeo.Point3d(pt1.X - 12.5, pt1.Y, 0.0);
                         pts.Add(ptTemp);
                         AcadGeo.Point3d ptTemp2 = new AcadGeo.Point3d(pt1.X - ((pt1.X - pt3.X) / 2), pt1.Y, 0.0);
                         pts.Add(ptTemp2);
                         AcadGeo.Point3d ptTemp3 = new AcadGeo.Point3d(pt2.X - ((pt2.X - pt3.X) / 2), pt2.Y, 0.0);
                         pts.Add(ptTemp3);
                         AcadGeo.Point3d ptTemp4 = new AcadGeo.Point3d(pt2.X - 12.5, pt2.Y, 0.0);
                         pts.Add(ptTemp4);

                         AcadGeo.Point3d ptTemp5 = new AcadGeo.Point3d(pt3.X + 12.5, pt3.Y, 0.0);
                         pts2.Add(ptTemp5);
                         AcadGeo.Point3d ptTemp6 = new AcadGeo.Point3d(pt3.X + ((pt1.X - pt3.X) / 2), pt3.Y, 0.0);
                         pts2.Add(ptTemp6);
                     }

                     AcadDB.Database dwg = AcadAS.Application.DocumentManager.MdiActiveDocument.Database;
                     AcadDB.BlockTableRecord btr = tr.GetObject(dwg.CurrentSpaceId, AcadDB.OpenMode.ForWrite, false) as AcadDB.BlockTableRecord;

                     //  Checks to see if --AOCK-020 layer exists for transfer to EMB if not it will create the layer also load in hidden linetype if not in current drawing.
                     AcadDB.LayerTable lt = tr.GetObject(dwg.LayerTableId, AcadDB.OpenMode.ForWrite) as AcadDB.LayerTable;
                     if (!lt.Has("--AOCK-020"))
                     {
                        AcadDB.LayerTableRecord ltr = new AcadDB.LayerTableRecord
                        {
                            Name = "--AOCK-020",
                            Color = Autodesk.AutoCAD.Colors.Color.FromColorIndex(Autodesk.AutoCAD.Colors.ColorMethod.ByAci, 7)
                        };

                        AcadDB.LinetypeTable ltt = tr.GetObject(dwg.LinetypeTableId, AcadDB.OpenMode.ForRead) as AcadDB.LinetypeTable;
                         if (!ltt.Has("Hidden"))
                         {
                             dwg.LoadLineTypeFile("Hidden", "acad.lin");
                         }
                         ltr.LinetypeObjectId = ltt["Hidden"];
                         lt.Add(ltr);
                         tr.AddNewlyCreatedDBObject(ltr, true);
                     }

                     //  Create XData for setting line width in EMB 
                     AcadDB.ResultBuffer rb = new AcadDB.ResultBuffer(
                     new AcadDB.TypedValue(1001, "LINE_WDT"),
                     new AcadDB.TypedValue(1000, "1"));

                    //  Creates first polyline for sequence switch connecting the two breaker isolation switches.
                    AcadDB.Polyline2d pline = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts, 0.0, false, 0.0, 0.0, null)
                    {
                        LinetypeScale = 0.25,
                        Layer = "--AOCK-020",
                        XData = rb
                    };

                    //  Creates conecting polyline to ByPass swithch/
                    AcadDB.Polyline2d pline2 = new AcadDB.Polyline2d(AcadDB.Poly2dType.SimplePoly, pts2, 0.0, false, 0.0, 0.0, null)
                    {
                        LinetypeScale = 0.25,
                        Layer = "--AOCK-020",
                        XData = rb
                    };

                    //  Adds new polylines to AutoCAD drawing database
                    btr.AppendEntity(pline);
                     tr.AddNewlyCreatedDBObject(pline, true);
                     btr.AppendEntity(pline2);
                     tr.AddNewlyCreatedDBObject(pline2, true);

                     //  Causes the polylines to be displayed in AutoCAD
                     ed.Regen();
                 }
                 else
                 {
                     MessageBox.Show("At least two of the switches need to be in the same plane, within 250 mm of a common axes.");
                 }
             }
             catch (System.Exception ex)
             {
                 MessageBox.Show(ex.ToString(), "System Exception");
             }
             finally
             {
                 tr.Commit();
                 tr.Dispose();
             }
         }

         /// <summary>
        /// Called by Tables.lsp!Bld_T_Fdr_New
        /// </summary>
        /// <param name="args">Division, MyUsrInfo(Orcale Login information based on user)</param>
        /// <returns>AutoCAD List of List containing Feeder Name, Feeder Color, Breaker, Feeder Description</returns>
        [Acad.LispFunction("GetFeedersLUT")]
        public AcadDB.ResultBuffer GetFeederData(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = Adds.ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            
            try
            {
                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

                string strDivision = alInputParameters[0].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[1]);      //  Second parameter - Logon information list.

                StringBuilder sbSQL = new StringBuilder();

                // [TODO] Transmission code LPAD(lf.feeder_name, 5, '0') AS feeder_name
                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("SELECT LPAD(lf.feeder_name, 4, '0') AS feeder_name, lf.feeder_color, lf.feeder_breaker, lf.feeder_description ");
                }
                else
                {
                    sbSQL.Append("SELECT lf.feeder_name, lf.feeder_color, lf.feeder_breaker, lf.feeder_description ");
                }
                sbSQL.Append("FROM AddsDB.Lu_Feeders lf, AddsDB.Ext_Feeder ef ");
                switch (strDivision)
                {
                    case "BH":
                        sbSQL.Append("WHERE lf.div_birmingham = -1 AND lf.ret_div_bh  <> -1 ");
                        break;
                    case "E_":
                        sbSQL.Append("WHERE lf.div_eastern = -1 AND lf.ret_div_e  <> -1 ");
                        break;
                    case "M_":
                        sbSQL.Append("WHERE lf.div_mobile = -1 AND lf.ret_div_m  <> -1 ");
                        break;
                    case "S_":
                        sbSQL.Append("WHERE lf.div_southern = -1 AND lf.ret_div_s  <> -1 ");
                        break;
                    case "SE":
                        sbSQL.Append("WHERE lf.div_southeast = -1 AND lf.ret_div_se  <> -1 ");
                        break;
                    case "W_":
                        sbSQL.Append("WHERE lf.div_western = -1 AND lf.ret_div_W  <> -1 ");
                        break;
                    default:
                        sbSQL.Append("WHERE 1 = 1 ");
                        break;
                }
                sbSQL.Append("  AND lf.feeder_breaker <> '0' ");
                sbSQL.Append("  AND lf.feeder_name = ef.FdrCode(+) ");
                sbSQL.Append("ORDER BY UPPER(lf.feeder_description) ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    
                    oracleConn.Open();                      // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                    while (odReader.Read())
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetOracleString(0)));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetInt32(1)));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetOracleString(2)));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetOracleString(3)));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
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
         /// Called by Tables.lsp!Bld_T_Panel_New
         /// </summary>
         /// <param name="args">MyUsrInfo(Orcale Login information based on user)</param>
         /// <returns>AutoCAD List of List containing Panel Name and Adds Panel ID</returns>
        [Acad.LispFunction("GetPanelIDLUT")]
        public AcadDB.ResultBuffer GetPanelIdLut(AcadDB.ResultBuffer args)
        {
             ArrayList alInputParameters = ProcessInputParameters(args);
             AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
             OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

             try
             {
                 string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[0]);      //  Second parameter - Logon information list.

                 StringBuilder sbSQL = new StringBuilder();
                 sbSQL.Append("SELECT UPPER(lp.Panel_Name) as Panel_Name, lp.Adds_Panel_ID ");
                 sbSQL.Append("FROM AddsDB.Lu_Panel lp ");
                 sbSQL.Append("ORDER BY UPPER(lp.Panel_Name) ");

                 using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                 {
                     oracleConn.Open();                     // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                     oracleCommand.CommandType = CommandType.Text;
                     oracleCommand.CommandText = sbSQL.ToString();

                     OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                     if (odReader.HasRows)
                     {
                         while (odReader.Read())
                         {
                             resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                             resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(0)));    // Panel_Name
                             resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, odReader.GetValue(1)));    // Adds_Panel_ID
                             resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                         }
                     }
                     else
                     {
                         resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
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
        /// Called by Tables.lsp!Bld_Sub_Pos_New
        /// </summary>
        /// <param name="args">MyUsrInfo(Orcale Login information based on user)</param>
        /// <returns>AutoCAD List of List containing Substation, Drawing Name, Division Name, Description, Origization ID, Block Name, Easting and Northing</returns>
        [Acad.LispFunction("GetSubPosLUT")]
        public AcadDB.ResultBuffer GetSubPosLUT(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();

            //  Get Division for linetypes to be used.
            int stat = 0;
            AcadDB.ResultBuffer rbResults = Adds.AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = Adds.ProcessInputParameters(rbResults);
            string strDiv = alResults[0].ToString();


            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
            int retryCount = 0;

            try
            {
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[0]);      //  First parameter - Logon information list.

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT ls.substation ,NVL(ls.subdwgname, ' ') AS subdwgname, NVL(ls.subdivname, ' ') as subdivname, ");
                sbSQL.Append("ls.subdescription, NVL(ls.org_id, ' ') AS org_id, ob.adds_blk_nam, ");
                sbSQL.Append("ROUND(ob.blkpntx) AS Easting, ROUND(ob.blkpnty) AS Northing ");
                sbSQL.Append("FROM AddsDB.OBJBlk ob, AddsDB.Lu_SubStations ls, ");
                sbSQL.Append("(SELECT Min(ob1.device_id) ");
                if (strDiv != "AL")
                {
                    sbSQL.Append("KEEP (DENSE_RANK FIRST ORDER BY UPPER(SUBSTR(ob1.adds_layer_nam, 1,2))) AS DeviceID ");
                    sbSQL.Append("FROM AddsDB.OBJBlk ob1 ");
                    sbSQL.Append("WHERE (ob1.adds_blk_nam = 'A074' OR  ob1.adds_blk_nam = 'A075' ");
                    sbSQL.Append("OR  ob1.adds_blk_nam = 'A076' OR  ob1.adds_blk_nam = 'A150') ");
                    sbSQL.Append("AND ob1.adds_layer_nam NOT LIKE '--%' ");
                    sbSQL.Append("GROUP BY UPPER(SUBSTR(ob1.adds_layer_nam, 1,2)) ");
                }
                else
                {
                    sbSQL.Append("KEEP (DENSE_RANK FIRST ORDER BY UPPER(SUBSTR(ob1.adds_layer_nam, 1,5))) AS DeviceID ");
                    sbSQL.Append("FROM AddsDB.OBJBlk ob1 ");
                    sbSQL.Append("WHERE ob1.adds_blk_nam = 'A822' ");
                    sbSQL.Append("AND ob1.adds_layer_nam NOT LIKE '--%' ");
                    sbSQL.Append("GROUP BY UPPER(SUBSTR(ob1.adds_layer_nam, 1,5)) ");
                }
                sbSQL.Append(") DId ");
                sbSQL.Append("WHERE ob.device_id = DId.DeviceID ");
                if (strDiv != "AL")
                {
                    sbSQL.Append("AND UPPER(SUBSTR(ob.adds_layer_nam, 1,2)) = ls.substation AND ls.subdescription IS NOT NULL ");
                }
                else
                {
                    sbSQL.Append("AND UPPER(SUBSTR(ob.adds_layer_nam, 1,5)) = ls.substation AND ls.subdescription IS NOT NULL ");
                }
                sbSQL.Append("ORDER BY ls.substation ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    while (oracleConn.State != ConnectionState.Open)
                    {
                        try
                        {
                            oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String
                        }
                        catch (Exception ex1)
                        {
                            if (++retryCount >= 2) throw ex1;
                            Random rand = new Random();
                            System.Threading.Thread.Sleep(rand.Next(500));
                        }
                    }

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    if (odReader.HasRows)
                    {
                        while (odReader.Read())
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(0)));    // substation
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(1) ?? string.Empty ));    // subdwgname
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(2) ?? string.Empty ));    // subdivname
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(3) ?? string.Empty ));    // subdescription
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(4) ?? string.Empty ));    // org_id
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(5) ?? string.Empty ));    // adds_blk_nam
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, odReader.GetValue(6) ?? 0));    // Easting
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, odReader.GetValue(7) ?? 0));    // Northing
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                    }
                    else
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
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
        /// Called by Panel.lsp!GetFeed
        /// </summary>
        /// <param name="args">Division Code, MyUsrInfo(Orcale Login information based on user)</param>
        /// <returns>AutoCAD List of List containing Lower Left X, Lower Left Y, Upper Right X, and Feeder Code</returns>
        [Acad.LispFunction("GetFeederCor")]
        public AcadDB.ResultBuffer GetFeederCor(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            try
            {
                string strDivision = alInputParameters[0].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[1]);      //  Second parameter - Logon information list.

                StringBuilder sbSQL = new StringBuilder(); 

                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("SELECT xf.x_l, xf.y_l, xf.x_u, xf.y_u, xf.fdrcode ");
                }
                else
                {
                    sbSQL.Append("SELECT xf.x_l, xf.y_l, xf.x_u, xf.y_u, xf.fdrcode ");
                }
                sbSQL.Append("FROM AddsDB.Ext_Feeder xf, AddsDB.Lu_Feeders lf ");

                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("WHERE xf.fdrcode = LPAD(lf.feeder_name, 4, '0') ");
                }
                else
                {
                    sbSQL.Append("WHERE xf.fdrcode = lf.feeder_name ");
                }
                switch (strDivision)
                {
                    case "BH":
                        sbSQL.Append("AND lf.div_birmingham = -1 AND lf.ret_div_bh <> -1 ");
                        break;
                    case "E_":
                        sbSQL.Append("AND lf.div_eastern = -1 AND lf.ret_div_e  <> -1 ");
                        break;
                    case "M_":
                        sbSQL.Append("AND lf.div_mobile = -1 AND lf.ret_div_m  <> -1 ");
                        break;
                    case "S_":
                        sbSQL.Append("AND lf.div_southern = -1 AND lf.ret_div_s  <> -1 ");
                        break;
                    case "SE":
                        sbSQL.Append("AND lf.div_southeast = -1 AND lf.ret_div_se  <> -1 ");
                        break;
                    case "W_":
                        sbSQL.Append("AND lf.div_western = -1 AND lf.ret_div_W  <> -1 ");
                        break;
                    case "AL":  // AL Transmission
                        break;
                    case "GA":  // GA Transmission
                        break;
                }
                sbSQL.Append("ORDER BY xf.fdrcode ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String    ACAD COMMAND OpenFeed will call this 

                    OracleDb.OracleGlobalization ogInfo = oracleConn.GetSessionInfo();

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    if (odReader.HasRows)
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        while (odReader.Read())
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(0)));   // Lower Left X
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(1)));   // Lower Left Y
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(2)));   // Upper Right X
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(3)));   // Upper Right Y
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(4)));            // Feeder Code
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    else
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
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

        [Acad.LispFunction("GetTransSubCor")]
        public AcadDB.ResultBuffer GetSubstationCor(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            
            try
            {
                string strDivision = alInputParameters[0].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[1]);
                StringBuilder sbSQL = new StringBuilder();

                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("SELECT LPAD(ls.substation, 5, '0') AS  substation, ls.subdescription, xs.subcode, xs.x_l, xs.y_l, xs.x_u, xs.y_u ");
                    sbSQL.Append("FROM AddsDB.Lu_Substations ls, AddsDB.Ext_Sub xs ");
                    sbSQL.Append("WHERE LPAD(ls.substation, 5, '0') = xs.subcode ");
                    sbSQL.Append("ORDER BY ls.subdescription ");
                }
                
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    OracleDb.OracleCommand oracleCommand = new OracleDb.OracleCommand
                    {
                        Connection = oracleConn,
                        CommandType = CommandType.Text,
                        CommandText = sbSQL.ToString()
                    };

                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "dtSubCors");
                    da.Fill(ds);

                    int intRecordCount = ds.Tables["dtSubCors"].Rows.Count;

                    if (intRecordCount == 0)
                    {
                        AcadAS.Application.ShowAlertDialog("There are not any Substations with extents.");
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    else          // was 351 before memory cleanup in AddsPlot
                    {
                        foreach (DataRow oRow in ds.Tables["dtSubCors"].Rows)
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            foreach (DataColumn dc in ds.Tables["dtSubCors"].Columns)
                            {
                                if (dc.DataType == System.Type.GetType("System.String"))
                                {
                                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow[dc].ToString()));
                                }
                                if (dc.DataType == System.Type.GetType("System.Decimal")) 
                                {
                                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Double, oRow[dc].ToString()));
                                }
                            }

                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }                       
                    }

                }

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return resultBuffer;
        }

        /// <summary>
        /// Called by Panel.lsp!GetSw_New
        /// </summary>
        /// <param name="args">MyUsrInfo(Orcale Login information based on user), Division code, Switch Number</param>
        /// <returns>AutoCAD List of List containing Switch Code, Lower Left X, Lower Left Y, and Feeder code</returns>
        [Acad.LispFunction("GetSwitchCorBySwID")]
        public AcadDB.ResultBuffer GetSwitchCor(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            try
            {
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[0]);      //  First parameter - Logon information list.
                string strDivision = alInputParameters[1].ToString();
                string strSwitchId = alInputParameters[2].ToString();

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT DISTINCT ob.adds_blk_nam, ls.adds_symbol_desc, ob.operpt_num, ROUND(ob.blkpntx) AS X, ROUND(ob.blkpnty) AS Y, ");
                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("     SUBSTR(ob.adds_layer_nam, 0, 5) AS SubCode, ");      // [ADDS-3] Bug fix
                    sbSQL.Append("     SUBSTR(ob.adds_layer_nam, 6, 4) AS FeederCode, ls.Subdescription || '/' || lf.feeder_description As feeder_description, ");
                    switch (strDivision)
                    {
                        case "AL":  // AL Transmission
                            sbSQL.Append("     'APC Trans' as MgrOrg, ");
                            break;
                        case "GA":  // GA Transmission
                            sbSQL.Append("     'GPC Trans' as MgrOrg, ");
                            break;
                    }
                }
                else
                {
                    sbSQL.Append("     SUBSTR(ob.adds_layer_nam, 1, 2) AS SubCode,  ");
                    sbSQL.Append("     SUBSTR(ob.adds_layer_nam, 3, 1) AS FeederCode, lf.feeder_description,  ");
                    sbSQL.Append("     Decode(lf.mgr_org_id, 1, 'Birmingham', 2, 'Eastern', 3, 'Southern', 4, 'Western', 5, 'Mobile', 6, 'Southeast') As MgrOrg, ");
                }
                sbSQL.Append("     lf.feeder_breaker, ob.device_id, lf.mgr_org_id ");
                
                sbSQL.Append("FROM AddsDB.ObjBlk ob, AddsDB.Lu_Symbols ls, AddsDB.Lu_Feeders lf, AddsDB.Lu_Panel lp ");
                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("     ,  AddsDb.Lu_Substations ls ");
                }
                sbSQL.Append("WHERE UPPER(ob.operpt_num)= :switchId ");
                sbSQL.Append("     AND ob.adds_blk_nam = ls.adds_blk_nam ");
                sbSQL.Append("     AND ob.adds_panel_id = lp.adds_panel_id AND lp.geo_sw = -1 AND lp.retired_sw = 0 ");

                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("     AND SUBSTR(ob.adds_layer_nam, 6, 4) = LPAD(lf.feeder_name, 4, '0') ");
                    sbSQL.Append("     AND SUBSTR(ob.adds_layer_nam, 0, 5) = LPAD(ls.substation, 5, '0') "); // [ADDS-3] Bug fix
                }
                else
                {
                    sbSQL.Append("     AND SUBSTR(ob.adds_layer_nam, 1, 3) = lf.feeder_name AND lf.feeder_name <> '0' ");
                }

                switch (strDivision)
                {
                    case "BH":
                        sbSQL.Append("AND lf.div_birmingham = -1 AND lf.ret_div_bh  <> -1 ");
                        sbSQL.Append("AND (lp.div_birmingham = -1 OR lp.Shr_birmingham = -1) ");
                        break;
                    case "E_":
                        sbSQL.Append("AND lf.div_eastern = -1 AND lf.ret_div_e = 0 ");
                        sbSQL.Append("AND (lp.div_eastern = -1 OR lp.Shr_eastern = -1) ");
                        break;
                    case "M_":
                        sbSQL.Append("AND lf.div_mobile = -1 AND lf.ret_div_m  <> -1 ");
                        sbSQL.Append("AND (lp.div_mobile = -1 OR lp.Shr_mobile = -1) ");
                        break;
                    case "S_":
                        sbSQL.Append("AND lf.div_southern = -1 AND lf.ret_div_s  <> -1 ");
                        sbSQL.Append("AND (lp.div_southern = -1 OR lp.Shr_southern = -1) ");
                        break;
                    case "SE":
                        sbSQL.Append("AND lf.div_southeast = -1 AND lf.ret_div_se  <> -1 ");
                        sbSQL.Append("AND (lp.div_southeast = -1 OR lp.Shr_southeast = -1) ");
                        break;
                    case "W_":
                        sbSQL.Append("AND lf.div_western = -1 AND lf.ret_div_W  <> -1 ");
                        sbSQL.Append("AND (lp.div_western = -1 OR lp.Shr_Western = -1) ");
                        break;
                    case "AL":  // AL Transmission
                        break;
                    case "GA":  // GA Transmission
                        break;
                }
                sbSQL.Append("ORDER BY  ob.operpt_num ");
                
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;

                    // [TODO] Code to offer user a selection if OptNum has more than one record.
                    oracleCommand.CommandText = sbSQL.ToString();
                    oracleCommand.Parameters.Add("switchId", Oracle.DataAccess.Client.OracleDbType.Varchar2).Value = strSwitchId.Trim().ToUpper();

                    DataSet ds = new DataSet();
                    OracleDb.OracleDataAdapter da = new OracleDb.OracleDataAdapter(oracleCommand);
                    da.TableMappings.Add("Table", "Results");
                    da.Fill(ds);

                    if (ds.Tables[0].Rows.Count == 1)
                    {
                        DataRow oRow = ds.Tables[0].Rows[0];

                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow["operpt_num"].ToString()));        // Switch Code
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, Int32.Parse(oRow["X"].ToString())));   // Lower Left X       
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, Int32.Parse(oRow["Y"].ToString())));   // Lower Left Y
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, oRow["FeederCode"].ToString()));        // Switch Code
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                    }
                    else if (ds.Tables[0].Rows.Count > 1)
                    {
                        DataTable dtSwitch = ds.Tables[0];
                        dtSwitch.TableName = "SwitchCor";
                        frmResults oResultsDialog = new frmResults(dtSwitch);

                        //  Makes AutoCAD owns the form not Windows, notice icon on form
                        //  This signature of ShowModalDialog is need to override reg last location display position 
                        //  in this case the regedit location is at HKCU\Software\Autodesk\AutoCAD17.0\Acad-5002:409\Profiles\AddsPlot\Diaglogs\Adds.ChangesDialog Bounds key
                        //AcadAS.Application.ShowModalDialog(AcadAS.Application.MainWindow, oResultsDialog, false);
                        AcadAS.Application.ShowModalDialog(null, oResultsDialog, false);         
                        //ResultsDialog1.ShowDialog();

                        DataGridViewRow rowResults = oResultsDialog.SelectedRow;
                        if (rowResults != null)
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, rowResults.Cells[2].Value));            // Switch Code
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, Int32.Parse(rowResults.Cells[3].Value.ToString())));    // Lower Left X
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, Int32.Parse(rowResults.Cells[4].Value.ToString())));    // Lower Left Y
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, rowResults.Cells[5].Value));            // Feeder Code
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                        else
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                    }
                    else
                    {
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

        /// <summary>
        /// Called by Panel.lsp!GetSub
        /// </summary>
        /// <param name="args">MyUsrInfo(Orcale Login information based on user), Division code</param>
        /// <returns>AutoCAD List of List containing Switch Code, Lower Left X, Lower Left Y, and Substation code</returns>
        [Acad.LispFunction("GetSubCor")]
        public AcadDB.ResultBuffer GetSubCor(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
            ArrayList alInputParameters = ProcessInputParameters(args);

            try
            {
                string strDivision = alInputParameters[1].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[0]);      //  Second parameter - Logon information list.

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT DISTINCT xs.x_l, xs.y_l, xs.x_u, xs.y_u, xs.subcode ");
                sbSQL.Append("FROM AddsDB.Ext_Sub xs, AddsDB.Lu_SubStations ls, AddsDB.Lu_Feeders lf ");

                if (strDivision == "GA" || strDivision == "AL")
                {
                    sbSQL.Append("WHERE xs.subcode = LPAD(ls.substation, 5, '0') AND ls.retired_emb = 0 ");
                }
                else
                {
                    sbSQL.Append("WHERE xs.subcode = ls.substation AND ls.substation = lf.substation ");

                    switch (strDivision)
                    {
                        case "BH":
                            sbSQL.Append("AND lf.div_birmingham = -1 AND lf.ret_div_bh  <> -1 ");
                            break;
                        case "E_":
                            sbSQL.Append("AND lf.div_eastern = -1 AND lf.ret_div_e  <> -1 ");
                            break;
                        case "M_":
                            sbSQL.Append("AND lf.div_mobile = -1 AND lf.ret_div_m  <> -1 ");
                            break;
                        case "S_":
                            sbSQL.Append("AND lf.div_southern = -1 AND lf.ret_div_s  <> -1 ");
                            break;
                        case "SE":
                            sbSQL.Append("AND lf.div_southeast = -1 AND lf.ret_div_se  <> -1 ");
                            break;
                        case "W_":
                            sbSQL.Append("AND lf.div_western = -1 AND lf.ret_div_W  <> -1 ");
                            break;
                        case "AL":  // AL Transmission
                            break;
                        case "GA":  // GA Transmission
                            break;
                    }
                }
                sbSQL.Append("ORDER BY xs.subcode ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String - called by OpenSub

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    if (odReader.HasRows)
                    {
                        while (odReader.Read())
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(0)));   // Lower Left X
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(1)));   // Lower Left Y
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(2)));   // Upper Right X
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Int32, (Int32)odReader.GetDecimal(3)));   // Upper Right Y
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(4)));            // Substation Code
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                    }
                    else
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
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
        /// Called by Switch.lsp!Symentry
        /// </summary>
        /// <param name="args">Symbol Name, MyUsrInfo(Orcale Login information based on user)</param>
        /// <returns>Adds Block Name, EMB Symbol Number, Adds Description, Adds Class, Adds Symbol Size, Adds, Attribute Size, EMB State, EMB Sub-Class, 
        /// Adds Layer Type Code, Adds Function, Gap Type, Gap, Adds Attribute Code, List of Attribute prompts
        /// </returns>
        [Acad.LispFunction("SymEntryInfo")]
        public AcadDB.ResultBuffer GetSymbolEntryInfo(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();

            ArrayList alInputParameters = ProcessInputParameters(args);
            try
            {
                string strSymbol = alInputParameters[0].ToString();                                 //  First parameter - symbol name.
                string strOracleConn = BuildConnectionString((ArrayList)alInputParameters[1]);      //  Second parameter - Logon information list.

                OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOracleConn);
                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT DISTINCT ls.*, lsai.Sym_Attr_Code ");
                sbSQL.Append("FROM AddsDB.Lu_Symbols ls, AddsDB.Lu_Symbol_Attr_Info lsai ");
                sbSQL.Append("WHERE ls.Adds_Blk_Nam = '" + strSymbol + "' ");
                sbSQL.Append(" AND ls.adds_blk_nam = lsai.adds_blk_nam(+) ");

                oracleConn.Open();                  // [CHECKED] Oracle 12.c - Connection String

                oracleCommand.CommandType = CommandType.Text;
                oracleCommand.CommandText = sbSQL.ToString();
                oracleCommand.Connection = oracleConn;

                string strAttrCode = string.Empty;
                OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader();
                if (odReader.HasRows)
                {
                    while (odReader.Read())
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(0)));                // Adds_Blk_Nam
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(1).ToString()));      // Emb_Symbol_Num
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(2)));                // Adds_Symbol_Desc
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(3).ToString()));       // Adds_Class
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(4).ToString()));      // Adds_Symsize
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(5).ToString()));      // Adds_Attsize
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(6).ToString()));    // Emb_State
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(7).ToString()));    // Emb_Class
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(8).ToString()));    // Emb_Subclass
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(9).ToString()));    // Adds_Layer_Type
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(10).ToString()));    // Adds_Sym_Function
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(11).ToString()));    // Adds_Sym_GapType
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(12).ToString()));   // Adds_Sym_Gap
                        strAttrCode = odReader.GetValue(13).ToString();
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, strAttrCode));    // Adds_AttrCode
                    }
                }
                else
                {
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                }
                odReader.Close();

                //  Check to see if there are any prompts for block attributes.
                if (strAttrCode != string.Empty)
                {
                    StringBuilder sbSQL2 = new StringBuilder();
                    sbSQL2.AppendLine("SELECT * ");
                    sbSQL2.AppendLine("FROM AddsDB.Lu_Symbol_Attr lsa ");
                    sbSQL2.AppendLine("WHERE lsa.Sym_Attr_Code = '" + strAttrCode + "' ");
                    sbSQL2.AppendLine("ORDER BY lsa.Sym_Attr_Order");

                    oracleCommand.CommandText = sbSQL2.ToString();
                    odReader = oracleCommand.ExecuteReader();

                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                    while (odReader.Read())
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(3)));    // Attr_Prompt
                    }
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                }
                resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return resultBuffer;
        }

        /// <summary>
        /// Called by Tables.lsp!Bld_T_Sp1
        /// </summary>
        /// <param name="args">Division Code, MyUsrInfo(Orcale Login information based on user)</param>
        /// <returns>AutoCAD List of List containing Symbol Description, Block Name, Class, Symbol Size, and Attribute Size</returns>
        [Acad.LispFunction("GetSymbolInfo2")]
        public AcadDB.ResultBuffer GetSymbolInfo(AcadDB.ResultBuffer args)
        {
            ArrayList alInputParameters = ProcessInputParameters(args);

            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();

            try
            {
                string strDivision = alInputParameters[0].ToString();
                string strOrcaleConn = BuildConnectionString((ArrayList)alInputParameters[1]);      //  Second parameter - Logon information list.


                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT ls.Adds_Symbol_Desc, ls.Adds_Blk_Nam, ls.Adds_Class, ls.Adds_SymSize, ls.Adds_AttSize ");
                sbSQL.Append("FROM AddsDB.Lu_Symbols ls ");
                sbSQL.Append("WHERE  ls.Adds_SymSize IS NOT Null AND ls.Adds_AttSize IS NOT Null ");
                sbSQL.Append("ORDER BY ls.Adds_Blk_Nam ");

                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(strOrcaleConn))
                {
                    oracleConn.Open();                      // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    oracleCommand.CommandText = sbSQL.ToString();

                    OracleDb.OracleDataReader odReader = oracleCommand.ExecuteReader(CommandBehavior.CloseConnection);

                    if (odReader.HasRows)
                    {
                        while (odReader.Read())
                        {
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(0)));    // Adds_Symbol_Desc
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetString(1)));    // Adds_Blk_Nam
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(2).ToString()));   // Adds_Class
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(3).ToString()));   // Adds_SymSize
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, odReader.GetValue(4).ToString()));   // Adds_AttSize
                            resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                        }
                    }
                    else
                    {
                        resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
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

        

        [Acad.LispFunction("GetAllMasterDevicesNotInPanel")]
        public AcadDB.ResultBuffer GetAddsMasterDevicesNotInPanel(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer
            {
                new AcadDB.TypedValue((int)Acad.LispDataType.Nil)
            };

            ArrayList alInputParameters = ProcessInputParameters(args);
            string strOrcaleConn        = BuildConnectionString((ArrayList)alInputParameters[0]); 
            string strPanel             = alInputParameters[1].ToString().ToUpper();
                
            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT omd.device_id ");
            sbSQL.Append("FROM AddsDB.ObjMstDev omd, AddsDB.Lu_Panel lp ");
            sbSQL.Append("WHERE UPPER(lp.PANEL_NAME) <> '" + strPanel + "' ");
            sbSQL.Append("  AND lp.ADDS_PANEL_ID = omd.ADDS_PANEL_ID ");
            sbSQL.Append("ORDER BY omd.device_id ");
                
            try
            {
                _MasterDeviceIds = null;
                _MasterDeviceIds = Utilities.GetResults(sbSQL, strOrcaleConn);      // [CHECKED] Oracle 12.c - Connection String
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
            return rbResults;
        }
        
         [Acad.LispFunction("CheckMasterDevicesFor")]
        public AcadDB.ResultBuffer CheckMasterDevicesFor(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = ProcessInputParameters(args);
            string strDeviceID = alInputParameters[0].ToString().ToUpper();
            DataRow[] foundRows;

            try
            {
                foundRows = _MasterDeviceIds.Select("device_id = '" + strDeviceID + "' ");

                //resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                if (foundRows.Length > 0)
                {
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, "T"));
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                }
                else
                {
                    //resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Nil));
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                    resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                }
                //resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return resultBuffer;
        }

        [Acad.LispFunction("MyChkPanObj")]
        public int CheckPanelExist(AcadDB.ResultBuffer args)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
            ArrayList alInputParameters = ProcessInputParameters(args);
            string strPanelID = alInputParameters[0].ToString().ToUpper();
            int intResult = 0;
            DataTable dtResults = null;

            StringBuilder sbSQL = new StringBuilder();
            sbSQL.Append("SELECT CompLevel FROM AddsDb.LU_Panel WHERE Adds_Panel_ID = " + strPanelID);

            try
            {
                dtResults = Utilities.GetResults(sbSQL, _strConn);

                if(dtResults.Rows.Count > 0)
                {
                    DataRow oRow = dtResults.Rows[0];
                    intResult = Int32.Parse(oRow["CompLevel"].ToString());
                }
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return intResult;
        }


        [Acad.CommandMethod("InsertSOP")]
        public void InsertSOPSymbol()
        {
            InsertSymbol("A060");
        }

        [Acad.CommandMethod("InsertIER")]
        public void InsertIERSymbol()
        {
            InsertSymbol("A055");
        }

        [Acad.CommandMethod("InsertATS")]
        public void InsertATSSymbol()
        {
            InsertSymbol("_A200");
        }

        [Acad.LispFunction("MonitorWorkspaceChange")]
        public void MonitorWorkSpaceChanges(AcadDB.ResultBuffer args)
        {
            AcadASA.SystemVariableChanged += new AcadAS.SystemVariableChangedEventHandler(acApp_SystemVariableChanged);
        }

        internal void acApp_SystemVariableChanged(object sender, AcadAS.SystemVariableChangedEventArgs e)
        {
            string strCurrentWorkSpaceName = string.Empty;
            string strDivision = string.Empty;
            string strCleanUpKey = null;

            StringBuilder sb = new StringBuilder(256);
            AcadDB.ResultBuffer rbNil = new AcadDB.ResultBuffer();
            AcadDB.ResultBuffer rbResults = new AcadDB.ResultBuffer();

            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            if (e.Name == "WSCURRENT")
            {
                strCurrentWorkSpaceName = (string)AcadASA.GetSystemVariable(e.Name);
                
                // MessageBox.Show("New workspace is: " + strCurrentWorkSpaceName);

                rbNil.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Nil));

                if (strCurrentWorkSpaceName != _WorkSpaceOld)
                {
                    switch (strCurrentWorkSpaceName)
                    {
                        case "APC Transmission":
                            strDivision = "AL";
                            sb.Append("(UpdDivINI \"AL\")");
                            rbResults = rbNil;
                            break;
                        case "GPC Transmission":
                            strDivision = "GA";
                            sb.Append("(UpdDivINI \"GA\")");
                            rbResults = rbNil;
                            break;
                        case "APC Distribution":
                            strDivision = "BH";
                            sb.Append("(UpdDivINI \"BH\")");
                            rbResults = rbNil;
                            break;
                        case "(UA) APC Transmission":
                            strDivision = "AL";
                            sb.Append("(UpdDivINI \"AL\")");
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, "[Dev 19.0]"));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                            break;
                        case "(UA) GPC Transmission":
                            strDivision = "GA";
                            sb.Append("(UpdDivINI \"GA\")");
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, "[Dev 19.0]"));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                            break;
                        case "(UA) APC Distribution":
                            strDivision = "BH";
                            sb.Append("(UpdDivINI \"BH\")");
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, "[Dev 19.0]"));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
                            break;
                        case "AddsPlot":
                            rbResults = rbNil;
                            break;
                        case "UA - AddsPlot":
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, "[Dev 19.0]"));
                            rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));

                            break;

                    }

                    //  Updates DevMark varable in AutoLISP based on Production or User Acceptance Workspace
                    Adds.AcadPutSym("DevMark", rbResults);
                    UpdateRootPaths(strDivision);


                    //  Runs AutoLISP UpdDivIni function based on new Workspace
                    //  FYI, The ads_queueexpr() is an undocumented function which sends a command but through a queue avoiding document state problems.
                    Adds.ads_queueexpr(sb.ToString());

                    sb.Clear();
                    sb.Append("(INIT_INI)");
                    Adds.ads_queueexpr(sb.ToString());


                    if ((strCurrentWorkSpaceName == "AddsPlot") || (strCurrentWorkSpaceName == "UA - AddsPlot"))
                    {
                        //AcadDB.TypedValue typedValue;
                        //typedValue.Value((int) Acad.LispDataType.Nil);
                        //doc.SetLispSymbol("MyUsrInfo", typedValue);
                        doc.SetLispSymbol("ReqLoginFlag", "T");
                    }

                    //  Forces a new login becase change of Workspace
                    sb.Clear();
                    sb.Append("(FreshDwg)");
                    Adds.ads_queueexpr(sb.ToString());

                    _WorkSpaceOld = strCurrentWorkSpaceName;
                }
                
            }
        }

        internal void UpdateRootPaths(string strDivison)
        {
            string strPrmRootPath = string.Empty;
            string strPrimaryRoot = string.Empty;
            AcadDB.ResultBuffer rbResults;

            AcadAS.Document docAcad = AcadAS.Application.DocumentManager.MdiActiveDocument;

            //  Get current setting gor the new workspace from XML File
            Settings settings = new Settings();
            XmlDocument doc = new XmlDocument();
            doc.Load(@"C:\Div_Map\Common\AddsLookups.xml");
            string strNodePath = "AddsLookup/OPCOSettings/";
            if (strDivison != "AL" && strDivison != "GA")
            {
                strNodePath += "DTS/FilePaths/*";
            }
            else
            {
                strNodePath += strDivison + "/FilePaths/*";
            }
            XmlNodeList xNodes = doc.SelectNodes(strNodePath);
            foreach(XmlNode node in xNodes)
            {
                switch (node.Name)
                {
                    case "PrimaryRoot":
                        settings.PrimaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("PrmRootPath", rbResults);
                        break;
                    case "SecondaryRoot":
                        settings.SecondaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("SecRootPath", rbResults);
                        break;
                    case "AltPrimaryRoot":
                        settings.AltPrimaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("AltPrmRootDwg", rbResults);
                        break;
                    case "AltSecondaryRoot":
                        settings.AltSecondaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("AltSecRootDwg", rbResults);
                        break;
                    case "TestPrimaryRoot":
                        settings.TestPrimaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("TestPrmRootPath", rbResults);
                        break;
                    case "TestSecondaryRoot":
                        settings.TestSecondaryRoot = node.InnerText.ToString();
                        rbResults = new AcadDB.ResultBuffer();
                        rbResults.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Text, node.InnerText.ToString()));
                        Adds.AcadPutSym("TestSecRootPath", rbResults);
                        break;

                }
            }



        }

         /// <summary>
         /// Called by Panel.Lsp!WBlkPanDwg 
         /// </summary>
         /// <param name="args">File Name, Source Path, and Target Path</param>
         /// <returns></returns>
         [Acad.LispFunction("SavePanel")]
         public bool SavePanel(AcadDB.ResultBuffer args)
         {
             AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();
             bool blResult = false;

             ArrayList alInputParameters = ProcessInputParameters(args);

             string strFileName     = alInputParameters[0].ToString();
             string strSourcePath   = alInputParameters[1].ToString(); 
             string strTargetPath   = alInputParameters[2].ToString();

             try
             {
                 if (File.Exists(strSourcePath + strFileName))
                 {
                     File.Copy(strSourcePath + strFileName, strTargetPath + strFileName, true);
                     //System.Threading.Thread.Sleep(2000);//approx. two seconds - karl - 15dec14
                     System.Threading.Thread.Sleep(5000);//approx. five seconds - karl - 22dec14
                     bool flag = CompareFileDate(strSourcePath + strFileName, strTargetPath + strFileName);

                     resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListBegin));
                     if (flag)
                     {
                         blResult = true;
                         resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Double, 0.0));
                     }
                     else
                     {
                         AcadAS.Application.ShowAlertDialog("Did not copy: " + strFileName + " to " + strTargetPath);
                         resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.Double, -1.0));
                     }
                 }
                 else
                 {
                     AcadAS.Application.ShowAlertDialog("ADDS error - Source file: " + strSourcePath + strFileName +
                                                        " does not exist.\nADDS panel was not saved correctly.");
                 }
                
             }
             catch (System.IO.DirectoryNotFoundException ex)
             {
                 AcadAS.Application.ShowAlertDialog(ex.Message);
             }
             catch (System.UnauthorizedAccessException ex)
             {
                 AcadAS.Application.ShowAlertDialog(ex.Message);
             }
             catch (System.ArgumentException ex)
             {
                 AcadAS.Application.ShowAlertDialog(ex.Message);
             }
             finally
             {
                 resultBuffer.Add(new AcadDB.TypedValue((int)Acad.LispDataType.ListEnd));
             }
             
             return blResult;
         }

         /// <summary>
         /// Called by Panel.Lsp! LodPan (line 4696)                - karl - 23oct14
         /// </summary>
         /// 
         /// <param name="args"></param>
         /// 
         /// <returns></returns>
         [Acad.LispFunction("DeleteOldLocalFiles")]
         public void DeleteOldLocalFiles()
         {
             int DaysToExpire = 8;                 //includes Monday to Monday (i.e. 8 days)
             string strPath = "C:\\Adds\\Dwg\\";
             try
             {
                 if (Directory.Exists(strPath))
                 {
                     string[] FileCollection = Directory.GetFiles(strPath, "*.dwg");
                     if (FileCollection.Length < 1)//if empty then do nothing
                     {
                         foreach (string strPathAndDrawing in FileCollection)
                         {
                             DateTime FileDate = File.GetLastWriteTime(strPathAndDrawing);
                             int DaysCounted = (DateTime.Today - FileDate).Days;//do not use "().TotalDays" - karl
                             if (DaysCounted > DaysToExpire)//if less than 8 days then skip (i.e. keep file)
                             {
                                 FileInfo CurrFileInfo = new FileInfo(strPathAndDrawing);
                                 if (CurrFileInfo.IsReadOnly == true)//i know, i know, it just reads better this way - karl
                                 {
                                     File.SetAttributes(strPathAndDrawing, FileAttributes.Normal);
                                     File.Delete(strPathAndDrawing);
                                 }
                                 else
                                 {
                                     File.Delete(strPathAndDrawing);
                                 }

                                 //now check if delete was successful
                                 string[] TempFileCollection = Directory.GetFiles(strPath, "*.dwg");
                                 foreach (string TempFile in TempFileCollection)
                                 {
                                     if (TempFile == strPathAndDrawing)
                                     {
                                         AcadAS.Application.ShowAlertDialog("ADDS ERROR: " + strPath + strPathAndDrawing +
                                                                            " did not delete");
                                     }
                                 }
                             }
                         }
                     }
                 }
                 else
                 {
                     AcadAS.Application.ShowAlertDialog("ADDS ERROR - directory: " + strPath + " does not exist." +
                                                        "\nUnable to clean directory.");
                 }

             }
             //catch (System.IO.DirectoryNotFoundException ex)
             //{
             //    AcadAS.Application.ShowAlertDialog("ADDS error: " + ex.Message);
             //}
             catch (System.UnauthorizedAccessException ex)
             {
                 AcadAS.Application.ShowAlertDialog("ADDS error: " + ex.Message);
             }
             catch (System.ArgumentException ex)
             {
                 AcadAS.Application.ShowAlertDialog("ADDS error: " + ex.Message);
             }
             finally
             {

             }
         }//end of DeleteOldLocalFiles

         /// <summary>
         /// AutoCAD Command to show Palette for obtaining Adds, AddsPlot, and Cadet entity information.
         /// </summary>
         [Acad.CommandMethod("ShowPal")]
         static public void ShowPal()
         {
             if (ps == null)
             {
                //use constructor with Guid so that we can save/load user data
                //ps = new Autodesk.AutoCAD.Windows.PaletteSet("Adds Palette Set", new Guid("CEDBE906-5825-4e5a-B36E-D6D3DE1540EA"));
                ps = new Autodesk.AutoCAD.Windows.PaletteSet("Adds Palette Set")
                {
                    Style = AcadWin.PaletteSetStyles.NameEditable |
                    AcadWin.PaletteSetStyles.ShowPropertiesMenu |
                    AcadWin.PaletteSetStyles.ShowAutoHideButton |
                    AcadWin.PaletteSetStyles.ShowCloseButton,

                    MinimumSize = new System.Drawing.Size(150, 200)
                };
                ps.Add("Custom Form on Pallette", new pCircuitList());
             }
             bool b = ps.Visible;
             ps.Visible = true;
         }

    #endregion

    #region *** Internal Functions ***
         
         // Used to obtain current AutoLISP variable value(s)
         internal static AcadDB.ResultBuffer AcadGetSystemVariable(string varname, ref int stat)
         {
             IntPtr rb = IntPtr.Zero;
             stat = acedGetSym(varname, out rb);
             if (stat == (int)AcadEd.PromptStatus.OK && rb != IntPtr.Zero)
                 return (AcadDB.ResultBuffer)Acad.DisposableWrapper.Create(typeof(AcadDB.ResultBuffer), rb, true);
             return null;
         }

         internal static int AcadPutSym(string varname, AcadDB.ResultBuffer rb)
         {
             return acedPutSym(varname, rb.UnmanagedObject);
         }

         internal static void SetStoredXData(AcadDB.DBObject obj, string regAppName, string value)
         {
             AddRegAppTableRecord(regAppName);
             AcadDB.ResultBuffer rb = obj.XData;
             if (rb == null)
             {
                 rb = new AcadDB.ResultBuffer
                     (
                         new AcadDB.TypedValue(1001, regAppName),
                         new AcadDB.TypedValue(1000, value)
                     );
             }
             else
             {
                 rb.Add(new AcadDB.TypedValue(1001, regAppName));
                 rb.Add(new AcadDB.TypedValue(1000, value));
             }
             obj.XData = rb;
             rb.Dispose();
         }

         [Acad.CommandMethod("EtsTest")]
         public static void CreateDwgLink()
         {
             string strFilePath = null;

            OpenFileDialog ofdLink = new OpenFileDialog
            {
                Title = "Select File Location",
                InitialDirectory = @"S:\Workgroups\APC Power Delivery-ACC\Web\"
            };
            if (ofdLink.ShowDialog() == DialogResult.OK)
             {
                 strFilePath = ofdLink.FileName;
             }
         }


         internal static AcadDB.ResultBuffer AcadLispFunction(StringBuilder args)
         {
             IntPtr rb = IntPtr.Zero;
             acedEvaluateLisp(args, out rb);
             if (rb != IntPtr.Zero)
             {
                 try
                 {
                     AcadDB.ResultBuffer rbb = Acad.DisposableWrapper.Create(typeof(AcadDB.ResultBuffer), rb, true) as AcadDB.ResultBuffer;
                     return rbb;
                 }
                 catch
                 {
                     return null;
                 }
             }
             return null;
         }

         //  Pupose is to create an arraylist of input parameters that does not contain the extra codes that AutoCAD passes in the ResultBuffer.
         //      currently handles text & 16ints.  If a list is passed in it is an item in the array, and multiple list can be passed in.
         //      [TODO] expand for other datatypes
         internal static ArrayList ProcessInputParameters(AcadDB.ResultBuffer args)
         {
             AcadDB.TypedValue[] arArgs = args.AsArray();
             ArrayList alInputParameters = new ArrayList();
             ArrayList alItems = null;
             bool bListFlag = false;
             foreach (AcadDB.TypedValue tv in arArgs)
             {
                 if (tv.TypeCode == (int)Acad.LispDataType.ListBegin)
                 {
                     bListFlag = true;
                     alItems = new ArrayList();
                 }
                 if (tv.TypeCode == (int)Acad.LispDataType.ListEnd)
                 {
                     bListFlag = false;
                     alInputParameters.Add(alItems);
                 }
                //if ((tv.TypeCode == (int)Acad.LispDataType.Text || tv.TypeCode == (int)Acad.LispDataType.Int16) && bListFlag)
                //{
                //    alItems.Add(tv.Value);
                //}
                //if ((tv.TypeCode == (int)Acad.LispDataType.Text || tv.TypeCode == (int)Acad.LispDataType.Int16) && !bListFlag)
                //{
                //    alInputParameters.Add(tv.Value);
                //}
                if ((tv.TypeCode == (int)Acad.LispDataType.Text))
                {
                    if (!bListFlag)
                    {
                        alInputParameters.Add(tv.Value);
                    }
                    else
                    {
                        alItems.Add(tv.Value);
                    }
                }
                if ((tv.TypeCode == (int)Acad.LispDataType.Int16))
                {
                    if (!bListFlag)
                    {
                        alInputParameters.Add(tv.Value);
                    }
                    else
                    {
                        alItems.Add(tv.Value);
                    }
                }
                //if ((tv.TypeCode == (int)Acad.LispDataType.Double || tv.TypeCode == (int)Acad.LispDataType.Int16) && !bListFlag)
                // {
                //     alInputParameters.Add(tv.Value);
                // }
                // if ((tv.TypeCode == (int)Acad.LispDataType.Int32 || tv.TypeCode == (int)Acad.LispDataType.Int16) && !bListFlag)
                // {
                //     alInputParameters.Add(tv.Value);
                // }

                if ((tv.TypeCode == (int)Acad.LispDataType.Double))
                {
                    if (!bListFlag)
                    {
                        alInputParameters.Add(tv.Value);
                    }
                    else
                    {
                        alItems.Add(tv.Value);
                    }
                }
                if ((tv.TypeCode == (int)Acad.LispDataType.Int32))
                {
                    if (!bListFlag)
                    {
                        alInputParameters.Add(tv.Value);
                    }
                    else
                    {
                        alItems.Add(tv.Value);
                    }
                }
                if ((tv.TypeCode == (int)Acad.LispDataType.SelectionSet))
                 {
                    if (!bListFlag)
                    {
                        alInputParameters.Add(tv.Value);
                    }
                    else
                    {
                        alItems.Add(tv.Value);
                    }
                }
             }
             return alInputParameters;
         }

    #endregion *** Internal Functions ***


    #region *** Private Functions ***

        private bool CompareFileDate(string source, string target)//returns false if greater than 2 secs.
         {
             bool result = true;

             FileInfo fiSource = new FileInfo(source);
             FileInfo fiTarget = new FileInfo(target);

             DateTime dtSource = fiSource == null ? Convert.ToDateTime(null) : fiSource.LastWriteTime;
             DateTime dtTarget = fiTarget == null ? Convert.ToDateTime(null) : fiTarget.LastWriteTime;

             TimeSpan tsError = dtTarget - dtSource;
             TimeSpan tsErrorDuration = tsError.Duration();
             if ((tsErrorDuration.TotalSeconds > 2.0) || (dtTarget == DateTime.MinValue))
             {
                 //return false;
                 result = false;//29dec14 - karl
             }

             return result;
         }

        private AcadGeo.Point3d GetInsertionPoint(ref AcadEd.Editor ed, string strPrompt)
        {
            AcadEd.PromptPointOptions ppo = new AcadEd.PromptPointOptions(strPrompt);
            AcadEd.PromptPointResult ppr = ed.GetPoint(ppo);
            AcadGeo.Point3d pos = new AcadGeo.Point3d(0,0,0);  // Old code not initialized
            if (ppr.Status == AcadEd.PromptStatus.OK)
            {
                pos = ppr.Value;
            }

            return pos;
        }

         // Helper function to create RegApp equal to regapp command in AutoLISP
        private static void AddRegAppTableRecord(string regAppName)
        {
            //  Get handles to current AutoCAD drawing session.
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;

            AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
            using (tr)
            {
                AcadDB.RegAppTable rat = tr.GetObject(db.RegAppTableId, AcadDB.OpenMode.ForRead, false) as AcadDB.RegAppTable;
                if (!rat.Has(regAppName))
                {
                    rat.UpgradeOpen();
                    AcadDB.RegAppTableRecord ratr = new AcadDB.RegAppTableRecord
                    {
                        Name = regAppName
                    };
                    rat.Add(ratr);
                    tr.AddNewlyCreatedDBObject(ratr, true);
                }
                tr.Commit();
            }
            //db.Dispose();
            //doc.Dispose();
        }

        private AcadGeo.Point3d GetBlockInsertionPt(ref AcadEd.Editor ed, ref AcadDB.Transaction tr, string strPrompt)
        {
            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions(strPrompt);
            peo.SetRejectMessage("\nYou did not pick a block");
            peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);

            AcadEd.PromptEntityResult per = ed.GetEntity(peo);
            AcadGeo.Point3d pos = new AcadGeo.Point3d(0, 0, 0);  // Old code not initialized;
            if (per.Status == AcadEd.PromptStatus.OK)
            {
                AcadDB.BlockReference brObj = tr.GetObject(per.ObjectId, AcadDB.OpenMode.ForRead) as AcadDB.BlockReference;
                pos = brObj.Position;
            }

            return pos;
        }

        private void InsertSymbol(string strSymbolName)
        {
            AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer();

            try
            {
                //  Get Current AutoCAD System variables
                object oAttWas = AcadAS.Application.GetSystemVariable("ATTREQ");
                object oBlpWas = AcadAS.Application.GetSystemVariable("BLIPMODE");
                object oCmdWas = AcadAS.Application.GetSystemVariable("CMDDIA");    
                object oColWas = AcadAS.Application.GetSystemVariable("CECOLOR");
                object oEchWas = AcadAS.Application.GetSystemVariable("CMDECHO");   
                object oExWas = AcadAS.Application.GetSystemVariable("EXPERT");       
                object oFilWas = AcadAS.Application.GetSystemVariable("FILEDIA");   
                object oLtWas = AcadAS.Application.GetSystemVariable("CELTYPE");
                object oOsWas = AcadAS.Application.GetSystemVariable("OSMODE");


                //  Set AutoCAD System variables for current operation
                AcadAS.Application.SetSystemVariable("ATTREQ", 1);          //  Determines whether the INSERT command uses default attribute settings 1~Turns on prompts or dialog box for attribute values
                AcadAS.Application.SetSystemVariable("BLIPMODE", 0);        //  Controls whether marker blips are visible 0~Turns off marker blips
                AcadAS.Application.SetSystemVariable("CELTYPE", "BYLAYER"); //  Sets the linetype of new objects
                AcadAS.Application.SetSystemVariable("CMDDIA", 0);          //  Controls the display of the In-Place Text Editor for the QLEADER command 0 ~ Off
                AcadAS.Application.SetSystemVariable("CMDECHO", 0);         //  Controls whether AutoCAD echoes prompts and input during the AutoLISP command function. 0~Turns off echoing 
                AcadAS.Application.SetSystemVariable("EXPERT", 5);          //  Controls whether certain prompts are issued.
                AcadAS.Application.SetSystemVariable("FILEDIA", 0);         //  Suppresses display of the file dialog boxes. 0~Does not display dialog boxes.
                AcadAS.Application.SetSystemVariable("OSMODE", 3);          //  Sets running Object Snap modes using the following bitcodes. 1~ENDpoint, 2~MIDpoint

                //  Get handles to current AutoCAD drawing session.
                AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
                AcadDB.Database db = doc.Database;
                AcadEd.Editor ed = doc.Editor;

                //  Setup prompt and get sysmbol insertion point.
                string strPrompt = string.Empty;
                string strAttLocNum = string.Empty;
                string strAttrDesc = string.Empty;

                double dblScaleFactor = 0.00;
                double sf = 1.00;
                int stat = 0;
                AcadGeo.Point3d pos = new AcadGeo.Point3d(0, 0, 0);  // Old code not initialized;

                switch (strSymbolName)
                {
                    case "A060":
                        //  Setting up insertion point message for propmt
                        strPrompt = "\nSelect point for SOP Plate: ";
                        pos = GetInsertionPoint(ref ed, strPrompt);

                        //  Getting scale factor for the symbol
                        AcadDB.ResultBuffer rbResults = AcadGetSystemVariable("sf", ref stat);
                        ArrayList alResults = ProcessInputParameters(rbResults);
                        sf = (double)alResults[0];
                        dblScaleFactor = sf * 0.25;

                        //  Get Attribute(s) values
                        strAttLocNum = "SOP";

                        break;
                    case "A055":
                        strPrompt = "\nSelect point for IER Indicator: ";
                        pos = GetInsertionPoint(ref ed, strPrompt);
                        dblScaleFactor = 0.25 * 100;

                        AcadEd.PromptStringOptions pso = new AcadEd.PromptStringOptions("\nEnter the IER Value [1 2 3 4]: ");
                        AcadEd.PromptResult pr = ed.GetString(pso);
                        if (pr.Status == AcadEd.PromptStatus.OK)
                        {
                            strAttLocNum = pr.StringResult.ToString();
                        }
                        break;
                    case "_A200":
                        //  Setting up insertion point message for propmt
                        strPrompt = "\nSelect point for DA-ATS block: ";
                        pos = GetInsertionPoint(ref ed, strPrompt);
                        //  Getting scale factor for the symbol
                        AcadDB.ResultBuffer rbResults2 = AcadGetSystemVariable("sf", ref stat);
                        ArrayList alResults2 = ProcessInputParameters(rbResults2);
                        sf = (double)alResults2[0];
                        dblScaleFactor = sf * 0.25;
                        break;
                }

                AcadDB.Transaction tr = doc.TransactionManager.StartTransaction();
                using (tr)
                {
                    AcadDB.BlockTable bt = tr.GetObject(db.BlockTableId, AcadDB.OpenMode.ForRead) as AcadDB.BlockTable;
                    AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)
                        tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite);

                    if (!bt.Has(strSymbolName))
                    {
                        ed.WriteMessage("\n" + strSymbolName + " Block not found.");
                        AcadDB.Database dbSymbol = new AcadDB.Database(false, false);
                        dbSymbol.ReadDwgFile(@"C:\Div_Map\Adds\Sym\" + strSymbolName + ".dwg", System.IO.FileShare.Read, false, "");
                        db.Insert(strSymbolName, dbSymbol, true);
                    }

                    // Create Block reference
                    AcadDB.BlockReference br = new AcadDB.BlockReference(pos, bt[strSymbolName]);

                    //  Get and setup block scale.


                    AcadDB.ResultBuffer rbResults = AcadGetSystemVariable("sf", ref stat);
                    ArrayList alResults = ProcessInputParameters(rbResults);
                    //sf = (double) alResults[0]; 
                    br.ScaleFactors = new AcadGeo.Scale3d(dblScaleFactor, dblScaleFactor, 1.00);

                    //  Set Block Layer
                    if (strSymbolName == "_A200")
                    {
                        br.Layer = "----LM----";
                    }
                    else
                    {
                        br.Layer = "0";
                    }

                    // Add the reference to ModelSpace 
                    AcadDB.ObjectId blkObj = btr.AppendEntity(br);


                    // Add the attribute reference to the block reference
                    tr.AddNewlyCreatedDBObject(br, true);
                    AcadDB.ObjectId retId = br.OwnerId;

                    // Get the Attributes
                    AcadDB.AttributeCollection attrCol = br.AttributeCollection;
                    AcadDB.BlockTableRecord btrAttRec = (AcadDB.BlockTableRecord)tr.GetObject(bt[strSymbolName], AcadDB.OpenMode.ForRead);
                    AcadDB.BlockTableRecordEnumerator btrEnum = btrAttRec.GetEnumerator();
                    AcadDB.Entity ent = null;
                    while (btrEnum.MoveNext())
                    {
                        ent = (AcadDB.Entity)btrEnum.Current.GetObject(AcadDB.OpenMode.ForWrite);

                        //  [NEW TO ME] - expr (ent) is an expression that evaluates to an instance of some type, type is the name of the type 
                        //  to which the result of expr is to be converted (AcadDB.AttributeDefinition), and varname (attdef) is the 
                        //   object to which the result of expr is converted if the is test is true
                        if (ent is AcadDB.AttributeDefinition attdef)
                        {
                            AcadDB.AttributeReference attref = new AcadDB.AttributeReference(); // null;
                            attref.SetAttributeFromBlock(attdef, br.BlockTransform);   // [TODO] This line of code may what is causing attribut text to appaer the color of the layer that it is placed on.
                            switch (attdef.Tag)
                            {
                                case "LOC_NUM":
                                    //attdef.TextString = strAttLocNum;
                                    attref.TextString = strAttLocNum;
                                    break;
                            }
                            //attref.TextString = attdef.TextString;   // [TODO] change attref.TextString for user input to prompt here.
                            attrCol.AppendAttribute(attref);
                            tr.AddNewlyCreatedDBObject(attref, true);
                        }
                    }

                    //  Added 
                    ent = tr.GetObject(blkObj, AcadDB.OpenMode.ForRead) as AcadDB.Entity;

                    string strDeviceID = GetDeviceID(ent);
                    SetStoredXData(ent, "ID", strDeviceID);

                    if (strSymbolName == "A060")
                    {
                        AcadEd.PromptStringOptions pso = new AcadEd.PromptStringOptions("\nEnter the SOP Link: ");
                        AcadEd.PromptResult pr = ed.GetString(pso);
                        if (pr.Status == AcadEd.PromptStatus.OK)
                        {
                            SetStoredXData(ent, "PE_URL", pr.StringResult.ToString());
                        }
                        else
                        {
                            SetStoredXData(ent, "PE_URL", string.Empty);
                        }
                    }

                    string strDate = GetStorDate();
                    SetStoredXData(ent, "EDIT_DTM", strDate);

                    tr.Commit();
                    tr.Dispose();
                }


                //  Restore AutoCAD System variables as before this operation.
                AcadAS.Application.SetSystemVariable("ATTREQ", oAttWas);
                AcadAS.Application.SetSystemVariable("BLIPMODE", oBlpWas);
                AcadAS.Application.SetSystemVariable("CMDDIA", oCmdWas);
                AcadAS.Application.SetSystemVariable("CECOLOR", oColWas);
                AcadAS.Application.SetSystemVariable("CMDECHO", oEchWas);
                AcadAS.Application.SetSystemVariable("EXPERT", oExWas);
                AcadAS.Application.SetSystemVariable("FILEDIA", oFilWas);
                AcadAS.Application.SetSystemVariable("OSMODE", oOsWas);

            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }
        }

        private string GetDeviceID(AcadDB.DBObject obj)
        {
            string strDeviceID = string.Empty;
            string strObjP = string.Empty;
 
            switch (obj.GetType().FullName)
            {
                case "Autodesk.AutoCAD.DatabaseServices.BlockReference":
                    strObjP = "DS_";
                    break;
                case "Autodesk.AutoCAD.DatabaseServices.Polyline2d":
                    strObjP = "DP_";
                    break;
                case "Autodesk.AutoCAD.DatabaseServices.DBText":
                    strObjP = "DT_";
                    break;
            }

            int stat = 0;
            AcadDB.ResultBuffer rbResults = AcadGetSystemVariable("Div", ref stat);
            ArrayList alResults = ProcessInputParameters(rbResults);
            string strId_Pre = alResults[0].ToString();
            switch (strId_Pre)
            {
                case "BH":
                    strId_Pre = "BHM";
                    break;
                case "E_":
                    strId_Pre = "EAS";
                    break;
                case "M_":
                    strId_Pre = "MOB";
                    break;
                case "S_":
                    strId_Pre = "SOU";
                    break;
                case "SE":
                    strId_Pre = "SOE";
                    break;
                case "W_":
                    strId_Pre = "WES";
                    break;
            }
            string strResults = string.Empty;
            if (Adds._strConn != string.Empty)
            {
                StringBuilder sbSQL = new StringBuilder();
                sbSQL.Append("SELECT  AddsDB.Next_Device_ID.NEXTVAL ");
                sbSQL.Append("FROM Dual ");

                OracleDb.OracleCommand oracleCommand = new Oracle.DataAccess.Client.OracleCommand();
                using (OracleDb.OracleConnection oracleConn = new OracleDb.OracleConnection(Adds._strConn))
                {
                    oracleConn.Open();              // [CHECKED] Oracle 12.c - Connection String

                    oracleCommand.Connection = oracleConn;
                    oracleCommand.CommandType = CommandType.Text;
                    //oracleCommand.CommandText = Adds._strRoles;
                    

                    //oracleCommand.ExecuteNonQuery();

                    oracleCommand.CommandText = sbSQL.ToString();
                    strResults = oracleCommand.ExecuteScalar().ToString();

                    oracleConn.Close();
                }
            }

            strDeviceID = strObjP + strId_Pre + "_" + strResults;

            return strDeviceID;
        }

        internal static string GetStorDate()
        {
            string strResult = string.Empty;

            try
            {
                //  Get Current AutoCAD System variables
                //object oDate = AcadAS.Application.GetSystemVariable("DATE");
                //DateTimeFormatInfo myDTFI = new CultureInfo("en-US", false).DateTimeFormat;
                //CultureInfo ci = ;

                DateTime dtNow = DateTime.Now;
                string strYear = dtNow.ToString("yyyy");
                string strMonth = dtNow.ToString("MM");
                string strDay = dtNow.ToString("dd");
                string strHours = dtNow.ToString("hh");
                string strMinutes = dtNow.ToString("mm");
                string strSeconds = dtNow.ToString("ss");
                string strMilSecs = dtNow.ToString("fff");

                strResult = strYear + strMonth + strDay + strHours + strMinutes + strSeconds + strMilSecs;
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.ToString(), "System Exception");
            }

            return strResult;
        }

        private string BuildConnectionString(AcadDB.ResultBuffer args)
        {
            AcadDB.TypedValue[] arArgs = args.AsArray();

            string strDbInstance    = ((string)((AcadDB.TypedValue)arArgs.GetValue(0)).Value);
            string strUserID        = ((string)((AcadDB.TypedValue)arArgs.GetValue(1)).Value);
            string strPassWord      = ((string)((AcadDB.TypedValue)arArgs.GetValue(2)).Value);
            string strRoles         = ((string)((AcadDB.TypedValue)arArgs.GetValue(3)).Value);

            string strConn = "Data Source=" + strDbInstance + ";User ID=" + strUserID +
                ";Password=" + strPassWord + ";Pooling=false;";

            _strRoles = strRoles;
            _strConn = strConn;
            return strConn;
        }

        private string BuildConnectionString(ArrayList args)
        {
            string strWillDid       = args[0].ToString();
            string strDbInstance    = args[1].ToString();
            string strUserID        = args[2].ToString();
            string strPassWord      = args[3].ToString();
            string strServiceLevel  = args[4].ToString();
            string strRoles         = args[5].ToString();
            string strAppID         = args[6].ToString();
            string strAppPwd        = args[7].ToString();

            // For testing purposes
            string encrypted = Utilities.Encrypt("ADDSLODR");
            string encrypted1 = Utilities.Encrypt("Addslodr21pr");
            string encrypted2 = Utilities.Encrypt("Addslodr22pr");
            string encrypted3 = Utilities.Encrypt("Addslodr21ua");
            string encrypted4 = Utilities.Encrypt("Addslodr22ua");
            string encrypted5 = Utilities.Encrypt("Addslodr21dv");
            string encrypted6 = Utilities.Encrypt("Addslodr22dv");

            string dencrypted = Utilities.Decrypt(encrypted3);

            string strConn = "Data Source=" + strDbInstance + ";User ID="+ strAppID +  //    [Oracle 12.C]
                ";Password=" + strAppPwd +  ";Pooling=false;";

            _strRoles = strRoles;
            _strConn = strConn;
            _strUserID = strUserID;
            return strConn;
        }
        

    #endregion
    
     }
     
     public class GripVectorOverrule : AcadDB.GripOverrule
     {
         static public GripVectorOverrule theOverrule = new GripVectorOverrule();
         static bool overruling = false;
         static Dictionary<string, AcadGeo.Point3dCollection> _gripDict = new Dictionary<string, AcadGeo.Point3dCollection>();

         public GripVectorOverrule()
         {

         }

         private string GetKey(AcadDB.Entity e)
         {
             //Generates a key based on the name of the object's type and its geometric extents.
             return e.GetType().Name + ":" + e.GeometricExtents.ToString();
         }

         //private AcadGeo.Point3dCollection RetrieveGripInfo(AcadDB.Entity e)
         //{
         //    AcadGeo.Point3dCollection grips = null;
         //    string key = GetKey(e);
         //    if (_gripDict.ContainsKey(key))
         //    {
         //        grips = _gripDict[key];
         //    }
         //    return grips;
         //}

         //private void StoreGripInfo(AcadDB.Entity e, AcadGeo.Point3dCollection grips)
         //{
         //    string key = GetKey(e);
         //    if (_gripDict.ContainsKey(key))
         //    {
         //        // Clear the grips if any already associated
         //        AcadGeo.Point3dCollection grps = _gripDict[key];
         //        using (grps)
         //        {
         //            grps.Clear();
         //        }
         //        _gripDict.Remove(key);
         //    }

         //    AcadGeo.Point3d[] pts = new AcadGeo.Point3d[grips.Count];
         //    grips.CopyTo(pts, 0);
         //    AcadGeo.Point3dCollection gps = new AcadGeo.Point3dCollection(pts);
         //    _gripDict.Add(key, gps);
         //}

         //public override void GetGripPoints(AcadDB.Entity e, 
         //                                   AcadGeo.Point3dCollection grips, 
         //                                   AcadGeo.IntegerCollection snaps,
         //                                   AcadGeo.IntegerCollection geoIds)
         //{
         //    base.GetGripPoints(e, grips, snaps, geoIds);

         //    StoreGripInfo(e, grips);
         //}

        // public override void MoveGripPointsAt(AcadDB.Entity e, AcadGeo.IntegerCollection indices, AcadGeo.Vector3d offset)
        // {
        //    //  Get handles to current AutoCAD drawing session.
        //    AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
        //    AcadDB.Database db = doc.Database;
        //    AcadEd.Editor ed = doc.Editor;

        //    AcadGeo.Point3dCollection grips = RetrieveGripInfo(e);
        //    if (grips != null)
        //    {
        //        foreach (int i in indices)
        //        {
        //            AcadGeo.Point3d pt = grips[i];

        //            ed.DrawVector(
        //                pt,
        //                pt + offset,
        //                (i >= 6 ? i +2 : i+1),
        //                false
        //                );
        //        }
        //        base.MoveGripPointsAt(e, indices, offset);
        //    }
        //}

         //  Overrides nomarl grip behavior to update Device ID
         public override void OnGripStatusChanged(AcadDB.Entity entity, AcadDB.GripStatus status)
         {
             StringBuilder sbLispFunction = new StringBuilder();
             
             if (status == AcadDB.GripStatus.GripsDone)
             {

                AcadDB.ResultBuffer resultBuffer = new AcadDB.ResultBuffer
                {
                    new AcadDB.TypedValue((int)Acad.LispDataType.ObjectId, entity.ObjectId)
                };
                int intResult = Adds.AcadPutSym("RILineID", resultBuffer);

                 sbLispFunction.Append("(ChngUm T RILineID)");
                 resultBuffer = null;

                 Adds.ads_queueexpr(sbLispFunction.ToString());

             }             
         }

         [Acad.CommandMethod("RIStretch")]
         public void GripOverrideOnOff()
         {
             //  Get handles to current AutoCAD drawing session.
             AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
             AcadEd.Editor ed = doc.Editor;

             if (overruling)
             {
                 AcadDB.ObjectOverrule.RemoveOverrule(Acad.RXClass.GetClass(typeof(AcadDB.Polyline2d)), GripVectorOverrule.theOverrule);
             }
             else
             {
                 AcadDB.ObjectOverrule.AddOverrule(Acad.RXClass.GetClass(typeof(AcadDB.Polyline2d)), GripVectorOverrule.theOverrule, true);
             }

             overruling = !overruling;
             GripVectorOverrule.Overruling = overruling;

             ed.WriteMessage("\nRI Polyline Stretch Grip overruling turned {0}.", (overruling ? "on" : "off"));
         }
     }
}
