all: CubicSDR.AppImage

CubicSDR.AppImage: CubicSDR SoapyRemote SoapyRTLSDR AppImageKit
	rm -rf CubicSDR.AppDir CubicSDR.AppImage
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
	. AppImageKit/functions.sh && cd CubicSDR.AppDir/ && copy_deps && move_lib && delete_blacklisted && patch_usr
	cd CubicSDR.AppDir && mv usr/lib/x86_64-linux-gnu/pulseaudio/* usr/lib/x86_64-linux-gnu/ && rm -r usr/lib/x86_64-linux-gnu/pulseaudio/
	cd CubicSDR.AppDir && mv usr/local/lib/* usr/lib && rm -r usr/local/
	cd CubicSDR.AppDir/ && find usr/ -type f -exec sed -i -e "s|/usr/local|./////////|g" {} \; 
	
	chmod +x AppImageKit/AppImageAssistant
	AppImageKit/AppImageAssistant CubicSDR.AppDir CubicSDR.AppImage


clean: 
	rm -rf build_stage

build-stage: 
	mkdir build_stage || true
	chmod +x scripts/*.sh

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
	
build_stage/rtl-sdr.built: build-stage
	scripts/update_repo.sh build_stage/rtl-sdr git://git.osmocom.org/rtl-sdr.git
	mkdir -p build_stage/rtl-sdr/build || true
	cd build_stage/rtl-sdr/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	touch build_stage/rtl-sdr.built

rtl-sdr: build_stage/rtl-sdr.built

SoapyRTLSDR: SoapySDR rtl-sdr
	scripts/update_repo.sh build_stage/SoapyRTLSDR https://github.com/pothosware/SoapyRTLSDR.git
	mkdir -p build_stage/SoapyRTLSDR/build || true
	cd build_stage/SoapyRTLSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release && make -j4 && sudo make install
	sudo ldconfig
	SoapySDRUtil --info

build_stage/liquid-dsp.built: build-stage
	scripts/update_repo.sh build_stage/liquid-dsp https://github.com/jgaeddert/liquid-dsp.git
	cd build_stage/liquid-dsp && ./bootstrap.sh && ./configure && make && sudo make install
	sudo ldconfig
	touch build_stage/liquid-dsp.built

liquid-dsp: build_stage/liquid-dsp.built	

build_stage/wxWidgets.built:
	cd build_stage && wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2	
	cd build_stage && tar -xvjf wxWidgets-3.1.0.tar.bz2
	cd build_stage/wxWidgets-3.1.0 && ./configure --with-opengl --with-libjpeg --disable-shared --enable-monolithic --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webkit --disable-webview --disable-webviewwebkit --prefix=`pwd`/../wxWidgets-staticlib CXXFLAGS="-std=c++0x" --with-libiconv=/usr
	cd build_stage/wxWidgets-3.1.0 && make -j4 && make install
	touch build_stage/wxWidgets.built

wxWidgets: build_stage/wxWidgets.built

CubicSDR: SoapySDR liquid-dsp wxWidgets
	scripts/update_repo.sh build_stage/CubicSDR https://github.com/cjcliffe/CubicSDR.git
	mkdir -p build_stage/CubicSDR/build || true
	cd build_stage/CubicSDR/build && cmake ../ -DCMAKE_BUILD_TARGET=Release -DwxWidgets_CONFIG_EXECUTABLE=`pwd`/../../wxWidgets-staticlib/bin/wx-config && make -j2 && sudo make install

AppImageKit/AppImageKit.downloaded:
	mkdir -p AppImageKit || true
	cd AppImageKit/ && wget -c https://github.com/probonopd/AppImageKit/releases/download/5/AppRun
	cd AppImageKit/ && wget -c https://github.com/probonopd/AppImageKit/releases/download/5/AppImageAssistant
	wget -q https://github.com/probonopd/AppImages/raw/master/functions.sh -O AppImageKit/functions.sh
	touch AppImageKit/AppImageKit.downloaded

AppImageKit: AppImageKit/AppImageKit.downloaded

	
