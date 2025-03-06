% function plot_3D_surface_contour(all_raw_emg_data, condition_id, valid_participants)
%     % Generates a 3D surface contour plot comparing EMG signal amplitude distributions
%     % for Activity 1, Condition 1 across multiple participants, with individual muscle contributions.
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
%     valid_data = all_raw_emg_data(valid_indices);  
% 
%     num_valid_participants = length(valid_participants);
% 
%     % Ensure we have data to plot
%     if num_valid_participants == 0
%         warning('No valid EMG data found for any participants.');
%         return;
%     end
% 
%     % Flatten all EMG data into one array to get global min/max values
%     all_emg_values = cellfun(@(x) x(:), valid_data, 'UniformOutput', false);
%     all_emg_values = vertcat(all_emg_values{:}); % Convert to a single matrix
% 
%     % ✅ Fix X-Axis Scaling
%     X = linspace(0, 1, num_bins);  % ✅ Force X-axis to stay within [0,1]
%     Y = 1:num_valid_participants; % Correct Y-axis for only valid participants
%     Z = zeros(num_valid_participants, num_bins, num_muscles); % Store density values
% 
%     % Initialize figure
%     figure;
%     hold on;
% 
%     % Loop through only valid participants and muscles
%     for p_idx = 1:num_valid_participants
%         p = valid_indices(p_idx);
%         emg_data = valid_data{p};  
% 
%         for m = 1:num_muscles
%             muscle_data = emg_data(:, m); % Extract muscle data
% 
%             % Compute probability density
%             density_values = ksdensity(muscle_data, X);
%             Z(p_idx, :, m) = density_values;
%         end
%     end
% 
%     % ✅ Plot the 3D surface for each muscle with correct colors
%     for m = 1:num_muscles
%         surf(X, Y, squeeze(Z(:, :, m)), 'FaceColor', muscle_colors(m, :), 'FaceAlpha', 0.7, 'EdgeColor', 'none');
%     end
% 
%     hold off;
%     xlabel('EMG Signal Amplitude');
%     ylabel('Participants');
%     zlabel('Probability Density');
%     title(sprintf('3D Surface Contour: Activity 1 - Condition %s Across Participants', condition_id), 'FontSize', 14);
% 
%     % Set correct participant labels
%     yticks(1:num_valid_participants);
%     yticklabels(valid_participants); 
% 
%     grid on;
%     legend(muscle_labels, 'Location', 'northeastoutside');
%     view(-30, 40); % Adjust viewing angle
% end

function plot_3D_surface_contour(all_raw_emg_data, condition_id, activity_id, valid_participants)
    % Generates a 3D surface contour plot comparing EMG signal amplitude distributions
    % for a specified activity and condition across multiple participants.

    num_bins = 50; % Number of bins for histogram
    num_muscles = 8; % Number of muscle channels
    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

    % ✅ Get muscle colors from central function
    muscle_colors = get_muscle_colors();

    % Identify valid participants (only those with data)
    valid_indices = find(~cellfun(@isempty, all_raw_emg_data(:, activity_id)));  
    valid_data = all_raw_emg_data(valid_indices, activity_id);  

    num_valid_participants = length(valid_participants);
    
    % Ensure we have data to plot
    if num_valid_participants == 0
        warning('No valid EMG data found for any participants.');
        return;
    end

    % Flatten all EMG data into one array to get global min/max values
    all_emg_values = cellfun(@(x) x(:), valid_data, 'UniformOutput', false);
    all_emg_values = vertcat(all_emg_values{:});

    % ✅ Restore Dynamic X-Axis Scaling with Limit at 1
    X_min = min(all_emg_values);
    X_max = min(max(all_emg_values), 1);
    X = linspace(X_min, X_max, num_bins);

    Y = 1:num_valid_participants; % Correct Y-axis for only valid participants
    Z = zeros(num_valid_participants, num_bins, num_muscles); % Store density values

    % Initialize figure
    figure;
    hold on;

    % Loop through only valid participants and muscles
    for p_idx = 1:num_valid_participants
        p = valid_indices(p_idx);
        emg_data = valid_data{p};  

        for m = 1:num_muscles
            muscle_data = emg_data(:, m); % Extract muscle data

            % Compute probability density
            density_values = ksdensity(muscle_data, X);
            Z(p_idx, :, m) = density_values;
        end
    end

    % ✅ Ensure Z-Axis Scaling is Consistent
    Z_max = max(Z(:));  
    zlim([0, Z_max]);  

    % ✅ Plot the 3D surface for each muscle with correct colors
    for m = 1:num_muscles
        surf(X, Y, squeeze(Z(:, :, m)), 'FaceColor', muscle_colors(m, :), 'FaceAlpha', 0.7, 'EdgeColor', 'none');
    end

    hold off;
    xlabel('EMG Signal Amplitude');
    ylabel('Participants');
    zlabel('Probability Density');
    title(sprintf('3D Surface Contour: Activity %d - Condition %s Across Participants', activity_id, condition_id), 'FontSize', 14);
    
    yticks(1:num_valid_participants);
    yticklabels(valid_participants); 
    
    grid on;
    legend(muscle_labels, 'Location', 'northeastoutside');
    view(-30, 40);
end
