using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

namespace LumiSoft.MailServer.UI
{
    /// <summary>
    /// Text edit window.
    /// </summary>
    public class wfrm_EditText : Form
    {
        private TextBox  m_pTextbox   = null;
        private GroupBox m_pGroupbox1 = null;
        private Button   m_pCancel    = null;
        private Button   m_pOk        = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        public wfrm_EditText()
        {
            InitUI();
        }

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="editText">Text to edit.</param>
        public wfrm_EditText(string editText)
        {
            InitUI();
            
            m_pTextbox.Text = editText;
            m_pTextbox.SelectionStart = 0;
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes window UI.
        /// </summary>
        private void InitUI()
        {
            this.ClientSize = new Size(492,373);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Text = "Edit text";

            m_pTextbox = new TextBox();
            m_pTextbox.Size = new Size(488,320);
            m_pTextbox.Location = new Point(2,2);
            m_pTextbox.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top;
            m_pTextbox.Multiline = true;

            m_pGroupbox1 = new GroupBox();
            m_pGroupbox1.Size = new Size(490,3);
            m_pGroupbox1.Location = new Point(5,330);
            m_pGroupbox1.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;

            m_pCancel = new Button();
            m_pCancel.Size = new Size(70,20);
            m_pCancel.Location = new Point(325,345);
            m_pCancel.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            m_pCancel.Text = "Cancel";
            m_pCancel.Click += new EventHandler(m_pCancel_Click);

            m_pOk = new Button();
            m_pOk.Size = new Size(70,20);
            m_pOk.Location = new Point(400,345);
            m_pOk.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            m_pOk.Text = "Ok";
            m_pOk.Click += new EventHandler(m_pOk_Click);

            this.Controls.Add(m_pTextbox);
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
            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        #endregion

        #endregion


        #region Properties Implementation

        /// <summary>
        /// Gets or sets edit text.
        /// </summary>
        public string EditText
        {
            get{ return m_pTextbox.Text; }

            set{ m_pTextbox.Text = value; }
        }

        #endregion

    }
}
