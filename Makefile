export MCC=$(MATLABDIR)/bin/mcc
export MEX=$(MATLABDIR)/bin/mex
export MFLAGS=-m -R -singleCompThread -R -nodisplay -R -nojvm
TOP := $(shell pwd)
SRCTAR=source_code.tar.gz
SRC=src
DEP=dependencies
DATA=data
RSA_TOOLBOX_MODULES=$(DEP)/rsatoolbox/Modules
RSA_TOOLBOX_ENGINES=$(DEP)/rsatoolbox/Engines
SPM12_MINIMAL=$(DEP)/spm12_minimal
INCL= -N -p ${MATLABDIR}/toolbox/stats/stats -I $(SRC) -I $(RSA_TOOLBOX_ENGINES) -I $(RSA_TOOLBOX_MODULES) -I $(SPM12_MINIMAL)
.PHONEY: all clean-all clean-postbuild sdist

all: setup RSA_Toolbox_Analysis clean-postbuild

setup:
	tar xzvf $(SRCTAR)

RSA_Toolbox_Analysis: $(SRC)/RSA_Toolbox_Analysis.m
	$(MCC) -v $(MFLAGS) $(INCL) -a $(DATA) -o $@ $<

clean-postbuild:
	-rm *.dmr
	-rm mccExcludedFiles.log
	-rm readme.txt

sdist:
	tar czhf $(SRCTAR) src dependencies data

clean-all:
	-rm RSA_Toolbox_Analysis
	-rm $(DEP)
	-rm $(DATA)
	-rm $(SRC)
	-rm requiredMCRProducts.txt
	-rm build-csf-RSA_Toolbox_Analysis.sh.e*
	-rm build-csf-RSA_Toolbox_Analysis.sh.o*
