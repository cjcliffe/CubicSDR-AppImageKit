NPROC := 2

APPIMAGE_TARGET := CubicSDR.AppImage
DEPS := SoapySDR SoapyRemote SoapyRTLSDR SoapyAirspy SoapyAirspyHF SoapyAudio SoapyHackRF SoapyRedPitaya SoapyBladeRF LimeSuite
MODULE_DEPS := rtlsdr libairspy libairspyhf hackrf bladerf 

LimeSuite_REPO := https://github.com/myriadrf/LimeSuite.git

rtlsdr_REPO := https://github.com/rtlsdrblog/rtl-sdr-blog.git
libairspy_REPO := https://github.com/airspy/host.git

libairspyhf_REPO := https://github.com/airspy/airspyhf.git
libairspyhf_FLAGS := -DCMAKE_C_FLAGS=-std=gnu11

hackrf_REPO := https://github.com/mossmann/hackrf.git
hackrf_SRCDIR := /host

bladerf_REPO := https://github.com/Nuand/bladeRF
bladerf_FLAGS := -DCMAKE_C_FLAGS=-std=gnu99
bladerf_SRCDIR := /host

ALL_DEPS := $(DEPS) $(MODULE_DEPS)

.PHONY: all clean $(ALL_DEPS)

all: $(APPIMAGE_TARGET)

$(APPIMAGE_TARGET): AppImageKit CubicSDR $(DEPS)
	rm -rf CubicSDR.AppDir CubicSDR*.AppImage
	mkdir CubicSDR.AppDir
	cp build_stage/CubicSDR/build/CubicSDR.desktop CubicSDR.AppDir/
	cp build_stage/CubicSDR/src/CubicSDR.png CubicSDR.AppDir/
	cp AppImageKit/AppRun-x86_64 CubicSDR.AppDir/AppRun
	chmod +x CubicSDR.AppDir/AppRun
	mkdir -p CubicSDR.AppDir/usr/bin
	mkdir -p CubicSDR.AppDir/usr/local/lib
	mkdir -p CubicSDR.AppDir/usr/local/lib64
	cp -R /usr/local/bin/CubicSDR CubicSDR.AppDir/usr/bin/
	mkdir -p CubicSDR.AppDir/usr/local/share/cubicsdr
	cp -R /usr/local/share/cubicsdr/* CubicSDR.AppDir/usr/local/share/cubicsdr/
	cp -R /usr/local/share/cubicsdr/* CubicSDR.AppDir/usr/bin/
	cp -R /usr/local/lib64/* CubicSDR.AppDir/usr/local/lib64/
	cp -R /usr/local/lib/* CubicSDR.AppDir/usr/local/lib/

	strip CubicSDR.AppDir/usr/bin/CubicSDR
	chmod -R 777 CubicSDR.AppDir
	bash -c ". AppImageKit/functions.sh && cd CubicSDR.AppDir/ && copy_deps"
	# Not sure why this doesn't always work the first time
	chmod -R 777 CubicSDR.AppDir
	bash -c ". AppImageKit/functions.sh && cd CubicSDR.AppDir/ && copy_deps"
	rm -rf CubicSDR.AppDir/usr/lib/libmirsdrapi*
	bash -c ". AppImageKit/functions.sh && cd CubicSDR.AppDir/ && move_lib && delete_blacklisted && patch_usr"
	chmod -R 777 CubicSDR.AppDir

	mv CubicSDR.AppDir/usr/local/lib64/* CubicSDR.AppDir/usr/lib64/
	mv CubicSDR.AppDir/usr/local/lib/* CubicSDR.AppDir/usr/lib/
	mv CubicSDR.AppDir/usr/lib64/SoapySDR CubicSDR.AppDir/usr/local/lib64/SoapySDR
	rm -rf CubicSDR.AppDir/usr/local/lib

	cd CubicSDR.AppDir/ && find usr/ -type f -exec sed -i -e "s|/usr/local|./////////|g" {} \;
	
	chmod +x AppImageKit/appimagetool-x86_64.AppImage
	AppImageKit/appimagetool-x86_64.AppImage CubicSDR.AppDir CubicSDR-`scripts/getCubicSDRVer.sh`-`uname -m`.AppImage



AppImageKit: 
	mkdir -p AppImageKit || true
	cd AppImageKit/ && wget -c https://github.com/AppImage/AppImageKit/releases/download/13/AppRun-x86_64
	cd AppImageKit/ && wget -c https://github.com/AppImage/AppImageKit/releases/download/13/appimagetool-x86_64.AppImage
	wget -q https://github.com/AppImage/AppImages/raw/master/functions.sh -O AppImageKit/functions.sh


CubicSDR: build_status/CubicSDR.built
build_status/CubicSDR.built: SoapySDR liquid-dsp wxWidgets-3.2.1 hamlib 
	scripts/update_repo.sh build_stage/CubicSDR https://github.com/cjcliffe/CubicSDR.git
	mkdir -p build_stage/CubicSDR/build || true
	cmake -S build_stage/CubicSDR -B build_stage/CubicSDR/build -DCMAKE_BUILD_TYPE=Release -DUSE_HAMLIB=1 -DwxWidgets_CONFIG_EXECUTABLE=/vagrant/build_stage/wxWidgets-staticlib/bin/wx-config 
	cd build_stage/CubicSDR/build && make -j$(NPROC) && sudo make install
	touch $@

$(ALL_DEPS): %: build_status/%.built
	@echo "$* is built or up to date"

build_status/%.built: build_stage
	$(eval REPO_VAR_NAME=$*_REPO)
	$(eval REPO_VALUE=$(value ${REPO_VAR_NAME}))
	@if [ -z "$(REPO_VALUE)" ]; then \
		echo "'${REPO_VAR_NAME}' is not set. Using default repo.";\
		scripts/update_repo.sh build_stage/$* https://github.com/pothosware/$*.git;\
	else \
		scripts/update_repo.sh build_stage/$* $(REPO_VALUE);\
	fi
	mkdir -p build_stage/$*/build
	cmake -S build_stage/$*${$*_SRCDIR} -B build_stage/$*/build -DCMAKE_BUILD_TYPE=Release ${$*_FLAGS}
	cd build_stage/$*/build && make -j$(NPROC) && sudo make install
	sudo ldconfig
	touch $@

build_status/SoapyRTLSDR.built: rtlsdr
build_status/SoapyAirspy.built: libairspy
build_status/SoapyAirspyHF.built: libairspyhf
build_status/SoapyHackRF.built: hackrf
build_status/SoapyBladeRF.built: bladerf

SoapySDRPlay: build_status/SoapySDRPlay.built

wxWidgets-3.2.1: build_status/wxWidgets.built
build_status/wxWidgets.built: build_stage
	cd build_stage && wget -N https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.1/wxWidgets-3.2.1.tar.bz2	
	cd build_stage && tar -xvjf wxWidgets-3.2.1.tar.bz2
	cd build_stage/wxWidgets-3.2.1 && ./configure --with-opengl --with-libjpeg --disable-shared --enable-monolithic --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webview --disable-webviewwebkit --prefix=`pwd`/../wxWidgets-staticlib CXXFLAGS="-std=c++0x" --with-libiconv=/usr
	cd build_stage/wxWidgets-3.2.1 && make -j$(NPROC) && make install
	touch $@

liquid-dsp: build_status/liquid-dsp.built
build_status/liquid-dsp.built: build_stage 
	scripts/update_repo.sh build_stage/liquid-dsp https://github.com/jgaeddert/liquid-dsp.git
	cd build_stage/liquid-dsp && ./bootstrap.sh && ./configure && make && sudo make install
	touch $@

hamlib: build_status/hamlib.built
build_status/hamlib.built: build_stage
	scripts/update_repo.sh build_stage/hamlib https://github.com/Hamlib/Hamlib 4.5.5
	cd build_stage/hamlib && ./bootstrap && ./configure && make -j$(NPROC) && sudo make install
	touch $@


build_stage:
	mkdir -p build_stage
	mkdir -p build_status
	chmod +x scripts/*.sh

clean: 
	rm -rf build_stage
	rm -rf build_status
	rm -rf AppImageKit
	rm -rf CubicSDR.AppDir CubicSDR*.AppImage

