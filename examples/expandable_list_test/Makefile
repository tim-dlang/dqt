CXXFLAGS := $(shell pkg-config --cflags Qt6Gui Qt6Qml Qt6Quick)
LIBS := $(shell pkg-config --libs Qt6Gui Qt6Qml Qt6Quick)

cpp: cpp_control
	@:

cpp_control: cpp_control.cpp expandable_list.qml
	g++ -std=c++17 -O0 -g $(CXXFLAGS) cpp_control.cpp -o cpp_control $(LIBS)

run-cpp: cpp_control
	MALLOC_CHECK_=3 MALLOC_PERTURB_=165 ./cpp_control

run-d: d-build
	cd d_variant && MALLOC_CHECK_=3 MALLOC_PERTURB_=165 FSU_AUTOTEST=1 ./expandable_list_test

d-build:
	cd d_variant && dub build

clean:
	rm -f cpp_control
	cd d_variant && dub clean || true

.PHONY: cpp run-cpp run-d d-build clean
