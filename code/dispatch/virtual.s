	.file	"virtual.cpp"
# GNU C++14 (Ubuntu 9.4.0-1ubuntu1~20.04.1) version 9.4.0 (x86_64-linux-gnu)
#	compiled by GNU C version 9.4.0, GMP version 6.2.0, MPFR version 4.0.2, MPC version 1.1.0, isl version isl-0.22.1-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -imultiarch x86_64-linux-gnu -D_GNU_SOURCE virtual.cpp
# -mtune=generic -march=x86-64 -fverbose-asm -fasynchronous-unwind-tables
# -fstack-protector-strong -Wformat -Wformat-security
# -fstack-clash-protection -fcf-protection
# options enabled:  -fPIC -fPIE -faggressive-loop-optimizations
# -fassume-phsa -fasynchronous-unwind-tables -fauto-inc-dec -fcommon
# -fdelete-null-pointer-checks -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -fexceptions -ffp-int-builtin-inexact
# -ffunction-cse -fgcse-lm -fgnu-runtime -fgnu-unique -fident
# -finline-atomics -fipa-stack-alignment -fira-hoist-pressure
# -fira-share-save-slots -fira-share-spill-slots -fivopts
# -fkeep-static-consts -fleading-underscore -flifetime-dse
# -flto-odr-type-merging -fmath-errno -fmerge-debug-strings -fpeephole
# -fplt -fprefetch-loop-arrays -freg-struct-return
# -fsched-critical-path-heuristic -fsched-dep-count-heuristic
# -fsched-group-heuristic -fsched-interblock -fsched-last-insn-heuristic
# -fsched-rank-heuristic -fsched-spec -fsched-spec-insn-heuristic
# -fsched-stalled-insns-dep -fschedule-fusion -fsemantic-interposition
# -fshow-column -fshrink-wrap-separate -fsigned-zeros
# -fsplit-ivs-in-unroller -fssa-backprop -fstack-clash-protection
# -fstack-protector-strong -fstdarg-opt -fstrict-volatile-bitfields
# -fsync-libcalls -ftrapping-math -ftree-cselim -ftree-forwprop
# -ftree-loop-if-convert -ftree-loop-im -ftree-loop-ivcanon
# -ftree-loop-optimize -ftree-parallelize-loops= -ftree-phiprop
# -ftree-reassoc -ftree-scev-cprop -funit-at-a-time -funwind-tables
# -fverbose-asm -fzero-initialized-in-bss -m128bit-long-double -m64 -m80387
# -malign-stringops -mavx256-split-unaligned-load
# -mavx256-split-unaligned-store -mfancy-math-387 -mfp-ret-in-387 -mfxsr
# -mglibc -mieee-fp -mlong-double-80 -mmmx -mno-sse4 -mpush-args -mred-zone
# -msse -msse2 -mstv -mtls-direct-seg-refs -mvzeroupper

	.text
	.section	.rodata
	.type	_ZStL19piecewise_construct, @object
	.size	_ZStL19piecewise_construct, 1
_ZStL19piecewise_construct:
	.zero	1
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
.LC0:
	.string	"????"
	.section	.text._ZNK6Animal9makeNoiseEv,"axG",@progbits,_ZNK6Animal9makeNoiseEv,comdat
	.align 2
	.weak	_ZNK6Animal9makeNoiseEv
	.type	_ZNK6Animal9makeNoiseEv, @function
_ZNK6Animal9makeNoiseEv:
.LFB1522:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:6:         std::cout << "????" << std::endl;
	leaq	.LC0(%rip), %rsi	#,
	leaq	_ZSt4cout(%rip), %rdi	#,
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT	#
	movq	%rax, %rdx	#, _1
# virtual.cpp:6:         std::cout << "????" << std::endl;
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax	#, tmp83
	movq	%rax, %rsi	# tmp83,
	movq	%rdx, %rdi	# _1,
	call	_ZNSolsEPFRSoS_E@PLT	#
# virtual.cpp:7:     }
	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1522:
	.size	_ZNK6Animal9makeNoiseEv, .-_ZNK6Animal9makeNoiseEv
	.section	.text._ZNK6Animal2idEv,"axG",@progbits,_ZNK6Animal2idEv,comdat
	.align 2
	.weak	_ZNK6Animal2idEv
	.type	_ZNK6Animal2idEv, @function
_ZNK6Animal2idEv:
.LFB1523:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:11:         return 0;
	movl	$0, %eax	#, _1
# virtual.cpp:12:     }
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1523:
	.size	_ZNK6Animal2idEv, .-_ZNK6Animal2idEv
	.section	.rodata
.LC1:
	.string	"Meow :3"
	.section	.text._ZNK3Cat9makeNoiseEv,"axG",@progbits,_ZNK3Cat9makeNoiseEv,comdat
	.align 2
	.weak	_ZNK3Cat9makeNoiseEv
	.type	_ZNK3Cat9makeNoiseEv, @function
_ZNK3Cat9makeNoiseEv:
.LFB1524:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:19:         std::cout << "Meow :3" << std::endl;
	leaq	.LC1(%rip), %rsi	#,
	leaq	_ZSt4cout(%rip), %rdi	#,
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT	#
	movq	%rax, %rdx	#, _1
# virtual.cpp:19:         std::cout << "Meow :3" << std::endl;
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax	#, tmp83
	movq	%rax, %rsi	# tmp83,
	movq	%rdx, %rdi	# _1,
	call	_ZNSolsEPFRSoS_E@PLT	#
# virtual.cpp:20:     }
	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1524:
	.size	_ZNK3Cat9makeNoiseEv, .-_ZNK3Cat9makeNoiseEv
	.section	.text._ZNK3Cat2idEv,"axG",@progbits,_ZNK3Cat2idEv,comdat
	.align 2
	.weak	_ZNK3Cat2idEv
	.type	_ZNK3Cat2idEv, @function
_ZNK3Cat2idEv:
.LFB1525:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:23:         return 1;
	movl	$1, %eax	#, _1
# virtual.cpp:24:     }
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1525:
	.size	_ZNK3Cat2idEv, .-_ZNK3Cat2idEv
	.section	.text._ZN6AnimalC2Ev,"axG",@progbits,_ZN6AnimalC5Ev,comdat
	.align 2
	.weak	_ZN6AnimalC2Ev
	.type	_ZN6AnimalC2Ev, @function
_ZN6AnimalC2Ev:
.LFB1529:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:3: class Animal {
	leaq	16+_ZTV6Animal(%rip), %rdx	#, _1
	movq	-8(%rbp), %rax	# this, tmp83
	movq	%rdx, (%rax)	# _1, this_3(D)->_vptr.Animal
	nop	
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1529:
	.size	_ZN6AnimalC2Ev, .-_ZN6AnimalC2Ev
	.weak	_ZN6AnimalC1Ev
	.set	_ZN6AnimalC1Ev,_ZN6AnimalC2Ev
	.section	.text._ZN3CatC2Ev,"axG",@progbits,_ZN3CatC5Ev,comdat
	.align 2
	.weak	_ZN3CatC2Ev
	.type	_ZN3CatC2Ev, @function
_ZN3CatC2Ev:
.LFB1531:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movq	%rdi, -8(%rbp)	# this, this
# virtual.cpp:15: class Cat : public Animal {
	movq	-8(%rbp), %rax	# this, _1
	movq	%rax, %rdi	# _1,
	call	_ZN6AnimalC2Ev	#
	leaq	16+_ZTV3Cat(%rip), %rdx	#, _2
	movq	-8(%rbp), %rax	# this, tmp84
	movq	%rdx, (%rax)	# _2, this_3(D)->D.36383._vptr.Animal
	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1531:
	.size	_ZN3CatC2Ev, .-_ZN3CatC2Ev
	.weak	_ZN3CatC1Ev
	.set	_ZN3CatC1Ev,_ZN3CatC2Ev
	.text
	.globl	main
	.type	main, @function
main:
.LFB1526:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	pushq	%rbx	#
	subq	$24, %rsp	#,
	.cfi_offset 3, -24
# virtual.cpp:29:     Cat* cat = new Cat();
	movl	$8, %edi	#,
	call	_Znwm@PLT	#
	movq	%rax, %rbx	# tmp93, _11
	movq	$0, (%rbx)	#, MEM[(struct Cat *)_12].D.36383._vptr.Animal
	movq	%rbx, %rdi	# _11,
	call	_ZN3CatC1Ev	#
	movq	%rbx, -32(%rbp)	# _11, cat
# virtual.cpp:30:     Animal* animalCat = (Animal*) cat;
	movq	-32(%rbp), %rax	# cat, tmp94
	movq	%rax, -24(%rbp)	# tmp94, animalCat
# virtual.cpp:32:     std::cout << cat->id() << std::endl;
	movq	-32(%rbp), %rax	# cat, tmp95
	movq	%rax, %rdi	# tmp95,
	call	_ZNK3Cat2idEv	#
	movl	%eax, %esi	# _1,
	leaq	_ZSt4cout(%rip), %rdi	#,
	call	_ZNSolsEi@PLT	#
	movq	%rax, %rdx	#, _2
# virtual.cpp:32:     std::cout << cat->id() << std::endl;
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax	#, tmp96
	movq	%rax, %rsi	# tmp96,
	movq	%rdx, %rdi	# _2,
	call	_ZNSolsEPFRSoS_E@PLT	#
# virtual.cpp:36:     std::cout << animalCat->id() << std::endl;
	movq	-24(%rbp), %rax	# animalCat, tmp97
	movq	%rax, %rdi	# tmp97,
	call	_ZNK6Animal2idEv	#
	movl	%eax, %esi	# _3,
	leaq	_ZSt4cout(%rip), %rdi	#,
	call	_ZNSolsEi@PLT	#
	movq	%rax, %rdx	#, _4
# virtual.cpp:36:     std::cout << animalCat->id() << std::endl;
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax	#, tmp98
	movq	%rax, %rsi	# tmp98,
	movq	%rdx, %rdi	# _4,
	call	_ZNSolsEPFRSoS_E@PLT	#
# virtual.cpp:40:     cat->makeNoise();
	movq	-32(%rbp), %rax	# cat, tmp99
	movq	(%rax), %rax	# cat_15->D.36383._vptr.Animal, _5
	movq	(%rax), %rdx	# *_5, _6
# virtual.cpp:40:     cat->makeNoise();
	movq	-32(%rbp), %rax	# cat, tmp100
	movq	%rax, %rdi	# tmp100,
	call	*%rdx	# _6
# virtual.cpp:44:     animalCat->makeNoise();
	movq	-24(%rbp), %rax	# animalCat, tmp101
	movq	(%rax), %rax	# animalCat_16->_vptr.Animal, _7
	movq	(%rax), %rdx	# *_7, _8
# virtual.cpp:44:     animalCat->makeNoise();
	movq	-24(%rbp), %rax	# animalCat, tmp102
	movq	%rax, %rdi	# tmp102,
	call	*%rdx	# _8
# virtual.cpp:47: }
	movl	$0, %eax	#, _27
	addq	$24, %rsp	#,
	popq	%rbx	#
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE1526:
	.size	main, .-main
	.weak	_ZTV3Cat
	.section	.data.rel.ro.local._ZTV3Cat,"awG",@progbits,_ZTV3Cat,comdat
	.align 8
	.type	_ZTV3Cat, @object
	.size	_ZTV3Cat, 24
_ZTV3Cat:
	.quad	0
	.quad	_ZTI3Cat
	.quad	_ZNK3Cat9makeNoiseEv
	.weak	_ZTV6Animal
	.section	.data.rel.ro.local._ZTV6Animal,"awG",@progbits,_ZTV6Animal,comdat
	.align 8
	.type	_ZTV6Animal, @object
	.size	_ZTV6Animal, 24
_ZTV6Animal:
	.quad	0
	.quad	_ZTI6Animal
	.quad	_ZNK6Animal9makeNoiseEv
	.weak	_ZTI3Cat
	.section	.data.rel.ro._ZTI3Cat,"awG",@progbits,_ZTI3Cat,comdat
	.align 8
	.type	_ZTI3Cat, @object
	.size	_ZTI3Cat, 24
_ZTI3Cat:
# <anonymous>:
# <anonymous>:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
# <anonymous>:
	.quad	_ZTS3Cat
# <anonymous>:
	.quad	_ZTI6Animal
	.weak	_ZTS3Cat
	.section	.rodata._ZTS3Cat,"aG",@progbits,_ZTS3Cat,comdat
	.type	_ZTS3Cat, @object
	.size	_ZTS3Cat, 5
_ZTS3Cat:
	.string	"3Cat"
	.weak	_ZTI6Animal
	.section	.data.rel.ro._ZTI6Animal,"awG",@progbits,_ZTI6Animal,comdat
	.align 8
	.type	_ZTI6Animal, @object
	.size	_ZTI6Animal, 16
_ZTI6Animal:
# <anonymous>:
# <anonymous>:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
# <anonymous>:
	.quad	_ZTS6Animal
	.weak	_ZTS6Animal
	.section	.rodata._ZTS6Animal,"aG",@progbits,_ZTS6Animal,comdat
	.align 8
	.type	_ZTS6Animal, @object
	.size	_ZTS6Animal, 8
_ZTS6Animal:
	.string	"6Animal"
	.text
	.type	_Z41__static_initialization_and_destruction_0ii, @function
_Z41__static_initialization_and_destruction_0ii:
.LFB2021:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
	movl	%edi, -4(%rbp)	# __initialize_p, __initialize_p
	movl	%esi, -8(%rbp)	# __priority, __priority
# virtual.cpp:47: }
	cmpl	$1, -4(%rbp)	#, __initialize_p
	jne	.L13	#,
# virtual.cpp:47: }
	cmpl	$65535, -8(%rbp)	#, __priority
	jne	.L13	#,
# /usr/include/c++/9/iostream:74:   static ios_base::Init __ioinit;
	leaq	_ZStL8__ioinit(%rip), %rdi	#,
	call	_ZNSt8ios_base4InitC1Ev@PLT	#
	leaq	__dso_handle(%rip), %rdx	#,
	leaq	_ZStL8__ioinit(%rip), %rsi	#,
	movq	_ZNSt8ios_base4InitD1Ev@GOTPCREL(%rip), %rax	#, tmp82
	movq	%rax, %rdi	# tmp82,
	call	__cxa_atexit@PLT	#
.L13:
# virtual.cpp:47: }
	nop	
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE2021:
	.size	_Z41__static_initialization_and_destruction_0ii, .-_Z41__static_initialization_and_destruction_0ii
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB2022:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
# virtual.cpp:47: }
	movl	$65535, %esi	#,
	movl	$1, %edi	#,
	call	_Z41__static_initialization_and_destruction_0ii	#
	popq	%rbp	#
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE2022:
	.size	_GLOBAL__sub_I_main, .-_GLOBAL__sub_I_main
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_main
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
