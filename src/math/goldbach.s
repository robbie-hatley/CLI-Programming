	.file	"goldbach.c"
	.text
	.globl	IsGoldbachException
	.def	IsGoldbachException;	.scl	2;	.type	32;	.endef
	.seh_proc	IsGoldbachException
IsGoldbachException:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	cmpq	$3, 16(%rbp)
	ja	.L2
	movl	$0, %eax
	jmp	.L3
.L2:
	cmpq	$4, 16(%rbp)
	jne	.L4
	movl	$0, %eax
	jmp	.L3
.L4:
	movq	16(%rbp), %rax
	andl	$1, %eax
	testq	%rax, %rax
	je	.L5
	movl	$0, %eax
	jmp	.L3
.L5:
	movq	16(%rbp), %rax
	shrq	%rax
	movq	%rax, -24(%rbp)
	movq	$3, -8(%rbp)
	movq	16(%rbp), %rax
	subq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
	jmp	.L6
.L8:
	movq	-8(%rbp), %rax
	movq	%rax, %rcx
	call	IsPrime
	testl	%eax, %eax
	je	.L7
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	call	IsPrime
	testl	%eax, %eax
	je	.L7
	movl	$0, %eax
	jmp	.L3
.L7:
	addq	$2, -8(%rbp)
	movq	16(%rbp), %rax
	subq	-8(%rbp), %rax
	movq	%rax, -16(%rbp)
.L6:
	movq	-8(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jbe	.L8
	movl	$1, %eax
.L3:
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "%ld is an exception to Goldbach's conjecture.\12\0"
	.align 8
.LC1:
	.ascii "Checked Goldbach's conjecture through %ld.\12\0"
.LC2:
	.ascii "Found %d exceptions.\12\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$64, %rsp
	.seh_stackalloc	64
	.seh_endprologue
	movl	%ecx, 16(%rbp)
	movq	%rdx, 24(%rbp)
	call	__main
	movq	$0, -8(%rbp)
	movq	$1000000, -16(%rbp)
	movl	$0, -20(%rbp)
	cmpl	$1, 16(%rbp)
	jle	.L10
	movq	24(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movl	$10, %r8d
	movl	$0, %edx
	movq	%rax, %rcx
	call	strtoul
	movq	%rax, -16(%rbp)
.L10:
	movq	$4, -8(%rbp)
	jmp	.L11
.L13:
	movq	-8(%rbp), %rax
	movq	%rax, %rcx
	call	IsGoldbachException
	testl	%eax, %eax
	je	.L12
	addl	$1, -20(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC0(%rip), %rcx
	call	printf
.L12:
	addq	$2, -8(%rbp)
.L11:
	movq	-8(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jbe	.L13
	movq	-16(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC1(%rip), %rcx
	call	printf
	movl	-20(%rbp), %eax
	movl	%eax, %edx
	leaq	.LC2(%rip), %rcx
	call	printf
	movl	$0, %eax
	addq	$64, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (GNU) 6.4.0"
	.def	IsPrime;	.scl	2;	.type	32;	.endef
	.def	strtoul;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
