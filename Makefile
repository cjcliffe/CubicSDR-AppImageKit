all: CubicSDR.AppImage

CubicSDR.AppImage: CubicSDR SoapyRemote SoapyRTLSDR SoapyAirspy SoapyAudio SoapyHackRF SoapyRedPitaya SoapyBladeRF AppImageKit
	rm -rf CubicSDR.AppDir CubicSDR*.AppImage
	mkdir CubicSDR.AppDir
	cp build_stage/CubicSDR/build/CubicSDR.desktop CubicSDR.AppDir/
	cp build_stage/CubicSDR/src/CubicSDR.png CubicSDR.AppDir/
	cp AppImageKit/AppRun CubicSDR.AppDir/
	chmod +x CubicSDR.AppDir/AppRun
	mkdir -p CubicSDR.AppDir/usr/bin
	cp -R /usr/local/bin/CubicSDR CubicSDR.AppDir/usr/bin/ 
	cp -R /usr/local/share/cubicsdr/* CubicSDR.AppDir/usr/bin/ 
	mkdir -p CubicSDR.AppDir/usr/local/lib/
	cp -R /usr/local/lib/SoapySDR CubicSDR.AppDir/usr/local/lib/

	mkdir -p CubicSDR.AppDir/usr/lib
	strip CubicSDR.AppDir/usr/bin/CubicSDR
	bash -c ". AppImageKit/functions.sh && cd CubicSDR.AppDir/ && copy_deps"
	rm -rf CubicSDR.AppDir/usr/local/lib/libmirsdrapi*
	bash -c ". AppImageKit/functions.sh && cd CubicSDR.AppDir/ && move_lib && delete_blacklisted && patch_usr"
	cd CubicSDR.AppDir && mv usr/lib/`uname -m`-linux-gnu/pulseaudio/* usr/lib/`uname -m`-linux-gnu/ && rm -r usr/lib/`uname -m`-linux-gnu/pulseaudio/
	cd CubicSDR.AppDir && mv usr/local/lib/* usr/lib && rm -r usr/local/
	cd CubicSDR.AppDir/ && find usr/ -type f -exec sed -i -e "s|/usr/local|./////////|g" {} \; 
	
	chmod +x AppImageKit/AppImageAssistant
	AppImageKit/AppImageAssistant CubicSDR.AppDir CubicSDR-`scripts/getCubicSDRVer.sh`-`uname -m`.AppImage


AppImageKit: 
	mkdir -p AppImageKit || true
	cd AppImageKit/ && wget -c https://github.com/AppImage/AppImageKit/releases/download/5/AppRun
	cd AppImageKit/ && wget -c https://github.com/AppImage/AppImageKit/releases/download/5/AppImageAssistant
	wget -q https://github.com/AppImage/AppImages/raw/master/functions.sh -O AppImageKit/functions.sh



CubicSDR: SoapySDR build_stage/liquid-dsp build_stage/wxWidgets-3.1.1 build_stage/hamlib
	scripts/update_repo.sh build_stage/CubicSDR https://github.com/cjcliffe/CubicSDR.git
	mkdir -p build_stage/CubicSDR/build || true
	cd build_stage/CubicSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DUSE_HAMLIB=1 -DwxWidgets_CONFIG_EXECUTABLE=`pwd`/../../wxWidgets-staticlib/bin/wx-config && make -j2 && sudo make install




SoapySDR: build_stage
	scripts/update_repo.sh build_stage/SoapySDR https://github.com/pothosware/SoapySDR.git
	mkdir -p build_stage/SoapySDR/build || true
	cd build_stage/SoapySDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info
	
SoapyRemote: SoapySDR
	scripts/update_repo.sh build_stage/SoapyRemote https://github.com/pothosware/SoapyRemote.git
	mkdir -p build_stage/SoapyRemote/build || true
	cd build_stage/SoapyRemote/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyRTLSDR: SoapySDR build_stage/rtl-sdr
	scripts/update_repo.sh build_stage/SoapyRTLSDR https://github.com/pothosware/SoapyRTLSDR.git
	mkdir -p build_stage/SoapyRTLSDR/build || true
	cd build_stage/SoapyRTLSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyAirspy: SoapySDR build_stage/libairspy
	scripts/update_repo.sh build_stage/SoapyAirspy https://github.com/pothosware/SoapyAirspy.git
	mkdir -p build_stage/SoapyAirspy/build || true
	cd build_stage/SoapyAirspy/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyAudio: SoapySDR build_stage/hamlib
	scripts/update_repo.sh build_stage/SoapyAudio https://github.com/pothosware/SoapyAudio.git
	mkdir -p build_stage/SoapyAudio/build || true
	cd build_stage/SoapyAudio/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DUSE_HAMLIB=1 && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info


SoapyHackRF: SoapySDR build_stage/hackrf
	scripts/update_repo.sh build_stage/SoapyHackRF https://github.com/pothosware/SoapyHackRF.git
	mkdir -p build_stage/SoapyHackRF/build || true
	cd build_stage/SoapyHackRF/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyRedPitaya: SoapySDR
	scripts/update_repo.sh build_stage/SoapyRedPitaya https://github.com/pothosware/SoapyRedPitaya.git
	mkdir -p build_stage/SoapyRedPitaya/build || true
	cd build_stage/SoapyRedPitaya/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

SoapyBladeRF: SoapySDR build_stage/bladerf
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




build_stage/wxWidgets-3.1.1:
	cd build_stage && wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.1/wxWidgets-3.1.1.tar.bz2	
	cd build_stage && tar -xvjf wxWidgets-3.1.1.tar.bz2
	cd build_stage/wxWidgets-3.1.1 && ./configure --with-opengl --with-libjpeg --disable-shared --enable-monolithic --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webkit --disable-webview --disable-webviewwebkit --prefix=`pwd`/../wxWidgets-staticlib CXXFLAGS="-std=c++0x" --with-libiconv=/usr
	cd build_stage/wxWidgets-3.1.1 && make -j4 && make install

build_stage/liquid-dsp: build_stage
	scripts/update_repo.sh build_stage/liquid-dsp https://github.com/jgaeddert/liquid-dsp.git
	cd build_stage/liquid-dsp && ./bootstrap.sh && ./configure && make && sudo make install
	sudo ldconfig

build_stage/rtl-sdr: build_stage
	scripts/update_repo.sh build_stage/rtl-sdr git://git.osmocom.org/rtl-sdr.git
	mkdir -p build_stage/rtl-sdr/build || true
	cd build_stage/rtl-sdr/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig

build_stage/libairspy: build_stage
	scripts/update_repo.sh build_stage/libairspy https://github.com/airspy/host.git
	mkdir -p build_stage/libairspy/build || true
	cd build_stage/libairspy/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig

build_stage/hackrf: build_stage
	scripts/update_repo.sh build_stage/hackrf https://github.com/mossmann/hackrf.git
	mkdir -p build_stage/hackrf/host/build || true
	cd build_stage/hackrf/host/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig

build_stage/bladerf: build_stage
	scripts/update_repo.sh build_stage/bladerf https://github.com/Nuand/bladeRF
	mkdir -p build_stage/bladerf/host/build || true
	cd build_stage/bladerf/host/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DCMAKE_C_FLAGS="-std=gnu99" && make -j4 && sudo make install
	sudo ldconfig

build_stage/hamlib: build_stage
	scripts/update_repo.sh build_stage/hamlib https://github.com/N0NB/hamlib.git
	cd build_stage/hamlib && ./bootstrap && ./configure && make -j4 && sudo make install
	sudo ldconfig





build_stage:
	mkdir build_stage || true
	chmod +x scripts/*.sh

clean: 
	rm -rf build_stage
	rm -rf AppImageKit

	

