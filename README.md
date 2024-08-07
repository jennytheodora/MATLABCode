Here's the revised README in a professional format:

---

# Data Processing Pipeline for EEG Data: Impact of COVID-19 on Cognitive Function

Welcome! This repository contains a series of scripts for processing EEG data for the project "Impact of COVID-19 on Cognitive Function." Below is the pipeline along with the description of each script.

## Prerequisites

- **MATLAB**: We used version R2023a for this analysis.
- **FieldTrip toolbox**: [FieldTrip Toolbox](https://www.fieldtriptoolbox.org/)

## Scripts

### 1. MoCA_SQR.m
**Purpose**: To perform statistical analysis and visualization of MoCA and SRQ scores.

**Details**:
- **Statistical Analysis**: Compare the Montreal Cognitive Assessment (MoCA) and its components, as well as the Self Report Questionnaire (SRQ) scores between COVID and Non-COVID subjects using Student’s t-test.
- **Visualization**: Create visual representations of the analysis results.
- **Additional Analysis**: Include demographic analysis (age, gender, education level).

### 2. Preprocessing.m
**Purpose**: To clean and prepare the EEG data for further analysis.

**Details**:
- **Cleaning**: Apply filters and visually inspect artifacts.
- **Data Preparation**: Format the data for subsequent analysis steps.

### 3. PowerSpectralDensity.m
**Purpose**: To calculate and normalize the Power Spectral Density (PSD).

**Details**:
- **PSD Calculation**: Compute the PSD of the EEG data.
- **Normalization**: Normalize the PSD values for consistency.

### 4. DataAllocation.m
**Purpose**: To allocate data into two groups (COVID or Non-COVID).

**Details**:
- **Group Allocation**: Sort the data into COVID and Non-COVID groups for comparison.

### 5. SpectrumAndStats.m
**Purpose**: To visualize the spectrum and perform statistical analysis.

**Details**:
- **Spectrum**: Generate spectrum plots.
- **Statistical Analysis**: Conduct statistical tests on the spectral data.
- **Visualization**: Create bar plots to visualize the statistical results.

### 6. AsymmetryAndStats.m
**Purpose**: To calculate and analyze asymmetry between electrode pairs.

**Details**:
- **Asymmetry Calculation**: Calculate the asymmetry for each pair of electrodes.
- **Statistical Analysis**: Conduct statistical tests on the asymmetry data.
- **Visualization**: Create horizontal bar plots to visualize the results.

### 7. ConnectivityAndStats.m
**Purpose**: To calculate and analyze connectivity between electrodes.

**Details**:
- **Connectivity Calculation**: Calculate the connectivity between all electrodes.
- **Statistical Analysis**: Conduct statistical tests on the connectivity data.
- **Visualization**: Create a connectivity matrix (heatmap) to visualize the connectivity values between electrodes.
