% function plot_3D_histogram(all_raw_emg_data, condition_id, valid_participants)
%     % Generates a 3D histogram comparing EMG signal amplitude distributions
%     % for Activity 1, Condition 1 across multiple participants.
% 
%     num_bins = 50; % Number of bins for histogram
%     num_muscles = 8; % Number of muscle channels
%     muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};
% 
%     % ✅ Get muscle colors from central function
%     muscle_colors = get_muscle_colors();
% 
%     % Identify valid participants (only those with data)
%     valid_indices = find(~cellfun(@isempty, all_raw_emg_data));  
%     num_valid_participants = length(valid_participants);
% 
%     % Ensure we have data to plot
%     if num_valid_participants == 0
%         warning('No valid EMG data found for any participants.');
%         return;
%     end
% 
%     % Initialize figure
%     figure;
%     hold on;
% 
%     % Loop through valid participants and plot histograms for each muscle
%     for p_idx = 1:num_valid_participants
%         p = valid_indices(p_idx);
%         emg_data = all_raw_emg_data{p, 1};  % Extract first activity's data
% 
%         for m = 1:num_muscles
%             muscle_data = emg_data(:, m); % Extract muscle data
% 
%             % Compute histogram
%             [counts, edges] = histcounts(muscle_data, num_bins, 'Normalization', 'probability');
%             bin_centers = edges(1:end-1) + diff(edges) / 2; % Compute bin centers
% 
%             % Offset Y-axis to align participant IDs
%             y_shift = p_idx;  
% 
%             % Plot 3D histogram using `plot3()`
%             plot3(bin_centers, ones(size(bin_centers)) * y_shift, counts, ...
%                 'Color', muscle_colors(m, :), 'LineWidth', 2);
%         end
%     end
% 
%     hold off;
%     xlabel('EMG Signal Amplitude');
%     ylabel('Participants');
%     zlabel('Probability Density');
%     title(sprintf('3D Histogram: Activity 1 - Condition %s Across Participants', condition_id), 'FontSize', 14);
% 
%     % Set correct participant labels
%     yticks(1:num_valid_participants);
%     yticklabels(valid_participants); 
% 
%     grid on;
%     legend(muscle_labels, 'Location', 'northeastoutside');
%     view(-30, 30); % Adjust viewing angle
% end

function plot_3D_histogram(all_raw_emg_data, condition_id, activity_id, valid_participants)
    % Generates a 3D histogram comparing EMG signal amplitude distributions
    % for a specified activity and condition across multiple participants.

    num_bins = 50; % Number of bins for histogram
    num_muscles = 8; % Number of muscle channels
    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

    % ✅ Get muscle colors from central function
    muscle_colors = get_muscle_colors();

    % Identify valid participants (only those with data)
    valid_indices = find(~cellfun(@isempty, all_raw_emg_data(:, activity_id)));  
    num_valid_participants = length(valid_participants);

    % Ensure we have data to plot
    if num_valid_participants == 0
        warning('No valid EMG data found for any participants.');
        return;
    end

    % Flatten all EMG data to determine proper X-axis range
    all_emg_values = cellfun(@(x) x(:), all_raw_emg_data(valid_indices, activity_id), 'UniformOutput', false);
    all_emg_values = vertcat(all_emg_values{:});

    % ✅ Restore Dynamic X-Axis Scaling with Limit at 1
    X_min = min(all_emg_values);
    X_max = min(max(all_emg_values), 1);
    X = linspace(X_min, X_max, num_bins);

    % Initialize figure
    figure;
    hold on;

    % Loop through valid participants and plot histograms for each muscle
    for p_idx = 1:num_valid_participants
        p = valid_indices(p_idx);
        emg_data = all_raw_emg_data{p, activity_id};  % ✅ Extract the specified activity's data

        for m = 1:num_muscles
            muscle_data = emg_data(:, m); % Extract muscle data

            % Compute histogram
            [counts, edges] = histcounts(muscle_data, num_bins, 'Normalization', 'probability');
            bin_centers = edges(1:end-1) + diff(edges) / 2;

            % Offset Y-axis to align participant IDs
            y_shift = p_idx;  

            % Plot 3D histogram using `plot3()`
            plot3(bin_centers, ones(size(bin_centers)) * y_shift, counts, ...
                'Color', muscle_colors(m, :), 'LineWidth', 2);
        end
    end

    hold off;
    xlabel('EMG Signal Amplitude');
    ylabel('Participants');
    zlabel('Probability Density');
    title(sprintf('3D Histogram: Activity %d - Condition %s Across Participants', activity_id, condition_id), 'FontSize', 14);
    
    yticks(1:num_valid_participants);
    yticklabels(valid_participants); 
    
    grid on;
    legend(muscle_labels, 'Location', 'northeastoutside');
    view(-30, 30);
end
