using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.ServiceProcess;

using LumiSoft.MailServer.Resources;

namespace LumiSoft.MailServer.UI
{
    /// <summary>
    /// LumiSoft mail server installer.
    /// </summary>
    public class wfrm_Install : Form
    {
        private GroupBox m_pService          = null;
        private Button   m_pInstallAsService = null;
        private Button   m_pUninstallService = null;
        private GroupBox m_pRun              = null;
        private Button   m_pRunAsTryApp      = null;
        private Button   m_pRunAsWindowsForm = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        public wfrm_Install()
        {
            InitUI();

            if(Environment.OSVersion.Platform == PlatformID.Unix){
                m_pRunAsTryApp.Enabled = true;
                m_pRunAsWindowsForm.Enabled = true;
            }
            else{
                if(!IsServiceInstalled()){
                    m_pInstallAsService.Enabled = true;
                    m_pUninstallService.Enabled = false;
                    m_pRunAsTryApp.Enabled = true;
                    m_pRunAsWindowsForm.Enabled = true;
                }
                else{
                    m_pInstallAsService.Enabled = false;
                    m_pUninstallService.Enabled = true;
                }
            }
        }

        #region method InitUI

        /// <summary>
        /// Creates and intializes UI.
        /// </summary>
        private void InitUI()
        {
            this.ClientSize = new Size(220,200);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Text = "Mail Server Installer";
            this.Icon = ResManager.GetIcon("trayicon.ico");

            m_pService = new GroupBox();
            m_pService.Size = new Size(200,80);
            m_pService.Location = new Point(10,10);
            m_pService.Text = "Service:";

            m_pInstallAsService = new Button();
            m_pInstallAsService.Size = new Size(180,20);
            m_pInstallAsService.Location = new Point(10,20);
            m_pInstallAsService.Enabled = false;
            m_pInstallAsService.Text = "Install as Service";
            m_pInstallAsService.Click += new EventHandler(m_pInstallAsService_Click);

            m_pUninstallService = new Button();
            m_pUninstallService.Size = new Size(180,20);
            m_pUninstallService.Location = new Point(10,45);
            m_pUninstallService.Enabled = false;
            m_pUninstallService.Text = "Uninstall";
            m_pUninstallService.Click += new EventHandler(m_pUninstallService_Click);

            m_pService.Controls.Add(m_pInstallAsService);
            m_pService.Controls.Add(m_pUninstallService);

            m_pRun = new GroupBox();
            m_pRun.Size = new Size(200,80);
            m_pRun.Location = new Point(10,100);
            m_pRun.Text = "Run:";

            m_pRunAsTryApp = new Button();
            m_pRunAsTryApp.Size = new Size(180,20);
            m_pRunAsTryApp.Location = new Point(10,20);
            m_pRunAsTryApp.Enabled = false;
            m_pRunAsTryApp.Text = "Run as tray application";
            m_pRunAsTryApp.Click += new EventHandler(m_pRunAsTryApp_Click);

            m_pRunAsWindowsForm = new Button();
            m_pRunAsWindowsForm.Size = new Size(180,20);
            m_pRunAsWindowsForm.Location = new Point(10,45);
            m_pRunAsWindowsForm.Enabled = false;
            m_pRunAsWindowsForm.Text = "Run as windows form application";
            m_pRunAsWindowsForm.Click += new EventHandler(m_pRunAsWindowsForm_Click);

            m_pRun.Controls.Add(m_pRunAsTryApp);
            m_pRun.Controls.Add(m_pRunAsWindowsForm);

            this.Controls.Add(m_pService);
            this.Controls.Add(m_pRun);
        }
                                                                
        #endregion


        #region Events Handling

        #region method m_pInstallAsService_Click

        private void m_pInstallAsService_Click(object sender,EventArgs e)
        {            
            System.Diagnostics.Process.Start(Application.StartupPath + "/MailServerService.exe","-install"); 
           
            m_pInstallAsService.Enabled = false;
            m_pUninstallService.Enabled = true;
            m_pRunAsTryApp.Enabled = false;
            m_pRunAsWindowsForm.Enabled = false;
        }

        #endregion

        #region method m_pUninstallService_Click

        private void m_pUninstallService_Click(object sender,EventArgs e)
        {
            System.Diagnostics.Process.Start(Application.StartupPath + "/MailServerService.exe","-uninstall");

            m_pInstallAsService.Enabled = true;
            m_pUninstallService.Enabled = false;
            m_pRunAsTryApp.Enabled = true;
            m_pRunAsWindowsForm.Enabled = true;
        }

        #endregion


        #region method m_pRunAsTryApp_Click

        private void m_pRunAsTryApp_Click(object sender,EventArgs e)
        {
            if(Environment.OSVersion.Platform == PlatformID.Unix){                
                System.Diagnostics.Process.Start("mono",Application.StartupPath + "/lsMailServer.exe -trayapp");
            }
            else{
                System.Diagnostics.Process.Start(Application.StartupPath + "/lsMailServer.exe","-trayapp");
            }

            m_pInstallAsService.Enabled = false;
            m_pUninstallService.Enabled = false;
            m_pRunAsTryApp.Enabled = false;
            m_pRunAsWindowsForm.Enabled = false;
        }

        #endregion

        #region method m_pRunAsWindowsForm_Click

        private void m_pRunAsWindowsForm_Click(object sender,EventArgs e)
        {
            if(Environment.OSVersion.Platform == PlatformID.Unix){
                System.Diagnostics.Process.Start("mono",Application.StartupPath + "/lsMailServer.exe -winform");
            }
            else{
                System.Diagnostics.Process.Start(Application.StartupPath + "/lsMailServer.exe","-winform");
            }

            m_pInstallAsService.Enabled = false;
            m_pUninstallService.Enabled = false;
            m_pRunAsTryApp.Enabled = false;
            m_pRunAsWindowsForm.Enabled = false;
        }

        #endregion

        #endregion


        #region method IsServiceInstalled

        /// <summary>
        /// Gets if mail server service is installed.
        /// </summary>
        /// <returns></returns>
        private bool IsServiceInstalled()
        {
            foreach(ServiceController service in ServiceController.GetServices()){
                if(service.ServiceName == "LumiSoft Mail Server"){
                    return true;
                }
            }

            return false;
        }

        #endregion

    }
}
