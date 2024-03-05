TOPDIR = ..
LLVMSRC = llvm-15.0.7.src
LLVMDEV := llvm-15-release+assert
LLVMREL := llvm-15-release

all: $(LLVMDEV).tar.xz $(LLVMREL).tar.xz

$(LLVMDEV).tar.xz: $(LLVMSRC).tar.xz
	bash build_llvm.sh dev
	tar cfJ $(LLVMDEV).tar.xz $(LLVMDEV)

$(LLVMREL).tar.xz: $(LLVMSRC).tar.xz
	bash build_llvm.sh opt
	tar cfJ $(LLVMREL).tar.xz $(LLVMREL)

$(LLVMSRC).tar.xz:
	wget https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz

wipe:
	rm -rf llvm-15-release* llvm-15-release+assert* cmake

.PHONY: all clean format wipe

.NOTPARALLEL:

