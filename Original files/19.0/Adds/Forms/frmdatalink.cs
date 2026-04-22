using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadColor = Autodesk.AutoCAD.Colors;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;


namespace Adds.Forms
{
    public partial class frmDataLink : Form
    {
        public frmDataLink()
        {
            InitializeComponent();
        }

        private void btnPlace_Click(object sender, EventArgs e)
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

            using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
            {
                AcadDB.BlockTable bt = (AcadDB.BlockTable)tr.GetObject(dbDwg.BlockTableId, AcadDB.OpenMode.ForRead, false);
                AcadDB.BlockTableRecord btr = (AcadDB.BlockTableRecord)tr.GetObject(bt[AcadDB.BlockTableRecord.ModelSpace], AcadDB.OpenMode.ForWrite, false);
                bt.Dispose();                                                                   //  Cleanup memory for AutoCAD wrapper

                AcadDB.DBText acadText = new AcadDB.DBText();

                acadText.Layer = "0";
                acadText.TextString = txtDisplayText.Text;
                acadText.Height = strDiv.ToUpper() == "FL" ? 30 : 20;
                
                acadText.Color = AcadColor.Color.FromColorIndex(AcadColor.ColorMethod.ByAci, 4);  // 0~By Block, 256~By Layer

                //  Adds new text to AutoCAD drawing database
                btr.AppendEntity(acadText);
                btr.Dispose();                              //  Cleanup memory for AutoCAD wrapper
                tr.AddNewlyCreatedDBObject(acadText, true);

                TextJig textJig = new TextJig(acadText);

                if (textJig.Run() != AcadEd.PromptStatus.OK)
                    return;
                
                txtDeviceID.Text = Utilities.GetNextDeviceID("T_");
                Adds.SetStoredXData(acadText, "ID", txtDeviceID.Text);
                Adds.SetStoredXData(acadText, "PE_URL", txtURL.Text);
                Adds.SetStoredXData(acadText, "CLR_NUM", txtURL.Text);
                tr.Commit();
            }
        }

        private void rbnKeyAccount_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "KEY ACCOUNT";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = "https://gabrielleois.southernco.com/Applications/Customer/LoadOisForEntity.asp?EntityType=3&CompanyID=1&EntityID=3648404&EntityIDType=0&Action=0&PageTitle=Gabrielle Entity Loader";
            this.txtURL.Enabled = false;
        }

        private void rbnKeyRep_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "KEY REP";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = "https://sam.southernco.com/Search/CustomerSearch.aspx?acctnum=";
            this.txtURL.Enabled = true;
        }

        private void rbnPictures_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "PICTURES";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = "http://pdtweb.southernco.com/substation_pics/";
            this.txtURL.Enabled = true;
        }

        private void rbnPrint_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "PRINT";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = "http://pdtweb.southernco.com/search/?dwgnum=";
            this.txtURL.Enabled = true;
        }

        private void rbtSOP_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "SOP";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = @"S:\Workgroups\APC Power Delivery-ACC\TIP-Transmission Information Portal\sop\";
            this.txtURL.Enabled = true;
        }

        private void rbnSTA_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "STA ";
            this.txtDisplayText.Enabled = true;
            this.txtURL.Text = "http://accweb.southernco.com/TransMap/Stomp_Inventory_Drill.aspx?fac_id=";
            this.txtURL.Enabled = true;
        }

        private void rbnWEBFG_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "WEBFG";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = "http://a0sw00.scada.apc.southernco.com/webfg/adn/displays/scada/";
            this.txtURL.Enabled = true;
        }

        private void rbnOA_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "OA";
            this.txtDisplayText.Enabled = false;
            this.txtURL.Text = @"S:\Workgroups\APC Power Delivery-ACC\Web\OAs\";
            this.txtURL.Enabled = true;
        }

        private void rbnOther_CheckedChanged(object sender, EventArgs e)
        {
            this.txtDisplayText.Text = "";
            this.txtDisplayText.Enabled = true;
            this.txtURL.Text = "";
            this.txtURL.Enabled = true;
        }        
    }
}
