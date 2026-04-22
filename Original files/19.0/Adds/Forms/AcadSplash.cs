using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using AcadASA = Autodesk.AutoCAD.ApplicationServices.Application;

namespace Adds
{
    public partial class frmAcadSplash : Form
    {
        public frmAcadSplash(string appInfo)
        {
            string strCurrentWorkSpaceName = string.Empty;
            InitializeComponent();
            int? iSpace = appInfo.IndexOf(" ");
            int iSpacePos = iSpace ?? 0;

            var pos = this.PointToScreen(lblAdds.Location);
            pos = this.pictureBox1.PointToClient(pos);
            lblAdds.Parent = this.pictureBox1;
            lblAdds.Location = pos;
            strCurrentWorkSpaceName = (string)AcadASA.GetSystemVariable("WSCURRENT");
            //strCurrentWorkSpaceName = strCurrentWorkSpaceName.ToUpper();
            if (strCurrentWorkSpaceName.ToUpper().Contains("ADDSPLOT"))
            {
                this.lblAdds.Text = "Automated Design && Drafting System Plotting (ADDSPlot)";
            }
            else
            {
                this.lblAdds.Text = "Automated Design && Drafting System (ADDS)";
            }
            lblAdds.BackColor = Color.Transparent;

            this.lblLicenseTo.Text  = "Licensed to: " + Environment.UserName.ToString();
            this.lblProduct.Text    = appInfo.Substring(0, iSpacePos);
            this.lblVersion.Text    = appInfo.Substring(iSpacePos);
            
            tmrSplash.Interval = 6000;
        }

        private void tmrSplash_Tick(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
