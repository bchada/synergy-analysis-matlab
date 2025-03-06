function plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names)
    num_activities = length(raw_emg_data);

    if num_activities == 0
        disp('No activity data to plot.');
        return;
    end

    muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};

    figure;
    tiledlayout(2,4, 'TileSpacing', 'compact', 'Padding', 'compact'); % 2x4 grid

    for act = 1:num_activities
        nexttile;
        hold on;

        for m = 1:length(muscle_labels)
            %histogram(raw_emg_data{act}(:, m), 'Normalization', 'probability', 'BinWidth', 0.01, 'DisplayStyle', 'stairs');
            histogram(raw_emg_data{act}(:, m), 'Normalization', 'probability', 'BinMethod', 'scott', 'DisplayStyle', 'stairs');
        end

        hold off;
        xlabel('EMG Signal Amplitude');
        ylabel('Probability');
        title(sprintf('%s - %s', subject_id, activity_names{act}), 'FontSize', 12);
        legend(muscle_labels, 'Location', 'northeast', 'FontSize', 7);
        grid on;
    end
end

% % function plot_time_series_distribution(raw_emg_data, subject_id, condition_id, activity_names)
% %     % Plots the time-series distribution (histograms) for each activity.
% %     % Saves the distribution to avoid redundant computations.
% % 
% %     % Define folder for saved distributions
% %     save_path = fullfile(pwd, 'Saved_TimeSeries_Distributions');
% %     if ~exist(save_path, 'dir')
% %         mkdir(save_path); % Create folder if it doesn't exist
% %     end
% % 
% %     % Define save filename
% %     save_file = fullfile(save_path, sprintf('TimeSeries_Subject%s_Condition%s.mat', subject_id, condition_id));
% % 
% %     % Check if saved data exists
% %     if exist(save_file, 'file')
% %         disp(['Loading saved time-series distribution for Subject ' subject_id ' Condition ' condition_id '...']);
% %         load(save_file, 'histogram_data', 'num_activities');
% %     else
% %         disp(['Computing time-series distribution for Subject ' subject_id ' Condition ' condition_id '...']);
% % 
% %         num_activities = length(raw_emg_data); % Define num_activities dynamically
% %         num_muscles = 8; % 8 muscle channels
% %         muscle_labels = {'BB', 'PD', 'AD', 'MD', 'TL', 'WF', 'WE', 'BR'};
% % 
% %         % Define distinct colors for each muscle (Ensuring clarity)
% %         muscle_colors = [...
% %             0 0 1;        % BB - Blue
% %             0 0.5 0;      % PD - Dark Green
% %             1 0 0;        % AD - Red
% %             0.75 0.75 0;  % MD - Yellow
% %             1 0.5 0;      % TL - Orange
% %             0.6 0.2 0.8;  % WF - Purple
% %             0 1 1;        % WE - Cyan
% %             1 0 1];       % BR - Magenta
% % 
% %         histogram_data = cell(num_activities, 1);
% % 
% %         % Compute histograms for each muscle in each activity
% %         for act = 1:num_activities
% %             histograms = cell(num_muscles, 1);
% %             for m = 1:num_muscles
% %                 [counts, edges] = histcounts(raw_emg_data{act}(:, m), 50, 'Normalization', 'probability');
% %                 histograms{m} = struct('counts', counts, 'edges', edges);
% %             end
% %             histogram_data{act} = histograms;
% %         end
% % 
% %         % Save computed histograms & num_activities
% %         save(save_file, 'histogram_data', 'num_activities');
% %         disp(['Saved time-series distribution for Subject ' subject_id ' Condition ' condition_id '.']);
% %     end
% % 
% %     % Plot the saved distributions
% %     figure;
% %     tiledlayout(2, 4, 'TileSpacing', 'compact', 'Padding', 'compact');
% % 
% %     for act = 1:num_activities
% %         nexttile;
% %         hold on;
% % 
% %         % Retrieve histogram data and plot each muscle using **only colored outlines**
% %         for m = 1:num_muscles
% %             hist_data = histogram_data{act}{m};
% %             bar(hist_data.edges(1:end-1), hist_data.counts, 'EdgeColor', muscle_colors(m, :), ...
% %                 'FaceColor', 'none', 'LineWidth', 0.75); % Outlined bars, no fill
% %         end
% % 
% %         hold off;
% %         xlabel('EMG Signal Amplitude');
% %         ylabel('Probability');
% %         title(sprintf('%s - %s', subject_id, activity_names{act}), 'FontSize', 12);
% %         legend(muscle_labels, 'Location', 'northeast', 'FontSize', 7);
% %         grid on;
% %     end
% % end
