function all_raw_emg_data = load_all_participants_emg(participant_ids, condition_id, data_folder)
    num_activities = 8; % Total number of activity files
    num_participants = length(participant_ids);
    
    % Preallocate storage
    all_raw_emg_data = cell(num_participants, num_activities);

    % Loop through all participants
    for p = 1:num_participants
        subject_id = participant_ids{p};  % Get the participant ID
        subject_path = fullfile(data_folder, subject_id, condition_id);

        % Loop through all 8 activities for this participant
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

                all_raw_emg_data{p, act} = [BB, PD, AD, MD, TL, WF, WE, BR];
            else
                warning('File %s not found for Participant %s. Skipping...', filename, subject_id);
            end
        end
    end
end
