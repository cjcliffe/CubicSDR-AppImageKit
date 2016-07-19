all: CubicSDR.AppImage

CubicSDR.AppImage: CubicSDR SoapyRemote SoapyRTLSDR SoapyAirspy SoapyAudio SoapyHackRF SoapyRedPitaya SoapyBladeRF AppImageKit
	rm -rf CubicSDR.AppDir CubicSDR*.AppImage
	mkdir CubicSDR.AppDir
	cp build_stage/CubicSDR/build/CubicSDR.desktop CubicSDR.AppDir/
	cp build_stage/CubicSDR/src/CubicSDR.png CubicSDR.AppDir/
	cp AppImageKit/AppRun CubicSDR.AppDir/
	chmod +x CubicSDR.AppDir/AppRun
	mkdir -p CubicSDR.AppDir/usr/bin
	cp -R build_stage/CubicSDR/build/x64/* CubicSDR.AppDir/usr/bin/ 
	mkdir -p CubicSDR.AppDir/usr/local/lib/
	cp -R /usr/local/lib/SoapySDR CubicSDR.AppDir/usr/local/lib/

	mkdir -p CubicSDR.AppDir/usr/lib
	strip CubicSDR.AppDir/usr/bin/CubicSDR
	. AppImageKit/functions.sh && cd CubicSDR.AppDir/ && copy_deps
	rm -rf CubicSDR.AppDir/usr/local/lib/libmirsdrapi*
	. AppImageKit/functions.sh && cd CubicSDR.AppDir/ && move_lib && delete_blacklisted && patch_usr
	cd CubicSDR.AppDir && mv usr/lib/`uname -m`-linux-gnu/pulseaudio/* usr/lib/`uname -m`-linux-gnu/ && rm -r usr/lib/`uname -m`-linux-gnu/pulseaudio/
	cd CubicSDR.AppDir && mv usr/local/lib/* usr/lib && rm -r usr/local/
	cd CubicSDR.AppDir/ && find usr/ -type f -exec sed -i -e "s|/usr/local|./////////|g" {} \; 
	
	chmod +x AppImageKit/AppImageAssistant
	AppImageKit/AppImageAssistant CubicSDR.AppDir CubicSDR-`scripts/getCubicSDRVer.sh`-`uname -m`.AppImage


AppImageKit/AppImageKit.downloaded:
	mkdir -p AppImageKit || true
	cd AppImageKit/ && wget -c https://github.com/probonopd/AppImageKit/releases/download/5/AppRun
	cd AppImageKit/ && wget -c https://github.com/probonopd/AppImageKit/releases/download/5/AppImageAssistant
	wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O AppImageKit/functions.sh
	touch AppImageKit/AppImageKit.downloaded

AppImageKit: AppImageKit/AppImageKit.downloaded




CubicSDR: SoapySDR liquid-dsp wxWidgets hamlib
	scripts/update_repo.sh build_stage/CubicSDR https://github.com/cjcliffe/CubicSDR.git
	mkdir -p build_stage/CubicSDR/build || true
	cd build_stage/CubicSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DUSE_HAMLIB=1 -DwxWidgets_CONFIG_EXECUTABLE=`pwd`/../../wxWidgets-staticlib/bin/wx-config && make -j2 && sudo make install




SoapySDR: build-stage
	scripts/update_repo.sh build_stage/SoapySDR https://github.com/pothosware/SoapySDR.git maint
	mkdir -p build_stage/SoapySDR/build || true
	cd build_stage/SoapySDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info
	
SoapyRemote: SoapySDR
	scripts/update_repo.sh build_stage/SoapyRemote https://github.com/pothosware/SoapyRemote.git maint
	mkdir -p build_stage/SoapyRemote/build || true
	cd build_stage/SoapyRemote/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyRTLSDR: SoapySDR rtl-sdr
	scripts/update_repo.sh build_stage/SoapyRTLSDR https://github.com/pothosware/SoapyRTLSDR.git
	mkdir -p build_stage/SoapyRTLSDR/build || true
	cd build_stage/SoapyRTLSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyAirspy: SoapySDR libairspy
	scripts/update_repo.sh build_stage/SoapyAirspy https://github.com/pothosware/SoapyAirspy.git
	mkdir -p build_stage/SoapyAirspy/build || true
	cd build_stage/SoapyAirspy/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyAudio: SoapySDR
	scripts/update_repo.sh build_stage/SoapyAudio https://github.com/pothosware/SoapyAudio.git
	mkdir -p build_stage/SoapyAudio/build || true
	cd build_stage/SoapyAudio/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DUSE_HAMLIB=1 && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info


SoapyHackRF: SoapySDR hackrf
	scripts/update_repo.sh build_stage/SoapyHackRF https://github.com/pothosware/SoapyHackRF.git
	mkdir -p build_stage/SoapyHackRF/build || true
	cd build_stage/SoapyHackRF/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyRedPitaya: SoapySDR hackrf
	scripts/update_repo.sh build_stage/SoapyRedPitaya https://github.com/pothosware/SoapyRedPitaya.git
	mkdir -p build_stage/SoapyRedPitaya/build || true
	cd build_stage/SoapyRedPitaya/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyBladeRF: SoapySDR libbladerf
	scripts/update_repo.sh build_stage/SoapyBladeRF https://github.com/pothosware/SoapyBladeRF.git
	mkdir -p build_stage/SoapyBladeRF/build || true
	cd build_stage/SoapyBladeRF/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapySDRPlay: SoapySDR
	scripts/update_repo.sh build_stage/SoapySDRPlay https://github.com/pothosware/SoapySDRPlay.git
	mkdir -p build_stage/SoapySDRPlay/build || true
	cd build_stage/SoapySDRPlay/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info


build_stage/wxWidgets.built:
	cd build_stage && wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2	
	cd build_stage && tar -xvjf wxWidgets-3.1.0.tar.bz2
	cd build_stage/wxWidgets-3.1.0 && ./configure --with-opengl --with-libjpeg --disable-shared --enable-monolithic --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webkit --disable-webview --disable-webviewwebkit --prefix=`pwd`/../wxWidgets-staticlib CXXFLAGS="-std=c++0x" --with-libiconv=/usr
	cd build_stage/wxWidgets-3.1.0 && make -j4 && make install
	touch build_stage/wxWidgets.built

wxWidgets: build_stage/wxWidgets.built


build_stage/liquid-dsp.built: build-stage
	scripts/update_repo.sh build_stage/liquid-dsp https://github.com/jgaeddert/liquid-dsp.git
	cd build_stage/liquid-dsp && ./bootstrap.sh && ./configure && make && sudo make install
	sudo ldconfig
	touch build_stage/liquid-dsp.built

liquid-dsp: build_stage/liquid-dsp.built	


build_stage/rtl-sdr.built: build-stage
	scripts/update_repo.sh build_stage/rtl-sdr git://git.osmocom.org/rtl-sdr.git
	mkdir -p build_stage/rtl-sdr/build || true
	cd build_stage/rtl-sdr/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/rtl-sdr.built

rtl-sdr: build_stage/rtl-sdr.built


build_stage/libairspy.built: build-stage
	scripts/update_repo.sh build_stage/libairspy https://github.com/airspy/host.git
	mkdir -p build_stage/libairspy/build || true
	cd build_stage/libairspy/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/libairspy.built

libairspy: build_stage/libairspy.built


build_stage/hackrf.built: build-stage
	scripts/update_repo.sh build_stage/hackrf https://github.com/mossmann/hackrf.git
	mkdir -p build_stage/hackrf/host/build || true
	cd build_stage/hackrf/host/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/hackrf.built

hackrf: build_stage/hackrf.built


build_stage/libbladerf.built: build-stage
	scripts/update_repo.sh build_stage/bladerf https://github.com/Nuand/bladeRF
	mkdir -p build_stage/bladerf/host/build || true
	cd build_stage/bladerf/host/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/libbladerf.built

libbladerf: build_stage/libbladerf.built


build_stage/hamlib.built: build-stage
	scripts/update_repo.sh build_stage/hamlib https://github.com/N0NB/hamlib.git
	cd build_stage/hamlib && ./autogen.sh && ./configure && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/hamlib.built

hamlib: build_stage/hamlib.built


build_stage/prepped:
	mkdir build_stage || true
	chmod +x scripts/*.sh
	touch build_stage/prepped
	

build-stage: build_stage/prepped

clean: 
	rm -rf build_stage
	rm -rf AppImageKit

	
