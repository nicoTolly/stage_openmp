	.text
	.file	"task-test2.c"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI0_0:
	.quad	4611686018427387904     # double 2
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp0:
	.cfi_def_cfa_offset 16
.Ltmp1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp2:
	.cfi_def_cfa_register %rbp
	subq	$1600064, %rsp          # imm = 0x186A40
	movl	$0, -4(%rbp)
	movl	%edi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movl	$0, -1600020(%rbp)
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	cmpl	$200000, -1600020(%rbp) # imm = 0x30D40
	jge	.LBB0_4
# BB#2:                                 #   in Loop: Header=BB0_1 Depth=1
	movsd	.LCPI0_0, %xmm0         # xmm0 = mem[0],zero
	imull	$3, -1600020(%rbp), %eax
	cvtsi2sdl	%eax, %xmm1
	addsd	%xmm0, %xmm1
	cvtsd2ss	%xmm1, %xmm0
	movslq	-1600020(%rbp), %rcx
	movss	%xmm0, -800016(%rbp,%rcx,4)
# BB#3:                                 #   in Loop: Header=BB0_1 Depth=1
	movl	-1600020(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -1600020(%rbp)
	jmp	.LBB0_1
.LBB0_4:
	leaq	-1600040(%rbp), %rax
	movq	%rax, %rdi
	callq	gettime
	movabsq	$.L__unnamed_1, %rdi
	movl	$1, %esi
	movabsq	$.omp_outlined., %rax
	leaq	-800016(%rbp), %rcx
	movq	%rax, %rdx
	movb	$0, %al
	callq	__kmpc_fork_call
	leaq	-1600056(%rbp), %rcx
	movq	%rcx, %rdi
	callq	gettime
	leaq	-1600056(%rbp), %rcx
	leaq	-1600040(%rbp), %rdx
	movq	%rdx, %rdi
	movq	%rcx, %rsi
	callq	printtime
	xorl	%eax, %eax
	addq	$1600064, %rsp          # imm = 0x186A40
	popq	%rbp
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc

	.p2align	4, 0x90
	.type	.omp_outlined.,@function
.omp_outlined.:                         # @.omp_outlined.
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp3:
	.cfi_def_cfa_offset 16
.Ltmp4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp5:
	.cfi_def_cfa_register %rbp
	subq	$80, %rsp
	movabsq	$.L__unnamed_1, %rax
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	-8(%rbp), %rsi
	movl	(%rsi), %ecx
	movq	%rax, %rdi
	movl	%ecx, %esi
	movl	%ecx, -44(%rbp)         # 4-byte Spill
	movq	%rdx, -56(%rbp)         # 8-byte Spill
	callq	__kmpc_single
	cmpl	$0, %eax
	je	.LBB1_2
# BB#1:
	movabsq	$.L__unnamed_1, %rdi
	movl	$1, %edx
	movl	$32, %eax
	movl	%eax, %ecx
	movl	$8, %eax
	movl	%eax, %r8d
	movabsq	$.omp_task_entry., %rsi
	movq	-56(%rbp), %r9          # 8-byte Reload
	movq	%r9, -32(%rbp)
	movl	-44(%rbp), %eax         # 4-byte Reload
	movq	%rsi, -64(%rbp)         # 8-byte Spill
	movl	%eax, %esi
	movq	-64(%rbp), %r9          # 8-byte Reload
	callq	__kmpc_omp_task_alloc
	movabsq	$.L__unnamed_1, %rdi
	movq	(%rax), %rcx
	movq	-32(%rbp), %r8
	movq	%r8, (%rcx)
	movq	$0, 24(%rax)
	movl	-44(%rbp), %esi         # 4-byte Reload
	movq	%rax, %rdx
	callq	__kmpc_omp_task
	movabsq	$.L__unnamed_1, %rdi
	movl	$1, %edx
	movl	$32, %esi
	movl	%esi, %ecx
	movl	$8, %esi
	movl	%esi, %r8d
	movabsq	$.omp_task_entry..3, %r9
	movq	-56(%rbp), %r10         # 8-byte Reload
	movq	%r10, -40(%rbp)
	movl	-44(%rbp), %esi         # 4-byte Reload
	movl	%eax, -68(%rbp)         # 4-byte Spill
	callq	__kmpc_omp_task_alloc
	movabsq	$.L__unnamed_1, %rdi
	movq	(%rax), %rcx
	movq	-40(%rbp), %r8
	movq	%r8, (%rcx)
	movq	$0, 24(%rax)
	movl	-44(%rbp), %esi         # 4-byte Reload
	movq	%rax, %rdx
	callq	__kmpc_omp_task
	movabsq	$.L__unnamed_1, %rdi
	movl	-44(%rbp), %esi         # 4-byte Reload
	movl	%eax, -72(%rbp)         # 4-byte Spill
	callq	__kmpc_omp_taskwait
	movabsq	$.L__unnamed_1, %rdi
	movl	-44(%rbp), %esi         # 4-byte Reload
	movl	%eax, -76(%rbp)         # 4-byte Spill
	callq	__kmpc_end_single
.LBB1_2:
	movabsq	$.L__unnamed_2, %rdi
	movl	-44(%rbp), %esi         # 4-byte Reload
	callq	__kmpc_barrier
	addq	$80, %rsp
	popq	%rbp
	retq
.Lfunc_end1:
	.size	.omp_outlined., .Lfunc_end1-.omp_outlined.
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI2_0:
	.quad	4613937818241073152     # double 3
	.text
	.p2align	4, 0x90
	.type	.omp_task_entry.,@function
.omp_task_entry.:                       # @.omp_task_entry.
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp6:
	.cfi_def_cfa_offset 16
.Ltmp7:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp8:
	.cfi_def_cfa_register %rbp
	movl	%edi, -44(%rbp)
	movq	%rsi, -56(%rbp)
	movl	-44(%rbp), %edi
	movq	-56(%rbp), %rsi
	movl	16(%rsi), %eax
	movq	(%rsi), %rsi
	movl	%edi, -4(%rbp)
	movl	%eax, -8(%rbp)
	movq	$0, -16(%rbp)
	movq	$0, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rsi
	movq	$0, -40(%rbp)
	movq	%rsi, -64(%rbp)         # 8-byte Spill
.LBB2_1:                                # =>This Inner Loop Header: Depth=1
	cmpq	$10000000, -40(%rbp)    # imm = 0x989680
	jge	.LBB2_3
# BB#2:                                 #   in Loop: Header=BB2_1 Depth=1
	movsd	.LCPI2_0, %xmm0         # xmm0 = mem[0],zero
	movl	$200000, %eax           # imm = 0x30D40
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	cqto
	idivq	%rcx
	movq	-64(%rbp), %rcx         # 8-byte Reload
	movq	(%rcx), %rsi
	cvtss2sd	(%rsi,%rdx,4), %xmm1
	addsd	%xmm0, %xmm1
	cvtsd2ss	%xmm1, %xmm0
	movss	%xmm0, (%rsi,%rdx,4)
	movq	-40(%rbp), %rdx
	addq	$1, %rdx
	movq	%rdx, -40(%rbp)
	jmp	.LBB2_1
.LBB2_3:
	xorl	%eax, %eax
	popq	%rbp
	retq
.Lfunc_end2:
	.size	.omp_task_entry., .Lfunc_end2-.omp_task_entry.
	.cfi_endproc

	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3
.LCPI3_0:
	.quad	4616189618054758400     # double 4
	.text
	.p2align	4, 0x90
	.type	.omp_task_entry..3,@function
.omp_task_entry..3:                     # @.omp_task_entry..3
	.cfi_startproc
# BB#0:
	pushq	%rbp
.Ltmp9:
	.cfi_def_cfa_offset 16
.Ltmp10:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
.Ltmp11:
	.cfi_def_cfa_register %rbp
	movl	%edi, -44(%rbp)
	movq	%rsi, -56(%rbp)
	movl	-44(%rbp), %edi
	movq	-56(%rbp), %rsi
	movl	16(%rsi), %eax
	movq	(%rsi), %rsi
	movl	%edi, -4(%rbp)
	movl	%eax, -8(%rbp)
	movq	$0, -16(%rbp)
	movq	$0, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rsi
	movq	$0, -40(%rbp)
	movq	%rsi, -64(%rbp)         # 8-byte Spill
.LBB3_1:                                # =>This Inner Loop Header: Depth=1
	cmpq	$10000000, -40(%rbp)    # imm = 0x989680
	jge	.LBB3_3
# BB#2:                                 #   in Loop: Header=BB3_1 Depth=1
	movsd	.LCPI3_0, %xmm0         # xmm0 = mem[0],zero
	movl	$200000, %eax           # imm = 0x30D40
	movl	%eax, %ecx
	movq	-40(%rbp), %rax
	cqto
	idivq	%rcx
	movq	-64(%rbp), %rcx         # 8-byte Reload
	movq	(%rcx), %rsi
	cvtss2sd	(%rsi,%rdx,4), %xmm1
	subsd	%xmm0, %xmm1
	cvtsd2ss	%xmm1, %xmm0
	movss	%xmm0, (%rsi,%rdx,4)
	movq	-40(%rbp), %rdx
	addq	$1, %rdx
	movq	%rdx, -40(%rbp)
	jmp	.LBB3_1
.LBB3_3:
	xorl	%eax, %eax
	popq	%rbp
	retq
.Lfunc_end3:
	.size	.omp_task_entry..3, .Lfunc_end3-.omp_task_entry..3
	.cfi_endproc

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	";unknown;unknown;0;0;;"
	.size	.L.str, 23

	.type	.L__unnamed_1,@object   # @0
	.section	.rodata,"a",@progbits
	.p2align	3
.L__unnamed_1:
	.long	0                       # 0x0
	.long	2                       # 0x2
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.L.str
	.size	.L__unnamed_1, 24

	.type	.L__unnamed_2,@object   # @1
	.p2align	3
.L__unnamed_2:
	.long	0                       # 0x0
	.long	322                     # 0x142
	.long	0                       # 0x0
	.long	0                       # 0x0
	.quad	.L.str
	.size	.L__unnamed_2, 24


	.ident	"clang version 3.9.0 (git@github.com:llvm-mirror/clang.git a6a2b89b5f44fe7b88101cb7e9e0f03576005d7f) (git@github.com:nicoTolly/llvm.git 3b8a73e9fe8d4aa0b6d2130d41d8080e21ea741b)"
	.section	".note.GNU-stack","",@progbits
