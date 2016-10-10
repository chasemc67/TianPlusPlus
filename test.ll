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
  %5 = add nsw i32 1, %4
  %6 = load i32* %2, align 4
  %7 = sub nsw i32 %5, %6
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %9, label %14

; <label>:9                                       ; preds = %0
  %10 = load i32* %3, align 4
  %11 = add nsw i32 1, %10
  %12 = load i32* %2, align 4
  %13 = sub nsw i32 %11, %12
  br label %15

; <label>:14                                      ; preds = %0
  br label %15

; <label>:15                                      ; preds = %14, %9
  %16 = phi i32 [ %13, %9 ], [ 0, %14 ]
  %17 = load i32** %1, align 8
  %18 = getelementptr inbounds i32* %17, i64 0
  store i32 %16, i32* %18, align 4
  store i32 1, i32* %i, align 4
  br label %19

; <label>:19                                      ; preds = %35, %15
  %20 = load i32* %i, align 4
  %21 = load i32* %3, align 4
  %22 = add nsw i32 1, %21
  %23 = load i32* %2, align 4
  %24 = sub nsw i32 %22, %23
  %25 = icmp sle i32 %20, %24
  br i1 %25, label %26, label %38

; <label>:26                                      ; preds = %19
  %27 = load i32* %2, align 4
  %28 = load i32* %i, align 4
  %29 = sub nsw i32 %28, 1
  %30 = add nsw i32 %27, %29
  %31 = load i32* %i, align 4
  %32 = sext i32 %31 to i64
  %33 = load i32** %1, align 8
  %34 = getelementptr inbounds i32* %33, i64 %32
  store i32 %30, i32* %34, align 4
  br label %35

; <label>:35                                      ; preds = %26
  %36 = load i32* %i, align 4
  %37 = add nsw i32 %36, 1
  store i32 %37, i32* %i, align 4
  br label %19

; <label>:38                                      ; preds = %19
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
  store i32 1, i32* %startRange, align 4
  store i32 9, i32* %endRange, align 4
  %4 = load i32* %endRange, align 4
  %5 = add nsw i32 2, %4
  %6 = load i32* %startRange, align 4
  %7 = sub nsw i32 %5, %6
  %8 = zext i32 %7 to i64
  %9 = call i8* @llvm.stacksave()
  store i8* %9, i8** %3
  %10 = alloca i32, i64 %8, align 16
  %11 = load i32* %startRange, align 4
  %12 = load i32* %endRange, align 4
  call void @createRange(i32* %10, i32 %11, i32 %12)
  %13 = getelementptr inbounds i32* %10, i64 9
  %14 = load i32* %13, align 4
  %15 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %14)
  %16 = load i8** %3
  call void @llvm.stackrestore(i8* %16)
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
