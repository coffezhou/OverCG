; ModuleID = 'test1.c'
source_filename = "test1.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"hello foo!\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"hello goo!\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define void @foo() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i32 0, i32 0))
  ret void
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: noinline nounwind optnone uwtable
define void @goo() #0 {
  %1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i32 0, i32 0))
  ret void
}

; Function Attrs: noinline nounwind optnone uwtable
define void @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca void (...)*, align 8
  %3 = alloca void (...)*, align 8
  %4 = alloca void (...)*, align 8
  store i32 1, i32* %1, align 4
  store void (...)* bitcast (void ()* @foo to void (...)*), void (...)** %2, align 8
  store void (...)* bitcast (void ()* @goo to void (...)*), void (...)** %3, align 8
  %5 = load i32, i32* %1, align 4
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %7, label %9

; <label>:7:                                      ; preds = %0
  %8 = load void (...)*, void (...)** %2, align 8
  store void (...)* %8, void (...)** %4, align 8
  br label %11

; <label>:9:                                      ; preds = %0
  %10 = load void (...)*, void (...)** %3, align 8
  store void (...)* %10, void (...)** %4, align 8
  br label %11

; <label>:11:                                     ; preds = %9, %7
  %12 = load void (...)*, void (...)** %4, align 8
  call void (...) %12()
  ret void
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0 (tags/RELEASE_600/final)"}
