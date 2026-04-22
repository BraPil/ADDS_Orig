using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Adds
{
    public class SymbolInformation
    {
        #region Private Variables

        private string _BlockName = null;
        private string _Description = null;
        private string _Class = null;
        private string _Function = null;
        private string _LayerType = null;

        private int _EMB_Symbol_Number;

        private double _SymbolSize;
        private double _AttributeSize;
        private double _GapSize;
        private string _GapType = null;

        #endregion Private Variables


        #region Public Attributes

        public string BlockName
        {
            get { return _BlockName; }
            set { _BlockName = value; }
        }
        public string Description
        {
            get { return _Description; }
            set { _Description = value; }
        }
        public string Class
        {
            get { return _Class; }
            set { _Class = value; }
        }
        public string Function
        {
            get { return _Function; }
            set { _Function = value; }
        }
        public string LayerType
        {
            get { return _LayerType; }
            set { _LayerType = value; }
        }

        public int EMBSymbolNumber
        {
            get { return _EMB_Symbol_Number; }
            set { _EMB_Symbol_Number = value; }
        }

        public double SymbolSize
        {
            get { return _SymbolSize; }
            set { _SymbolSize = value; }
        }
        public double AttributeSize
        {
            get { return _AttributeSize; }
            set { _AttributeSize = value; }
        }
        public double GapSize
        {
            get { return _GapSize; }
            set { _GapSize = value; }
        }
        public string GapType
        {
            get { return _GapType; }
            set { _GapType = value; }
        }
        #endregion Public Attributes
    }
}
