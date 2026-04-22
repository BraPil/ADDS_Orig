using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Adds
{
    public class Plot
    {
        #region Private Variables

        private string _PldName = null;
        private string _DivName = null;
        private string _CordFileType = null;
        private string _CordKey = null;
        private int? _Buffer = null;

        private int? _XL = null;
        private int? _YL = null;
        private int? _XU = null;
        private int? _YU = null;
        private string _Sheet = null;

        private int? _PltSc = null;
        private int? _SymSc = null;
        private int? _TxtSc = null;
        private string _VoltageCode = null;
        private string _JobName = null;

        private string _Detail = null;
        private string _DrawingNumber = null;
        private string _MatchToLeft = null;
        private string _MatchToTop = null;
        private string _MatchToRight = null;

        private string _MatchToBottom = null;
        private string _Description = null;

        #endregion Private Variables

        #region Public Attributes

        public string PldName
        {
            get { return _PldName; }
            set { _PldName = value; }
        }
        public string DivName
        {
            get { return _DivName; }
            set { _DivName = value; }
        }
        public string CordFileType
        {
            get { return _CordFileType; }
            set { _CordFileType = value; }
        }
        public string CordKey
        {
            get { return _CordKey; }
            set { _CordKey = value; }
        }
        public int? Buffer
        {
            get { return _Buffer; }
            set { _Buffer = value; }
        }

        public int? XL
        {
            get { return _XL; }
            set { _XL = value; }
        }
        public int? YL
        {
            get { return _YL; }
            set { _YL = value; }
        }
        public int? XU
        {
            get { return _XU; }
            set { _XU = value; }
        }
        public int? YU
        {
            get { return _YU; }
            set { _YU = value; }
        }
        public string Sheet
        {
            get { return _Sheet; }
            set { _Sheet = value; }
        }

        public int? PlotScale
        {
            get { return _PltSc; }
            set { _PltSc = value; }
        }
        public int? SymbolScale
        {
            get { return _SymSc; }
            set { _SymSc = value; }
        }
        public int? TextScale
        {
            get { return _TxtSc; }
            set { _TxtSc = value; }
        }
        public string VoltageCode
        {
            get { return _VoltageCode; }
            set { _VoltageCode = value; }
        }
        public string JobName
        {
            get { return _JobName; }
            set { _JobName = value; }
        }

        public string Detail
        {
            get { return _Detail; }
            set { _Detail = value; }
        }
        public string DrawingNumber
        {
            get { return _DrawingNumber; }
            set { _DrawingNumber = value; }
        }

        public string MatchToLeft
        {
            get { return _MatchToLeft; }
            set { _MatchToLeft = value; }
        }
        public string MatchToTop
        {
            get { return _MatchToTop; }
            set { _MatchToTop = value; }
        }
        public string MatchToRight
        {
            get { return _MatchToRight; }
            set { _MatchToRight = value; }
        }
        public string MatchToBottom
        {
            get { return _MatchToBottom; }
            set { _MatchToBottom = value; }
        }

        public string Description
        {
            get { return _Description; }
            set { _Description = value; }
        }

        #endregion Public Attributes
    }

    public class PlotCustom
    {
        #region Private Variables

        private string _PldName = null;
        private string _CustomName = null;
        private int? _CustomOrder = null;

        #endregion Private Variables

        #region Public Attributes

        public string PldName
        {
            get { return _PldName; }
            set { _PldName = value; }
        }
        public string CustomName
        {
            get { return _CustomName; }
            set { _CustomName = value; }
        }
        public int? CustomOrder
        {
            get { return _CustomOrder; }
            set { _CustomOrder = value; }
        }

        #endregion Public Attributes
    }

    public class PlotGroup
    {
        #region Private Variables

        private string _PlotName = null;
        private string _PlotGroupName = null;
        private string _SheetNumber = null;
        private string _NumberOfSheets = null;
        private int? _GroupOrderNumber = null;

        #endregion Private Variables

        #region Public Attributes

        public string PlotName
        {
            get { return _PlotName; }
            set { _PlotName = value; }
        }
        public string PlotGroupName
        {
            get { return _PlotGroupName; }
            set { _PlotGroupName = value; }
        }
        public string SheetNumber
        {
            get { return _SheetNumber; }
            set { _SheetNumber = value; }
        }
        public string NumberOfSheets
        {
            get { return _NumberOfSheets; }
            set { _NumberOfSheets = value; }
        }
        public int? GroupOrderNumber
        {
            get { return _GroupOrderNumber; }
            set { _GroupOrderNumber = value; }
        }
        #endregion Public Attributes
    }

}

