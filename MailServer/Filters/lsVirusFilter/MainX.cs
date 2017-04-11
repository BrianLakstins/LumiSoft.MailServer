using System;
using System.Windows.Forms;

namespace LumiSoft.MailServer.Filters
{
	/// <summary>
	/// Application main class.
	/// </summary>
	public class MainX
	{
		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new wfrm_Main());
		}
	}
}
