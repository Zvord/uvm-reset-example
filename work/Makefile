.PHONY: build run clean

ifdef GUI
QUESTA_CMD:=-visualizer=design.bin -do "onfinish stop"
else
QUESTA_CMD:=-c -do "run -all; quit;"
endif

build:
	qrun \
	-optimize \
	-outdir questa \
	-F ../filelist.f \
	-designfile design.bin \
	-access=rw+/. \
	| ../log-colorizer vsim

run:
	vsim -Ldir questa $(QUESTA_CMD) qrun_opt -qwavedb=+signal+locals | ../log-colorizer uvm

clean:
	ls | grep -xv "Makefile" | xargs rm -r