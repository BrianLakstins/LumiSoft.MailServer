using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Reflection;

namespace lsMailserver_Install
{
    /// <summary>
    /// Install UI.
    /// </summary>
    public class frm_InstallUI : Form, IValidateInstallUI
    {
        private frm_Main    m_pMain         = null;
        private Label       mt_ProgressText = null;
        private ProgressBar m_pProgressBar  = null;
        private GroupBox    m_pLine         = null;
        private Button      m_pBack         = null;
        private Button      m_pNext         = null;
        private Button      m_pCancel       = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="main">Main install UI form.</param>
        public frm_InstallUI(frm_Main main)
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

            mt_ProgressText = new Label();
            mt_ProgressText.Location = new Point(10,183);
            mt_ProgressText.Size = new Size(400,13);

            m_pProgressBar = new ProgressBar();
            m_pProgressBar.Location = new Point(10,199);
            m_pProgressBar.Size = new Size(486,23);

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

            this.Controls.Add(mt_ProgressText);
            this.Controls.Add(m_pProgressBar);
            this.Controls.Add(m_pLine);
            this.Controls.Add(m_pBack);
            this.Controls.Add(m_pNext);
            this.Controls.Add(m_pCancel);
        }

        #endregion


        #region Events handling

        #region method m_pBack_Click

        private void m_pBack_Click(object sender,EventArgs e)
        {
            m_pMain.Back();
        }

        #endregion

        #region method m_pNext_Clic

        private void m_pNext_Click(object sender,EventArgs e)
        {           
            string[] files = new string[]{
                "Backup\\default_data.bcp",
                "Filters\\lsDNSBL_Filter.exe",
                "Filters\\lsDNSBL_Filter_db.xml",
                "Filters\\lsInvalidMessageScanner.exe",
                "Filters\\lsSpam_db.xml",
                "Filters\\lsSpamFilter.exe",
                "Filters\\lsVirusFilter.exe",
                "Filters\\lsVirusFilter_db.xml",
                "Filters\\lumisoft.ui.dll",
                "Help\\MailServer_ENG.chm",
                "lsMailServer.exe",
                "LumiSoft.MailServerAPI.dll",
                "LumiSoft.Net.dll",
                "LumiSoft.UI.dll",
                "mssql_API.dll",
                "WebServices_API.dll",
                "version.txt",
                "xml_API.dll"
            };

            m_pProgressBar.Maximum = files.Length;
            m_pProgressBar.Value = 0;

            foreach(string file in files){
                mt_ProgressText.Text = "Copying file: " + file;
                mt_ProgressText.Refresh();
          //    System.Threading.Thread.Sleep(200);

                string dirName = Path.GetDirectoryName(file);
                if(dirName != "" && !Directory.Exists(m_pMain.InstallPath + "\\" + dirName)){
                    Directory.CreateDirectory(m_pMain.InstallPath + "\\" + dirName);
                }
 
                Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream("lsMailserver_Install.Files." + file.Replace("\\","."));
                using(FileStream fs = File.Create(m_pMain.InstallPath + "\\" + file)){
                    byte[] data = new byte[rs.Length];
                    rs.Read(data,0,data.Length);
                    fs.Write(data,0,data.Length);
                }

                m_pProgressBar.Value++; 
            }

            mt_ProgressText.Text = "";
            m_pProgressBar.Visible = false;

            // Run server
        //    System.Diagnostics.Process.Start(new System.Diagnostics.ProcessStartInfo(m_pMain.InstallPath + "\\lsMailServer.exe","install"));

       //   m_pBack.Enabled = false;
       //   m_pCancel.Enabled = false;

         // m_pMain.Next();
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
