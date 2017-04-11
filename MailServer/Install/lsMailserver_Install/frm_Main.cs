using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace lsMailserver_Install
{
    /// <summary>
    /// Application main form.
    /// </summary>
    public class frm_Main : Form
    {
        private Panel m_pFrame = null;

        private string                   m_InstallPath         = "";
        private frm_LicenseAgreement     m_pLicenseAgreementUI = null;
        private frm_InstallationLocation m_pInstallLocationUI  = null;
        private frm_API_UI               m_pAPI_UI             = null;
        private frm_InstallUI            m_pInstallUI          = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        public frm_Main()
        {
            InitUI();

            m_pLicenseAgreementUI = new frm_LicenseAgreement(this);
            m_pInstallLocationUI = new frm_InstallationLocation(this);
            m_pAPI_UI = new frm_API_UI(this);
            m_pInstallUI = new frm_InstallUI(this);

            m_pFrame.Controls.Add(m_pLicenseAgreementUI);
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes UI.
        /// </summary>
        private void InitUI()
        {
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Size = new Size(518,359);
            this.MaximizeBox = false;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.Text = "LumiSoft Mail Server Install";

            m_pFrame = new Panel();
            m_pFrame.Location = new Point(2,5);
            m_pFrame.Size = new Size(506,325);

            this.Controls.Add(m_pFrame);
        }
                
        #endregion


        #region method Back

        internal void Back()
        {
            if(m_pFrame.Controls[0].GetType() == typeof(frm_InstallationLocation)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pLicenseAgreementUI);
            }
            else if(m_pFrame.Controls[0].GetType() == typeof(frm_API_UI)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pInstallLocationUI);
            }
            else if(m_pFrame.Controls[0].GetType() == typeof(frm_InstallUI)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pAPI_UI);
            }
        }

        #endregion

        #region method Next

        internal void Next()
        {
           if(m_pFrame.Controls[0].GetType() == typeof(frm_LicenseAgreement)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pInstallLocationUI);
           }
           else if(m_pFrame.Controls[0].GetType() == typeof(frm_InstallationLocation)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pAPI_UI);
           }
           else if(m_pFrame.Controls[0].GetType() == typeof(frm_API_UI)){
               m_pFrame.Controls.Clear();
               m_pFrame.Controls.Add(m_pInstallUI);
           }
       }

        #endregion
               
        #region method Cancel

        internal void Cancel()
        {
            if(MessageBox.Show(this,"Click yes to cancel installation.","",MessageBoxButtons.YesNo,MessageBoxIcon.Question) == DialogResult.Yes){
                this.Close();
            }
        }

       #endregion


        #region Properties Implementation

        /// <summary>
        /// Gets or sets installation path.
        /// </summary>
        public string InstallPath
        {
            get{ return m_InstallPath; }

            set{ m_InstallPath = value; }
        }

        #endregion

    }
}
