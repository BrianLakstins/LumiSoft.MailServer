using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;

namespace lsMailserver_Install
{
    public class MainX
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        public static void Main()
        {
            Application.Run(new frm_Main());
        }
    }
}
