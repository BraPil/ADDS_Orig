using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace Adds
{
    public partial class frmResults : Form
    {
        private DataTable _dtTable = null;
        private DataGridViewRow _SelectedRow = null;

        public frmResults(DataTable dtTable)
        {
            InitializeComponent();
            _dtTable = dtTable;
        }

        public DataGridViewRow SelectedRow
        {
            get
            {
                return _SelectedRow;
            }
        }

        private void frmResults_Load(object sender, EventArgs e)
        {
            this.dgvResults.DataSource = _dtTable;

            this.dgvResults.AllowUserToAddRows = false;
            this.dgvResults.ReadOnly = true;
            this.dgvResults.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            this.dgvResults.MultiSelect = false;

            // Used switch to be able to reuse this dialog box for different purposes.
            switch (_dtTable.TableName)
            {
                case "SwitchCor":
                    this.Text = "Open By Switch/Operator Number";

                    this.dgvResults.Columns["operpt_num"].Visible = true;
                    this.dgvResults.Columns["operpt_num"].HeaderText = "Operator Number";
                    this.dgvResults.Columns["operpt_num"].Width = 50;
                    this.dgvResults.Columns["operpt_num"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["operpt_num"].DisplayIndex = 0;
                    
                    this.dgvResults.Columns["adds_blk_nam"].Visible = true;
                    this.dgvResults.Columns["adds_blk_nam"].HeaderText = "Block Name";
                    this.dgvResults.Columns["adds_blk_nam"].Width = 50;
                    this.dgvResults.Columns["adds_blk_nam"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["adds_blk_nam"].DisplayIndex = 1;
                    
                    this.dgvResults.Columns["adds_symbol_desc"].Visible = true;
                    this.dgvResults.Columns["adds_symbol_desc"].HeaderText = "Description";
                    this.dgvResults.Columns["adds_symbol_desc"].Width = 150;
                    this.dgvResults.Columns["adds_symbol_desc"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["adds_symbol_desc"].DisplayIndex = 2;
                    
                    this.dgvResults.Columns["X"].Visible = false;
                    this.dgvResults.Columns["X"].HeaderText = "X";
                    this.dgvResults.Columns["X"].Width = 50;
                    this.dgvResults.Columns["X"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["X"].DisplayIndex = 3;
                    
                    this.dgvResults.Columns["Y"].Visible = false;
                    this.dgvResults.Columns["Y"].HeaderText = "Y";
                    this.dgvResults.Columns["Y"].Width = 50;
                    this.dgvResults.Columns["Y"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["Y"].DisplayIndex = 4;

                    this.dgvResults.Columns["SubCode"].Visible = true;
                    this.dgvResults.Columns["SubCode"].HeaderText = "Substation Code";
                    this.dgvResults.Columns["SubCode"].Width = 65;
                    this.dgvResults.Columns["SubCode"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["SubCode"].DisplayIndex = 5;

                    this.dgvResults.Columns["FeederCode"].Visible = true;
                    this.dgvResults.Columns["FeederCode"].HeaderText = "Feeder Code";
                    this.dgvResults.Columns["FeederCode"].Width = 50;
                    this.dgvResults.Columns["FeederCode"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["FeederCode"].DisplayIndex = 6;
                    
                    this.dgvResults.Columns["feeder_breaker"].Visible = true;
                    this.dgvResults.Columns["feeder_breaker"].HeaderText = "Breaker";
                    this.dgvResults.Columns["feeder_breaker"].Width = 50;
                    this.dgvResults.Columns["feeder_breaker"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["feeder_breaker"].DisplayIndex = 7;

                    this.dgvResults.Columns["feeder_description"].Visible = true;
                    this.dgvResults.Columns["feeder_description"].HeaderText = "Substation/Feeder";
                    this.dgvResults.Columns["feeder_description"].Width = 200;
                    this.dgvResults.Columns["feeder_description"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["feeder_description"].DisplayIndex = 8;

                    this.dgvResults.Columns["MgrOrg"].Visible = true;
                    this.dgvResults.Columns["MgrOrg"].HeaderText = "Division";
                    this.dgvResults.Columns["MgrOrg"].Width = 65;
                    this.dgvResults.Columns["MgrOrg"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["MgrOrg"].DisplayIndex = 9;

                    this.dgvResults.Columns["device_id"].Visible = true;
                    this.dgvResults.Columns["device_id"].HeaderText = "Device ID";
                    this.dgvResults.Columns["device_id"].Width = 110;
                    this.dgvResults.Columns["device_id"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
                    this.dgvResults.Columns["device_id"].DisplayIndex = 10;

                    this.dgvResults.Columns["mgr_org_id"].Visible = false;

                    break;

            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            _SelectedRow = null;
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            _SelectedRow = this.dgvResults.CurrentRow;
        }

    }
}
