using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace lsMailserver_Install
{
    /// <summary>
    /// Installation location UI.
    /// </summary>
    public class frm_InstallationLocation : Form, IValidateInstallUI
    {
        private frm_Main m_pMain            = null;
        private Label    mt_InstallLocation = null;
        private TextBox  m_pInstallLocation = null;
        private Button   m_pGetFolder       = null;
        private GroupBox m_pLine            = null;
        private Button   m_pBack            = null;
        private Button   m_pNext            = null;
        private Button   m_pCancel          = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="main">Main install UI form.</param>
        public frm_InstallationLocation(frm_Main main)
        {
            m_pMain = main;

            InitUI();
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

            mt_InstallLocation = new Label();
            mt_InstallLocation.Location = new Point(7,123);
            mt_InstallLocation.Size = new Size(300,13);
            mt_InstallLocation.Text = "Please select folder where to install Mail Server.";

            m_pInstallLocation = new TextBox();
            m_pInstallLocation.Location = new Point(10,139);
            m_pInstallLocation.Size = new Size(453,20);
            m_pInstallLocation.Text = "c:\\LumiSoftMailServer";

            m_pGetFolder = new Button();
            m_pGetFolder.Location = new Point(469,139);
            m_pGetFolder.Size = new Size(27,20);
            m_pGetFolder.Text = "...";
            m_pGetFolder.Click += new EventHandler(m_pGetFolder_Click);

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

            this.Controls.Add(mt_InstallLocation);
            this.Controls.Add(m_pInstallLocation);
            this.Controls.Add(m_pGetFolder);
            this.Controls.Add(m_pLine);
            this.Controls.Add(m_pBack);
            this.Controls.Add(m_pNext);
            this.Controls.Add(m_pCancel);
        }
               
        #endregion


        #region Events handling

        #region method m_pGetFolder_Click

        private void m_pGetFolder_Click(object sender,EventArgs e)
        {
            FolderBrowserDialog dlg = new FolderBrowserDialog();
            if(dlg.ShowDialog(this) == DialogResult.OK){
                m_pInstallLocation.Text = dlg.SelectedPath;
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
            if(m_pInstallLocation.Text == ""){
                MessageBox.Show(this,"Installation location may not be empty !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                return;
            }

            if(!Directory.Exists(m_pInstallLocation.Text)){
                Directory.CreateDirectory(m_pInstallLocation.Text);
            }

            m_pMain.InstallPath = m_pInstallLocation.Text;
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
