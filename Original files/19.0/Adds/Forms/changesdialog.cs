using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Adds
{
    public partial class ChangesDialog : Form
    {
        public string strDateStart = string.Empty;
        public string strDateEnd = string.Empty;

        public ChangesDialog()
        {
            InitializeComponent();
            setDateRange();
        }

        private void setDateRange()
        {
            DateTime todaysDate = DateTime.Now;
            this.mcalStartDate.MaxDate = todaysDate;

            DateTime minDate = todaysDate.AddDays(-14);
            this.mcalStartDate.MinDate = minDate;
            
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            strDateStart = string.Empty;
            this.Close();
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (strDateStart == string.Empty)
            {
                DateTime todaysDate = DateTime.Now;
                strDateStart = todaysDate.ToString("MM/dd/yyyy");
            }
            this.Close();
        }

        private void mcalStartDate_DateChanged(object sender, DateRangeEventArgs e)
        {
            strDateStart = e.Start.ToString("MM/dd/yyyy");
            strDateEnd = e.End.ToString("MM/dd/yyyy");
        }

        private void mcalStartDate_DateSelected(object sender, DateRangeEventArgs e)
        {
            strDateStart = e.Start.ToString("MM/dd/yyyy");
            strDateEnd = e.End.ToString("MM/dd/yyyy");
        }

    }
}
