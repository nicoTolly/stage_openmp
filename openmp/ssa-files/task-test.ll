; ModuleID = 'task-test.c'
source_filename = "task-test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%ident_t = type { i32, i32, i32, i32, i8* }
%struct.timespec = type { i64, i64 }
%struct.anon = type { [500 x float]* }
%struct.anon.0 = type { [500 x float]* }
%struct.anon.3 = type { [500 x float]* }
%struct.anon.6 = type { [500 x float]* }
%struct.anon.9 = type { [500 x float]* }
%struct.anon.11 = type { [500 x float]* }
%struct.anon.13 = type { [500 x float]* }
%struct.anon.15 = type { [500 x float]* }
%struct.kmp_task_t_with_privates = type { %struct.kmp_task_t, %struct..kmp_privates.t }
%struct.kmp_task_t = type { i8*, i32 (i32, i8*)*, i32, i32 (i32, i8*)* }
%struct..kmp_privates.t = type { [500 x float] }
%struct.kmp_task_t_with_privates.1 = type { %struct.kmp_task_t, %struct..kmp_privates.t.2 }
%struct..kmp_privates.t.2 = type { [500 x float] }
%struct.kmp_task_t_with_privates.4 = type { %struct.kmp_task_t, %struct..kmp_privates.t.5 }
%struct..kmp_privates.t.5 = type { [500 x float] }
%struct.kmp_task_t_with_privates.7 = type { %struct.kmp_task_t, %struct..kmp_privates.t.8 }
%struct..kmp_privates.t.8 = type { [500 x float] }
%struct.kmp_task_t_with_privates.10 = type { %struct.kmp_task_t }
%struct.kmp_task_t_with_privates.12 = type { %struct.kmp_task_t }
%struct.kmp_task_t_with_privates.14 = type { %struct.kmp_task_t }
%struct.kmp_task_t_with_privates.16 = type { %struct.kmp_task_t }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr constant %ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@.str.19 = private unnamed_addr constant [25 x i8] c"Elapsed time global= %f\0A\00", align 1
@.str.20 = private unnamed_addr constant [40 x i8] c"Elapsed time global with wtime= %e \C2\B5s\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca [500 x float], align 16
  %7 = alloca [500 x float], align 16
  %8 = alloca [500 x float], align 16
  %9 = alloca [500 x float], align 16
  %10 = alloca [500 x float], align 16
  %11 = alloca [500 x float], align 16
  %12 = alloca [500 x float], align 16
  %13 = alloca [500 x float], align 16
  %14 = alloca i32, align 4
  %15 = alloca %struct.timespec, align 8
  %16 = alloca %struct.timespec, align 8
  %17 = alloca double, align 8
  %18 = alloca double, align 8
  %19 = alloca double, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  store i32 0, i32* %14, align 4
  br label %20

; <label>:20:                                     ; preds = %89, %2
  %21 = load i32, i32* %14, align 4
  %22 = icmp slt i32 %21, 500
  br i1 %22, label %23, label %92

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %14, align 4
  %25 = mul nsw i32 3, %24
  %26 = sitofp i32 %25 to double
  %27 = fadd double %26, 2.000000e+00
  %28 = fptrunc double %27 to float
  %29 = load i32, i32* %14, align 4
  %30 = sext i32 %29 to i64
  %31 = getelementptr inbounds [500 x float], [500 x float]* %6, i64 0, i64 %30
  store float %28, float* %31, align 4
  %32 = load i32, i32* %14, align 4
  %33 = load i32, i32* %14, align 4
  %34 = mul nsw i32 %32, %33
  %35 = sitofp i32 %34 to double
  %36 = fadd double %35, 7.000000e+00
  %37 = fptrunc double %36 to float
  %38 = load i32, i32* %14, align 4
  %39 = sext i32 %38 to i64
  %40 = getelementptr inbounds [500 x float], [500 x float]* %7, i64 0, i64 %39
  store float %37, float* %40, align 4
  %41 = load i32, i32* %14, align 4
  %42 = mul nsw i32 3, %41
  %43 = sitofp i32 %42 to double
  %44 = fadd double %43, 2.000000e+00
  %45 = fptrunc double %44 to float
  %46 = load i32, i32* %14, align 4
  %47 = sext i32 %46 to i64
  %48 = getelementptr inbounds [500 x float], [500 x float]* %9, i64 0, i64 %47
  store float %45, float* %48, align 4
  %49 = load i32, i32* %14, align 4
  %50 = mul nsw i32 3, %49
  %51 = sitofp i32 %50 to double
  %52 = fadd double %51, 2.000000e+00
  %53 = fptrunc double %52 to float
  %54 = load i32, i32* %14, align 4
  %55 = sext i32 %54 to i64
  %56 = getelementptr inbounds [500 x float], [500 x float]* %8, i64 0, i64 %55
  store float %53, float* %56, align 4
  %57 = load i32, i32* %14, align 4
  %58 = mul nsw i32 3, %57
  %59 = sitofp i32 %58 to double
  %60 = fadd double %59, 2.000000e+00
  %61 = fptrunc double %60 to float
  %62 = load i32, i32* %14, align 4
  %63 = sext i32 %62 to i64
  %64 = getelementptr inbounds [500 x float], [500 x float]* %10, i64 0, i64 %63
  store float %61, float* %64, align 4
  %65 = load i32, i32* %14, align 4
  %66 = mul nsw i32 -3, %65
  %67 = sitofp i32 %66 to double
  %68 = fadd double %67, 2.000000e+00
  %69 = fptrunc double %68 to float
  %70 = load i32, i32* %14, align 4
  %71 = sext i32 %70 to i64
  %72 = getelementptr inbounds [500 x float], [500 x float]* %11, i64 0, i64 %71
  store float %69, float* %72, align 4
  %73 = load i32, i32* %14, align 4
  %74 = mul nsw i32 3, %73
  %75 = sitofp i32 %74 to double
  %76 = fsub double %75, 2.000000e+00
  %77 = fptrunc double %76 to float
  %78 = load i32, i32* %14, align 4
  %79 = sext i32 %78 to i64
  %80 = getelementptr inbounds [500 x float], [500 x float]* %12, i64 0, i64 %79
  store float %77, float* %80, align 4
  %81 = load i32, i32* %14, align 4
  %82 = sitofp i32 %81 to double
  %83 = fmul double 3.500000e+00, %82
  %84 = fadd double %83, 2.000000e+00
  %85 = fptrunc double %84 to float
  %86 = load i32, i32* %14, align 4
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds [500 x float], [500 x float]* %13, i64 0, i64 %87
  store float %85, float* %88, align 4
  br label %89

; <label>:89:                                     ; preds = %23
  %90 = load i32, i32* %14, align 4
  %91 = add nsw i32 %90, 1
  store i32 %91, i32* %14, align 4
  br label %20

; <label>:92:                                     ; preds = %20
  %93 = call i32 @clock_gettime(i32 0, %struct.timespec* %15) #5
  %94 = call double @omp_get_wtime()
  store double %94, double* %18, align 8
  call void (%ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%ident_t* @0, i32 8, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, [500 x float]*, [500 x float]*, [500 x float]*, [500 x float]*, [500 x float]*, [500 x float]*, [500 x float]*, [500 x float]*)* @.omp_outlined. to void (i32*, i32*, ...)*), [500 x float]* %6, [500 x float]* %7, [500 x float]* %8, [500 x float]* %9, [500 x float]* %10, [500 x float]* %11, [500 x float]* %12, [500 x float]* %13)
  %95 = call double @omp_get_wtime()
  %96 = load double, double* %18, align 8
  %97 = fsub double %95, %96
  store double %97, double* %17, align 8
  %98 = call i32 @clock_gettime(i32 0, %struct.timespec* %16) #5
  %99 = getelementptr inbounds %struct.timespec, %struct.timespec* %16, i32 0, i32 0
  %100 = load i64, i64* %99, align 8
  %101 = getelementptr inbounds %struct.timespec, %struct.timespec* %15, i32 0, i32 0
  %102 = load i64, i64* %101, align 8
  %103 = sub nsw i64 %100, %102
  %104 = sitofp i64 %103 to double
  %105 = fmul double %104, 1.000000e+03
  %106 = getelementptr inbounds %struct.timespec, %struct.timespec* %16, i32 0, i32 1
  %107 = load i64, i64* %106, align 8
  %108 = getelementptr inbounds %struct.timespec, %struct.timespec* %15, i32 0, i32 1
  %109 = load i64, i64* %108, align 8
  %110 = sub nsw i64 %107, %109
  %111 = sitofp i64 %110 to double
  %112 = fdiv double %111, 1.000000e+06
  %113 = fadd double %105, %112
  store double %113, double* %19, align 8
  %114 = load double, double* %19, align 8
  %115 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.19, i32 0, i32 0), double %114)
  %116 = load double, double* %17, align 8
  %117 = fmul double %116, 1.000000e+06
  %118 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.20, i32 0, i32 0), double %117)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @clock_gettime(i32, %struct.timespec*) #1

declare double @omp_get_wtime() #2

; Function Attrs: nounwind uwtable
define internal void @.omp_outlined.(i32* noalias, i32* noalias, [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000), [500 x float]* dereferenceable(2000)) #0 {
  %11 = alloca i32*, align 8
  %12 = alloca i32*, align 8
  %13 = alloca [500 x float]*, align 8
  %14 = alloca [500 x float]*, align 8
  %15 = alloca [500 x float]*, align 8
  %16 = alloca [500 x float]*, align 8
  %17 = alloca [500 x float]*, align 8
  %18 = alloca [500 x float]*, align 8
  %19 = alloca [500 x float]*, align 8
  %20 = alloca [500 x float]*, align 8
  %21 = alloca [500 x float], align 16
  %22 = alloca [500 x float], align 16
  %23 = alloca [500 x float], align 16
  %24 = alloca [500 x float], align 16
  %25 = alloca i32, align 4
  %26 = alloca %struct.anon, align 8
  %27 = alloca %struct.anon.0, align 8
  %28 = alloca %struct.anon.3, align 8
  %29 = alloca %struct.anon.6, align 8
  %30 = alloca %struct.anon.9, align 8
  %31 = alloca %struct.anon.11, align 8
  %32 = alloca %struct.anon.13, align 8
  %33 = alloca %struct.anon.15, align 8
  store i32* %0, i32** %11, align 8
  store i32* %1, i32** %12, align 8
  store [500 x float]* %2, [500 x float]** %13, align 8
  store [500 x float]* %3, [500 x float]** %14, align 8
  store [500 x float]* %4, [500 x float]** %15, align 8
  store [500 x float]* %5, [500 x float]** %16, align 8
  store [500 x float]* %6, [500 x float]** %17, align 8
  store [500 x float]* %7, [500 x float]** %18, align 8
  store [500 x float]* %8, [500 x float]** %19, align 8
  store [500 x float]* %9, [500 x float]** %20, align 8
  %34 = load [500 x float]*, [500 x float]** %13, align 8
  %35 = load [500 x float]*, [500 x float]** %14, align 8
  %36 = load [500 x float]*, [500 x float]** %15, align 8
  %37 = load [500 x float]*, [500 x float]** %16, align 8
  %38 = load [500 x float]*, [500 x float]** %17, align 8
  %39 = load [500 x float]*, [500 x float]** %18, align 8
  %40 = load [500 x float]*, [500 x float]** %19, align 8
  %41 = load [500 x float]*, [500 x float]** %20, align 8
  %42 = bitcast [500 x float]* %21 to i8*
  %43 = bitcast [500 x float]* %34 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %42, i8* %43, i64 2000, i32 16, i1 false)
  %44 = bitcast [500 x float]* %22 to i8*
  %45 = bitcast [500 x float]* %35 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %44, i8* %45, i64 2000, i32 16, i1 false)
  %46 = bitcast [500 x float]* %23 to i8*
  %47 = bitcast [500 x float]* %36 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %46, i8* %47, i64 2000, i32 16, i1 false)
  %48 = bitcast [500 x float]* %24 to i8*
  %49 = bitcast [500 x float]* %37 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %48, i8* %49, i64 2000, i32 16, i1 false)
  %50 = load i32*, i32** %11, align 8
  %51 = load i32, i32* %50, align 4
  %52 = call i32 @__kmpc_single(%ident_t* @0, i32 %51)
  %53 = icmp ne i32 %52, 0
  br i1 %53, label %54, label %157

; <label>:54:                                     ; preds = %10
  %55 = call i32 @omp_get_thread_num()
  store i32 %55, i32* %25, align 4
  %56 = getelementptr inbounds %struct.anon, %struct.anon* %26, i32 0, i32 0
  store [500 x float]* %21, [500 x float]** %56, align 8
  %57 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 2032, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates*)* @.omp_task_entry. to i32 (i32, i8*)*))
  %58 = bitcast i8* %57 to %struct.kmp_task_t_with_privates*
  %59 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %58, i32 0, i32 0
  %60 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %59, i32 0, i32 0
  %61 = load i8*, i8** %60, align 8
  %62 = bitcast %struct.anon* %26 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %61, i8* %62, i64 8, i32 8, i1 false)
  %63 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %58, i32 0, i32 1
  %64 = bitcast i8* %61 to %struct.anon*
  %65 = getelementptr inbounds %struct..kmp_privates.t, %struct..kmp_privates.t* %63, i32 0, i32 0
  %66 = getelementptr inbounds %struct.anon, %struct.anon* %64, i32 0, i32 0
  %67 = load [500 x float]*, [500 x float]** %66, align 8
  %68 = bitcast [500 x float]* %65 to i8*
  %69 = bitcast [500 x float]* %67 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %68, i8* %69, i64 2000, i32 8, i1 false)
  %70 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %59, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %70, align 8
  %71 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %57)
  %72 = getelementptr inbounds %struct.anon.0, %struct.anon.0* %27, i32 0, i32 0
  store [500 x float]* %22, [500 x float]** %72, align 8
  %73 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 2032, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.1*)* @.omp_task_entry..4 to i32 (i32, i8*)*))
  %74 = bitcast i8* %73 to %struct.kmp_task_t_with_privates.1*
  %75 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %74, i32 0, i32 0
  %76 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %75, i32 0, i32 0
  %77 = load i8*, i8** %76, align 8
  %78 = bitcast %struct.anon.0* %27 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %77, i8* %78, i64 8, i32 8, i1 false)
  %79 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %74, i32 0, i32 1
  %80 = bitcast i8* %77 to %struct.anon.0*
  %81 = getelementptr inbounds %struct..kmp_privates.t.2, %struct..kmp_privates.t.2* %79, i32 0, i32 0
  %82 = getelementptr inbounds %struct.anon.0, %struct.anon.0* %80, i32 0, i32 0
  %83 = load [500 x float]*, [500 x float]** %82, align 8
  %84 = bitcast [500 x float]* %81 to i8*
  %85 = bitcast [500 x float]* %83 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %84, i8* %85, i64 2000, i32 8, i1 false)
  %86 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %75, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %86, align 8
  %87 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %73)
  %88 = getelementptr inbounds %struct.anon.3, %struct.anon.3* %28, i32 0, i32 0
  store [500 x float]* %23, [500 x float]** %88, align 8
  %89 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 2032, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.4*)* @.omp_task_entry..7 to i32 (i32, i8*)*))
  %90 = bitcast i8* %89 to %struct.kmp_task_t_with_privates.4*
  %91 = getelementptr inbounds %struct.kmp_task_t_with_privates.4, %struct.kmp_task_t_with_privates.4* %90, i32 0, i32 0
  %92 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %91, i32 0, i32 0
  %93 = load i8*, i8** %92, align 8
  %94 = bitcast %struct.anon.3* %28 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %93, i8* %94, i64 8, i32 8, i1 false)
  %95 = getelementptr inbounds %struct.kmp_task_t_with_privates.4, %struct.kmp_task_t_with_privates.4* %90, i32 0, i32 1
  %96 = bitcast i8* %93 to %struct.anon.3*
  %97 = getelementptr inbounds %struct..kmp_privates.t.5, %struct..kmp_privates.t.5* %95, i32 0, i32 0
  %98 = getelementptr inbounds %struct.anon.3, %struct.anon.3* %96, i32 0, i32 0
  %99 = load [500 x float]*, [500 x float]** %98, align 8
  %100 = bitcast [500 x float]* %97 to i8*
  %101 = bitcast [500 x float]* %99 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %100, i8* %101, i64 2000, i32 8, i1 false)
  %102 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %91, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %102, align 8
  %103 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %89)
  %104 = getelementptr inbounds %struct.anon.6, %struct.anon.6* %29, i32 0, i32 0
  store [500 x float]* %24, [500 x float]** %104, align 8
  %105 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 2032, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.7*)* @.omp_task_entry..10 to i32 (i32, i8*)*))
  %106 = bitcast i8* %105 to %struct.kmp_task_t_with_privates.7*
  %107 = getelementptr inbounds %struct.kmp_task_t_with_privates.7, %struct.kmp_task_t_with_privates.7* %106, i32 0, i32 0
  %108 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %107, i32 0, i32 0
  %109 = load i8*, i8** %108, align 8
  %110 = bitcast %struct.anon.6* %29 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %109, i8* %110, i64 8, i32 8, i1 false)
  %111 = getelementptr inbounds %struct.kmp_task_t_with_privates.7, %struct.kmp_task_t_with_privates.7* %106, i32 0, i32 1
  %112 = bitcast i8* %109 to %struct.anon.6*
  %113 = getelementptr inbounds %struct..kmp_privates.t.8, %struct..kmp_privates.t.8* %111, i32 0, i32 0
  %114 = getelementptr inbounds %struct.anon.6, %struct.anon.6* %112, i32 0, i32 0
  %115 = load [500 x float]*, [500 x float]** %114, align 8
  %116 = bitcast [500 x float]* %113 to i8*
  %117 = bitcast [500 x float]* %115 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %116, i8* %117, i64 2000, i32 8, i1 false)
  %118 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %107, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %118, align 8
  %119 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %105)
  %120 = getelementptr inbounds %struct.anon.9, %struct.anon.9* %30, i32 0, i32 0
  store [500 x float]* %38, [500 x float]** %120, align 8
  %121 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.10*)* @.omp_task_entry..12 to i32 (i32, i8*)*))
  %122 = bitcast i8* %121 to %struct.kmp_task_t_with_privates.10*
  %123 = getelementptr inbounds %struct.kmp_task_t_with_privates.10, %struct.kmp_task_t_with_privates.10* %122, i32 0, i32 0
  %124 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %123, i32 0, i32 0
  %125 = load i8*, i8** %124, align 8
  %126 = bitcast %struct.anon.9* %30 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %125, i8* %126, i64 8, i32 8, i1 false)
  %127 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %123, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %127, align 8
  %128 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %121)
  %129 = getelementptr inbounds %struct.anon.11, %struct.anon.11* %31, i32 0, i32 0
  store [500 x float]* %39, [500 x float]** %129, align 8
  %130 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.12*)* @.omp_task_entry..14 to i32 (i32, i8*)*))
  %131 = bitcast i8* %130 to %struct.kmp_task_t_with_privates.12*
  %132 = getelementptr inbounds %struct.kmp_task_t_with_privates.12, %struct.kmp_task_t_with_privates.12* %131, i32 0, i32 0
  %133 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %132, i32 0, i32 0
  %134 = load i8*, i8** %133, align 8
  %135 = bitcast %struct.anon.11* %31 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %134, i8* %135, i64 8, i32 8, i1 false)
  %136 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %132, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %136, align 8
  %137 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %130)
  %138 = getelementptr inbounds %struct.anon.13, %struct.anon.13* %32, i32 0, i32 0
  store [500 x float]* %40, [500 x float]** %138, align 8
  %139 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.14*)* @.omp_task_entry..16 to i32 (i32, i8*)*))
  %140 = bitcast i8* %139 to %struct.kmp_task_t_with_privates.14*
  %141 = getelementptr inbounds %struct.kmp_task_t_with_privates.14, %struct.kmp_task_t_with_privates.14* %140, i32 0, i32 0
  %142 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %141, i32 0, i32 0
  %143 = load i8*, i8** %142, align 8
  %144 = bitcast %struct.anon.13* %32 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %143, i8* %144, i64 8, i32 8, i1 false)
  %145 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %141, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %145, align 8
  %146 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %139)
  %147 = getelementptr inbounds %struct.anon.15, %struct.anon.15* %33, i32 0, i32 0
  store [500 x float]* %41, [500 x float]** %147, align 8
  %148 = call i8* @__kmpc_omp_task_alloc(%ident_t* @0, i32 %51, i32 1, i64 32, i64 8, i32 (i32, i8*)* bitcast (i32 (i32, %struct.kmp_task_t_with_privates.16*)* @.omp_task_entry..18 to i32 (i32, i8*)*))
  %149 = bitcast i8* %148 to %struct.kmp_task_t_with_privates.16*
  %150 = getelementptr inbounds %struct.kmp_task_t_with_privates.16, %struct.kmp_task_t_with_privates.16* %149, i32 0, i32 0
  %151 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %150, i32 0, i32 0
  %152 = load i8*, i8** %151, align 8
  %153 = bitcast %struct.anon.15* %33 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %152, i8* %153, i64 8, i32 8, i1 false)
  %154 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %150, i32 0, i32 3
  store i32 (i32, i8*)* null, i32 (i32, i8*)** %154, align 8
  %155 = call i32 @__kmpc_omp_task(%ident_t* @0, i32 %51, i8* %148)
  %156 = call i32 @__kmpc_omp_taskwait(%ident_t* @0, i32 %51)
  call void @__kmpc_end_single(%ident_t* @0, i32 %51)
  br label %157

; <label>:157:                                    ; preds = %54, %10
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #3

declare void @__kmpc_end_single(%ident_t*, i32)

declare i32 @__kmpc_single(%ident_t*, i32)

declare i32 @omp_get_thread_num() #2

; Function Attrs: alwaysinline nounwind uwtable
define internal void @.omp_task_privates_map.(%struct..kmp_privates.t* noalias, [500 x float]** noalias) #4 {
  %3 = alloca %struct..kmp_privates.t*, align 8
  %4 = alloca [500 x float]**, align 8
  store %struct..kmp_privates.t* %0, %struct..kmp_privates.t** %3, align 8
  store [500 x float]** %1, [500 x float]*** %4, align 8
  %5 = load %struct..kmp_privates.t*, %struct..kmp_privates.t** %3, align 8
  %6 = getelementptr inbounds %struct..kmp_privates.t, %struct..kmp_privates.t* %5, i32 0, i32 0
  %7 = load [500 x float]**, [500 x float]*** %4, align 8
  store [500 x float]* %6, [500 x float]** %7, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry.(i32, %struct.kmp_task_t_with_privates* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon*, align 8
  %8 = alloca [500 x float]*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.kmp_task_t_with_privates*, align 8
  store i32 %0, i32* %10, align 4
  store %struct.kmp_task_t_with_privates* %1, %struct.kmp_task_t_with_privates** %11, align 8
  %12 = load i32, i32* %10, align 4
  %13 = load %struct.kmp_task_t_with_privates*, %struct.kmp_task_t_with_privates** %11, align 8
  %14 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %13, i32 0, i32 0
  %15 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 2
  %16 = load i32, i32* %15, align 8
  %17 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 0
  %18 = load i8*, i8** %17, align 8
  %19 = bitcast i8* %18 to %struct.anon*
  %20 = getelementptr inbounds %struct.kmp_task_t_with_privates, %struct.kmp_task_t_with_privates* %13, i32 0, i32 1
  %21 = bitcast %struct..kmp_privates.t* %20 to i8*
  store i32 %12, i32* %3, align 4, !noalias !1
  store i32 %16, i32* %4, align 4, !noalias !1
  store i8* %21, i8** %5, align 8, !noalias !1
  store void (i8*, ...)* bitcast (void (%struct..kmp_privates.t*, [500 x float]**)* @.omp_task_privates_map. to void (i8*, ...)*), void (i8*, ...)** %6, align 8, !noalias !1
  store %struct.anon* %19, %struct.anon** %7, align 8, !noalias !1
  %22 = load %struct.anon*, %struct.anon** %7, align 8, !noalias !1
  %23 = load void (i8*, ...)*, void (i8*, ...)** %6, align 8, !noalias !1
  %24 = load i8*, i8** %5, align 8, !noalias !1
  call void (i8*, ...) %23(i8* %24, [500 x float]** %8) #5
  %25 = load [500 x float]*, [500 x float]** %8, align 8, !noalias !1
  store i32 0, i32* %9, align 4, !noalias !1
  br label %26

; <label>:26:                                     ; preds = %29, %2
  %27 = load i32, i32* %9, align 4, !noalias !1
  %28 = icmp slt i32 %27, 10000000
  br i1 %28, label %29, label %40

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* %9, align 4, !noalias !1
  %31 = srem i32 %30, 500
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [500 x float], [500 x float]* %25, i64 0, i64 %32
  %34 = load float, float* %33, align 4
  %35 = fpext float %34 to double
  %36 = fadd double %35, 3.000000e+00
  %37 = fptrunc double %36 to float
  store float %37, float* %33, align 4
  %38 = load i32, i32* %9, align 4, !noalias !1
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %9, align 4, !noalias !1
  br label %26

; <label>:40:                                     ; preds = %26
  ret i32 0
}

declare i8* @__kmpc_omp_task_alloc(%ident_t*, i32, i32, i64, i64, i32 (i32, i8*)*)

declare i32 @__kmpc_omp_task(%ident_t*, i32, i8*)

; Function Attrs: alwaysinline nounwind uwtable
define internal void @.omp_task_privates_map..3(%struct..kmp_privates.t.2* noalias, [500 x float]** noalias) #4 {
  %3 = alloca %struct..kmp_privates.t.2*, align 8
  %4 = alloca [500 x float]**, align 8
  store %struct..kmp_privates.t.2* %0, %struct..kmp_privates.t.2** %3, align 8
  store [500 x float]** %1, [500 x float]*** %4, align 8
  %5 = load %struct..kmp_privates.t.2*, %struct..kmp_privates.t.2** %3, align 8
  %6 = getelementptr inbounds %struct..kmp_privates.t.2, %struct..kmp_privates.t.2* %5, i32 0, i32 0
  %7 = load [500 x float]**, [500 x float]*** %4, align 8
  store [500 x float]* %6, [500 x float]** %7, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..4(i32, %struct.kmp_task_t_with_privates.1* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.0*, align 8
  %8 = alloca [500 x float]*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.kmp_task_t_with_privates.1*, align 8
  store i32 %0, i32* %10, align 4
  store %struct.kmp_task_t_with_privates.1* %1, %struct.kmp_task_t_with_privates.1** %11, align 8
  %12 = load i32, i32* %10, align 4
  %13 = load %struct.kmp_task_t_with_privates.1*, %struct.kmp_task_t_with_privates.1** %11, align 8
  %14 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %13, i32 0, i32 0
  %15 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 2
  %16 = load i32, i32* %15, align 8
  %17 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 0
  %18 = load i8*, i8** %17, align 8
  %19 = bitcast i8* %18 to %struct.anon.0*
  %20 = getelementptr inbounds %struct.kmp_task_t_with_privates.1, %struct.kmp_task_t_with_privates.1* %13, i32 0, i32 1
  %21 = bitcast %struct..kmp_privates.t.2* %20 to i8*
  store i32 %12, i32* %3, align 4, !noalias !5
  store i32 %16, i32* %4, align 4, !noalias !5
  store i8* %21, i8** %5, align 8, !noalias !5
  store void (i8*, ...)* bitcast (void (%struct..kmp_privates.t.2*, [500 x float]**)* @.omp_task_privates_map..3 to void (i8*, ...)*), void (i8*, ...)** %6, align 8, !noalias !5
  store %struct.anon.0* %19, %struct.anon.0** %7, align 8, !noalias !5
  %22 = load %struct.anon.0*, %struct.anon.0** %7, align 8, !noalias !5
  %23 = load void (i8*, ...)*, void (i8*, ...)** %6, align 8, !noalias !5
  %24 = load i8*, i8** %5, align 8, !noalias !5
  call void (i8*, ...) %23(i8* %24, [500 x float]** %8) #5
  %25 = load [500 x float]*, [500 x float]** %8, align 8, !noalias !5
  store i32 0, i32* %9, align 4, !noalias !5
  br label %26

; <label>:26:                                     ; preds = %29, %2
  %27 = load i32, i32* %9, align 4, !noalias !5
  %28 = icmp slt i32 %27, 10000000
  br i1 %28, label %29, label %40

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* %9, align 4, !noalias !5
  %31 = srem i32 %30, 500
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [500 x float], [500 x float]* %25, i64 0, i64 %32
  %34 = load float, float* %33, align 4
  %35 = fpext float %34 to double
  %36 = fsub double %35, 4.000000e+00
  %37 = fptrunc double %36 to float
  store float %37, float* %33, align 4
  %38 = load i32, i32* %9, align 4, !noalias !5
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %9, align 4, !noalias !5
  br label %26

; <label>:40:                                     ; preds = %26
  ret i32 0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @.omp_task_privates_map..6(%struct..kmp_privates.t.5* noalias, [500 x float]** noalias) #4 {
  %3 = alloca %struct..kmp_privates.t.5*, align 8
  %4 = alloca [500 x float]**, align 8
  store %struct..kmp_privates.t.5* %0, %struct..kmp_privates.t.5** %3, align 8
  store [500 x float]** %1, [500 x float]*** %4, align 8
  %5 = load %struct..kmp_privates.t.5*, %struct..kmp_privates.t.5** %3, align 8
  %6 = getelementptr inbounds %struct..kmp_privates.t.5, %struct..kmp_privates.t.5* %5, i32 0, i32 0
  %7 = load [500 x float]**, [500 x float]*** %4, align 8
  store [500 x float]* %6, [500 x float]** %7, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..7(i32, %struct.kmp_task_t_with_privates.4* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.3*, align 8
  %8 = alloca [500 x float]*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.kmp_task_t_with_privates.4*, align 8
  store i32 %0, i32* %10, align 4
  store %struct.kmp_task_t_with_privates.4* %1, %struct.kmp_task_t_with_privates.4** %11, align 8
  %12 = load i32, i32* %10, align 4
  %13 = load %struct.kmp_task_t_with_privates.4*, %struct.kmp_task_t_with_privates.4** %11, align 8
  %14 = getelementptr inbounds %struct.kmp_task_t_with_privates.4, %struct.kmp_task_t_with_privates.4* %13, i32 0, i32 0
  %15 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 2
  %16 = load i32, i32* %15, align 8
  %17 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 0
  %18 = load i8*, i8** %17, align 8
  %19 = bitcast i8* %18 to %struct.anon.3*
  %20 = getelementptr inbounds %struct.kmp_task_t_with_privates.4, %struct.kmp_task_t_with_privates.4* %13, i32 0, i32 1
  %21 = bitcast %struct..kmp_privates.t.5* %20 to i8*
  store i32 %12, i32* %3, align 4, !noalias !9
  store i32 %16, i32* %4, align 4, !noalias !9
  store i8* %21, i8** %5, align 8, !noalias !9
  store void (i8*, ...)* bitcast (void (%struct..kmp_privates.t.5*, [500 x float]**)* @.omp_task_privates_map..6 to void (i8*, ...)*), void (i8*, ...)** %6, align 8, !noalias !9
  store %struct.anon.3* %19, %struct.anon.3** %7, align 8, !noalias !9
  %22 = load %struct.anon.3*, %struct.anon.3** %7, align 8, !noalias !9
  %23 = load void (i8*, ...)*, void (i8*, ...)** %6, align 8, !noalias !9
  %24 = load i8*, i8** %5, align 8, !noalias !9
  call void (i8*, ...) %23(i8* %24, [500 x float]** %8) #5
  %25 = load [500 x float]*, [500 x float]** %8, align 8, !noalias !9
  store i32 0, i32* %9, align 4, !noalias !9
  br label %26

; <label>:26:                                     ; preds = %29, %2
  %27 = load i32, i32* %9, align 4, !noalias !9
  %28 = icmp slt i32 %27, 10000000
  br i1 %28, label %29, label %40

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* %9, align 4, !noalias !9
  %31 = srem i32 %30, 500
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [500 x float], [500 x float]* %25, i64 0, i64 %32
  %34 = load float, float* %33, align 4
  %35 = fpext float %34 to double
  %36 = fsub double %35, 4.000000e+00
  %37 = fptrunc double %36 to float
  store float %37, float* %33, align 4
  %38 = load i32, i32* %9, align 4, !noalias !9
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %9, align 4, !noalias !9
  br label %26

; <label>:40:                                     ; preds = %26
  ret i32 0
}

; Function Attrs: alwaysinline nounwind uwtable
define internal void @.omp_task_privates_map..9(%struct..kmp_privates.t.8* noalias, [500 x float]** noalias) #4 {
  %3 = alloca %struct..kmp_privates.t.8*, align 8
  %4 = alloca [500 x float]**, align 8
  store %struct..kmp_privates.t.8* %0, %struct..kmp_privates.t.8** %3, align 8
  store [500 x float]** %1, [500 x float]*** %4, align 8
  %5 = load %struct..kmp_privates.t.8*, %struct..kmp_privates.t.8** %3, align 8
  %6 = getelementptr inbounds %struct..kmp_privates.t.8, %struct..kmp_privates.t.8* %5, i32 0, i32 0
  %7 = load [500 x float]**, [500 x float]*** %4, align 8
  store [500 x float]* %6, [500 x float]** %7, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..10(i32, %struct.kmp_task_t_with_privates.7* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.6*, align 8
  %8 = alloca [500 x float]*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.kmp_task_t_with_privates.7*, align 8
  store i32 %0, i32* %10, align 4
  store %struct.kmp_task_t_with_privates.7* %1, %struct.kmp_task_t_with_privates.7** %11, align 8
  %12 = load i32, i32* %10, align 4
  %13 = load %struct.kmp_task_t_with_privates.7*, %struct.kmp_task_t_with_privates.7** %11, align 8
  %14 = getelementptr inbounds %struct.kmp_task_t_with_privates.7, %struct.kmp_task_t_with_privates.7* %13, i32 0, i32 0
  %15 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 2
  %16 = load i32, i32* %15, align 8
  %17 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %14, i32 0, i32 0
  %18 = load i8*, i8** %17, align 8
  %19 = bitcast i8* %18 to %struct.anon.6*
  %20 = getelementptr inbounds %struct.kmp_task_t_with_privates.7, %struct.kmp_task_t_with_privates.7* %13, i32 0, i32 1
  %21 = bitcast %struct..kmp_privates.t.8* %20 to i8*
  store i32 %12, i32* %3, align 4, !noalias !13
  store i32 %16, i32* %4, align 4, !noalias !13
  store i8* %21, i8** %5, align 8, !noalias !13
  store void (i8*, ...)* bitcast (void (%struct..kmp_privates.t.8*, [500 x float]**)* @.omp_task_privates_map..9 to void (i8*, ...)*), void (i8*, ...)** %6, align 8, !noalias !13
  store %struct.anon.6* %19, %struct.anon.6** %7, align 8, !noalias !13
  %22 = load %struct.anon.6*, %struct.anon.6** %7, align 8, !noalias !13
  %23 = load void (i8*, ...)*, void (i8*, ...)** %6, align 8, !noalias !13
  %24 = load i8*, i8** %5, align 8, !noalias !13
  call void (i8*, ...) %23(i8* %24, [500 x float]** %8) #5
  %25 = load [500 x float]*, [500 x float]** %8, align 8, !noalias !13
  store i32 0, i32* %9, align 4, !noalias !13
  br label %26

; <label>:26:                                     ; preds = %29, %2
  %27 = load i32, i32* %9, align 4, !noalias !13
  %28 = icmp slt i32 %27, 10000000
  br i1 %28, label %29, label %40

; <label>:29:                                     ; preds = %26
  %30 = load i32, i32* %9, align 4, !noalias !13
  %31 = srem i32 %30, 500
  %32 = sext i32 %31 to i64
  %33 = getelementptr inbounds [500 x float], [500 x float]* %25, i64 0, i64 %32
  %34 = load float, float* %33, align 4
  %35 = fpext float %34 to double
  %36 = fsub double %35, 4.000000e+00
  %37 = fptrunc double %36 to float
  store float %37, float* %33, align 4
  %38 = load i32, i32* %9, align 4, !noalias !13
  %39 = add nsw i32 %38, 1
  store i32 %39, i32* %9, align 4, !noalias !13
  br label %26

; <label>:40:                                     ; preds = %26
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..12(i32, %struct.kmp_task_t_with_privates.10* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.9*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates.10*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates.10* %1, %struct.kmp_task_t_with_privates.10** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates.10*, %struct.kmp_task_t_with_privates.10** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates.10, %struct.kmp_task_t_with_privates.10* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon.9*
  store i32 %11, i32* %3, align 4, !noalias !17
  store i32 %15, i32* %4, align 4, !noalias !17
  store i8* null, i8** %5, align 8, !noalias !17
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !17
  store %struct.anon.9* %18, %struct.anon.9** %7, align 8, !noalias !17
  %19 = load %struct.anon.9*, %struct.anon.9** %7, align 8, !noalias !17
  store i32 0, i32* %8, align 4, !noalias !17
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i32, i32* %8, align 4, !noalias !17
  %22 = icmp slt i32 %21, 10000000
  br i1 %22, label %23, label %36

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %8, align 4, !noalias !17
  %25 = srem i32 %24, 500
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds %struct.anon.9, %struct.anon.9* %19, i32 0, i32 0
  %28 = load [500 x float]*, [500 x float]** %27, align 8
  %29 = getelementptr inbounds [500 x float], [500 x float]* %28, i64 0, i64 %26
  %30 = load float, float* %29, align 4
  %31 = fpext float %30 to double
  %32 = fsub double %31, 4.000000e+00
  %33 = fptrunc double %32 to float
  store float %33, float* %29, align 4
  %34 = load i32, i32* %8, align 4, !noalias !17
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %8, align 4, !noalias !17
  br label %20

; <label>:36:                                     ; preds = %20
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..14(i32, %struct.kmp_task_t_with_privates.12* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.11*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates.12*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates.12* %1, %struct.kmp_task_t_with_privates.12** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates.12*, %struct.kmp_task_t_with_privates.12** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates.12, %struct.kmp_task_t_with_privates.12* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon.11*
  store i32 %11, i32* %3, align 4, !noalias !21
  store i32 %15, i32* %4, align 4, !noalias !21
  store i8* null, i8** %5, align 8, !noalias !21
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !21
  store %struct.anon.11* %18, %struct.anon.11** %7, align 8, !noalias !21
  %19 = load %struct.anon.11*, %struct.anon.11** %7, align 8, !noalias !21
  store i32 0, i32* %8, align 4, !noalias !21
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i32, i32* %8, align 4, !noalias !21
  %22 = icmp slt i32 %21, 10000000
  br i1 %22, label %23, label %36

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %8, align 4, !noalias !21
  %25 = srem i32 %24, 500
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds %struct.anon.11, %struct.anon.11* %19, i32 0, i32 0
  %28 = load [500 x float]*, [500 x float]** %27, align 8
  %29 = getelementptr inbounds [500 x float], [500 x float]* %28, i64 0, i64 %26
  %30 = load float, float* %29, align 4
  %31 = fpext float %30 to double
  %32 = fsub double %31, 4.000000e+00
  %33 = fptrunc double %32 to float
  store float %33, float* %29, align 4
  %34 = load i32, i32* %8, align 4, !noalias !21
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %8, align 4, !noalias !21
  br label %20

; <label>:36:                                     ; preds = %20
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..16(i32, %struct.kmp_task_t_with_privates.14* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.13*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates.14*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates.14* %1, %struct.kmp_task_t_with_privates.14** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates.14*, %struct.kmp_task_t_with_privates.14** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates.14, %struct.kmp_task_t_with_privates.14* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon.13*
  store i32 %11, i32* %3, align 4, !noalias !25
  store i32 %15, i32* %4, align 4, !noalias !25
  store i8* null, i8** %5, align 8, !noalias !25
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !25
  store %struct.anon.13* %18, %struct.anon.13** %7, align 8, !noalias !25
  %19 = load %struct.anon.13*, %struct.anon.13** %7, align 8, !noalias !25
  store i32 0, i32* %8, align 4, !noalias !25
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i32, i32* %8, align 4, !noalias !25
  %22 = icmp slt i32 %21, 10000000
  br i1 %22, label %23, label %36

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %8, align 4, !noalias !25
  %25 = srem i32 %24, 500
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds %struct.anon.13, %struct.anon.13* %19, i32 0, i32 0
  %28 = load [500 x float]*, [500 x float]** %27, align 8
  %29 = getelementptr inbounds [500 x float], [500 x float]* %28, i64 0, i64 %26
  %30 = load float, float* %29, align 4
  %31 = fpext float %30 to double
  %32 = fsub double %31, 4.000000e+00
  %33 = fptrunc double %32 to float
  store float %33, float* %29, align 4
  %34 = load i32, i32* %8, align 4, !noalias !25
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %8, align 4, !noalias !25
  br label %20

; <label>:36:                                     ; preds = %20
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal i32 @.omp_task_entry..18(i32, %struct.kmp_task_t_with_privates.16* noalias) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca void (i8*, ...)*, align 8
  %7 = alloca %struct.anon.15*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.kmp_task_t_with_privates.16*, align 8
  store i32 %0, i32* %9, align 4
  store %struct.kmp_task_t_with_privates.16* %1, %struct.kmp_task_t_with_privates.16** %10, align 8
  %11 = load i32, i32* %9, align 4
  %12 = load %struct.kmp_task_t_with_privates.16*, %struct.kmp_task_t_with_privates.16** %10, align 8
  %13 = getelementptr inbounds %struct.kmp_task_t_with_privates.16, %struct.kmp_task_t_with_privates.16* %12, i32 0, i32 0
  %14 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 2
  %15 = load i32, i32* %14, align 8
  %16 = getelementptr inbounds %struct.kmp_task_t, %struct.kmp_task_t* %13, i32 0, i32 0
  %17 = load i8*, i8** %16, align 8
  %18 = bitcast i8* %17 to %struct.anon.15*
  store i32 %11, i32* %3, align 4, !noalias !29
  store i32 %15, i32* %4, align 4, !noalias !29
  store i8* null, i8** %5, align 8, !noalias !29
  store void (i8*, ...)* null, void (i8*, ...)** %6, align 8, !noalias !29
  store %struct.anon.15* %18, %struct.anon.15** %7, align 8, !noalias !29
  %19 = load %struct.anon.15*, %struct.anon.15** %7, align 8, !noalias !29
  store i32 0, i32* %8, align 4, !noalias !29
  br label %20

; <label>:20:                                     ; preds = %23, %2
  %21 = load i32, i32* %8, align 4, !noalias !29
  %22 = icmp slt i32 %21, 10000000
  br i1 %22, label %23, label %36

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %8, align 4, !noalias !29
  %25 = srem i32 %24, 500
  %26 = sext i32 %25 to i64
  %27 = getelementptr inbounds %struct.anon.15, %struct.anon.15* %19, i32 0, i32 0
  %28 = load [500 x float]*, [500 x float]** %27, align 8
  %29 = getelementptr inbounds [500 x float], [500 x float]* %28, i64 0, i64 %26
  %30 = load float, float* %29, align 4
  %31 = fpext float %30 to double
  %32 = fsub double %31, 4.000000e+00
  %33 = fptrunc double %32 to float
  store float %33, float* %29, align 4
  %34 = load i32, i32* %8, align 4, !noalias !29
  %35 = add nsw i32 %34, 1
  store i32 %35, i32* %8, align 4, !noalias !29
  br label %20

; <label>:36:                                     ; preds = %20
  ret i32 0
}

declare i32 @__kmpc_omp_taskwait(%ident_t*, i32)

declare void @__kmpc_fork_call(%ident_t*, i32, void (i32*, i32*, ...)*, ...)

declare i32 @printf(i8*, ...) #2

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { alwaysinline nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

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
!9 = !{!10, !12}
!10 = distinct !{!10, !11, !".omp_outlined..5: argument 0"}
!11 = distinct !{!11, !".omp_outlined..5"}
!12 = distinct !{!12, !11, !".omp_outlined..5: argument 1"}
!13 = !{!14, !16}
!14 = distinct !{!14, !15, !".omp_outlined..8: argument 0"}
!15 = distinct !{!15, !".omp_outlined..8"}
!16 = distinct !{!16, !15, !".omp_outlined..8: argument 1"}
!17 = !{!18, !20}
!18 = distinct !{!18, !19, !".omp_outlined..11: argument 0"}
!19 = distinct !{!19, !".omp_outlined..11"}
!20 = distinct !{!20, !19, !".omp_outlined..11: argument 1"}
!21 = !{!22, !24}
!22 = distinct !{!22, !23, !".omp_outlined..13: argument 0"}
!23 = distinct !{!23, !".omp_outlined..13"}
!24 = distinct !{!24, !23, !".omp_outlined..13: argument 1"}
!25 = !{!26, !28}
!26 = distinct !{!26, !27, !".omp_outlined..15: argument 0"}
!27 = distinct !{!27, !".omp_outlined..15"}
!28 = distinct !{!28, !27, !".omp_outlined..15: argument 1"}
!29 = !{!30, !32}
!30 = distinct !{!30, !31, !".omp_outlined..17: argument 0"}
!31 = distinct !{!31, !".omp_outlined..17"}
!32 = distinct !{!32, !31, !".omp_outlined..17: argument 1"}
