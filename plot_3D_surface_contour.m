function plot_3D_surface_contour(raw_emg_data, subject_id, condition_id, participant_ids)
    % Generates a 3D surface contour plot comparing EMG signal amplitude distributions
    % for Activity 1, Condition 1 across multiple participants, with individual muscle contributions.
    
    num_bins = 50; % Number of bins for histogram
    num_muscles = 8; % Number of muscle channels
    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

    % Define colors for each muscle
    muscle_colors = lines(num_muscles);

    % Identify valid participants (only those with data)
    valid_indices = find(~cellfun(@isempty, raw_emg_data));
    valid_participants = participant_ids(valid_indices); % Extract actual labels
    num_valid_participants = length(valid_indices);

    % Ensure we have data to plot
    if num_valid_participants == 0
        warning('No valid EMG data found for any participants.');
        return;
    end

    % Flatten all EMG data into one array to get global min/max values
    valid_data = raw_emg_data(valid_indices); 
    all_emg_values = cellfun(@(x) x(:), valid_data, 'UniformOutput', false);
    all_emg_values = vertcat(all_emg_values{:}); % Convert to a single matrix

    % Ensure X has valid min/max range
    X = linspace(min(all_emg_values), max(all_emg_values), num_bins);
    Y = 1:num_valid_participants; % Correct Y-axis for only valid participants
    Z = zeros(num_valid_participants, num_bins, num_muscles); % Store density values

    % Initialize figure
    figure;
    hold on;

    % Loop through only valid participants and muscles
    for p_idx = 1:num_valid_participants
        p = valid_indices(p_idx);
        emg_data = raw_emg_data{p};

        for m = 1:num_muscles
            muscle_data = emg_data(:, m); % Extract muscle data

            % Compute probability density
            density_values = ksdensity(muscle_data, X);
            Z(p_idx, :, m) = density_values; % No normalization
        end
    end

    % Plot the 3D surface for each muscle using `surf()`
    for m = 1:num_muscles
        surf(X, Y, squeeze(Z(:, :, m)), 'FaceColor', muscle_colors(m, :), 'FaceAlpha', 0.7, 'EdgeColor', 'none');
    end

    hold off;
    xlabel('EMG Signal Amplitude');
    ylabel('Participants');
    zlabel('Probability Density');
    title(sprintf('3D Surface Contour: Activity 1 - Condition %s Across Participants', condition_id), 'FontSize', 14);
    
    % Set correct participant labels
    yticks(1:num_valid_participants);
    yticklabels(valid_participants); 
    
    grid on;
    legend(muscle_labels, 'Location', 'northeastoutside');
    view(-30, 40); % Adjust viewing angle
end
