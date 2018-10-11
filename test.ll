; ModuleID = 'test.bc'
source_filename = "hello.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@m = global void (...)* bitcast (void ()* @foo to void (...)*), align 8
@n = global void (...)* bitcast (void ()* @goo to void (...)*), align 8

; Function Attrs: nounwind uwtable
define void @foo() #0 {
  ret void
}

; Function Attrs: nounwind uwtable
define void @goo() #0 {
  ret void
}

; Function Attrs: nounwind uwtable
define void @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca void (...)*, align 8
  %3 = alloca void (...)*, align 8
  %4 = alloca void (...)*, align 8
  %5 = bitcast i32* %1 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #2
  store i32 1, i32* %1, align 4, !tbaa !2
  %6 = bitcast void (...)** %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %6) #2
  %7 = load void (...)*, void (...)** @m, align 8, !tbaa !6
  store void (...)* %7, void (...)** %2, align 8, !tbaa !6
  %8 = bitcast void (...)** %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %8) #2
  %9 = load void (...)*, void (...)** @n, align 8, !tbaa !6
  store void (...)* %9, void (...)** %3, align 8, !tbaa !6
  %10 = bitcast void (...)** %4 to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %10) #2
  %11 = load i32, i32* %1, align 4, !tbaa !2
  %12 = icmp ne i32 %11, 0
  br i1 %12, label %13, label %15

; <label>:13:                                     ; preds = %0
  %14 = load void (...)*, void (...)** %2, align 8, !tbaa !6
  store void (...)* %14, void (...)** %4, align 8, !tbaa !6
  br label %17

; <label>:15:                                     ; preds = %0
  %16 = load void (...)*, void (...)** %3, align 8, !tbaa !6
  store void (...)* %16, void (...)** %4, align 8, !tbaa !6
  br label %17

; <label>:17:                                     ; preds = %15, %13
  %18 = load void (...)*, void (...)** %4, align 8, !tbaa !6
  call void (...) %18()
  %19 = bitcast void (...)** %4 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %19) #2
  %20 = bitcast void (...)** %3 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %20) #2
  %21 = bitcast void (...)** %2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %21) #2
  %22 = bitcast i32* %1 to i8*
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #2
  ret void
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.0 (tags/RELEASE_600/final)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !7, i64 0}
!7 = !{!"any pointer", !4, i64 0}
