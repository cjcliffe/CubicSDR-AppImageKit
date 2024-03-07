NPROC := $(nproc --all)
SOAPY_ABI_VERSION := $((shell sed -n 's/^\#define SOAPY_SDR_ABI_VERSION "\([0-9\.-]*\)"/\1/p' /usr/local/include/SoapySDR/Version.h)
SOAPY_MOD_PATH := /usr/local/lib/SoapySDR/modules$(SOAPY_ABI_VERSION)

all: CubicSDR.AppImage

CubicSDR.AppImage: CubicSDR SoapyRemote SoapyRTLSDR SoapyAirspy SoapyAirspyHF SoapyAudio SoapyHackRF SoapyRedPitaya SoapyBladeRF AppImageKit LimeSuite
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


# Macro for for cloning, building, and installing with CMake
define BUILD_AND_INSTALL
	scripts/update_repo.sh build_stage/$(1) $(2)
	mkdir -p build_stage/$(1)/build
	cmake -S build_stage/$(1) -B build_stage/$(1)/build -DCMAKE_BUILD_TYPE=Release $(3)
	cd build_stage/$(1)/build && make -j${NPROC} && sudo make install
	sudo ldconfig
endef

CubicSDR: SoapySDR /usr/local/bin/CubicSDR
/usr/local/bin/CubicSDR: build_stage/liquid-dsp build_stage/wxWidgets-3.2.1 build_stage/hamlib 
	scripts/update_repo.sh build_stage/CubicSDR https://github.com/cjcliffe/CubicSDR.git
	mkdir -p build_stage/CubicSDR/build || true
	cmake -S build_stage/CubicSDR -B build_stage/CubicSDR/build -DCMAKE_BUILD_TYPE=Release -DUSE_HAMLIB=1 -DwxWidgets_CONFIG_EXECUTABLE=`pwd`/../../wxWidgets-staticlib/bin/wx-config 
	cd build_stage/CubicSDR/build && make -j${NPROC} && sudo make install

SoapySDR: /usr/local/lib64/libSoapySDR.so
/usr/local/lib64/libSoapySDR.so: build_stage
	$(call BUILD_AND_INSTALL,SoapySDR,https://github.com/pothosware/SoapySDR.git)
	
SoapyRemote: $(SOAPY_MOD_PATH)/libremoteSupport.so
$(SOAPY_MOD_PATH)/libremoteSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyRemote,https://github.com/pothosware/SoapyRemote.git)

SoapyRTLSDR: build_stage/rtl-sdr $(SOAPY_MOD_PATH)/librtlsdrSupport.so
$(SOAPY_MOD_PATH)/librtlsdrSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyRTLSDR,https://github.com/pothosware/SoapyRTLSDR.git)

SoapyAirspy: build_stage/libairspy $(SOAPY_MOD_PATH)/libairspySupport.so
$(SOAPY_MOD_PATH)/libairspySupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyAirspy,https://github.com/pothosware/SoapyAirspy.git)

SoapyAirspyHF: build_stage/libairspyhf $(SOAPY_MOD_PATH)/libairspyhfSupport.so
$(SOAPY_MOD_PATH)/libairspyhfSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyAirspyHF,https://github.com/pothosware/SoapyAirspyHF.git)

SoapyAudio: build_stage/hamlib $(SOAPY_MOD_PATH)/libaudioSupport.so
$(SOAPY_MOD_PATH)/libaudioSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyAudio,https://github.com/pothosware/SoapyAudio.git)

SoapyHackRF: build_stage/hackrf $(SOAPY_MOD_PATH)/libHackRFSupport.so
$(SOAPY_MOD_PATH)/libHackRFSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyHackRF,https://github.com/pothosware/SoapyHackRF.git)

SoapyRedPitaya: $(SOAPY_MOD_PATH)/libRedPitaya.so
$(SOAPY_MOD_PATH)/libRedPitaya.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyRedPitaya,https://github.com/pothosware/SoapyRedPitaya.git)

SoapyBladeRF: build_stage/bladerf $(SOAPY_MOD_PATH)/libbladeRFSupport.so
$(SOAPY_MOD_PATH)/libbladeRFSupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapyBladeRF,https://github.com/pothosware/libbladeRFSupport.git)

SoapySDRPlay: $(SOAPY_MOD_PATH)/libsdrPlaySupport.so
$(SOAPY_MOD_PATH)/libsdrPlaySupport.so: SoapySDR
	$(call BUILD_AND_INSTALL,SoapySDRPlay,https://github.com/pothosware/SoapySDRPlay.git)

LimeSuite: $(SOAPY_MOD_PATH)/libLMS7Support.so
$(SOAPY_MOD_PATH)/libLMS7Support.so: SoapySDR
	$(call BUILD_AND_INSTALL,LimeSuite,https://github.com/myriadrf/LimeSuite.git)


build_stage/wxWidgets-3.2.1:
	cd build_stage && wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.2.1/wxWidgets-3.2.1.tar.bz2	
	cd build_stage && tar -xvjf wxWidgets-3.2.1.tar.bz2
	cd build_stage/wxWidgets-3.2.1 && ./configure --with-opengl --with-libjpeg --disable-shared --enable-monolithic --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webview --disable-webviewwebkit --prefix=`pwd`/../wxWidgets-staticlib CXXFLAGS="-std=c++0x" --with-libiconv=/usr
	cd build_stage/wxWidgets-3.2.1 && make -j4 && make install

build_stage/liquid-dsp: /usr/local/lib/libliquid.so
/usr/local/lib/libliquid.so: build_stage
	scripts/update_repo.sh build_stage/liquid-dsp https://github.com/jgaeddert/liquid-dsp.git
	cd build_stage/liquid-dsp && ./bootstrap.sh && ./configure && make && sudo make install

build_stage/rtl-sdr: /usr/local/lib64/librtlsdr.so
/usr/local/lib64/librtlsdr.so: build_stage
	$(call BUILD_AND_INSTALL,rtl-sdr,https://github.com/rtlsdrblog/rtl-sdr-blog.git)

build_stage/libairspy: /usr/local/lib/libairspy.so
/usr/local/lib/libairspy.so: build_stage
	$(call BUILD_AND_INSTALL,libairspy,https://github.com/airspy/host.git)

build_stage/libairspyhf: /usr/local/lib/libairspyhf.so
/usr/local/lib/libairspyhf.so: build_stage
	$(call BUILD_AND_INSTALL,libairspyhf,https://github.com/airspy/host.git,"-DCMAKE_C_FLAGS=-std=gnu11")

build_stage/hackrf: /usr/local/lib/libhackrf.so
/usr/local/lib/libhackrf.so: build_stage
	$(call BUILD_AND_INSTALL,hackrf,https://github.com/mossmann/hackrf.git)

build_stage/bladerf: /usr/local/lib64/libbladeRF.so
/usr/local/lib64/libbladeRF.so: build_stage
	$(call BUILD_AND_INSTALL,bladerf,https://github.com/Nuand/bladeRF,"-DCMAKE_C_FLAGS=-std=gnu99")

build_stage/hamlib: /usr/local/lib/libhamlib.so
/usr/local/lib/libhamlib.so: build_stage
	scripts/update_repo.sh build_stage/hamlib https://github.com/Hamlib/Hamlib 4.5.5
	cd build_stage/hamlib && ./bootstrap && ./configure && make -j4 && sudo make install





build_stage:
	mkdir build_stage || true
	chmod +x scripts/*.sh

clean: 
	rm -rf build_stage
	rm -rf AppImageKit

