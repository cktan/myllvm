TOPDIR = ..
LLVMSRCTARXZ = llvm-15.0.7.src.tar.xz
LLVMDEV := llvm-15-release+assert
LLVMOPT := llvm-15-release

all: $(LLVMDEV).tar.xz $(LLVMOPT).tar.xz

$(LLVMDEV).tar.xz: $(LLVMSRCTARXZ)
	echo building dev
	bash build_llvm.sh dev
	tar cfJ $@ $(LLVMDEV)

$(LLVMOPT).tar.xz: $(LLVMSRCTARXZ)
	echo building opt
	bash build_llvm.sh opt
	tar cfJ $@ $(LLVMOPT)

$(LLVMSRCTARXZ):
	wget https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz

wipe:
	rm -rf llvm-15-release* llvm-15-release+assert* cmake

.PHONY: all clean format wipe

.NOTPARALLEL:

