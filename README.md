# Neuro-Diagnostic-Pipeline-PSO

![MATLAB](https://img.shields.io/badge/MATLAB-Simulation%20%26%20Modeling-blue)
![Data Science](https://img.shields.io/badge/Domain-Healthcare%20Analytics-success)
![Algorithm](https://img.shields.io/badge/Algorithm-PSO%20%2B%20SVM-orange)

## 📌 Overview
Early and accurate detection of brain tumors from Magnetic Resonance Imaging (MRI) is highly complex due to the sheer volume of image data and the subtle variations between benign and malignant tissues. Traditional diagnostic models often struggle with high dimensionality, leading to computational inefficiencies and lower accuracy. This project implements an end-to-end medical image processing pipeline that utilizes Particle Swarm Optimization (PSO) for aggressive, intelligent feature selection, coupled with a Support Vector Machine (SVM) to classify tumors as either Benign or Malignant. An interactive graphical user interface (GUI) was also developed to streamline the evaluation process.

## 🚀 Objectives & Technical Implementation
The primary objective was to engineer a pipeline capable of ingesting, processing, and extracting meaningful features from raw MRI image datasets. To manage dimensionality, a Binary Particle Swarm Optimization (PSO) algorithm was deployed to identify the most critical diagnostic features, reducing computational overhead while maximizing the signal-to-noise ratio. The optimized feature subset was then passed into an SVM classifier to differentiate between tumor types with high clinical accuracy. From an engineering perspective, this involved automating the transformation of unstructured image arrays into structured matrices and developing a stateful, event-driven MATLAB interface (`.m` and `.fig`) to visualize outcomes.

## 🧠 Methodology
The architecture begins with data preparation, where raw MRI images are loaded, segmented, and processed to extract initial statistical and morphological features. Instead of feeding all extracted features into the classifier, the PSO algorithm evaluates combinations of features over 100 iterations to select the subset that maximizes predictive power. This subset is evaluated using an SVM classifier with K-fold cross-validation to ensure robust training and prevent overfitting.

## 📊 Results & Performance
The integration of Particle Swarm Optimization significantly outperformed the baseline classification approach by filtering out irrelevant imaging noise. The baseline accuracy using only the SVM classifier achieved 85.71%. By applying the PSO-enhanced feature selection, the model's accuracy improved to 93.75%. This demonstrates that intelligent feature selection not only improves computing efficiency but is critical for achieving the high accuracy thresholds required in healthcare analytics. For a comprehensive breakdown of the methodology and performance metrics, please refer to the `Brain_Tumor_Classification_Paper.pdf` located in the `docs/` directory.

## 📂 Data Architecture & Privacy
To adhere to enterprise data engineering best practices and repository size limits, the full raw medical imaging dataset is not hosted directly within this repository. A strict `.gitignore` policy is enforced to keep the codebase lightweight and prevent binary bloat. A small subset of sample MRI images (Benign and Malignant) is provided in the `data/sample_mri/` directory for immediate testing and verification of the diagnostic pipeline. 

## ⚙️ How to Run the Project
1. Clone the repository and open MATLAB.
2. Ensure the Statistics and Machine Learning Toolbox is installed.
3. Navigate to the `src/` directory.
4. Run `ex3.m` from the command window to launch the interactive GUI.
5. Use the interface to load sample MRI data, execute the standard SVM, and compare it against the PSO-optimized model.

## 📬 Contact
**Adithya Reddy Boravelly**
* **Location:** Birmingham, AL
* **Email:** adithyareddyboravelly@gmail.com
