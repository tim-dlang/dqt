module expandable_list_test.main;

import qt.config;
import qt.helpers;

import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.string;
import qt.core.timer;
import qt.core.url;
import qt.gui.event;
import qt.gui.guiapplication;
import qt.gui.window;
import qt.qml.applicationengine;

import core.stdcpp.new_;
import core.runtime : Runtime;
import core.thread : Thread;

import std.array : split;
import std.conv : to;
import std.exception : enforce;
import std.process : environment;
import std.stdio : writeln;

// QTest's input-injection entry point (returns void in reality; the
// bool here only reads whatever is left in w0, which is harmless).
// Resolved via dlsym because D's Itanium mangling of the QFlags
// substitutions doesn't match libQt6Gui's.
private __gshared extern(C) void function(
	void* window,
	const(QPointF)* local, const(QPointF)* global,
	int state, int button, int type, int modifiers, int timestamp) qt_handleMouseEventC;

private void loadMouseEventHelper()
{
	import core.sys.posix.dlfcn : dlopen, dlsym, RTLD_NOW;
	auto handle = dlopen(null, RTLD_NOW);
	enforce(handle !is null, "dlopen(self) failed");
	string mangled = "_Z19qt_handleMouseEventP7QWindowRK7QPointFS3_"
		~ "6QFlagsIN2Qt11MouseButtonEES6_N6QEvent4TypeES4_INS5_16KeyboardModifierEEi";
	auto sym = cast(const(char)[]) mangled;
	qt_handleMouseEventC = cast(typeof(qt_handleMouseEventC)) dlsym(handle, sym.ptr);
	enforce(qt_handleMouseEventC !is null, "dlsym(qt_handleMouseEvent) failed");
}

private void realClick(QWindow win, double x, double y, bool press)
{
	auto pos = QPointF(x, y);
	auto gpos = win.mapToGlobal(pos); // the REAL global position, like QTest
	if (qt_handleMouseEventC is null)
		loadMouseEventHelper();
	int L = cast(int) qt.core.namespace.MouseButton.LeftButton;
	int N = cast(int) qt.core.namespace.MouseButton.NoButton;
	int M = cast(int) qt.core.namespace.KeyboardModifier.NoModifier;
	qt_handleMouseEventC(cast(void*) win, &pos, &gpos,
		press ? L : N, // button state after the event
		L,             // the button that changed
		press ? 2 : 3, // QEvent::MouseButtonPress / Release
		M, press ? 10 : 20); // timestamps like QTest/cpp_control
}

private void realMove(QWindow win, double x, double y)
{
	auto pos = QPointF(x, y);
	auto gpos = win.mapToGlobal(pos);
	if (qt_handleMouseEventC is null)
		loadMouseEventHelper();
	int N = cast(int) qt.core.namespace.MouseButton.NoButton;
	int M = cast(int) qt.core.namespace.KeyboardModifier.NoModifier;
	qt_handleMouseEventC(cast(void*) win, &pos, &gpos,
		N, N, 5, // QEvent::MouseMove
		M, 0);
}

int main()
{
	int argc = Runtime.cArgs.argc;
	char** argv = Runtime.cArgs.argv;
	scope app = new QGuiApplication(argc, argv);

	scope engine = new QQmlApplicationEngine;
	auto dir = QCoreApplication.applicationDirPath();
	auto ba0 = dir.toUtf8();
	auto dirS = ba0.data[0 .. ba0.size].idup;
	import std.path : buildNormalizedPath;
	engine.load(QUrl.fromLocalFile(
		toQString(buildNormalizedPath(dirS ~ "/../expandable_list.qml"))));

	// CRITICAL: keep a D reference - a GC root. Dropping it lets the
	// collector free the object while Qt (parent + slot connection) still
	// holds a raw pointer and keeps invoking tick on freed memory.
	// FSU_DROP_ROOT=1 deliberately drops the reference: this reproduces
	// the original crash - and proves that the GC keep-alive fix in
	// qt.core.object (dqtKeepAlive on connect) now covers it.
	__gshared ClickBot gClickBot;
	if (environment.get("FSU_AUTOTEST", null) == "1")
	{
		if (environment.get("FSU_DROP_ROOT", null) == "1")
			new ClickBot(app, engine); // dropped: only Qt holds it now
		else
			gClickBot = new ClickBot(app, engine);
	}

	return app.exec();
}

private QString toQString(string s)
{
	import qt.core.global : qsizetype;
	return QString.fromUtf8(s.ptr, cast(qsizetype) s.length);
}

/// Drives the same click sequence as cpp_control.
final class ClickBot : QObject
{
	mixin(Q_OBJECT_D);

public:
	this(QObject parent = null, QQmlApplicationEngine engine = null)
	{
		super(parent);
		this.engine = engine;
		variant = environment.get("FSU_V3", null) == "1" ? 3
			: environment.get("FSU_V2", null) == "1" ? 2 : 1;
		if (variant == 3)
		{
			// V3: no Qt timer glue at all - a plain D thread drives the
			// injection (window cached once, found before threads start).
			cachedWin = firstVisibleWindow();
			auto t = new Thread(&threadLoop);
			t.isDaemon = true;
			t.start();
			return;
		}
		if (variant == 2)
			cachedWin = firstVisibleWindow(); // V2: allWindows() only once
		timer = cpp_new!QTimer(this);
		timer.setInterval(500);
		QObject.connect(timer.signal!"timeout", this.slot!"tick");
		timer.start();
	}

	private void threadLoop()
	{
		import core.thread : Thread;
		import core.time : msecs;
		foreach (n; 1 .. 9)
		{
			Thread.sleep(500.msecs);
			if (n == 1)
				continue; // let the QML settle
			writeln("D step(thread) ", n);
			realClick(cachedWin, 100, 118, true);
			realClick(cachedWin, 100, 118, false);
			clickIdx++;
		}
		writeln("D-OK (survived ", clickIdx, " thread clicks)");
		QCoreApplication.quit();
	}

	private QWindow firstVisibleWindow()
	{
		auto wins = QGuiApplication.allWindows();
		foreach (i; 0 .. wins.size())
			if (wins[i].isVisible())
				return wins[i];
		return null;
	}

	@QSlot void tick()
	{
		step++;
		writeln("D step ", step);

		QWindow win = cachedWin !is null ? cachedWin : firstVisibleWindow();
		if (win is null)
			return;

		if (environment.get("FSU_AT_FIXED", null).length)
		{
			auto ys = environment.get("FSU_AT_FIXED", null).split(',');
			if (clickIdx >= cast(int) ys.length)
			{
				writeln("D-OK (survived ", clickIdx, " clicks)");
				QCoreApplication.quit();
				return;
			}
			double y = ys[clickIdx].to!double;
			writeln("D click at 100,", y);
			realClick(win, 100, y, true);
			realClick(win, 100, y, false);
			clickIdx++;
		}
		else if (environment.get("FSU_CPPISH", null) == "1")
		{
			// cpp_control-identical stream: no hover moves, click the
			// live row 0 at its real position, QTest timestamps.
			auto map = rowMap();
			if (map.length == 0)
			{
				writeln("D waiting for rows...");
				return;
			}
			auto r = map[0];
			writeln("D (cppish) click row ", r.i, " (", r.name,
				") at ", r.x + 60, ",", r.y);
			realClick(win, r.x + 60, r.y, true);
			realClick(win, r.x + 60, r.y, false);
			clickIdx++;
			if (clickIdx >= 6)
			{
				writeln("D-OK (survived ", clickIdx, " cppish clicks)");
				QCoreApplication.quit();
			}
		}
		else if (step == 1)
			return; // let the QML settle
		else if (step > 8)
		{
			writeln("D-OK (survived ", clickIdx, " clicks)");
			QCoreApplication.quit();
		}
		else
		{
			// click row 0 repeatedly (home -> user -> Documents -> ...)
			realClick(win, 100, 118, true);
			realClick(win, 100, 118, false);
			realMove(win, 125, 126);
			clickIdx++;
			writeln("D clicked row 0 (", clickIdx, ")");
		}
	}

	/// Live row geometry from the QML root object (see expandable_list.qml).
	private struct RowPos
	{
		int i;
		double x, y;
		string name;
		bool dir;
	}

	RowPos[] rowMap()
	{
		import std.json : JSONType, JSONValue, parseJSON;
		import qt.core.variant;
		RowPos[] result;
		if (engine is null || engine.rootObjects().length == 0)
			return result;
		auto root = engine.rootObjects()[0];
		auto v = root.property("rowMapJson");
		auto ba = v.toString().toUtf8();
		auto json = parseJSON(ba.data[0 .. ba.size].idup);
		static double num(ref const JSONValue v)
		{
			if (v.type == JSONType.integer)
				return cast(double) v.integer;
			if (v.type == JSONType.uinteger)
				return cast(double) v.uinteger;
			return v.floating;
		}
		foreach (ref r; json.array)
		{
			RowPos p;
			p.i = cast(int) r.object["i"].integer;
			p.x = num(r.object["x"]);
			p.y = num(r.object["y"]);
			p.name = r.object["name"].str.dup;
			p.dir = r.object["dir"].type == JSONType.true_;
			result ~= p;
		}
		return result;
	}

private:
	QQmlApplicationEngine engine;
	QTimer timer;
	QWindow cachedWin;
	int step;
	int clickIdx;
	int variant;
}
