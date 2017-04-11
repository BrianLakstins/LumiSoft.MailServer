using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace lsMailserver_Install
{
    /// <summary>
    /// License agreement UI.
    /// </summary>
    public class frm_LicenseAgreement : Form, IValidateInstallUI
    {
        private frm_Main    m_pMain   = null;
        private RichTextBox m_pText   = null;
        private CheckBox    m_pAgree  = null;
        private GroupBox    m_pLine   = null;
        private Button      m_pBack   = null;
        private Button      m_pNext   = null;
        private Button      m_pCancel = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="main">Main install UI form.</param>
        public frm_LicenseAgreement(frm_Main main)
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

            m_pText = new RichTextBox();
            m_pText.Location = new Point(11,72);
            m_pText.Size = new Size(484,154);
            m_pText.ReadOnly = true;

            m_pAgree = new CheckBox();
            m_pAgree.Location = new Point(21,241);
            m_pAgree.Size = new Size(100,17);
            m_pAgree.Text = "I agree";
            m_pAgree.CheckedChanged += new EventHandler(m_pAgree_CheckedChanged);

            m_pLine = new GroupBox();
            m_pLine.Location = new Point(2,282);
            m_pLine.Size = new Size(506,3);

            m_pBack = new Button();
            m_pBack.Location = new Point(214,298);
            m_pBack.Size = new Size(87,23);
            m_pBack.Enabled = false;
            m_pBack.Text = "Back";
            m_pBack.Click += new EventHandler(m_pBack_Click);

            m_pNext = new Button();
            m_pNext.Location = new Point(307,298);
            m_pNext.Size = new Size(92,23);
            m_pNext.Enabled = false;
            m_pNext.Text = "Next";
            m_pNext.Click += new EventHandler(m_pNext_Click);

            m_pCancel = new Button();
            m_pCancel.Location = new Point(411,298);
            m_pCancel.Size = new Size(87,23);
            m_pCancel.Text = "Cancel";
            m_pCancel.Click += new EventHandler(m_pCancel_Click);

            this.Controls.Add(m_pText);
            this.Controls.Add(m_pAgree);
            this.Controls.Add(m_pLine);
            this.Controls.Add(m_pBack);
            this.Controls.Add(m_pNext);
            this.Controls.Add(m_pCancel);
        }
                
        #endregion


        #region Events handling

        private void m_pAgree_CheckedChanged(object sender,EventArgs e)
        {
            m_pNext.Enabled = m_pAgree.Checked;
        }


        #region method m_pBack_Click

        private void m_pBack_Click(object sender,EventArgs e)
        {
            m_pMain.Back();
        }

        #endregion

        #region method m_pNext_Click

        private void m_pNext_Click(object sender,EventArgs e)
        {
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
