TCL_VERSION = 8.6.15
TCL_TARBALL = $(DOWNLOAD)/tcl$(TCL_VERSION)-src.tar.gz
TCL_URL = https://prdownloads.sourceforge.net/tcl/tcl$(TCL_VERSION)-src.tar.gz

.PHONY: tcl
tcl: $(TCL_WASM_LIB)

$(TCL_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget -q -O $@ $(TCL_URL)

$(TCL_WASM_LIB): $(TCL_TARBALL)
	rm -rf $(BUILD)/tcl$(TCL_VERSION)
	mkdir -p $(BUILD)/tcl$(TCL_VERSION)/build
	tar -C $(BUILD) -xf $(TCL_TARBALL)
	cd $(BUILD)/tcl$(TCL_VERSION)/build && \
	  emconfigure ../unix/configure \
	    --enable-shared=no \
	    --enable-static=yes \
	    --disable-dll-unloading \
	    --prefix=$(WASM) && \
	  emmake make install

# `make install` also writes `tclConfig.sh` under `$(WASM)/lib`.
$(TCL_WASM_CONFIG): $(TCL_WASM_LIB)
	@:
