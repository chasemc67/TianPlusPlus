; ModuleID = 'cfunctions.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c" %d\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c" ]\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @allocateVec(i32** %x, i32 %size) #0 {
  %1 = alloca i32**, align 8
  %2 = alloca i32, align 4
  store i32** %x, i32*** %1, align 8
  store i32 %size, i32* %2, align 4
  %3 = load i32* %2, align 4
  %4 = add nsw i32 %3, 1
  %5 = sext i32 %4 to i64
  %6 = mul i64 %5, 4
  %7 = call noalias i8* @malloc(i64 %6) #3
  %8 = bitcast i8* %7 to i32*
  %9 = load i32*** %1, align 8
  store i32* %8, i32** %9, align 8
  %10 = load i32* %2, align 4
  %11 = load i32*** %1, align 8
  %12 = getelementptr inbounds i32** %11, i64 0
  %13 = load i32** %12, align 8
  store i32 %10, i32* %13, align 4
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #1

; Function Attrs: nounwind uwtable
define void @printVec(i32* %x) #0 {
  %1 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %x, i32** %1, align 8
  %2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str, i32 0, i32 0))
  %3 = load i32** %1, align 8
  %4 = getelementptr inbounds i32* %3, i64 0
  %5 = load i32* %4, align 4
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32 %5)
  store i32 1, i32* %i, align 4
  br label %7

; <label>:7                                       ; preds = %21, %0
  %8 = load i32* %i, align 4
  %9 = load i32** %1, align 8
  %10 = getelementptr inbounds i32* %9, i64 0
  %11 = load i32* %10, align 4
  %12 = add nsw i32 %11, 1
  %13 = icmp slt i32 %8, %12
  br i1 %13, label %14, label %24

; <label>:14                                      ; preds = %7
  %15 = load i32* %i, align 4
  %16 = sext i32 %15 to i64
  %17 = load i32** %1, align 8
  %18 = getelementptr inbounds i32* %17, i64 %16
  %19 = load i32* %18, align 4
  %20 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i32 %19)
  br label %21

; <label>:21                                      ; preds = %14
  %22 = load i32* %i, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %i, align 4
  br label %7

; <label>:24                                      ; preds = %7
  %25 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str3, i32 0, i32 0))
  ret void
}

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind uwtable
define void @swapVec(i32** %x, i32** %y) #0 {
  %1 = alloca i32**, align 8
  %2 = alloca i32**, align 8
  %tmp = alloca i32*, align 8
  store i32** %x, i32*** %1, align 8
  store i32** %y, i32*** %2, align 8
  %3 = load i32*** %1, align 8
  %4 = load i32** %3, align 8
  store i32* %4, i32** %tmp, align 8
  %5 = load i32*** %2, align 8
  %6 = load i32** %5, align 8
  %7 = load i32*** %1, align 8
  store i32* %6, i32** %7, align 8
  %8 = load i32** %tmp, align 8
  %9 = load i32*** %2, align 8
  store i32* %8, i32** %9, align 8
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @getMaxSize(i32* %var, i32* %var2) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  store i32* %var, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  %4 = load i32** %2, align 8
  %5 = getelementptr inbounds i32* %4, i64 0
  %6 = load i32* %5, align 4
  %7 = load i32** %3, align 8
  %8 = getelementptr inbounds i32* %7, i64 0
  %9 = load i32* %8, align 4
  %10 = icmp sgt i32 %6, %9
  br i1 %10, label %11, label %15

; <label>:11                                      ; preds = %0
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  store i32 %14, i32* %1
  br label %19

; <label>:15                                      ; preds = %0
  %16 = load i32** %3, align 8
  %17 = getelementptr inbounds i32* %16, i64 0
  %18 = load i32* %17, align 4
  store i32 %18, i32* %1
  br label %19

; <label>:19                                      ; preds = %15, %11
  %20 = load i32* %1
  ret i32 %20
}

; Function Attrs: nounwind uwtable
define void @addVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %62, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %65

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %27

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = load i32* %i, align 4
  %24 = sext i32 %23 to i64
  %25 = load i32** %1, align 8
  %26 = getelementptr inbounds i32* %25, i64 %24
  store i32 %22, i32* %26, align 4
  br label %61

; <label>:27                                      ; preds = %10
  %28 = load i32* %i, align 4
  %29 = load i32** %3, align 8
  %30 = getelementptr inbounds i32* %29, i64 0
  %31 = load i32* %30, align 4
  %32 = add nsw i32 %31, 1
  %33 = icmp sge i32 %28, %32
  br i1 %33, label %34, label %44

; <label>:34                                      ; preds = %27
  %35 = load i32* %i, align 4
  %36 = sext i32 %35 to i64
  %37 = load i32** %2, align 8
  %38 = getelementptr inbounds i32* %37, i64 %36
  %39 = load i32* %38, align 4
  %40 = load i32* %i, align 4
  %41 = sext i32 %40 to i64
  %42 = load i32** %1, align 8
  %43 = getelementptr inbounds i32* %42, i64 %41
  store i32 %39, i32* %43, align 4
  br label %60

; <label>:44                                      ; preds = %27
  %45 = load i32* %i, align 4
  %46 = sext i32 %45 to i64
  %47 = load i32** %2, align 8
  %48 = getelementptr inbounds i32* %47, i64 %46
  %49 = load i32* %48, align 4
  %50 = load i32* %i, align 4
  %51 = sext i32 %50 to i64
  %52 = load i32** %3, align 8
  %53 = getelementptr inbounds i32* %52, i64 %51
  %54 = load i32* %53, align 4
  %55 = add nsw i32 %49, %54
  %56 = load i32* %i, align 4
  %57 = sext i32 %56 to i64
  %58 = load i32** %1, align 8
  %59 = getelementptr inbounds i32* %58, i64 %57
  store i32 %55, i32* %59, align 4
  br label %60

; <label>:60                                      ; preds = %44, %34
  br label %61

; <label>:61                                      ; preds = %60, %17
  br label %62

; <label>:62                                      ; preds = %61
  %63 = load i32* %i, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, i32* %i, align 4
  br label %4

; <label>:65                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @subVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %62, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %65

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %27

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = load i32* %i, align 4
  %24 = sext i32 %23 to i64
  %25 = load i32** %1, align 8
  %26 = getelementptr inbounds i32* %25, i64 %24
  store i32 %22, i32* %26, align 4
  br label %61

; <label>:27                                      ; preds = %10
  %28 = load i32* %i, align 4
  %29 = load i32** %3, align 8
  %30 = getelementptr inbounds i32* %29, i64 0
  %31 = load i32* %30, align 4
  %32 = add nsw i32 %31, 1
  %33 = icmp sge i32 %28, %32
  br i1 %33, label %34, label %44

; <label>:34                                      ; preds = %27
  %35 = load i32* %i, align 4
  %36 = sext i32 %35 to i64
  %37 = load i32** %2, align 8
  %38 = getelementptr inbounds i32* %37, i64 %36
  %39 = load i32* %38, align 4
  %40 = load i32* %i, align 4
  %41 = sext i32 %40 to i64
  %42 = load i32** %1, align 8
  %43 = getelementptr inbounds i32* %42, i64 %41
  store i32 %39, i32* %43, align 4
  br label %60

; <label>:44                                      ; preds = %27
  %45 = load i32* %i, align 4
  %46 = sext i32 %45 to i64
  %47 = load i32** %2, align 8
  %48 = getelementptr inbounds i32* %47, i64 %46
  %49 = load i32* %48, align 4
  %50 = load i32* %i, align 4
  %51 = sext i32 %50 to i64
  %52 = load i32** %3, align 8
  %53 = getelementptr inbounds i32* %52, i64 %51
  %54 = load i32* %53, align 4
  %55 = sub nsw i32 %49, %54
  %56 = load i32* %i, align 4
  %57 = sext i32 %56 to i64
  %58 = load i32** %1, align 8
  %59 = getelementptr inbounds i32* %58, i64 %57
  store i32 %55, i32* %59, align 4
  br label %60

; <label>:60                                      ; preds = %44, %34
  br label %61

; <label>:61                                      ; preds = %60, %17
  br label %62

; <label>:62                                      ; preds = %61
  %63 = load i32* %i, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, i32* %i, align 4
  br label %4

; <label>:65                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @mulVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %62, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %65

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %27

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = load i32* %i, align 4
  %24 = sext i32 %23 to i64
  %25 = load i32** %1, align 8
  %26 = getelementptr inbounds i32* %25, i64 %24
  store i32 %22, i32* %26, align 4
  br label %61

; <label>:27                                      ; preds = %10
  %28 = load i32* %i, align 4
  %29 = load i32** %3, align 8
  %30 = getelementptr inbounds i32* %29, i64 0
  %31 = load i32* %30, align 4
  %32 = add nsw i32 %31, 1
  %33 = icmp sge i32 %28, %32
  br i1 %33, label %34, label %44

; <label>:34                                      ; preds = %27
  %35 = load i32* %i, align 4
  %36 = sext i32 %35 to i64
  %37 = load i32** %2, align 8
  %38 = getelementptr inbounds i32* %37, i64 %36
  %39 = load i32* %38, align 4
  %40 = load i32* %i, align 4
  %41 = sext i32 %40 to i64
  %42 = load i32** %1, align 8
  %43 = getelementptr inbounds i32* %42, i64 %41
  store i32 %39, i32* %43, align 4
  br label %60

; <label>:44                                      ; preds = %27
  %45 = load i32* %i, align 4
  %46 = sext i32 %45 to i64
  %47 = load i32** %2, align 8
  %48 = getelementptr inbounds i32* %47, i64 %46
  %49 = load i32* %48, align 4
  %50 = load i32* %i, align 4
  %51 = sext i32 %50 to i64
  %52 = load i32** %3, align 8
  %53 = getelementptr inbounds i32* %52, i64 %51
  %54 = load i32* %53, align 4
  %55 = mul nsw i32 %49, %54
  %56 = load i32* %i, align 4
  %57 = sext i32 %56 to i64
  %58 = load i32** %1, align 8
  %59 = getelementptr inbounds i32* %58, i64 %57
  store i32 %55, i32* %59, align 4
  br label %60

; <label>:60                                      ; preds = %44, %34
  br label %61

; <label>:61                                      ; preds = %60, %17
  br label %62

; <label>:62                                      ; preds = %61
  %63 = load i32* %i, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, i32* %i, align 4
  br label %4

; <label>:65                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @divVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %62, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %65

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %27

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = load i32* %i, align 4
  %24 = sext i32 %23 to i64
  %25 = load i32** %1, align 8
  %26 = getelementptr inbounds i32* %25, i64 %24
  store i32 %22, i32* %26, align 4
  br label %61

; <label>:27                                      ; preds = %10
  %28 = load i32* %i, align 4
  %29 = load i32** %3, align 8
  %30 = getelementptr inbounds i32* %29, i64 0
  %31 = load i32* %30, align 4
  %32 = add nsw i32 %31, 1
  %33 = icmp sge i32 %28, %32
  br i1 %33, label %34, label %44

; <label>:34                                      ; preds = %27
  %35 = load i32* %i, align 4
  %36 = sext i32 %35 to i64
  %37 = load i32** %2, align 8
  %38 = getelementptr inbounds i32* %37, i64 %36
  %39 = load i32* %38, align 4
  %40 = load i32* %i, align 4
  %41 = sext i32 %40 to i64
  %42 = load i32** %1, align 8
  %43 = getelementptr inbounds i32* %42, i64 %41
  store i32 %39, i32* %43, align 4
  br label %60

; <label>:44                                      ; preds = %27
  %45 = load i32* %i, align 4
  %46 = sext i32 %45 to i64
  %47 = load i32** %2, align 8
  %48 = getelementptr inbounds i32* %47, i64 %46
  %49 = load i32* %48, align 4
  %50 = load i32* %i, align 4
  %51 = sext i32 %50 to i64
  %52 = load i32** %3, align 8
  %53 = getelementptr inbounds i32* %52, i64 %51
  %54 = load i32* %53, align 4
  %55 = sdiv i32 %49, %54
  %56 = load i32* %i, align 4
  %57 = sext i32 %56 to i64
  %58 = load i32** %1, align 8
  %59 = getelementptr inbounds i32* %58, i64 %57
  store i32 %55, i32* %59, align 4
  br label %60

; <label>:60                                      ; preds = %44, %34
  br label %61

; <label>:61                                      ; preds = %60, %17
  br label %62

; <label>:62                                      ; preds = %61
  %63 = load i32* %i, align 4
  %64 = add nsw i32 %63, 1
  store i32 %64, i32* %i, align 4
  br label %4

; <label>:65                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @equalVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %67, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %70

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %29

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = icmp eq i32 %22, 0
  %24 = zext i1 %23 to i32
  %25 = load i32* %i, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32** %1, align 8
  %28 = getelementptr inbounds i32* %27, i64 %26
  store i32 %24, i32* %28, align 4
  br label %66

; <label>:29                                      ; preds = %10
  %30 = load i32* %i, align 4
  %31 = load i32** %3, align 8
  %32 = getelementptr inbounds i32* %31, i64 0
  %33 = load i32* %32, align 4
  %34 = add nsw i32 %33, 1
  %35 = icmp sge i32 %30, %34
  br i1 %35, label %36, label %48

; <label>:36                                      ; preds = %29
  %37 = load i32* %i, align 4
  %38 = sext i32 %37 to i64
  %39 = load i32** %2, align 8
  %40 = getelementptr inbounds i32* %39, i64 %38
  %41 = load i32* %40, align 4
  %42 = icmp eq i32 %41, 0
  %43 = zext i1 %42 to i32
  %44 = load i32* %i, align 4
  %45 = sext i32 %44 to i64
  %46 = load i32** %1, align 8
  %47 = getelementptr inbounds i32* %46, i64 %45
  store i32 %43, i32* %47, align 4
  br label %65

; <label>:48                                      ; preds = %29
  %49 = load i32* %i, align 4
  %50 = sext i32 %49 to i64
  %51 = load i32** %2, align 8
  %52 = getelementptr inbounds i32* %51, i64 %50
  %53 = load i32* %52, align 4
  %54 = load i32* %i, align 4
  %55 = sext i32 %54 to i64
  %56 = load i32** %3, align 8
  %57 = getelementptr inbounds i32* %56, i64 %55
  %58 = load i32* %57, align 4
  %59 = icmp eq i32 %53, %58
  %60 = zext i1 %59 to i32
  %61 = load i32* %i, align 4
  %62 = sext i32 %61 to i64
  %63 = load i32** %1, align 8
  %64 = getelementptr inbounds i32* %63, i64 %62
  store i32 %60, i32* %64, align 4
  br label %65

; <label>:65                                      ; preds = %48, %36
  br label %66

; <label>:66                                      ; preds = %65, %17
  br label %67

; <label>:67                                      ; preds = %66
  %68 = load i32* %i, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %i, align 4
  br label %4

; <label>:70                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @notEqualsVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %67, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %70

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %29

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = icmp ne i32 %22, 0
  %24 = zext i1 %23 to i32
  %25 = load i32* %i, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32** %1, align 8
  %28 = getelementptr inbounds i32* %27, i64 %26
  store i32 %24, i32* %28, align 4
  br label %66

; <label>:29                                      ; preds = %10
  %30 = load i32* %i, align 4
  %31 = load i32** %3, align 8
  %32 = getelementptr inbounds i32* %31, i64 0
  %33 = load i32* %32, align 4
  %34 = add nsw i32 %33, 1
  %35 = icmp sge i32 %30, %34
  br i1 %35, label %36, label %48

; <label>:36                                      ; preds = %29
  %37 = load i32* %i, align 4
  %38 = sext i32 %37 to i64
  %39 = load i32** %2, align 8
  %40 = getelementptr inbounds i32* %39, i64 %38
  %41 = load i32* %40, align 4
  %42 = icmp ne i32 %41, 0
  %43 = zext i1 %42 to i32
  %44 = load i32* %i, align 4
  %45 = sext i32 %44 to i64
  %46 = load i32** %1, align 8
  %47 = getelementptr inbounds i32* %46, i64 %45
  store i32 %43, i32* %47, align 4
  br label %65

; <label>:48                                      ; preds = %29
  %49 = load i32* %i, align 4
  %50 = sext i32 %49 to i64
  %51 = load i32** %2, align 8
  %52 = getelementptr inbounds i32* %51, i64 %50
  %53 = load i32* %52, align 4
  %54 = load i32* %i, align 4
  %55 = sext i32 %54 to i64
  %56 = load i32** %3, align 8
  %57 = getelementptr inbounds i32* %56, i64 %55
  %58 = load i32* %57, align 4
  %59 = icmp ne i32 %53, %58
  %60 = zext i1 %59 to i32
  %61 = load i32* %i, align 4
  %62 = sext i32 %61 to i64
  %63 = load i32** %1, align 8
  %64 = getelementptr inbounds i32* %63, i64 %62
  store i32 %60, i32* %64, align 4
  br label %65

; <label>:65                                      ; preds = %48, %36
  br label %66

; <label>:66                                      ; preds = %65, %17
  br label %67

; <label>:67                                      ; preds = %66
  %68 = load i32* %i, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %i, align 4
  br label %4

; <label>:70                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @lessVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %67, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %70

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %29

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = icmp slt i32 %22, 0
  %24 = zext i1 %23 to i32
  %25 = load i32* %i, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32** %1, align 8
  %28 = getelementptr inbounds i32* %27, i64 %26
  store i32 %24, i32* %28, align 4
  br label %66

; <label>:29                                      ; preds = %10
  %30 = load i32* %i, align 4
  %31 = load i32** %3, align 8
  %32 = getelementptr inbounds i32* %31, i64 0
  %33 = load i32* %32, align 4
  %34 = add nsw i32 %33, 1
  %35 = icmp sge i32 %30, %34
  br i1 %35, label %36, label %48

; <label>:36                                      ; preds = %29
  %37 = load i32* %i, align 4
  %38 = sext i32 %37 to i64
  %39 = load i32** %2, align 8
  %40 = getelementptr inbounds i32* %39, i64 %38
  %41 = load i32* %40, align 4
  %42 = icmp slt i32 %41, 0
  %43 = zext i1 %42 to i32
  %44 = load i32* %i, align 4
  %45 = sext i32 %44 to i64
  %46 = load i32** %1, align 8
  %47 = getelementptr inbounds i32* %46, i64 %45
  store i32 %43, i32* %47, align 4
  br label %65

; <label>:48                                      ; preds = %29
  %49 = load i32* %i, align 4
  %50 = sext i32 %49 to i64
  %51 = load i32** %2, align 8
  %52 = getelementptr inbounds i32* %51, i64 %50
  %53 = load i32* %52, align 4
  %54 = load i32* %i, align 4
  %55 = sext i32 %54 to i64
  %56 = load i32** %3, align 8
  %57 = getelementptr inbounds i32* %56, i64 %55
  %58 = load i32* %57, align 4
  %59 = icmp slt i32 %53, %58
  %60 = zext i1 %59 to i32
  %61 = load i32* %i, align 4
  %62 = sext i32 %61 to i64
  %63 = load i32** %1, align 8
  %64 = getelementptr inbounds i32* %63, i64 %62
  store i32 %60, i32* %64, align 4
  br label %65

; <label>:65                                      ; preds = %48, %36
  br label %66

; <label>:66                                      ; preds = %65, %17
  br label %67

; <label>:67                                      ; preds = %66
  %68 = load i32* %i, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %i, align 4
  br label %4

; <label>:70                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @greatVars(i32* %newVar, i32* %var1, i32* %var2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32* %var1, i32** %2, align 8
  store i32* %var2, i32** %3, align 8
  store i32 1, i32* %i, align 4
  br label %4

; <label>:4                                       ; preds = %67, %0
  %5 = load i32* %i, align 4
  %6 = load i32** %1, align 8
  %7 = getelementptr inbounds i32* %6, i64 0
  %8 = load i32* %7, align 4
  %9 = icmp sle i32 %5, %8
  br i1 %9, label %10, label %70

; <label>:10                                      ; preds = %4
  %11 = load i32* %i, align 4
  %12 = load i32** %2, align 8
  %13 = getelementptr inbounds i32* %12, i64 0
  %14 = load i32* %13, align 4
  %15 = add nsw i32 %14, 1
  %16 = icmp sge i32 %11, %15
  br i1 %16, label %17, label %29

; <label>:17                                      ; preds = %10
  %18 = load i32* %i, align 4
  %19 = sext i32 %18 to i64
  %20 = load i32** %3, align 8
  %21 = getelementptr inbounds i32* %20, i64 %19
  %22 = load i32* %21, align 4
  %23 = icmp sgt i32 %22, 0
  %24 = zext i1 %23 to i32
  %25 = load i32* %i, align 4
  %26 = sext i32 %25 to i64
  %27 = load i32** %1, align 8
  %28 = getelementptr inbounds i32* %27, i64 %26
  store i32 %24, i32* %28, align 4
  br label %66

; <label>:29                                      ; preds = %10
  %30 = load i32* %i, align 4
  %31 = load i32** %3, align 8
  %32 = getelementptr inbounds i32* %31, i64 0
  %33 = load i32* %32, align 4
  %34 = add nsw i32 %33, 1
  %35 = icmp sge i32 %30, %34
  br i1 %35, label %36, label %48

; <label>:36                                      ; preds = %29
  %37 = load i32* %i, align 4
  %38 = sext i32 %37 to i64
  %39 = load i32** %2, align 8
  %40 = getelementptr inbounds i32* %39, i64 %38
  %41 = load i32* %40, align 4
  %42 = icmp sgt i32 %41, 0
  %43 = zext i1 %42 to i32
  %44 = load i32* %i, align 4
  %45 = sext i32 %44 to i64
  %46 = load i32** %1, align 8
  %47 = getelementptr inbounds i32* %46, i64 %45
  store i32 %43, i32* %47, align 4
  br label %65

; <label>:48                                      ; preds = %29
  %49 = load i32* %i, align 4
  %50 = sext i32 %49 to i64
  %51 = load i32** %2, align 8
  %52 = getelementptr inbounds i32* %51, i64 %50
  %53 = load i32* %52, align 4
  %54 = load i32* %i, align 4
  %55 = sext i32 %54 to i64
  %56 = load i32** %3, align 8
  %57 = getelementptr inbounds i32* %56, i64 %55
  %58 = load i32* %57, align 4
  %59 = icmp sgt i32 %53, %58
  %60 = zext i1 %59 to i32
  %61 = load i32* %i, align 4
  %62 = sext i32 %61 to i64
  %63 = load i32** %1, align 8
  %64 = getelementptr inbounds i32* %63, i64 %62
  store i32 %60, i32* %64, align 4
  br label %65

; <label>:65                                      ; preds = %48, %36
  br label %66

; <label>:66                                      ; preds = %65, %17
  br label %67

; <label>:67                                      ; preds = %66
  %68 = load i32* %i, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, i32* %i, align 4
  br label %4

; <label>:70                                      ; preds = %4
  ret void
}

; Function Attrs: nounwind uwtable
define void @makeRange(i32* %x, i32 %a, i32 %b) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %size = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %x, i32** %1, align 8
  store i32 %a, i32* %2, align 4
  store i32 %b, i32* %3, align 4
  %4 = load i32* %3, align 4
  %5 = add nsw i32 %4, 1
  %6 = load i32* %2, align 4
  %7 = sub nsw i32 %5, %6
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %14

; <label>:9                                       ; preds = %0
  %10 = load i32* %3, align 4
  %11 = add nsw i32 %10, 1
  %12 = load i32* %2, align 4
  %13 = sub nsw i32 %11, %12
  br label %15

; <label>:14                                      ; preds = %0
  br label %15

; <label>:15                                      ; preds = %14, %9
  %16 = phi i32 [ %13, %9 ], [ 0, %14 ]
  store i32 %16, i32* %size, align 4
  store i32 1, i32* %i, align 4
  br label %17

; <label>:17                                      ; preds = %30, %15
  %18 = load i32* %i, align 4
  %19 = load i32* %size, align 4
  %20 = icmp sle i32 %18, %19
  br i1 %20, label %21, label %33

; <label>:21                                      ; preds = %17
  %22 = load i32* %2, align 4
  %23 = load i32* %i, align 4
  %24 = add nsw i32 %22, %23
  %25 = sub nsw i32 %24, 1
  %26 = load i32* %i, align 4
  %27 = sext i32 %26 to i64
  %28 = load i32** %1, align 8
  %29 = getelementptr inbounds i32* %28, i64 %27
  store i32 %25, i32* %29, align 4
  br label %30

; <label>:30                                      ; preds = %21
  %31 = load i32* %i, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %i, align 4
  br label %17

; <label>:33                                      ; preds = %17
  ret void
}

; Function Attrs: nounwind uwtable
define void @setVectorToInt(i32* %newVar, i32 %value) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %newVar, i32** %1, align 8
  store i32 %value, i32* %2, align 4
  store i32 1, i32* %i, align 4
  br label %3

; <label>:3                                       ; preds = %15, %0
  %4 = load i32* %i, align 4
  %5 = load i32** %1, align 8
  %6 = getelementptr inbounds i32* %5, i64 0
  %7 = load i32* %6, align 4
  %8 = icmp sle i32 %4, %7
  br i1 %8, label %9, label %18

; <label>:9                                       ; preds = %3
  %10 = load i32* %2, align 4
  %11 = load i32* %i, align 4
  %12 = sext i32 %11 to i64
  %13 = load i32** %1, align 8
  %14 = getelementptr inbounds i32* %13, i64 %12
  store i32 %10, i32* %14, align 4
  br label %15

; <label>:15                                      ; preds = %9
  %16 = load i32* %i, align 4
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* %i, align 4
  br label %3

; <label>:18                                      ; preds = %3
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %vec = alloca i32*, align 8
  %size = alloca i32, align 4
  store i32 %argc, i32* %1, align 4
  store i8** %argv, i8*** %2, align 8
  store i32 1, i32* %a, align 4
  store i32 5, i32* %b, align 4
  %3 = load i32* %b, align 4
  %4 = load i32* %a, align 4
  %5 = sub nsw i32 %3, %4
  %6 = add nsw i32 %5, 1
  store i32 %6, i32* %size, align 4
  %7 = load i32* %size, align 4
  call void @allocateVec(i32** %vec, i32 %7)
  %8 = load i32** %vec, align 8
  call void @makeRange(i32* %8, i32 1, i32 5)
  %9 = load i32** %vec, align 8
  call void @printVec(i32* %9)
  ret i32 0
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.6.0-2ubuntu1~trusty1 (tags/RELEASE_360/final) (based on LLVM 3.6.0)"}
