using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Reflection;

namespace LumiSoft.MailServer
{
    /// <summary>
    /// Resource manager.
    /// </summary>
    internal class ResManager
    {
        #region static method GetText

        /// <summary>
        /// Gets stored resource as text.
        /// </summary>
        /// <returns></returns>
        public static string GetText(string fileName,System.Text.Encoding encoding)
        {
            Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream("LumiSoft.MailServer.API.Resources." + fileName);
            byte[] text = new byte[rs.Length];
            rs.Read(text,0,text.Length);
            return encoding.GetString(text);
        }

        #endregion
    }
}
