using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace LumiSoft.MailServer.UI
{
    /// <summary>
    /// Run as -winform window.
    /// </summary>
    public class wfrm_WinForm : Form
    {
        private Button m_pStart = null;
        private Button m_pStop  = null;

        private Server m_pServer = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        public wfrm_WinForm()
        {
            InitUI();

            m_pServer = new Server();
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes window UI.
        /// </summary>
        private void InitUI()
        {
            this.Size = new Size(200,100);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.FormBorderStyle = FormBorderStyle.FixedDialog;
            this.Text = "LumiSoft Mail Server";
            this.FormClosed += new FormClosedEventHandler(wfrm_WinForm_FormClosed);

            m_pStart = new Button();
            m_pStart.Size = new Size(70,20);
            m_pStart.Location = new Point(110,20);
            m_pStart.Text = "Start";
            m_pStart.Click += new EventHandler(m_pStart_Click);

            m_pStop = new Button();
            m_pStop.Size = new Size(70,20);
            m_pStop.Location = new Point(110,50);
            m_pStop.Text = "Stop";
            m_pStop.Enabled = false;
            m_pStop.Click += new EventHandler(m_pStop_Click);

            this.Controls.Add(m_pStart);
            this.Controls.Add(m_pStop);
        }
                                                               
        #endregion


        #region Events Handling

        #region method wfrm_WinForm_FormClosed

        private void wfrm_WinForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            m_pServer.Stop();
        }

        #endregion


        #region method m_pStart_Click

        private void m_pStart_Click(object sender, EventArgs e)
        {
            try{                
                m_pServer.Start(); 
                m_pStart.Enabled = false;
                m_pStop.Enabled  = true;
            }
            catch(Exception x){
                MessageBox.Show(x.Message);
            }
        }

        #endregion

        #region method m_pStop_Click

        private void m_pStop_Click(object sender, EventArgs e)
        {
            try{                
                m_pServer.Stop();  
                m_pStart.Enabled = true;
                m_pStop.Enabled  = false;              
            }
            catch(Exception x){
                MessageBox.Show(x.Message);
            }
        }

        #endregion

        #endregion

    }
}
