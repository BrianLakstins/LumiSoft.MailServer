using System;
using System.IO;
using System.Collections;
using System.Configuration.Install;
using System.Reflection;
using System.ServiceProcess;

using LumiSoft.MailServer;
using LumiSoft.MailServer.UI;

namespace LumiSoft.MailServer
{
	/// <summary>
	/// Application main class.
	/// </summary>
	public class MainX
	{
		#region static method Main

		/// <summary>
		/// Application main entry point.
		/// </summary>
		/// <param name="args">Command line argumnets.</param>
		public static void Main(string[] args)
		{
            try{
                if(args.Length > 0 && args[0].ToLower() == "-install"){
                    ManagedInstallerClass.InstallHelper(new string[]{"MailServerService.exe"});

                    ServiceController c = new ServiceController("LumiSoft Mail Server");                
                    c.Start();
                }
                else if(args.Length > 0 && args[0].ToLower() == "-uninstall"){
                    ManagedInstallerClass.InstallHelper(new string[]{"/u","MailServerService.exe"});
                }
                else{                
                    System.ServiceProcess.ServiceBase[] servicesToRun = new System.ServiceProcess.ServiceBase[]{new MailServer_Service()};
			        System.ServiceProcess.ServiceBase.Run(servicesToRun);
                }
            }
            catch(Exception x){
                System.Windows.Forms.MessageBox.Show("Error: " + x.ToString(),"Error:",System.Windows.Forms.MessageBoxButtons.OK,System.Windows.Forms.MessageBoxIcon.Error);
            }
		}

		#endregion
	}
}
