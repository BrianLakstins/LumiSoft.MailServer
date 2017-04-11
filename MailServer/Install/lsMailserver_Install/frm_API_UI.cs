using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace lsMailserver_Install
{    
    /// <summary>
    /// API selection and configuration UI.
    /// </summary>
    public class frm_API_UI : Form, IValidateInstallUI
    {
        private frm_Main m_pMain        = null;
        private Label    mt_ApiTypeText = null;
        private ComboBox m_pApiType     = null;
        private GroupBox m_pLine        = null;
        private Button   m_pBack        = null;
        private Button   m_pNext        = null;
        private Button   m_pCancel      = null;
        //--- XML API ---------------------------//
        private Label   mt_SettigsPath      = null;
        private TextBox m_pSettingsPath     = null;
        private Button  m_pGetSttingsPath   = null;
        private Label   mt_MailStorePath    = null;
        private TextBox m_pMailStorePath    = null;
        private Button  m_pGetMailStorePath = null;
        //--- MSSQL API -------------------------//
        private Label   mt_Server   = null;
        private TextBox m_pServer   = null;
        private Label   mt_UserName = null;
        private TextBox m_pUserName = null;
        private Label   mt_Password = null;
        private TextBox m_pPassword = null;
        private Label   mt_Database = null;
        private TextBox m_pDatabase = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="main">Main install UI form.</param>
        public frm_API_UI(frm_Main main)
        {
            m_pMain = main;

            InitUI();

            // Select XML API by default
            m_pApiType.SelectedIndex = 0;
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes UI.
        /// </summary>
        private void InitUI()
        {
            this.ClientSize = new System.Drawing.Size(506,271);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.TopLevel = false;
            this.Dock = DockStyle.Fill;
            this.Visible = true;

            mt_ApiTypeText = new Label();
            mt_ApiTypeText.Location = new Point(10,81);
            mt_ApiTypeText.Size = new Size(200,13);

            m_pApiType = new ComboBox();
            m_pApiType.Location = new Point(10,97);
            m_pApiType.Size = new Size(177,21);
            m_pApiType.DropDownStyle = ComboBoxStyle.DropDownList;
            m_pApiType.Items.Add("XML");
            m_pApiType.Items.Add("MSSQL");
            m_pApiType.SelectedIndexChanged += new EventHandler(m_pApiType_SelectedIndexChanged);

            m_pLine = new GroupBox();
            m_pLine.Location = new Point(2,282);
            m_pLine.Size = new Size(506,3);

            m_pBack = new Button();
            m_pBack.Location = new Point(214,298);
            m_pBack.Size = new Size(87,23);
            m_pBack.Text = "Back";
            m_pBack.Click += new EventHandler(m_pBack_Click);

            m_pNext = new Button();
            m_pNext.Location = new Point(307,298);
            m_pNext.Size = new Size(92,23);
            m_pNext.Text = "Next";
            m_pNext.Click += new EventHandler(m_pNext_Click);

            m_pCancel = new Button();
            m_pCancel.Location = new Point(411,298);
            m_pCancel.Size = new Size(87,23);
            m_pCancel.Text = "Cancel";
            m_pCancel.Click += new EventHandler(m_pCancel_Click);
            
            //--- XML API -------------------------------//
            mt_SettigsPath = new Label();
            mt_SettigsPath.Location = new Point(10,130);
            mt_SettigsPath.Size = new Size(200,13);
            mt_SettigsPath.Text = "Settings path:";
            mt_SettigsPath.Visible = false;

            m_pSettingsPath = new TextBox();
            m_pSettingsPath.Location = new Point(10,146);
            m_pSettingsPath.Size = new Size(452,0);
            m_pSettingsPath.Visible = false;
            m_pSettingsPath.Text = "c:\\LumiSoftMailServer\\Settings\\local_XML";

            m_pGetSttingsPath = new Button();
            m_pGetSttingsPath.Location = new Point(468,146);
            m_pGetSttingsPath.Size = new Size(25,19);
            m_pGetSttingsPath.Text = "...";
            m_pGetSttingsPath.Visible = false;
            m_pGetSttingsPath.Click += new EventHandler(m_pGetSttingsPath_Click);

            mt_MailStorePath = new Label();
            mt_MailStorePath.Location = new Point(10,175);
            mt_MailStorePath.Size = new Size(200,13);
            mt_MailStorePath.Text = "Mail store path:";
            mt_MailStorePath.Visible = false;

            m_pMailStorePath = new TextBox();
            m_pMailStorePath.Location = new Point(10,191);
            m_pMailStorePath.Size = new Size(452,20);
            m_pMailStorePath.Visible = false;
            m_pMailStorePath.Text = "c:\\LumiSoftMailServer\\MailStore";

            m_pGetMailStorePath = new Button();
            m_pGetMailStorePath.Location = new Point(468,191);
            m_pGetMailStorePath.Size = new Size(25,19);
            m_pGetMailStorePath.Text = "...";
            m_pGetMailStorePath.Visible = false;
            m_pGetMailStorePath.Click += new EventHandler(m_pGetMailStorePath_Click);
            //------------------------------------------//

            //--- MSSQL API ----------------------------//
            mt_Server = new Label();
            mt_Server.Location = new Point(144,142);
            mt_Server.Size = new Size(41,13);
            mt_Server.Visible = false;
            mt_Server.Text = "Server:";

            m_pServer = new TextBox();
            m_pServer.Location = new Point(185,139);
            m_pServer.Size = new Size(174,20);
            m_pServer.Visible = false;
            m_pServer.Text = "localhost";

            mt_UserName = new Label();
            mt_UserName.Location = new Point(116,168);
            mt_UserName.Size = new Size(63,13);
            mt_UserName.Visible = false;
            mt_UserName.Text = "User Name:";

            m_pUserName = new TextBox();
            m_pUserName.Location = new Point(185,165);
            m_pUserName.Size = new Size(174,20);
            m_pUserName.Visible = false;
            m_pUserName.Text = "sa";

            mt_Password = new Label();
            mt_Password.Location = new Point(123,198);
            mt_Password.Size = new Size(56,13);
            mt_Password.Visible = false;
            mt_Password.Text = "Password:";

            m_pPassword = new TextBox();
            m_pPassword.Location = new Point(185,191);
            m_pPassword.Size = new Size(174,20);
            m_pPassword.Visible = false;

            mt_Database = new Label();
            mt_Database.Location = new Point(92,230);
            mt_Database.Size = new Size(87,13);
            mt_Database.Visible = false;
            mt_Database.Text = "Database Name:";

            m_pDatabase = new TextBox();
            m_pDatabase.Location = new Point(185,227);
            m_pDatabase.Size = new Size(174,20);
            m_pDatabase.Visible = false;
            m_pDatabase.Text = "lsMailServer";
            //------------------------------------------//
            
            this.Controls.Add(mt_ApiTypeText);
            this.Controls.Add(m_pApiType);
            this.Controls.Add(m_pLine);
            this.Controls.Add(m_pBack);
            this.Controls.Add(m_pNext);
            this.Controls.Add(m_pCancel);
            //--- XML API -----------------------//
            this.Controls.Add(mt_SettigsPath);
            this.Controls.Add(m_pSettingsPath);
            this.Controls.Add(m_pGetSttingsPath);
            this.Controls.Add(mt_MailStorePath);
            this.Controls.Add(m_pMailStorePath);
            this.Controls.Add(m_pGetMailStorePath);
            //--- MSSQL API ---------------------//
            this.Controls.Add(mt_Server);
            this.Controls.Add(m_pServer);
            this.Controls.Add(mt_UserName);
            this.Controls.Add(m_pUserName);
            this.Controls.Add(mt_Password);
            this.Controls.Add(m_pPassword);
            this.Controls.Add(mt_Database);
            this.Controls.Add(m_pDatabase);
        }
                                                
        #endregion

        #region Events handling

        #region method m_pApiType_SelectedIndexChanged

        private void m_pApiType_SelectedIndexChanged(object sender,EventArgs e)
        {
            // Hide all API controls
            mt_SettigsPath.Visible = false;
            m_pSettingsPath.Visible = false;
            m_pGetSttingsPath.Visible = false;
            mt_MailStorePath.Visible = false;
            m_pMailStorePath.Visible = false;
            m_pGetMailStorePath.Visible = false;
            //
            mt_Server.Visible = false; 
            m_pServer.Visible = false;
            mt_UserName.Visible = false;
            m_pUserName.Visible = false;
            mt_Password.Visible = false;
            m_pPassword.Visible = false;
            mt_Database.Visible = false;
            m_pDatabase.Visible = false;

           
            if(m_pApiType.SelectedItem.ToString() == "XML"){
                mt_SettigsPath.Visible = true;
                m_pSettingsPath.Visible = true;
                m_pGetSttingsPath.Visible = true;
                mt_MailStorePath.Visible = true;
                m_pMailStorePath.Visible = true;
                m_pGetMailStorePath.Visible = true;
            }
            else if(m_pApiType.SelectedItem.ToString() == "MSSQL"){
                mt_Server.Visible = true; 
                m_pServer.Visible = true;
                mt_UserName.Visible = true;
                m_pUserName.Visible = true;
                mt_Password.Visible = true;
                m_pPassword.Visible = true;
                mt_Database.Visible = true;
                m_pDatabase.Visible = true;
            }
        }

        #endregion


        #region method m_pGetSttingsPath_Click

        private void m_pGetSttingsPath_Click(object sender,EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            if(dlg.ShowDialog(this) == DialogResult.OK){
                m_pSettingsPath.Text = dlg.SelectedPath;
            }
        }

        #endregion

        #region method m_pGetMailStorePath_Click

        private void m_pGetMailStorePath_Click(object sender,EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            if(dlg.ShowDialog(this) == DialogResult.OK){
                m_pMailStorePath.Text = dlg.SelectedPath;
            }
        }

        #endregion


        #region method m_pBack_Click

        private void m_pBack_Click(object sender,EventArgs e)
        {
            m_pMain.Back();
        }

        #endregion

        #region method m_pNext_Click

        private void m_pNext_Click(object sender,EventArgs e)
        {
            // Validate XML config values
            if(m_pApiType.SelectedItem.ToString() == "XML"){
                if(m_pSettingsPath.Text == ""){
                    MessageBox.Show(this,"Settings location may not be empty !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                    return;
                }
                if(m_pMailStorePath.Text == ""){
                    MessageBox.Show(this,"Mail store location may not be empty !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                    return;
                }
            }

            // Validate MSSQL config values
            if(m_pApiType.SelectedItem.ToString() == "MSSQL"){
                if(m_pServer.Text == ""){
                    MessageBox.Show(this,"Sql server name may not be empty !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                    return;
                }
                if(m_pDatabase.Text == ""){
                    MessageBox.Show(this,"Sql server database name may not be empty !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                    return;
                }
            }



            m_pMain.Next();
        }

        #endregion

        #region method m_pCancel_Click

        private void m_pCancel_Click(object sender,EventArgs e)
        {
            m_pMain.Cancel();
        }

        #endregion

        #endregion


        #region interface IValidateInstallUI implementation

        /// <summary>
        /// Gets is install UI has vaild values.
        /// </summary>
        /// <returns>Returns true if install UI has vlaid values.</returns>
        public bool IsValid()
        {
            return true;
        }

        #endregion

    }
}
