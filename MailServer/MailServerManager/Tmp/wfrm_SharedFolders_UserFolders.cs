using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;

using LumiSoft.MailServer.API.UserAPI;
using LumiSoft.UI.Controls;
using LumiSoft.MailServer.UI.Resources;

namespace LumiSoft.MailServer.UI
{
    /// <summary>
    /// Users shared folders window.
    /// </summary>
    public class wfrm_SharedFolders_UserFolders : Form
    {
        private ToolStrip m_pToolbar       = null;
        private Label     mt_User          = null;
        private TextBox   m_pUser          = null;
        private Button    m_pGetUser       = null;
        private ImageList m_pFoldersImages = null;
        private TreeView  m_pFolders       = null;

        private VirtualServer m_pVirtualServer = null;

        /// <summary>
        /// Default constructor.
        /// </summary>
        /// <param name="virtualServer">Virtual server.</param>
        /// <param name="frame"></param>
        public wfrm_SharedFolders_UserFolders(VirtualServer virtualServer,WFrame frame)
        {   
            m_pVirtualServer = virtualServer;
        
            InitUI();

            // Move toolbar to Frame
            frame.Frame_ToolStrip = m_pToolbar;
        }

        #region method InitUI

        /// <summary>
        /// Creates and initializes window UI.
        /// </summary>
        private void InitUI()
        {
            this.Size = new Size(300,300);

            ImageList toobarImageList = new ImageList();
            toobarImageList.Images.Add(ResManager.GetIcon("add.ico"));
            toobarImageList.Images.Add(ResManager.GetIcon("edit.ico"));
            toobarImageList.Images.Add(ResManager.GetIcon("delete.ico"));
            toobarImageList.Images.Add(ResManager.GetIcon("properties.ico"));

            m_pToolbar = new WToolBar();
            m_pToolbar.Appearance = ToolBarAppearance.Flat;
            m_pToolbar.Divider = false;
            m_pToolbar.ImageList = toobarImageList;
            m_pToolbar.ButtonClick += new ToolBarButtonClickEventHandler(m_pToolbar_ButtonClick);
            ToolBarButton button_Add = new ToolBarButton();
            button_Add.Enabled  = false;
            button_Add.ImageIndex = 0;
            button_Add.Tag = "add";
            m_pToolbar.Buttons.Add(button_Add);
            ToolBarButton button_Edit = new ToolBarButton();
            button_Edit.Enabled = false;
            button_Edit.ImageIndex = 1;
            button_Edit.Tag = "edit";
            m_pToolbar.Buttons.Add(button_Edit);
            ToolBarButton button_Delete = new ToolBarButton();
            button_Delete.Enabled = false;
            button_Delete.ImageIndex = 2;
            button_Delete.Tag = "delete";
            m_pToolbar.Buttons.Add(button_Delete);
            ToolBarButton button_separator = new ToolBarButton();
            button_separator.Style = ToolBarButtonStyle.Separator;
            m_pToolbar.Buttons.Add(button_separator);
            ToolBarButton button_Properties = new ToolBarButton();
            button_Properties.Enabled = false;
            button_Properties.ImageIndex = 3;
            button_Properties.Tag = "properties";
            m_pToolbar.Buttons.Add(button_Properties);

            mt_User = new Label();
            mt_User.Size = new Size(100,20);
            mt_User.Location = new Point(9,20);
            mt_User.TextAlign = ContentAlignment.MiddleRight;
            mt_User.Text = "User:";
  
            m_pUser = new TextBox();
            m_pUser.Size = new Size(150,20);
            m_pUser.Location = new Point(115,20);
            m_pUser.ReadOnly = true;
        
            m_pGetUser = new Button();
            m_pGetUser.Size = new Size(70,20);
            m_pGetUser.Location = new Point(280,20);
            m_pGetUser.Text = "Get";            
            m_pGetUser.Click += new EventHandler(m_pGetUser_Click);

            m_pFoldersImages = new ImageList();
            m_pFoldersImages.Images.Add(ResManager.GetIcon("folder.ico"));

            m_pFolders = new TreeView();
            m_pFolders.Size = new Size(270,200);
            m_pFolders.Location = new Point(10,50);
            m_pFolders.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right | AnchorStyles.Top;
            m_pFolders.HideSelection = false;
            m_pFolders.FullRowSelect = true;
            m_pFolders.PathSeparator = "/";
            m_pFolders.ImageList = m_pFoldersImages;
            m_pFolders.AfterSelect += new TreeViewEventHandler(m_pFolders_AfterSelect);
        //  m_pFolders.DoubleClick += new EventHandler(m_pFolders_DoubleClick);

            this.Controls.Add(mt_User);
            this.Controls.Add(m_pUser);
            this.Controls.Add(m_pGetUser);
            this.Controls.Add(m_pFolders);
        }
                                                                                
        #endregion


        #region Events Handling

        #region method m_pToolbar_ButtonClick

        private void m_pToolbar_ButtonClick(object sender,ToolBarButtonClickEventArgs e)
        {
            if(e.Button.Tag.ToString() == "add"){
                if(m_pFolders.SelectedNode == null){
                    wfrm_sys_Folder frm = new wfrm_sys_Folder(true,"",false);
                    if(frm.ShowDialog(this) == DialogResult.OK){
                        m_pVirtualServer.Users.GetUserByName(m_pUser.Text).Folders.Add(frm.Folder);
                        LoadFolders(frm.Folder);
                    }
                }
                else{
                    wfrm_sys_Folder frm = new wfrm_sys_Folder(true,"",false);
                    if(frm.ShowDialog(this) == DialogResult.OK){
                        UserFolder folder = (UserFolder)m_pFolders.SelectedNode.Tag;
                        folder.ChildFolders.Add(frm.Folder);
                        LoadFolders(frm.Folder);
                    }
                }
            }
            else if(e.Button.Tag.ToString() == "edit" && m_pFolders.SelectedNode != null){
                wfrm_sys_Folder frm = new wfrm_sys_Folder(false,m_pFolders.SelectedNode.FullPath,true);
                if(frm.ShowDialog(this) == DialogResult.OK && m_pFolders.SelectedNode.FullPath != frm.Folder){
                    UserFolder folder = (UserFolder)m_pFolders.SelectedNode.Tag;
                    folder.Rename(frm.Folder);
                    LoadFolders(frm.Folder);
                }
            }
            else if(e.Button.Tag.ToString() == "delete" && m_pFolders.SelectedNode != null){
                UserFolder folder = (UserFolder)m_pFolders.SelectedNode.Tag;
                if(MessageBox.Show(this,"Are you sure you want to delete Folder '" + folder.FolderFullPath + "' ?","Confirm delete",MessageBoxButtons.YesNo,MessageBoxIcon.Question) == DialogResult.Yes){
                    folder.Owner.Remove(folder);
                    LoadFolders("");
                }
            }
            else if(e.Button.Tag.ToString() == "properties" && m_pFolders.SelectedNode != null){
                UserFolder folder = (UserFolder)m_pFolders.SelectedNode.Tag;
                wfrm_User_FolderProperties frm = new wfrm_User_FolderProperties(m_pVirtualServer,folder);
                frm.ShowDialog(this);             
            }
        }

        #endregion


        #region method m_pGetUser_Click

        private void m_pGetUser_Click(object sender, EventArgs e)
        {
            wfrm_se_UserOrGroup frm = new wfrm_se_UserOrGroup(m_pVirtualServer,false,false);
            if(frm.ShowDialog(this) == DialogResult.OK){
                m_pToolbar.Buttons[0].Enabled = true;
                m_pUser.Text = frm.SelectedUserOrGroup;

                LoadFolders("");
            }
        }

        #endregion

        #region method m_pFolders_AfterSelect

        private void m_pFolders_AfterSelect(object sender,TreeViewEventArgs e)
        {
            if(e.Node != null){
                m_pToolbar.Buttons[1].Enabled = true;
                m_pToolbar.Buttons[2].Enabled = true;
                m_pToolbar.Buttons[4].Enabled = true;
            }
            else{
                m_pToolbar.Buttons[1].Enabled = false;
                m_pToolbar.Buttons[2].Enabled = false;
                m_pToolbar.Buttons[4].Enabled = false;
            }
        }

        #endregion

        #endregion


        #region method LoadFolders

        /// <summary>
        /// Load user folder to UI.
        /// </summary>
        /// <param name="selectedFolder">Selects specified folder, it it exists.</param>
        private void LoadFolders(string selectedFolder)
        {
            m_pFolders.Nodes.Clear();
                        
            Queue<object> folders = new Queue<object>();
            foreach(UserFolder folder in m_pVirtualServer.Users.GetUserByName(m_pUser.Text).Folders){                
                TreeNode n = new TreeNode(folder.FolderName);
                n.ImageIndex = 0;
                n.Tag = folder;
                m_pFolders.Nodes.Add(n);

                folders.Enqueue(new object[]{folder,n});
            }

            while(folders.Count > 0){
                object[]   param  = (object[])folders.Dequeue();
                UserFolder folder = (UserFolder)param[0];
                TreeNode   node   = (TreeNode)param[1];
                foreach(UserFolder childFolder in folder.ChildFolders){                                        
                    TreeNode n = new TreeNode(childFolder.FolderName);
                    n.ImageIndex = 0;
                    n.Tag = childFolder;
                    node.Nodes.Add(n);

                    folders.Enqueue(new object[]{childFolder,n});
                }                
            }

            m_pFolders_AfterSelect(this,new TreeViewEventArgs(m_pFolders.SelectedNode));
        }

        #endregion

    }
}
