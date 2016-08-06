# Added for safety
git pull

# 2d-conv benchmark
(cd perfect/pa1/kernels/2d_convolution/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 6 -target conv2d")
mv perfect/pa1/kernels/2d_convolution/outputs runs/pa1_2d_convolution
#DWT53 benchmark
(cd perfect/pa1/kernels/dwt53/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 27 -target dwt53_row_transpose")
mv perfect/pa1/kernels/dwt53/outputs runs/pa1_dwt53
#Histogram-eq benchmark
(cd perfect/pa1/kernels/histogram_equalization/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 13 -target histEq")
mv perfect/pa1/kernels/histogram_equalization/outputs runs/pa1_histogram_equalization

#Outer-product benchmark
(cd perfect/stap/kernels/outer-product/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 142 -target stap_compute_covariance_estimate")
mv perfect/stap/kernels/outer-product/outputs runs/stap_outer-product
#System-solve benchmark
(cd perfect/stap/kernels/system-solve/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 77 -target stap_system_solver")
mv perfect/stap/kernels/system-solve/outputs runs/stap_system-solve
#Inner-product benchmark
(cd perfect/stap/kernels/inner-product/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 84 -target stap_apply_weighting")
mv perfect/stap/kernels/inner-product/outputs runs/stap_inner-product

#PFA-interp1 benchmark
(cd perfect/sar/kernels/pfa-interp1/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 42 -target sar_interp1")
mv perfect/sar/kernels/pfa-interp1/outputs runs/sar_pfa-interp1
#PFA-interp2 benchmark
(cd perfect/sar/kernels/pfa-interp2/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 41 -target sar_interp2")
mv perfect/sar/kernels/pfa-interp2/outputs runs/sar_pfa-interp2
#BP benchmark
(cd perfect/sar/kernels/bp/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 45 -target sar_backprojection")
mv perfect/sar/kernels/bp/outputs runs/sar_bp

#Debayer benchmark
(cd perfect/wami/kernels/debayer/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 124 -target wami_debayer")
mv perfect/wami/kernels/debayer/outputs runs/wami_debayer
#Lucas-Kanade benchmark
(cd perfect/wami/kernels/lucas-kanade/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 129 -target lucas_kanade")
mv perfect/wami/kernels/lucas-kanade/outputs runs/wami_lucas-kanade
#Change-detection benchmark
(cd perfect/wami/kernels/change-detection/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 134 -target wami_gmm")
mv perfect/wami/kernels/change-detection/outputs runs/wami_change-detection

#FFT-1D benchmark
(cd perfect/required/kernels/fft-1d/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 43 -target fft")
mv perfect/required/kernels/fft-1d/outputs runs/required_fft-1d
#FFT-2D benchmark
(cd perfect/required/kernels/fft-2d/; make tune TUNER_ARGS="-d -snr 10.0 -fixed -c 43 -target fft")
mv perfect/required/kernels/fft-2d/outputs runs/required_fft-2d


# Copy everything
mkdir runs/error_logs
cp runs/pa1_2d_convolution/error.log runs/error_logs/pa1_2d_convolution.log
cp runs/pa1_dwt53/error.log runs/error_logs/pa1_dwt53.log
cp runs/pa1_histogram_equalization/error.log runs/error_logs/pa1_histogram_equalization.log
cp runs/sar_pfa-interp1/error.log runs/error_logs/sar_pfa-interp1.log
cp runs/sar_pfa-interp2/error.log runs/error_logs/sar_pfa-interp2.log
cp runs/sar_bp/error.log runs/error_logs/sar_bp.log
cp runs/stap_outer-product/error.log runs/error_logs/stap_outer-product.log
cp runs/stap_system-solve/error.log runs/error_logs/stap_system-solve.log
cp runs/stap_inner-product/error.log runs/error_logs/stap_inner-product.log
cp runs/wami_debayer/error.log runs/error_logs/wami_debayer.log
cp runs/wami_lucas-kanade/error.log runs/error_logs/wami_lucas-kanade.log
cp runs/wami_change-detection/error.log runs/error_logs/wami_change-detection.log
cp runs/required_fft-1d/error.log runs/error_logs/required_fft-1d.log
cp runs/required_fft-2d/error.log runs/error_logs/required_fft-2d.log

# Cleanup
rm -rf perfect/pa1/kernels/*outputs
rm -rf perfect/wami/kernels/*outputs
rm -rf perfect/stap/kernels/*outputs
rm -rf perfect/required/kernels/*outputs
rm -rf perfect/sar/kernels/*outputs
(cd perfect/pa1/kernels/2d_convolution/; make clean)
(cd perfect/pa1/kernels/dwt53/; make clean)
(cd perfect/pa1/kernels/histogram_equalization/; make clean)
(cd perfect/wami/kernels/debayer/; make clean)
(cd perfect/wami/kernels/lucas-kanade/; make clean)
(cd perfect/wami/kernels/change-detection/; make clean)
(cd perfect/stap/kernels/outer-product/; make clean)
(cd perfect/stap/kernels/system-solve/; make clean)
(cd perfect/stap/kernels/inner-product/; make clean)
(cd perfect/required/kernels/fft-1d/; make clean)
(cd perfect/required/kernels/fft-2d/; make clean)
(cd perfect/sar/kernels/pfa-interp1/; make clean)
(cd perfect/sar/kernels/pfa-interp2/; make clean)
(cd perfect/sar/kernels/bp/; make clean)

