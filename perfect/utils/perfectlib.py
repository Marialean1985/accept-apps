from subprocess import check_output
import os
import math
import argparse
import struct
import numpy as np
from numpy import linalg as la
from matplotlib import cm, pyplot as plt

def load_mat(filename):
    mat = []
    with open(filename) as f:
        for line in f:
            if line.strip()!='':
                line = line.strip().split(" ")
                if line[0]!='%':
                    line = [float(x) for x in line]
    return np.array(mat)

def load_fft(filename):
    mat = []
    with open(filename) as f:
        for line in f:
            if line.strip()!='' and line[0]!='#':
                line = line.strip()[1:-1].split(") (")
                line = [x.split(', ') for x in line]
                line = [float(x[0])+1j*float(x[1]) for x in line]
                mat.append(line)
    return np.array(mat)

def load_bin(filename, luma=False, metadata=False):
    pixels = []
    params = []
    f = open(filename, "rb")
    try:
        word = f.read(2)
        while word != "":
            if len(params)<4:
                params.append(struct.unpack('h', word)[0])
                word = f.read(2)
            else:
                pix = struct.unpack('h', word)[0]
                pixels.append(pix)
                word = f.read(params[3])
    finally:
        f.close()

    if metadata:
        print("Image width = {}".format(params[0]))
        print("Image height = {}".format(params[1]))
        print("Channels = {}".format(params[2]))
        print("Depth = {}".format(params[3]))
        print("Pixel count = {}".format(len(pixels)))

    channels = params[2]

    # Normalize
    minVal = min(pixels)
    maxVal = max(pixels)
    # pixels = [(x-minVal)/(maxVal-minVal) for x in pixels]

    mat = []
    for y in range(0, params[1]):
        row = pixels[y*channels*params[0]:(y+1)*channels*params[0]]
        if channels==1:
            mat.append(row)
        elif channels == 3:
            rgb_row = []
            for x in range(0, params[0]):
                if luma:
                    # using RGB to lumincance conversion for ITU-R BT.709 / sRGB
                    r = row[x*channels+0]
                    g = row[x*channels+1]
                    b = row[x*channels+2]
                    luminance = 0.2126*r + 0.7152*g + 0.0722*b
                    rgb_row.append(luminance)
                else:
                    rgb_pixel = (row[x*channels+0],row[x*channels+1],row[x*channels+2])
                    rgb_row.append(rgb_pixel)
            mat.append(rgb_row)

    return np.array(mat)

def computeSNR(golden, relaxed, mode):
    if (os.path.isfile(relaxed)):
        if mode=="mat" or mode=="fft":
            if mode=="mat":
                goldenData = load_mat(golden)
                relaxedData = load_mat(relaxed)
            elif mode=="fft":
                # This code is left commented in case we'd like
                # to recompute the fft function
                # inputData = load_fft(golden)
                # if inputData.shape[1] == 1:
                #     goldenData = np.fft.fft(inputData)
                # else:
                #     goldenData = np.fft.fft2(inputData)
                goldenData = load_fft(golden)
                relaxedData = load_fft(relaxed)
            if (goldenData==relaxedData).all():
                return 1E9 # arbitrarily large SNR to indicate identical values
            else:
                # Here we compute the SNR based on the PERFECT doc
                num = ((goldenData) ** 2).sum(axis=None)
                denom = ((goldenData - relaxedData) ** 2).sum(axis=None)
                snr = 10 * np.log10( num/denom );
                if mode=="mat":
                    return snr
                elif mode=="fft":
                    return snr.real
        else:
            return 1.0
    else:
        return 1.0

def computePSNR(golden, relaxed, mode):
    if (os.path.isfile(relaxed)):
        if mode=="RGBbin":
            goldenData = load_bin(golden, luma=True)
            relaxedData = load_bin(relaxed, luma=True)
            if (goldenData==relaxedData).all():
                return 1E9 # arbitrarily large PSNR to indicate identical values
            else:
                # For details on how to compute PSNR in multimedia applications
                # https://en.wikipedia.org/wiki/Peak_signal-to-noise_ratio
                mseVal = ((goldenData - relaxedData) ** 2).mean(axis=None)
                maxVal = np.amax(goldenData)
                psnr = 20 * np.log10(maxVal) - 10 * np.log10(mseVal);
                return psnr
        else:
            return 1.0
    else:
        return 1.0

def display(fn):
    if fn.endswith('.mat'):
        img_array = load_mat(fn)
        plt.imshow(img_array, interpolation='nearest', cmap = cm.Greys_r)
        plt.show()
    elif fn.endswith('.bin'):
        img_array = load_bin(fn, luma=True)
        channels = 1 if len(img_array.shape)==2 else img_array.shape[2]
        if channels==1:
            plt.imshow(img_array, interpolation='nearest', cmap = cm.Greys_r)
        else:
            plt.imshow(img_array)
        plt.show()

def cli():
    parser = argparse.ArgumentParser(
        description='Displays image'
    )
    parser.add_argument(
        '-f', dest='path', action='store', type=str, required=True,
        default=None, help='path to file'
    )
    args = parser.parse_args()

    display(args.path)

if __name__ == '__main__':
    cli()