using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Data;

namespace Mail_Server_Configuration
{
    /// <summary>
    /// Add/edit IP access settings window.
    /// </summary>
    public class wfrm_IPAccess : Form
    {
        private Label    mt_StartIP   = null;
        private TextBox  m_pStartIP   = null;
        private Label    mt_EndIP     = null;
        private TextBox  m_pEndIP     = null;
        private GroupBox m_pGroupbox1 = null;
        private Button   m_pCancel    = null;
        private Button   m_pOk        = null;

        private DataSet m_pDsSettings = null;
        private DataRow m_pDrIPAccess = null;
        private bool    m_Add_Edit    = true;

        /// <summary>
        /// Add constructor.
        /// </summary>
        /// <param name="dsSettings">Reference to settings DataSet.</param>
        public wfrm_IPAccess(DataSet dsSettings)
        {
            m_pDsSettings = dsSettings;
            m_Add_Edit    = true;

            InitUI();
        }

        /// <summary>
        /// Edit constructor.
        /// </summary>
        /// <param name="dsSettings">Reference to settings DataSet.</param>
        /// <param name="dr">Reference to DataRow what contains editable IP access info.</param>
        public wfrm_IPAccess(DataSet dsSettings,DataRow dr)
        {
            m_pDsSettings = dsSettings;
            m_pDrIPAccess = dr;
            m_Add_Edit    = false;

            InitUI();

            m_pStartIP.Text = dr["StartIP"].ToString();
            m_pEndIP.Text   = dr["EndIP"].ToString(); 
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes window UI.
        /// </summary>
        private void InitUI()
        {
            this.Size = new Size(330,140);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Text = "IP Access settings:";

            mt_StartIP = new Label();
            mt_StartIP.Size = new Size(100,18);
            mt_StartIP.Location = new Point(5,20);
            mt_StartIP.TextAlign = ContentAlignment.MiddleRight;
            mt_StartIP.Text = "Start IP:";

            m_pStartIP = new TextBox();
            m_pStartIP.Size = new Size(200,20);
            m_pStartIP.Location = new Point(105,20);

            mt_EndIP = new Label();
            mt_EndIP.Size = new Size(100,18);
            mt_EndIP.Location = new Point(5,45);
            mt_EndIP.TextAlign = ContentAlignment.MiddleRight;
            mt_EndIP.Text = "End IP:";

            m_pEndIP = new TextBox();
            m_pEndIP.Size = new Size(200,20);
            m_pEndIP.Location = new Point(105,45);

            m_pGroupbox1 = new GroupBox();
            m_pGroupbox1.Size = new Size(325,3);
            m_pGroupbox1.Location = new Point(3,75);

            m_pCancel = new Button();
            m_pCancel.Size = new Size(70,20);
            m_pCancel.Location = new Point(160,85);
            m_pCancel.Text = "Cancel";
            m_pCancel.Click += new EventHandler(m_pCancel_Click);

            m_pOk = new Button();
            m_pOk.Size = new Size(70,20);
            m_pOk.Location = new Point(235,85);
            m_pOk.Text = "Ok";
            m_pOk.Click += new EventHandler(m_pOk_Click);

            this.Controls.Add(mt_StartIP);
            this.Controls.Add(m_pStartIP);
            this.Controls.Add(mt_EndIP);
            this.Controls.Add(m_pEndIP);
            this.Controls.Add(m_pGroupbox1);
            this.Controls.Add(m_pCancel);
            this.Controls.Add(m_pOk);
        }

        #endregion


        #region Events Handling

        #region method m_pCancel_Click

        private void m_pCancel_Click(object sender, EventArgs e)
        {
            this.DialogResult = DialogResult.Cancel;
            this.Close();
        }

        #endregion

        #region method m_pOk_Click

        private void m_pOk_Click(object sender, EventArgs e)
        {
            string startIP = m_pStartIP.Text;
            string endIP   = m_pEndIP.Text;
            if(endIP == ""){
                endIP = startIP;
            }
                        
            //--- Validate values ------------------------------------------------------------------------------//
            try{
                System.Net.IPAddress.Parse(startIP);             
            }
            catch{
                MessageBox.Show("Invalid start IP value !","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);					
			    return;
            }
            try{
                System.Net.IPAddress.Parse(endIP);             
            }
            catch{
                MessageBox.Show("Invalid end IP value !","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);					
			    return;
            }

            // Check that IP range doesn't already exist
            if(m_Add_Edit){
                foreach(DataRow dr in m_pDsSettings.Tables["IP_Access"].Rows){
                    if(dr["StartIP"].ToString() == startIP && dr["EndIP"].ToString() == endIP){
                        MessageBox.Show("Specified IP range already exists !","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);					
			            return;
                    }
                }
            }
            //--------------------------------------------------------------------------------------------------//
            
            if(m_Add_Edit){
                DataRow dr = m_pDsSettings.Tables["IP_Access"].NewRow();
                dr["StartIP"] = m_pStartIP.Text;
                dr["EndIP"]   = m_pEndIP.Text;
                m_pDsSettings.Tables["IP_Access"].Rows.Add(dr);
            }
            else{
                m_pDrIPAccess["StartIP"] = m_pStartIP.Text;
                m_pDrIPAccess["EndIP"]   = m_pEndIP.Text;
            }

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        #endregion

        #endregion

    }
}
