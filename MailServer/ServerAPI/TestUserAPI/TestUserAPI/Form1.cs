using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

using LumiSoft.MailServer.API.UserAPI;
using LumiSoft.Net.IMAP;
using LumiSoft.Net.IMAP.Server;

namespace TestUserAPI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try{
                using(Server lsMailServer = new Server()){
                    lsMailServer.Connect("localhost","Administrator","");

                    //lsMailServer.VirtualServers[0].Backup("c:\\backup.bck");
                    
                    //Console.WriteLine(lsMailServer.VirtualServers[0].SystemSettings.Relay.SmartHost);

                    
                    // Loop all virtual servers
                    foreach(VirtualServer virtualServer in lsMailServer.VirtualServers){
                        Console.WriteLine(virtualServer.Name + " : " + virtualServer.VirtualServerID);        
                    }

                    /*
                    // Loop first virtual server all domains
                    foreach(Domain domain in lsMailServer.VirtualServers[0].Domains){
                        Console.WriteLine("DomainName: " + domain.DomainName);
                    } */

                    /*
                    // Loop first virtual server all users
                    foreach(User user in lsMailServer.VirtualServers[0].Users){
                        Console.WriteLine("Login Name: " + user.UserName);
                    } */
                   
                    /*
                    // Loop first virtual server all groups
                    foreach(Group group in lsMailServer.VirtualServers[0].Groups){
                        Console.WriteLine("GroupName: " + group.GroupName);
                    } */

                    /*
                    // Add new group to first virtual server
                    Group gX = lsMailServer.VirtualServers[0].Groups.Add("new group","this is added from user api",false);
                    System.Threading.Thread.Sleep(15000);
                    // Delete specified group after 15 sec
                    lsMailServer.VirtualServers[0].Groups.Remove(gX);
                    */

                    // Add new member to first virtual server group
                    //lsMailServer.VirtualServers[0].Groups[0].Members.Add("xxx");

                    // Delete member
                    //lsMailServer.VirtualServers[0].Groups[0].Members.Remove("xxx
                                        
                    /*
                    // Update first virtual server first group description
                    lsMailServer.VirtualServers[0].Groups[0].Description = "some group";
                    lsMailServer.VirtualServers[0].Groups[0].Commit();
                    */
                                        
                    /*
                    // Loop first virtual server first user email addresses
                    foreach(string email in lsMailServer.VirtualServers[0].Users[0].EmailAddresses){
                        Console.WriteLine("Email: " + email);
                    }*/

                    /*
                    // Loop first virtual server first group members
                    foreach(string member in lsMailServer.VirtualServers[0].Groups[0].Members){
                        Console.WriteLine("Member: " + member);
                    }*/

                    /*
                    // Loop first virtual server first user root folders (no childs)
                    foreach(UserFolder folder in lsMailServer.VirtualServers[0].Users[0].Folders){
                        Console.WriteLine("FolderName: " + folder.FolderName + " childs: " + folder.ChildFolders.Count);
                    }*/
                    

                    //lsMailServer.VirtualServers[0].Users[1].Description = "test User api set description";
                    //lsMailServer.VirtualServers[0].Users[1].Commit();

                    //lsMailServer.VirtualServers[0].Users.Add("testXXX","full name","pwd","description",10,true,false);
                    //lsMailServer.VirtualServers[0].Users.Remove(lsMailServer.VirtualServers[0].Users[6]);

                    //lsMailServer.VirtualServers[0].Users[0].EmailAddresses.Remove("qwq@test.lumisoft.ee");
                    //lsMailServer.VirtualServers[0].Users[3].RemoteServers.Add("new rem serv","ivx",110,false,"user","pwd",false);
                    //lsMailServer.VirtualServers[0].Users[3].RemoteServers.Remove(lsMailServer.VirtualServers[0].Users[3].RemoteServers[1]);
                    //lsMailServer.VirtualServers[0].Users[3].RemoteServers[0].Description = "Test desc";
                    //lsMailServer.VirtualServers[0].Users[3].RemoteServers[0].Commit();
                    //MessageBox.Show(lsMailServer.VirtualServers[0].Users[3].RemoteServers[0].Description);

                    //lsMailServer.VirtualServers[0].Users[0].Folders.Add("test api folder");
                    //MessageBox.Show(lsMailServer.VirtualServers[0].Users[0].Folders["test api folder"].FolderPath);
                    //lsMailServer.VirtualServers[0].Users[0].Folders["test api folder"].ChildFolders.Remove(lsMailServer.VirtualServers[0].Users[0].Folders["test api folder"].ChildFolders[0]);
                    //lsMailServer.VirtualServers[0].Users[0].Folders[0].ACL.Add("anyone",IMAP_ACL_Flags.All);
                    //lsMailServer.VirtualServers[0].Users[0].Folders[0].ACL.Remove(lsMailServer.VirtualServers[0].Users[0].Folders[0].ACL[0]);

                    /*
                    // Loop first virtual server first user root folders ACLd
                    foreach(UserFolder folder in lsMailServer.VirtualServers[0].Users[0].Folders){
                        string t = "Folder: " + folder.FolderName;
                        foreach(UserFolderAcl acl in folder.ACL){
                            t += "\r\n\tUser or Group: '" + acl.UserOrGroup + "' permissions: " + IMAP_Utils.ACL_to_String(acl.Permissions);
                        }
                        Console.WriteLine(t);
                    }
                    */

                    //lsMailServer.VirtualServers[0].MailingLists.Add("testML@test.lumisoft.ee","descr",true);
                    //lsMailServer.VirtualServers[0].MailingLists.Remove(lsMailServer.VirtualServers[0].MailingLists[4]);

                    /*
                    // Loop first virtual server all mailing lists
                    foreach(MailingList mailingList in lsMailServer.VirtualServers[0].MailingLists){
                        string t = "Mailing list Name: " + mailingList.Name;
                        t += "\r\n\tMembers: -----------------------";
                        foreach(string member in mailingList.Members){
                            t += "\r\n\tMember: '" + member;
                        }
                        t += "\r\n\tACL: -----------------------";
                        foreach(string acl in mailingList.ACL){
                            t += "\r\n\tUserOrGroup: '" + acl;
                        }
                        Console.WriteLine(t);
                    }*/

                    /*
                    // Update first virtual server first mailing list description
                    lsMailServer.VirtualServers[0].MailingLists[0].Description = "xxx list";
                    lsMailServer.VirtualServers[0].MailingLists[0].Commit();
                    */

                    // Add new member to first virtual server mailing list
                    //lsMailServer.VirtualServers[0].MailingLists[0].Members.Add("ivx@lumisoft.ee");
                    //lsMailServer.VirtualServers[0].MailingLists[0].Members.Remove("ivx@lumisoft.ee");
                    //lsMailServer.VirtualServers[0].MailingLists[0].ACL.Add("xxx");
                    //lsMailServer.VirtualServers[0].MailingLists[0].ACL.Remove("xxx");

                    /*
                    // Loop first virtual server first user email addresses
                    foreach(UserRemoteServer remoteServer in lsMailServer.VirtualServers[0].Users[3].RemoteServers){
                        Console.WriteLine("Server: " + remoteServer.Host);
                    }*/


                    /*
                    foreach(GlobalMessageRule gRule in lsMailServer.VirtualServers[0].GlobalMessageRules){
                        Console.WriteLine(gRule.Description);
                    }*/

                    //lsMailServer.VirtualServers[0].GlobalMessageRules[11].Description = "new descr";
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[11].Commit();
                    //lsMailServer.VirtualServers[0].GlobalMessageRules.Remove(lsMailServer.VirtualServers[0].GlobalMessageRules[11]);
                    //Console.WriteLine(lsMailServer.VirtualServers[0].GlobalMessageRules[11].Description);
                    //lsMailServer.VirtualServers[0].GlobalMessageRules.Add(true,"desc","sys.date = \"01.01.2006\"",GlobalMessageRule_CheckNextRule_enum.IfMatches);
                    //Console.WriteLine(lsMailServer.VirtualServers[0].GlobalMessageRules[0].CheckNextRule);
                    //Console.WriteLine(((GlobalMessageRuleAction_DeleteMessage)lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions[0]).Description);
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions[0].Description = "test action update";
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions[0].Commit();
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_AddHeaderField("desc","to:","test");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_AutoResponse("A resp test","aa@from.ee",new byte[0]);
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_DeleteMessage("d m test");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_ExecuteProgram("xxx desr","w.exe","-d");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_ForwardToEmail("desrc","aaa@ee.ee");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_ForwardToHost("descr","mail.ee",1025);
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_MoveToImapFolder("descr","spam");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_PostToHttp("desc","http://www.ee");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_PostToNntp("desc","server",10119,"test");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_RemoveHeaderField("descr","to:");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_StoreToDisk("desc","c:\\");
                    //lsMailServer.VirtualServers[0].GlobalMessageRules[0].Actions.Add_StoreToFtp("desc","host",1021,"user","pass","folder");


                    //lsMailServer.VirtualServers[0].RootFolders.Add(false,"xxxTestXX","desc",SharedFolderRootType_enum.UsersSharedFolder,"","");
                    //lsMailServer.VirtualServers[0].RootFolders.Remove(lsMailServer.VirtualServers[0].RootFolders[3]);
                    //lsMailServer.VirtualServers[0].RootFolders[3].Description = "new description";
                    //lsMailServer.VirtualServers[0].RootFolders[3].Commit();
                    
                    /*
                    foreach(SharedRootFolder rootFolder in lsMailServer.VirtualServers[0].RootFolders){
                        Console.WriteLine(rootFolder.Name);
                    }*/

                    /*
                    foreach(Filter filter in lsMailServer.VirtualServers[0].Filters){
                        Console.WriteLine(filter.Description);
                    }*/

                }
            }
            catch(Exception x){
                MessageBox.Show(x.Message + x.StackTrace);
            }
        }
    }
}