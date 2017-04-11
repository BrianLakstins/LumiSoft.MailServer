using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Data;

namespace Mail_Server_Configuration
{
    /// <summary>
    /// Add/Edit user settings window.
    /// </summary>
    public class wfrm_User : Form
    {
        private Label    mt_UserName  = null;
        private TextBox  m_pUserName  = null;
        private Label    mt_Password  = null;
        private TextBox  m_pPassword  = null;
        private GroupBox m_pGroupbox1 = null;
        private Button   m_pCancel    = null;
        private Button   m_pOk        = null;

        private DataSet m_pDsSettings = null;
        private DataRow m_pDrUser     = null;
        private bool    m_Add_Edit    = true;

        /// <summary>
        /// Add constructor.
        /// </summary>
        /// <param name="dsSettings">Reference to settings DataSet.</param>
        public wfrm_User(DataSet dsSettings)
        {
            m_pDsSettings = dsSettings;
            m_Add_Edit    = true;

            InitUI();
        }

        /// <summary>
        /// Edit constructor.
        /// </summary>
        /// <param name="dsSettings">Reference to settings DataSet.</param>
        /// <param name="dr">Reference to DataRow what contains editable user info.</param>
        public wfrm_User(DataSet dsSettings,DataRow dr)
        {
            m_pDsSettings = dsSettings;
            m_pDrUser     = dr;
            m_Add_Edit    = false;

            InitUI();

            m_pUserName.Text = dr["UserName"].ToString();
            m_pUserName.ReadOnly = true;
            m_pPassword.Text = dr["Password"].ToString();
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
            this.Text = "User settings:";

            mt_UserName = new Label();
            mt_UserName.Size = new Size(100,18);
            mt_UserName.Location = new Point(5,20);
            mt_UserName.TextAlign = ContentAlignment.MiddleRight;
            mt_UserName.Text = "User Name:";

            m_pUserName = new TextBox();
            m_pUserName.Size = new Size(200,20);
            m_pUserName.Location = new Point(105,20);

            mt_Password = new Label();
            mt_Password.Size = new Size(100,18);
            mt_Password.Location = new Point(5,45);
            mt_Password.TextAlign = ContentAlignment.MiddleRight;
            mt_Password.Text = "Password:";

            m_pPassword = new TextBox();
            m_pPassword.Size = new Size(200,20);
            m_pPassword.Location = new Point(105,45);
            m_pPassword.PasswordChar = '*';

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

            this.Controls.Add(mt_UserName);
            this.Controls.Add(m_pUserName);
            this.Controls.Add(mt_Password);
            this.Controls.Add(m_pPassword);
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
            //--- Validate values ------------------------------------------------------------------------------//
            if(m_pUserName.Text == ""){
                MessageBox.Show("User name cannot be empty !","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);					
			    return;
            }

            // Check that user doesn't already exist
            if(m_Add_Edit){
                foreach(DataRow dr in m_pDsSettings.Tables["Users"].Rows){
                    if(dr["UserName"].ToString().ToLower() == m_pUserName.Text.ToLower()){
                        MessageBox.Show("Specified user '" + m_pUserName.Text + "' already exists !","Error",MessageBoxButtons.OK,MessageBoxIcon.Error);					
			            return;
                    }
                }
            }
            //--------------------------------------------------------------------------------------------------//

            if(m_Add_Edit){
                DataRow dr = m_pDsSettings.Tables["Users"].NewRow();
                dr["UserName"] = m_pUserName.Text;
                dr["Password"] = m_pPassword.Text;
                m_pDsSettings.Tables["Users"].Rows.Add(dr);
            }
            else{
                m_pDrUser["Password"] = m_pPassword.Text;                
            }

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        #endregion

        #endregion

    }
}
