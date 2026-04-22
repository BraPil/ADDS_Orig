using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadGeo = Autodesk.AutoCAD.Geometry;
using AcadGrp = Autodesk.AutoCAD.GraphicsInterface;

using AcadWin = Autodesk.AutoCAD.Windows;
using AcadColor = Autodesk.AutoCAD.Colors;
//using AcadGIS = Autodesk.Gis.Map;
using AcadPS = Autodesk.AutoCAD.PlottingServices;

namespace Adds
{
    public class TextJig : AcadEd.EntityJig
    {
        private AcadGeo.Point3d _TempPosition;
        private AcadGrp.TextStyle _tsNormal;
        private AcadGeo.Point3d m_CenterPt, m_ActualPoint;

        public AcadGeo.Point3d Position
        {
            get { return _TempPosition; }
        }

        public TextJig(AcadDB.DBText dbText)
            : base(dbText)
        {
            _tsNormal = new AcadGrp.TextStyle
            {
                Font = new AcadGrp.FontDescriptor("Times New Roman", false, false, 0, 0),
                TextSize = 10
            };

            m_CenterPt = dbText.Position;  //br.Position;
        }

        protected override AcadEd.SamplerStatus Sampler(AcadEd.JigPrompts prompts)
        {
            AcadEd.JigPromptPointOptions jigPtsOption = new AcadEd.JigPromptPointOptions
            {
                UserInputControls = AcadEd.UserInputControls.Accept3dCoordinates
                                        | AcadEd.UserInputControls.NoZeroResponseAccepted
                                        | AcadEd.UserInputControls.NoNegativeResponseAccepted,

                Message = "\nSelect insertion point: "
            };

            AcadEd.PromptPointResult ppr = prompts.AcquirePoint(jigPtsOption);
            if (_TempPosition == ppr.Value)
            {
                return AcadEd.SamplerStatus.NoChange;
            }
            else if (ppr.Status == AcadEd.PromptStatus.OK)
            {
                m_ActualPoint = ppr.Value;
                return AcadEd.SamplerStatus.OK;
            }
            return AcadEd.SamplerStatus.Cancel;
        }

        protected override bool Update()
        {
            m_CenterPt = m_ActualPoint;
            try
            {
                ((AcadDB.DBText)Entity).Position = m_CenterPt;
            }
            catch (System.Exception)
            {
                return false;
            }
            return true;
        }

        public AcadDB.Entity GetEntity()
        {
            return Entity;
        }

        public AcadEd.PromptStatus Run()
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadEd.Editor ed = doc.Editor;

            AcadEd.PromptResult promptResult = ed.Drag(this);
            return promptResult.Status;
        }
    }
    
    public class PlineJig : AcadEd.EntityJig
    {
        private AcadGeo.Point3dCollection m_Points;         //  List of vertices
        private AcadGeo.Point3d m_TempPoint;
        private AcadGeo.Plane m_Plane;

        public PlineJig(AcadGeo.Matrix3d ucs): base(new AcadDB.Polyline())
        {
            //  Create a point collection to store vertices
            m_Points = new AcadGeo.Point3dCollection();

            //  Create a temporary plane, to help with calcs
            AcadGeo.Point3d origin = new AcadGeo.Point3d(0, 0, 0);
            AcadGeo.Vector3d normal = new AcadGeo.Vector3d(0, 0, 1);
            normal = normal.TransformBy(ucs);
            m_Plane = new AcadGeo.Plane(origin, normal);

            //  Create polyline, set defaults, and dummy vertix
            AcadDB.Polyline pline = Entity as AcadDB.Polyline;
            //AcadDB.Polyline2d pline = Entity as AcadDB.Polyline2d;
            pline.SetDatabaseDefaults();
            pline.Normal = normal;
            pline.AddVertexAt(0, new AcadGeo.Point2d(0, 0), 0, 0, 0);
            //pline.AppendVertex(new AcadGeo.Point3d(0.0, 0.0, 0.0));

        }

        protected override AcadEd.SamplerStatus Sampler(AcadEd.JigPrompts prompts)
        {
            AcadEd.JigPromptPointOptions jigPtsOption = new AcadEd.JigPromptPointOptions
            {
                UserInputControls = (AcadEd.UserInputControls.Accept3dCoordinates |
                   AcadEd.UserInputControls.NullResponseAccepted |
                   AcadEd.UserInputControls.NoNegativeResponseAccepted)
            };

            if (m_Points.Count == 0)
            {
                jigPtsOption.Message = "\nStart point of polyline: ";
            }
            else if (m_Points.Count > 0)
            {
                jigPtsOption.BasePoint = m_Points[m_Points.Count - 1];
                jigPtsOption.UseBasePoint = true;
                jigPtsOption.Message = "\nPolyline vertex: ";
            }
            else
            {
                return AcadEd.SamplerStatus.Cancel;
            }

            AcadEd.PromptPointResult ppr = prompts.AcquirePoint(jigPtsOption);
            if (m_TempPoint == ppr.Value)
            {
                return AcadEd.SamplerStatus.NoChange;
            }
            else if (ppr.Status == AcadEd.PromptStatus.OK)
            {
                m_TempPoint = ppr.Value;
                return AcadEd.SamplerStatus.OK;
            }
            return AcadEd.SamplerStatus.Cancel;
        }

        protected override bool Update()
        {
            AcadDB.Polyline pline = Entity as AcadDB.Polyline;
            //AcadDB.Polyline2d pline = Entity as AcadDB.Polyline2d;
            pline.SetPointAt(pline.NumberOfVertices - 1, m_TempPoint.Convert2d(m_Plane));

            return true;
        }

        public AcadDB.Entity GetEntity()
        {
            return Entity;
        }

        public void AddLatestVertex()
        {
            m_Points.Add(m_TempPoint);
            AcadDB.Polyline pline = Entity as AcadDB.Polyline;
            pline.AddVertexAt(pline.NumberOfVertices, new AcadGeo.Point2d(0, 0), 0, 0, 0);
        }

        public void RemoveLastVertex()
        {
            AcadDB.Polyline pline = Entity as AcadDB.Polyline;
            pline.RemoveVertexAt(m_Points.Count);
        }
    }

    public class BlockJig : AcadEd.EntityJig
    {
        private AcadGeo.Point3d m_CenterPt, m_ActualPoint;

        public BlockJig(AcadDB.BlockReference br)
            : base(br)
        {
            m_CenterPt = br.Position;
        }

        protected override AcadEd.SamplerStatus Sampler(AcadEd.JigPrompts jigPrompts)
        {
            AcadEd.JigPromptPointOptions jigOpts = new AcadEd.JigPromptPointOptions
            {
                UserInputControls = AcadEd.UserInputControls.Accept3dCoordinates
                                        | AcadEd.UserInputControls.NoZeroResponseAccepted
                                        | AcadEd.UserInputControls.NoNegativeResponseAccepted,
                Message = "\nEnter insertion point: "
            };

            AcadEd.PromptPointResult ppr = jigPrompts.AcquirePoint(jigOpts);
            if (ppr.Status == AcadEd.PromptStatus.OK)
            {
                if (m_ActualPoint == ppr.Value)
                {
                    return AcadEd.SamplerStatus.NoChange;
                }
                else
                {
                    m_ActualPoint = ppr.Value;
                }
            }
            return AcadEd.SamplerStatus.OK;
        }

        protected override bool Update()
        {
            m_CenterPt = m_ActualPoint;
            try
            {
                ((AcadDB.BlockReference)Entity).Position = m_CenterPt;
            }
            catch (System.Exception)
            {
                return false;
            }
            return true;
        }

        public AcadDB.Entity GetEntity()
        {
            return Entity;
        }
    }

    public class AttInfo
    {
        private AcadGeo.Point3d _pos;
        private AcadGeo.Point3d _aln;
        private bool _aligned;
        private double _rotation;

        public AttInfo(AcadGeo.Point3d pos, AcadGeo.Point3d aln, bool aligned, double rotation)
        {
            _pos = pos;
            _aln = aln;
            _aligned = aligned;
            _rotation = rotation;
        }
        public AcadGeo.Point3d Position
        {
            set { _pos = value; }
            get { return _pos; }
        }
        public AcadGeo.Point3d Alignment
        {
            set { _aln = value; }
            get { return _aln; }
        }
        public bool IsAligned
        {
            set { _aligned = value; }
            get { return _aligned; }
        }
        public double Rotation
        {
            set { _rotation = value; }
            get { return  _rotation; }
        }
    }

    public class BlockJig2 : AcadEd.EntityJig
    {
        internal AcadGeo.Point3d _pos;
        private Dictionary<AcadDB.ObjectId, AttInfo> _attInfo;
        private AcadDB.Transaction _tr;

        public BlockJig2(AcadDB.Transaction tr, AcadDB.BlockReference br, Dictionary<AcadDB.ObjectId, AttInfo> attInfo) : base(br)
        {
            _pos = br.Position;
            _attInfo = attInfo;
            _tr = tr;
        }

        protected override bool Update()
        {
            AcadDB.BlockReference br = Entity as AcadDB.BlockReference;
            br.Position = _pos;

            if (br.AttributeCollection.Count != 0)
            {
                foreach (AcadDB.ObjectId id in br.AttributeCollection)
                {
                    AcadDB.DBObject obj = _tr.GetObject(id, AcadDB.OpenMode.ForRead);
                    AcadDB.AttributeReference ar = obj as AcadDB.AttributeReference;

                    if (ar != null)
                    {
                        ar.UpgradeOpen();
                        AttInfo ai = _attInfo[ar.ObjectId];
                        if (ai.IsAligned)
                        {
                            ar.AlignmentPoint = ai.Alignment.TransformBy(br.BlockTransform);
                        }
                        else
                        {
                            ar.Position = ai.Position.TransformBy(br.BlockTransform);
                        }

                        //ar.Rotation = ai.Rotation;

                        //if (ar.IsMTextAttribute())
                        //{
                        //    ar.UpdateMTextAttribute();
                        //}
                    }
                }
            }
            return true;
        }

        protected override AcadEd.SamplerStatus Sampler(AcadEd.JigPrompts prompts)
        {
            AcadEd.JigPromptPointOptions opts = new AcadEd.JigPromptPointOptions("\nSelect insertion point:")
            {
                BasePoint = new AcadGeo.Point3d(0, 0, 0),
                UserInputControls = AcadEd.UserInputControls.NoZeroResponseAccepted
            };

            AcadEd.PromptPointResult ppr = prompts.AcquirePoint(opts);

            if (_pos == ppr.Value)
            {
                return AcadEd.SamplerStatus.NoChange;
            }
            _pos = ppr.Value;

            return AcadEd.SamplerStatus.OK;
        }

        public AcadEd.PromptStatus Run()
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadEd.Editor ed = doc.Editor;

            AcadEd.PromptResult promptResult = ed.Drag(this);
            return promptResult.Status;
        }
    }
}
