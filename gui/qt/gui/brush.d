/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.gui.brush;
extern(C++):

import qt.config;
import qt.core.atomic;
import qt.core.global;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.objectdefs;
import qt.core.pair;
import qt.core.point;
import qt.core.scopedpointer;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.gui.color;
import qt.gui.image;
import qt.gui.matrix;
import qt.gui.pixmap;
import qt.gui.transform;
import qt.helpers;

struct QBrushDataPointerDeleter;

/// Binding for C++ class [QBrush](https://doc.qt.io/qt-5/qbrush.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QBrush) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QBrush
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(/+ Qt:: +/qt.core.namespace.BrushStyle bs);
    this(ref const(QColor) color, /+ Qt:: +/qt.core.namespace.BrushStyle bs=/+ Qt:: +/qt.core.namespace.BrushStyle.SolidPattern);
    this(const(QColor) color, /+ Qt:: +/qt.core.namespace.BrushStyle bs=/+ Qt:: +/qt.core.namespace.BrushStyle.SolidPattern)
    {
        this(color, bs);
    }
    this(/+ Qt:: +/qt.core.namespace.GlobalColor color, /+ Qt:: +/qt.core.namespace.BrushStyle bs=/+ Qt:: +/qt.core.namespace.BrushStyle.SolidPattern);

    this(ref const(QColor) color, ref const(QPixmap) pixmap);
    this(/+ Qt:: +/qt.core.namespace.GlobalColor color, ref const(QPixmap) pixmap);
    this(ref const(QPixmap) pixmap);
    this(ref const(QImage) image);

    @disable this(this);
    this(ref const(QBrush) brush);

    this(ref const(QGradient) gradient);

    ~this();
    /+ref QBrush operator =(ref const(QBrush) brush);+/
    /+ inline QBrush &operator=(QBrush &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    /+ inline void swap(QBrush &other) noexcept
    { qSwap(d, other.d); } +/

    /+auto opCast(T : QVariant)() const;+/

    pragma(inline, true) /+ Qt:: +/qt.core.namespace.BrushStyle style() const { return d.style; }
    void setStyle(/+ Qt:: +/qt.core.namespace.BrushStyle);

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_X("Use transform()") +/ pragma(inline, true) ref const(QMatrix) matrix() const { return d.transform.toAffine(); }
    /+ QT_DEPRECATED_X("Use setTransform()") +/ void setMatrix(ref const(QMatrix) mat);
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)

    pragma(inline, true) QTransform transform() const { return d.transform; }
    void setTransform(ref const(QTransform) );

    QPixmap texture() const;
    void setTexture(ref const(QPixmap) pixmap);

    QImage textureImage() const;
    void setTextureImage(ref const(QImage) image);

    pragma(inline, true) ref const(QColor) color() const { return d.color; }
    void setColor(ref const(QColor) color);
    pragma(inline, true) void setColor(/+ Qt:: +/qt.core.namespace.GlobalColor acolor)
    { auto tmp = QColor(acolor); setColor(tmp); }

    const(QGradient)* gradient() const;

    bool isOpaque() const;

    /+bool operator ==(ref const(QBrush) b) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QBrush) b) const { return !(operator==(b)); }+/

private:
    /+ friend class QRasterPaintEngine; +/
    /+ friend class QRasterPaintEnginePrivate; +/
    /+ friend struct QSpanData; +/
    /+ friend class QPainter; +/
    /+ friend bool Q_GUI_EXPORT qHasPixmapTexture(const QBrush& brush); +/
    void detach(/+ Qt:: +/qt.core.namespace.BrushStyle newStyle);
    void init_(ref const(QColor) color, /+ Qt:: +/qt.core.namespace.BrushStyle bs);
    QScopedPointer!(QBrushData, QBrushDataPointerDeleter) d;
    void cleanUp(QBrushData* x);

public:
    pragma(inline, true) bool isDetached() const { return d.ref_.loadRelaxed() == 1; }
    alias DataPtr = QScopedPointer!(QBrushData, QBrushDataPointerDeleter);
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
}

/+ Q_DECLARE_SHARED(QBrush)

/*****************************************************************************
  QBrush stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QBrush &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QBrush &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QBrush &);
#endif +/

struct QBrushData
{
    QAtomicInt ref_;
    /+ Qt:: +/qt.core.namespace.BrushStyle style;
    QColor color;
    QTransform transform;
}
/+ #if QT_DEPRECATED_SINCE(5, 15)
#endif +/ // QT_DEPRECATED_SINCE(5, 15)


/*******************************************************************************
 * QGradients
 */
extern(C++, class) struct QGradientPrivate;

alias QGradientStop = QPair!(qreal, QColor);
alias QGradientStops = QVector!(QGradientStop);

/// Binding for C++ class [QGradient](https://doc.qt.io/qt-5/qgradient.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QGradient
{
    mixin(Q_GADGET);
public:
    enum Type {
        LinearGradient,
        RadialGradient,
        ConicalGradient,
        NoGradient
    }
    /+ Q_ENUM(Type) +/

    enum Spread {
        PadSpread,
        ReflectSpread,
        RepeatSpread
    }
    /+ Q_ENUM(Spread) +/

    enum CoordinateMode {
        LogicalMode,
        StretchToDeviceMode,
        ObjectBoundingMode,
        ObjectMode
    }
    /+ Q_ENUM(CoordinateMode) +/

    enum InterpolationMode {
        ColorInterpolation,
        ComponentInterpolation
    }

    enum Preset {
        WarmFlame = 1,
        NightFade = 2,
        SpringWarmth = 3,
        JuicyPeach = 4,
        YoungPassion = 5,
        LadyLips = 6,
        SunnyMorning = 7,
        RainyAshville = 8,
        FrozenDreams = 9,
        WinterNeva = 10,
        DustyGrass = 11,
        TemptingAzure = 12,
        HeavyRain = 13,
        AmyCrisp = 14,
        MeanFruit = 15,
        DeepBlue = 16,
        RipeMalinka = 17,
        CloudyKnoxville = 18,
        MalibuBeach = 19,
        NewLife = 20,
        TrueSunset = 21,
        MorpheusDen = 22,
        RareWind = 23,
        NearMoon = 24,
        WildApple = 25,
        SaintPetersburg = 26,
        PlumPlate = 28,
        EverlastingSky = 29,
        HappyFisher = 30,
        Blessing = 31,
        SharpeyeEagle = 32,
        LadogaBottom = 33,
        LemonGate = 34,
        ItmeoBranding = 35,
        ZeusMiracle = 36,
        OldHat = 37,
        StarWine = 38,
        HappyAcid = 41,
        AwesomePine = 42,
        NewYork = 43,
        ShyRainbow = 44,
        MixedHopes = 46,
        FlyHigh = 47,
        StrongBliss = 48,
        FreshMilk = 49,
        SnowAgain = 50,
        FebruaryInk = 51,
        KindSteel = 52,
        SoftGrass = 53,
        GrownEarly = 54,
        SharpBlues = 55,
        ShadyWater = 56,
        DirtyBeauty = 57,
        GreatWhale = 58,
        TeenNotebook = 59,
        PoliteRumors = 60,
        SweetPeriod = 61,
        WideMatrix = 62,
        SoftCherish = 63,
        RedSalvation = 64,
        BurningSpring = 65,
        NightParty = 66,
        SkyGlider = 67,
        HeavenPeach = 68,
        PurpleDivision = 69,
        AquaSplash = 70,
        SpikyNaga = 72,
        LoveKiss = 73,
        CleanMirror = 75,
        PremiumDark = 76,
        ColdEvening = 77,
        CochitiLake = 78,
        SummerGames = 79,
        PassionateBed = 80,
        MountainRock = 81,
        DesertHump = 82,
        JungleDay = 83,
        PhoenixStart = 84,
        OctoberSilence = 85,
        FarawayRiver = 86,
        AlchemistLab = 87,
        OverSun = 88,
        PremiumWhite = 89,
        MarsParty = 90,
        EternalConstance = 91,
        JapanBlush = 92,
        SmilingRain = 93,
        CloudyApple = 94,
        BigMango = 95,
        HealthyWater = 96,
        AmourAmour = 97,
        RiskyConcrete = 98,
        StrongStick = 99,
        ViciousStance = 100,
        PaloAlto = 101,
        HappyMemories = 102,
        MidnightBloom = 103,
        Crystalline = 104,
        PartyBliss = 106,
        ConfidentCloud = 107,
        LeCocktail = 108,
        RiverCity = 109,
        FrozenBerry = 110,
        ChildCare = 112,
        FlyingLemon = 113,
        NewRetrowave = 114,
        HiddenJaguar = 115,
        AboveTheSky = 116,
        Nega = 117,
        DenseWater = 118,
        Seashore = 120,
        MarbleWall = 121,
        CheerfulCaramel = 122,
        NightSky = 123,
        MagicLake = 124,
        YoungGrass = 125,
        ColorfulPeach = 126,
        GentleCare = 127,
        PlumBath = 128,
        HappyUnicorn = 129,
        AfricanField = 131,
        SolidStone = 132,
        OrangeJuice = 133,
        GlassWater = 134,
        NorthMiracle = 136,
        FruitBlend = 137,
        MillenniumPine = 138,
        HighFlight = 139,
        MoleHall = 140,
        SpaceShift = 142,
        ForestInei = 143,
        RoyalGarden = 144,
        RichMetal = 145,
        JuicyCake = 146,
        SmartIndigo = 147,
        SandStrike = 148,
        NorseBeauty = 149,
        AquaGuidance = 150,
        SunVeggie = 151,
        SeaLord = 152,
        BlackSea = 153,
        GrassShampoo = 154,
        LandingAircraft = 155,
        WitchDance = 156,
        SleeplessNight = 157,
        AngelCare = 158,
        CrystalRiver = 159,
        SoftLipstick = 160,
        SaltMountain = 161,
        PerfectWhite = 162,
        FreshOasis = 163,
        StrictNovember = 164,
        MorningSalad = 165,
        DeepRelief = 166,
        SeaStrike = 167,
        NightCall = 168,
        SupremeSky = 169,
        LightBlue = 170,
        MindCrawl = 171,
        LilyMeadow = 172,
        SugarLollipop = 173,
        SweetDessert = 174,
        MagicRay = 175,
        TeenParty = 176,
        FrozenHeat = 177,
        GagarinView = 178,
        FabledSunset = 179,
        PerfectBlue = 180,

        NumPresets
    }
    /+ Q_ENUM(Preset) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(Preset);
    ~this();

    Type type() const { return m_type; }

    pragma(inline, true) void setSpread(Spread aspread)
    { m_spread = aspread; }
    Spread spread() const { return m_spread; }

    void setColorAt(qreal pos, ref const(QColor) color);

    void setStops(ref const(QGradientStops) stops);
    QGradientStops stops() const;

    CoordinateMode coordinateMode() const;
    void setCoordinateMode(CoordinateMode mode);

    InterpolationMode interpolationMode() const;
    void setInterpolationMode(InterpolationMode mode);

    /+bool operator ==(ref const(QGradient) gradient) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QGradient) other) const
    { return !operator==(other); }+/

    union QGradientData {
        struct generated_qbrush_0 {
            qreal x1; qreal y1; qreal x2; qreal y2;
        }generated_qbrush_0 linear;
        struct generated_qbrush_1 {
            qreal cx; qreal cy; qreal fx; qreal fy; qreal cradius;
        }generated_qbrush_1 radial;
        struct generated_qbrush_2 {
            qreal cx; qreal cy; qreal angle;
        }generated_qbrush_2 conical;
    }

private:
    /+ friend class QLinearGradient; +/
    /+ friend class QRadialGradient; +/
    /+ friend class QConicalGradient; +/
    /+ friend class QBrush; +/

    Type m_type;
    Spread m_spread;
    QGradientStops m_stops;
    QGradientData m_data;
    void* dummy; // ### Qt 6: replace with actual content (CoordinateMode, InterpolationMode, ...)
}

/// Binding for C++ class [QLinearGradient](https://doc.qt.io/qt-5/qlineargradient.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QLinearGradient
{
    public QGradient base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QPointF) start, ref const(QPointF) finalStop);
    this(qreal xStart, qreal yStart, qreal xFinalStop, qreal yFinalStop);
    ~this();

    QPointF start() const;
    void setStart(ref const(QPointF) start);
    pragma(inline, true) void setStart(qreal x, qreal y) { auto tmp = QPointF(x, y); setStart(tmp); }

    QPointF finalStop() const;
    void setFinalStop(ref const(QPointF) stop);
    pragma(inline, true) void setFinalStop(qreal x, qreal y) { auto tmp = QPointF(x, y); setFinalStop(tmp); }
}


/// Binding for C++ class [QRadialGradient](https://doc.qt.io/qt-5/qradialgradient.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QRadialGradient
{
    public QGradient base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QPointF) center, qreal radius, ref const(QPointF) focalPoint);
    this(qreal cx, qreal cy, qreal radius, qreal fx, qreal fy);

    this(ref const(QPointF) center, qreal radius);
    this(qreal cx, qreal cy, qreal radius);

    this(ref const(QPointF) center, qreal centerRadius, ref const(QPointF) focalPoint, qreal focalRadius);
    this(qreal cx, qreal cy, qreal centerRadius, qreal fx, qreal fy, qreal focalRadius);

    ~this();

    QPointF center() const;
    void setCenter(ref const(QPointF) center);
    pragma(inline, true) void setCenter(qreal x, qreal y) { auto tmp = QPointF(x, y); setCenter(tmp); }

    QPointF focalPoint() const;
    void setFocalPoint(ref const(QPointF) focalPoint);
    pragma(inline, true) void setFocalPoint(qreal x, qreal y) { auto tmp = QPointF(x, y); setFocalPoint(tmp); }

    qreal radius() const;
    void setRadius(qreal radius);

    qreal centerRadius() const;
    void setCenterRadius(qreal radius);

    qreal focalRadius() const;
    void setFocalRadius(qreal radius);
}


/// Binding for C++ class [QConicalGradient](https://doc.qt.io/qt-5/qconicalgradient.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QConicalGradient
{
    public QGradient base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QPointF) center, qreal startAngle);
    this(qreal cx, qreal cy, qreal startAngle);
    ~this();

    QPointF center() const;
    void setCenter(ref const(QPointF) center);
    pragma(inline, true) void setCenter(qreal x, qreal y) { auto tmp = QPointF(x, y); setCenter(tmp); }

    qreal angle() const;
    void setAngle(qreal angle);
}

