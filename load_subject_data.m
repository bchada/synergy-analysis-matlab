function [H_matrices, rms_resid_values, activity_names, raw_emg_data] = load_subject_data(subject_id, condition_id, data_folder, num_synergies)
    num_activities = 8; % Total number of activity files
    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

    % Path to subject's data folder
    subject_path = fullfile(data_folder, subject_id, condition_id);

    % Preallocate storage for single subject
    H_matrices = cell(num_activities, 1);
    rms_resid_values = zeros(num_activities, 1);
    activity_names = cell(num_activities, 1);
    raw_emg_data = cell(num_activities, 1);

    % Loop through all 8 activities for the selected subject
    for act = 1:num_activities
        filename = fullfile(subject_path, sprintf('processed-emg-%02d.csv', act));

        if exist(filename, 'file')
            temp_data = readmatrix(filename);
            temp_data(1, :) = []; % Remove first row (headers)

            % Extract muscle channels
            BB = temp_data(:, 5);  PD = temp_data(:, 6);
            AD = temp_data(:, 7);  MD = temp_data(:, 8);
            TL = temp_data(:, 9);  WF = temp_data(:, 10);
            WE = temp_data(:, 11); BR = temp_data(:, 12);

            emg_data = [BB, PD, AD, MD, TL, WF, WE, BR];
            raw_emg_data{act} = emg_data; % Store raw data for this subject

            % Generate random initialization matrix "X"
            X = rand(size(emg_data, 1), num_synergies);

            % Perform NNMF with "X" initialization
            opt = statset('MaxIter', 10, 'Display', 'final');
            [W0, H0] = nnmf(emg_data, num_synergies, 'w0', X, 'replicates', 5, 'options', opt, 'algorithm', 'mult');
            opt = statset('Maxiter', 1000, 'Display', 'final');
            [W, H] = nnmf(emg_data, num_synergies, 'w0', W0, 'h0', H0, 'options', opt, 'algorithm', 'als');

            % Compute RMS Residual
            reconstructed = W * H;
            residual = emg_data - reconstructed;
            rms_resid_values(act) = sqrt(mean(residual(:).^2));

            % Store NNMF results
            H_matrices{act} = H;
            activity_names{act} = sprintf('Activity %d', act);
        else
            warning('File %s not found. Skipping...', filename);
        end
    end
end
