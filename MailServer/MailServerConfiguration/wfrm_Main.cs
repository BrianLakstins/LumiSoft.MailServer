using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Data;

namespace Mail_Server_Configuration
{
    /// <summary>
    /// Application main window.
    /// </summary>
    public class wfrm_Main : Form
    {
        //--- Common UI --------------------
        private TabControl m_pTab    = null;
        private Button     m_pCancel = null;
        private Button     m_pOk     = null;
        //--- Tab page IP Access UI ------------------
        private ListView m_pTab_IPAccess_List   = null;
        private Button   m_pTab_IPAccess_Add    = null;
        private Button   m_pTab_IPAccess_Edit   = null;
        private Button   m_pTab_IPAccess_Delete = null;
        //--- Tab page Users UI --------------------
        private ListView m_pTab_Users_List   = null;
        private Button   m_pTab_Users_Add    = null;
        private Button   m_pTab_Users_Edit   = null;
        private Button   m_pTab_Users_Delete = null;

        private DataSet m_pDsSettings = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        public wfrm_Main()
        {
            InitUI();

            LoadSettings();
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes window UI.
        /// </summary>
        private void InitUI()
        {
            //--- Common UI ------------------------------------------------//
            this.ClientSize = new Size(400,275);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Text = "LS Mail Server Administration Access Configurator:";

            m_pTab = new TabControl();
            m_pTab.Size = new Size(392,230);
            m_pTab.Location = new Point(5,5);
            m_pTab.TabPages.Add(new TabPage("IP Access"));
            m_pTab.TabPages.Add(new TabPage("Users"));

            m_pCancel = new Button();
            m_pCancel.Size = new Size(70,20);
            m_pCancel.Location = new Point(245,245);
            m_pCancel.Text = "Cancel";
            m_pCancel.Click += new EventHandler(m_pCancel_Click);

            m_pOk = new Button();
            m_pOk.Size = new Size(70,20);
            m_pOk.Location = new Point(320,245);
            m_pOk.Text = "Ok";
            m_pOk.Click += new EventHandler(m_pOk_Click);

            this.Controls.Add(m_pTab);
            this.Controls.Add(m_pCancel);
            this.Controls.Add(m_pOk);
            //-------------------------------------------------------------//
            
            //--- Tab page IP Access UI -----------------------------------//
            m_pTab_IPAccess_List = new ListView();
            m_pTab_IPAccess_List.Size = new Size(300,150);
            m_pTab_IPAccess_List.Location = new Point(5,30);
            m_pTab_IPAccess_List.View = View.Details;
            m_pTab_IPAccess_List.HideSelection = false;
            m_pTab_IPAccess_List.FullRowSelect = true;
            m_pTab_IPAccess_List.SelectedIndexChanged += new EventHandler(m_pTab_IPAccess_List_SelectedIndexChanged);
            m_pTab_IPAccess_List.Columns.Add("Start IP",145,HorizontalAlignment.Center);
            m_pTab_IPAccess_List.Columns.Add("End IP",145,HorizontalAlignment.Center);

            m_pTab_IPAccess_Add = new Button();
            m_pTab_IPAccess_Add.Size = new Size(70,20);
            m_pTab_IPAccess_Add.Location = new Point(310,30);
            m_pTab_IPAccess_Add.Text = "Add";
            m_pTab_IPAccess_Add.Click += new EventHandler(m_pTab_IPAccess_Add_Click);

            m_pTab_IPAccess_Edit = new Button();
            m_pTab_IPAccess_Edit.Size = new Size(70,20);
            m_pTab_IPAccess_Edit.Location = new Point(310,55);
            m_pTab_IPAccess_Edit.Text = "Edit";
            m_pTab_IPAccess_Edit.Click += new EventHandler(m_pTab_IPAccess_Edit_Click);

            m_pTab_IPAccess_Delete = new Button();
            m_pTab_IPAccess_Delete.Size = new Size(70,20);
            m_pTab_IPAccess_Delete.Location = new Point(310,80);
            m_pTab_IPAccess_Delete.Text = "Delete";
            m_pTab_IPAccess_Delete.Click += new EventHandler(m_pTab_IPAccess_Delete_Click);

            m_pTab.TabPages[0].Controls.Add(m_pTab_IPAccess_List);
            m_pTab.TabPages[0].Controls.Add(m_pTab_IPAccess_Add);
            m_pTab.TabPages[0].Controls.Add(m_pTab_IPAccess_Edit);
            m_pTab.TabPages[0].Controls.Add(m_pTab_IPAccess_Delete);
            //-------------------------------------------------------------//

            //--- Tab page Users UI ---------------------------------------//
            m_pTab_Users_List = new ListView();
            m_pTab_Users_List.Size = new Size(300,150);
            m_pTab_Users_List.Location = new Point(5,30);
            m_pTab_Users_List.View = View.Details;
            m_pTab_Users_List.HideSelection = false;
            m_pTab_Users_List.FullRowSelect = true;
            m_pTab_Users_List.SelectedIndexChanged += new EventHandler(m_pTab_Users_List_SelectedIndexChanged);
            m_pTab_Users_List.Columns.Add("User Name",250,HorizontalAlignment.Center);

            m_pTab_Users_Add = new Button();
            m_pTab_Users_Add.Size = new Size(70,20);
            m_pTab_Users_Add.Location = new Point(310,30);
            m_pTab_Users_Add.Text = "Add";
            m_pTab_Users_Add.Click += new EventHandler(m_pTab_Users_Add_Click);

            m_pTab_Users_Edit = new Button();
            m_pTab_Users_Edit.Size = new Size(70,20);
            m_pTab_Users_Edit.Location = new Point(310,55);
            m_pTab_Users_Edit.Text = "Edit";
            m_pTab_Users_Edit.Click += new EventHandler(m_pTab_Users_Edit_Click);

            m_pTab_Users_Delete = new Button();
            m_pTab_Users_Delete.Size = new Size(70,20);
            m_pTab_Users_Delete.Location = new Point(310,80);
            m_pTab_Users_Delete.Text = "Delete";
            m_pTab_Users_Delete.Click += new EventHandler(m_pTab_Users_Delete_Click);

            m_pTab.TabPages[1].Controls.Add(m_pTab_Users_List);
            m_pTab.TabPages[1].Controls.Add(m_pTab_Users_Add);
            m_pTab.TabPages[1].Controls.Add(m_pTab_Users_Edit);
            m_pTab.TabPages[1].Controls.Add(m_pTab_Users_Delete);
            //-------------------------------------------------------------//
        }
                                                                                                                                                                
        #endregion


        #region Events Handling

        #region method m_pTab_IPAccess_List_SelectedIndexChanged

        private void m_pTab_IPAccess_List_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(m_pTab_IPAccess_List.SelectedItems.Count == 0){
                m_pTab_IPAccess_Edit.Enabled = false;
                m_pTab_IPAccess_Delete.Enabled = false;
            }
            else{
                m_pTab_IPAccess_Edit.Enabled = true;
                m_pTab_IPAccess_Delete.Enabled = true;
            }
        }

        #endregion

        #region method m_pTab_IPAccess_Add_Click

        private void m_pTab_IPAccess_Add_Click(object sender, EventArgs e)
        {
            wfrm_IPAccess frm = new wfrm_IPAccess(m_pDsSettings);
            if(frm.ShowDialog(this) == DialogResult.OK){
                m_pTab_IPAccess_List.Items.Clear();
                foreach(DataRow dr in m_pDsSettings.Tables["IP_Access"].Rows){
                    ListViewItem it = new ListViewItem(dr["StartIP"].ToString());
                    it.SubItems.Add(dr["EndIP"].ToString());
                    it.Tag = dr;
                    m_pTab_IPAccess_List.Items.Add(it);
                }
            }
        }

        #endregion

        #region method m_pTab_IPAccess_Edit_Click

        private void m_pTab_IPAccess_Edit_Click(object sender, EventArgs e)
        {
            if(m_pTab_IPAccess_List.SelectedItems[0].Text.ToLower() == "127.0.0.1" && m_pTab_IPAccess_List.SelectedItems[0].SubItems[0].Text == "127.0.0.1"){
                MessageBox.Show("IP range 127.0.0.1 - 127.0.0.1 is permanent system entry and cannot be modified !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                return;
            }

            wfrm_IPAccess frm = new wfrm_IPAccess(m_pDsSettings,(DataRow)m_pTab_IPAccess_List.SelectedItems[0].Tag);
            if(frm.ShowDialog(this) == DialogResult.OK){
                m_pTab_IPAccess_List.Items.Clear();
                foreach(DataRow dr in m_pDsSettings.Tables["IP_Access"].Rows){
                    ListViewItem it = new ListViewItem(dr["StartIP"].ToString());
                    it.SubItems.Add(dr["EndIP"].ToString());
                    it.Tag = dr;
                    m_pTab_IPAccess_List.Items.Add(it);
                }
            }
        }

        #endregion

        #region method m_pTab_IPAccess_Delete_Click

        private void m_pTab_IPAccess_Delete_Click(object sender, EventArgs e)
        {
            if(m_pTab_IPAccess_List.SelectedItems[0].Text.ToLower() == "127.0.0.1"){
                MessageBox.Show("IP range 127.0.0.1 - 127.0.0.1 is permanent system entry and cannot be deleted !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                return;
            }

            if(MessageBox.Show("Are you sure you want to delete entry '" + m_pTab_IPAccess_List.SelectedItems[0].Text + "' !","Confirm:",MessageBoxButtons.YesNo,MessageBoxIcon.Information) == DialogResult.Yes){
                ((DataRow)m_pTab_IPAccess_List.SelectedItems[0].Tag).Delete();
                m_pTab_IPAccess_List.SelectedItems[0].Remove();
            }
        }

        #endregion


        #region method m_pTab_Users_List_SelectedIndexChanged

        private void m_pTab_Users_List_SelectedIndexChanged(object sender, EventArgs e)
        {
            if(m_pTab_Users_List.SelectedItems.Count == 0){
                m_pTab_Users_Edit.Enabled = false;
                m_pTab_Users_Delete.Enabled = false;
            }
            else{
                m_pTab_Users_Edit.Enabled = true;
                m_pTab_Users_Delete.Enabled = true;
            }
        }

        #endregion

        #region method m_pTab_Users_Add_Click

        private void m_pTab_Users_Add_Click(object sender, EventArgs e)
        {
            wfrm_User frm = new wfrm_User(m_pDsSettings);
            if(frm.ShowDialog(this) == DialogResult.OK){
                m_pTab_Users_List.Items.Clear();
                foreach(DataRow dr in m_pDsSettings.Tables["Users"].Rows){
                    ListViewItem it = new ListViewItem(dr["UserName"].ToString());
                    it.Tag = dr;
                    m_pTab_Users_List.Items.Add(it);
                }
            }
        }

        #endregion

        #region method m_pTab_Users_Edit_Click

        private void m_pTab_Users_Edit_Click(object sender, EventArgs e)
        {
            wfrm_User frm = new wfrm_User(m_pDsSettings,(DataRow)m_pTab_Users_List.SelectedItems[0].Tag);
            if(frm.ShowDialog(this) == DialogResult.OK){
            }
        }

        #endregion

        #region method m_pTab_Users_Delete_Click

        private void m_pTab_Users_Delete_Click(object sender, EventArgs e)
        {
            if(m_pTab_Users_List.SelectedItems[0].Text.ToLower() == "administrator"){
                MessageBox.Show("User Administrator is permanent user and cannot be deleted !","Error:",MessageBoxButtons.OK,MessageBoxIcon.Error);
                return;
            }

            if(MessageBox.Show("Are you sure you want to delete user '" + m_pTab_Users_List.SelectedItems[0].Text + "' !","Confirm:",MessageBoxButtons.YesNo,MessageBoxIcon.Information) == DialogResult.Yes){
                ((DataRow)m_pTab_Users_List.SelectedItems[0].Tag).Delete();
                m_pTab_Users_List.SelectedItems[0].Remove();
            }
        }

        #endregion


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
            if(m_pDsSettings.HasChanges()){
                m_pDsSettings.WriteXml(Application.StartupPath + "/Settings/AdminAccess.xml");
            }

            this.DialogResult = DialogResult.OK;
            this.Close();
        }

        #endregion

        #endregion


        #region method LoadSettings

        /// <summary>
        /// Loads settings from xml to UI.
        /// </summary>
        private void LoadSettings()
        {
            m_pDsSettings = new DataSet();
            m_pDsSettings.Tables.Add("IP_Access");
            m_pDsSettings.Tables["IP_Access"].Columns.Add("StartIP");
            m_pDsSettings.Tables["IP_Access"].Columns.Add("EndIP");
            m_pDsSettings.Tables.Add("Users");
            m_pDsSettings.Tables["Users"].Columns.Add("UserName");
            m_pDsSettings.Tables["Users"].Columns.Add("Password");

            if(File.Exists(Application.StartupPath + "/Settings/AdminAccess.xml")){
                m_pDsSettings.ReadXml(Application.StartupPath + "/Settings/AdminAccess.xml");
            }
            else{
                // There is no access conf file, add default values.

                DataRow dr = m_pDsSettings.Tables["IP_Access"].NewRow();
                dr["StartIP"] = "127.0.0.1";
                dr["EndIP"] = "127.0.0.1";
                m_pDsSettings.Tables["IP_Access"].Rows.Add(dr);

                dr = m_pDsSettings.Tables["Users"].NewRow();
                dr["UserName"] = "Administrator";
                dr["Password"] = "";
                m_pDsSettings.Tables["Users"].Rows.Add(dr);
            }

            foreach(DataRow dr in m_pDsSettings.Tables["IP_Access"].Rows){
                ListViewItem it = new ListViewItem(dr["StartIP"].ToString());
                it.SubItems.Add(dr["EndIP"].ToString());
                it.Tag = dr;
                m_pTab_IPAccess_List.Items.Add(it);
            }

            foreach(DataRow dr in m_pDsSettings.Tables["Users"].Rows){
                ListViewItem it = new ListViewItem(dr["UserName"].ToString());
                it.Tag = dr;
                m_pTab_Users_List.Items.Add(it);
            }

            m_pTab_IPAccess_List_SelectedIndexChanged(this,null);
            m_pTab_Users_List_SelectedIndexChanged(this,null);
        }

        #endregion

    }
}
