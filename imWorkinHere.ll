; ModuleID = 'sampleC.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@p = global i32 9, align 4
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"[\00", align 1
@.str2 = private unnamed_addr constant [4 x i8] c" %d\00", align 1
@.str3 = private unnamed_addr constant [4 x i8] c" ]\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @allocateVec(i32** %x, i32 %size) #0 {
  %1 = alloca i32**, align 8
  %2 = alloca i32, align 4
  store i32** %x, i32*** %1, align 8
  store i32 %size, i32* %2, align 4
  %3 = load i32* @p, align 4
  %4 = add nsw i32 %3, 2
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
  %2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([2 x i8]* @.str1, i32 0, i32 0))
  store i32 1, i32* %i, align 4
  br label %3
  %4 = load i32* %i, align 4
  %5 = load i32** %1, align 8
  %6 = getelementptr inbounds i32* %5, i64 0
  %7 = load i32* %6, align 4
  %8 = add nsw i32 %7, 1
  %9 = icmp slt i32 %4, %8
  br i1 %9, label %10, label %20
  %11 = load i32* %i, align 4
  %12 = sext i32 %11 to i64
  %13 = load i32** %1, align 8
  %14 = getelementptr inbounds i32* %13, i64 %12
  %15 = load i32* %14, align 4
  %16 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i32 %15)
  br label %17
  %18 = load i32* %i, align 4
  %19 = add nsw i32 %18, 1
  store i32 %19, i32* %i, align 4
  br label %3
  %21 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str3, i32 0, i32 0))
  ret void
}

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

; <label\>:9                                       ; preds = %0
  %10 = load i32* %3, align 4
  %11 = add nsw i32 %10, 1
  %12 = load i32* %2, align 4
  %13 = sub nsw i32 %11, %12
  br label %15

; <label\>:14                                      ; preds = %0
  br label %15

; <label\>:15                                      ; preds = %14, %9
  %16 = phi i32 [ %13, %9 ], [ 0, %14 ]
  store i32 %16, i32* %size, align 4
  store i32 1, i32* %i, align 4
  br label %17

; <label\>:17                                      ; preds = %30, %15
  %18 = load i32* %i, align 4
  %19 = load i32* %size, align 4
  %20 = icmp sle i32 %18, %19
  br i1 %20, label %21, label %33

; <label\>:21                                      ; preds = %17
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

; <label\>:30                                      ; preds = %21
  %31 = load i32* %i, align 4
  %32 = add nsw i32 %31, 1
  store i32 %32, i32* %i, align 4
  br label %17

; <label\>:33                                      ; preds = %17
  ret void
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
%1 = alloca i32, align 4
%2 = alloca i32, align 4
%3 = alloca i8**, align 8
store i32 0, i32* %1
store i32 %argc, i32* %2, align 4
store i8** %argv, i8*** %3, align 8
;declareVecVar
%s0varv0 = alloca i32*, align 8                               ;declare vector
%var4 = alloca i32, align 4
store i32 1, i32* %var4, align 4
%var5 = alloca i32, align 4
store i32 9, i32* %var5, align 4
;declareVecVar
%var11 = alloca i32*, align 8                               ;declare vector
%var6 =  load i32* %var4, align 4
%var7 =  load i32* %var5, align 4
%var8 =  sub i32 %var7, %var6
%var9 = add  i32 %var8, 1
call void @allocateVec(i32** %var11, i32 %var9)            ;allocate vector
%var10 = load i32** %var11, align 8
call void @makeRange(i32* %var10, i32 %var6, i32 %var7)
%var13 = load i32** %var11, align 8                                      ;print vector
call void @printVec(i32* %var13)
 ;--------
ret i32 0
}
