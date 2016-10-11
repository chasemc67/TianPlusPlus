; ModuleID = 'addVectors.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c" %d\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c" ]\0A\00", align 1

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

declare i32 @printf(i8*, ...) #1

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
declare noalias i8* @malloc(i64) #2

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  %var1 = alloca [3 x i32], align 4
  %var2 = alloca [6 x i32], align 16
  %max = alloca i32, align 4
  %var3 = alloca i32*, align 8
  store i32 %argc, i32* %1, align 4
  store i8** %argv, i8*** %2, align 8
  %3 = getelementptr inbounds [3 x i32]* %var1, i32 0, i64 0
  store i32 2, i32* %3, align 4
  %4 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 0
  store i32 5, i32* %4, align 4
  %5 = getelementptr inbounds [3 x i32]* %var1, i32 0, i64 1
  store i32 1, i32* %5, align 4
  %6 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 1
  store i32 1, i32* %6, align 4
  %7 = getelementptr inbounds [3 x i32]* %var1, i32 0, i64 2
  store i32 2, i32* %7, align 4
  %8 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 2
  store i32 2, i32* %8, align 4
  %9 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 3
  store i32 3, i32* %9, align 4
  %10 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 4
  store i32 10, i32* %10, align 4
  %11 = getelementptr inbounds [6 x i32]* %var2, i32 0, i64 5
  store i32 11, i32* %11, align 4
  %12 = getelementptr inbounds [3 x i32]* %var1, i32 0, i32 0
  %13 = getelementptr inbounds [6 x i32]* %var2, i32 0, i32 0
  %14 = call i32 @getMaxSize(i32* %12, i32* %13)
  store i32 %14, i32* %max, align 4
  %15 = load i32* %max, align 4
  call void @allocateVec(i32** %var3, i32 %15)
  %16 = load i32** %var3, align 8
  %17 = getelementptr inbounds [6 x i32]* %var2, i32 0, i32 0
  %18 = getelementptr inbounds [3 x i32]* %var1, i32 0, i32 0
  call void @addVars(i32* %16, i32* %17, i32* %18)
  %19 = getelementptr inbounds [3 x i32]* %var1, i32 0, i32 0
  call void @printVec(i32* %19)
  %20 = getelementptr inbounds [6 x i32]* %var2, i32 0, i32 0
  call void @printVec(i32* %20)
  %21 = load i32** %var3, align 8
  call void @printVec(i32* %21)
  ret i32 0
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.6.0-2ubuntu1~trusty1 (tags/RELEASE_360/final) (based on LLVM 3.6.0)"}
