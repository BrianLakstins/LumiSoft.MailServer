using System;
using System.IO;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.ServiceProcess;
using System.Threading;
using System.Reflection;

namespace LumiSoft.MailServer
{
	/// <summary>
	/// Mail server windows service.
	/// </summary>
	public class MailServer_Service : System.ServiceProcess.ServiceBase
	{
        private Server m_pServer = null;

        /// <summary>
		/// Default constructor.
		/// </summary>
		public MailServer_Service()
		{
			m_pServer = new Server();

            this.ServiceName = "LumiSoft Mail Server";
		}


		#region method OnStart
                
		/// <summary>
		/// Is called by OS when service must be started.
		/// </summary>
		/// <param name="args">Command line arguments.</param>
		protected override void OnStart(string[] args)
		{						
			m_pServer.Start();				
		}

		#endregion

		#region method OnStop
 		
		/// <summary>
		/// Is called by OS when service must be stopped.
		/// </summary>
		protected override void OnStop()
		{			
			m_pServer.Stop();
		}

		#endregion
			
	}
}
