# 💡 Performance Analysis and Functional Verification of DCT-Based Lossy Image Compression Technique



## 🧠 Introduction
- I developed this project along with my project-mates as part of my **final year of Engineering**. This work focuses on implementing **DCT-based lossy image compression** entirely in **MATLAB**.  
- The goal was to understand how the **Discrete Cosine Transform (DCT)** can efficiently compress images by transforming spatial data into frequency components and reducing redundancy.  
- I analyzed its performance using key metrics like **Peak Signal-to-Noise Ratio (PSNR)**, **Mean Squared Error (MSE)**, and **Compression Ratio** to study the trade-off between image quality and compression efficiency.


## 🧾 Abstract
- This project presents a software-based implementation of **Discrete Cosine Transform (DCT)** for lossy image compression using **MATLAB**.  
- The method transforms spatial pixel data into frequency components, enabling efficient compression through quantization and inverse transformation while maintaining visual fidelity.  
- Two quantization strategies — **direct (Q30)** and **sequential (Q50 → Q30)** — are implemented to study the trade-off between image quality and compression ratio.  
- Performance is evaluated using **Peak Signal-to-Noise Ratio (PSNR)** and **Mean Squared Error (MSE)**, demonstrating that the DCT-based approach effectively reduces data size with minimal perceptual loss.  
- This work highlights the practicality of DCT in optimizing storage and transmission for modern multimedia systems.



## ⚙️ Approach
1. Convert the input RGB image to YCbCr and process only the Y channel.  
2. Divide the image into 8×8 blocks.  
3. Apply 2D DCT to each block to transform spatial data into frequency coefficients.  
4. Quantize the transformed data using Q50 and Q30 matrices to achieve different compression levels.  
5. Perform inverse DCT (IDCT) to reconstruct the image.  
6. Compare the results based on PSNR, MSE, and compression ratio metrics.



## 💻 How to Run
- You don’t need to download the entire repository to try this project.  
- Simply download the MATLAB file **`dct_image_compression.m`** and open it in **MATLAB**.

- Once opened:  
   1. Run the script.  
   2. When prompted, choose which compression type you want to perform:  
      - Enter **1** → for sequential Q50 → Q30 compression.  
      - Enter **2** → for Q30-only compression.  
   3. The reconstructed images and metric values (PSNR, MSE, Compression Ratio) will appear.  
   Visual differences between the images may not be noticeable, as variations are very subtle and detailed.



## 🧮 Tech Stack
| Category | Tool |
|-----------|------|
| Language | MATLAB |
| Algorithm | Discrete Cosine Transform (DCT) |



## 👩‍💻 Team
- **Dhanya V. Kulkarni**  
- **Pallavi M. Betsur**  
- **Pooja M. Betsur**  
- **Ramyashree V. Nayak**  

Guided by **Dr. Mahendra M. Dixit**, Professor & Head, Department of ECE, **KLS VDIT, Haliyal**.



## 📚 Reference
For detailed explanation, refer to the paper included in the repository under the `docs/` folder.



## 🏷️ Tags
`MATLAB` · `DCT` · `Image Compression` · `Lossy` · `PSNR` · `MSE` · `Quantization` · `Final Year Project`
