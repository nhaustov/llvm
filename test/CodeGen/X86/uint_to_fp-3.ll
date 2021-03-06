; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X32-SSE
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx | FileCheck %s --check-prefix=X32-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=X64-AVX

;PR29079

define <4 x float> @mask_ucvt_4i32_4f32(<4 x i32> %a) {
; X32-SSE-LABEL: mask_ucvt_4i32_4f32:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    pand {{\.LCPI.*}}, %xmm0
; X32-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [65535,65535,65535,65535]
; X32-SSE-NEXT:    pand %xmm0, %xmm1
; X32-SSE-NEXT:    por {{\.LCPI.*}}, %xmm1
; X32-SSE-NEXT:    psrld $16, %xmm0
; X32-SSE-NEXT:    por {{\.LCPI.*}}, %xmm0
; X32-SSE-NEXT:    addps {{\.LCPI.*}}, %xmm0
; X32-SSE-NEXT:    addps %xmm1, %xmm0
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: mask_ucvt_4i32_4f32:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-AVX-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-AVX-NEXT:    vpsrld $16, %xmm0, %xmm0
; X32-AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X32-AVX-NEXT:    vaddps {{\.LCPI.*}}, %xmm0, %xmm0
; X32-AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: mask_ucvt_4i32_4f32:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [65535,65535,65535,65535]
; X64-SSE-NEXT:    pand %xmm0, %xmm1
; X64-SSE-NEXT:    por {{.*}}(%rip), %xmm1
; X64-SSE-NEXT:    psrld $16, %xmm0
; X64-SSE-NEXT:    por {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    addps {{.*}}(%rip), %xmm0
; X64-SSE-NEXT:    addps %xmm1, %xmm0
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_ucvt_4i32_4f32:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vpblendw {{.*#+}} xmm1 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-AVX-NEXT:    vpsrld $16, %xmm0, %xmm0
; X64-AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],mem[1],xmm0[2],mem[3],xmm0[4],mem[5],xmm0[6],mem[7]
; X64-AVX-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; X64-AVX-NEXT:    retq
  %and = and <4 x i32> %a, <i32 127, i32 255, i32 4095, i32 65595>
  %cvt = uitofp <4 x i32> %and to <4 x float>
  ret <4 x float> %cvt
}

define <4 x double> @mask_ucvt_4i32_4f64(<4 x i32> %a) {
; X32-SSE-LABEL: mask_ucvt_4i32_4f64:
; X32-SSE:       # BB#0:
; X32-SSE-NEXT:    movdqa %xmm0, %xmm2
; X32-SSE-NEXT:    pand {{\.LCPI.*}}, %xmm2
; X32-SSE-NEXT:    pxor %xmm3, %xmm3
; X32-SSE-NEXT:    movdqa %xmm2, %xmm0
; X32-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; X32-SSE-NEXT:    movdqa {{.*#+}} xmm4 = [1127219200,1160773632,0,0]
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; X32-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1]
; X32-SSE-NEXT:    movapd {{.*#+}} xmm5 = [4.503600e+15,1.934281e+25]
; X32-SSE-NEXT:    subpd %xmm5, %xmm0
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[2,3,0,1]
; X32-SSE-NEXT:    addpd %xmm6, %xmm0
; X32-SSE-NEXT:    xorpd %xmm6, %xmm6
; X32-SSE-NEXT:    movss {{.*#+}} xmm6 = xmm1[0],xmm6[1,2,3]
; X32-SSE-NEXT:    punpckldq {{.*#+}} xmm6 = xmm6[0],xmm4[0],xmm6[1],xmm4[1]
; X32-SSE-NEXT:    subpd %xmm5, %xmm6
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm6[2,3,0,1]
; X32-SSE-NEXT:    addpd %xmm6, %xmm1
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X32-SSE-NEXT:    punpckhdq {{.*#+}} xmm2 = xmm2[2],xmm3[2],xmm2[3],xmm3[3]
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm2[2,3,0,1]
; X32-SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm4[0],xmm2[1],xmm4[1]
; X32-SSE-NEXT:    subpd %xmm5, %xmm2
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[2,3,0,1]
; X32-SSE-NEXT:    addpd %xmm2, %xmm1
; X32-SSE-NEXT:    movss {{.*#+}} xmm3 = xmm6[0],xmm3[1,2,3]
; X32-SSE-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm4[0],xmm3[1],xmm4[1]
; X32-SSE-NEXT:    subpd %xmm5, %xmm3
; X32-SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm3[2,3,0,1]
; X32-SSE-NEXT:    addpd %xmm3, %xmm2
; X32-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X32-SSE-NEXT:    retl
;
; X32-AVX-LABEL: mask_ucvt_4i32_4f64:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm0
; X32-AVX-NEXT:    vpand {{\.LCPI.*}}, %xmm0, %xmm1
; X32-AVX-NEXT:    vcvtdq2pd %xmm1, %ymm1
; X32-AVX-NEXT:    vpsrld $16, %xmm0, %xmm0
; X32-AVX-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X32-AVX-NEXT:    vmulpd {{\.LCPI.*}}, %ymm0, %ymm0
; X32-AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
;
; X64-SSE-LABEL: mask_ucvt_4i32_4f64:
; X64-SSE:       # BB#0:
; X64-SSE-NEXT:    movdqa %xmm0, %xmm2
; X64-SSE-NEXT:    pand {{.*}}(%rip), %xmm2
; X64-SSE-NEXT:    pxor %xmm1, %xmm1
; X64-SSE-NEXT:    movdqa %xmm2, %xmm0
; X64-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X64-SSE-NEXT:    movdqa {{.*#+}} xmm3 = [1127219200,1160773632,0,0]
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm0[2,3,0,1]
; X64-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; X64-SSE-NEXT:    movapd {{.*#+}} xmm5 = [4.503600e+15,1.934281e+25]
; X64-SSE-NEXT:    subpd %xmm5, %xmm0
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm0[2,3,0,1]
; X64-SSE-NEXT:    addpd %xmm6, %xmm0
; X64-SSE-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1]
; X64-SSE-NEXT:    subpd %xmm5, %xmm4
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm6 = xmm4[2,3,0,1]
; X64-SSE-NEXT:    addpd %xmm4, %xmm6
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0],xmm6[0]
; X64-SSE-NEXT:    punpckhdq {{.*#+}} xmm2 = xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm4 = xmm2[2,3,0,1]
; X64-SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; X64-SSE-NEXT:    subpd %xmm5, %xmm2
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[2,3,0,1]
; X64-SSE-NEXT:    addpd %xmm2, %xmm1
; X64-SSE-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm3[0],xmm4[1],xmm3[1]
; X64-SSE-NEXT:    subpd %xmm5, %xmm4
; X64-SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm4[2,3,0,1]
; X64-SSE-NEXT:    addpd %xmm4, %xmm2
; X64-SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0],xmm2[0]
; X64-SSE-NEXT:    retq
;
; X64-AVX-LABEL: mask_ucvt_4i32_4f64:
; X64-AVX:       # BB#0:
; X64-AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm1
; X64-AVX-NEXT:    vcvtdq2pd %xmm1, %ymm1
; X64-AVX-NEXT:    vpsrld $16, %xmm0, %xmm0
; X64-AVX-NEXT:    vcvtdq2pd %xmm0, %ymm0
; X64-AVX-NEXT:    vmulpd {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; X64-AVX-NEXT:    retq
  %and = and <4 x i32> %a, <i32 127, i32 255, i32 4095, i32 65595>
  %cvt = uitofp <4 x i32> %and to <4 x double>
  ret <4 x double> %cvt
}
