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

% Automatically detect all participant IDs
participant_folders = dir(fullfile(data_folder, '*'));
participant_ids = {participant_folders([participant_folders.isdir]).name};

% Remove irrelevant folders (e.g., ".", "..")
participant_ids = participant_ids(~ismember(participant_ids, {'.', '..'}));

disp('Detected Participants:');
disp(participant_ids);

% Select **only one subject for NNMF**
subject_id = '21';  % Change this to analyze different subjects
condition_id = '02'; % Change as needed
num_synergies = 4;   % Number of synergies to extract

% Load **only the selected subject's data** for NNMF
[H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies);

%  Load **ALL participants' raw EMG data** before 3D plots
all_raw_emg_data = load_all_participants_emg(participant_ids, condition_id, data_folder);

%  Debug Step: Detect how many participants have data for 3D plotting
disp('--- DEBUG: Checking Number of Valid Participants ---');

%  **FIX: Only use the first activity (column 1) to detect valid participants**
valid_indices = find(~cellfun(@isempty, all_raw_emg_data(:, 1)));  
valid_participants = participant_ids(valid_indices);  % Extract valid participant labels
num_valid_participants = length(valid_indices);

disp(['Total Valid Participants Detected: ', num2str(num_valid_participants)]);
disp('Participant IDs with Data:');
disp(valid_participants);
disp('---------------------------------------------------');

% Define `show_distribution` to prevent errors
show_distribution = true;
show_3D_histogram = true;
show_3D_surface = true;

% Plot the NNMF Synergy Bar Chart for **only the selected subject**
plot_synergy_results(H_matrices, subject_id, condition_id, activity_names);

% Plot the histogram distribution of raw EMG signals (if enabled)
if show_distribution
    plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names);
end

% User-specified activity and condition
activity_id = 3;  % Set the activity number you want to analyze
condition_id = '02'; % Set condition number

% Generate 3D histogram comparing the selected activity and condition across participants
if show_3D_histogram
    plot_3D_histogram(all_raw_emg_data, condition_id, activity_id, valid_participants);
end

% Generate 3D surface contour plot comparing the selected activity and condition across participants
if show_3D_surface
    plot_3D_surface_contour(all_raw_emg_data, condition_id, activity_id, valid_participants);
end


% % %  Generate 3D histogram comparing Activity 1 for multiple participants
% % if show_3D_histogram
% %     plot_3D_histogram(all_raw_emg_data, condition_id, valid_participants);
% % end
% % 
% % %  Generate 3D surface contour plot comparing Activity 1 across participants
% % if show_3D_surface
% %     plot_3D_surface_contour(all_raw_emg_data, condition_id, valid_participants);
% % end
