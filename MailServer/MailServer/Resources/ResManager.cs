using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Reflection;

namespace LumiSoft.MailServer.Resources
{
    /// <summary>
    /// Resource manager.
    /// </summary>
    public class ResManager
    {
        /*
        public string[] GetResourceIDs()
        {
            return null;
        }
        */

        #region method GetIcon

        /// <summary>
        /// Gets specified icon.
        /// </summary>
        /// <param name="iconName">Icon name.</param>
        /// <returns></returns>
        public static Icon GetIcon(string iconName)
        {
            Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream("LumiSoft.MailServer.Resources." + iconName);
            return new Icon(rs);
        }

        #endregion

        #region method GetImage

        /// <summary>
        /// Gets specified image.
        /// </summary>
        /// <param name="imageName">Image name.</param>
        /// <returns></returns>
        public static Image GetImage(string imageName)
        {
            Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream("LumiSoft.MailServer.Resources." + imageName);
            return Image.FromStream(rs);
        }

        #endregion
    }
}
