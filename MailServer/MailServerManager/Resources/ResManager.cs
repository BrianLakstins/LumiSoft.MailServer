using System;
using System.IO;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Windows.Forms;
using System.Reflection;

namespace LumiSoft.MailServer.UI.Resources
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
        /// <returns>Returns specified icon.</returns>
        public static Icon GetIcon(string iconName)
        {
            return GetIcon(iconName,new Size(32,32));
        }

        /// <summary>
        /// Gets specified icon.
        /// </summary>
        /// <param name="iconName">Icon name.</param>
        /// <param name="size">Icon size.</param>
        /// <returns>Returns specified icon.</returns>
        public static Icon GetIcon(string iconName,Size size)
        {
            Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream(typeof(ResManager).Namespace + "." + iconName);
            return new Icon(rs,size);
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
            Stream rs = Assembly.GetExecutingAssembly().GetManifestResourceStream(typeof(ResManager).Namespace + "." + imageName);
            return Image.FromStream(rs);
        }

        #endregion
    }
}
