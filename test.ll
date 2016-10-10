; ModuleID = 'test.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind uwtable
define void @createRange(i32* %a, i32 %start, i32 %end) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %i = alloca i32, align 4
  store i32* %a, i32** %1, align 8
  store i32 %start, i32* %2, align 4
  store i32 %end, i32* %3, align 4
  %4 = load i32* %3, align 4
  %5 = load i32* %2, align 4
  %6 = sub nsw i32 %4, %5
  %7 = icmp sgt i32 %6, 0
  br i1 %7, label %8, label %12

; <label>:8                                       ; preds = %0
  %9 = load i32* %3, align 4
  %10 = load i32* %2, align 4
  %11 = sub nsw i32 %9, %10
  br label %13

; <label>:12                                      ; preds = %0
  br label %13

; <label>:13                                      ; preds = %12, %8
  %14 = phi i32 [ %11, %8 ], [ 0, %12 ]
  %15 = load i32** %1, align 8
  %16 = getelementptr inbounds i32* %15, i64 0
  store i32 %14, i32* %16, align 4
  store i32 1, i32* %i, align 4
  br label %17

; <label>:17                                      ; preds = %32, %13
  %18 = load i32* %i, align 4
  %19 = load i32* %3, align 4
  %20 = load i32* %2, align 4
  %21 = sub nsw i32 %19, %20
  %22 = icmp sle i32 %18, %21
  br i1 %22, label %23, label %35

; <label>:23                                      ; preds = %17
  %24 = load i32* %2, align 4
  %25 = load i32* %i, align 4
  %26 = sub nsw i32 %25, 1
  %27 = add nsw i32 %24, %26
  %28 = load i32* %i, align 4
  %29 = sext i32 %28 to i64
  %30 = load i32** %1, align 8
  %31 = getelementptr inbounds i32* %30, i64 %29
  store i32 %27, i32* %31, align 4
  br label %32

; <label>:32                                      ; preds = %23
  %33 = load i32* %i, align 4
  %34 = add nsw i32 %33, 1
  store i32 %34, i32* %i, align 4
  br label %17

; <label>:35                                      ; preds = %17
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  %startRange = alloca i32, align 4
  %endRange = alloca i32, align 4
  %3 = alloca i8*
  store i32 %argc, i32* %1, align 4
  store i8** %argv, i8*** %2, align 8
  store i32 3, i32* %startRange, align 4
  store i32 7, i32* %endRange, align 4
  %4 = load i32* %endRange, align 4
  %5 = add nsw i32 1, %4
  %6 = load i32* %startRange, align 4
  %7 = sub nsw i32 %5, %6
  %8 = zext i32 %7 to i64
  %9 = call i8* @llvm.stacksave()
  store i8* %9, i8** %3
  %10 = alloca i32, i64 %8, align 16
  %11 = load i32* %startRange, align 4
  %12 = load i32* %endRange, align 4
  call void @createRange(i32* %10, i32 %11, i32 %12)
  %13 = load i32* %startRange, align 4
  %14 = getelementptr inbounds i32* %10, i64 3
  store i32 %13, i32* %14, align 4
  %15 = getelementptr inbounds i32* %10, i64 2
  %16 = load i32* %15, align 4
  %17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %16)
  %18 = load i8** %3
  call void @llvm.stackrestore(i8* %18)
  ret i32 0
}

; Function Attrs: nounwind
declare i8* @llvm.stacksave() #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind
declare void @llvm.stackrestore(i8*) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"Ubuntu clang version 3.6.0-2ubuntu1~trusty1 (tags/RELEASE_360/final) (based on LLVM 3.6.0)"}
