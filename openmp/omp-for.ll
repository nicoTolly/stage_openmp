; ModuleID = 'omp-for.c'
source_filename = "omp-for.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr constant %ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8
@.str.1 = private unnamed_addr constant [25 x i8] c"non ordered, i=%d, j=%d\0A\00", align 1
@.str.2 = private unnamed_addr constant [21 x i8] c"ordered, i=%d, j=%d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32, i8**) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  store i8** %1, i8*** %5, align 8
  call void (%ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%ident_t* @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal void @.omp_outlined.(i32* noalias, i32* noalias) #0 {
  %3 = alloca i32*, align 8
  %4 = alloca i32*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  store i32* %1, i32** %4, align 8
  store i32 0, i32* %6, align 4
  store i32 11, i32* %7, align 4
  store i32 1, i32* %8, align 4
  store i32 0, i32* %9, align 4
  %12 = load i32*, i32** %3, align 8
  %13 = load i32, i32* %12, align 4
  call void @__kmpc_dispatch_init_4(%ident_t* @0, i32 %13, i32 66, i32 0, i32 11, i32 1, i32 1)
  br label %14

; <label>:14:                                     ; preds = %52, %2
  %15 = call i32 @__kmpc_dispatch_next_4(%ident_t* @0, i32 %13, i32* %9, i32* %6, i32* %7, i32* %8)
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %17, label %53

; <label>:17:                                     ; preds = %14
  %18 = load i32, i32* %6, align 4
  store i32 %18, i32* %5, align 4
  br label %19

; <label>:19:                                     ; preds = %48, %17
  %20 = load i32, i32* %5, align 4
  %21 = load i32, i32* %7, align 4
  %22 = icmp sle i32 %20, %21
  br i1 %22, label %23, label %51

; <label>:23:                                     ; preds = %19
  %24 = load i32, i32* %5, align 4
  %25 = mul nsw i32 %24, 1
  %26 = add nsw i32 0, %25
  store i32 %26, i32* %10, align 4
  store i32 0, i32* %11, align 4
  br label %27

; <label>:27:                                     ; preds = %43, %23
  %28 = load i32, i32* %11, align 4
  %29 = icmp slt i32 %28, 12
  br i1 %29, label %30, label %46

; <label>:30:                                     ; preds = %27
  %31 = load i32, i32* %10, align 4
  %32 = load i32, i32* %11, align 4
  %33 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.1, i32 0, i32 0), i32 %31, i32 %32)
  %34 = load i32, i32* %10, align 4
  %35 = load i32, i32* %11, align 4
  %36 = mul nsw i32 %34, %35
  %37 = add nsw i32 %36, 1
  %38 = sdiv i32 1, %37
  %39 = call i32 @sleep(i32 %38)
  call void @__kmpc_ordered(%ident_t* @0, i32 %13)
  %40 = load i32, i32* %10, align 4
  %41 = load i32, i32* %11, align 4
  %42 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.2, i32 0, i32 0), i32 %40, i32 %41)
  call void @__kmpc_end_ordered(%ident_t* @0, i32 %13)
  br label %43

; <label>:43:                                     ; preds = %30
  %44 = load i32, i32* %11, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, i32* %11, align 4
  br label %27

; <label>:46:                                     ; preds = %27
  br label %47

; <label>:47:                                     ; preds = %46
  br label %48

; <label>:48:                                     ; preds = %47
  %49 = load i32, i32* %5, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, i32* %5, align 4
  call void @__kmpc_dispatch_fini_4(%ident_t* @0, i32 %13)
  br label %19

; <label>:51:                                     ; preds = %19
  br label %52

; <label>:52:                                     ; preds = %51
  br label %14

; <label>:53:                                     ; preds = %14
  ret void
}

declare void @__kmpc_dispatch_init_4(%ident_t*, i32, i32, i32, i32, i32, i32)

declare i32 @__kmpc_dispatch_next_4(%ident_t*, i32, i32*, i32*, i32*, i32*)

declare i32 @printf(i8*, ...) #1

declare i32 @sleep(i32) #1

declare void @__kmpc_end_ordered(%ident_t*, i32)

declare void @__kmpc_ordered(%ident_t*, i32)

declare void @__kmpc_dispatch_fini_4(%ident_t*, i32)

declare void @__kmpc_fork_call(%ident_t*, i32, void (i32*, i32*, ...)*, ...)

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.9.0 (git@github.com:llvm-mirror/clang.git a6a2b89b5f44fe7b88101cb7e9e0f03576005d7f) (git@github.com:nicoTolly/llvm.git 3b8a73e9fe8d4aa0b6d2130d41d8080e21ea741b)"}
