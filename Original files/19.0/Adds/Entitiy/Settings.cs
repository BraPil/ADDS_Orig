using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Adds
{
    public class Settings
    {
        #region Private Variables
        private string _PrimaryRoot = null;
        private string _SecondaryRoot = null;
        private string _AltPrimaryRoot = null;
        private string _AltSecondaryRoot = null;
        private string _TestPrimaryRoot = null;
        private string _TestSecondaryRoot = null;
        #endregion

        #region Public Attributes
        public string PrimaryRoot { get { return _PrimaryRoot; } set { _PrimaryRoot = value; } }
        public string SecondaryRoot { get { return _SecondaryRoot; } set { _SecondaryRoot = value; } }
        public string AltPrimaryRoot { get { return _AltPrimaryRoot; } set { _AltPrimaryRoot = value; } }
        public string AltSecondaryRoot { get { return _AltSecondaryRoot; } set { _AltSecondaryRoot = value; } }
        public string TestPrimaryRoot { get { return _TestPrimaryRoot; } set { _TestPrimaryRoot = value; } }
        public string TestSecondaryRoot { get { return _TestSecondaryRoot; } set { _TestSecondaryRoot = value; } }

        #endregion
    }

}
