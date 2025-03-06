% % % % %% NNMF analysis of participant every participants data from sEMG channels 1-8 %%
% % % % %% HRELab
% % % % %% Chad Berghoff
% % 
% % clear; clc;
% % 
% % % Define root data folder
% % data_folder = 'ICCOR_2025_sEMG_Data';
% % 
% % % Select subject and condition
% % subject_id = '13';  % Change this to analyze different subjects
% % condition_id = '01'; % Change to '02' for condition #2
% % num_synergies = 4;   % Number of synergies to extract
% % show_distribution = true; % Toggle on/off the histogram plot
% % 
% % % Load the data and perform NNMF with randomized "X" matrix
% % [H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies);
% % 
% % % Plot the synergy bar chart results with labeled bars and RMS Resid
% % plot_synergy_results(H_matrices, subject_id, condition_id, activity_names);
% % 
% % % Plot the histogram distribution of raw EMG signals (if enabled)
% % if show_distribution
% %     plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names);
% % end
% % 
% % 

% clear; clc;
% 
% % Define root data folder
% data_folder = 'ICCOR_2025_sEMG_Data';
% 
% % Select subject and condition
% subject_id = '13';  % Change this to analyze different subjects
% condition_id = '01'; % Change to '02' for condition #2
% num_synergies = 4;   % Number of synergies to extract
% show_distribution = true; % Toggle histogram plot
% show_3D_histogram = true; % Toggle 3D histogram comparison
% 
% % Load the data and perform NNMF with randomized "X" matrix
% [H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies);
% 
% % Plot the synergy bar chart results with labeled bars and RMS Resid
% plot_synergy_results(H_matrices, subject_id, condition_id, activity_names);
% 
% % Plot the histogram distribution of raw EMG signals (if enabled)
% if show_distribution
%     plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names);
% end
% 
% % Generate 3D histogram comparing Activity 1 for multiple participants (if enabled)
% if show_3D_histogram
%     participant_ids = {'01', '02', '03', '04'}; % Define which participants to compare
%     plot_3D_histogram(raw_emg_data, subject_id, condition_id, participant_ids);
% end

% clear; clc;
% 
% % Define root data folder
% data_folder = 'ICCOR_2025_sEMG_Data';
% 
% % Select subject and condition
% subject_id = '13';  % Change this to analyze different subjects
% condition_id = '01'; % Change to '02' for condition #2
% num_synergies = 4;   % Number of synergies to extract
% show_distribution = true; % Toggle histogram plot
% show_3D_histogram = true; % Toggle 3D histogram comparison
% 
% % Load the data and perform NNMF with randomized "X" matrix
% [H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies);
% 
% % Plot the synergy bar chart results with labeled bars and RMS Resid
% plot_synergy_results(H_matrices, subject_id, condition_id, activity_names);
% 
% % Plot the histogram distribution of raw EMG signals (if enabled)
% if show_distribution
%     plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names);
% end
% 
% % Generate 3D histogram comparing Activity 1 for multiple participants (if enabled)
% if show_3D_histogram
%     participant_ids = {'01', '02', '03', '04'}; % Define which participants to compare
%     plot_3D_histogram(raw_emg_data, subject_id, condition_id, participant_ids);
% end

clear; clc;

% Define root data folder
data_folder = 'ICCOR_2025_sEMG_Data';

% Select subject and condition
subject_id = '13';  % Change this to analyze different subjects
condition_id = '02'; % Change to '02' for condition #2
num_synergies = 4;   % Number of synergies to extract
show_distribution = true; % Toggle histogram plot
show_3D_histogram = true; % Toggle 3D histogram comparison
show_3D_surface = false;   % Toggle 3D surface contour plot

% Load the data and perform NNMF with randomized "X" matrix
[H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies);

% Plot the synergy bar chart results with labeled bars and RMS Resid
plot_synergy_results(H_matrices, subject_id, condition_id, activity_names);

% Plot the histogram distribution of raw EMG signals (if enabled)
if show_distribution
    plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names);
end

% Generate 3D histogram comparing Activity 1 for multiple participants (if enabled)
if show_3D_histogram
    participant_ids = {'15', '16', '17', '18', '19', '20', '21', '22'}; % Define which participants to compare
    plot_3D_histogram(raw_emg_data, subject_id, condition_id, participant_ids);
end

% Generate 3D surface contour plot comparing Activity 1 across participants (if enabled)
if show_3D_surface
    participant_ids = {'15', '16', '17', '18', '19', '20', '21', '22'}; % Define which participants to compare
    plot_3D_surface_contour(raw_emg_data, subject_id, condition_id, participant_ids);
end


