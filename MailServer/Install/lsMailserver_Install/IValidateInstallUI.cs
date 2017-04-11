using System;
using System.Collections.Generic;
using System.Text;

namespace lsMailserver_Install
{
    /// <summary>
    ///This interface is used to validate insatll UI (License Agreement,Installation location,...).
    /// </summary>
    public interface IValidateInstallUI
    {
        /// <summary>
        /// Gets is install UI has vaild values.
        /// </summary>
        /// <returns>Returns true if install UI has vlaid values.</returns>
        bool IsValid();
    }
}
