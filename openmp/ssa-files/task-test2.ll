; ModuleID = 'task-test2.c'
source_filename = "task-test2.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%ident_t = type { i32, i32, i32, i32, i8* }
%struct.timespec = type { i64, i64 }
%struct.anon = type { [500 x float]* }
%struct.anon.0 = type { [500 x float]* }
%struct.kmp_task_t_with_privates = type { %struct.kmp_task_t }
%struct.kmp_task_t = type { i8*, i32 (i32, i8*)*, i32, i32 (i32, i8*)* }
%struct.kmp_task_t_with_privates.1 = type { %struct.kmp_task_t }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr constant %ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@1 = private unnamed_addr constant %ident_t { i32 0, i32 322, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8

; Function Attrs: nounwind uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca [500 x float], align 16
  %7 = alloca [500 x float], align 16
  %8 = alloca i32, align 4
  %9 = alloca %struct.timespec, align 8
  %10 = alloca %struct.timespec, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i32 0, i32* %8, align 4
  br label %11

; <label>:11:                                     ; preds = %23, %2
  %12 = load i32, i32* %8, align 4
  %13 = icmp slt i32 %12, 500
  br i1 %13, label %14, label %26

; <label>:14:                                     ; preds = %11
  %15 = load i32, i32* %8, align 4
  %16 = mul nsw i32 3, %15
  %17 = sitofp i32 %16 to double
  %18 = fadd double %17, 2.000000e+00
  %19 = fptrunc double %18 to float
  %20 = load i32, i32* %8, align 4
  %21 = sext i32 %20 to i64
  %22 = getelementptr inbounds [500 x float], [500 x float]* %6, i64 0, i64 %21
  store float %19, float* %22, align 4
  br label %23

; <label>:23:                                     ; preds = %14
  %24 = load i32, i32* %8, align 4
  %25 = add nsw i32 %24, 1
  store i32 %25, i32* %8, align 4
  br label %11

; <label>:26:                                     ; preds = %11
  %27 = bitcast %struct.timespec* %9 to i8*
  call void @gettime(i8* %27)
  call void (%ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%ident_t* @0, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, [500 x float]*)* @.omp_outlined. to void (i32*, i32*, ...)*), [500 x float]* %6)
  %28 = bitcast %struct.timespec* %10 to i8*
  call void @gettime(i8* %28)
  %29 = bitcast %struct.timespec* %9 to i8*
  %30 = bitcast %struct.timespec* %10 to i8*
  call void @printtime(i8* %29, i8* %30)
  ret i32 0
}

declare void @gettime(i8*) #1

; Function Attrs: nounwind uwtable
define internal void @.omp_outlined.(i32* noalias, i32* noalias, [500 x float]* dereferenceable(2000)) #0 {
  %4 = alloca i32*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca [500 x float]*, align 8
  %7 = alloca %struct.anon, align 8
  %8 = alloca %struct.anon.0, align 8
  store i32* %0, i32** %4, align 8
  store i32* %1, i32** %5, align 8
  store [500 x float]* %2, [500 x float]** %6, align 8
  %9 = load [500 x float]*, [500 x float]** %6, align 8
  %10 = load i32*, i32** %4, align 8
  %11 = load i32, i32* %10, align 4
  %12 = call i32 @__kmpc_single(%ident_t* @0, i32 %11)
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %14, label %34

; <label>:14:                                     ; preds = %3
  %15 = getelementptr inbounds %struct.anon, %struct.anon* %7, i32 0, i32 0
  store [500 x float]* %9, [500 x float]** %15, align 8
  %16 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %11, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates*)* @.omp_task_entry. to i32 (i32, i8*)*))
  %17 = bitcast i8* %16 to %struct.kmp_task_t_with_privates*
  %18 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %17, i32 0, i32 0
  %19 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %18, i32 0, i32 0
  %20 = load i8*, i8** %19, align 8
  %21 = bitcast %struct.anon* %7 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %20, i8* %21, i64 8, i32 8, i1 false)
  %22 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %18, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %22, align 8
  %23 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %11, i8* %16)
  %24 = getelementptr inbounds %struct.anon.0, %struct.anon.0* %8, i32 0, i32 0
  store [500 x float]* %9, [500 x float]** %24, align 8
  %25 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %11, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.1*)* @.omp_task_entry..3 to i32 (i32, i8*)*))
  %26 = bitcast i8* %25 to %struct.kmp_task_t_with_privates.1*
  %27 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %26, i32 0, i32 0
  %28 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %27, i32 0, i32 0
  %29 = load i8*, i8** %28, align 8
  %30 = bitcast %struct.anon.0* %8 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %29, i8* %30, i64 8, i32 8, i1 false)
  %31 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %27, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %31, align 8
  %32 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %11, i8* %25)
  %33 = call i32 @__kmpc_omp_taskwait(%ident_t* @0, i32 %11)
  call void @__kmpc_end_single(%ident_t* @0, i32 %11)
  br label %34

; <label>:34:                                     ; preds = %14, %3
  call void @__kmpc_barrier(%ident_t* @1, i32 %11)
  ret void
}

declare void @__kmpc_end_single(%ident_t*, i32)

declare i32 @__kmpc_single(%ident_t*, i32)

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry.(i32, %struct.kmp_task_t_with_privates* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates* %1, %struct.kmp_task_t_with_privates** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates*, %struct.kmp_task_t_with_privates** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon*
  store i32 %11, i32* %3, align 4, !noalias !1
  store i32 %15, i32* %4, align 4, !noalias !1
  store i8* null, i8** %5, align 8, !noalias !1
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !1
  store %struct.anon* %18, %struct.anon** %7, align 8, !noalias !1
  %19 = load %struct.anon*, %struct.anon** %7, align 8, !noalias !1
  store i64 0, i64* %8, align 8, !noalias !1
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i64, i64* %8, align 8, !noalias !1
  %22 = icmp slt i64 %21, 10000000
  br i1 %22, label %23, label %35

; <label>:23:                                     ; preds = %20
  %24 = load i64, i64* %8, align 8, !noalias !1
  %25 = srem i64 %24, 500
  %26 = getelementptr inbounds %struct.anon, %struct.anon* %19, i32 0, i32 0
  %27 = load [500 x float]*, [500 x float]** %26, align 8
  %28 = getelementptr inbounds [500 x float], [500 x float]* %27, i64 0, i64 %25
  %29 = load float, float* %28, align 4
  %30 = fpext float %29 to double
  %31 = fadd double %30, 3.000000e+00
  %32 = fptrunc double %31 to float
  store float %32, float* %28, align 4
  %33 = load i64, i64* %8, align 8, !noalias !1
  %34 = add nsw i64 %33, 1
  store i64 %34, i64* %8, align 8, !noalias !1
  br label %20

; <label>:35:                                     ; preds = %20
  ret i32 0
}

declare i8* @__kmpc_omp_task_alloc(%ident_t*, i32, i32, i64, i64, i32 (i32, i8*)*)

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

declare i32 @__kmpc_omp_task(%ident_t*, i32, i8*)

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..3(i32, %struct.kmp_task_t_with_privates.1* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.0*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates.1*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates.1* %1, %struct.kmp_task_t_with_privates.1** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates.1*, %struct.kmp_task_t_with_privates.1** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon.0*
  store i32 %11, i32* %3, align 4, !noalias !5
  store i32 %15, i32* %4, align 4, !noalias !5
  store i8* null, i8** %5, align 8, !noalias !5
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !5
  store %struct.anon.0* %18, %struct.anon.0** %7, align 8, !noalias !5
  %19 = load %struct.anon.0*, %struct.anon.0** %7, align 8, !noalias !5
  store i64 0, i64* %8, align 8, !noalias !5
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i64, i64* %8, align 8, !noalias !5
  %22 = icmp slt i64 %21, 10000000
  br i1 %22, label %23, label %35

; <label>:23:                                     ; preds = %20
  %24 = load i64, i64* %8, align 8, !noalias !5
  %25 = srem i64 %24, 500
  %26 = getelementptr inbounds %struct.anon.0, %struct.anon.0* %19, i32 0, i32 0
  %27 = load [500 x float]*, [500 x float]** %26, align 8
  %28 = getelementptr inbounds [500 x float], [500 x float]* %27, i64 0, i64 %25
  %29 = load float, float* %28, align 4
  %30 = fpext float %29 to double
  %31 = fsub double %30, 4.000000e+00
  %32 = fptrunc double %31 to float
  store float %32, float* %28, align 4
  %33 = load i64, i64* %8, align 8, !noalias !5
  %34 = add nsw i64 %33, 1
  store i64 %34, i64* %8, align 8, !noalias !5
  br label %20

; <label>:35:                                     ; preds = %20
  ret i32 0
}

declare i32 @__kmpc_omp_taskwait(%ident_t*, i32)

declare void @__kmpc_barrier(%ident_t*, i32)

declare void @__kmpc_fork_call(%ident_t*, i32, void (i32*, i32*, ...)*, ...)

declare void @printtime(i8*, i8*) #1

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.9.0 (git@github.com:llvm-mirror/clang.git a6a2b89b5f44fe7b88101cb7e9e0f03576005d7f) (git@github.com:nicoTolly/llvm.git 3b8a73e9fe8d4aa0b6d2130d41d8080e21ea741b)"}
!1 = !{!2, !4}
!2 = distinct !{!2, !3, !".omp_outlined..1: argument 0"}
!3 = distinct !{!3, !".omp_outlined..1"}
!4 = distinct !{!4, !3, !".omp_outlined..1: argument 1"}
!5 = !{!6, !8}
!6 = distinct !{!6, !7, !".omp_outlined..2: argument 0"}
!7 = distinct !{!7, !".omp_outlined..2"}
!8 = distinct !{!8, !7, !".omp_outlined..2: argument 1"}
