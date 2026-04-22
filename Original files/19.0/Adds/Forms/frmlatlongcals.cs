using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace Adds
{
    public enum UnitsOfLength { Mile, NauticalMiles, Kilometer }
    public enum CardinalPoints { N, E, W, S, NE, NW, SE, SW }

    public partial class frmLatLongCals : Form
    {
        private const Double _MilesToKilometers = 1.609344;
        private const Double _MilesToNautical = 0.8684;

        public frmLatLongCals()
        {
            InitializeComponent();
        }

        private void btnOk_Click(object sender, EventArgs e)
        {
            Coordinate coordinate1 = new Coordinate();
            Coordinate coordinate2 = new Coordinate();

            coordinate1.Latitude = double.Parse(txtLat1.Text.ToString());
            coordinate1.Longitude = double.Parse(txtLong1.Text.ToString());
            coordinate2.Latitude = double.Parse(txtLat2.Text.ToString());
            coordinate2.Longitude = double.Parse(txtLong2.Text.ToString());

            double dist = Distance(coordinate1, coordinate2, UnitsOfLength.Kilometer);

            txtResult.Text = dist.ToString();
        }

        private static Double Distance(Coordinate coordinate1, Coordinate coordinate2, UnitsOfLength unitsOfLength)
        {
            // uses Haversine Formula to calculate the distance between two coordinates
            var theta = coordinate1.Longitude - coordinate2.Longitude;
            var distance = Math.Sin(coordinate1.Latitude.ToRadian()) * Math.Sin(coordinate2.Latitude.ToRadian())
                            + Math.Cos(coordinate1.Latitude.ToRadian()) * Math.Cos(coordinate2.Latitude.ToRadian())
                            * Math.Cos(theta.ToRadian());

            distance = Math.Acos(distance);
            distance = distance.ToDegree();
            distance = distance * 60 * 1.1515;

            if (unitsOfLength == UnitsOfLength.Kilometer)
            {
                distance = distance * _MilesToKilometers;
            }
            else if (unitsOfLength == UnitsOfLength.NauticalMiles)
            {
                distance = distance * _MilesToNautical;
            }
            return distance;
        }
    }

    public class Coordinate
    {
        private double latitude, longitude;

        /// <summary>
        /// Latitude in degrees. -90 to 90
        /// </summary>
        public Double Latitude
        {
            get { return latitude; }
            set
            {
                if (value > 90) throw new ArgumentOutOfRangeException("value", "Latitude value cannot be greater than 90.");
                if (value < -90) throw new ArgumentOutOfRangeException("value", "Latitude value cannot be less than -90.");
                latitude = value;
            }
        }

        /// <summary>
        /// Longitude in degree. -180 to 180
        /// </summary>
        public Double Longitude
        {
            get { return longitude; }
            set
            {
                if (value > 180) throw new ArgumentOutOfRangeException("value", "Longitude value cannot be greater than 180.");
                if (value < -180) throw new ArgumentOutOfRangeException("value", "Longitude value cannot be less than -180.");
                longitude = value;
            }
        }
    }

    public static class Helper
    {
        public static Double ToDegree(this Double radian) { return (radian / Math.PI * 180.0); }
        public static Double ToRadian(this Double degree) { return (degree * Math.PI / 180.0); }

        
    }

   
}
