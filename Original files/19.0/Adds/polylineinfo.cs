using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using AcadGeo = Autodesk.AutoCAD.Geometry;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;


namespace Adds
{
    public class PolylineInfo
    {
        #region Private Variables
        private string _entityName = null;
        private AcadDB.ObjectId _dxfEntityName;

        private AcadDB.Entity _Ent = null;

        private string _layerName = null;
        private double _thickness;

        private double _slopeInRads;
        private double _slopeInDegs;
        private double _perpendicularSlopeInRads;
        private double _perpendicularSlopeInDegs;

        private AcadGeo.Point3d _pickedPoint;
        private AcadGeo.Point3d _ClosestPoint;

        private AcadGeo.Point3d _StartPoint;
        private AcadGeo.Point3d _EndPoint;

        
        // Common data
        private string _Type = null;      //O~Overhead, U~Underground Distribution, T~Transmission, - neither
        private string _Voltage = null;
        private string _DeviceID = null;
        private string _OverRideColorNumber = null;
        private string _OverRideLineWeight = null;

        // Transmission Information
        private string _plantLoc = null;
        private string _lineID = null;


        #endregion Private Variables

        #region Public Attributes

        public AcadDB.Entity Entity
        {
            get { return _Ent; }
            set { _Ent = value; }
        }

        public string EntityName
        {
            get { return _entityName; }
            set { _entityName = value; }
        }
        public AcadDB.ObjectId DxfEntityName
        {
            get { return _dxfEntityName; }
            set { _dxfEntityName = value; }
        }
        public string LayerName
        {
            get { return _layerName; }
            set { _layerName = value; }
        }
        public double Thickness
        {
            get { return _thickness; }
            set { _thickness = value; }
        }

        public double SlopeInRads
        {
            get { return _slopeInRads; }
            set { _slopeInRads = value; }
        }
        public double SlopeInDegs
        {
            get { return _slopeInDegs; }
            set { _slopeInDegs = value; }
        }
        public double SlopePerpendicularInRads
        {
            get { return _perpendicularSlopeInRads; }
            set { _perpendicularSlopeInRads = value; }
        }
        public double SlopePerpendicularInDegs
        {
            get { return _perpendicularSlopeInDegs; }
            set { _perpendicularSlopeInDegs = value; }
        }

        public AcadGeo.Point3d PickedPoint
        {
            get { return _pickedPoint; }
            set { _pickedPoint = value; }
        }
        public AcadGeo.Point3d ClosestPoint
        {
            get { return _ClosestPoint; }
            set { _ClosestPoint = value; }
        }

        public AcadGeo.Point3d StartPoint
        {
            get { return _StartPoint; }
            set { _StartPoint = value; }
        }
        public AcadGeo.Point3d EndPoint
        {
            get { return _EndPoint; }
            set { _EndPoint = value; }
        }

        public string Type
        {
            get { return _Type; }
            set { _Type = value; }
        }

        public string Voltage
        {
            get { return _Voltage; }
            set { _Voltage = value; }
        }


        public string PlantLoc
        {
            get { return _plantLoc; }
            set { _plantLoc = value; }
        }
        public string LineID
        {
            get { return _lineID; }
            set { _lineID = value; }
        }

        public string DeviceID
        {
            get { return _DeviceID; }
            set { _DeviceID = value; }
        }
        public string OverRideColorNumber
        {
            get { return _OverRideColorNumber; }
            set { _OverRideColorNumber = value; }
        }
        public string OverRideLineWeight
        {
            get { return _OverRideLineWeight; }
            set { _OverRideLineWeight = value; }
        }
        #endregion Public Attributes

    }

}
