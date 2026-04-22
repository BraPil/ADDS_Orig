#region Namespaces & Notes

using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;

using Autodesk.AutoCAD.EditorInput;
using Autodesk.AutoCAD.Geometry;
using Autodesk.AutoCAD.DatabaseServices;
using Autodesk.AutoCAD.GraphicsInterface;
using Autodesk.AutoCAD.Runtime;
//  Use prefix to avoid problems between Microsoft and AutoCAD namespaces
using Acad = Autodesk.AutoCAD.Runtime;
using AcadAS = Autodesk.AutoCAD.ApplicationServices;
using AcadDB = Autodesk.AutoCAD.DatabaseServices;
using AcadEd = Autodesk.AutoCAD.EditorInput;
using AcadApp = Autodesk.AutoCAD.ApplicationServices.Application;
using AcadGeo = Autodesk.AutoCAD.Geometry;
//using AcadColor = Autodesk.AutoCAD.Colors;

//03july14 - karl
//copied from cadet2012 AttributeTools.cs (originally by mickey gsell)
//to temporarily fix the attribute vanishing issue in ADDS.
//
//NAMESPACE AddsAttribFuncts
//          METHOD LISTING
//              "MoveAttribute"
//              "RotateAttribute"
//              "Move&RotateAttribute"
//              "Rotate&MoveAttribute"
//              "LevelAttribute"
//              "Level&MoveAttribute"
//              AttributesToTextList
//              AttributesToTextListNotVisible
//              TextJigMove                              //mickey original
//              TextJig : DrawJig                        //mickey original
//              MovementJig : DrawJig                    //karl
//              RotationJig : DrawJig                    //karl
//              
//NAMESPACE AttributeFuncts
//          METHOD LISTING
//              SelectBlock()                             //karl
//              MoveAttrib()                              //karl
//              RotateAttrib()                            //karl
//              MoveRotAttrib()                           //karl
//              RotMoveAttrib()                           //karl
//              LevelAttrib()                             //karl
//              DegreesToRadians()
//              RadiansToDegrees()
//              DrawCircle()         //for testing only
//              ReturnAngleRad()                          //karl
//              MoveAndLevelAttribute()                   //mickey original
//              HoldAttributes(regId, db)                 //mickey original
//              karlgetAttributepoints(AttributeList)     //karl
//              getAttributepoints(AttributeList)         //mickey original
//              getMid3d(pntcollection3d)                 //mickey original
//              LevelAttlist(AttributeList, midpoint)     //mickey original (but renamed)
//
//
#endregion

namespace AddsAttribFuncts
{
    public partial class Functs
    {

        [Acad.CommandMethod("MoveAttribute")]
        public void MovAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block
                AttributeFuncts.AttribFuncts.MoveAttrib(res);                               //move the attribs            
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "MoveAttribute"

        [Acad.CommandMethod("RotateAttribute")]
        public void RotAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block
                AttributeFuncts.AttribFuncts.RotateAttrib(res);                             //rotate the attribs            
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "RotateAttribute"

        [Acad.CommandMethod("Move&RotateAttribute")]
        public void MovRotAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block
                AttributeFuncts.AttribFuncts.MoveRotAttrib(res);                            //move then rotate the attribs
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "Move&RotateAttribute"

        [Acad.CommandMethod("Rotate&MoveAttribute")]
        public void RotMovAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block
                AttributeFuncts.AttribFuncts.RotMoveAttrib(res);                            //rotate then move the attribs
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "Move&RotateAttribute"

        [Acad.CommandMethod("LevelAttribute")]                         //no jig needed for this command
        public void LevAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block - karl
                AttributeFuncts.AttribFuncts.LevelAttrib(res);                              //level the attribs - karl            
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "LevelAttribute"

        [Acad.CommandMethod("Level&MoveAttribute")]       //level first then move
        public void LevMovAttr()
        {
            AcadAS.Document doc = AcadApp.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                AttributeFuncts.AttribFuncts.MoveAndLevelAttribute();                     //mickey original
                //PromptEntityResult res = AttributeFuncts.AttribFuncts.SelectBlock();        //select the block - karl
                //AttributeFuncts.AttribFuncts.LevelAttrib(res);                              //level the attribs - karl
                //AttributeFuncts.AttribFuncts.MoveAttrib(res);                               //move the attribs - karl
            }
            catch (System.Exception ex)
            {
                ed.WriteMessage("Msg to karl: " + ex.ToString());
            }
        }//end of "LevelAndMoveAttribute"


        public static List<AcadDB.DBText> AttributesToTextList(List<AttribHolder> attributelist)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            List<AcadDB.DBText> textlist = new List<AcadDB.DBText>();
            using (AcadDB.Transaction tr = doc.TransactionManager.StartTransaction())
            {
                AcadDB.BlockTableRecord btr = tr.GetObject(db.CurrentSpaceId, AcadDB.OpenMode.ForWrite)
                                              as AcadDB.BlockTableRecord;
                foreach (AttribHolder attributeholder in attributelist)
                {
                    AcadDB.DBText txt = attributeholder.ToDBText();
                    txt.Normal = ed.CurrentUserCoordinateSystem.CoordinateSystem3d.Zaxis;
                    btr.AppendEntity(txt);
                    tr.AddNewlyCreatedDBObject(txt, true);
                    textlist.Add(txt);
                }
                tr.Commit();
            }
            return textlist;
        }//end of AttributesToTextList


        public static List<AcadDB.DBText> AttributesToTextListNotVisible(List<AttribHolder> attributelist)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            List<AcadDB.DBText> textlist = new List<AcadDB.DBText>();
            foreach (AttribHolder attributeholder in attributelist)
            {
                AcadDB.DBText txt = attributeholder.ToDBText();
                txt.Normal = ed.CurrentUserCoordinateSystem.CoordinateSystem3d.Zaxis;
                textlist.Add(txt);
            }
            return textlist;
        }//end of AttributesToTextListNotVisible

    }//end of class Functs


    public class TextJigCommands
    {
        public static AcadEd.PromptPointResult TextJigMove(List<DBText> TextList, Point3d RefPoint)   //used 3 places
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadEd.Editor ed = doc.Editor;
            List<DBText> textlist = new List<DBText>();
            using (Transaction trans = doc.TransactionManager.StartTransaction())
            {
                foreach (DBText txt in TextList)
                {
                    DBObject text = trans.GetObject(txt.ObjectId, OpenMode.ForWrite);
                }
                TextJig jig = new TextJig(TextList, RefPoint);
                AcadEd.PromptPointResult res = (AcadEd.PromptPointResult)ed.Drag(jig);
                foreach (DBText txt in TextList)
                {
                    txt.Erase();
                }
                trans.Commit();
                return res;
            }
        }//end of TextJigMove

    }//end of class TextJigCommands


    public class TextJig : DrawJig
    {
        private IList<DBText> TextList;
        private Point3d currentPosition;
        private Vector3d currentVector;
        public List<Vector3d> VectorList = new List<Vector3d>();

        public TextJig(IList<DBText> textlist, Point3d referencePoint)
        {
            this.TextList = textlist;
            currentPosition = referencePoint;
            // init current vector as 0,0,0
            currentVector = new Vector3d(0, 0, 0);
            foreach (DBText Item in textlist)
            {
                Vector3d test = referencePoint.GetVectorTo(Item.Position);
                VectorList.Add(test);
            }
        }//end of TextJig


        protected override SamplerStatus Sampler(JigPrompts prompts)
        {
            JigPromptPointOptions jigOpt = new JigPromptPointOptions("\nPlace attribute location: ");
            jigOpt.UserInputControls = (UserInputControls.Accept3dCoordinates |
                                        UserInputControls.NullResponseAccepted |
                                        UserInputControls.NoNegativeResponseAccepted |
                                        UserInputControls.GovernedByOrthoMode);
            //jigOpt.Cursor = CursorType.RubberBand; 
            PromptPointResult res = prompts.AcquirePoint(jigOpt);
            if (res.Status != PromptStatus.OK)
                return SamplerStatus.Cancel;

            // compare points
            if (res.Value.IsEqualTo(currentPosition))
                return SamplerStatus.NoChange;

            // get vector to current position
            Vector3d v3d = currentPosition.GetVectorTo(res.Value);
            currentVector = new Vector3d(v3d.X, v3d.Y, v3d.Z);

            // reset current position
            currentPosition = res.Value;

            return SamplerStatus.OK;
        }//end of Sampler


        protected override bool WorldDraw(Autodesk.AutoCAD.GraphicsInterface.WorldDraw draw)
        {
            try
            {
                int counter = 0;
                foreach (DBText Item in TextList)
                {
                    Vector3d newvec = new Vector3d();
                    Point3d newtextloc = currentPosition.Add(VectorList[counter]);
                    newvec = Item.Position.GetVectorTo(newtextloc);
                    Item.Position = Item.Position.Add(newvec);
                    draw.Geometry.Draw(Item);
                    counter++;
                }
            }
            catch (System.Exception)
            {
                return false;
            }
            return true;
        }//end of  WorldDraw

    }//end of class TextJig


    public class MovementJig : DrawJig
    {
        private List<Entity> mEntities = new List<Entity>();
        private Point3d mBase;
        public Point3d mPickedPoint;
        public List<Vector3d> VectorList = new List<Vector3d>();

        public MovementJig(Point3d basePt)
        {
            mBase = basePt.TransformBy(UCS);
            mPickedPoint = mBase;
        }

        public Autodesk.AutoCAD.Geometry.Point3d Location
        {
            get { return mPickedPoint; }
            set { mPickedPoint = value; }
        }

        public Autodesk.AutoCAD.Geometry.Point3d Base
        {
            get { return mBase; }
            set { mBase = value; }
        }

        public Editor AcEditor
        {
            get
            {
                return AcadApp.DocumentManager.MdiActiveDocument.Editor;
            }
        }

        public Matrix3d UCS
        {
            get
            {
                return AcEditor.CurrentUserCoordinateSystem;
            }
        }

        public Matrix3d Transformation   //displacement only (i.e. move)
        {
            get
            {
                return Matrix3d.Displacement(mBase.GetVectorTo(mPickedPoint));
            }
        }

        public void AddEntity(Entity ent)
        {
            mEntities.Add(ent);
        }

        protected override bool WorldDraw(Autodesk.AutoCAD.GraphicsInterface.WorldDraw draw)     //karl - or in the worlddraw subroutines
        {
            Matrix3d mat = Transformation;
            WorldGeometry geo = draw.Geometry;
            if (geo != null)
            {
                geo.PushModelTransform(mat);
                foreach (Entity ent in mEntities)
                {
                    geo.Draw(ent);
                }
                geo.PopModelTransform();
            }
            return true;
        }//end of WorldDraw

        protected override SamplerStatus Sampler(JigPrompts prompts)     //karl - never put message boxes in the sampler subroutines
        {
            JigPromptPointOptions prOptions = new JigPromptPointOptions("\nPlace attribute location: ");
            prOptions.UserInputControls = UserInputControls.GovernedByOrthoMode | UserInputControls.GovernedByUCSDetect;
            PromptPointResult prResult = prompts.AcquirePoint(prOptions);
            switch (prResult.Status)
            {
                case PromptStatus.OK:
                    if (prResult.Value.Equals(mPickedPoint))
                    {
                        return SamplerStatus.NoChange;
                    }
                    else
                    {
                        mPickedPoint = prResult.Value;
                        return SamplerStatus.OK;
                    }
                case PromptStatus.Cancel:
                case PromptStatus.Error:
                    return SamplerStatus.Cancel;
                default:
                    return SamplerStatus.NoChange;
            }
        }//end of Sampler

        public bool Jig()
        {
            try
            {
                PromptResult pr = AcEditor.Drag(this);                                            //karl - drag here
                if (pr.Status == PromptStatus.OK)
                    return true;
                else
                    return false;
            }
            catch
            {
                return false;
            }
        }//end of Jig

    }//end of MovementJig


    public class RotationJig : DrawJig
    {
        private List<Entity> mEntities = new List<Entity>();
        private Point3d mBase;
        public Double mAngle;

        public RotationJig(Point3d basePt)
        {
            mBase = basePt.TransformBy(UCS);
            mAngle = 0;
        }

        public Double Angle
        {
            get { return mAngle; }
            set { mAngle = value; }
        }

        public Autodesk.AutoCAD.Geometry.Point3d Base
        {
            get { return mBase; }
            set { mBase = value; }
        }

        public Editor AcEditor
        {
            get
            {
                return AcadApp.DocumentManager.MdiActiveDocument.Editor;
            }
        }

        public Matrix3d UCS
        {
            get
            {
                return AcEditor.CurrentUserCoordinateSystem;
            }
        }

        public Matrix3d Transformation    //rotation only
        {
            get
            {
                return Matrix3d.Rotation(mAngle, Vector3d.ZAxis.TransformBy(UCS), mBase);
            }
        }

        public void AddEntity(Entity ent)
        {
            mEntities.Add(ent);
        }

        protected override bool WorldDraw(Autodesk.AutoCAD.GraphicsInterface.WorldDraw draw)     //karl - or in the worlddraw subroutines
        {
            Matrix3d mat = Transformation;
            WorldGeometry geo = draw.Geometry;
            if (geo != null)
            {
                geo.PushModelTransform(mat);
                foreach (Entity ent in mEntities)
                {
                    geo.Draw(ent);
                }
                geo.PopModelTransform();
            }
            return true;
        }//end of WorldDraw

        protected override SamplerStatus Sampler(JigPrompts prompts)     //karl - never put message boxes in the sampler subroutines
        {
            JigPromptAngleOptions prOptions = new JigPromptAngleOptions("\nRotate: ");
            prOptions.UseBasePoint = true;
            prOptions.BasePoint = mBase;
            prOptions.UserInputControls = UserInputControls.GovernedByOrthoMode | UserInputControls.GovernedByUCSDetect;
            prOptions.Cursor = CursorType.RubberBand;
            PromptDoubleResult prResult = prompts.AcquireAngle(prOptions);
            switch (prResult.Status)
            {
                case PromptStatus.OK:
                    if (prResult.Value.Equals(mAngle))
                    {
                        return SamplerStatus.NoChange;
                    }
                    else
                    {
                        mAngle = prResult.Value;
                        return SamplerStatus.OK;
                    }
                case PromptStatus.Cancel:
                case PromptStatus.Error:
                    return SamplerStatus.Cancel;
                default:
                    return SamplerStatus.NoChange;
            }
        }//end of Sampler

        public bool Jig()
        {
            try
            {
                PromptResult pr = AcEditor.Drag(this);                                            //karl - drag here
                if (pr.Status == PromptStatus.OK)
                    return true;
                else
                    return false;
            }
            catch
            {
                return false;
            }
        }//end of Jig

    }//end of RotationJig

    public class AttribHolder
    {
        public string Tag { get; set; }
        public string AttValue { get; set; }
        public AcadGeo.Point3d Position { get; set; }
        public AcadGeo.Point3d AlignmentPoint { get; set; }
        public double Rotation { get; set; }
        public ObjectId TextStyleID { get; set; }
        public AttachmentPoint Justification { get; set; }
        public bool Backwards { get; set; }
        public bool Upsidedown { get; set; }
        public double WidthFactor { get; set; }
        public double ObliqueAngle { get; set; }
        public double TextHeight { get; set; }
        public int ColorIndex { get; set; }

        public AttribHolder(string tag, string attValue, AcadGeo.Point3d position, AcadGeo.Point3d alignmentpoint,
            double rotation, ObjectId textStyleId, AttachmentPoint justification, bool backwards, bool upsidedown,
            double widthFactor, double obliqueangle, double textheight, int colorindex)
        {
            Tag = tag;                          //1  string
            AttValue = attValue;                //2  string
            Position = position;                //3  Point3d
            AlignmentPoint = alignmentpoint;    //4  Point3d
            Rotation = rotation;                //5  double
            TextStyleID = textStyleId;          //6  ObjectId
            Justification = justification;      //7  AttachmentPoint
            Backwards = backwards;              //8  bool
            Upsidedown = upsidedown;            //9  bool
            WidthFactor = widthFactor;          //10 double
            ObliqueAngle = obliqueangle;        //11 double
            TextHeight = textheight;            //12 double
            ColorIndex = colorindex;            //13 int
        }//end of AttribHolder


        public DBText ToDBText()
        {
            AcadDB.DBText txt = new AcadDB.DBText();    //mickey's original listing
            txt.Height = TextHeight;
            txt.TextString = AttValue;
            txt.Position = Position;
            txt.TextStyleId = TextStyleID;
            txt.Oblique = ObliqueAngle;
            txt.Justify = Justification;
            txt.Rotation = Rotation;
            txt.WidthFactor = WidthFactor;
            if (txt.Justify != AcadDB.AttachmentPoint.BaseLeft)
                txt.AlignmentPoint = AlignmentPoint;
            return txt;
        }//end of ToDBText

    }//end of class AttributeHolder
}//end of namespace AddsAttribFuncts


namespace AttributeFuncts
{
    class AttribFuncts
    {

        public static PromptEntityResult SelectBlock()
        {
            //Select block (entity) to pass to other routines
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadEd.Editor ed = doc.Editor;
            AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Block Attribute: ");
            peo.SetRejectMessage("\nSelection must be a block.");
            peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
            PromptEntityResult res = ed.GetEntity(peo);                        //pick entity here
            return res;
        }


        public static void MoveAttrib(PromptEntityResult res)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            try
            {
                ObjectId regId = new ObjectId();
                regId = res.ObjectId;

                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
                AttributeList = AttributeFuncts.AttribFuncts.HoldAttributes(regId, db);

                Point3dCollection pntcollection = new Point3dCollection();
                pntcollection = AttributeFuncts.AttribFuncts.karlgetAttributePoints(AttributeList);

                Point3d CentralRotationPt = AttributeFuncts.AttribFuncts.getMid3d(pntcollection);
                AddsAttribFuncts.MovementJig jiggerMove = new AddsAttribFuncts.MovementJig(CentralRotationPt);
                using (Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    List<DBText> TextList = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    CoordinateSystem3d curUCS = doc.Editor.CurrentUserCoordinateSystem.CoordinateSystem3d;
                    foreach (DBText TextItem in TextList)
                    {
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerMove.AddEntity(TextEnt);
                    }

                    if (jiggerMove.Jig())
                    {
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            Vector3d MoveVector = CentralRotationPt.GetVectorTo(jiggerMove.mPickedPoint);
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AcadDB.AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AcadDB.AttributeReference;
                                attRef.TransformBy(Matrix3d.Displacement(MoveVector));                //karl's version
                                //if (attRef.Justify == AcadDB.AttachmentPoint.BaseLeft)              //mickey's original
                                //   attRef.Position = attRef.Position.Add(MoveVector);               //mickey's original
                                //else                                                                //mickey's original
                                //   attRef.AlignmentPoint = attRef.AlignmentPoint.Add(MoveVector);   //mickey's original
                            }
                        }
                        foreach (DBText txt in TextList)
                        {
                            txt.Erase();                  //delete jig text here
                        }
                        tr.Commit();
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerMove [AddsAttribFuncts.cs]");
                    }
                }
            }
            catch
            {
                //ed.WriteMessage("You escaped out of MoveAttrib [AddsAttribFuncts.cs]");
            }
        }//end of MoveAttrib


        public static void RotateAttrib(PromptEntityResult res)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            try
            {
                ObjectId regId = new ObjectId();
                regId = res.ObjectId;

                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
                AttributeList = AttributeFuncts.AttribFuncts.HoldAttributes(regId, db);

                Point3dCollection pntcollection = new Point3dCollection();
                pntcollection = AttributeFuncts.AttribFuncts.karlgetAttributePoints(AttributeList);

                Point3d CentralRotationPt = AttributeFuncts.AttribFuncts.getMid3d(pntcollection);
                AddsAttribFuncts.RotationJig jiggerRot = new AddsAttribFuncts.RotationJig(CentralRotationPt);
                using (Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    List<DBText> TextList = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    double TextRotAngleRad = TextList[0].Rotation;                 //get first text angle, others will be rotated the same
                    double TextRotAngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(TextRotAngleRad);//just for testing (not used)
                    CoordinateSystem3d curUCS = doc.Editor.CurrentUserCoordinateSystem.CoordinateSystem3d;
                    foreach (DBText TextItem in TextList)
                    {
                        //to have the jig at zero angle to begin (i.e. match the rubberband)
                        TextItem.TransformBy(Matrix3d.Rotation(-TextRotAngleRad, curUCS.Zaxis, CentralRotationPt));
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerRot.AddEntity(TextEnt);
                    }

                    if (jiggerRot.Jig())
                    {
                        double AngleRad = jiggerRot.Angle;
                        double AngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(AngleRad);//just for testing convenience (not used)
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AttributeReference;
                                attRef.TransformBy(Matrix3d.Rotation(-TextRotAngleRad + AngleRad, curUCS.Zaxis, CentralRotationPt));
                                attRef.Rotation = AngleRad;
                            }
                        }
                        foreach (DBText txt in TextList)
                        {
                            txt.Erase();                  //delete jig text here
                        }
                        tr.Commit();
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerRot [AddsAttribFuncts.cs]");
                    }
                }
            }
            catch
            {
                //ed.WriteMessage("You escaped out of RotateAttrib [AddsAttribFuncts.cs]");
            }
        }//end of RotateAttrib


        public static void MoveRotAttrib(PromptEntityResult res)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            try
            {
                ObjectId regId = new ObjectId();
                regId = res.ObjectId;

                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
                AttributeList = AttributeFuncts.AttribFuncts.HoldAttributes(regId, db);

                Point3dCollection pntcollection = new Point3dCollection();
                pntcollection = AttributeFuncts.AttribFuncts.karlgetAttributePoints(AttributeList);

                Point3d CentralRotationPt = AttributeFuncts.AttribFuncts.getMid3d(pntcollection);
                Point3d NewCentralRotationPt = new Point3d();
                Vector3d MoveVector = new Vector3d();
                AddsAttribFuncts.MovementJig jiggerMove = new AddsAttribFuncts.MovementJig(CentralRotationPt);

                using (Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    List<DBText> TextList1 = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    double TextRotAngleRad = TextList1[0].Rotation;                      //get first text angle, others will be rotated the same
                    double TextRotAngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(TextRotAngleRad);     //just for testing (not used)
                    //MessageBox.Show(TextRotAngleDeg.ToString());
                    CoordinateSystem3d curUCS = doc.Editor.CurrentUserCoordinateSystem.CoordinateSystem3d;

                    //do the MOVE stuff first
                    foreach (DBText TextItem in TextList1)
                    {
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerMove.AddEntity(TextEnt);
                    }
                    if (jiggerMove.Jig())
                    {
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            MoveVector = CentralRotationPt.GetVectorTo(jiggerMove.mPickedPoint);
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AcadDB.AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AcadDB.AttributeReference;
                                attRef.TransformBy(Matrix3d.Displacement(MoveVector));                //karl's version
                                //if (attRef.Justify == AcadDB.AttachmentPoint.BaseLeft)              //mickey's original
                                //   attRef.Position = attRef.Position.Add(MoveVector);               //mickey's original
                                //else                                                                //mickey's original
                                //   attRef.AlignmentPoint = attRef.AlignmentPoint.Add(MoveVector);   //mickey's original
                            }
                            NewCentralRotationPt = CentralRotationPt.TransformBy(Matrix3d.Displacement(MoveVector));
                        }
                        foreach (DBText txt in TextList1)
                        {
                            txt.Erase();                  //delete jig text here (rebuild below)
                        }
                        //commit below, not here
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerMove [AddsAttribFuncts.cs]");
                        return;               //skips the rotate jigger if this jigger is canceled
                    }

                    //then do ROTATE stuff second
                    List<DBText> TextList2 = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    AddsAttribFuncts.RotationJig jiggerRot = new AddsAttribFuncts.RotationJig(NewCentralRotationPt);
                    foreach (DBText TextItem in TextList2)
                    {
                        //to have the jig at the same spot as the move pick point
                        TextItem.TransformBy(Matrix3d.Displacement(MoveVector));
                        //to have the jig at zero angle to begin (i.e. match the rubberband)
                        TextItem.TransformBy(Matrix3d.Rotation(-TextRotAngleRad, curUCS.Zaxis, NewCentralRotationPt));
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerRot.AddEntity(TextEnt);
                    }
                    if (jiggerRot.Jig())
                    {
                        double AngleRad = jiggerRot.Angle;
                        double AngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(AngleRad);     //just for testing convenience (not used)
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AttributeReference;
                                attRef.TransformBy(Matrix3d.Rotation(-TextRotAngleRad + AngleRad, curUCS.Zaxis, NewCentralRotationPt));
                                attRef.Rotation = AngleRad;
                            }
                        }
                        foreach (DBText txt in TextList2)
                        {
                            txt.Erase();                  //delete jig text here
                        }
                        tr.Commit();
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerRot [AddsAttribFuncts.cs]");
                    }
                    //end of rotating stuff
                }
            }
            catch
            {
                //ed.WriteMessage("You escaped out of MoveRotAttrib [AddsAttribFuncts.cs]");
            }
        }//end of MoveRotAttrib


        public static void RotMoveAttrib(PromptEntityResult res)
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            try
            {
                ObjectId regId = new ObjectId();
                regId = res.ObjectId;

                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
                AttributeList = AttributeFuncts.AttribFuncts.HoldAttributes(regId, db);

                Point3dCollection pntcollection = new Point3dCollection();
                pntcollection = AttributeFuncts.AttribFuncts.karlgetAttributePoints(AttributeList);

                Point3d CentralRotationPt = AttributeFuncts.AttribFuncts.getMid3d(pntcollection);
                AddsAttribFuncts.RotationJig jiggerRot = new AddsAttribFuncts.RotationJig(CentralRotationPt);
                using (Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    List<DBText> TextList1 = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    double AngleRad = 0;
                    double TextRotAngleRad = TextList1[0].Rotation;                      //get first text angle, others will be rotated the same
                    double TextRotAngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(TextRotAngleRad);     //just for testing (not used)
                    //MessageBox.Show(TextRotAngleDeg.ToString());
                    CoordinateSystem3d curUCS = doc.Editor.CurrentUserCoordinateSystem.CoordinateSystem3d;

                    //do the ROTATE stuff first
                    foreach (DBText TextItem in TextList1)
                    {
                        //to have the jig at zero angle to begin (i.e. match the rubberband)
                        TextItem.TransformBy(Matrix3d.Rotation(-TextRotAngleRad, curUCS.Zaxis, CentralRotationPt));
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerRot.AddEntity(TextEnt);
                    }

                    if (jiggerRot.Jig())
                    {
                        AngleRad = jiggerRot.Angle;
                        double AngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(AngleRad);     //just for testing convenience (not used)
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AttributeReference;
                                attRef.TransformBy(Matrix3d.Rotation(-TextRotAngleRad + AngleRad, curUCS.Zaxis, CentralRotationPt));
                                attRef.Rotation = AngleRad;
                            }
                        }
                        foreach (DBText txt in TextList1)
                        {
                            txt.Erase();                  //delete jig text here
                        }
                        //commit below, not here
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerRot [AddsAttribFuncts.cs]");
                        return;               //skips the move jigger if this jigger is canceled
                    }

                    //then do MOVE stuff second
                    List<DBText> TextList2 = AddsAttribFuncts.Functs.AttributesToTextList(AttributeList);
                    AddsAttribFuncts.MovementJig jiggerMove = new AddsAttribFuncts.MovementJig(CentralRotationPt);
                    foreach (DBText TextItem in TextList2)
                    {
                        //to have the jig at same angle after rotate to begin the move
                        TextItem.TransformBy(Matrix3d.Rotation(-TextRotAngleRad + AngleRad, curUCS.Zaxis, CentralRotationPt));
                        Entity TextEnt = tr.GetObject(TextItem.Id, OpenMode.ForRead) as Entity;
                        jiggerMove.AddEntity(TextEnt);
                    }

                    if (jiggerMove.Jig())
                    {
                        AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                        if (res.Status == PromptStatus.OK)
                        {
                            Vector3d MoveVector = CentralRotationPt.GetVectorTo(jiggerMove.mPickedPoint);
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AcadDB.AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AcadDB.AttributeReference;
                                attRef.TransformBy(Matrix3d.Displacement(MoveVector));                //karl's version
                                //if (attRef.Justify == AcadDB.AttachmentPoint.BaseLeft)              //mickey's original
                                //   attRef.Position = attRef.Position.Add(MoveVector);               //mickey's original
                                //else                                                                //mickey's original
                                //   attRef.AlignmentPoint = attRef.AlignmentPoint.Add(MoveVector);   //mickey's original
                            }
                        }
                        foreach (DBText txt in TextList2)
                        {
                            txt.Erase();                  //delete jig text here
                        }
                        tr.Commit();
                    }
                    else
                    {
                        tr.Abort();
                        //ed.WriteMessage("You escaped out of jiggerMove [AddsAttribFuncts.cs]");
                    }
                }
            }
            catch
            {
                //ed.WriteMessage("You escaped out of RotMoveAttrib [AddsAttribFuncts.cs]");
            }
        }//end of RotMoveAttrib


        public static void LevelAttrib(PromptEntityResult res)                          //note: no jig needed
        {
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            Editor ed = doc.Editor;
            Database db = doc.Database;
            try
            {
                ObjectId regId = new ObjectId();
                regId = res.ObjectId;

                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
                AttributeList = AttributeFuncts.AttribFuncts.HoldAttributes(regId, db);

                Point3dCollection pntcollection = new Point3dCollection();
                pntcollection = AttributeFuncts.AttribFuncts.karlgetAttributePoints(AttributeList);

                Point3d CentralRotationPt = AttributeFuncts.AttribFuncts.getMid3d(pntcollection);
                List<DBText> TextList = AddsAttribFuncts.Functs.AttributesToTextListNotVisible(AttributeList);
                Matrix3d curUCSMatrix = AcadAS.Application.DocumentManager.MdiActiveDocument.Editor.CurrentUserCoordinateSystem;
                CoordinateSystem3d curUCS = curUCSMatrix.CoordinateSystem3d;
                double TextRotAngleRad = TextList[1].Rotation;                      //get first text angle, others will be rotated the same
                double TextRotAngleDeg = AttributeFuncts.AttribFuncts.RadiansToDegrees(TextRotAngleRad);     //just for testing (not used)
                //MessageBox.Show(TextRotAngleDeg.ToString());
                using (Transaction tr = doc.TransactionManager.StartTransaction())
                {
                    AcadDB.BlockReference blockRefw = tr.GetObject(regId, AcadDB.OpenMode.ForWrite) as BlockReference;
                    if (res.Status == PromptStatus.OK)
                    {
                        foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                        {
                            AttributeReference attRef = tr.GetObject(attId, AcadDB.OpenMode.ForWrite) as AttributeReference;
                            attRef.TransformBy(Matrix3d.Rotation(-TextRotAngleRad, curUCS.Zaxis, CentralRotationPt));
                            attRef.Rotation = 0;
                        }
                    }
                    tr.Commit();
                }
            }
            catch
            {
                //ed.WriteMessage("You escaped out of LevelAttrib [AddsAttribFuncts.cs]");
            }
        }//end of LevelAttrib

        internal static double DegreesToRadians(double degrees)
        {
            double result = degrees * (Math.PI / 180.0);
            return result;
        }

        internal static double RadiansToDegrees(double radians)
        {
            double result = radians * (180.0 / Math.PI);
            return result;
        }

        public static void DrawCircle(AcadGeo.Point3d Midpoint, double Radius, int DesiredColorNum)      //for testing only
        {
            AcadAS.Document acDoc = Autodesk.AutoCAD.ApplicationServices.Application.DocumentManager.MdiActiveDocument;
            Database acCurDb = acDoc.Database;
            using (Transaction acTrans = acCurDb.TransactionManager.StartTransaction())
            {
                BlockTable acBlkTbl;
                acBlkTbl = acTrans.GetObject(acCurDb.BlockTableId, OpenMode.ForRead) as BlockTable;
                BlockTableRecord acBlkTblRec;
                acBlkTblRec = acTrans.GetObject(acBlkTbl[BlockTableRecord.ModelSpace],
                                      OpenMode.ForWrite) as BlockTableRecord;
                Circle acCirc = new Circle();
                acCirc.SetDatabaseDefaults();
                acCirc.Center = Midpoint;
                acCirc.Radius = Radius;
                //MessageBox.Show(acCirc.Color.ToString());          //ByLayer
                //MessageBox.Show(acCirc.ColorIndex.ToString());     //256
                acCirc.ColorIndex = DesiredColorNum;
                acBlkTblRec.AppendEntity(acCirc);
                acTrans.AddNewlyCreatedDBObject(acCirc, true);
                acTrans.Commit();
            }
        }//end of DrawCircle


        public static double ReturnAngleRad(Point3d StartPt, Point3d EndPt)//startpt is assumed equivalent to origin, angle is ccw to endpt
        {
            double DeltaX = EndPt.X - StartPt.X;
            double DeltaY = EndPt.Y - StartPt.Y;   //note: z is not used for this angle
            double AngleRad = Math.Atan(DeltaY / DeltaX);
            return AngleRad;
        }//end of ReturnAngleRad


        public static void MoveAndLevelAttribute()                                        //mickey original
        {
            //Select Attribute(block) to move (use pick point for centroid)
            AcadAS.Document doc = AcadAS.Application.DocumentManager.MdiActiveDocument;
            AcadDB.Database db = doc.Database;
            AcadEd.Editor ed = doc.Editor;
            try                                                                                     //karl
            {
                AcadDB.ObjectId regId = new AcadDB.ObjectId();
                List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();

                AcadEd.PromptEntityOptions peo = new AcadEd.PromptEntityOptions("\nSelect Block Attribute: ");
                peo.SetRejectMessage("\nSelection must be a block.");
                peo.AddAllowedClass(typeof(AcadDB.BlockReference), false);
                AcadEd.PromptEntityResult res = ed.GetEntity(peo);
                regId = res.ObjectId;
                AttributeList = HoldAttributes(regId, db);
                AcadGeo.Point3d Midpoint = new AcadGeo.Point3d(0, 0, 0);
                AcadGeo.Point3dCollection pntcollection = new AcadGeo.Point3dCollection();
                pntcollection = getAttributePoints(AttributeList);
                Midpoint = getMid3d(pntcollection);
                AttributeList = LevelAttList(AttributeList, Midpoint);
                PromptPointResult respnt = AddsAttribFuncts.TextJigCommands.TextJigMove(
                   AddsAttribFuncts.Functs.AttributesToTextList(AttributeList), res.PickedPoint);
                if (respnt.Status != PromptStatus.Cancel)
                {
                    using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
                    {
                        AcadDB.BlockReference blockRefw = (AcadDB.BlockReference)tr.GetObject(regId, AcadDB.OpenMode.ForWrite);
                        if (res.Status != PromptStatus.Cancel)
                        {
                            //create a vector between midpoint and resulting point
                            Vector3d MoveVector = res.PickedPoint.GetVectorTo(respnt.Value);
                            //Go thru each attribute and apply the new vector
                            int cnt = 0;
                            foreach (AcadDB.ObjectId attId in blockRefw.AttributeCollection)
                            {
                                AcadDB.AttributeReference attRef = (AcadDB.AttributeReference)tr.GetObject(attId, AcadDB.OpenMode.ForWrite);
                                if (attRef.Justify == AcadDB.AttachmentPoint.BaseLeft)
                                    attRef.Position = AttributeList[cnt].Position.Add(MoveVector);
                                else
                                    attRef.AlignmentPoint = AttributeList[cnt].AlignmentPoint.Add(MoveVector);

                                attRef.Rotation = AttributeList[cnt].Rotation;
                                cnt++;
                            }
                        }
                        tr.Commit();
                    }
                }
            }
            catch                                                                                   //karl
            {
                //ed.WriteMessage("You escaped out of MoveAndLevelAttribute [AddsAttribFuncts.cs]");
            }
        }//end of MoveAndLevelAttribute


        public static List<AddsAttribFuncts.AttribHolder> HoldAttributes(ObjectId regId, AcadDB.Database db)        //mickey original
        {
            List<AddsAttribFuncts.AttribHolder> AttributeList = new List<AddsAttribFuncts.AttribHolder>();
            using (AcadDB.Transaction tr = db.TransactionManager.StartTransaction())
            {
                BlockReference blockref = tr.GetObject(regId, OpenMode.ForRead, false) as BlockReference;
                //Go through each attribute to gather the alignment points in a collection
                foreach (AcadDB.ObjectId attId in blockref.AttributeCollection)
                {
                    AcadDB.AttributeReference attref = (AcadDB.AttributeReference)tr.GetObject(attId, AcadDB.OpenMode.ForRead);
                    AddsAttribFuncts.AttribHolder mycoolattribute = new AddsAttribFuncts.AttribHolder(attref.Tag,
                       attref.TextString, attref.Position, attref.AlignmentPoint, attref.Rotation, attref.TextStyleId,
                       attref.Justify, false, false, attref.WidthFactor, attref.Oblique, attref.Height, attref.ColorIndex);
                    AttributeList.Add(mycoolattribute);
                }
                return AttributeList;
            }
        }//end of HoldAttributes


        //collects both the position & alignment pt of each attrib (for averaging later)- karl
        public static AcadGeo.Point3dCollection karlgetAttributePoints(List<AddsAttribFuncts.AttribHolder> AttributeList)
        {
            AcadGeo.Point3dCollection pntcollection3d = new AcadGeo.Point3dCollection();
            //Go through each attribute to gather the alignment points in a collection (but ignore the blank attribs)
            foreach (AddsAttribFuncts.AttribHolder attRef in AttributeList)
            {
                if (!string.IsNullOrEmpty(attRef.AttValue) &&
                    attRef.AttValue != " " &&
                    attRef.AttValue != "  ")
                {
                    if (attRef.Justification == AttachmentPoint.BaseLeft)
                    {
                        pntcollection3d.Add(attRef.Position);   //alignment pt for baseleft is 0,0  --  skews the average
                    }
                    else
                    {
                        pntcollection3d.Add(attRef.Position);
                        pntcollection3d.Add(attRef.AlignmentPoint);
                    }
                }
            }
            return pntcollection3d;
        }//end of karlgetAttributepoints


        public static AcadGeo.Point3dCollection getAttributePoints(List<AddsAttribFuncts.AttribHolder> AttributeList)     //mickey original
        {
            AcadGeo.Point3dCollection pntcollection3d = new AcadGeo.Point3dCollection();
            //Go through each attribute to gather the alignment points in a collection
            foreach (AddsAttribFuncts.AttribHolder attRef in AttributeList)
            {
                if (attRef.Justification == AcadDB.AttachmentPoint.BaseLeft)
                    pntcollection3d.Add(attRef.Position);
                else
                    pntcollection3d.Add(attRef.AlignmentPoint);
            }
            return pntcollection3d;
        }//end of getAttributepoints


        public static AcadGeo.Point3d getMid3d(AcadGeo.Point3dCollection pntcollection3d)                //mickey original
        {
            AcadGeo.Point3d midpoint = new AcadGeo.Point3d(0, 0, 0);
            double totalX = 0;
            double totalY = 0;
            double NewX = 0;
            double NewY = 0;
            foreach (AcadGeo.Point3d newpoint in pntcollection3d)
            {
                totalX += newpoint.X;
                totalY += newpoint.Y;
            }
            NewX = totalX / pntcollection3d.Count;
            NewY = totalY / pntcollection3d.Count;
            midpoint = new AcadGeo.Point3d(NewX, NewY, 0);
            return midpoint;
        }//end of getMid3d


        public static List<AddsAttribFuncts.AttribHolder> LevelAttList(                                 //mickey original
                      List<AddsAttribFuncts.AttribHolder> AttributeList, AcadGeo.Point3d midpoint)
        {
            foreach (AddsAttribFuncts.AttribHolder attr in AttributeList)
            {
                Vector3d V3 = new Vector3d(0, 0, 1);
                if (attr.Justification != AcadDB.AttachmentPoint.BaseLeft)
                    attr.AlignmentPoint = attr.AlignmentPoint.RotateBy(-attr.Rotation, V3, midpoint);
                else
                    attr.Position = attr.Position.RotateBy(-attr.Rotation, V3, midpoint);
                attr.Rotation = 0;
            }
            return AttributeList;
        }//end of LevelAttList (originally LevelAtlst)

    }//end of class AttribFuncts

}//end of namespace AddsAttribFuncts